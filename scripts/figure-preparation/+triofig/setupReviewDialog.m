function read = setupReviewDialog(ui, recipe, data)
%SETUPREVIEWDIALOG Review all exported images before creating a generation.
baseline = triofig.setupPreview(data, recipe, true);
prepared = triofig.presentPrepared(baseline, recipe);
[panels, zooms, extras] = triofig.presentZooms(prepared, recipe.presentation, recipe.schemaVersion);
% Stacked second versions get their own rows (4 and 5 are regions 1 and 2).
rows = 3;
ui.plots.RowHeight = {'2x', '1x', '1x'};
if ~isempty(fieldnames(extras))
    rows = 5;
    ui.plots.RowHeight = {'2x', '1x', '1x', '1x', '1x'};
end
names = {'thorcam', 'global', 'local'};
labels = {'ThorCam', 'Global-stage average', 'Final rectified image'};
for row = 1:rows
    for column = 1:3
        ax = uiaxes(ui.plots);
        ax.Layout.Row = row;
        ax.Layout.Column = column;
        if row > 3
            key = sprintf('%s_zoom_%d_emphasis', names{column}, row - 3);
            if isfield(extras, key)
                imshow(extras.(key), 'Parent', ax);
                title(ax, sprintf('Region %d · lower copy', row - 3));
            else
                axis(ax, 'off');
            end
        elseif row == 1
            imshow(panels.(names{column}), 'Parent', ax);
            title(ax, labels{column});
            for k = 1:2
                roi = recipe.presentation.zoomRois(k);
                drawrectangle(ax, 'Position', [roi.xZeroBased + 1, roi.yZeroBased + 1, roi.width, roi.height], ...
                    'Color', triofig.roiDisplayColor(roi.color), 'InteractionsAllowed', 'none', ...
                    'Label', sprintf('%d', k));
            end
        else
            imshow(zooms.(sprintf('%s_zoom_%d', names{column}, row - 1)), 'Parent', ax);
            title(ax, sprintf('Region %d', row - 1));
        end
    end
end
crop = recipe.registration.crop;
[effective, mode] = triofig.resolveIntensity(recipe.presentation);
brightness = sprintf('Brightness: intermediate %g×; final %g×; ThorCam %g× (%s).', ...
    effective.global, effective.local, effective.thorcam, mode);
if isfield(prepared, 'display')
    brightness = ['Display: ' triofig.displayCaption(prepared.display)];
end
summary = uilabel(ui.controls, 'WordWrap', 'on', 'Text', sprintf( ...
    'Crop: %d × %d pixels. Export upsampling: %g× (nearest).\n%s Main width: %g cm; zoom width: %g cm.\nThe PDF uses the saved LaTeX layout. Generating advances latest only when Publish is true; selected changes only by explicit selection.', ...
    crop.width, crop.height, recipe.presentation.upsampleFactor, brightness, ...
    recipe.figure.mainWidthCm, recipe.figure.zoomWidthCm));
summary.Layout.Row = [1, 3]; summary.Layout.Column = [1, 8];
ui.report('Review the three main images and both zoom rows. Generate creates a retained version and compiles its PDF.', true);
read = @() recipe;
end
