function result = run_figure_replay(dataRoot, varargin)
%RUN_FIGURE_REPLAY Compatibility entry point for the June 3 dense4 scene.
%   New figures should use replay_trio_figure with their own trio-recipe.json.

scriptRoot = fileparts(mfilename('fullpath'));
pipelineRoot = fileparts(scriptRoot);
repositoryRoot = fileparts(fileparts(fileparts(scriptRoot)));
recipePath = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
addpath(pipelineRoot);
result = replay_trio_figure(recipePath, dataRoot, varargin{:});
result.configPath = recipePath;
result.comparison = result.candidateComparison;
end
