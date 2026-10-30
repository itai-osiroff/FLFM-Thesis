function app = launch_capture_editor(dataRoot, options)
%LAUNCH_CAPTURE_EDITOR Edit native captures without modifying source files.
% addpath('scripts/capture-editor'); launch_capture_editor(dataRoot)
arguments
    dataRoot = ''
    options.RecipePath = ''
    options.SessionPath = ''
    options.Visible = 'on'
end
if isempty(dataRoot)
    dataRoot = uigetdir(pwd,'Choose the capture data root');
    if isequal(dataRoot,0), app=[]; return; end
end
editorRoot=fileparts(mfilename('fullpath'));
addpath(fullfile(fileparts(editorRoot),'figure-preparation'));
app=captureedit.Editor(dataRoot,'Visible',options.Visible);
try
    if ~isempty(options.SessionPath)
        app.openSession(options.SessionPath);
    elseif ~isempty(options.RecipePath)
        app.importRecipe(options.RecipePath);
    end
catch cause
    delete(app.Figure); rethrow(cause);
end
if nargout==0, clear app; end
end
