function filters = catalog()
%CATALOG Supported native-image filters and their editable parameters.
filters = struct('type', {}, 'label', {}, 'params', {}, 'knobs', {});
add('brightness','Brightness / contrast',{'gain','offset'},[1 0],[0 -1],[5 1],[.01 .01]);
add('gamma','Gamma',{'gamma'},1,.1,5,.01);
add('window','Intensity window',{'black','white'},[0 1],[0 0],[1 1],[.01 .01]);
add('clip','Clip range',{'lower','upper'},[0 1],[0 0],[1 1],[.01 .01]);
add('threshold','Threshold',{'cutoff','binary'},[.1 0],[0 0],[1 1],[.01 1]);
add('gaussian','Gaussian blur',{'sigma','size'},[1 0],[.1 0],[20 101],[.1 1]);
add('mean','Mean blur',{'size'},3,1,101,2);
add('median','Median filter',{'size'},3,1,101,2);
add('unsharp','Unsharp mask',{'radius','amount','threshold'},[1 .8 0],[.1 0 0],[20 5 1],[.1 .05 .01]);
add('laplacian','Laplacian sharpening',{'alpha','amount'},[.2 .5],[0 0],[1 5],[.01 .05]);
add('background','Background subtraction',{'radius','strength'},[25 1],[1 0],[250 1],[1 .01]);
add('clahe','Local contrast (CLAHE)',{'tiles','clipLimit','amount'},[8 .01 1],[2 0 0],[32 1 1],[1 .001 .01]);
add('bilateral','Edge-preserving denoise',{'spatialSigma','intensitySigma'},[2 .05],[.1 .001],[20 .5],[.1 .001]);
for index=1:numel(filters)
    type=filters(index).type;
    if ismember(type,{'brightness','gamma','window','clip','threshold'}), category='Tone';
    elseif ismember(type,{'gaussian','mean','median','bilateral'}), category='Denoise';
    elseif ismember(type,{'unsharp','laplacian'}), category='Sharpen';
    else, category='Advanced'; end
    filters(index).category=category;
    filters(index).description=[filters(index).label ' affects exported pixels. Spatial values use native pixels.'];
    if strcmp(type,'window'), filters(index).description='Rescale the selected intensity interval. Preservation mode retains tails; use Clip range to remove them explicitly.';
    elseif strcmp(type,'clip'), filters(index).description='Deliberately clamp values to the selected lower and upper bounds. Exact endpoints are unchanged.';
    elseif strcmp(type,'background'), filters(index).description='Subtract a smooth background estimated by morphological opening. Radius uses native pixels.';
    elseif strcmp(type,'clahe'), filters(index).description='Enhance local contrast with a fixed tile grid. Images smaller than 4 pixels in either dimension bypass this filter.';
    elseif strcmp(type,'bilateral'), filters(index).description='Smooth similar intensities while preserving edges. Intensity sigma uses the fixed normalized source range.'; end
end
    function add(type,label,names,values,low,high,steps)
        p=struct(); knobs=struct('name',{},'label',{},'min',{},'max',{},'step',{});
        for k=1:numel(names)
            p.(names{k})=values(k);
            knobs(k)=struct('name',names{k},'label',names{k},'min',low(k),'max',high(k),'step',steps(k));
        end
        filters(end+1)=struct('type',type,'label',label,'params',p,'knobs',knobs);
    end
end
