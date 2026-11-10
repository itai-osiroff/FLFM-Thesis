function image = processDisplay(image, processing)
%PROCESSDISPLAY Apply the optional display-only operations that are enabled.
% Order: background subtraction, then smoothing. Both are off by default.
% Gamma is applied after windowing (see windowImage).

image = double(image);
if processing.background.enabled
    image = image - imgaussfilt(image, processing.background.sigmaPixels, ...
        'Padding', 'symmetric');
end
if processing.smoothing.enabled
    image = imgaussfilt(image, processing.smoothing.sigmaPixels, 'Padding', 'symmetric');
end
end
