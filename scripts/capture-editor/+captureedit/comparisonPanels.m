function [panels,mask,validSupport] = comparisonPanels(images,geometry)
%COMPARISONPANELS Geometry-only equivalent of trio preparation, no normalization.
if ~isfield(images,'global'), error('captureedit:MissingReference','Aligned comparisons require global.'); end
required=fieldnames(images);
if ~isequal(size(images.global),geometry.referenceSize(:).'), error('captureedit:GridMismatch','Global image differs from reference grid.'); end
if isfield(images,'local') && ~isequal(size(images.local),size(images.global)), error('captureedit:GridMismatch','Global and local must share a grid.'); end
reference=imref2d(geometry.referenceSize); masks=struct(); actualMasks=struct(); panels=struct();
for role={'thorcam','validation'}
 name=role{1}; if ~isfield(images,name), continue; end; settings=geometry.cameraPreparation.(name); image=double(images.(name));
 strict=isfield(geometry.registration,'requireValidPixels') && geometry.registration.requireValidPixels;
 nativeMask=true(size(image)); nativeMask=imrotate(nativeMask,settings.rotationDegrees,'nearest');
 image=imrotate(image,settings.rotationDegrees);
 if settings.flipVertical, image=flipud(image); nativeMask=flipud(nativeMask); end
 factor=settings.downsampleFactor;
 image=imresize(imgaussfilt(image,1/factor/2),factor,'bilinear');
 transforms=geometry.registration.savedTransforms;
 angle=transforms.([name 'RotationDegrees']); shift=transforms.([name 'TranslationXY']);
 if strict, support=imresize(nativeMask,factor,'nearest'); else, support=true(size(image)); end
 % A warning pixel is valid only when every contributing sample is valid.
 % Gaussian support follows imgaussfilt's default 2-sigma kernel.
 gaussianRadius=ceil(2*(1/factor/2));
 actual=erodeSupport(nativeMask,gaussianRadius);
 actual=imresize(double(actual),factor,'bilinear')>=1-32*eps;
 switch geometry.registration.rotationInterpolation
  case 'nearest', interpolationRadius=0;
  case 'bilinear', interpolationRadius=1;
  case 'bicubic', interpolationRadius=2;
  otherwise, error('captureedit:InvalidInterpolation','Unsupported registration interpolation.');
 end
 actual=erodeSupport(actual,interpolationRadius);
 actual=imrotate(actual,angle,'nearest','crop');
 m=imrotate(support,angle,'nearest','crop');
 image=imrotate(image,angle,geometry.registration.rotationInterpolation,'crop');
 transform=affine2d([1 0 0;0 1 0;shift(1) shift(2) 1]);
 panels.(name)=imwarp(image,transform,'OutputView',reference);
 masks.(name)=imwarp(m,transform,'OutputView',reference)>0;
 actualMasks.(name)=imwarp(double(actual),transform,'OutputView',reference)>=1-32*eps;
end
panels.global=double(images.global);
if isfield(images,'local'), panels.local=double(images.local); end
mask=true(geometry.referenceSize); validSupport=mask;
names=fieldnames(actualMasks); for k=1:numel(names), validSupport=validSupport & actualMasks.(names{k}); end
names=fieldnames(masks); for k=1:numel(names), mask=mask & masks.(names{k}); end
if isfield(geometry.registration,'crop') && ~isempty(geometry.registration.crop)
 c=geometry.registration.crop;
 values=[c.rowStartOneBased c.columnStartOneBased c.height c.width];
 validateattributes(values,{'numeric'},{'integer','finite','positive'});
 rows=c.rowStartOneBased+(0:c.height-1); cols=c.columnStartOneBased+(0:c.width-1);
 if rows(end)>size(mask,1) || cols(end)>size(mask,2), error('captureedit:InvalidCrop','Crop exceeds comparison grid.'); end
 for k=1:numel(required), name=required{k}; panels.(name)=panels.(name)(rows,cols); end
 mask=mask(rows,cols); validSupport=validSupport(rows,cols);
end
end

function mask=erodeSupport(mask,radius)
% Zero padding makes outside-image samples explicitly unsupported.
if radius==0, return; end
padded=padarray(mask,[radius radius],false);
padded=imerode(padded,strel('square',2*radius+1));
mask=padded(radius+(1:size(mask,1)),radius+(1:size(mask,2)));
end
