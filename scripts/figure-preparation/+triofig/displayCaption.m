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
if isfield(display, 'zoom') && strcmp(display.zoom.mode, 'perRegion')
    parts = cell(1, numel(display.zoom.regions));
    for index = 1:numel(display.zoom.regions)
        region = display.zoom.regions(index);
        parts{index} = sprintf('region %d: ThorCam %s, FLFM %s', region.id, ...
            fmt(region.thorcam), fmt(region.flfm));
    end
    text = [text ' Zoom insets are scaled separately from the main panels (' ...
        strjoin(parts, '; ') ' ' unit '); within each region the global-stage and final insets share one window.'];
end
end
