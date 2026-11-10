function region = zoomRegionDefaults(id)
%ZOOMREGIONDEFAULTS Per-zoom-region cells: ThorCam, and FLFM (global-stage + final, tied).
% view: 'inherit' (main-panel window), 'separate' (the cell's own window), or
% 'both' (upper inset inherited, lower inset on the cell's own window).
window = struct('black', 0, 'white', 1, 'auto', true, ...
    'lowPercentile', 0.5, 'highPercentile', 99.8, 'view', 'inherit');
region = struct('id', id, 'flfm', window, 'thorcam', window);
end
