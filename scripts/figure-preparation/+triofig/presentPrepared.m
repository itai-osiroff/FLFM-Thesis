function [prepared, clipping, masks] = presentPrepared(baseline, recipe)
%PRESENTPREPARED Apply a recipe's presentation to a setupPreview baseline.
% Legacy (min/max + gain) recipes map through applySetupIntensity; schema-6
% window recipes map the raw crops through applyDisplay. Either way the
% result matches what preparePanels produces for replay.

presentation = recipe.presentation;
windowed = recipe.schemaVersion >= 6 && strcmp(presentation.display.method, 'window');
if ~windowed
    [prepared, clipping, masks] = triofig.applySetupIntensity(baseline, presentation);
    return;
end
[mapped, info] = triofig.applyDisplay(baseline.crops, presentation);
prepared = baseline;
for name = {'global', 'local', 'thorcam', 'validation'}
    prepared.(name{1}) = mapped.(name{1});
end
prepared.source = info.source;
prepared.display = rmfield(info, 'source');
clipping = struct();
masks = struct();
for name = {'global', 'local', 'thorcam'}
    stats = info.stats.(name{1});
    clipping.(name{1}) = stats.clippedLowPercent + stats.clippedHighPercent;
    window = info.windows.(name{1});
    scaled = (info.source.(name{1}) - window.black) ./ (window.white - window.black);
    masks.(name{1}) = scaled > 1 | scaled < 0;
end
end
