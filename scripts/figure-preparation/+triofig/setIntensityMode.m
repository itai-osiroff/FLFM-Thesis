function recipe = setIntensityMode(recipe, mode)
%SETINTENSITYMODE Opt in to schema 5, copying the visible gain when linking changes.
[effective, previous] = triofig.resolveIntensity(recipe.presentation);
if strcmp(previous, mode), return; end
if strcmp(mode, 'separate')
    if recipe.schemaVersion == 2
        % Schema 2 always requires an authentic manifest; retain that boundary.
        recipe.reconstruction.manifestStatus = 'present';
        recipe.reconstruction.stageId = '';
    end
    if recipe.schemaVersion < 5
        recipe.input.workspaceMode = 'shared';
        recipe.input.workspaceSha256 = 'unknown';
        recipe.input.localWorkspaceRelativePath = recipe.input.workspaceRelativePath;
        recipe.input.localWorkspaceSha256 = recipe.input.workspaceSha256;
        recipe.input.localRunManifestRelativePath = recipe.input.runManifestRelativePath;
        recipe.input.expectedLocalGenerationId = recipe.input.expectedGenerationId;
        local = struct('manifestStatus', recipe.reconstruction.manifestStatus, ...
            'stageId', recipe.reconstruction.stageId, ...
            'availableRunRelativePath', recipe.reconstruction.availableRunRelativePath, ...
            'manifestRecordedRunRelativePath', recipe.reconstruction.manifestRecordedRunRelativePath);
        if isfield(recipe.reconstruction, 'recovery')
            local.recovery = recipe.reconstruction.recovery;
        end
        recipe.reconstruction.localWorkspace = local;
    end
    recipe.schemaVersion = max(recipe.schemaVersion, 5);
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
