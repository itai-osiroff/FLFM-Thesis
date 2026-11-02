function [output, normalized, diagnostics] = evaluate(image, stack, range, scale, processingPolicy)
%EVALUATE Deterministic ordered filters, in native intensity coordinates.
if nargin<4, scale=1; end
if nargin<5, processingPolicy='legacy-clamp'; end
processingPolicy=validatestring(processingPolicy,{'preserve','legacy-clamp'});
preserve=strcmp(processingPolicy,'preserve');
validateattributes(range,{'numeric'},{'vector','numel',2,'finite','increasing'});
validateattributes(scale,{'numeric'},{'scalar','positive','finite'});
normalized=(double(image)-range(1))/(range(2)-range(1));
diagnostics=stats(normalized,range);
diagnostics.processingPolicy=processingPolicy; diagnostics.referenceRange=range;
diagnostics.stages=struct('id',{},'type',{},'index',{},'min',{},'max',{},'belowCount',{},'aboveCount',{},'clippedLowCount',{},'clippedHighCount',{},'thresholdAffectedCount',{},'totalCount',{});
if any(~isfinite(normalized(:))), error('captureedit:NonfiniteResult','Source normalization produced nonfinite values.'); end
if isempty(stack) || ~any([stack.enabled])
    output=image; return;
end
definitions=captureedit.catalog();
for k=1:numel(stack)
    node=stack(k); if ~node.enabled, continue; end
    index=find(strcmp({definitions.type},node.type),1);
    if isempty(index), error('captureedit:InvalidFilter','Unknown filter: %s',node.type); end
    p=node.params; knobs=definitions(index).knobs;
    for j=1:numel(knobs)
        name=knobs(j).name;
        if ~isfield(p,name) || ~isnumeric(p.(name)) || ~isscalar(p.(name)) || ...
                ~isfinite(p.(name)) || p.(name)<knobs(j).min || p.(name)>knobs(j).max
            error('captureedit:InvalidParameter','Invalid %s parameter for %s.',name,node.type);
        end
    end
    x=normalized; before=x; clippedLow=0; clippedHigh=0; affected=0;
    switch node.type
        case 'brightness', x=x*p.gain+p.offset;
        case 'gamma'
            if preserve
                if p.gamma~=1 && any(x(:)<0), domainError(k,node,'Gamma requires nonnegative input.'); end
                if p.gamma~=1, x=x.^p.gamma; end
            else, x=max(x,0).^p.gamma; end
        case 'clip'
            if p.upper<=p.lower, error('captureedit:InvalidParameter','Clip upper bound must exceed lower bound.'); end
            clippedLow=nnz(x<p.lower); clippedHigh=nnz(x>p.upper);
            x=min(max(x,p.lower),p.upper);
        case 'window'
            if p.white<=p.black, error('captureedit:InvalidParameter','White must exceed black.'); end
            x=(x-p.black)/(p.white-p.black);
        case 'threshold'
            if ~ismember(p.binary,[0 1]), error('captureedit:InvalidParameter','Binary mode must be 0 or 1.'); end
            if p.binary, x=double(x>=p.cutoff); else, x(x<p.cutoff)=0; end
            affected=nnz(x~=before);
        case 'gaussian'
            if p.size~=0, requireOdd(p.size); end
            sigma=max(.01,p.sigma*scale);
            if p.size==0, n=2*ceil(2*sigma)+1; else, n=scaledOdd(p.size,scale); end
            x=imgaussfilt(x,sigma,'FilterSize',n,'Padding','replicate');
        case 'mean'
            requireOdd(p.size); n=scaledOdd(p.size,scale);
            x=imfilter(x,ones(n)/(n*n),'replicate');
        case 'median'
            requireOdd(p.size); n=scaledOdd(p.size,scale);
            padded=padarray(x,[floor(n/2) floor(n/2)],'replicate');
            filtered=medfilt2(padded,[n n]);
            x=filtered(floor(n/2)+(1:size(x,1)),floor(n/2)+(1:size(x,2)));
        case 'unsharp'
            x=imsharpen(x,'Radius',max(.01,p.radius*scale),'Amount',p.amount,'Threshold',p.threshold);
        case 'laplacian'
            x=x-p.amount*imfilter(x,fspecial('laplacian',p.alpha),'replicate');
        case 'background'
            if p.radius~=round(p.radius), error('captureedit:InvalidParameter','Background radius must be an integer.'); end
            radius=max(1,round(p.radius*scale));
            padded=padarray(x,[radius radius],'replicate');
            background=imopen(padded,strel('disk',radius,0));
            background=background(radius+(1:size(x,1)),radius+(1:size(x,2)));
            x=x-p.strength*background;
        case 'clahe'
            if p.tiles~=round(p.tiles), error('captureedit:InvalidParameter','CLAHE tile count must be an integer.'); end
            if min(size(x))>=4 && p.amount>0
                if preserve && any(x(:)<0 | x(:)>1), domainError(k,node,'CLAHE requires input within [0,1].'); end
                tiles=min([p.tiles p.tiles],floor(size(x)/2));
                enhanced=adapthisteq(min(max(x,0),1),'NumTiles',tiles, ...
                    'ClipLimit',p.clipLimit,'NBins',256,'Distribution','uniform','Range','full');
                x=(1-p.amount)*x+p.amount*enhanced;
            end
        case 'bilateral'
            sigma=max(.01,p.spatialSigma*scale); n=2*ceil(2*sigma)+1;
            if any(size(x)<=n)
                % MATLAB requires both dimensions to exceed its neighborhood.
                % Replicated padding keeps that restriction out of the editor.
                padded=padarray(x,[n n],'replicate');
                filtered=imbilatfilt(padded,p.intensitySigma^2,sigma,'Padding','replicate');
                x=filtered(n+(1:size(x,1)),n+(1:size(x,2)));
            else
                x=imbilatfilt(x,p.intensitySigma^2,sigma,'Padding','replicate');
            end
    end
    if any(~isfinite(x(:)))
        error('captureedit:NonfiniteResult','Filter %d (%s, id %s) produced nonfinite values.',k,node.type,node.id);
    end
    entry=stats(x,range);
    if ~preserve
        clippedLow=clippedLow+nnz(x<0); clippedHigh=clippedHigh+nnz(x>1);
        normalized=min(max(x,0),1);
    else, normalized=x; end
    diagnostics.stages(end+1)=struct('id',node.id,'type',node.type,'index',k, ...
        'min',entry.min,'max',entry.max,'belowCount',entry.belowCount,'aboveCount',entry.aboveCount, ...
        'clippedLowCount',clippedLow,'clippedHighCount',clippedHigh, ...
        'thresholdAffectedCount',affected,'totalCount',numel(x));
end
native=normalized*(range(2)-range(1))+range(1);
if any(~isfinite(native(:))), error('captureedit:NonfiniteResult','Mapping processed values to native coordinates produced nonfinite values.'); end
final=stats(normalized,range);
for name={'min','max','belowCount','aboveCount'}, diagnostics.(name{1})=final.(name{1}); end
if preserve, output=native;
else
    if isinteger(image), native=round(native); end
    output=cast(native,'like',image);
end
end
function requireOdd(n)
if n~=round(n) || mod(n,2)~=1
    error('captureedit:InvalidParameter','Kernel size must be a positive odd integer (Gaussian zero means automatic).');
end
end
function n=scaledOdd(n,scale)
n=max(1,2*round((n-1)*scale/2)+1);
end

function s=stats(x,range)
s=struct('min',min(x(:))*diff(range)+range(1),'max',max(x(:))*diff(range)+range(1), ...
    'belowCount',nnz(x<0),'aboveCount',nnz(x>1),'totalCount',numel(x));
end
function domainError(index,node,message)
error('captureedit:FilterDomain','Filter %d (%s, id %s): %s Adjust the preceding range or insert Clip range explicitly.',index,node.type,node.id,message);
end
