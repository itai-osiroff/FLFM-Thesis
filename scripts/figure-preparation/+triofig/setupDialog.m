function [recipe, action] = setupDialog(step, recipe, data, pendingCheckpoint)
%SETUPDIALOG Shared navigation and safe closing for sequential review dialogs.
if nargin < 4, pendingCheckpoint = false; end
titles = {'Camera preparation', 'Alignment', 'Common crop', 'Display', 'Zoom regions', 'Final review'};
original = recipe;
action = 'close';
fig = uifigure('Name', sprintf('Trio figure — %d/6: %s', step, titles{step}), ...
    'Position', [60, 60, 1280, 860], 'Tag', 'trio-setup');
cleanup = onCleanup(@() deleteIfValid(fig));
grid = uigridlayout(fig, [4, 1], 'RowHeight', {38, '1x', 55, 46});
uilabel(grid, 'Text', sprintf('%d of 6  ·  %s', step, titles{step}), ...
    'FontSize', 20, 'FontWeight', 'bold');
body = uigridlayout(grid, [2, 1], 'RowHeight', {150, '1x'});
controls = uigridlayout(body, [3, 8], 'RowHeight', {45, 45, '1x'});
plotGrid = uigridlayout(body, [1, 3]);
note = uilabel(grid, 'Text', 'Changes are checkpointed when you choose Next.', ...
    'WordWrap', 'on', 'Tag', 'setup-message');
footer = uigridlayout(grid, [1, 4], 'ColumnWidth', {110, '1x', 150, 130});
back = uibutton(footer, 'Text', 'Back', 'Tag', 'setup-back', ...
    'ButtonPushedFcn', @(~, ~) navigate('back'));
if step == 1
    back.Enable = 'off';
end
uilabel(footer, 'Text', '');
uibutton(footer, 'Text', 'Save and Close', 'Tag', 'setup-save', ...
    'ButtonPushedFcn', @(~, ~) navigate('save'));
next = uibutton(footer, 'Text', 'Next', 'Tag', 'setup-next', ...
    'ButtonPushedFcn', @(~, ~) navigate('next'));
if step == 6
    next.Text = 'Generate';
end
ui = struct('figure', fig, 'body', body, 'controls', controls, 'plots', plotGrid, ...
    'message', note, 'next', next, 'report', @report);
switch step
    case 1
        read = triofig.setupCameraDialog(ui, recipe, data);
    case 2
        read = triofig.setupAlignmentDialog(ui, recipe, data);
    case 3
        read = triofig.setupCropDialog(ui, recipe, data);
    case 4
        read = triofig.setupBrightnessDialog(ui, recipe, data);
    case 5
        read = triofig.setupZoomDialog(ui, recipe, data);
    case 6
        read = triofig.setupReviewDialog(ui, recipe, data);
end
fig.CloseRequestFcn = @(~, ~) closeDialog();
uiwait(fig);
deleteIfValid(fig);

    function report(message, valid)
        note.Text = message;
        next.Enable = matlab.lang.OnOffSwitchState(valid);
        if valid
            note.FontColor = [.15, .25, .2];
        else
            note.FontColor = [.75, .15, .1];
        end
    end

    function navigate(destination)
        try
            candidate = read();
        catch cause
            report(cause.message, false);
            if strcmp(destination, 'back')
                triofig.setupChoiceDialog('Discard invalid edits in this step and go back?', ...
                    'Invalid edits', {'Discard edits', 'Keep editing'}, @discardAndBack);
            end
            return;
        end
        recipe = candidate;
        action = destination;
        uiresume(fig);
    end

    function closeDialog()
        try
            candidate = read();
            dirty = pendingCheckpoint || ~isequaln(candidate, original);
        catch
            dirty = true;
            candidate = [];
        end
        if dirty
            if isempty(candidate)
                options = {'Discard edits', 'Keep editing'};
            else
                options = {'Save edits', 'Discard edits', 'Keep editing'};
            end
            triofig.setupChoiceDialog('Close setup? Your last checkpoint is retained.', ...
                'Pause figure setup', options, @(answer) finishClose(answer, candidate));
            return;
        end
        uiresume(fig);
    end

    function discardAndBack(answer)
        if strcmp(answer, 'Discard edits')
            recipe = original;
            action = 'back';
            uiresume(fig);
        end
    end

    function finishClose(answer, candidate)
        if isempty(answer) || strcmp(answer, 'Keep editing'), return; end
        if strcmp(answer, 'Save edits')
            recipe = candidate;
            action = 'save';
        end
        uiresume(fig);
    end
end

function deleteIfValid(fig)
if isvalid(fig)
    delete(fig);
end
end
