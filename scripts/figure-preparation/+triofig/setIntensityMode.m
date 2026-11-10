function recipe = setIntensityMode(recipe, mode)
%SETINTENSITYMODE Switch linked/separate intermediate-final display, copying the visible value.
% Opting into separate mode upgrades older recipes to schema 6 (legacyMinMax),
% which reproduces their original pixels.
[effective, previous] = triofig.resolveIntensity(recipe.presentation);
if strcmp(previous, mode), return; end
windowed = recipe.schemaVersion >= 6 && strcmp(recipe.presentation.display.method, 'window');
if strcmp(mode, 'separate')
    recipe = triofig.upgradeRecipe(recipe);
    recipe.presentation.intensityMode = 'separate';
    recipe.presentation.intensityMultipliers.global = effective.global;
    recipe.presentation.intensityMultipliers.local = effective.global;
    if windowed
        roles = recipe.presentation.display.roles;
        roles.global = roles.flfm;
        roles.local = roles.flfm;
        recipe.presentation.display.roles = roles;
    end
elseif strcmp(mode, 'linked')
    recipe.presentation.intensityMode = 'linked';
    recipe.presentation.intensityMultipliers.globalLocal = effective.global;
    if windowed
        recipe.presentation.display.roles.flfm = recipe.presentation.display.roles.global;
    end
else
    error('triofig:InvalidRecipe', 'Intensity mode must be linked or separate.');
end
end
