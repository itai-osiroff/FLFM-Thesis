function [effective, mode] = resolveIntensity(presentation)
%RESOLVEINTENSITY Resolve linked/independent display gains on a shared baseline.
mode = 'linked';
if isfield(presentation, 'intensityMode')
    mode = presentation.intensityMode;
end
if ~(ischar(mode) || (isstring(mode) && isscalar(mode))) || ...
        ~ismember(string(mode), ["linked", "separate"])
    error('triofig:InvalidRecipe', 'Intensity mode must be linked or separate.');
end
mode = char(mode);
gains = presentation.intensityMultipliers;
required = {'globalLocal', 'thorcam', 'validation'};
if strcmp(mode, 'separate')
    required = [required, {'global', 'local'}];
end
for k = 1:numel(required)
    name = required{k};
    if ~isfield(gains, name) || ~isnumeric(gains.(name)) || ~isscalar(gains.(name)) || ...
            ~isfinite(gains.(name)) || gains.(name) <= 0
        error('triofig:InvalidRecipe', 'Intensity multiplier %s must be finite and positive.', name);
    end
end
effective = struct('thorcam', gains.thorcam, 'global', gains.globalLocal, ...
    'local', gains.globalLocal, 'validation', gains.validation);
if strcmp(mode, 'separate')
    effective.global = gains.global;
    effective.local = gains.local;
end
end
