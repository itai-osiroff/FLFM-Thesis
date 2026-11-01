function draft = newSetupDraft(recipe, dataRoot, selected)
%NEWSETUPDRAFT Capture setup choices without creating a figure generation.
if recipe.schemaVersion >= 5
    if ~isfield(selected, 'localWorkspace') && strcmp(recipe.input.workspaceMode, 'shared')
        selected.localWorkspace = selected.workspace;
    end
    if ~isfield(selected, 'localRunManifest') && strcmp(recipe.input.workspaceMode, 'shared')
        selected.localRunManifest = selected.runManifest;
    end
    globalHash = triofig.fileSha256(selected.workspace);
    localHash = triofig.fileSha256(selected.localWorkspace);
    if strcmp(recipe.input.workspaceSha256, 'unknown')
        recipe.input.workspaceSha256 = globalHash;
    elseif ~strcmpi(recipe.input.workspaceSha256, globalHash)
        error('triofig:DraftInputMismatch', 'Selected global workspace differs from the recipe hash.');
    end
    if strcmp(recipe.input.localWorkspaceSha256, 'unknown')
        recipe.input.localWorkspaceSha256 = localHash;
    elseif ~strcmpi(recipe.input.localWorkspaceSha256, localHash)
        error('triofig:DraftInputMismatch', 'Selected local workspace differs from the recipe hash.');
    end
end
roles = fieldnames(selected);
identities = struct();
for k = 1:numel(roles)
    role = roles{k};
    path = selected.(role);
    if isempty(path)
        identities.(role) = struct('relativePath', '', 'sha256', '');
    else
        identities.(role) = struct('relativePath', triofig.relativeToRoot(dataRoot, path), ...
            'sha256', triofig.fileSha256(path));
    end
end
draft = struct('schemaVersion', 1, 'recipe', recipe, 'dataRoot', char(dataRoot), ...
    'selected', selected, 'identities', identities, 'accepted', false(1, 6), ...
    'step', 1, 'updatedAt', '');
end
