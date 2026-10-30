function recipe = setIntensityMode(recipe, mode)
%SETINTENSITYMODE Opt in to v4, copying the visible gain when linking changes.
[effective, previous] = triofig.resolveIntensity(recipe.presentation);
if strcmp(previous, mode), return; end
if strcmp(mode, 'separate')
    if recipe.schemaVersion == 2
        % Schema 2 always requires an authentic manifest; retain that boundary.
        recipe.reconstruction.manifestStatus = 'present';
        recipe.reconstruction.stageId = '';
    end
    recipe.schemaVersion = 4;
    recipe.presentation.intensityMode = 'separate';
    recipe.presentation.intensityMultipliers.global = effective.global;
    recipe.presentation.intensityMultipliers.local = effective.global;
elseif strcmp(mode, 'linked')
    recipe.presentation.intensityMode = 'linked';
    recipe.presentation.intensityMultipliers.globalLocal = effective.global;
else
    error('triofig:InvalidRecipe', 'Intensity mode must be linked or separate.');
end
end
