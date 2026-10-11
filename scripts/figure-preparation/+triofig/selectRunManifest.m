function [path, completed] = selectRunManifest(dataRoot, state, varargin)
%SELECTRUNMANIFEST Select an authentic manifest or explicitly recover without it.
parser = inputParser;
addParameter(parser, 'ChoiceFcn', @questdlg, @(value) isa(value, 'function_handle'));
addParameter(parser, 'FileFcn', @uigetfile, @(value) isa(value, 'function_handle'));
addParameter(parser, 'ListFcn', @listdlg, @(value) isa(value, 'function_handle'));
parse(parser, varargin{:});
dialogs = parser.Results;
path = '';
completed = false;
if strcmp(state.status, 'single')
    answer = dialogs.ChoiceFcn(sprintf('Run manifest candidate:\n%s', state.candidates{1}), ...
        'Run identity', 'Use manifest', 'Recover run info', 'Cancel', 'Use manifest');
    if strcmp(answer, 'Use manifest')
        path = state.candidates{1};
        completed = true;
    elseif strcmp(answer, 'Recover run info')
        completed = true;
    end
    return;
elseif strcmp(state.status, 'ambiguous')
    choices = [state.candidates(:); {'No matching manifest: recover run info'}];
    [selection, completed] = dialogs.ListFcn( ...
        'PromptString', 'Select the matching manifest, or recover without one:', ...
        'SelectionMode', 'single', 'ListString', choices, 'ListSize', [900, 300]);
    if completed && selection <= numel(state.candidates)
        path = state.candidates{selection};
    end
    return;
end
answer = dialogs.ChoiceFcn('No experiment manifest was found. Browse for it or recover run information?', ...
    'Missing run manifest', 'Recover run info', 'Browse', 'Cancel', 'Recover run info');
if strcmp(answer, 'Recover run info')
    completed = true;
elseif strcmp(answer, 'Browse')
    [filename, folder] = dialogs.FileFcn({'*.json', 'JSON manifests'}, ...
        'Select the matching run manifest', dataRoot);
    if ~isequal(filename, 0)
        path = fullfile(folder, filename);
        completed = true;
    end
end
end
