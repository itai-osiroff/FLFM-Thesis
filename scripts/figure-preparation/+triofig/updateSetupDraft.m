function draft = updateSetupDraft(draft, recipe, step, action)
%UPDATESETUPDRAFT Preserve edits and invalidate approvals of dependent steps.
old = draft.recipe;
if ~isequaln(old.cameraPreparation, recipe.cameraPreparation) || ...
        ~isequaln(old.calibration, recipe.calibration)
    draft.accepted(:) = false;
elseif ~isequaln(old.registration.savedTransforms, recipe.registration.savedTransforms) || ...
        ~strcmp(old.registration.transformSource, recipe.registration.transformSource)
    draft.accepted(2:6) = false;
elseif ~isequaln(old.registration.crop, recipe.registration.crop) || ...
        ~strcmp(old.registration.cropMode, recipe.registration.cropMode)
    draft.accepted(3:6) = false;
end
if ~isequaln(old.presentation, recipe.presentation)
    draft.accepted(6) = false;
    [oldGains, oldMode] = triofig.resolveIntensity(old.presentation);
    [newGains, newMode] = triofig.resolveIntensity(recipe.presentation);
    if ~isequaln(oldGains, newGains) || ~strcmp(oldMode, newMode)
        draft.accepted(4) = false;
    end
    if ~isequaln(old.presentation.zoomRois, recipe.presentation.zoomRois) || ...
            old.presentation.upsampleFactor ~= recipe.presentation.upsampleFactor
        draft.accepted(5) = false;
    end
end
draft.recipe = recipe;
draft.step = step;
switch action
    case 'next'
        draft.accepted(step) = true;
        draft.step = min(step + 1, 6);
    case 'back'
        draft.step = max(step - 1, 1);
end
end
