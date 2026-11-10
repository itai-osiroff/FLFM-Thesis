function read = setupBrightnessDialog(ui, recipe, data)
%SETUPBRIGHTNESSDIALOG Display step: window mapping, or legacy min/max for older recipes.
% Schema-6 'window' recipes use setupDisplayDialog. Older recipes and
% 'legacyMinMax' keep the original gain dialog. Either dialog can switch the
% recipe to the other mapping; this dispatcher rebuilds the step in place.
reader = [];
build(recipe);
read = @() reader();

    function build(current)
        delete(ui.controls.Children);
        delete(ui.plots.Children);
        ui.controls.RowHeight = {45, 45, '1x'};
        ui.body.RowHeight = {150, '1x'};
        stepUi = ui;
        stepUi.switchMapping = @switchMapping;
        if current.schemaVersion >= 6 && strcmp(current.presentation.display.method, 'window')
            reader = triofig.setupDisplayDialog(stepUi, current, data);
        else
            reader = triofig.setupLegacyBrightnessDialog(stepUi, current, data);
        end
    end

    function switchMapping(candidate, target)
        baseline = triofig.setupPreview(data, candidate, true);
        build(triofig.convertMapping(candidate, target, baseline));
    end
end
