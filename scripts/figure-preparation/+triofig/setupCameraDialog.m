function read = setupCameraDialog(ui, recipe, data)
%SETUPCAMERADIALOG Review orientation, sampling, and optional matched points.
roles = {'thorcam', 'validation'};
labels = {'ThorCam', 'Validation camera'};
fields = gobjects(2, 3);
axesHandles = gobjects(1, 3);
for k = 1:3
    axesHandles(k) = uiaxes(ui.plots);
end
for k = 1:2
    role = roles{k};
    settings = recipe.cameraPreparation.(role);
    uilabel(ui.controls, 'Text', labels{k});
    fields(k, 1) = uieditfield(ui.controls, 'text', 'Value', num2str(settings.rotationDegrees), ...
        'Tooltip', 'Preparation rotation in degrees', 'Tag', [role '-rotation']);
    fields(k, 2) = uicheckbox(ui.controls, 'Text', 'Flip vertical', 'Value', settings.flipVertical);
    fields(k, 3) = uieditfield(ui.controls, 'text', 'Value', num2str(settings.downsampleFactor, 12), ...
        'Tooltip', 'Downsample factor: greater than zero and at most one', 'Tag', [role '-scale']);
    button = uibutton(ui.controls, 'Text', 'Match points…');
    button.ButtonPushedFcn = @(~, ~) calibrate(k);
    button = uibutton(ui.controls, 'Text', 'Estimate scale');
    button.ButtonPushedFcn = @(~, ~) estimate(k);
    uilabel(ui.controls, 'Text', sprintf('%d saved pairs', ...
        size(recipe.calibration.(role).pointPairs.referenceXY, 1)), 'Tag', [role '-pairs']);
    uilabel(ui.controls, 'Text', 'degrees / factor');
    for j = 1:3
        fields(k, j).ValueChangedFcn = @(~, ~) refresh();
    end
end
read = @readRecipe;
refresh();

    function candidate = readRecipe()
        candidate = recipe;
        for n = 1:2
            rotation = str2double(fields(n, 1).Value);
            scale = str2double(fields(n, 3).Value);
            if ~isfinite(rotation) || ~isfinite(scale) || scale <= 0 || scale > 1
                error('triofig:InvalidRecipe', 'Enter a finite rotation and a scale greater than 0 and at most 1.');
            end
            candidate.cameraPreparation.(roles{n}) = struct('rotationDegrees', rotation, ...
                'flipVertical', fields(n, 2).Value, 'downsampleFactor', scale);
        end
    end

    function refresh()
        try
            candidate = readRecipe();
            imshow(mat2gray(data.globalImage), 'Parent', axesHandles(1));
            title(axesHandles(1), 'Global-stage average · reference');
            for n = 1:2
                settings = candidate.cameraPreparation.(roles{n});
                image = orient(data.(roles{n}), settings);
                image = imresize(imgaussfilt(double(image), 1 / settings.downsampleFactor / 2), ...
                    settings.downsampleFactor, 'bilinear');
                imshow(mat2gray(image), 'Parent', axesHandles(n + 1));
                title(axesHandles(n + 1), sprintf('%s · %d × %d px', labels{n}, size(image, 2), size(image, 1)));
            end
            ui.report('Rotation is in degrees. Factor controls camera downsampling before alignment.', true);
        catch cause
            ui.report(cause.message, false);
        end
    end

    function estimate(n)
        try
            candidate = readRecipe();
            image = orient(data.(roles{n}), candidate.cameraPreparation.(roles{n}));
            factor = min(1, median([size(data.globalImage, 1) / size(image, 1), ...
                size(data.globalImage, 2) / size(image, 2)]));
            fields(n, 3).Value = num2str(factor, 12);
            refresh();
        catch cause
            ui.report(cause.message, false);
        end
    end

    function calibrate(n)
        try
            candidate = readRecipe();
            image = orient(data.(roles{n}), candidate.cameraPreparation.(roles{n}));
            [points, factor, accepted] = triofig.setupCalibrationDialog(data.globalImage, ...
                image, recipe.calibration.(roles{n}).pointPairs, labels{n});
            if accepted
                recipe.calibration.(roles{n}).pointPairs = points;
                fields(n, 3).Value = num2str(factor, 12);
                label = findobj(ui.controls, 'Tag', [roles{n} '-pairs']);
                label.Text = sprintf('%d saved pairs', size(points.referenceXY, 1));
                refresh();
            end
        catch cause
            ui.report(cause.message, false);
        end
    end
end

function image = orient(image, settings)
image = imrotate(image, settings.rotationDegrees);
if settings.flipVertical
    image = flipud(image);
end
end
