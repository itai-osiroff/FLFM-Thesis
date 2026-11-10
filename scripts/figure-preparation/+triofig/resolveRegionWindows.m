function regions = resolveRegionWindows(regions, rois, upsampled)
%RESOLVEREGIONWINDOWS Recompute auto zoom windows from percentiles of each ROI slice.
% Only windows flagged auto change. ROIs are zero-based in the upsampled panel;
% upsampled holds the nearest-upsampled processed panels (global, local, thorcam).
% The FLFM window pools the global-stage and final slices of the region.

for index = 1:numel(regions)
    region = regions(index);
    roi = rois([rois.id] == region.id);
    rows = roi.yZeroBased + (1:roi.height);
    columns = roi.xZeroBased + (1:roi.width);
    if region.thorcam.auto
        region.thorcam = triofig.resolveWindow({upsampled.thorcam(rows, columns)}, region.thorcam);
    end
    if region.flfm.auto
        region.flfm = triofig.resolveWindow( ...
            {upsampled.global(rows, columns), upsampled.local(rows, columns)}, region.flfm);
    end
    regions(index) = region;
end
end
