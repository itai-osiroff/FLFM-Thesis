function showSetupResult(result)
%SHOWSETUPRESULT Open retained artifacts without changing selected exports.
fig = uifigure('Name', 'Trio figure · generation result', 'Position', [150, 150, 720, 330], ...
    'Tag', 'trio-setup-result');
grid = uigridlayout(fig, [3, 1], 'RowHeight', {45, '1x', 45});
uilabel(grid, 'Text', ['Generation ' result.status], 'FontSize', 20, 'FontWeight', 'bold');
message = ['Saved in: ' result.generationDirectory];
if ~strcmp(result.status, 'complete')
    message = sprintf('%s\n\n%s\n\nYour setup checkpoint is retained. Compiler logs, when available, are in build/compiler.log.', ...
        result.error.message, message);
end
uitextarea(grid, 'Value', splitlines(string(message)), 'Editable', 'off');
buttons = uigridlayout(grid, [1, 3]);
pdf = uibutton(buttons, 'Text', 'Open PDF', 'ButtonPushedFcn', @(~, ~) openPath(result.previewPath));
pdf.Enable = matlab.lang.OnOffSwitchState(~isempty(result.previewPath) && isfile(result.previewPath));
uibutton(buttons, 'Text', 'Show Output Folder', 'ButtonPushedFcn', @(~, ~) openPath(result.generationDirectory));
uibutton(buttons, 'Text', 'Close', 'ButtonPushedFcn', @(~, ~) delete(fig));

    function openPath(path)
        try
            winopen(path);
        catch cause
            uialert(fig, cause.message, 'Could not open artifact');
        end
    end
end
