function read = setupCropDialog(ui, recipe, data)
%SETUPCROPDIALOG Review a shared crop with common-field diagnostics.
prepared = triofig.setupPreview(data, recipe, false);
names = {'thorcamAligned', 'reference', ''};
labels = {'ThorCam', 'Global-stage average', 'Final rectified image'};
axesHandles = gobjects(1, 3);
rectangles = gobjects(1, 3);
crop = recipe.registration.crop;
if strcmp(recipe.registration.cropMode, 'intersection')
    crop = prepared.crop;
end
position = [crop.columnStartOneBased - .5, crop.rowStartOneBased - .5, crop.width, crop.height];
for k = 1:3
    axesHandles(k) = uiaxes(ui.plots);
    if k == 3
        image = data.localImage;
    else
        image = prepared.preview.(names{k});
    end
    image = repmat(mat2gray(image), 1, 1, 3);
    invalid = ~prepared.preview.commonMask;
    red = image(:, :, 1); red(invalid) = 1; image(:, :, 1) = red;
    green = image(:, :, 2); green(invalid) = green(invalid) * .25; image(:, :, 2) = green;
    blue = image(:, :, 3); blue(invalid) = blue(invalid) * .25; image(:, :, 3) = blue;
    imshow(image, 'Parent', axesHandles(k));
    title(axesHandles(k), labels{k});
    rectangles(k) = drawrectangle(axesHandles(k), 'Position', position, ...
        'Color', triofig.roiDisplayColor('yellow'));
end
fields = gobjects(1, 4);
labels = {'X edge', 'Y edge', 'Width', 'Height'};
for k = 1:4
    uilabel(ui.controls, 'Text', labels{k});
    fields(k) = uieditfield(ui.controls, 'text', 'Value', num2str(position(k)), ...
        'ValueChangedFcn', @(~, ~) fromFields());
end
for k = 1:3
    addlistener(rectangles(k), 'MovingROI', @(source, ~) fromRectangle(source));
    addlistener(rectangles(k), 'ROIMoved', @(source, ~) fromRectangle(source));
end
read = @readRecipe;
refresh();

    function candidate = readRecipe()
        position = arrayfun(@(field) str2double(field.Value), fields);
        crop = triofig.setupRectangle('crop', position, size(data.globalImage));
        candidate = recipe;
        candidate.registration.crop = crop;
        candidate.registration.cropMode = 'saved';
        candidate.registration.requireExpectedCrop = true;
        bounds = prepared.crop;
        if crop.columnStartOneBased < bounds.columnStartOneBased || ...
                crop.rowStartOneBased < bounds.rowStartOneBased || ...
                crop.columnStartOneBased + crop.width > bounds.columnStartOneBased + bounds.width || ...
                crop.rowStartOneBased + crop.height > bounds.rowStartOneBased + bounds.height
            error('triofig:InvalidCrop', 'Move the crop inside the common-field bounding limits.');
        end
    end

    function fromFields()
        refresh();
    end

    function fromRectangle(source)
        position = source.Position;
        for n = 1:4
            fields(n).Value = num2str(position(n), 12);
        end
        refresh();
    end

    function refresh()
        try
            candidate = readRecipe();
            crop = candidate.registration.crop;
            position = [crop.columnStartOneBased - .5, crop.rowStartOneBased - .5, crop.width, crop.height];
            for n = 1:3
                rectangles(n).Position = position;
            end
            mask = prepared.preview.commonMask(crop.rowStartOneBased:crop.rowStartOneBased + crop.height - 1, ...
                crop.columnStartOneBased:crop.columnStartOneBased + crop.width - 1);
            if all(mask(:))
                ui.report('Drag a rectangle on any panel. Red shading marks invalid common-field pixels.', true);
            else
                ui.report(sprintf('Warning: crop includes %.2f%% invalid common-field pixels (red). Existing bounds rules allow this crop.', ...
                    100 * nnz(~mask) / numel(mask)), true);
                ui.message.FontColor = [.7, .35, 0];
            end
        catch cause
            ui.report(cause.message, false);
        end
    end
end
