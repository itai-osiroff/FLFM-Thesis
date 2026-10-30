function filters = catalog()
%CATALOG Supported native-image filters and their editable parameters.
filters = struct('type', {}, 'label', {}, 'params', {}, 'knobs', {});
add('brightness','Brightness / contrast',{'gain','offset'},[1 0],[0 -1],[5 1],[.01 .01]);
add('gamma','Gamma',{'gamma'},1,.1,5,.01);
add('window','Intensity window',{'black','white'},[0 1],[0 0],[1 1],[.01 .01]);
add('threshold','Threshold',{'cutoff','binary'},[.1 0],[0 0],[1 1],[.01 1]);
add('gaussian','Gaussian blur',{'sigma','size'},[1 0],[.1 0],[20 101],[.1 1]);
add('mean','Mean blur',{'size'},3,1,101,2);
add('median','Median filter',{'size'},3,1,101,2);
add('unsharp','Unsharp mask',{'radius','amount','threshold'},[1 .8 0],[.1 0 0],[20 5 1],[.1 .05 .01]);
add('laplacian','Laplacian sharpening',{'alpha','amount'},[.2 .5],[0 0],[1 5],[.01 .05]);
    function add(type,label,names,values,low,high,steps)
        p=struct(); knobs=struct('name',{},'label',{},'min',{},'max',{},'step',{});
        for k=1:numel(names)
            p.(names{k})=values(k);
            knobs(k)=struct('name',names{k},'label',names{k},'min',low(k),'max',high(k),'step',steps(k));
        end
        filters(end+1)=struct('type',type,'label',label,'params',p,'knobs',knobs);
    end
end
