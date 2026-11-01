function [recipe, selected, completed] = setupInputs(dataRoot, sceneId, figureId)
%SETUPINPUTS Discover files and retain independently reviewed workspace identity.
recipe = []; selected = struct(); completed = false;
discovery = triofig.discoverInputs(dataRoot, sceneId);
choice = questdlg(['Use one reconstruction workspace for both averages?' newline ...
    'Separate workspaces can be selected for the uncommon cross-run comparison.'], ...
    'Choose reconstruction workspaces', 'One workspace', 'Separate workspaces', 'One workspace');
if isempty(choice), return; end
separate = strcmp(choice, 'Separate workspaces');

roles = {'main', 'thorcam', 'validation', 'workspace', 'runManifest'};
for index = 1:numel(roles)
    role = roles{index};
    if strcmp(role, 'runManifest')
        [path, accepted] = triofig.selectRunManifest(dataRoot, discovery.runManifest);
    else
        [path, accepted] = selectCandidate(dataRoot, role, discovery.(role));
    end
    if ~accepted, return; end
    selected.(role) = path;
end

if separate
    [selected.localWorkspace, accepted] = selectCandidate(dataRoot, 'local workspace', discovery.workspace);
    if ~accepted, return; end
    [selected.localRunManifest, accepted] = triofig.selectRunManifest(dataRoot, discovery.runManifest);
    if ~accepted, return; end
else
    selected.localWorkspace = selected.workspace;
    selected.localRunManifest = selected.runManifest;
end

recipe = triofig.defaultRecipe(sceneId, ['candidate-outputs/figures-source/' figureId]);
recipe.figure.id = figureId;
recipe.figure.assetDirectoryFromWrapper = ['./' figureId];
recipe.input.mainCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.main);
recipe.input.thorcamCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.thorcam);
recipe.input.validationCaptureRelativePath = triofig.relativeToRoot(dataRoot, selected.validation);
recipe.input.workspaceRelativePath = triofig.relativeToRoot(dataRoot, selected.workspace);
recipe.input.localWorkspaceRelativePath = triofig.relativeToRoot(dataRoot, selected.localWorkspace);
recipe.input.workspaceSha256 = triofig.fileSha256(selected.workspace);
recipe.input.localWorkspaceSha256 = triofig.fileSha256(selected.localWorkspace);
recipe.input.workspaceMode = 'shared';
if separate, recipe.input.workspaceMode = 'separate'; end

[globalRun, accepted] = workspaceRunInfo(dataRoot, selected.workspace, selected.runManifest, ...
    sceneId, 'average_rectified_global_image');
if ~accepted, recipe=[]; return; end
recipe.input.runManifestRelativePath = globalRun.manifestPath;
recipe.input.expectedGenerationId = globalRun.generationId;
recipe.reconstruction.manifestStatus = globalRun.manifestStatus;
recipe.reconstruction.stageId = globalRun.stageId;
recipe.reconstruction.availableRunRelativePath = globalRun.availableRunRelativePath;
recipe.reconstruction.manifestRecordedRunRelativePath = globalRun.manifestRecordedRunRelativePath;
if strcmp(globalRun.manifestStatus, 'absent'), recipe.reconstruction.recovery = globalRun.recovery; end
selected.runManifest = globalRun.manifestAbsolutePath;

if separate
    [localRun, accepted] = workspaceRunInfo(dataRoot, selected.localWorkspace, ...
        selected.localRunManifest, sceneId, 'average_rectified_image');
    if ~accepted, recipe=[]; return; end
    recipe.input.localRunManifestRelativePath = localRun.manifestPath;
    recipe.input.expectedLocalGenerationId = localRun.generationId;
    recipe.reconstruction.localWorkspace = rmfield(localRun, {'manifestPath','manifestAbsolutePath', ...
        'generationId','recovery'});
    if strcmp(localRun.manifestStatus, 'absent')
        recipe.reconstruction.localWorkspace.recovery = localRun.recovery;
    end
    selected.localRunManifest = localRun.manifestAbsolutePath;
else
    recipe.input.localRunManifestRelativePath = recipe.input.runManifestRelativePath;
    recipe.input.expectedLocalGenerationId = recipe.input.expectedGenerationId;
    recipe.reconstruction.localWorkspace = rmfield(globalRun, {'manifestPath','manifestAbsolutePath', ...
        'generationId','recovery'});
    if strcmp(globalRun.manifestStatus, 'absent')
        recipe.reconstruction.localWorkspace.recovery = globalRun.recovery;
    end
    selected.localRunManifest = selected.runManifest;
end
completed = true;
end

function [info, completed] = workspaceRunInfo(dataRoot, workspacePath, manifestPath, sceneId, averageVariable)
completed = false;
info = struct('manifestPath', '', 'manifestAbsolutePath', '', 'generationId', 'unknown', ...
    'manifestStatus', 'absent', 'stageId', 'unknown', 'availableRunRelativePath', ...
    triofig.relativeToRoot(dataRoot, fileparts(workspacePath)), ...
    'manifestRecordedRunRelativePath', '', 'recovery', struct());
if isempty(manifestPath)
    [info.recovery, completed] = recover_trio_run_info(dataRoot, workspacePath, ...
        'RequiredVariables', {averageVariable, 'config_json'});
    if ~completed, return; end
    info.generationId = info.recovery.generationId;
    info.stageId = info.recovery.stageId;
    info.availableRunRelativePath = info.recovery.availableRunRelativePath;
    return;
end
manifest = jsondecode(fileread(manifestPath));
manifestText = fileread(manifestPath);
if ~isfield(manifest, 'generation_id') || ...
        ~(ischar(manifest.generation_id) || isstring(manifest.generation_id)) || ...
        strlength(string(manifest.generation_id)) == 0 || ~contains(manifestText, sceneId)
    error('triofig:InvalidRunManifest', 'Selected manifest must identify the expected scene and generation: %s', manifestPath);
end
info.manifestPath = triofig.relativeToRoot(dataRoot, manifestPath);
info.manifestAbsolutePath = manifestPath;
info.generationId = char(string(manifest.generation_id));
info.manifestStatus = 'present';
info.availableRunRelativePath = triofig.relativeToRoot(dataRoot, fileparts(manifestPath));
info.manifestRecordedRunRelativePath = '';
try
    config = load(workspacePath, 'config_json');
    parsed = jsondecode(char(string(config.config_json)));
    for field = {'stage1_run_id','run_id'}
        if isfield(parsed, field{1}), info.stageId = char(string(parsed.(field{1}))); break; end
    end
catch
    % The manifest generation remains the required identity when stage metadata is unavailable.
end
completed = true;
end

function [path, accepted] = selectCandidate(dataRoot, role, state)
accepted = false; path = '';
if strcmp(state.status, 'single')
    path = state.candidates{1}; accepted = true; return;
end
if strcmp(state.status, 'ambiguous')
    [selection, accepted] = listdlg('PromptString', sprintf('Review the %s candidates and select one:', role), ...
        'SelectionMode', 'single', 'ListString', state.candidates, 'ListSize', [900, 300]);
    if accepted, path = state.candidates{selection}; end
    return;
end
if ismember(role, {'workspace', 'local workspace'})
    startDirectory = fullfile(dataRoot, 'algo_run');
    if ~isfolder(startDirectory), startDirectory = dataRoot; end
    filter = {'*.mat', 'MATLAB workspaces'};
else
    startDirectory = fullfile(dataRoot, role);
    if ~isfolder(startDirectory), startDirectory = dataRoot; end
    filter = {'*.tif;*.tiff;*.png;*.jpg;*.jpeg', 'Image files'};
end
[filename, folder] = uigetfile(filter, ...
    sprintf('Select the %s input', role), startDirectory);
if isequal(filename, 0), return; end
path = fullfile(folder, filename); accepted = true;
end
