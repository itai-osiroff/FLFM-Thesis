function result = setup_trio_figure(dataRoot, varargin)
%SETUP_TRIO_FIGURE Interactively create and publish one trio-figure recipe.
%   SETUP_TRIO_FIGURE(DATAROOT) discovers a main/ThorCam/validation/workspace
%   bundle, lets the user review registration, crop, intensity, and two zoom
%   ROIs, then saves a recipe and candidate bundle. Closing or cancelling any
%   review step leaves no recipe or output files behind.

if nargin < 1 || strlength(string(dataRoot)) == 0
    dataRoot = getenv('TRIO_FIGURE_DATA_ROOT');
end
if strlength(string(dataRoot)) == 0 || ~isfolder(dataRoot)
    selected = uigetdir(pwd, 'Select the external data root');
    if isequal(selected, 0)
        result = cancelledResult();
        return;
    end
    dataRoot = selected;
end
dataRoot = char(string(dataRoot));

parser = inputParser;
parser.FunctionName = mfilename;
addParameter(parser, 'SceneId', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'FigureId', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'OutputDirectory', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'Publish', true, @(value) islogical(value) && isscalar(value));
parse(parser, varargin{:});
options = parser.Results;

sceneId = char(string(options.SceneId));
if isempty(sceneId)
    answer = inputdlg('Scene ID used in the raw-data filenames:', ...
        'Trio figure scene', [1, 80]);
    if isempty(answer)
        result = cancelledResult();
        return;
    end
    sceneId = strtrim(answer{1});
end
figureId = char(string(options.FigureId));
if isempty(figureId)
    defaultFigureId = regexprep(lower(sceneId), '[^a-z0-9_]+', '_');
    answer = inputdlg('Candidate figure ID:', 'Trio figure output', [1, 60], ...
        {defaultFigureId});
    if isempty(answer)
        result = cancelledResult();
        return;
    end
    figureId = strtrim(answer{1});
end
if isempty(figureId)
    error('triofig:InvalidRecipe', 'A nonempty figure ID is required.');
end

discovery = triofig.discoverInputs(dataRoot, sceneId);
[selected, completed] = selectInputs(dataRoot, discovery);
if ~completed
    result = cancelledResult();
    return;
end

scriptRoot = fileparts(mfilename('fullpath'));
repositoryRoot = fileparts(fileparts(scriptRoot));
outputDirectory = char(string(options.OutputDirectory));
if isempty(outputDirectory)
    outputDirectory = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', figureId);
end
recipe = triofig.defaultRecipe(sceneId, ...
    ['candidate-outputs/figures-source/' figureId]);
recipe.figure.id = figureId;
recipe.figure.assetDirectoryFromWrapper = ['./' figureId];
recipe.input.mainCaptureRelativePath = relativeToRoot(dataRoot, selected.main);
recipe.input.thorcamCaptureRelativePath = relativeToRoot(dataRoot, selected.thorcam);
recipe.input.validationCaptureRelativePath = relativeToRoot(dataRoot, selected.validation);
recipe.input.workspaceRelativePath = relativeToRoot(dataRoot, selected.workspace);
recipe.input.runManifestRelativePath = relativeToRoot(dataRoot, selected.runManifest);
recipe.reconstruction.availableRunRelativePath = relativeToRoot(dataRoot, ...
    fileparts(selected.runManifest));

runManifest = jsondecode(fileread(selected.runManifest));
if ~isfield(runManifest, 'generation_id')
    error('triofig:InvalidRunManifest', ...
        'Selected run manifest has no generation_id: %s', selected.runManifest);
end
recipe.input.expectedGenerationId = runManifest.generation_id;
workspace = load(selected.workspace, recipe.input.requiredWorkspaceVariables{:});
[recipe, completed] = reviewCameraPreparation(recipe, workspace, selected);
if ~completed
    result = cancelledResult();
    return;
end
[calibrate, completed] = shouldCalibrate('ThorCam');
if ~completed
    result = cancelledResult();
    return;
end
if calibrate
    [factor, points, completed] = calibrateScale( ...
        workspace.average_rectified_global_image, imread(selected.thorcam), ...
        recipe.cameraPreparation.thorcam, 'ThorCam');
    if ~completed
        result = cancelledResult();
        return;
    end
    recipe.cameraPreparation.thorcam.downsampleFactor = factor;
    recipe.calibration.thorcam.pointPairs = points;
end
[calibrate, completed] = shouldCalibrate('Validation camera');
if ~completed
    result = cancelledResult();
    return;
end
if calibrate
    [factor, points, completed] = calibrateScale( ...
        workspace.average_rectified_global_image, imread(selected.validation), ...
        recipe.cameraPreparation.validation, 'Validation camera');
    if ~completed
        result = cancelledResult();
        return;
    end
    recipe.cameraPreparation.validation.downsampleFactor = factor;
    recipe.calibration.validation.pointPairs = points;
end

prepared = prepareForReview(recipe, workspace, selected);
[recipe, completed] = reviewRegistration(recipe, prepared);
if ~completed
    result = cancelledResult();
    return;
end
prepared = prepareForReview(recipe, workspace, selected);
[recipe, completed] = chooseCrop(recipe, prepared);
if ~completed
    result = cancelledResult();
    return;
end
prepared = triofig.preparePanels( ...
    workspace.average_rectified_global_image, workspace.average_rectified_image, ...
    imread(selected.thorcam), imread(selected.validation), recipe);
[recipe, completed] = chooseIntensities(recipe, prepared);
if ~completed
    result = cancelledResult();
    return;
end
prepared = triofig.preparePanels( ...
    workspace.average_rectified_global_image, workspace.average_rectified_image, ...
    imread(selected.thorcam), imread(selected.validation), recipe);
panels = triofig.renderPanels(prepared, recipe.presentation.upsampleFactor);
[recipe, completed] = chooseZoomRois(recipe, panels);
if ~completed
    result = cancelledResult();
    return;
end

temporaryRecipe = [tempname '.json'];
recipeCleanup = onCleanup(@() removeFileIfPresent(temporaryRecipe));
triofig.writeRecipe(temporaryRecipe, recipe);
replay = replay_trio_figure(temporaryRecipe, dataRoot, ...
    'OutputDirectory', outputDirectory, 'Publish', options.Publish);
clear recipeCleanup
result = replay;
result.cancelled = false;
end

function [selected, completed] = selectInputs(dataRoot, discovery)
roles = {'main', 'thorcam', 'validation', 'workspace', 'runManifest'};
selected = struct();
completed = true;
for index = 1:numel(roles)
    role = roles{index};
    [path, accepted] = selectCandidate(dataRoot, role, discovery.(role));
    if ~accepted
        completed = false;
        return;
    end
    selected.(role) = path;
end
end

function [path, accepted] = selectCandidate(dataRoot, role, state)
accepted = false;
path = '';
if strcmp(state.status, 'single')
    path = state.candidates{1};
    accepted = true;
    return;
end
if strcmp(state.status, 'ambiguous')
    [selection, accepted] = listdlg( ...
        'PromptString', sprintf('Review the %s candidates and select one:', role), ...
        'SelectionMode', 'single', 'ListString', state.candidates, ...
        'ListSize', [900, 300]);
    if accepted
        path = state.candidates{selection};
    end
    return;
end
startDirectory = fullfile(dataRoot, role);
if ~isfolder(startDirectory)
    startDirectory = dataRoot;
end
switch role
    case {'main', 'thorcam', 'validation'}
        filter = {'*.tif;*.tiff;*.png;*.jpg;*.jpeg', 'Image files'};
    case 'workspace'
        filter = {'*.mat', 'MATLAB workspaces'};
    otherwise
        filter = {'*.json', 'JSON manifests'};
end
[filename, folder] = uigetfile(filter, sprintf('Select the %s input', role), startDirectory);
if isequal(filename, 0)
    return;
end
path = fullfile(folder, filename);
accepted = true;
end

function [recipe, completed] = reviewCameraPreparation(recipe, workspace, selected)
thorcamEstimate = estimateScale(workspace.average_rectified_global_image, ...
    imread(selected.thorcam), recipe.cameraPreparation.thorcam);
validationEstimate = estimateScale(workspace.average_rectified_global_image, ...
    imread(selected.validation), recipe.cameraPreparation.validation);
defaults = { ...
    num2str(recipe.cameraPreparation.thorcam.rotationDegrees), ...
    num2str(recipe.cameraPreparation.thorcam.flipVertical), ...
    num2str(thorcamEstimate, '%.8f'), ...
    num2str(recipe.cameraPreparation.validation.rotationDegrees), ...
    num2str(recipe.cameraPreparation.validation.flipVertical), ...
    num2str(validationEstimate, '%.8f')};
answers = inputdlg({ ...
    'ThorCam rotation (degrees):', 'ThorCam flip vertical (0 or 1):', ...
    'ThorCam downsample factor:', 'Validation rotation (degrees):', ...
    'Validation flip vertical (0 or 1):', 'Validation downsample factor:'}, ...
    'Review camera preparation', [1, 48], defaults);
if isempty(answers)
    completed = false;
    return;
end
values = str2double(answers);
if any(~isfinite(values)) || any(values([3, 6]) <= 0) || any(values([3, 6]) > 1) || ...
        any(~ismember(values([2, 5]), [0, 1]))
    error('triofig:InvalidRecipe', 'Camera review contains invalid values.');
end
recipe.cameraPreparation.thorcam.rotationDegrees = values(1);
recipe.cameraPreparation.thorcam.flipVertical = logical(values(2));
recipe.cameraPreparation.thorcam.downsampleFactor = values(3);
recipe.cameraPreparation.validation.rotationDegrees = values(4);
recipe.cameraPreparation.validation.flipVertical = logical(values(5));
recipe.cameraPreparation.validation.downsampleFactor = values(6);
completed = true;
end

function factor = estimateScale(reference, raw, settings)
oriented = imrotate(raw, settings.rotationDegrees);
if settings.flipVertical
    oriented = flipud(oriented);
end
factor = median([size(reference, 1) / size(oriented, 1), ...
    size(reference, 2) / size(oriented, 2)]);
end

function [calibrate, completed] = shouldCalibrate(name)
answer = questdlg(sprintf('Estimate the %s scale from matched point pairs?', name), ...
    'Optional point-pair calibration', 'Calibrate', 'Use reviewed factor', ...
    'Use reviewed factor');
completed = ~isempty(answer);
calibrate = strcmp(answer, 'Calibrate');
end

function [factor, points, completed] = calibrateScale(reference, raw, settings, label)
oriented = imrotate(raw, settings.rotationDegrees);
if settings.flipVertical
    oriented = flipud(oriented);
end
figureHandle = figure('Name', [label ' point-pair calibration'], ...
    'NumberTitle', 'off', 'Position', [100, 100, 1200, 500]);
cleaner = onCleanup(@() closeIfValid(figureHandle));
left = subplot(1, 2, 1, 'Parent', figureHandle);
imshow(imadjust(mat2gray(reference)), 'Parent', left);
title(left, 'Reference: click a feature, then its match on the right');
right = subplot(1, 2, 2, 'Parent', figureHandle);
imshow(imadjust(mat2gray(oriented)), 'Parent', right);
title(right, 'Moving camera image');
referenceXY = zeros(0, 2);
movingXY = zeros(0, 2);
while true
    axes(left); %#ok<LAXES>
    [x1, y1, button1] = ginput(1);
    if isempty(button1)
        break;
    end
    triofig.addCalibrationPoint(left, [x1, y1]);
    axes(right); %#ok<LAXES>
    [x2, y2, button2] = ginput(1);
    if isempty(button2)
        break;
    end
    triofig.addCalibrationPoint(right, [x2, y2]);
    referenceXY(end + 1, :) = [x1, y1]; %#ok<AGROW>
    movingXY(end + 1, :) = [x2, y2]; %#ok<AGROW>
end
if size(referenceXY, 1) < 2
    factor = settings.downsampleFactor;
    points = struct('referenceXY', referenceXY, 'movingXY', movingXY);
    completed = false;
    return;
end
factor = median(pdist(referenceXY) ./ pdist(movingXY));
points = struct('referenceXY', referenceXY, 'movingXY', movingXY);
completed = true;
end

function prepared = prepareForReview(recipe, workspace, selected)
recipe.registration.requireExpectedCrop = false;
recipe.registration.cropMode = 'intersection';
prepared = triofig.preparePanels( ...
    workspace.average_rectified_global_image, workspace.average_rectified_image, ...
    imread(selected.thorcam), imread(selected.validation), recipe);
end

function [recipe, completed] = reviewRegistration(recipe, prepared)
figureHandle = figure('Name', 'Automatic registration preview', ...
    'NumberTitle', 'off', 'Position', [100, 100, 1300, 480]);
cleaner = onCleanup(@() closeIfValid(figureHandle));
showOverlay(subplot(1, 3, 1, 'Parent', figureHandle), prepared.preview.reference, ...
    prepared.preview.thorcamAligned, 'Reference / ThorCam');
showOverlay(subplot(1, 3, 2, 'Parent', figureHandle), prepared.preview.reference, ...
    prepared.preview.validationAligned, 'Reference / Validation');
imshow(prepared.preview.commonMask, 'Parent', subplot(1, 3, 3, 'Parent', figureHandle));
title('Common field mask');
defaults = { ...
    num2str(prepared.registration.thorcamRotationDegrees), ...
    num2str(prepared.registration.thorcamTranslationXY(1)), ...
    num2str(prepared.registration.thorcamTranslationXY(2)), ...
    num2str(prepared.registration.validationRotationDegrees), ...
    num2str(prepared.registration.validationTranslationXY(1)), ...
    num2str(prepared.registration.validationTranslationXY(2))};
answers = inputdlg({ ...
    'ThorCam rotation (degrees):', 'ThorCam translation X:', 'ThorCam translation Y:', ...
    'Validation rotation (degrees):', 'Validation translation X:', 'Validation translation Y:'}, ...
    'Accept or adjust registration', [1, 42], defaults);
if isempty(answers)
    completed = false;
    return;
end
values = str2double(answers);
if any(~isfinite(values))
    error('triofig:InvalidRecipe', 'Registration review contains invalid values.');
end
recipe.registration.transformSource = 'saved';
recipe.registration.savedTransforms = struct( ...
    'thorcamRotationDegrees', values(1), ...
    'thorcamTranslationXY', values(2:3)', ...
    'validationRotationDegrees', values(4), ...
    'validationTranslationXY', values(5:6)');
recipe.registration.cropMode = 'intersection';
recipe.registration.requireExpectedCrop = false;
completed = true;
end

function showOverlay(axesHandle, reference, moving, label)
imshow(cat(3, mat2gray(reference), mat2gray(moving), zeros(size(reference))), ...
    'Parent', axesHandle);
title(axesHandle, label);
end

function [recipe, completed] = chooseCrop(recipe, prepared)
figureHandle = figure('Name', 'Select common crop', 'NumberTitle', 'off', ...
    'Position', [120, 120, 900, 700]);
cleaner = onCleanup(@() closeIfValid(figureHandle));
axesHandle = axes('Parent', figureHandle);
imshow(prepared.preview.reference, [], 'Parent', axesHandle);
title(axesHandle, 'Adjust the crop, then double-click the rectangle to accept.');
crop = prepared.crop;
position = [crop.columnStartOneBased - 0.5, crop.rowStartOneBased - 0.5, ...
    crop.width, crop.height];
roi = drawrectangle(axesHandle, 'Position', position, ...
    'Color', triofig.roiDisplayColor('yellow'));
wait(roi);
[position, completed] = triofig.roiPosition(roi, figureHandle);
if ~completed
    completed = false;
    return;
end
recipe.registration.crop = rectangleToCrop(position);
recipe.registration.cropMode = 'saved';
recipe.registration.requireExpectedCrop = true;
completed = true;
end

function crop = rectangleToCrop(position)
crop = struct( ...
    'rowStartOneBased', round(position(2) + 0.5), ...
    'columnStartOneBased', round(position(1) + 0.5), ...
    'height', round(position(4)), ...
    'width', round(position(3)));
end

function [recipe, completed] = chooseIntensities(recipe, prepared)
[globalLocal, accepted] = intensitySlider(prepared.global, ...
    'Global/local shared intensity', recipe.presentation.intensityMultipliers.globalLocal);
if ~accepted
    completed = false;
    return;
end
[thorcam, accepted] = intensitySlider(prepared.thorcam, ...
    'ThorCam intensity', recipe.presentation.intensityMultipliers.thorcam);
if ~accepted
    completed = false;
    return;
end
recipe.presentation.intensityMultipliers.globalLocal = globalLocal;
recipe.presentation.intensityMultipliers.thorcam = thorcam;
completed = true;
end

function [value, accepted] = intensitySlider(image, titleText, initialValue)
value = initialValue;
accepted = false;
figureHandle = uifigure('Name', titleText, 'Position', [100, 100, 650, 690]);
axesHandle = uiaxes(figureHandle, 'Position', [50, 190, 550, 430]);
imageHandle = imshow(image, 'Parent', axesHandle);
title(axesHandle, titleText);
slider = uislider(figureHandle, 'Position', [150, 140, 350, 3], ...
    'Limits', [0.1, 5], 'Value', min(max(initialValue, 0.1), 5));
uilabel(figureHandle, 'Position', [240, 160, 180, 22], ...
    'Text', 'Intensity multiplier');
uibutton(figureHandle, 'Position', [185, 55, 110, 38], 'Text', 'Accept', ...
    'ButtonPushedFcn', @(~, ~) accept());
uibutton(figureHandle, 'Position', [355, 55, 110, 38], 'Text', 'Cancel', ...
    'ButtonPushedFcn', @(~, ~) cancel());
slider.ValueChangingFcn = @(source, event) updatePreview(event.Value);
uiwait(figureHandle);
if isvalid(figureHandle)
    delete(figureHandle);
end

    function updatePreview(multiplier)
        imageHandle.CData = min(image * multiplier, 1);
    end

    function accept()
        value = slider.Value;
        accepted = true;
        uiresume(figureHandle);
    end

    function cancel()
        uiresume(figureHandle);
    end
end

function [recipe, completed] = chooseZoomRois(recipe, panels)
colors = {'orange', 'cyan'};
rois = recipe.presentation.zoomRois;
figureHandle = figure('Name', 'Select zoom ROIs', 'NumberTitle', 'off', ...
    'Position', [50, 80, 1350, 820]);
cleaner = onCleanup(@() closeIfValid(figureHandle));
layout = tiledlayout(figureHandle, 2, 3, 'Padding', 'compact');
thorcamAxes = nexttile(layout, 1);
imshow(panels.thorcam, 'Parent', thorcamAxes); title(thorcamAxes, 'Thorcam');
globalAxes = nexttile(layout, 2);
imshow(panels.global, 'Parent', globalAxes); title(globalAxes, 'Global: draw each ROI');
localAxes = nexttile(layout, 3);
imshow(panels.local, 'Parent', localAxes); title(localAxes, 'Local');
previewAxes = [nexttile(layout, 4), nexttile(layout, 5), nexttile(layout, 6)];
previewNames = {'Thorcam zoom', 'Global zoom', 'Local zoom'};
for index = 1:numel(previewAxes)
    title(previewAxes(index), previewNames{index});
end

for index = 1:2
    initial = defaultRoiPosition(panels.global, index);
    roi = drawrectangle(globalAxes, 'Position', initial, ...
        'Color', triofig.roiDisplayColor(colors{index}));
    updateZoomPreview(roi.Position);
    addlistener(roi, 'MovingROI', @(source, ~) updateZoomPreview(source.Position));
    addlistener(roi, 'ROIMoved', @(source, ~) updateZoomPreview(source.Position));
    title(globalAxes, sprintf('ROI %d: adjust, then double-click to accept', index));
    wait(roi);
    [position, completed] = triofig.roiPosition(roi, figureHandle);
    if ~completed
        completed = false;
        return;
    end
    rois(index) = rectangleToRoi(position, panels.global, index, colors{index});
end
recipe.presentation.zoomRois = rois;
completed = true;

    function updateZoomPreview(position)
        candidate = rectangleToRoi(position, panels.global, 1, 'orange');
        try
            previews = triofig.extractZooms(panels, [candidate, candidate]);
            imshow(previews.thorcam_zoom_1, 'Parent', previewAxes(1));
            imshow(previews.global_zoom_1, 'Parent', previewAxes(2));
            imshow(previews.local_zoom_1, 'Parent', previewAxes(3));
        catch
            % Invalid transient drag positions are shown only after they return in-bounds.
        end
    end
end

function position = defaultRoiPosition(image, index)
width = max(2, floor(size(image, 2) / 4));
height = max(2, floor(size(image, 1) / 5));
position = [floor(size(image, 2) / 4), ...
    floor((index + 1) * size(image, 1) / 5), width, height];
end

function roi = rectangleToRoi(position, image, id, color)
width = max(1, min(round(position(3)), size(image, 2)));
height = max(1, min(round(position(4)), size(image, 1)));
xZeroBased = min(max(round(position(1)) - 1, 0), size(image, 2) - width);
yZeroBased = min(max(round(position(2)) - 1, 0), size(image, 1) - height);
roi = struct('id', id, 'xZeroBased', xZeroBased, 'yZeroBased', yZeroBased, ...
    'width', width, 'height', height, 'color', color);
end

function relative = relativeToRoot(root, path)
root = char(java.io.File(root).getCanonicalPath());
path = char(java.io.File(path).getCanonicalPath());
prefix = [root filesep];
if ~startsWith(path, prefix, 'IgnoreCase', ispc)
    error('triofig:InvalidInput', 'Selected input is outside the data root: %s', path);
end
relative = strrep(extractAfter(string(path), strlength(string(prefix))), char(92), '/');
relative = char(relative);
end

function result = cancelledResult()
result = struct('cancelled', true);
end

function closeIfValid(handle)
if isgraphics(handle)
    close(handle);
end
end

function removeFileIfPresent(path)
if isfile(path)
    delete(path);
end
end
