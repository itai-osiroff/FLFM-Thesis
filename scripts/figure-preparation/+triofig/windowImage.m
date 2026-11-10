function [mapped, lowPercent, highPercent] = windowImage(image, window, processing)
%WINDOWIMAGE Map a float image through a black/white window, then optional gamma.
% Values below black clip to 0 and above white clip to 1. lowPercent and
% highPercent report how many pixels were clipped at each end, before gamma.

scaled = (double(image) - window.black) ./ (window.white - window.black);
lowPercent = 100 * nnz(scaled < 0) / numel(scaled);
highPercent = 100 * nnz(scaled > 1) / numel(scaled);
mapped = min(max(scaled, 0), 1);
if nargin > 2 && processing.gamma.enabled && processing.gamma.value ~= 1
    mapped = mapped .^ processing.gamma.value;
end
end
