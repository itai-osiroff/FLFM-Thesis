function tests = test_line_profile_figure
%TEST_LINE_PROFILE_FIGURE Line-profile tool: sampling, registration, end to end.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
addpath(fileparts(fileparts(mfilename('fullpath'))));
testCase.TestData.root = tempname;
mkdir(testCase.TestData.root);
end

function teardownOnce(testCase)
if isfolder(testCase.TestData.root)
    rmdir(testCase.TestData.root, 's');
end
end

function testSampleProfileFindsTwoPeaksAndDip(testCase)
image = twoBeads(64, [20, 32; 30, 32], 2);
[d, v] = lineprofile.sampleProfile(image, [10, 32], [40, 32], 0.25);
verifyEqual(testCase, d(end), 30, 'AbsTol', 1e-9);
[peaks, where] = findpeaks(v / max(v));
verifyEqual(testCase, numel(peaks), 2);
verifyEqual(testCase, d(where), [10, 20], 'AbsTol', 0.3);
middle = v(abs(d - 15) < 1e-9) / max(v);
verifyLessThan(testCase, middle, 0.5);
end

function testSampleProfileRejectsSegmentOutsideImage(testCase)
verifyError(testCase, @() lineprofile.sampleProfile(zeros(10), [1, 1], [20, 1], 0.5), ...
    'lineprofile:OutsideImage');
end

function testRegisterRegularAppliesSavedTranslation(testCase)
raw = zeros(40);
raw(11, 21) = 1;
registration = identityRegistration([7, 3]);
[aligned, valid] = lineprofile.registerRegular(raw, registration, [40, 40]);
[~, index] = max(aligned(:));
[row, column] = ind2sub(size(aligned), index);
verifyEqual(testCase, [column, row], [21 + 7, 11 + 3]);
verifyFalse(testCase, valid(1, 1));
verifyTrue(testCase, valid(20, 20));
end

function testProposeSegmentPassesThroughBothBeads(testCase)
image = twoBeads(64, [20, 30; 28, 36], 1.5);
segment = lineprofile.proposeSegment(image, [10, 20, 30, 25], 4);
verifyEqual(testCase, segment.kind, 'pair');
direction = (segment.endXY - segment.startXY) / norm(segment.endXY - segment.startXY);
for bead = {[20, 30], [28, 36]}
    offset = bead{1} - segment.startXY;
    distanceToLine = abs(offset(1) * direction(2) - offset(2) * direction(1));
    verifyLessThan(testCase, distanceToLine, 1);
end
end

function testLocalOffsetRecoversSubpixelShift(testCase)
reference = twoBeads(64, [28, 30; 36, 34], 2);
moving = twoBeads(64, [28, 30; 36, 34] + [-2.4, 1.6], 2);
offset = lineprofile.localOffset(moving, reference, 20:44, 22:42, 6);
verifyEqual(testCase, offset, [-2.4, 1.6], 'AbsTol', 0.2);
end

function testSetupRenderSelectEndToEnd(testCase)
root = testCase.TestData.root;
dataRoot = fullfile(root, 'data');
mkdir(fullfile(dataRoot, 'run'));
mkdir(fullfile(dataRoot, 'thorcam'));
average_rectified_global_image = twoBeads(48, [20, 24; 28, 24], 3); %#ok<NASGU>
average_rectified_image = twoBeads(48, [20, 24; 28, 24], 1.5); %#ok<NASGU>
save(fullfile(dataRoot, 'run', 'workspace.mat'), 'average_rectified_global_image', 'average_rectified_image');
imwrite(uint16(1000 * twoBeads(48, [20, 24; 28, 24], 4)), fullfile(dataRoot, 'thorcam', 'capture.tif'));

trioDir = fullfile(root, 'trio');
mkdir(fullfile(trioDir, 'selected', 'metadata'));
trio = struct('sceneId', 'synthetic', ...
    'input', struct('workspaceRelativePath', 'run/workspace.mat', ...
        'localWorkspaceRelativePath', 'run/workspace.mat', ...
        'thorcamCaptureRelativePath', 'thorcam/capture.tif'), ...
    'cameraPreparation', struct('thorcam', struct('rotationDegrees', 0, ...
        'flipVertical', false, 'downsampleFactor', 1)), ...
    'registration', struct('transformSource', 'saved', 'rotationInterpolation', 'bilinear', ...
        'savedTransforms', struct('thorcamRotationDegrees', 0, 'thorcamTranslationXY', [0, 0]), ...
        'crop', struct('rowStartOneBased', 5, 'columnStartOneBased', 5, 'height', 40, 'width', 40)), ...
    'presentation', struct('upsampleFactor', 4, 'zoomRois', ...
        struct('id', 1, 'color', 'orange', 'xZeroBased', 40, 'yZeroBased', 40, 'width', 80, 'height', 80)));
fid = fopen(fullfile(trioDir, 'selected', 'metadata', 'trio-recipe.json'), 'w');
fprintf(fid, '%s', jsonencode(trio));
fclose(fid);

figureDir = fullfile(root, 'profile_synthetic');
recipe = line_profile_figure('setup', figureDir, trioDir, 1, dataRoot);
verifyEqual(testCase, recipe.status, 'proposed');
verifyTrue(testCase, isfile(fullfile(figureDir, 'profile-recipe.json')));
recipe = line_profile_figure('offsets', figureDir, dataRoot);
verifyEqual(testCase, recipe.segments(1).offsetsXY.regular, [0, 0], 'AbsTol', 0.2);
verifyEqual(testCase, recipe.segments(1).offsetsXY.global, [0, 0], 'AbsTol', 0.2);

generation = line_profile_figure('render', figureDir, dataRoot);
for name = {'figure.pdf', 'figure.png', 'profiles.csv', 'profile-recipe.json', 'manifest.json'}
    verifyTrue(testCase, isfile(fullfile(generation.directory, name{1})), name{1});
end
verifyEqual(testCase, [generation.registrationCheck.dxPixels, generation.registrationCheck.dyPixels], [0, 0]);

selected = line_profile_figure('select', figureDir, generation.generationId);
verifyEqual(testCase, lineprofile.fileSha256(selected.pdf), ...
    lineprofile.fileSha256(fullfile(generation.directory, 'figure.pdf')));
index = jsondecode(fileread(fullfile(figureDir, 'figure-index.json')));
verifyEqual(testCase, index.selected, generation.generationId);

fid = fopen(fullfile(generation.directory, 'profiles.csv'), 'a');
fprintf(fid, 'tampered\n');
fclose(fid);
verifyError(testCase, @() line_profile_figure('select', figureDir, generation.generationId), ...
    'lineprofile:ChangedGeneration');
end

% ---------------------------------------------------------------- helpers
function image = twoBeads(n, centersXY, sigma)
[x, y] = meshgrid(1:n, 1:n);
image = zeros(n);
for k = 1:size(centersXY, 1)
    image = image + exp(-((x - centersXY(k, 1)).^2 + (y - centersXY(k, 2)).^2) / (2 * sigma^2));
end
image = image + 0.01;
end

function registration = identityRegistration(translationXY)
registration = struct( ...
    'camera', struct('rotationDegrees', 0, 'flipVertical', false, 'downsampleFactor', 1), ...
    'savedTransforms', struct('rotationDegrees', 0, 'translationXY', translationXY), ...
    'rotationInterpolation', 'bilinear');
end
