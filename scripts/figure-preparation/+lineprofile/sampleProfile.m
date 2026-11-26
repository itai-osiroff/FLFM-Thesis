function [distance, values, xs, ys] = sampleProfile(image, startXY, endXY, stepPixels)
%SAMPLEPROFILE Bilinear intensity samples along a straight segment.
%   startXY and endXY are one-based [column, row] positions on IMAGE (the
%   MATLAB pixel-centre convention). DISTANCE is measured from startXY in
%   pixels. Samples outside the image are an error, not NaN padding.
if nargin < 4 || isempty(stepPixels)
    stepPixels = 0.25;
end
startXY = double(startXY(:)).';
endXY = double(endXY(:)).';
lengthPixels = hypot(endXY(1) - startXY(1), endXY(2) - startXY(2));
if lengthPixels <= 0
    error('lineprofile:EmptySegment', 'The segment has zero length.');
end
count = floor(lengthPixels / stepPixels) + 1;
t = (0:count - 1) * stepPixels / lengthPixels;
xs = startXY(1) + t * (endXY(1) - startXY(1));
ys = startXY(2) + t * (endXY(2) - startXY(2));
values = interp2(double(image), xs, ys, 'linear');
if any(isnan(values))
    error('lineprofile:OutsideImage', 'The segment leaves the image.');
end
distance = t * lengthPixels;
end
