function zooms = extractDisplayZooms(prepared, presentation, upsampled)
%EXTRACTDISPLAYZOOMS Zoom insets windowed per region from the processed float panels.
% Used when display.zoom.mode is perRegion. For each ROI the ThorCam inset has
% its own window and the global-stage and final insets share one window, so the
% intermediate/final comparison stays fair. Coordinates and geometry match
% extractZooms: top-left, zero-based, in the upsampled exported panel.
% upsampled (optional): struct of nearest-upsampled prepared.source panels, so
% interactive callers can avoid repeating the resize.

display = presentation.display;
rois = presentation.zoomRois;
if nargin < 3
    upsampled = triofig.upsampleSources(prepared, presentation.upsampleFactor);
end
groups = struct('thorcam', 'thorcam', 'global', 'flfm', 'local', 'flfm');
zooms = struct();
for panelName = {'thorcam', 'global', 'local'}
    key = panelName{1};
    processing = display.processing.(groups.(key));
    panel = upsampled.(key);
    for roiIndex = 1:numel(rois)
        roi = rois(roiIndex);
        rowStart = roi.yZeroBased + 1;
        rowEnd = rowStart + roi.height - 1;
        columnStart = roi.xZeroBased + 1;
        columnEnd = columnStart + roi.width - 1;
        if rowStart < 1 || columnStart < 1 || rowEnd > size(panel, 1) || ...
                columnEnd > size(panel, 2)
            error('triofig:InvalidRoi', ...
                'Zoom ROI %d falls outside the %s panel.', roi.id, key);
        end
        region = display.zoom.regions([display.zoom.regions.id] == roi.id);
        window = region.(groups.(key));
        mapped = triofig.windowImage(panel(rowStart:rowEnd, columnStart:columnEnd), ...
            window, processing);
        zooms.(sprintf('%s_zoom_%d', key, roi.id)) = uint8(round(mapped * 255));
    end
end
end
