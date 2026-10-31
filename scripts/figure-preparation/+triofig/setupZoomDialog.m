function read = setupZoomDialog(ui, recipe, data)
%SETUPZOOMDIALOG Keep both zoom regions editable and compare matching crops.
baseline = triofig.setupPreview(data, recipe, true);
prepared = triofig.applySetupIntensity(baseline, recipe.presentation);
panels = triofig.renderPanels(prepared, recipe.presentation.upsampleFactor);
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
ui.body.RowHeight = {84, '1x'};
ui.controls.RowHeight = {27, 27};
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
for k = 1:2
    addlistener(boxes(k, 2), 'MovingROI', @(source, ~) fromBox(source, k));
    addlistener(boxes(k, 2), 'ROIMoved', @(source, ~) fromBox(source, k));
    addlistener(boxes(k, 2), 'ROIClicked', @(~, ~) activateRegion(k));
end
active = 1;
read = @readRecipe;
fillFields();
refresh();

    function fillFields()
        roi = rois(active);
        values = [roi.xZeroBased + 1, roi.yZeroBased + 1, roi.width, roi.height];
        for n = 1:4
            fields(n).Value = num2str(values(n));
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

    function candidate = readRecipe()
        storeFields();
        triofig.extractZooms(panels, rois);
        candidate = recipe;
        candidate.presentation.zoomRois = rois;
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
            zooms = triofig.extractZooms(panels, candidate.presentation.zoomRois);
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
