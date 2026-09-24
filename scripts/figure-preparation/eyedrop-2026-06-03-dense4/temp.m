function diagnostics = temp(thorcamRaw, globalAverage, localAverage, downsampleFactor)
%TEMP Optional diagnostic helper; it is excluded from the canonical replay.
%   The function returns normalized diagnostic panels and writes no files.

if nargin < 4
    downsampleFactor = 0.11101;
end
thorcamRectified = flipud(imrotate(double(thorcamRaw), -90));
thorcamDownsampled = imresize(imgaussfilt(thorcamRectified, ...
    1 / downsampleFactor / 2), downsampleFactor, 'bilinear');
sharedMaximum = max([double(globalAverage(:)); double(localAverage(:))]);
if sharedMaximum <= 0
    error('eyedrop_replay:FlatImage', 'Diagnostic inputs must have a positive maximum.');
end
diagnostics = struct( ...
    'thorcamOriginal', normalizePeak(thorcamRectified), ...
    'thorcamDownsampled', normalizePeak(thorcamDownsampled), ...
    'globalAverage', min(max(double(globalAverage) ./ sharedMaximum, 0), 1), ...
    'localAverage', min(max(double(localAverage) ./ sharedMaximum, 0), 1));
end

function normalized = normalizePeak(image)
peak = max(image(:));
if peak <= 0
    error('eyedrop_replay:FlatImage', 'Diagnostic image must have a positive maximum.');
end
normalized = image ./ peak;
end
