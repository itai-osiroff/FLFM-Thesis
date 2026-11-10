function text = displayCaption(display)
%DISPLAYCAPTION One sentence disclosing how the exported panels were scaled.
% Built from the manifest display record so the caption cannot drift from the
% pixels. Authors paste or adapt it into the figure caption.

windows = display.windows;
unit = 'source counts';
fmt = @(window) sprintf('%.4g to %.4g', window.black, window.white);
if strcmp(display.mode, 'separate')
    flfm = sprintf('the global-stage panel is shown over %s and the final panel over %s %s', ...
        fmt(windows.global), fmt(windows.local), unit);
else
    flfm = sprintf('the global-stage and final panels share one linear display window of %s %s', ...
        fmt(windows.global), unit);
end
text = sprintf('Display scaling: %s; the ThorCam panel is shown over its own window of %s %s.', ...
    flfm, fmt(windows.thorcam), unit);

operations = {};
for group = {'flfm', 'thorcam'}
    processing = display.processing.(group{1});
    label = group{1};
    if strcmp(label, 'flfm'), label = 'FLFM'; else, label = 'ThorCam'; end
    if processing.background.enabled
        operations{end + 1} = sprintf('%s background subtraction (Gaussian, sigma %g px)', ...
            label, processing.background.sigmaPixels); %#ok<AGROW>
    end
    if processing.smoothing.enabled
        operations{end + 1} = sprintf('%s Gaussian smoothing (sigma %g px)', ...
            label, processing.smoothing.sigmaPixels); %#ok<AGROW>
    end
    if processing.gamma.enabled && processing.gamma.value ~= 1
        operations{end + 1} = sprintf('%s gamma %g', label, processing.gamma.value); %#ok<AGROW>
    end
end
if isempty(operations)
    text = [text ' No smoothing, background subtraction, or gamma was applied.'];
else
    text = [text ' Display-only processing: ' strjoin(operations, '; ') '.'];
end
if triofig.hasSeparateZoom(display)
    clauses = {};
    stacked = false;
    cellLabels = struct('thorcam', 'ThorCam', 'flfm', 'global-stage and final');
    for index = 1:numel(display.zoom.regions)
        region = display.zoom.regions(index);
        for cell = {'thorcam', 'flfm'}
            current = region.(cell{1});
            switch current.view
                case 'separate'
                    clauses{end + 1} = sprintf('region %d %s inset%s scaled to %s', region.id, ...
                        cellLabels.(cell{1}), plural(cell{1}), fmt(current)); %#ok<AGROW>
                case 'both'
                    stacked = true;
                    clauses{end + 1} = sprintf(['region %d %s inset%s shown twice: the upper copy uses ' ...
                        'the main-panel window and the lower copy is rescaled to %s'], region.id, ...
                        cellLabels.(cell{1}), plural(cell{1}), fmt(current)); %#ok<AGROW>
            end
        end
    end
    text = [text ' Zoom insets: ' strjoin(clauses, '; ') ' ' unit '.'];
    if stacked
        text = [text ' The lower copy emphasizes the zoomed feature and is not comparable in brightness with the upper copy.'];
    end
    text = [text ' Within each region the global-stage and final insets share one window.'];
end
end

function suffix = plural(cell)
suffix = '';
if strcmp(cell, 'flfm'), suffix = 's'; end
end
