function region = zoomRegionDefaults(id)
%ZOOMREGIONDEFAULTS Per-zoom-region display windows (used when zoom.mode is perRegion).
window = struct('black', 0, 'white', 1, 'auto', true, ...
    'lowPercentile', 0.5, 'highPercentile', 99.8);
region = struct('id', id, 'flfm', window, 'thorcam', window);
end
