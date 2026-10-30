function [panels,mask] = comparisonPanels(images,geometry)
%COMPARISONPANELS Geometry-only equivalent of trio preparation, no normalization.
required={'thorcam','validation','global','local'};
for k=1:numel(required)
 if ~isfield(images,required{k}), error('captureedit:IncompleteSet','Aligned comparison needs all four images.'); end
end
reference=imref2d(geometry.referenceSize); masks=struct(); panels=struct();
for role={'thorcam','validation'}
 name=role{1}; settings=geometry.cameraPreparation.(name); image=double(images.(name));
 image=imrotate(image,settings.rotationDegrees);
 if settings.flipVertical, image=flipud(image); end
 factor=settings.downsampleFactor;
 image=imresize(imgaussfilt(image,1/factor/2),factor,'bilinear');
 transforms=geometry.registration.savedTransforms;
 angle=transforms.([name 'RotationDegrees']); shift=transforms.([name 'TranslationXY']);
 m=imrotate(true(size(image)),angle,'nearest','crop');
 image=imrotate(image,angle,geometry.registration.rotationInterpolation,'crop');
 transform=affine2d([1 0 0;0 1 0;shift(1) shift(2) 1]);
 panels.(name)=imwarp(image,transform,'OutputView',reference);
 masks.(name)=imwarp(m,transform,'OutputView',reference)>0;
end
panels.global=double(images.global); panels.local=double(images.local);
mask=masks.thorcam & masks.validation;
if isfield(geometry.registration,'crop') && ~isempty(geometry.registration.crop)
 c=geometry.registration.crop;
 values=[c.rowStartOneBased c.columnStartOneBased c.height c.width];
 validateattributes(values,{'numeric'},{'integer','finite','positive'});
 rows=c.rowStartOneBased+(0:c.height-1); cols=c.columnStartOneBased+(0:c.width-1);
 if rows(end)>size(mask,1) || cols(end)>size(mask,2), error('captureedit:InvalidCrop','Crop exceeds comparison grid.'); end
 for k=1:numel(required), name=required{k}; panels.(name)=panels.(name)(rows,cols); end
 mask=mask(rows,cols);
end
end
