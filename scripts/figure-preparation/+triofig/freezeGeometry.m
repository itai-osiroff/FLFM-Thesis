function recipe = freezeGeometry(recipe, data)
%FREEZEGEOMETRY Record a recipe's resolved registration and crop as saved values.
% Runs preparePanels once with the recipe as given (automatic estimation is
% deterministic), then stores the resulting rotations, translations and crop.
% Replaying the frozen recipe reproduces the same registered crops, so a new
% setup seeded from an old figure starts on the Display step with geometry intact.

prepared = triofig.preparePanels(data.globalImage, data.localImage, ...
    data.thorcam, data.validation, recipe);
registration = prepared.registration;
recipe.registration.transformSource = 'saved';
recipe.registration.savedTransforms = struct( ...
    'thorcamRotationDegrees', registration.thorcamRotationDegrees, ...
    'thorcamTranslationXY', registration.thorcamTranslationXY, ...
    'validationRotationDegrees', registration.validationRotationDegrees, ...
    'validationTranslationXY', registration.validationTranslationXY);
recipe.registration.cropMode = 'saved';
recipe.registration.requireExpectedCrop = false;
recipe.registration.crop = prepared.crop;
end
