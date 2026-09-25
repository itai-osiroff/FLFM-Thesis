function [position, completed] = roiPosition(roi, figureHandle)
%ROIPOSITION Return an accepted modern ROI position after wait(roi).

position = zeros(1, 4);
completed = false;
if ~isgraphics(figureHandle) || ~isvalid(roi)
    return;
end
position = roi.Position;
completed = isnumeric(position) && numel(position) == 4 && all(isfinite(position));
end
