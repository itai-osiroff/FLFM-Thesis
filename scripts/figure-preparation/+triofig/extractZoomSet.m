function [zooms, extras] = extractZoomSet(prepared, panels, presentation, upsampled)
%EXTRACTZOOMSET Zoom insets for window mapping, honoring each cell's view.
% Cells are, per ROI, ThorCam and FLFM (global-stage and final, which share one
% window so their comparison stays fair). Per cell view:
%   inherit  one inset sliced from the exported main panel (main-panel window);
%   separate one inset on the cell's own region window;
%   both     the primary inset stays inherited, and an extra inset on the
%            region window is returned in extras as <panel>_zoom_<id>_emphasis.
% Geometry matches extractZooms (top-left, zero-based, upsampled panel).
% upsampled (optional): nearest-upsampled prepared.source panels, so
% interactive callers can avoid repeating the resize.

rois = presentation.zoomRois;
display = presentation.display;
zooms = triofig.extractZooms(panels, rois);
extras = struct();
if nargin < 4
    upsampled = triofig.upsampleSources(prepared, presentation.upsampleFactor);
end
cells = struct('thorcam', 'thorcam', 'global', 'flfm', 'local', 'flfm');
for panelName = {'thorcam', 'global', 'local'}
    key = panelName{1};
    processing = display.processing.(cells.(key));
    panel = upsampled.(key);
    for roiIndex = 1:numel(rois)
        roi = rois(roiIndex);
        region = display.zoom.regions([display.zoom.regions.id] == roi.id);
        cell = region.(cells.(key));
        if strcmp(cell.view, 'inherit'), continue; end
        rows = roi.yZeroBased + (1:roi.height);
        columns = roi.xZeroBased + (1:roi.width);
        mapped = triofig.windowImage(panel(rows, columns), cell, processing);
        image = uint8(round(mapped * 255));
        name = sprintf('%s_zoom_%d', key, roi.id);
        if strcmp(cell.view, 'separate')
            zooms.(name) = image;
        else
            extras.([name '_emphasis']) = image;
        end
    end
end
end
