function read = setupAlignmentDialog(ui, recipe, data)
%SETUPALIGNMENTDIALOG Edit saved transforms with immediate overlay feedback.
roles = {'thorcam', 'validation'};
labels = {'ThorCam', 'Validation camera'};
fields = gobjects(2, 3);
axesHandles = gobjects(1, 3);
for k = 1:3
    axesHandles(k) = uiaxes(ui.plots);
end
initialIssue = '';
if strcmp(recipe.registration.transformSource, 'automatic')
    try
        prepared = triofig.setupPreview(data, recipe, false);
        recipe = saveTransforms(recipe, prepared.registration);
    catch cause
        initialIssue = cause.message;
        recipe.registration.transformSource = 'saved';
    end
end
for k = 1:2
    role = roles{k};
    uilabel(ui.controls, 'Text', labels{k});
    transform = recipe.registration.savedTransforms;
    values = [transform.([role 'RotationDegrees']), transform.([role 'TranslationXY'])];
    tags = {'rotation', 'x', 'y'};
    for j = 1:3
        fields(k, j) = uieditfield(ui.controls, 'text', 'Value', num2str(values(j), 12), ...
            'Tag', [role '-' tags{j}], 'ValueChangedFcn', @(~, ~) refresh());
    end
    hint = uilabel(ui.controls, 'Text', 'Rotation (°), X, Y (px)');
    hint.Layout.Column = [5, 6];
    if k == 1
        button = uibutton(ui.controls, 'Text', 'Re-estimate');
        button.ButtonPushedFcn = @(~, ~) reestimate();
    else
        uilabel(ui.controls, 'Text', '');
    end
    uilabel(ui.controls, 'Text', '');
end
read = @readRecipe;
refresh();
if ~isempty(initialIssue)
    ui.report(['Initial estimation failed. Adjust the saved values or choose Re-estimate. ' initialIssue], false);
end

    function candidate = readRecipe()
        candidate = recipe;
        candidate.registration.transformSource = 'saved';
        for n = 1:2
            values = arrayfun(@(field) str2double(field.Value), fields(n, :));
            if any(~isfinite(values))
                error('triofig:InvalidRecipe', 'Rotation and X/Y translation must be finite numbers.');
            end
            candidate.registration.savedTransforms.([roles{n} 'RotationDegrees']) = values(1);
            candidate.registration.savedTransforms.([roles{n} 'TranslationXY']) = values(2:3);
        end
        triofig.setupPreview(data, candidate, false);
    end

    function refresh()
        try
            candidate = readRecipe();
            prepared = triofig.setupPreview(data, candidate, false);
            overlay(axesHandles(1), prepared.preview.reference, prepared.preview.thorcamAligned, 'Reference / ThorCam');
            overlay(axesHandles(2), prepared.preview.reference, prepared.preview.validationAligned, 'Reference / Validation');
            imshow(prepared.preview.commonMask, 'Parent', axesHandles(3));
            title(axesHandles(3), 'Common field · white is valid');
            ui.report('X = columns, Y = rows, in pixels after camera preparation. Rotation is additional to preparation.', true);
        catch cause
            ui.report(cause.message, false);
        end
    end

    function reestimate()
        ui.next.Enable = 'off';
        ui.message.Text = 'Estimating alignment…';
        drawnow;
        try
            candidate = recipe;
            candidate.registration.transformSource = 'automatic';
            % An explicit request must recompute, rather than reuse an estimate.
            automaticData = data;
            automaticData.cache = containers.Map('KeyType', 'char', 'ValueType', 'any');
            prepared = triofig.setupPreview(automaticData, candidate, false);
            candidate = saveTransforms(candidate, prepared.registration);
            for n = 1:2
                transform = candidate.registration.savedTransforms;
                values = [transform.([roles{n} 'RotationDegrees']), transform.([roles{n} 'TranslationXY'])];
                for fieldIndex = 1:3
                    fields(n, fieldIndex).Value = num2str(values(fieldIndex), 12);
                end
            end
            refresh();
        catch cause
            ui.report(cause.message, false);
        end
    end
end

function recipe = saveTransforms(recipe, registration)
recipe.registration.transformSource = 'saved';
names = {'thorcamRotationDegrees', 'thorcamTranslationXY', ...
    'validationRotationDegrees', 'validationTranslationXY'};
for k = 1:numel(names)
    recipe.registration.savedTransforms.(names{k}) = registration.(names{k});
end
end

function overlay(ax, reference, moving, label)
imshow(cat(3, mat2gray(reference), mat2gray(moving), zeros(size(reference))), 'Parent', ax);
title(ax, label);
end
