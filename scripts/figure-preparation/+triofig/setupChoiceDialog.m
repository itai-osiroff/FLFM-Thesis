function answer = setupChoiceDialog(message, titleText, options, response)
%SETUPCHOICEDIALOG Use explicit callbacks, including when no desktop is shown.
asynchronous = nargin == 4;
answer = '';
fig = uifigure('Name', titleText, 'Position', [250, 250, 650, 290], ...
    'Tag', 'setup-choice', 'WindowStyle', 'modal');
grid = uigridlayout(fig, [2, 1], 'RowHeight', {'1x', 42});
uilabel(grid, 'Text', message, 'WordWrap', 'on', 'FontSize', 14);
buttons = uigridlayout(grid, [1, numel(options)]);
for k = 1:numel(options)
    uibutton(buttons, 'Text', options{k}, 'Tag', sprintf('setup-choice-%d', k), ...
        'ButtonPushedFcn', @(~, ~) choose(k));
end
fig.CloseRequestFcn = @(~, ~) choose(0);
if asynchronous, return; end
uiwait(fig);
delete(fig);

    function choose(index)
        if index > 0, answer = options{index}; end
        if asynchronous
            delete(fig);
            response(answer);
        else
            uiresume(fig);
        end
    end
end
