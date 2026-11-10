function read = setupDisplayDialog(ui, recipe, data)
%SETUPDISPLAYDIALOG Black/white display windows, histograms, and optional processing.
% Windows are absolute source-unit values stored in the recipe. Windows flagged
% auto are recomputed from percentiles whenever the processed image changes;
% editing black or white switches that window to manual. The global-stage and
% final images share one FLFM window (linked) unless separation is chosen.
% Gamma, smoothing and background subtraction are off unless ticked.
baseline = triofig.setupPreview(data, recipe, true);
keys = {'flfm', 'global', 'local', 'thorcam'};
captions = struct('flfm', 'Global-stage + final window', 'global', 'Global-stage window', ...
    'local', 'Final-image window', 'thorcam', 'ThorCam window');
rowOf = struct('flfm', 2, 'global', 3, 'local', 4, 'thorcam', 5);
ui.controls.RowSpacing = 4;
ui.controls.RowHeight = {25, 28, 0, 0, 28, 28, 28, 22};
ui.body.RowHeight = {250, '1x'};
ui.plots.RowHeight = {'3x', '2x'};

[~, mode] = triofig.resolveIntensity(recipe.presentation);
mapping = uidropdown(ui.controls, 'Items', {'Window (recommended)', 'Legacy min/max'}, ...
    'ItemsData', {'window', 'legacyMinMax'}, 'Value', 'window', 'Tag', 'mapping-method', ...
    'ValueChangedFcn', @(~, ~) changeMapping());
mapping.Layout.Row = 1; mapping.Layout.Column = [1, 2];
separate = uicheckbox(ui.controls, 'Text', 'Separate intermediate and final windows', ...
    'Value', strcmp(mode, 'separate'), 'Tag', 'separate-brightness', ...
    'ValueChangedFcn', @(~, ~) changeMode());
separate.Layout.Row = 1; separate.Layout.Column = [3, 6];
highlight = uicheckbox(ui.controls, 'Text', 'Highlight clipping', 'Tag', 'highlight-clipping', ...
    'ValueChangedFcn', @(~, ~) refresh());
highlight.Layout.Row = 1; highlight.Layout.Column = [7, 8];

widgets = struct();
for index = 1:numel(keys)
    key = keys{index};
    row = rowOf.(key);
    label = uilabel(ui.controls, 'Text', captions.(key));
    label.Layout.Row = row; label.Layout.Column = 1;
    black = numericField(row, 2, [key '-black'], @(~, ~) editWindow(key));
    white = numericField(row, 3, [key '-white'], @(~, ~) editWindow(key));
    low = numericField(row, 4, [key '-low'], @(~, ~) editPercentiles());
    high = numericField(row, 5, [key '-high'], @(~, ~) editPercentiles());
    auto = uibutton(ui.controls, 'Text', 'Auto', 'Tag', [key '-auto'], ...
        'Tooltip', 'Recompute black/white from the low/high percentiles (columns 4-5, in %).', ...
        'ButtonPushedFcn', @(~, ~) pressAuto(key));
    auto.Layout.Row = row; auto.Layout.Column = 6;
    status = uilabel(ui.controls, 'Text', '');
    status.Layout.Row = row; status.Layout.Column = [7, 8];
    widgets.(key) = struct('label', label, 'black', black, 'white', white, 'low', low, ...
        'high', high, 'auto', auto, 'status', status);
end
% Column headers sit in the tooltips; keep the fields self-describing.
for index = 1:numel(keys)
    key = keys{index};
    widgets.(key).black.Tooltip = 'Black level (source units)';
    widgets.(key).white.Tooltip = 'White level (source units)';
    widgets.(key).low.Tooltip = 'Low percentile (%) used by Auto';
    widgets.(key).high.Tooltip = 'High percentile (%) used by Auto';
end

ops = struct();
groupRows = struct('flfm', 6, 'thorcam', 7);
groupLabels = struct('flfm', 'FLFM display-only ops', 'thorcam', 'ThorCam display-only ops');
for group = {'flfm', 'thorcam'}
    key = group{1};
    row = groupRows.(key);
    label = uilabel(ui.controls, 'Text', groupLabels.(key));
    label.Layout.Row = row; label.Layout.Column = 1;
    ops.(key).backgroundEnabled = opsCheckbox(row, 2, 'Background', [key '-background']);
    ops.(key).backgroundSigma = opsField(row, 3, [key '-background-sigma'], 'Background sigma (px)');
    ops.(key).smoothingEnabled = opsCheckbox(row, 4, 'Smooth', [key '-smoothing']);
    ops.(key).smoothingSigma = opsField(row, 5, [key '-smoothing-sigma'], 'Smoothing sigma (px)');
    ops.(key).gammaEnabled = opsCheckbox(row, 6, 'Gamma', [key '-gamma']);
    ops.(key).gammaValue = opsField(row, 7, [key '-gamma-value'], 'Gamma (0.2 to 5)');
end
warningLabel = uilabel(ui.controls, 'Text', '', 'FontColor', [.7, .35, 0], 'WordWrap', 'on');
warningLabel.Layout.Row = 8; warningLabel.Layout.Column = [1, 8];

axesImages = gobjects(1, 3);
imageHandles = gobjects(1, 3);
for k = 1:3
    axesImages(k) = uiaxes(ui.plots);
    axesImages(k).Layout.Row = 1; axesImages(k).Layout.Column = k;
    imageHandles(k) = imshow(zeros(2), 'Parent', axesImages(k));
end
axesThorcamHistogram = uiaxes(ui.plots);
axesThorcamHistogram.Layout.Row = 2; axesThorcamHistogram.Layout.Column = 1;
axesFlfmHistogram = uiaxes(ui.plots);
axesFlfmHistogram.Layout.Row = 2; axesFlfmHistogram.Layout.Column = [2, 3];

current = recipe;
loadFields(current.presentation.display);
arrange();
read = @readRecipe;
refresh();

    function field = numericField(row, column, tag, callback)
        field = uieditfield(ui.controls, 'numeric', 'Tag', tag, 'ValueDisplayFormat', '%.5g', ...
            'ValueChangedFcn', callback);
        field.Layout.Row = row; field.Layout.Column = column;
    end

    function box = opsCheckbox(row, column, text, tag)
        box = uicheckbox(ui.controls, 'Text', text, 'Tag', tag, 'ValueChangedFcn', @(~, ~) refresh());
        box.Layout.Row = row; box.Layout.Column = column;
    end

    function field = opsField(row, column, tag, tooltip)
        field = uieditfield(ui.controls, 'numeric', 'Tag', tag, 'Tooltip', tooltip, ...
            'ValueDisplayFormat', '%.4g', 'ValueChangedFcn', @(~, ~) refresh());
        field.Layout.Row = row; field.Layout.Column = column;
    end

    function loadFields(display)
        for index = 1:numel(keys)
            key = keys{index};
            window = display.roles.(key);
            widgets.(key).black.Value = window.black;
            widgets.(key).white.Value = window.white;
            widgets.(key).low.Value = window.lowPercentile;
            widgets.(key).high.Value = window.highPercentile;
        end
        for group = {'flfm', 'thorcam'}
            key = group{1};
            processing = display.processing.(key);
            ops.(key).backgroundEnabled.Value = logical(processing.background.enabled);
            ops.(key).backgroundSigma.Value = processing.background.sigmaPixels;
            ops.(key).smoothingEnabled.Value = logical(processing.smoothing.enabled);
            ops.(key).smoothingSigma.Value = processing.smoothing.sigmaPixels;
            ops.(key).gammaEnabled.Value = logical(processing.gamma.enabled);
            ops.(key).gammaValue.Value = processing.gamma.value;
        end
    end

    function candidate = collect()
        % Gather every control into a candidate recipe without resolving auto windows.
        candidate = current;
        display = candidate.presentation.display;
        for index = 1:numel(keys)
            key = keys{index};
            window = display.roles.(key);
            window.black = widgets.(key).black.Value;
            window.white = widgets.(key).white.Value;
            window.lowPercentile = widgets.(key).low.Value;
            window.highPercentile = widgets.(key).high.Value;
            display.roles.(key) = window;
        end
        for group = {'flfm', 'thorcam'}
            key = group{1};
            processing = display.processing.(key);
            processing.background.enabled = ops.(key).backgroundEnabled.Value;
            processing.background.sigmaPixels = ops.(key).backgroundSigma.Value;
            processing.smoothing.enabled = ops.(key).smoothingEnabled.Value;
            processing.smoothing.sigmaPixels = ops.(key).smoothingSigma.Value;
            processing.gamma.enabled = ops.(key).gammaEnabled.Value;
            processing.gamma.value = ops.(key).gammaValue.Value;
            display.processing.(key) = processing;
        end
        candidate.presentation.display = display;
    end

    function candidate = readRecipe()
        candidate = collect();
        display = candidate.presentation.display;
        [~, currentMode] = triofig.resolveIntensity(candidate.presentation);
        activeKeys = {'flfm', 'thorcam'};
        if strcmp(currentMode, 'separate'), activeKeys = {'global', 'local', 'thorcam'}; end
        for index = 1:numel(activeKeys)
            window = display.roles.(activeKeys{index});
            if ~all(isfinite([window.black, window.white])) || window.white <= window.black
                error('triofig:InvalidRecipe', ...
                    'The %s window needs finite values with white above black.', activeKeys{index});
            end
            if window.lowPercentile < 0 || window.highPercentile > 100 || ...
                    window.lowPercentile >= window.highPercentile
                error('triofig:InvalidRecipe', 'Percentiles need 0 <= low < high <= 100.');
            end
        end
        for group = {'flfm', 'thorcam'}
            processing = display.processing.(group{1});
            sigmas = [processing.background.sigmaPixels, processing.smoothing.sigmaPixels];
            if any(~isfinite(sigmas)) || any(sigmas <= 0)
                error('triofig:InvalidRecipe', 'Processing sigmas must be positive.');
            end
            if ~isfinite(processing.gamma.value) || processing.gamma.value < .2 || processing.gamma.value > 5
                error('triofig:InvalidRecipe', 'Gamma must be between 0.2 and 5.');
            end
        end
        [~, info] = triofig.applyDisplay(baseline.crops, candidate.presentation);
        display = triofig.resolveAutoWindows(display, info.source, currentMode);
        candidate.presentation.display = display;
    end

    function editWindow(key)
        current = collect();
        current.presentation.display.roles.(key).auto = false;
        refresh();
    end

    function editPercentiles()
        current = collect();
        refresh();
    end

    function pressAuto(key)
        current = collect();
        current.presentation.display.roles.(key).auto = true;
        refresh();
    end

    function changeMode()
        try
            current = collect();
            target = 'linked';
            if separate.Value, target = 'separate'; end
            current = triofig.setIntensityMode(current, target);
            loadFields(current.presentation.display);
            arrange();
            refresh();
        catch cause
            [~, previous] = triofig.resolveIntensity(current.presentation);
            separate.Value = strcmp(previous, 'separate');
            ui.report(cause.message, false);
        end
    end

    function changeMapping()
        if strcmp(mapping.Value, 'legacyMinMax')
            try
                ui.switchMapping(collect(), 'legacyMinMax');
            catch cause
                mapping.Value = 'window';
                ui.report(cause.message, false);
            end
        end
    end

    function arrange()
        isSeparate = separate.Value;
        visibility = struct('flfm', ~isSeparate, 'global', isSeparate, ...
            'local', isSeparate, 'thorcam', true);
        for index = 1:numel(keys)
            key = keys{index};
            handles = struct2cell(widgets.(key));
            set([handles{:}], 'Visible', matlab.lang.OnOffSwitchState(visibility.(key)));
        end
        if isSeparate
            ui.controls.RowHeight = {25, 0, 28, 28, 28, 28, 28, 22};
        else
            ui.controls.RowHeight = {25, 28, 0, 0, 28, 28, 28, 22};
        end
    end

    function refresh()
        try
            current = readRecipe();
            display = current.presentation.display;
            [~, currentMode] = triofig.resolveIntensity(current.presentation);
            loadFields(display);
            prepared = triofig.presentPrepared(baseline, current);
            names = {'thorcam', 'global', 'local'};
            titles = {'ThorCam', 'Global-stage average', 'Final rectified image'};
            for panelIndex = 1:3
                name = names{panelIndex};
                image = prepared.(name);
                if highlight.Value
                    image = highlightClipping(image, prepared.source.(name), ...
                        prepared.display.windows.(name));
                end
                imageHandles(panelIndex).CData = image;
                imageHandles(panelIndex).XData = [1, size(image, 2)];
                imageHandles(panelIndex).YData = [1, size(image, 1)];
                xlim(axesImages(panelIndex), [.5, size(image, 2) + .5]);
                ylim(axesImages(panelIndex), [.5, size(image, 1) + .5]);
                stats = prepared.display.stats.(name);
                title(axesImages(panelIndex), sprintf('%s · %.2f%% low / %.2f%% high clipped · %d levels', ...
                    titles{panelIndex}, stats.clippedLowPercent, stats.clippedHighPercent, stats.occupiedLevels));
            end
            updateStatus(display, prepared.display, currentMode);
            drawHistograms(prepared, currentMode);
            warningText = '';
            if anyProcessing(display)
                warningText = 'Display-only processing is enabled. It changes how the image looks, not the data; disclose it in the caption.';
            end
            warningLabel.Text = warningText;
            stats = prepared.display.stats;
            ui.report(sprintf(['Window mapping. Same-window means: global-stage %.4g, final %.4g (source units). ' ...
                'Blue marks values below black, magenta above white.'], ...
                stats.global.sourceMean, stats.local.sourceMean), true);
        catch cause
            ui.report(cause.message, false);
        end
    end

    function updateStatus(display, info, currentMode)
        for index = 1:numel(keys)
            key = keys{index};
            widgets.(key).status.Text = autoText(display.roles.(key));
        end
        if strcmp(currentMode, 'linked')
            widgets.flfm.status.Text = [autoText(display.roles.flfm) ' · ' ...
                sprintf('%.2f/%.2f%% clipped', ...
                max(info.stats.global.clippedLowPercent, info.stats.local.clippedLowPercent), ...
                max(info.stats.global.clippedHighPercent, info.stats.local.clippedHighPercent))];
        end
    end

    function drawHistograms(prepared, currentMode)
        drawHistogram(axesThorcamHistogram, {prepared.source.thorcam}, ...
            {prepared.display.windows.thorcam}, [.2, .2, .2], 'ThorCam');
        if strcmp(currentMode, 'separate')
            drawHistogram(axesFlfmHistogram, {prepared.source.global, prepared.source.local}, ...
                {prepared.display.windows.global, prepared.display.windows.local}, ...
                [0, .35, .75; .75, .25, 0], 'Global-stage (blue) and final (orange)');
        else
            drawHistogram(axesFlfmHistogram, {prepared.source.global, prepared.source.local}, ...
                {prepared.display.windows.global, prepared.display.windows.local}, ...
                [0, .35, .75; .75, .25, 0], 'Global-stage (blue) and final (orange), shared window');
        end
    end
end

function drawHistogram(ax, sources, windows, colors, label)
cla(ax);
hold(ax, 'on');
pooled = [];
for index = 1:numel(sources)
    pooled = [pooled; sources{index}(:)]; %#ok<AGROW>
end
low = min(pooled);
high = max(pooled);
if high <= low, high = low + 1; end
edges = linspace(low, high, 129);
centers = (edges(1:end - 1) + edges(2:end)) / 2;
peak = 1;
for index = 1:numel(sources)
    counts = histcounts(sources{index}(:), edges) + 1;
    peak = max(peak, max(counts));
    plot(ax, centers, counts, 'Color', colors(min(index, size(colors, 1)), :), 'LineWidth', 1);
end
for index = 1:numel(windows)
    shade = colors(min(index, size(colors, 1)), :);
    plot(ax, [windows{index}.black, windows{index}.black], [1, peak], '--', 'Color', shade);
    plot(ax, [windows{index}.white, windows{index}.white], [1, peak], ':', 'Color', shade, 'LineWidth', 1.5);
end
hold(ax, 'off');
ax.YScale = 'log';
xlim(ax, [low, high]);
title(ax, [label ' · dashed black, dotted white'], 'FontSize', 10);
end

function image = highlightClipping(image, source, window)
scaled = (source - window.black) ./ (window.white - window.black);
rgb = repmat(image, 1, 1, 3);
for channel = 1:3
    plane = rgb(:, :, channel);
    plane(scaled > 1) = double(channel ~= 2);
    plane(scaled < 0) = double(channel == 3);
    rgb(:, :, channel) = plane;
end
image = rgb;
end

function text = autoText(window)
if window.auto
    text = 'auto';
else
    text = 'manual';
end
end

function enabled = anyProcessing(display)
enabled = false;
for group = {'flfm', 'thorcam'}
    processing = display.processing.(group{1});
    enabled = enabled || processing.background.enabled || processing.smoothing.enabled || ...
        (processing.gamma.enabled && processing.gamma.value ~= 1);
end
end
