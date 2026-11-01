function prepared = setupPreview(data, recipe, useCrop)
%SETUPPREVIEW Cache geometry; presentation-only edits never rerun alignment.
if nargin < 3 || ~useCrop
    recipe.registration.cropMode = 'intersection';
    recipe.registration.requireExpectedCrop = false;
end
recipe.presentation.intensityMultipliers = struct('globalLocal', 1, 'thorcam', 1, 'validation', 1);
if recipe.schemaVersion >= 4
    recipe.presentation.intensityMode = 'linked';
    recipe.presentation.intensityMultipliers.global = 1;
    recipe.presentation.intensityMultipliers.local = 1;
end
key = jsonencode(struct('camera', recipe.cameraPreparation, 'registration', recipe.registration));
if isKey(data.cache, key)
    prepared = data.cache(key);
else
    prepared = triofig.preparePanels(data.globalImage, data.localImage, ...
        data.thorcam, data.validation, recipe);
    % Bound memory while still retaining the current geometry between dialogs.
    if data.cache.Count >= 4
        remove(data.cache, keys(data.cache));
    end
    data.cache(key) = prepared;
end
end
