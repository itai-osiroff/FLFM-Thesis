function [output, normalized] = evaluate(image, stack, range, scale)
%EVALUATE Deterministic ordered filters, in native intensity coordinates.
if nargin<4, scale=1; end
validateattributes(range,{'numeric'},{'vector','numel',2,'finite','increasing'});
validateattributes(scale,{'numeric'},{'scalar','positive','finite'});
normalized=(double(image)-range(1))/(range(2)-range(1));
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
    x=normalized;
    switch node.type
        case 'brightness', x=x*p.gain+p.offset;
        case 'gamma', x=max(x,0).^p.gamma;
        case 'window'
            if p.white<=p.black, error('captureedit:InvalidParameter','White must exceed black.'); end
            x=(x-p.black)/(p.white-p.black);
        case 'threshold'
            if ~ismember(p.binary,[0 1]), error('captureedit:InvalidParameter','Binary mode must be 0 or 1.'); end
            if p.binary, x=double(x>=p.cutoff); else, x(x<p.cutoff)=0; end
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
    end
    normalized=min(max(x,0),1);
end
native=normalized*(range(2)-range(1))+range(1);
if isinteger(image), native=round(native); end
output=cast(native,'like',image);
end
function requireOdd(n)
if n~=round(n) || mod(n,2)~=1
    error('captureedit:InvalidParameter','Kernel size must be a positive odd integer (Gaussian zero means automatic).');
end
end
function n=scaledOdd(n,scale)
n=max(1,2*round((n-1)*scale/2)+1);
end
