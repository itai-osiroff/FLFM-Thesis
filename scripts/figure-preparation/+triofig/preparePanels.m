function prepared = preparePanels(globalAverage, localAverage, thorcamRaw, validationRaw, recipe)
%PREPAREPANELS Apply a recipe's deterministic registration and presentation.

globalAverage = double(globalAverage);
localAverage = double(localAverage);
thorcam = orientCamera(double(thorcamRaw), recipe.cameraPreparation.thorcam);
validation = orientCamera(double(validationRaw), recipe.cameraPreparation.validation);

thorcamDownsampled = downsampleImage(thorcam, recipe.cameraPreparation.thorcam);
validationDownsampled = downsampleImage(validation, recipe.cameraPreparation.validation);
reference = imref2d(size(globalAverage));

[thorcamRotation, thorcamTranslation, thorcamRotated] = resolveTransform( ...
    thorcamDownsampled, globalAverage, recipe, 'thorcam');
[validationRotation, validationTranslation, validationRotated] = resolveTransform( ...
    validationDownsampled, globalAverage, recipe, 'validation');

thorcamAligned = translateToReference(thorcamRotated, thorcamTranslation, reference);
validationAligned = translateToReference(validationRotated, validationTranslation, reference);
thorcamMask = rotateAndTranslateMask(size(thorcamDownsampled), thorcamRotation, ...
    thorcamTranslation, reference);
validationMask = rotateAndTranslateMask(size(validationDownsampled), validationRotation, ...
    validationTranslation, reference);
commonMask = thorcamMask & validationMask;
[crop, rowRange, columnRange] = resolveCrop(commonMask, recipe.registration);

globalCrop = globalAverage(rowRange, columnRange);
localCrop = localAverage(rowRange, columnRange);
thorcamCrop = thorcamAligned(rowRange, columnRange);
validationCrop = validationAligned(rowRange, columnRange);

% Raw registered crops, kept so display dialogs can re-window without realigning.
prepared.crops = struct('global', globalCrop, 'local', localCrop, ...
    'thorcam', thorcamCrop, 'validation', validationCrop);

sharedMinimum = min([globalCrop(:); localCrop(:)]);
sharedMaximum = max([globalCrop(:); localCrop(:)]);
intensity = recipe.presentation.intensityMultipliers;
[effective, mode] = triofig.resolveIntensity(recipe.presentation);
windowed = recipe.schemaVersion >= 6 && strcmp(recipe.presentation.display.method, 'window');
if windowed
    [mapped, displayInfo] = triofig.applyDisplay(prepared.crops, recipe.presentation);
    prepared.global = mapped.global;
    prepared.local = mapped.local;
    prepared.thorcam = mapped.thorcam;
    prepared.validation = mapped.validation;
    prepared.source = displayInfo.source;
    prepared.display = rmfield(displayInfo, 'source');
else
    globalNormalized = normalizeRange(globalCrop, sharedMinimum, sharedMaximum);
    localNormalized = normalizeRange(localCrop, sharedMinimum, sharedMaximum);
    thorcamNormalized = normalizeRange(thorcamCrop, min(thorcamCrop(:)), max(thorcamCrop(:)));
    validationNormalized = normalizeRange(validationCrop, ...
        min(validationCrop(:)), max(validationCrop(:)));
    prepared.global = clipUnit(globalNormalized * effective.global);
    prepared.local = clipUnit(localNormalized * effective.local);
    prepared.thorcam = clipUnit(thorcamNormalized * intensity.thorcam);
    prepared.validation = clipUnit(validationNormalized * intensity.validation);
end
prepared.crop = crop;
prepared.registration = struct( ...
    'thorcamRotationDegrees', thorcamRotation, ...
    'thorcamTranslationXY', thorcamTranslation, ...
    'validationRotationDegrees', validationRotation, ...
    'validationTranslationXY', validationTranslation, ...
    'rotationAnglesDegrees', rotationAngles(recipe.registration), ...
    'transformSource', recipe.registration.transformSource, ...
    'cropMode', recipe.registration.cropMode);
prepared.intensity = struct( ...
    'sharedGlobalLocalMinimum', sharedMinimum, ...
    'sharedGlobalLocalMaximum', sharedMaximum, ...
    'globalLocalMultiplier', intensity.globalLocal, ...
    'thorcamMultiplier', intensity.thorcam, ...
    'validationMultiplier', intensity.validation);
if recipe.schemaVersion >= 4
    prepared.intensity.mode = mode;
    prepared.intensity.globalMultiplier = effective.global;
    prepared.intensity.localMultiplier = effective.local;
end
prepared.preview = struct( ...
    'reference', globalAverage, ...
    'thorcamAligned', thorcamAligned, ...
    'validationAligned', validationAligned, ...
    'commonMask', commonMask);
end

function image = orientCamera(image, settings)
image = imrotate(image, settings.rotationDegrees);
if settings.flipVertical
    image = flipud(image);
end
end

function downsampled = downsampleImage(image, settings)
factor = settings.downsampleFactor;
downsampled = imresize(imgaussfilt(image, 1 / factor / 2), factor, 'bilinear');
end

function [rotation, translation, rotatedImage] = resolveTransform(moving, fixed, recipe, role)
if strcmp(recipe.registration.transformSource, 'saved')
    transforms = recipe.registration.savedTransforms;
    rotation = transforms.([role 'RotationDegrees']);
    translation = transforms.([role 'TranslationXY']);
    rotatedImage = imrotate(moving, rotation, recipe.registration.rotationInterpolation, 'crop');
else
    [rotation, translation, rotatedImage] = sweepAlignment(moving, fixed, ...
        rotationAngles(recipe.registration), recipe.registration.rotationInterpolation);
end
end

function angles = rotationAngles(registration)
if strcmp(registration.transformSource, 'saved')
    angles = [registration.savedTransforms.thorcamRotationDegrees, ...
        registration.savedTransforms.validationRotationDegrees];
else
    angles = registration.rotationStartDegrees:registration.rotationStepDegrees: ...
        registration.rotationStopDegrees;
end
end

function [rotation, translation, rotatedImage] = sweepAlignment(moving, fixed, angles, interpolation)
bestPeak = -Inf;
rotation = 0;
translation = [0, 0];
rotatedImage = moving;
for theta = angles
    candidate = imrotate(moving, theta, interpolation, 'crop');
    correlation = normxcorr2(candidate, fixed);
    peak = max(correlation(:));
    if peak > bestPeak
        bestPeak = peak;
        rotation = theta;
        [peakRow, peakColumn] = find(correlation == peak, 1);
        translation = [peakColumn - size(candidate, 2), ...
            peakRow - size(candidate, 1)];
        rotatedImage = candidate;
    end
end
end

function translated = translateToReference(image, translation, reference)
transform = affine2d([1, 0, 0; 0, 1, 0; translation(1), translation(2), 1]);
translated = imwarp(image, transform, 'OutputView', reference);
end

function mask = rotateAndTranslateMask(imageSize, rotation, translation, reference)
sourceMask = true(imageSize(1), imageSize(2));
rotatedMask = imrotate(sourceMask, rotation, 'nearest', 'crop');
mask = translateToReference(rotatedMask, translation, reference) > 0;
end

function [crop, rowRange, columnRange] = resolveCrop(commonMask, registration)
[rows, columns] = find(commonMask);
if isempty(rows) || isempty(columns)
    error('triofig:NoCommonCrop', ...
        'Registration produced no common valid crop between ThorCam and validation.');
end
intersection = struct( ...
    'rowStartOneBased', min(rows), ...
    'columnStartOneBased', min(columns), ...
    'height', max(rows) - min(rows) + 1, ...
    'width', max(columns) - min(columns) + 1);
if strcmp(registration.cropMode, 'intersection')
    crop = intersection;
    if registration.requireExpectedCrop && ~isequal(crop, registration.crop)
        error('triofig:UnexpectedCrop', ...
            'The registered intersection does not match the recipe crop.');
    end
else
    crop = registration.crop;
end
rowRange = crop.rowStartOneBased:(crop.rowStartOneBased + crop.height - 1);
columnRange = crop.columnStartOneBased:(crop.columnStartOneBased + crop.width - 1);
intersectionRows = intersection.rowStartOneBased: ...
    (intersection.rowStartOneBased + intersection.height - 1);
intersectionColumns = intersection.columnStartOneBased: ...
    (intersection.columnStartOneBased + intersection.width - 1);
if rowRange(1) < intersectionRows(1) || rowRange(end) > intersectionRows(end) || ...
        columnRange(1) < intersectionColumns(1) || ...
        columnRange(end) > intersectionColumns(end)
    error('triofig:InvalidCrop', ...
        'The recipe crop falls outside the registered common-field bounds.');
end
end

function normalized = normalizeRange(image, minimum, maximum)
if maximum <= minimum
    error('triofig:FlatImage', 'Cannot normalize an image with no intensity range.');
end
normalized = (image - minimum) ./ (maximum - minimum);
end

function image = clipUnit(image)
image = min(max(image, 0), 1);
end
