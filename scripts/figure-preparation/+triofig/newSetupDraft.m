function draft = newSetupDraft(recipe, dataRoot, selected)
%NEWSETUPDRAFT Capture setup choices without creating a figure generation.
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
