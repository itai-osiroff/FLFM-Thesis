function read = setupZoomDialog(ui, recipe, data)
%SETUPZOOMDIALOG Keep both zoom regions editable and compare matching crops.
% With window display mapping each zoom region has two cells, ThorCam and FLFM
% (global-stage and final, which share one window so their comparison stays
% fair). A cell's view is Inherit (main-panel window), Separate (its own window)
% or Both (upper inset inherited, a lower copy on its own window).
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
plotRows = 2;
if windowed
    plotRows = 3;
    ui.body.RowHeight = {150, '1x'};
    ui.controls.RowHeight = {27, 27, 27, 27};
    ui.plots.RowHeight = {'6x', '3x', '3x'};
else
    ui.body.RowHeight = {84, '1x'};
    ui.controls.RowHeight = {27, 27};
    ui.plots.RowHeight = {'7x', '3x'};
end
ui.controls.RowSpacing = 5;
ui.plots.Padding = [0, 0, 0, 0];
ui.plots.RowSpacing = 6;
ui.plots.ColumnSpacing = 10;
names = {'thorcam', 'global', 'local'};
labels = {'ThorCam', 'Global-stage average', 'Final rectified image'};
axesHandles = gobjects(plotRows, 3);
imageHandles = gobjects(plotRows, 3);
for rowIndex = 1:plotRows
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
cellControls = struct();
if windowed
    cellControls.thorcam = zoomCellRow(3, 'ThorCam inset', 'thorcam');
    cellControls.flfm = zoomCellRow(4, 'Global-stage + final', 'flfm');
    autoButton = uibutton(ui.controls, 'Text', 'Auto (this region)', 'Tag', 'zoom-auto', ...
        'Tooltip', 'Recompute this region''s windows from the percentiles of its pixels.', ...
        'ButtonPushedFcn', @(~, ~) pressAuto());
    autoButton.Layout.Row = 4; autoButton.Layout.Column = [6, 7];
    hint = uilabel(ui.controls, 'WordWrap', 'on', ...
        'Text', 'Both: upper inset keeps the main-panel window; the lower copy uses this window.');
    hint.Layout.Row = 3; hint.Layout.Column = [6, 8];
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

    function controls = zoomCellRow(row, caption, key)
        label = uilabel(ui.controls, 'Text', caption);
        label.Layout.Row = row; label.Layout.Column = 1;
        view = uidropdown(ui.controls, 'Items', {'Inherit', 'Separate', 'Both'}, ...
            'ItemsData', {'inherit', 'separate', 'both'}, 'Value', 'inherit', ...
            'Tag', ['zoom-' key '-view'], 'ValueChangedFcn', @(~, ~) changeView(key));
        view.Layout.Row = row; view.Layout.Column = [2, 3];
        black = uieditfield(ui.controls, 'numeric', 'Tag', ['zoom-' key '-black'], ...
            'Tooltip', [caption ' black level (source units)'], 'ValueDisplayFormat', '%.5g', ...
            'ValueChangedFcn', @(~, ~) editWindow(key));
        black.Layout.Row = row; black.Layout.Column = 4;
        white = uieditfield(ui.controls, 'numeric', 'Tag', ['zoom-' key '-white'], ...
            'Tooltip', [caption ' white level (source units)'], 'ValueDisplayFormat', '%.5g', ...
            'ValueChangedFcn', @(~, ~) editWindow(key));
        white.Layout.Row = row; white.Layout.Column = 5;
        controls = struct('view', view, 'black', black, 'white', white);
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
        for key = {'thorcam', 'flfm'}
            cellState = region.(key{1});
            controls = cellControls.(key{1});
            controls.view.Value = cellState.view;
            controls.black.Value = cellState.black;
            controls.white.Value = cellState.white;
            enabled = matlab.lang.OnOffSwitchState(~strcmp(cellState.view, 'inherit'));
            controls.black.Enable = enabled;
            controls.white.Enable = enabled;
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

    function changeView(key)
        index = [zoomState.regions.id] == rois(active).id;
        zoomState.regions(index).(key).view = cellControls.(key).view.Value;
        fillWindowFields();
        refresh();
    end

    function pressAuto()
        index = [zoomState.regions.id] == rois(active).id;
        zoomState.regions(index).thorcam.auto = true;
        zoomState.regions(index).flfm.auto = true;
        refresh();
    end

    function editWindow(key)
        index = [zoomState.regions.id] == rois(active).id;
        cellState = zoomState.regions(index).(key);
        cellState.black = cellControls.(key).black.Value;
        cellState.white = cellControls.(key).white.Value;
        cellState.auto = false;
        zoomState.regions(index).(key) = cellState;
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
            extras = struct();
            if windowed
                zoomState = candidate.presentation.display.zoom;
                fillWindowFields();
                [zooms, extras] = triofig.extractZoomSet(prepared, panels, candidate.presentation, upsampled);
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
                name = sprintf('%s_zoom_%d', names{panelIndex}, active);
                showZoom(2, panelIndex, zooms.(name), sprintf('Region %d · %s', active, rois(active).color));
                if windowed
                    if isfield(extras, [name '_emphasis'])
                        showZoom(3, panelIndex, extras.([name '_emphasis']), ...
                            sprintf('Region %d · lower copy', active));
                    else
                        showZoom(3, panelIndex, zeros(2, 'uint8'), 'No second copy');
                    end
                end
            end
            ui.report('Drag or select either box on the middle image. The lower rows show the active region across all three images.', true);
        catch cause
            ui.report(cause.message, false);
        end
    end

    function showZoom(rowIndex, panelIndex, image, caption)
        handle = imageHandles(rowIndex, panelIndex);
        handle.CData = image;
        handle.XData = [1, size(image, 2)];
        handle.YData = [1, size(image, 1)];
        xlim(axesHandles(rowIndex, panelIndex), [.5, size(image, 2) + .5]);
        ylim(axesHandles(rowIndex, panelIndex), [.5, size(image, 1) + .5]);
        title(axesHandles(rowIndex, panelIndex), caption);
    end
end
