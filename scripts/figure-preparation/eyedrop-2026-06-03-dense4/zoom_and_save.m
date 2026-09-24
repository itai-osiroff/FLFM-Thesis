function zooms = zoom_and_save(images, rois)
%ZOOM_AND_SAVE Extract documented pixel-coordinate crops without a GUI.
%   IMAGES contains full-resolution uint8 panels named thorcam, global, local.
%   ROIS use zero-based x/y coordinates with a top-left origin.

panelNames = {'thorcam', 'global', 'local'};
zooms = struct();
for panelIndex = 1:numel(panelNames)
    panelName = panelNames{panelIndex};
    image = images.(panelName);
    for roiIndex = 1:numel(rois)
        roi = rois(roiIndex);
        rowStart = roi.yZeroBased + 1;
        rowEnd = rowStart + roi.height - 1;
        columnStart = roi.xZeroBased + 1;
        columnEnd = columnStart + roi.width - 1;
        if rowStart < 1 || columnStart < 1 || rowEnd > size(image, 1) || ...
                columnEnd > size(image, 2)
            error('eyedrop_replay:InvalidRoi', ...
                'Zoom ROI %d falls outside the %s panel.', roi.id, panelName);
        end
        zooms.(sprintf('%s_zoom_%d', panelName, roi.id)) = ...
            image(rowStart:rowEnd, columnStart:columnEnd);
    end
end
end
