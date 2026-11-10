function recipe = upgradeRecipe(recipe)
%UPGRADERECIPE Return an equivalent schema-6 recipe from schema 2-5 input.
% The result uses display.method = 'legacyMinMax', so replay reproduces the
% original pixels. The input recipe value is never modified on disk.

if recipe.schemaVersion >= 6, return; end
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
if ~isfield(recipe.presentation, 'intensityMode')
    recipe.presentation.intensityMode = 'linked';
end
recipe.schemaVersion = 6;
recipe.presentation.display = triofig.displayDefaults('legacyMinMax');
end
