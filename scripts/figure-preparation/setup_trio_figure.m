function result = setup_trio_figure(dataRoot, varargin)
%SETUP_TRIO_FIGURE Review a trio with Back/Next and resumable checkpoints.
%   Existing name/value options retain their meanings. Drafts are local and
%   never advance latest or selected; only Generate invokes replay.
if nargin < 1 || strlength(string(dataRoot)) == 0
    dataRoot = getenv('TRIO_FIGURE_DATA_ROOT');
end
parser = inputParser;
parser.FunctionName = mfilename;
addParameter(parser, 'SceneId', '', @(v) ischar(v) || isstring(v));
addParameter(parser, 'FigureId', '', @(v) ischar(v) || isstring(v));
addParameter(parser, 'OutputDirectory', '', @(v) ischar(v) || isstring(v));
addParameter(parser, 'Publish', true, @(v) islogical(v) && isscalar(v));
addParameter(parser, 'CompilerExecutable', 'pdflatex', @(v) ischar(v) || isstring(v));
parse(parser, varargin{:});
options = parser.Results;
result = struct('cancelled', true, 'draftPath', '');
sceneId = char(string(options.SceneId));
if isempty(sceneId)
    answer = inputdlg('Scene ID used in the raw-data filenames:', 'Trio figure scene', [1, 80]);
    if isempty(answer), return; end
    sceneId = strtrim(answer{1});
end
figureId = char(string(options.FigureId));
if isempty(figureId)
    answer = inputdlg('Candidate figure ID:', 'Trio figure output', [1, 60], ...
        {regexprep(lower(sceneId), '[^a-z0-9_]+', '_')});
    if isempty(answer), return; end
    figureId = strtrim(answer{1});
end
if isempty(figureId)
    error('triofig:InvalidRecipe', 'A nonempty figure ID is required.');
end
repositoryRoot = fileparts(fileparts(fileparts(mfilename('fullpath'))));
outputDirectory = char(string(options.OutputDirectory));
if isempty(outputDirectory)
    outputDirectory = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', figureId);
end
draftPath = fullfile(outputDirectory, 'setup-draft.json');
result.draftPath = draftPath;
if strlength(string(dataRoot)) == 0 && isfile(draftPath)
    try
        saved = jsondecode(fileread(draftPath));
        dataRoot = saved.dataRoot;
    catch
        % A damaged draft must not prevent selection of a valid data root.
    end
end
if strlength(string(dataRoot)) == 0 || ~isfolder(dataRoot)
    selected = uigetdir(pwd, 'Select the external data root');
    if isequal(selected, 0), return; end
    dataRoot = selected;
end
dataRoot = char(string(dataRoot));
[draft, issue] = triofig.loadSetupDraft(draftPath, dataRoot);
if ~isempty(draft) && (~strcmp(draft.recipe.sceneId, sceneId) || ~strcmp(draft.recipe.figure.id, figureId))
    issue = 'The checkpoint belongs to a different scene or figure. Choose its original IDs or start fresh.';
end
if ~isempty(issue)
    answer = triofig.setupChoiceDialog([issue newline newline 'The existing checkpoint is retained until new inputs are accepted.'], ...
        'Setup draft needs attention', {'Start Fresh', 'Close'});
    if ~strcmp(answer, 'Start Fresh'), return; end
    draft = [];
elseif ~isempty(draft)
    answer = triofig.setupChoiceDialog(sprintf('Resume %s at step %d of 6?', figureId, draft.step), ...
        'Resume trio figure', {'Resume', 'Start Fresh', 'Cancel'});
    if strcmp(answer, 'Start Fresh')
        draft = [];
    elseif ~strcmp(answer, 'Resume')
        return;
    end
end
if isempty(draft)
    [recipe, selected, completed] = triofig.setupInputs(dataRoot, sceneId, figureId);
    if ~completed, return; end
    data = loadData(recipe, selected);
    for role = {'thorcam', 'validation'}
        name = role{1};
        settings = recipe.cameraPreparation.(name);
        image = imrotate(data.(name), settings.rotationDegrees);
        recipe.cameraPreparation.(name).downsampleFactor = min(1, median( ...
            [size(data.globalImage, 1) / size(image, 1), size(data.globalImage, 2) / size(image, 2)]));
    end
    draft = triofig.newSetupDraft(recipe, dataRoot, selected);
    triofig.saveSetupDraft(draftPath, draft);
else
    data = loadData(draft.recipe, draft.selected);
end
pendingCheckpoint = false;
while true
    step = draft.step;
    if step == 6 && ~all(draft.accepted(1:5))
        step = find(~draft.accepted(1:5), 1);
        draft.step = step;
    end
    [recipe, action] = triofig.setupDialog(step, draft.recipe, data, pendingCheckpoint);
    if strcmp(action, 'close'), return; end
    updated = triofig.updateSetupDraft(draft, recipe, step, action);
    try
        triofig.saveSetupDraft(draftPath, updated);
        pendingCheckpoint = false;
    catch cause
        triofig.setupChoiceDialog([cause.message newline 'Your previous checkpoint is intact. Return to the dialog to retry.'], ...
            'Checkpoint could not be saved', {'Return to step'});
        updated.step = step;
        draft = updated;
        pendingCheckpoint = true;
        continue;
    end
    draft = updated;
    if strcmp(action, 'save'), return; end
    if step == 6 && strcmp(action, 'next'), break; end
end
[~, issue] = triofig.loadSetupDraft(draftPath, dataRoot);
if ~isempty(issue)
    uiwait(errordlg([issue newline 'Setup is saved. Resolve the inputs before generating.'], ...
        'Inputs changed during setup', 'modal'));
    return;
end
temporaryRecipe = [tempname '.json'];
cleanup = onCleanup(@() deleteIfPresent(temporaryRecipe));
triofig.writeRecipe(temporaryRecipe, draft.recipe);
try
    result = replay_trio_figure(temporaryRecipe, dataRoot, ...
        'OutputDirectory', outputDirectory, 'Publish', options.Publish, ...
        'CompilerExecutable', options.CompilerExecutable);
catch cause
    uiwait(errordlg([cause.message newline 'The setup checkpoint is retained. Reopen setup to retry.'], ...
        'Generation could not start', 'modal'));
    rethrow(cause);
end
if strcmp(result.status, 'complete')
    lock = triofig.lockFigure(result.outputDirectory); %#ok<NASGU>
    copyfile(result.recipePath, fullfile(result.outputDirectory, 'trio-recipe.json'), 'f');
end
result.cancelled = false;
result.draftPath = draftPath;
triofig.showSetupResult(result);
end

function data = loadData(recipe, selected)
globalWorkspace = load(selected.workspace, 'average_rectified_global_image', 'config_json');
localPath = selected.workspace;
if recipe.schemaVersion >= 5 && strcmp(recipe.input.workspaceMode, 'separate')
    localPath = selected.localWorkspace;
end
localWorkspace = load(localPath, 'average_rectified_image', 'config_json');
data = struct('globalImage', globalWorkspace.average_rectified_global_image, ...
    'localImage', localWorkspace.average_rectified_image, ...
    'thorcam', imread(selected.thorcam), 'validation', imread(selected.validation), ...
    'cache', containers.Map('KeyType', 'char', 'ValueType', 'any'));
end

function deleteIfPresent(path)
if isfile(path), delete(path); end
end
