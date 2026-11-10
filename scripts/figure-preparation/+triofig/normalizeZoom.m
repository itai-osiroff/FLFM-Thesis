function recipe = normalizeZoom(recipe)
%NORMALIZEZOOM Bring a schema-6 recipe's zoom block to per-cell views.
% Recipes written before per-cell views carry display.zoom.mode ('inherit' or
% 'perRegion'). perRegion becomes view='separate' for every cell and inherit
% becomes view='inherit'; the mode field is dropped. Cells that already have a
% view are kept. Recipes without a display block (schemas 2-5) pass through.

if ~isstruct(recipe) || ~isfield(recipe, 'presentation') || ...
        ~isfield(recipe.presentation, 'display') || ...
        ~isfield(recipe.presentation.display, 'zoom') || ...
        ~isfield(recipe.presentation.display.zoom, 'regions')
    return;
end
zoom = recipe.presentation.display.zoom;
legacyView = 'inherit';
if isfield(zoom, 'mode')
    if strcmp(zoom.mode, 'perRegion'), legacyView = 'separate'; end
    zoom = rmfield(zoom, 'mode');
end
for index = 1:numel(zoom.regions)
    for cell = {'thorcam', 'flfm'}
        if ~isfield(zoom.regions(index).(cell{1}), 'view')
            zoom.regions(index).(cell{1}).view = legacyView;
        end
    end
end
recipe.presentation.display.zoom = zoom;
end
