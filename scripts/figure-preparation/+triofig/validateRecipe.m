function validateRecipe(recipe)
%VALIDATERECIPE Reject incomplete or unsupported recipe data before replay.

if ~isstruct(recipe) || ~isfield(recipe, 'schemaVersion') || recipe.schemaVersion ~= 2
    error('triofig:InvalidRecipe', 'Expected a schemaVersion 2 trio-figure recipe.');
end
requireText(recipe, 'sceneId');
requireText(recipe, 'candidateOutputRelativePath');
if ~startsWith(strrep(recipe.candidateOutputRelativePath, char(92), '/'), ...
        'candidate-outputs/figures-source/')
    error('triofig:InvalidRecipe', ...
        'candidateOutputRelativePath must be under candidate-outputs/figures-source.');
end

requiredInput = {'mainCaptureRelativePath', 'thorcamCaptureRelativePath', ...
    'validationCaptureRelativePath', 'runManifestRelativePath', ...
    'workspaceRelativePath', 'expectedGenerationId', 'requiredWorkspaceVariables'};
requireStructFields(recipe, 'input', requiredInput);
for index = 1:6
    requireText(recipe.input, requiredInput{index});
end
if ~iscell(recipe.input.requiredWorkspaceVariables) || isempty(recipe.input.requiredWorkspaceVariables)
    error('triofig:InvalidRecipe', 'requiredWorkspaceVariables must be a nonempty list.');
end

requireStructFields(recipe, 'cameraPreparation', {'thorcam', 'validation'});
validateCamera(recipe.cameraPreparation.thorcam, 'thorcam');
validateCamera(recipe.cameraPreparation.validation, 'validation');

requireStructFields(recipe, 'registration', {'transformSource', 'cropMode', ...
    'crop', 'requireExpectedCrop', 'savedTransforms'});
if ~ismember(recipe.registration.transformSource, {'automatic', 'saved'})
    error('triofig:InvalidRecipe', 'transformSource must be automatic or saved.');
end
if ~ismember(recipe.registration.cropMode, {'intersection', 'saved'})
    error('triofig:InvalidRecipe', 'cropMode must be intersection or saved.');
end
validateCrop(recipe.registration.crop);
if ~islogical(recipe.registration.requireExpectedCrop) && ...
        ~(isnumeric(recipe.registration.requireExpectedCrop) && isscalar(recipe.registration.requireExpectedCrop))
    error('triofig:InvalidRecipe', 'requireExpectedCrop must be logical.');
end
if strcmp(recipe.registration.transformSource, 'saved')
    transforms = recipe.registration.savedTransforms;
    requireStructFields(struct('savedTransforms', transforms), 'savedTransforms', ...
        {'thorcamRotationDegrees', 'thorcamTranslationXY', ...
        'validationRotationDegrees', 'validationTranslationXY'});
    validateTranslation(transforms.thorcamTranslationXY, 'thorcamTranslationXY');
    validateTranslation(transforms.validationTranslationXY, 'validationTranslationXY');
end

requireStructFields(recipe, 'presentation', {'upsampleFactor', ...
    'intensityMultipliers', 'zoomRois'});
if ~isnumeric(recipe.presentation.upsampleFactor) || ...
        ~isscalar(recipe.presentation.upsampleFactor) || recipe.presentation.upsampleFactor <= 0
    error('triofig:InvalidRecipe', 'upsampleFactor must be positive.');
end
validateIntensity(recipe.presentation.intensityMultipliers);
rois = recipe.presentation.zoomRois;
if ~isstruct(rois) || numel(rois) ~= 2
    error('triofig:InvalidRecipe', 'Exactly two zoom ROIs are required for a trio bundle.');
end
ids = zeros(1, numel(rois));
for index = 1:numel(rois)
    requireStructFields(struct('roi', rois(index)), 'roi', ...
        {'id', 'xZeroBased', 'yZeroBased', 'width', 'height', 'color'});
    values = [rois(index).xZeroBased, rois(index).yZeroBased, ...
        rois(index).width, rois(index).height];
    if any(~isfinite(values)) || any(values < 0) || ...
            rois(index).width <= 0 || rois(index).height <= 0 || ...
            values(1) ~= floor(values(1)) || values(2) ~= floor(values(2)) || ...
            values(3) ~= floor(values(3)) || values(4) ~= floor(values(4))
        error('triofig:InvalidRecipe', 'Zoom ROIs must have positive integer pixel bounds.');
    end
    ids(index) = rois(index).id;
end
if ~isequal(sort(ids), 1:2)
    error('triofig:InvalidRecipe', 'Zoom ROI ids must be 1 and 2.');
end

requireStructFields(recipe, 'figure', {'id', 'assetDirectoryFromWrapper', ...
    'mainWidthCm', 'zoomWidthCm'});
requireText(recipe.figure, 'id');
requireText(recipe.figure, 'assetDirectoryFromWrapper');
if recipe.figure.mainWidthCm <= 0 || recipe.figure.zoomWidthCm <= 0
    error('triofig:InvalidRecipe', 'Figure widths must be positive.');
end
end

function validateCamera(camera, name)
requireStructFields(struct('camera', camera), 'camera', ...
    {'rotationDegrees', 'flipVertical', 'downsampleFactor'});
if ~isnumeric(camera.rotationDegrees) || ~isscalar(camera.rotationDegrees) || ...
        ~isfinite(camera.rotationDegrees) || ~isnumeric(camera.downsampleFactor) || ...
        ~isscalar(camera.downsampleFactor) || camera.downsampleFactor <= 0 || ...
        camera.downsampleFactor > 1
    error('triofig:InvalidRecipe', 'Invalid %s camera preparation settings.', name);
end
end

function validateCrop(crop)
requireStructFields(struct('crop', crop), 'crop', ...
    {'rowStartOneBased', 'columnStartOneBased', 'height', 'width'});
values = [crop.rowStartOneBased, crop.columnStartOneBased, crop.height, crop.width];
if any(~isfinite(values)) || any(values < 1) || any(values ~= floor(values))
    error('triofig:InvalidRecipe', 'Crop bounds must be positive integer pixels.');
end
end

function validateTranslation(value, name)
if ~isnumeric(value) || numel(value) ~= 2 || any(~isfinite(value))
    error('triofig:InvalidRecipe', '%s must contain two finite coordinates.', name);
end
end

function validateIntensity(intensity)
required = {'globalLocal', 'thorcam', 'validation'};
for index = 1:numel(required)
    if ~isfield(intensity, required{index}) || ...
            ~isnumeric(intensity.(required{index})) || ...
            ~isscalar(intensity.(required{index})) || ...
            ~isfinite(intensity.(required{index})) || intensity.(required{index}) <= 0
        error('triofig:InvalidRecipe', 'Intensity multiplier %s must be positive.', required{index});
    end
end
end

function requireText(container, field)
if ~isfield(container, field) || ~(ischar(container.(field)) || isstring(container.(field))) || ...
        strlength(string(container.(field))) == 0
    error('triofig:InvalidRecipe', '%s must be nonempty text.', field);
end
end

function requireStructFields(container, field, fields)
if ~isfield(container, field) || ~isstruct(container.(field))
    error('triofig:InvalidRecipe', '%s must be a structure.', field);
end
value = container.(field);
for index = 1:numel(fields)
    if ~isfield(value, fields{index})
        error('triofig:InvalidRecipe', '%s is missing %s.', field, fields{index});
    end
end
end
