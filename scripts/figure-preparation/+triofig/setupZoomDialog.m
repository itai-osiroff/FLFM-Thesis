function read = setupZoomDialog(ui, recipe, data)
%SETUPZOOMDIALOG Keep both zoom regions editable and compare matching crops.
% With window display mapping, "Per region" zoom contrast scales each region's
% insets separately from the main panels: the ThorCam inset has its own window
% and the global-stage and final insets share one, so their comparison stays fair.
baseline = triofig.setupPreview(data, recipe, true);
prepared = triofig.presentPrepared(baseline, recipe);
panels = triofig.renderPanels(prepared, recipe.presentation.upsampleFactor);
windowed = recipe.schemaVersion >= 6 && strcmp(recipe.presentation.display.method, 'window');
upsampled = struct();
zoomState = struct();
if windowed
    upsampled = triofig.upsampleSources(prepared, recipe.presentation.upsampleFactor);
    zoomState = recipe.presentation.display.zoom;
end
rois = recipe.presentation.zoomRois;
if all([rois.width] == 1) && all([rois.height] == 1) && ...
        isequal([rois.xZeroBased], [0, 1]) && isequal([rois.yZeroBased], [0, 1])
    for k = 1:2
        rois(k).width = max(1, floor(size(panels.global, 2) / 4));
        rois(k).height = max(1, floor(size(panels.global, 1) / 5));
        rois(k).xZeroBased = floor(size(panels.global, 2) / 4);
        rois(k).yZeroBased = min(size(panels.global, 1) - rois(k).height, ...
            floor(k * size(panels.global, 1) / 4));
    end
end
ui.figure.WindowState = 'maximized';
if windowed
    ui.body.RowHeight = {150, '1x'};
    ui.controls.RowHeight = {27, 27, 27, 27};
else
    ui.body.RowHeight = {84, '1x'};
    ui.controls.RowHeight = {27, 27};
end
ui.controls.RowSpacing = 5;
ui.plots.RowHeight = {'7x', '3x'};
ui.plots.Padding = [0, 0, 0, 0];
ui.plots.RowSpacing = 6;
ui.plots.ColumnSpacing = 10;
names = {'thorcam', 'global', 'local'};
labels = {'ThorCam', 'Global-stage average', 'Final rectified image'};
axesHandles = gobjects(2, 3);
imageHandles = gobjects(2, 3);
for rowIndex = 1:2
    for columnIndex = 1:3
        ax = uiaxes(ui.plots, 'Tag', sprintf('zoom-view-%d-%d', rowIndex, columnIndex));
        ax.Layout.Row = rowIndex;
        ax.Layout.Column = columnIndex;
        axesHandles(rowIndex, columnIndex) = ax;
        if rowIndex == 1
            imageHandles(rowIndex, columnIndex) = imshow(panels.(names{columnIndex}), 'Parent', ax);
            title(ax, labels{columnIndex});
        else
            % A retained region may be outside a newly reduced crop. Open the
            % editor anyway so the user can repair it before validation passes.
            imageHandles(rowIndex, columnIndex) = imshow(zeros(2, 'uint8'), 'Parent', ax);
            title(ax, 'Adjust regions to preview');
        end
        ax.Toolbar.Visible = 'off';
        if isprop(ax, 'LooseInset'), ax.LooseInset = [4, 4, 4, 24]; end
    end
end
boxes = gobjects(2, 3);
for k = 1:2
    roi = rois(k);
    for column = 1:3
        boxes(k, column) = drawrectangle(axesHandles(1, column), ...
            'Position', [roi.xZeroBased + 1, roi.yZeroBased + 1, roi.width, roi.height], ...
            'Color', triofig.roiDisplayColor(roi.color), 'Label', sprintf('%d', k), ...
            'InteractionsAllowed', 'none', 'DrawingArea', 'unlimited');
    end
    boxes(k, 2).InteractionsAllowed = 'all';
end
uilabel(ui.controls, 'Text', 'Active region');
selector = uidropdown(ui.controls, 'Items', {'1', '2'}, 'Value', '1', ...
    'Tag', 'zoom-selector', 'ValueChangedFcn', @(~, ~) selectRegion());
text = uilabel(ui.controls, 'Text', 'X / Y are one-based pixels in the exported, upsampled panel.');
text.Layout.Column = [3, 8];
fields = gobjects(1, 4);
tags = {'x', 'y', 'width', 'height'};
labels = {'X', 'Y', 'Width', 'Height'};
for k = 1:4
    text = uilabel(ui.controls, 'Text', labels{k}); text.Layout.Row = 2; text.Layout.Column = 2 * k - 1;
    fields(k) = uieditfield(ui.controls, 'text', 'Tag', ['zoom-' tags{k}], ...
        'ValueChangedFcn', @(~, ~) fromFields());
    fields(k).Layout.Row = 2; fields(k).Layout.Column = 2 * k;
end
contrast = gobjects(0);
windowFields = struct();
if windowed
    contrastLabel = uilabel(ui.controls, 'Text', 'Zoom contrast');
    contrastLabel.Layout.Row = 3; contrastLabel.Layout.Column = 1;
    contrast = uidropdown(ui.controls, 'Items', {'Inherit main panels', 'Per region'}, ...
        'ItemsData', {'inherit', 'perRegion'}, 'Value', zoomState.mode, ...
        'Tag', 'zoom-contrast-mode', 'ValueChangedFcn', @(~, ~) changeContrast());
    contrast.Layout.Row = 3; contrast.Layout.Column = [2, 3];
    autoButton = uibutton(ui.controls, 'Text', 'Auto (this region)', 'Tag', 'zoom-auto', ...
        'Tooltip', 'Recompute this region''s windows from the percentiles of its pixels.', ...
        'ButtonPushedFcn', @(~, ~) pressAuto());
    autoButton.Layout.Row = 3; autoButton.Layout.Column = [4, 5];
    hint = uilabel(ui.controls, 'WordWrap', 'on', ...
        'Text', 'Per region: ThorCam gets its own window; global-stage and final share one. Insets are marked in the figure.');
    hint.Layout.Row = 3; hint.Layout.Column = [6, 8];
    windowFields.thorcamBlack = zoomWindowField(4, 2, 'zoom-thorcam-black', 'ThorCam black');
    windowFields.thorcamWhite = zoomWindowField(4, 3, 'zoom-thorcam-white', 'ThorCam white');
    windowFields.flfmBlack = zoomWindowField(4, 5, 'zoom-flfm-black', 'FLFM black');
    windowFields.flfmWhite = zoomWindowField(4, 6, 'zoom-flfm-white', 'FLFM white');
    thorcamLabel = uilabel(ui.controls, 'Text', 'ThorCam window');
    thorcamLabel.Layout.Row = 4; thorcamLabel.Layout.Column = 1;
    flfmLabel = uilabel(ui.controls, 'Text', 'FLFM window');
    flfmLabel.Layout.Row = 4; flfmLabel.Layout.Column = 4;
end
for k = 1:2
    addlistener(boxes(k, 2), 'MovingROI', @(source, ~) fromBox(source, k));
    addlistener(boxes(k, 2), 'ROIMoved', @(source, ~) fromBox(source, k));
    addlistener(boxes(k, 2), 'ROIClicked', @(~, ~) activateRegion(k));
end
active = 1;
read = @readRecipe;
fillFields();
refresh();

    function field = zoomWindowField(row, column, tag, tooltip)
        field = uieditfield(ui.controls, 'numeric', 'Tag', tag, 'Tooltip', tooltip, ...
            'ValueDisplayFormat', '%.5g', 'ValueChangedFcn', @(~, ~) editWindow(tag));
        field.Layout.Row = row; field.Layout.Column = column;
    end

    function fillFields()
        roi = rois(active);
        values = [roi.xZeroBased + 1, roi.yZeroBased + 1, roi.width, roi.height];
        for n = 1:4
            fields(n).Value = num2str(values(n));
        end
        fillWindowFields();
    end

    function fillWindowFields()
        if ~windowed, return; end
        region = zoomState.regions([zoomState.regions.id] == rois(active).id);
        windowFields.thorcamBlack.Value = region.thorcam.black;
        windowFields.thorcamWhite.Value = region.thorcam.white;
        windowFields.flfmBlack.Value = region.flfm.black;
        windowFields.flfmWhite.Value = region.flfm.white;
        perRegion = strcmp(zoomState.mode, 'perRegion');
        for name = fieldnames(windowFields).'
            windowFields.(name{1}).Enable = matlab.lang.OnOffSwitchState(perRegion);
        end
    end

    function selectRegion()
        try
            storeFields();
            active = str2double(selector.Value);
            fillFields();
            refresh();
        catch cause
            selector.Value = num2str(active);
            ui.report(cause.message, false);
        end
    end

    function storeFields()
        position = arrayfun(@(field) str2double(field.Value), fields);
        rois(active) = triofig.setupRectangle('zoom', position, size(panels.global), active);
    end

    function changeContrast()
        zoomState.mode = contrast.Value;
        fillWindowFields();
        refresh();
    end

    function pressAuto()
        index = [zoomState.regions.id] == rois(active).id;
        zoomState.regions(index).thorcam.auto = true;
        zoomState.regions(index).flfm.auto = true;
        refresh();
    end

    function editWindow(tag)
        index = [zoomState.regions.id] == rois(active).id;
        region = zoomState.regions(index);
        switch tag
            case 'zoom-thorcam-black'
                region.thorcam.black = windowFields.thorcamBlack.Value; region.thorcam.auto = false;
            case 'zoom-thorcam-white'
                region.thorcam.white = windowFields.thorcamWhite.Value; region.thorcam.auto = false;
            case 'zoom-flfm-black'
                region.flfm.black = windowFields.flfmBlack.Value; region.flfm.auto = false;
            case 'zoom-flfm-white'
                region.flfm.white = windowFields.flfmWhite.Value; region.flfm.auto = false;
        end
        zoomState.regions(index) = region;
        refresh();
    end

    function candidate = readRecipe()
        storeFields();
        triofig.extractZooms(panels, rois);
        candidate = recipe;
        candidate.presentation.zoomRois = rois;
        if windowed
            state = zoomState;
            state.regions = triofig.resolveRegionWindows(state.regions, rois, upsampled);
            for regionIndex = 1:numel(state.regions)
                region = state.regions(regionIndex);
                if region.thorcam.white <= region.thorcam.black || region.flfm.white <= region.flfm.black
                    error('triofig:InvalidRecipe', ...
                        'Region %d needs zoom windows with white above black.', region.id);
                end
            end
            candidate.presentation.display.zoom = state;
        end
    end

    function fromFields()
        refresh();
    end

    function fromBox(source, index)
        active = index;
        selector.Value = num2str(index);
        for n = 1:4
            fields(n).Value = num2str(source.Position(n), 12);
        end
        refresh();
    end

    function activateRegion(index)
        selector.Value = num2str(index);
        selectRegion();
    end

    function refresh()
        try
            candidate = readRecipe();
            if windowed
                zoomState = candidate.presentation.display.zoom;
                fillWindowFields();
                if strcmp(zoomState.mode, 'perRegion')
                    zooms = triofig.extractDisplayZooms(prepared, candidate.presentation, upsampled);
                else
                    zooms = triofig.extractZooms(panels, candidate.presentation.zoomRois);
                end
            else
                zooms = triofig.extractZooms(panels, candidate.presentation.zoomRois);
            end
            for regionIndex = 1:2
                rectangle = rois(regionIndex);
                for panelIndex = 1:3
                    boxes(regionIndex, panelIndex).Position = [rectangle.xZeroBased + 1, ...
                        rectangle.yZeroBased + 1, rectangle.width, rectangle.height];
                end
            end
            for panelIndex = 1:3
                image = zooms.(sprintf('%s_zoom_%d', names{panelIndex}, active));
                handle = imageHandles(2, panelIndex);
                handle.CData = image;
                handle.XData = [1, size(image, 2)];
                handle.YData = [1, size(image, 1)];
                xlim(axesHandles(2, panelIndex), [.5, size(image, 2) + .5]);
                ylim(axesHandles(2, panelIndex), [.5, size(image, 1) + .5]);
                title(axesHandles(2, panelIndex), sprintf('Region %d · %s', active, rois(active).color));
            end
            ui.report('Drag or select either box on the middle image. The lower row shows the active region across all three images.', true);
        catch cause
            ui.report(cause.message, false);
        end
    end
end
