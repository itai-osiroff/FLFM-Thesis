function selected = startFromInputs(recipe, dataRoot)
%STARTFROMINPUTS Locate a seeded recipe's capture and workspace files under dataRoot.
% Every recorded input must exist. Empty run-manifest paths (recovered runs)
% stay empty, matching the selection struct that setup builds interactively.

selected = struct();
paths = struct( ...
    'main', recipe.input.mainCaptureRelativePath, ...
    'thorcam', recipe.input.thorcamCaptureRelativePath, ...
    'validation', recipe.input.validationCaptureRelativePath, ...
    'workspace', recipe.input.workspaceRelativePath, ...
    'runManifest', recipe.input.runManifestRelativePath, ...
    'localWorkspace', recipe.input.localWorkspaceRelativePath, ...
    'localRunManifest', recipe.input.localRunManifestRelativePath);
for role = fieldnames(paths).'
    name = role{1};
    relative = char(string(paths.(name)));
    if isempty(relative)
        selected.(name) = '';
        continue;
    end
    absolute = fullfile(dataRoot, strrep(relative, '/', filesep));
    if ~isfile(absolute)
        error('triofig:MissingInput', ...
            'The source recipe''s %s input was not found under the data root: %s', name, absolute);
    end
    selected.(name) = absolute;
end
end
