function [points, factor, accepted] = setupCalibrationDialog(reference, moving, points, label)
%SETUPCALIBRATIONDIALOG Preserve complete pairs; never commit a half-pair.
accepted = false;
factor = NaN;
if isempty(points.referenceXY)
    points.referenceXY = zeros(0, 2);
    points.movingXY = zeros(0, 2);
end
fig = figure('Name', [label ' · point-pair calibration'], 'NumberTitle', 'off', ...
    'Position', [80, 80, 1150, 650], 'CloseRequestFcn', @(~, ~) uiresume(gcbf));
cleanup = onCleanup(@() delete(fig));
left = axes(fig, 'Position', [.04, .2, .43, .72]);
right = axes(fig, 'Position', [.53, .2, .43, .72]);
note = uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
    'Position', [.05, .11, .9, .05], 'String', 'Add at least two matched pairs.');
uicontrol(fig, 'Style', 'pushbutton', 'String', 'Add pair', 'Units', 'normalized', ...
    'Position', [.1, .03, .15, .06], 'Callback', @(~, ~) addPair());
uicontrol(fig, 'Style', 'pushbutton', 'String', 'Undo pair', 'Units', 'normalized', ...
    'Position', [.3, .03, .15, .06], 'Callback', @(~, ~) undoPair());
uicontrol(fig, 'Style', 'pushbutton', 'String', 'Use calibration', 'Units', 'normalized', ...
    'Position', [.55, .03, .17, .06], 'Callback', @(~, ~) accept());
uicontrol(fig, 'Style', 'pushbutton', 'String', 'Cancel', 'Units', 'normalized', ...
    'Position', [.77, .03, .12, .06], 'Callback', @(~, ~) uiresume(fig));
draw();
uiwait(fig);
delete(fig);

    function draw()
        imshow(mat2gray(reference), 'Parent', left); title(left, '1. Reference feature');
        imshow(mat2gray(moving), 'Parent', right); title(right, '2. Matching camera feature');
        for k = 1:size(points.referenceXY, 1)
            triofig.addCalibrationPoint(left, points.referenceXY(k, :));
            triofig.addCalibrationPoint(right, points.movingXY(k, :));
        end
    end

    function addPair()
        try
            note.String = 'Click the reference, then the matching camera feature. Enter cancels this pair.';
            axes(left);
            [x1, y1, b1] = ginput(1);
            if isempty(b1), return; end
            axes(right);
            [x2, y2, b2] = ginput(1);
            if isempty(b2), return; end
            if x1 < .5 || y1 < .5 || x1 > size(reference, 2) + .5 || y1 > size(reference, 1) + .5 || ...
                    x2 < .5 || y2 < .5 || x2 > size(moving, 2) + .5 || y2 > size(moving, 1) + .5
                note.String = 'Both points must lie inside their images.';
                return;
            end
            points.referenceXY(end + 1, :) = [x1, y1];
            points.movingXY(end + 1, :) = [x2, y2];
            draw();
            note.String = sprintf('%d complete pairs.', size(points.referenceXY, 1));
        catch cause
            note.String = cause.message;
        end
    end

    function undoPair()
        if ~isempty(points.referenceXY)
            points.referenceXY(end, :) = [];
            points.movingXY(end, :) = [];
            draw();
        end
    end

    function accept()
        if size(points.referenceXY, 1) < 2
            note.String = 'At least two complete pairs are required.';
            return;
        end
        factor = median(pdist(points.referenceXY) ./ pdist(points.movingXY));
        if ~isfinite(factor) || factor <= 0 || factor > 1
            note.String = 'Pairs must imply a finite downsample factor greater than 0 and at most 1.';
            return;
        end
        accepted = true;
        uiresume(fig);
    end
end
