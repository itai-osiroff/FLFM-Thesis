function [mapped, info] = applyDisplay(crops, presentation)
%APPLYDISPLAY Window-mapped display images from raw registered crops (schema 6).
% crops: struct with double fields global, local, thorcam (and validation).
% Order: optional background subtraction and smoothing, black/white window,
% clip, optional gamma. FLFM settings apply identically to the global-stage
% and final images. info.source holds the processed, unwindowed float images.

display = presentation.display;
[~, mode] = triofig.resolveIntensity(presentation);
roles = display.roles;
if strcmp(mode, 'separate')
    windows = struct('global', roles.global, 'local', roles.local, 'thorcam', roles.thorcam);
else
    windows = struct('global', roles.flfm, 'local', roles.flfm, 'thorcam', roles.thorcam);
end
groups = struct('global', 'flfm', 'local', 'flfm', 'thorcam', 'thorcam');

source = struct();
mapped = struct();
stats = struct();
for name = {'thorcam', 'global', 'local'}
    key = name{1};
    processing = display.processing.(groups.(key));
    source.(key) = triofig.processDisplay(crops.(key), processing);
    [mapped.(key), lowPercent, highPercent] = triofig.windowImage( ...
        source.(key), windows.(key), processing);
    stats.(key) = struct('clippedLowPercent', lowPercent, ...
        'clippedHighPercent', highPercent, ...
        'occupiedLevels', numel(unique(round(mapped.(key) * 255))), ...
        'sourceMean', mean(source.(key)(:)));
end
if isfield(crops, 'validation')
    validation = double(crops.validation);
    span = max(validation(:)) - min(validation(:));
    if span > 0
        validation = (validation - min(validation(:))) ./ span;
    else
        validation = zeros(size(validation));
    end
    mapped.validation = validation;
end

info = struct('method', 'window', 'mode', mode, 'windows', windows, ...
    'processing', display.processing, 'source', source, 'stats', stats, ...
    'zoom', display.zoom);
end
