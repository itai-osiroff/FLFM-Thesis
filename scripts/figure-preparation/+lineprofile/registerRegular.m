function [aligned, valid] = registerRegular(raw, registration, referenceSize)
%REGISTERREGULAR Place a regular-camera capture on the reconstruction grid.
%   REGISTRATION is data read from a trio recipe (its cameraPreparation.thorcam
%   and registration fields), copied into the profile recipe; no trio code is
%   called. The steps reproduce how the trio figures placed the same capture:
%   orient (rotate, optional vertical flip), Gaussian anti-alias and bilinear
%   downsampling, the saved rotation (output cropped to the input size), then
%   the saved integer translation into the reference frame. VALID marks pixels
%   that the moved capture covers.
camera = registration.camera;
saved = registration.savedTransforms;
image = imrotate(double(raw), camera.rotationDegrees);
if camera.flipVertical
    image = flipud(image);
end
factor = camera.downsampleFactor;
image = imresize(imgaussfilt(image, 1 / factor / 2), factor, 'bilinear');
sourceSize = size(image);
image = imrotate(image, saved.rotationDegrees, registration.rotationInterpolation, 'crop');
reference = imref2d(referenceSize);
shift = affine2d([1, 0, 0; 0, 1, 0; saved.translationXY(1), saved.translationXY(2), 1]);
aligned = imwarp(image, shift, 'OutputView', reference);
mask = imrotate(true(sourceSize), saved.rotationDegrees, 'nearest', 'crop');
valid = imwarp(mask, shift, 'OutputView', reference) > 0;
end
