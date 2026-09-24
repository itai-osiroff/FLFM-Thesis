function marker = addCalibrationPoint(axesHandle, xy)
%ADDCALIBRATIONPOINT Draw a point pair marker without replacing the image.

if ~isnumeric(xy) || numel(xy) ~= 2 || any(~isfinite(xy))
    error('triofig:InvalidCalibrationPoint', ...
        'Calibration points must contain two finite coordinates.');
end
hold(axesHandle, 'on');
marker = plot(axesHandle, xy(1), xy(2), 'r+', 'MarkerSize', 12, 'LineWidth', 2);
end
