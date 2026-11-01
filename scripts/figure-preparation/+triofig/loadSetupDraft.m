function [draft, issue] = loadSetupDraft(path, dataRoot)
%LOADSETUPDRAFT Read a checkpoint and verify inputs before rebuilding previews.
draft = [];
issue = '';
if ~isfile(path)
    return;
end
try
    value = jsondecode(fileread(path));
    assert(isstruct(value) && isscalar(value) && value.schemaVersion == 1);
    assert(isscalar(value.step) && ismember(value.step, 1:6));
    assert(islogical(value.accepted) && numel(value.accepted) == 6);
    triofig.validateRecipe(value.recipe);
    roles = {'main', 'thorcam', 'validation', 'workspace', 'runManifest'};
    inputFields = {'mainCaptureRelativePath', 'thorcamCaptureRelativePath', ...
        'validationCaptureRelativePath', 'workspaceRelativePath', 'runManifestRelativePath'};
    if value.recipe.schemaVersion >= 5
        roles = [roles, {'localWorkspace', 'localRunManifest'}];
        inputFields = [inputFields, {'localWorkspaceRelativePath', 'localRunManifestRelativePath'}];
    end
    assert(ischar(value.dataRoot) && isstruct(value.identities));
    problems = {};
    for k = 1:numel(roles)
        role = roles{k};
        identity = value.identities.(role);
        assert(ischar(identity.relativePath) && ischar(identity.sha256));
        configured = value.recipe.input.(inputFields{k});
        assert(strcmp(strrep(configured, char(92), '/'), strrep(identity.relativePath, char(92), '/')), ...
            'The recipe and checkpoint input identity disagree.');
        if value.recipe.schemaVersion >= 5 && ismember(role, {'workspace','localWorkspace'})
            hashField = 'workspaceSha256';
            if strcmp(role, 'localWorkspace'), hashField = 'localWorkspaceSha256'; end
            assert(strcmpi(value.recipe.input.(hashField), identity.sha256), ...
                'The recipe and checkpoint workspace hashes disagree.');
        end
        if isempty(identity.relativePath)
            assert(ismember(role, {'runManifest', 'localRunManifest'}));
            value.selected.(role) = '';
            continue;
        end
        resolved = char(java.io.File(fullfile(dataRoot, identity.relativePath)).getCanonicalPath());
        % Check containment with the same policy used by setup input selection.
        triofig.relativeToRoot(dataRoot, resolved);
        value.selected.(role) = resolved;
        if ~isfile(resolved)
            problems{end + 1} = [role ': input is missing']; %#ok<AGROW>
        elseif ~strcmp(triofig.fileSha256(resolved), identity.sha256)
            problems{end + 1} = [role ': input has changed']; %#ok<AGROW>
        end
    end
    value.accepted = reshape(value.accepted, 1, 6);
    value.dataRoot = char(dataRoot);
    draft = value;
    issue = strjoin(problems, newline);
catch cause
    draft = [];
    issue = ['The setup draft could not be read. Start fresh or restore a backup. ' cause.message];
end
end
