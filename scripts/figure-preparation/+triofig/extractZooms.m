function zooms = extractZooms(panels, rois)
%EXTRACTZOOMS Extract documented top-left, zero-based pixel-coordinate crops.

panelNames = {'thorcam', 'global', 'local'};
zooms = struct();
for panelIndex = 1:numel(panelNames)
    panelName = panelNames{panelIndex};
    image = panels.(panelName);
    for roiIndex = 1:numel(rois)
        roi = rois(roiIndex);
        rowStart = roi.yZeroBased + 1;
        rowEnd = rowStart + roi.height - 1;
        columnStart = roi.xZeroBased + 1;
        columnEnd = columnStart + roi.width - 1;
        if rowStart < 1 || columnStart < 1 || rowEnd > size(image, 1) || ...
                columnEnd > size(image, 2)
            error('triofig:InvalidRoi', ...
                'Zoom ROI %d falls outside the %s panel.', roi.id, panelName);
        end
        zooms.(sprintf('%s_zoom_%d', panelName, roi.id)) = ...
            image(rowStart:rowEnd, columnStart:columnEnd);
    end
end
end
