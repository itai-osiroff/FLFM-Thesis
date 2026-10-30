function [prepared, clipping, masks] = applySetupIntensity(baseline, presentation)
%APPLYSETUPINTENSITY Map normalized, unclipped images exactly as preparePanels.
% The original multiplier-only argument remains supported for linked callers.
if ~isfield(presentation, 'intensityMultipliers')
    presentation = struct('intensityMultipliers', presentation);
end
multipliers = triofig.resolveIntensity(presentation);
prepared = baseline;
clipping = struct();
masks = struct();
names = {'thorcam', 'global', 'local', 'validation'};
for k = 1:numel(names)
    name = names{k};
    scaled = baseline.(name) * multipliers.(name);
    masks.(name) = scaled > 1 | scaled < 0;
    clipping.(name) = 100 * nnz(masks.(name)) / numel(scaled);
    prepared.(name) = min(max(scaled, 0), 1);
end
end
