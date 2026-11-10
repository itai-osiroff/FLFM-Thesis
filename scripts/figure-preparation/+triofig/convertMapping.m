function recipe = convertMapping(recipe, target, baseline)
%CONVERTMAPPING Switch a recipe between legacy min/max and window display mapping.
% To 'window': upgrades schemas 2-5 to 6 and seeds each window so the image
% initially looks like the legacy mapping (black = crop minimum, white =
% minimum + range / gain). All gains become 1, and every window is marked
% manual (auto = false) until the user presses Auto.
% To 'legacyMinMax': display gains reset to 1 on the shared normalization.
% baseline is the setupPreview result; its crops supply the legacy ranges.

recipe = triofig.upgradeRecipe(recipe);
display = recipe.presentation.display;
switch target
    case 'window'
        if strcmp(display.method, 'window'), return; end
        gains = recipe.presentation.intensityMultipliers;
        [effective, mode] = triofig.resolveIntensity(recipe.presentation);
        crops = baseline.crops;
        sharedMinimum = min([crops.global(:); crops.local(:)]);
        sharedMaximum = max([crops.global(:); crops.local(:)]);
        sharedRange = sharedMaximum - sharedMinimum;
        thorcamMinimum = min(crops.thorcam(:));
        thorcamRange = max(crops.thorcam(:)) - thorcamMinimum;
        if sharedRange <= 0 || thorcamRange <= 0
            error('triofig:FlatImage', 'Cannot seed a display window from an image with no intensity range.');
        end
        seed = @(window, minimum, range, gain) setWindow(window, minimum, minimum + range / gain);
        display.roles.flfm = seed(display.roles.flfm, sharedMinimum, sharedRange, effective.global);
        display.roles.global = seed(display.roles.global, sharedMinimum, sharedRange, effective.global);
        display.roles.local = seed(display.roles.local, sharedMinimum, sharedRange, effective.local);
        if strcmp(mode, 'separate')
            display.roles.flfm = display.roles.global;
        end
        display.roles.thorcam = seed(display.roles.thorcam, thorcamMinimum, thorcamRange, effective.thorcam);
        display.method = 'window';
        gains.globalLocal = 1; gains.thorcam = 1; gains.validation = 1;
        if isfield(gains, 'global'), gains.global = 1; end
        if isfield(gains, 'local'), gains.local = 1; end
        recipe.presentation.intensityMultipliers = gains;
    case 'legacyMinMax'
        display.method = 'legacyMinMax';
    otherwise
        error('triofig:InvalidRecipe', 'Mapping must be window or legacyMinMax.');
end
recipe.presentation.display = display;
end

function window = setWindow(window, black, white)
window.black = black;
window.white = white;
window.auto = false;
end
