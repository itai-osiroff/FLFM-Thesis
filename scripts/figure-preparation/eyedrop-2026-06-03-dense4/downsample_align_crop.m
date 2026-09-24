function aligned = downsample_align_crop(globalAverage, localAverage, thorcamRaw, validationRaw, config)
%DOWNSAMPLE_ALIGN_CROP Deterministically prepare aligned June 3 panels.
%   This working copy replaces GUI choices with values in replay_config.json.

globalAverage = double(globalAverage);
localAverage = double(localAverage);
thorcam = orientCamera(double(thorcamRaw), config.cameraPreparation.thorcam);
validation = orientCamera(double(validationRaw), config.cameraPreparation.validation);

thorcamDownsampled = downsampleImage(thorcam, config.cameraPreparation.thorcam);
validationDownsampled = downsampleImage(validation, config.cameraPreparation.validation);
reference = imref2d(size(globalAverage));
angles = config.registration.rotationStartDegrees: ...
    config.registration.rotationStepDegrees:config.registration.rotationStopDegrees;

[thorcamRotation, thorcamTranslation, thorcamRotated] = ...
    sweepAlignment(thorcamDownsampled, globalAverage, angles, ...
    config.registration.rotationInterpolation);
[validationRotation, validationTranslation, validationRotated] = ...
    sweepAlignment(validationDownsampled, globalAverage, angles, ...
    config.registration.rotationInterpolation);

thorcamAligned = translateToReference(thorcamRotated, thorcamTranslation, reference);
validationAligned = translateToReference(validationRotated, validationTranslation, reference);

thorcamMask = rotateAndTranslateMask(size(thorcamDownsampled), thorcamRotation, ...
    thorcamTranslation, reference);
validationMask = rotateAndTranslateMask(size(validationDownsampled), validationRotation, ...
    validationTranslation, reference);
commonMask = thorcamMask & validationMask;
[rows, columns] = find(commonMask);
if isempty(rows) || isempty(columns)
    error('eyedrop_replay:NoCommonCrop', ...
        'Registration produced no common valid crop between ThorCam and validation.');
end

rowStart = min(rows);
rowEnd = max(rows);
columnStart = min(columns);
columnEnd = max(columns);
expectedCrop = config.registration.expectedCrop;
actualHeight = rowEnd - rowStart + 1;
actualWidth = columnEnd - columnStart + 1;
if rowStart ~= expectedCrop.rowStartOneBased || ...
        columnStart ~= expectedCrop.columnStartOneBased || ...
        actualHeight ~= expectedCrop.height || actualWidth ~= expectedCrop.width
    error('eyedrop_replay:UnexpectedCrop', ...
        ['Expected crop row %d, column %d, height %d, width %d; ' ...
         'received row %d, column %d, height %d, width %d.'], ...
        expectedCrop.rowStartOneBased, expectedCrop.columnStartOneBased, ...
        expectedCrop.height, expectedCrop.width, rowStart, columnStart, ...
        actualHeight, actualWidth);
end

rowRange = rowStart:rowEnd;
columnRange = columnStart:columnEnd;
globalCrop = globalAverage(rowRange, columnRange);
localCrop = localAverage(rowRange, columnRange);
thorcamCrop = thorcamAligned(rowRange, columnRange);
validationCrop = validationAligned(rowRange, columnRange);

sharedMinimum = min([globalCrop(:); localCrop(:)]);
sharedMaximum = max([globalCrop(:); localCrop(:)]);
globalNormalized = normalizeRange(globalCrop, sharedMinimum, sharedMaximum);
localNormalized = normalizeRange(localCrop, sharedMinimum, sharedMaximum);
thorcamNormalized = normalizeRange(thorcamCrop, min(thorcamCrop(:)), max(thorcamCrop(:)));
validationNormalized = normalizeRange(validationCrop, ...
    min(validationCrop(:)), max(validationCrop(:)));

intensity = config.presentation.intensityMultipliers;
aligned.global = clipUnit(globalNormalized * intensity.globalLocal);
aligned.local = clipUnit(localNormalized * intensity.globalLocal);
aligned.thorcam = clipUnit(thorcamNormalized * intensity.thorcam);
aligned.validation = clipUnit(validationNormalized * intensity.validation);
aligned.crop = struct( ...
    'rowStartOneBased', rowStart, 'columnStartOneBased', columnStart, ...
    'height', actualHeight, 'width', actualWidth);
aligned.registration = struct( ...
    'thorcamRotationDegrees', thorcamRotation, ...
    'thorcamTranslationXY', thorcamTranslation, ...
    'validationRotationDegrees', validationRotation, ...
    'validationTranslationXY', validationTranslation, ...
    'rotationAnglesDegrees', angles);
aligned.intensity = struct( ...
    'sharedGlobalLocalMinimum', sharedMinimum, ...
    'sharedGlobalLocalMaximum', sharedMaximum, ...
    'globalLocalMultiplier', intensity.globalLocal, ...
    'thorcamMultiplier', intensity.thorcam, ...
    'validationMultiplier', intensity.validation);
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

function [bestRotation, bestTranslation, rotatedImage] = sweepAlignment(moving, fixed, angles, interpolation)
bestPeak = -Inf;
bestRotation = 0;
bestTranslation = [0, 0];
rotatedImage = moving;
for theta = angles
    candidate = imrotate(moving, theta, interpolation, 'crop');
    correlation = normxcorr2(candidate, fixed);
    peak = max(correlation(:));
    if peak > bestPeak
        bestPeak = peak;
        bestRotation = theta;
        [peakRow, peakColumn] = find(correlation == peak, 1);
        bestTranslation = [peakColumn - size(candidate, 2), ...
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

function normalized = normalizeRange(image, minimum, maximum)
if maximum <= minimum
    error('eyedrop_replay:FlatImage', 'Cannot normalize an image with no intensity range.');
end
normalized = (image - minimum) ./ (maximum - minimum);
end

function image = clipUnit(image)
image = min(max(image, 0), 1);
end
