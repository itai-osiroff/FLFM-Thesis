function [panels,mask] = comparisonPanels(images,geometry)
%COMPARISONPANELS Geometry-only equivalent of trio preparation, no normalization.
if ~isfield(images,'global'), error('captureedit:MissingReference','Aligned comparisons require global.'); end
required=fieldnames(images);
if ~isequal(size(images.global),geometry.referenceSize(:).'), error('captureedit:GridMismatch','Global image differs from reference grid.'); end
if isfield(images,'local') && ~isequal(size(images.local),size(images.global)), error('captureedit:GridMismatch','Global and local must share a grid.'); end
reference=imref2d(geometry.referenceSize); masks=struct(); panels=struct();
for role={'thorcam','validation'}
 name=role{1}; if ~isfield(images,name), continue; end; settings=geometry.cameraPreparation.(name); image=double(images.(name));
 strict=isfield(geometry.registration,'requireValidPixels') && geometry.registration.requireValidPixels;
 if strict, nativeMask=true(size(image)); nativeMask=imrotate(nativeMask,settings.rotationDegrees,'nearest'); end
 image=imrotate(image,settings.rotationDegrees);
 if settings.flipVertical, image=flipud(image); if strict, nativeMask=flipud(nativeMask); end; end
 factor=settings.downsampleFactor;
 image=imresize(imgaussfilt(image,1/factor/2),factor,'bilinear');
 transforms=geometry.registration.savedTransforms;
 angle=transforms.([name 'RotationDegrees']); shift=transforms.([name 'TranslationXY']);
 if strict, support=imresize(nativeMask,factor,'nearest'); else, support=true(size(image)); end
 m=imrotate(support,angle,'nearest','crop');
 image=imrotate(image,angle,geometry.registration.rotationInterpolation,'crop');
 transform=affine2d([1 0 0;0 1 0;shift(1) shift(2) 1]);
 panels.(name)=imwarp(image,transform,'OutputView',reference);
 masks.(name)=imwarp(m,transform,'OutputView',reference)>0;
end
panels.global=double(images.global);
if isfield(images,'local'), panels.local=double(images.local); end
mask=true(geometry.referenceSize);
names=fieldnames(masks); for k=1:numel(names), mask=mask & masks.(names{k}); end
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
