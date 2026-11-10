function window = resolveWindow(images, window)
%RESOLVEWINDOW Set black/white from the window's percentiles over one or more images.
% images is a cell array; their pixels are pooled (e.g. global and final images
% for the shared FLFM window). The auto flag is left unchanged.

pooled = [];
for index = 1:numel(images)
    pooled = [pooled; double(images{index}(:))]; %#ok<AGROW>
end
black = triofig.percentileValue(pooled, window.lowPercentile);
white = triofig.percentileValue(pooled, window.highPercentile);
if white <= black
    error('triofig:FlatImage', ...
        'The %g-%g percentile range is empty; widen the percentiles or choose the window manually.', ...
        window.lowPercentile, window.highPercentile);
end
window.black = black;
window.white = white;
end
