function result = run_figure_replay(varargin)
%RUN_FIGURE_REPLAY Compatibility entry point for the June 3 dense4 scene.
%   New figures should use replay_trio_figure with their own trio-recipe.json.

scriptRoot = fileparts(mfilename('fullpath'));
pipelineRoot = fileparts(scriptRoot);
repositoryRoot = fileparts(fileparts(fileparts(scriptRoot)));
recipePath = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
addpath(pipelineRoot);
arguments = varargin;
dataRoot = '';
if ~isempty(arguments) && ~isReplayOption(arguments{1})
    dataRoot = arguments{1};
    arguments = arguments(2:end);
end
if strlength(string(dataRoot)) == 0
    dataRoot = getenv('EYEDROP_20260603_DATA_ROOT');
end
if strlength(string(dataRoot)) == 0
    error('eyedrop_replay:MissingInput', ...
        'Provide the existing June 3 data root or set EYEDROP_20260603_DATA_ROOT.');
end
result = replay_trio_figure(recipePath, dataRoot, arguments{:});
result.configPath = recipePath;
result.comparison = result.candidateComparison;
end

function result = isReplayOption(value)
result = (ischar(value) || isstring(value)) && ismember(lower(string(value)), ...
    ["outputdirectory", "referencedirectory", "publish", "compilerexecutable"]);
end
