function read = setupLegacyBrightnessDialog(ui, recipe, data)
%SETUPLEGACYBRIGHTNESSDIALOG Min/max normalization with display gains (schemas 2-5, legacyMinMax).
% Opts into separate display multipliers on shared normalization. A button
% switches the recipe to the window mapping (ui.switchMapping).
baseline = triofig.setupPreview(data, recipe, true);
[~, mode] = triofig.resolveIntensity(recipe.presentation);
roles = {'globalLocal', 'global', 'local', 'thorcam'};
labels = {'Intermediate + final', 'Global-stage average', 'Final rectified image', 'ThorCam'};
rows = [2, 2, 3, 4];
fields = gobjects(1, 4); sliders = gobjects(1, 4); captions = gobjects(1, 4);
axesHandles = gobjects(1, 3); imageHandles = gobjects(1, 3);
ui.controls.RowSpacing = 6;
separate = uicheckbox(ui.controls, 'Text', 'Separate intermediate and final brightness', ...
    'Value', strcmp(mode, 'separate'), 'Tag', 'separate-brightness', ...
    'ValueChangedFcn', @(~, ~) changeMode());
separate.Layout.Row = 1; separate.Layout.Column = [1, 4];
highlight = uicheckbox(ui.controls, 'Text', 'Highlight clipping', 'ValueChangedFcn', @(~, ~) refresh());
highlight.Layout.Row = 1; highlight.Layout.Column = [5, 6];
switchButton = uibutton(ui.controls, 'Text', 'Use window mapping…', 'Tag', 'use-window-mapping', ...
    'Tooltip', 'Replace min/max normalization with explicit black/white windows. Re-link uses the global value for both.', ...
    'ButtonPushedFcn', @(~, ~) switchMapping());
switchButton.Layout.Row = 1; switchButton.Layout.Column = [7, 8];
for k = 1:4
    role = roles{k};
    value = recipe.presentation.intensityMultipliers.globalLocal;
    if isfield(recipe.presentation.intensityMultipliers, role)
        value = recipe.presentation.intensityMultipliers.(role);
    end
    captions(k) = uilabel(ui.controls, 'Text', labels{k});
    captions(k).Layout.Row = rows(k); captions(k).Layout.Column = [1, 2];
    fields(k) = uieditfield(ui.controls, 'numeric', 'Value', value, ...
        'Tag', [role '-multiplier'], 'ValueChangedFcn', @(~, ~) fromField(k));
    fields(k).Layout.Row = rows(k); fields(k).Layout.Column = 3;
    sliders(k) = uislider(ui.controls, 'Limits', [.1, 5], 'Value', min(max(value, .1), 5), ...
        'MajorTicks', [.1, 1, 2, 3, 4, 5], 'MinorTicks', []);
    sliders(k).Layout.Row = rows(k); sliders(k).Layout.Column = [4, 8];
    sliders(k).ValueChangingFcn = @(~, event) fromSlider(k, event.Value);
    sliders(k).ValueChangedFcn = @(source, ~) fromSlider(k, source.Value);
end
for k = 1:3
    axesHandles(k) = uiaxes(ui.plots);
    imageHandles(k) = imshow(zeros(2), 'Parent', axesHandles(k));
end
read = @readRecipe;
arrange();
refresh();

    function candidate = readRecipe()
        candidate = recipe;
        [~, currentMode] = triofig.resolveIntensity(recipe.presentation);
        active = [1, 4];
        if strcmp(currentMode, 'separate'), active = [2, 3, 4]; end
        for index = active
            value = fields(index).Value;
            if ~isfinite(value) || value < .1 || value > 5
                error('triofig:InvalidRecipe', 'Intensity multipliers must be between 0.1 and 5.');
            end
            candidate.presentation.intensityMultipliers.(roles{index}) = value;
        end
    end

    function switchMapping()
        try
            ui.switchMapping(readRecipe(), 'window');
        catch cause
            ui.report(cause.message, false);
        end
    end

    function changeMode()
        [~, previous] = triofig.resolveIntensity(recipe.presentation);
        try
            candidate = readRecipe();
            target = 'linked';
            if separate.Value, target = 'separate'; end
            recipe = triofig.setIntensityMode(candidate, target);
            for index = 1:4
                if isfield(recipe.presentation.intensityMultipliers, roles{index})
                    fields(index).Value = recipe.presentation.intensityMultipliers.(roles{index});
                    sliders(index).Value = min(max(fields(index).Value, .1), 5);
                end
            end
            arrange(); refresh();
        catch cause
            separate.Value = strcmp(previous, 'separate');
            ui.report(cause.message, false);
        end
    end

    function arrange()
        visibility = [~separate.Value, separate.Value, separate.Value, true];
        for index = 1:4
            set([captions(index), fields(index), sliders(index)], ...
                'Visible', matlab.lang.OnOffSwitchState(visibility(index)));
        end
        if separate.Value
            ui.controls.RowHeight = {25, 45, 45, 45};
            ui.body.RowHeight = {198, '1x'};
        else
            ui.controls.RowHeight = {25, 45, 0, 45};
            ui.body.RowHeight = {153, '1x'};
        end
    end

    function fromField(index)
        if isfinite(fields(index).Value) && fields(index).Value >= .1 && fields(index).Value <= 5
            sliders(index).Value = fields(index).Value;
        end
        refresh();
    end

    function fromSlider(index, value)
        fields(index).Value = value;
        refresh();
    end

    function refresh()
        try
            candidate = readRecipe();
            [images, clipping, masks] = triofig.applySetupIntensity(baseline, candidate.presentation);
            names = {'thorcam', 'global', 'local'};
            titles = {'ThorCam', 'Global-stage average', 'Final rectified image'};
            for panelIndex = 1:3
                image = images.(names{panelIndex});
                if highlight.Value
                    rgb = repmat(image, 1, 1, 3);
                    mask = masks.(names{panelIndex});
                    for channel = 1:3
                        plane = rgb(:, :, channel); plane(mask) = channel ~= 2; rgb(:, :, channel) = plane;
                    end
                    image = rgb;
                end
                imageHandles(panelIndex).CData = image;
                imageHandles(panelIndex).XData = [1, size(image, 2)];
                imageHandles(panelIndex).YData = [1, size(image, 1)];
                xlim(axesHandles(panelIndex), [.5, size(image, 2) + .5]);
                ylim(axesHandles(panelIndex), [.5, size(image, 1) + .5]);
                title(axesHandles(panelIndex), sprintf('%s · %.2f%% clipped', titles{panelIndex}, clipping.(names{panelIndex})));
            end
            text = 'Legacy min/max normalization with a linked intermediate/final multiplier.';
            if separate.Value, text = 'Legacy min/max normalization; separate intermediate/final display multipliers enabled.'; end
            ui.report([text ' Magenta marks clipped values.'], true);
        catch cause
            ui.report(cause.message, false);
        end
    end
end
