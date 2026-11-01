function [info, completed] = recover_trio_run_info(dataRoot, workspacePath, varargin)
%RECOVER_TRIO_RUN_INFO Review run metadata when the original manifest is absent.
%   Called by SETUP_TRIO_FIGURE after selecting the reconstruction workspace.
%   Returns reviewed metadata; never writes a replacement experiment manifest.
%   DialogFcn is an injectable inputdlg-compatible callback for automation.

parser = inputParser;
addParameter(parser, 'DialogFcn', @inputdlg, @(value) isa(value, 'function_handle'));
addParameter(parser, 'RequiredVariables', ...
    {'average_rectified_global_image', 'average_rectified_image', 'config_json'}, ...
    @(value) iscell(value) && all(cellfun(@(item) ischar(item) || isstring(item), value)));
parse(parser, varargin{:});
dialog = parser.Results.DialogFcn;
required = parser.Results.RequiredVariables;
info = [];
completed = false;
if ~isfile(workspacePath)
    error('triofig:MissingInput', 'Required workspace is missing: %s', workspacePath);
end
workspaceRelativePath = triofig.relativeToRoot(dataRoot, workspacePath);
variables = {whos('-file', workspacePath).name};
for index = 1:numel(required)
    if ~ismember(required{index}, variables)
        error('triofig:InvalidWorkspace', 'Workspace is missing required variable: %s', required{index});
    end
end
metadata = load(workspacePath, 'config_json');
generationId = 'unknown';
generationSource = 'unknown';
stageId = 'unknown';
stageSource = 'unknown';
note = 'Original experiment manifest unavailable; run metadata reviewed during trio setup.';
try
    config = jsondecode(char(string(metadata.config_json)));
    [generationId, generationSource] = configIdentifier(config, ...
        {'generation_id'}, workspaceRelativePath);
    [stageId, stageSource] = configIdentifier(config, ...
        {'stage1_run_id', 'run_id'}, workspaceRelativePath);
catch
    note = [note ' config_json could not be parsed for run identifiers.'];
end

% Paths provide suggestions only; the operator reviews them before use.
runDirectory = strrep(fileparts(workspaceRelativePath), char(92), '/');
if isempty(runDirectory)
    runDirectory = '.';
end
tokens = regexp(workspaceRelativePath, ...
    '^(.*)/runs/[^/]+/([^/]+)/[^/]+/workspace\.mat$', 'tokens', 'once');
if ~isempty(tokens)
    runDirectory = tokens{1};
    if strcmp(stageId, 'unknown')
        stageId = tokens{2};
        stageSource = ['Reviewed workspace path: ' workspaceRelativePath];
    end
end
if strcmp(generationId, 'unknown')
    token = regexp(workspaceRelativePath, ...
        '(?:^|/)generations/([^/]+)(?:/|$)', 'tokens', 'once');
    if ~isempty(token)
        generationId = token{1};
        generationSource = ['Reviewed workspace path: ' workspaceRelativePath];
    end
end
runDirectorySource = ['Reviewed workspace directory: ' workspaceRelativePath];
suggestedGenerationId = generationId;
suggestedStageId = stageId;
suggestedRunDirectory = runDirectory;
answers = dialog({ ...
    'Generation ID (leave blank or enter unknown if unavailable):', ...
    'Evidence for generation ID (file/log/notebook reference, or unknown):', ...
    'Candidate/run ID (leave blank or enter unknown if unavailable):', ...
    'Evidence for candidate/run ID (file/log/notebook reference, or unknown):', ...
    'Available run directory relative to dataRoot:', ...
    'Evidence for run directory:', ...
    'Recovery note (known gaps or limitations):'}, ...
    'Missing manifest: review run information', [1, 90], ...
    {generationId, generationSource, stageId, stageSource, ...
    runDirectory, runDirectorySource, note});
if isempty(answers)
    return;
end
generationId = knownOrUnknown(answers{1});
stageId = knownOrUnknown(answers{3});
runDirectory = strtrim(answers{5});
if isempty(runDirectory)
    error('triofig:InvalidRunInfo', 'The available run directory is required.');
end
% This is a location, so require an existing directory beneath dataRoot.
runPath = fullfile(dataRoot, runDirectory);
if ~isfolder(runPath)
    error('triofig:InvalidRunInfo', 'The available run directory does not exist: %s', runPath);
end
runDirectory = triofig.relativeToRoot(dataRoot, runPath);
info = struct( ...
    'generationId', generationId, ...
    'generationIdSource', evidenceFor(generationId, answers{2}, ...
        suggestedGenerationId, generationSource), ...
    'stageId', stageId, ...
    'stageIdSource', evidenceFor(stageId, answers{4}, ...
        suggestedStageId, stageSource), ...
    'availableRunRelativePath', runDirectory, ...
    'availableRunSource', evidenceFor(runDirectory, answers{6}, ...
        suggestedRunDirectory, runDirectorySource), ...
    'workspaceRelativePath', workspaceRelativePath, ...
    'workspaceSha256', triofig.fileSha256(workspacePath), ...
    'note', knownOrUnknown(answers{7}));
completed = true;
end

function [value, source] = configIdentifier(config, names, path)
value = 'unknown';
source = 'unknown';
if ~isstruct(config) || ~isscalar(config)
    return;
end
for index = 1:numel(names)
    name = names{index};
    if isfield(config, name) && (ischar(config.(name)) || isstring(config.(name))) && ...
            isscalar(string(config.(name))) && strlength(strtrim(string(config.(name)))) > 0
        value = knownOrUnknown(config.(name));
        if ~strcmp(value, 'unknown')
            source = [path ': config_json.' name];
            return;
        end
    end
end
end

function value = knownOrUnknown(value)
value = strtrim(char(string(value)));
if isempty(value) || strcmpi(value, 'unknown')
    value = 'unknown';
end
end

function source = evidenceFor(value, source, suggestedValue, suggestedSource)
source = knownOrUnknown(source);
if strcmp(value, 'unknown')
    source = 'unknown';
elseif ~strcmp(value, suggestedValue) && strcmp(source, suggestedSource)
    source = 'User supplied; evidence unknown';
end
end
