function [recipe, selected, completed] = setupInputs(dataRoot, sceneId, figureId)
%SETUPINPUTS Discover the existing inputs and retain reviewed run identity.
recipe = [];
discovery = triofig.discoverInputs(dataRoot, sceneId);
[selected, completed] = selectInputs(dataRoot, discovery);
if ~completed
    return;
end
recipe = triofig.defaultRecipe(sceneId, ...
    ['candidate-outputs/figures-source/' figureId]);
recipe.figure.id = figureId;
recipe.figure.assetDirectoryFromWrapper = ['./' figureId];
recipe.input.mainCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.main);
recipe.input.thorcamCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.thorcam);
recipe.input.validationCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.validation);
recipe.input.workspaceRelativePath = triofig.relativeToRoot(dataRoot, selected.workspace);
if isempty(selected.runManifest)
    [info, completed] = recover_trio_run_info(dataRoot, selected.workspace);
    if ~completed
        return;
    end
    recipe.input.runManifestRelativePath = '';
    recipe.input.expectedGenerationId = info.generationId;
    recipe.reconstruction.manifestStatus = 'absent';
    recipe.reconstruction.availableRunRelativePath = info.availableRunRelativePath;
    recipe.reconstruction.stageId = info.stageId;
    recipe.reconstruction.recovery = info;
else
    recipe.input.runManifestRelativePath = triofig.relativeToRoot(dataRoot, selected.runManifest);
    recipe.reconstruction.availableRunRelativePath = triofig.relativeToRoot(dataRoot, ...
        fileparts(selected.runManifest));
    runManifest = jsondecode(fileread(selected.runManifest));
    if ~isfield(runManifest, 'generation_id') || ...
            ~(ischar(runManifest.generation_id) || isstring(runManifest.generation_id)) || ...
            strlength(string(runManifest.generation_id)) == 0
        error('triofig:InvalidRunManifest', ...
            'Selected run manifest has no generation_id: %s', selected.runManifest);
    end
    if ~contains(fileread(selected.runManifest), sceneId)
        error('triofig:InvalidRunManifest', ...
            'Selected run manifest does not mention the expected scene: %s', sceneId);
    end
    recipe.input.expectedGenerationId = runManifest.generation_id;
end
completed = true;
end

function [selected, completed] = selectInputs(dataRoot, discovery)
roles = {'main', 'thorcam', 'validation', 'workspace', 'runManifest'};
selected = struct();
completed = true;
for index = 1:numel(roles)
    role = roles{index};
    if strcmp(role, 'runManifest')
        [path, accepted] = triofig.selectRunManifest(dataRoot, discovery.(role));
    else
        [path, accepted] = selectCandidate(dataRoot, role, discovery.(role));
    end
    if ~accepted
        completed = false;
        return;
    end
    selected.(role) = path;
end
end

function [path, accepted] = selectCandidate(dataRoot, role, state)
accepted = false;
path = '';
if strcmp(state.status, 'single')
    path = state.candidates{1};
    accepted = true;
    return;
end
if strcmp(state.status, 'ambiguous')
    [selection, accepted] = listdlg( ...
        'PromptString', sprintf('Review the %s candidates and select one:', role), ...
        'SelectionMode', 'single', 'ListString', state.candidates, ...
        'ListSize', [900, 300]);
    if accepted
        path = state.candidates{selection};
    end
    return;
end
startDirectory = fullfile(dataRoot, role);
if ~isfolder(startDirectory)
    startDirectory = dataRoot;
end
switch role
    case {'main', 'thorcam', 'validation'}
        filter = {'*.tif;*.tiff;*.png;*.jpg;*.jpeg', 'Image files'};
    case 'workspace'
        filter = {'*.mat', 'MATLAB workspaces'};
    otherwise
        filter = {'*.json', 'JSON manifests'};
end
[filename, folder] = uigetfile(filter, sprintf('Select the %s input', role), startDirectory);
if isequal(filename, 0)
    return;
end
path = fullfile(folder, filename);
accepted = true;
end
