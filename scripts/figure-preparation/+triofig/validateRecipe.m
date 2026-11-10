function validateRecipe(recipe)
%VALIDATERECIPE Reject incomplete or unsupported recipe data before replay.

if ~isstruct(recipe) || ~isscalar(recipe) || ~isfield(recipe, 'schemaVersion') || ...
        ~isnumeric(recipe.schemaVersion) || ~isscalar(recipe.schemaVersion) || ...
        ~ismember(recipe.schemaVersion, [2, 3, 4, 5, 6])
    error('triofig:InvalidRecipe', 'Expected a supported trio-figure recipe schemaVersion.');
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
    if recipe.schemaVersion >= 3 && strcmp(requiredInput{index}, 'runManifestRelativePath')
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
if recipe.schemaVersion >= 3
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
if recipe.schemaVersion >= 5
    requireText(recipe.input, 'workspaceMode');
    requireText(recipe.input, 'workspaceSha256');
    requireText(recipe.input, 'localWorkspaceRelativePath');
    requireText(recipe.input, 'localWorkspaceSha256');
    requireOptionalText(recipe.input, 'localRunManifestRelativePath');
    requireText(recipe.input, 'expectedLocalGenerationId');
    if ~ismember(recipe.input.workspaceMode, {'shared', 'separate'})
        error('triofig:InvalidRecipe', 'workspaceMode must be shared or separate.');
    end
    validateOptionalHash(recipe.input.workspaceSha256, 'workspaceSha256');
    validateOptionalHash(recipe.input.localWorkspaceSha256, 'localWorkspaceSha256');
    if strcmp(recipe.input.workspaceMode, 'separate') && ...
            any(strcmp({recipe.input.workspaceSha256, recipe.input.localWorkspaceSha256}, 'unknown'))
        error('triofig:InvalidRecipe', 'Separate workspaces require a SHA-256 hash for each workspace.');
    end
    requireStructFields(recipe.reconstruction, 'localWorkspace', ...
        {'manifestStatus', 'stageId', 'availableRunRelativePath', 'manifestRecordedRunRelativePath'});
    local = recipe.reconstruction.localWorkspace;
    requireText(local, 'manifestStatus'); requireOptionalText(local, 'stageId');
    requireText(local, 'availableRunRelativePath');
    requireOptionalText(local, 'manifestRecordedRunRelativePath');
    if ~ismember(local.manifestStatus, {'present', 'absent'})
        error('triofig:InvalidRecipe', 'localWorkspace.manifestStatus must be present or absent.');
    end
    if strcmp(recipe.input.workspaceMode, 'shared')
        if ~strcmp(recipe.input.localWorkspaceRelativePath, recipe.input.workspaceRelativePath) || ...
                ~strcmp(recipe.input.localWorkspaceSha256, recipe.input.workspaceSha256) || ...
                ~strcmp(recipe.input.localRunManifestRelativePath, recipe.input.runManifestRelativePath) || ...
                ~strcmp(recipe.input.expectedLocalGenerationId, recipe.input.expectedGenerationId) || ...
                ~strcmp(local.manifestStatus, recipe.reconstruction.manifestStatus) || ...
                ~strcmp(local.stageId, recipe.reconstruction.stageId) || ...
                ~strcmp(local.availableRunRelativePath, recipe.reconstruction.availableRunRelativePath) || ...
                ~strcmp(local.manifestRecordedRunRelativePath, recipe.reconstruction.manifestRecordedRunRelativePath)
            error('triofig:InvalidRecipe', 'Shared workspace inputs and run metadata must agree.');
        end
        if strcmp(local.manifestStatus, 'absent') && ...
                (~isfield(local, 'recovery') || ~isequaln(local.recovery, recipe.reconstruction.recovery))
            error('triofig:InvalidRecipe', 'Shared workspace recovery records must agree.');
        end
    elseif strcmp(local.manifestStatus, 'present')
        if isempty(recipe.input.localRunManifestRelativePath)
            error('triofig:InvalidRecipe', 'Separate workspaces require a local run manifest or recovery record.');
        end
    else
        requireStructFields(recipe.reconstruction, 'localWorkspace', {'recovery'});
        validateWorkspaceRecovery(local.recovery, recipe.input.expectedLocalGenerationId, ...
            local.stageId, local.availableRunRelativePath, recipe.input.localWorkspaceRelativePath);
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
if recipe.schemaVersion >= 4
    requireText(recipe.presentation, 'intensityMode');
    if strcmp(recipe.presentation.intensityMode, 'separate')
        gains = recipe.presentation.intensityMultipliers;
        requireStructFields(recipe.presentation, 'intensityMultipliers', {'global', 'local'});
        validateIntensity(struct('globalLocal', gains.global, 'thorcam', gains.local, 'validation', 1));
    end
elseif isfield(recipe.presentation, 'intensityMode') && ...
        ~strcmp(recipe.presentation.intensityMode, 'linked')
    error('triofig:InvalidRecipe', 'Independent intensity mapping requires recipe schema 4.');
end

triofig.resolveIntensity(recipe.presentation);
rois = recipe.presentation.zoomRois;
if ~isstruct(rois) || numel(rois) ~= 2
    error('triofig:InvalidRecipe', 'Exactly two zoom ROIs are required for a trio bundle.');
end
if recipe.schemaVersion >= 6
    validateDisplay(recipe.presentation);
elseif isfield(recipe.presentation, 'display')
    error('triofig:InvalidRecipe', 'A display block requires recipe schema 6.');
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

function validateDisplay(presentation)
requireStructFields(presentation, 'display', {'method', 'roles', 'processing', 'zoom'});
display = presentation.display;
requireText(display, 'method');
if ~ismember(display.method, {'window', 'legacyMinMax'})
    error('triofig:InvalidRecipe', 'display.method must be window or legacyMinMax.');
end
requireStructFields(display, 'roles', {'flfm', 'global', 'local', 'thorcam'});
for role = {'flfm', 'global', 'local', 'thorcam'}
    validateWindow(display.roles.(role{1}), ['display.roles.' role{1}]);
end
requireStructFields(display, 'processing', {'flfm', 'thorcam'});
for group = {'flfm', 'thorcam'}
    validateProcessing(display.processing.(group{1}), group{1});
end
requireStructFields(display, 'zoom', {'marker', 'regions'});
if ~isscalar(display.zoom.marker) || ~(islogical(display.zoom.marker) || isnumeric(display.zoom.marker))
    error('triofig:InvalidRecipe', 'display.zoom.marker must be logical.');
end
regions = display.zoom.regions;
if ~isstruct(regions) || numel(regions) ~= 2
    error('triofig:InvalidRecipe', 'display.zoom.regions must describe exactly two regions.');
end
ids = zeros(1, 2);
for index = 1:2
    requireStructFields(struct('region', regions(index)), 'region', {'id', 'flfm', 'thorcam'});
    validateWindow(regions(index).flfm, 'display.zoom region flfm');
    validateWindow(regions(index).thorcam, 'display.zoom region thorcam');
    for cell = {'flfm', 'thorcam'}
        view = regions(index).(cell{1}).view;
        if ~(ischar(view) || isstring(view)) || ~ismember(char(view), {'inherit', 'separate', 'both'})
            error('triofig:InvalidRecipe', ...
                'display.zoom region %s view must be inherit, separate or both.', cell{1});
        end
        if ~strcmp(display.method, 'window') && ~strcmp(char(view), 'inherit')
            error('triofig:InvalidRecipe', ...
                'Separate zoom windows require window display mapping (view %s).', cell{1});
        end
    end
    ids(index) = regions(index).id;
end
roiIds = [presentation.zoomRois.id];
if ~isequal(sort(ids), sort(roiIds))
    error('triofig:InvalidRecipe', 'display.zoom region ids must match the zoom ROI ids.');
end
if strcmp(display.method, 'window')
    gains = presentation.intensityMultipliers;
    for name = fieldnames(gains).'
        if gains.(name{1}) ~= 1
            error('triofig:InvalidRecipe', ...
                'Window display mapping requires intensity multipliers of 1 (found %s).', name{1});
        end
    end
end
end

function validateWindow(window, label)
requireStructFields(struct('window', window), 'window', ...
    {'black', 'white', 'auto', 'lowPercentile', 'highPercentile'});values = [window.black, window.white, window.lowPercentile, window.highPercentile];
if any(~isnumeric(values)) || any(~isfinite(values)) || ~isscalar(window.black) || ...
        ~isscalar(window.white) || window.white <= window.black
    error('triofig:InvalidRecipe', '%s needs finite black and white values with white > black.', label);
end
if window.lowPercentile < 0 || window.highPercentile > 100 || ...
        window.lowPercentile >= window.highPercentile
    error('triofig:InvalidRecipe', '%s percentiles must satisfy 0 <= low < high <= 100.', label);
end
if ~isscalar(window.auto) || ~(islogical(window.auto) || isnumeric(window.auto))
    error('triofig:InvalidRecipe', '%s auto flag must be logical.', label);
end
end

function validateProcessing(processing, group)
requireStructFields(struct('processing', processing), 'processing', ...
    {'background', 'smoothing', 'gamma'});
requireStructFields(processing, 'background', {'enabled', 'method', 'sigmaPixels'});
requireStructFields(processing, 'smoothing', {'enabled', 'sigmaPixels'});
requireStructFields(processing, 'gamma', {'enabled', 'value'});
if ~strcmp(processing.background.method, 'gaussian')
    error('triofig:InvalidRecipe', 'Background subtraction method must be gaussian (%s).', group);
end
sigmas = [processing.background.sigmaPixels, processing.smoothing.sigmaPixels];
if ~isnumeric(sigmas) || any(~isfinite(sigmas)) || any(sigmas <= 0)
    error('triofig:InvalidRecipe', 'Processing sigmas must be positive (%s).', group);
end
gamma = processing.gamma.value;
if ~isnumeric(gamma) || ~isscalar(gamma) || ~isfinite(gamma) || gamma < 0.2 || gamma > 5
    error('triofig:InvalidRecipe', 'Gamma must be between 0.2 and 5 (%s).', group);
end
end

function validateOptionalHash(value, name)
if ~strcmp(value, 'unknown') && isempty(regexp(value, '^[a-fA-F0-9]{64}$', 'once'))
    error('triofig:InvalidRecipe', '%s must be SHA-256 or unknown.', name);
end
end

function validateWorkspaceRecovery(info, generationId, stageId, runPath, workspacePath)
fields = {'generationId', 'generationIdSource', 'stageId', 'stageIdSource', ...
    'availableRunRelativePath', 'availableRunSource', 'workspaceRelativePath', ...
    'workspaceSha256', 'note'};
requireStructFields(struct('recovery', info), 'recovery', fields);
for index = 1:numel(fields), requireText(info, fields{index}); end
if ~strcmp(info.generationId, generationId) || ~strcmp(info.stageId, stageId) || ...
        ~strcmp(info.availableRunRelativePath, runPath) || ~strcmp(info.workspaceRelativePath, workspacePath)
    error('triofig:InvalidRecipe', 'Local recovered metadata must agree with the selected workspace.');
end
if isempty(regexp(info.workspaceSha256, '^[a-fA-F0-9]{64}$', 'once'))
    error('triofig:InvalidRecipe', 'Local recovery workspaceSha256 must be a SHA-256 hash.');
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
