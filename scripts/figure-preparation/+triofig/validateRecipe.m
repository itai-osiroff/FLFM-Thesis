function validateRecipe(recipe)
%VALIDATERECIPE Reject incomplete or unsupported recipe data before replay.

if ~isstruct(recipe) || ~isscalar(recipe) || ~isfield(recipe, 'schemaVersion') || ...
        ~isnumeric(recipe.schemaVersion) || ~isscalar(recipe.schemaVersion) || ...
        ~ismember(recipe.schemaVersion, [2, 3])
    error('triofig:InvalidRecipe', 'Expected a schemaVersion 2 or 3 trio-figure recipe.');
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
    if recipe.schemaVersion == 3 && strcmp(requiredInput{index}, 'runManifestRelativePath')
        requireOptionalText(recipe.input, requiredInput{index});
    else
        requireText(recipe.input, requiredInput{index});
    end
end
if ~iscell(recipe.input.requiredWorkspaceVariables) || isempty(recipe.input.requiredWorkspaceVariables)
    error('triofig:InvalidRecipe', 'requiredWorkspaceVariables must be a nonempty list.');
end
if ~all(cellfun(@(value) ischar(value) || isstring(value), ...
        recipe.input.requiredWorkspaceVariables))
    error('triofig:InvalidRecipe', 'requiredWorkspaceVariables must contain text names.');
end

requireStructFields(recipe, 'reconstruction', {'availableRunRelativePath', ...
    'manifestRecordedRunRelativePath'});
requireText(recipe.reconstruction, 'availableRunRelativePath');
if ~(ischar(recipe.reconstruction.manifestRecordedRunRelativePath) || ...
        isstring(recipe.reconstruction.manifestRecordedRunRelativePath))
    error('triofig:InvalidRecipe', ...
        'manifestRecordedRunRelativePath must be text, possibly empty.');
end
if recipe.schemaVersion == 3
    requireText(recipe.reconstruction, 'manifestStatus');
    requireOptionalText(recipe.reconstruction, 'stageId');
    switch recipe.reconstruction.manifestStatus
        case 'present'
            requireText(recipe.input, 'runManifestRelativePath');
        case 'absent'
            if strlength(string(recipe.input.runManifestRelativePath)) ~= 0 || ...
                    strlength(string(recipe.reconstruction.manifestRecordedRunRelativePath)) ~= 0
                error('triofig:InvalidRecipe', ...
                    'An absent manifest must have empty manifest paths.');
            end
            validateRecovery(recipe);
        otherwise
            error('triofig:InvalidRecipe', 'manifestStatus must be present or absent.');
    end
end

requireStructFields(recipe, 'cameraPreparation', {'thorcam', 'validation'});
validateCamera(recipe.cameraPreparation.thorcam, 'thorcam');
validateCamera(recipe.cameraPreparation.validation, 'validation');

requireStructFields(recipe, 'registration', {'transformSource', 'cropMode', ...
    'crop', 'requireExpectedCrop', 'savedTransforms', 'rotationInterpolation'});
if ~ismember(recipe.registration.transformSource, {'automatic', 'saved'})
    error('triofig:InvalidRecipe', 'transformSource must be automatic or saved.');
end
if ~ismember(recipe.registration.cropMode, {'intersection', 'saved'})
    error('triofig:InvalidRecipe', 'cropMode must be intersection or saved.');
end
validateCrop(recipe.registration.crop);
requireText(recipe.registration, 'rotationInterpolation');
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
else
    requireStructFields(struct('registration', recipe.registration), 'registration', ...
        {'rotationStartDegrees', 'rotationStopDegrees', 'rotationStepDegrees'});
    rotationValues = [recipe.registration.rotationStartDegrees, ...
        recipe.registration.rotationStopDegrees, recipe.registration.rotationStepDegrees];
    if any(~isfinite(rotationValues)) || recipe.registration.rotationStepDegrees <= 0 || ...
            recipe.registration.rotationStartDegrees > recipe.registration.rotationStopDegrees
        error('triofig:InvalidRecipe', 'Invalid automatic rotation sweep settings.');
    end
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
    requireText(rois(index), 'color');
    if ~ismember(rois(index).color, {'orange', 'cyan'})
        error('triofig:InvalidRecipe', 'Zoom ROI colors must be orange or cyan.');
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
if ~isnumeric(recipe.figure.mainWidthCm) || ~isscalar(recipe.figure.mainWidthCm) || ...
        ~isfinite(recipe.figure.mainWidthCm) || ~isnumeric(recipe.figure.zoomWidthCm) || ...
        ~isscalar(recipe.figure.zoomWidthCm) || ~isfinite(recipe.figure.zoomWidthCm) || ...
        recipe.figure.mainWidthCm <= 0 || recipe.figure.zoomWidthCm <= 0
    error('triofig:InvalidRecipe', 'Figure widths must be positive.');
end

requireStructFields(recipe, 'calibration', {'thorcam', 'validation'});
validateCalibration(recipe.calibration.thorcam, 'thorcam');
validateCalibration(recipe.calibration.validation, 'validation');

requireStructFields(recipe, 'comparison', {'maximumAbsolutePixelDifference', ...
    'requireExactCandidateMatchBeforePublish'});
if ~isnumeric(recipe.comparison.maximumAbsolutePixelDifference) || ...
        ~isscalar(recipe.comparison.maximumAbsolutePixelDifference) || ...
        ~isfinite(recipe.comparison.maximumAbsolutePixelDifference) || ...
        recipe.comparison.maximumAbsolutePixelDifference < 0
    error('triofig:InvalidRecipe', ...
        'maximumAbsolutePixelDifference must be a finite nonnegative scalar.');
end
if ~islogical(recipe.comparison.requireExactCandidateMatchBeforePublish) && ...
        ~(isnumeric(recipe.comparison.requireExactCandidateMatchBeforePublish) && ...
        isscalar(recipe.comparison.requireExactCandidateMatchBeforePublish))
    error('triofig:InvalidRecipe', ...
        'requireExactCandidateMatchBeforePublish must be logical.');
end
end

function validateRecovery(recipe)
fields = {'generationId', 'generationIdSource', 'stageId', 'stageIdSource', ...
    'availableRunRelativePath', 'availableRunSource', 'workspaceRelativePath', ...
    'workspaceSha256', 'note'};
requireStructFields(recipe.reconstruction, 'recovery', fields);
info = recipe.reconstruction.recovery;
for index = 1:numel(fields)
    requireText(info, fields{index});
end
requireText(recipe.reconstruction, 'stageId');
if ~strcmp(info.generationId, recipe.input.expectedGenerationId) || ...
        ~strcmp(info.stageId, recipe.reconstruction.stageId) || ...
        ~strcmp(info.availableRunRelativePath, recipe.reconstruction.availableRunRelativePath) || ...
        ~strcmp(info.workspaceRelativePath, recipe.input.workspaceRelativePath)
    error('triofig:InvalidRecipe', 'Recovered metadata must agree with the recipe input/run identity.');
end
if isempty(regexp(info.workspaceSha256, '^[a-fA-F0-9]{64}$', 'once'))
    error('triofig:InvalidRecipe', 'Recovery workspaceSha256 must be a SHA-256 hash.');
end
end

function requireOptionalText(container, field)
if ~isfield(container, field) || ...
        ~(ischar(container.(field)) || isstring(container.(field))) || ...
        ~isscalar(string(container.(field)))
    error('triofig:InvalidRecipe', '%s must be scalar text, possibly empty.', field);
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

function validateCalibration(calibration, name)
requireStructFields(struct('calibration', calibration), 'calibration', {'pointPairs'});
points = calibration.pointPairs;
requireStructFields(struct('pointPairs', points), 'pointPairs', ...
    {'referenceXY', 'movingXY'});
if ~isnumeric(points.referenceXY) || ~isnumeric(points.movingXY) || ...
        (~isempty(points.referenceXY) && size(points.referenceXY, 2) ~= 2) || ...
        (~isempty(points.movingXY) && size(points.movingXY, 2) ~= 2) || ...
        (~isempty(points.referenceXY) && ~isempty(points.movingXY) && ...
        size(points.referenceXY, 1) ~= size(points.movingXY, 1)) || ...
        xor(isempty(points.referenceXY), isempty(points.movingXY)) || ...
        any(~isfinite(points.referenceXY(:))) || any(~isfinite(points.movingXY(:)))
    error('triofig:InvalidRecipe', ...
        'Calibration point pairs for %s must be matching finite N-by-2 arrays.', name);
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
        ~isscalar(string(container.(field))) || ...
        strlength(string(container.(field))) == 0
    error('triofig:InvalidRecipe', '%s must be nonempty text.', field);
end
end

function requireStructFields(container, field, fields)
if ~isfield(container, field) || ~isstruct(container.(field)) || ~isscalar(container.(field))
    error('triofig:InvalidRecipe', '%s must be a structure.', field);
end
value = container.(field);
for index = 1:numel(fields)
    if ~isfield(value, fields{index})
        error('triofig:InvalidRecipe', '%s is missing %s.', field, fields{index});
    end
end
end
