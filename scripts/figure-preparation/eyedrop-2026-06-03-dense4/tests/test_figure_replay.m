function tests = test_figure_replay
% Integration tests for the deterministic June 3 eyedrop figure replay.
tests = functiontests(localfunctions);
end

function testReplayProducesExpectedAssets(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
assertEntrypoint(testCase);
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');

outputRoot = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(outputRoot)); %#ok<NASGU>
result = run_figure_replay(dataRoot, ...
    'OutputDirectory', outputRoot, 'Publish', false);

expectedDimensions = struct( ...
    'thorcam_downsampled_png', [856, 480], ...
    'global_average_png', [856, 480], ...
    'local_average_png', [856, 480], ...
    'thorcam_zoom_1_png', [154, 108], ...
    'global_zoom_1_png', [154, 108], ...
    'local_zoom_1_png', [154, 108], ...
    'thorcam_zoom_2_png', [109, 94], ...
    'global_zoom_2_png', [109, 94], ...
    'local_zoom_2_png', [109, 94]);
expectedNames = fieldnames(expectedDimensions);
for index = 1:numel(expectedNames)
    filename = strrep(expectedNames{index}, '_png', '.png');
    info = imfinfo(fullfile(result.stagingDirectory, filename));
    verifyEqual(testCase, [info.Height, info.Width], ...
        expectedDimensions.(expectedNames{index}));
end

verifyTrue(testCase, isfile(result.manifestPath));
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.sceneId, 'beads_2um_dense4_eyedrop_4kus');
verifyEqual(testCase, manifest.reconstruction.generationId, ...
    'gen_20260603_131632_run_cfd275b2');
verifyEqual(testCase, manifest.crop.height, 214);
verifyEqual(testCase, manifest.crop.width, 120);
assertTrue(testCase, isfield(manifest.intensity, 'recoveryNote'));
verifyEqual(testCase, manifest.intensity.recoveryNote, ...
    'The ThorCam multiplier was re-established by exact pixel comparison with the checked-in candidate; the original GUI value was not saved.');
verifyEqual(testCase, manifest.zoomRois(1).xZeroBased, 316);
verifyEqual(testCase, manifest.zoomRois(2).yZeroBased, 533);
verifyEqual(testCase, numel(manifest.outputs), 9);
verifyEqual(testCase, {manifest.inputs.path}, { ...
    'main/beads_2um_dense4_eyedrop_4kus.tiff', ...
    'thorcam/beads_2um_dense4_eyedrop_11d5ms.tif', ...
    'validation/beads_2um_dense4_eyedrop_6kus.tiff', ...
    'algo_run/regular_run_best/experiment_manifest.json', ...
    'algo_run/regular_run_best/runs/stage1/s1c8143f580da9f/beads_2um_dense4_eyedrop_4kus/workspace.mat'});
verifyEqual(testCase, pipelineRoot, fileparts(result.configPath));
end

function testReplayRejectsMissingDataRoot(testCase)
assertEntrypoint(testCase);
missingRoot = fullfile(tempdir, ['missing-eyedrop-root-' char(java.util.UUID.randomUUID)]);
verifyError(testCase, @() run_figure_replay(missingRoot, ...
    'OutputDirectory', tempname, 'Publish', false), ...
    'eyedrop_replay:MissingInput');
end

function testReplayProducesSameHashesTwice(testCase)
assertEntrypoint(testCase);
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');

firstOutput = tempname;
secondOutput = tempname;
cleanup = onCleanup(@() localRemoveIfPresent({firstOutput, secondOutput})); %#ok<NASGU>
first = run_figure_replay(dataRoot, ...
    'OutputDirectory', firstOutput, 'Publish', false);
second = run_figure_replay(dataRoot, ...
    'OutputDirectory', secondOutput, 'Publish', false);

firstManifest = jsondecode(fileread(first.manifestPath));
secondManifest = jsondecode(fileread(second.manifestPath));
verifyEqual(testCase, {firstManifest.outputs.sha256}, {secondManifest.outputs.sha256});
end

function testReplayMatchesCheckedInCandidatePixels(testCase)
assertEntrypoint(testCase);
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');

result = run_figure_replay(dataRoot, 'Publish', false);
cleanup = onCleanup(@() localRemoveIfPresent(result.stagingDirectory)); %#ok<NASGU>
comparison = result.comparison;
verifyTrue(testCase, all([comparison.referenceExists]));
verifyTrue(testCase, all([comparison.sameDimensions]));
verifyEqual(testCase, [comparison.maximumAbsolutePixelDifference], ...
    zeros(1, numel(comparison)));
end

function testPublishedReplayCleansItsStagingDirectory(testCase)
assertEntrypoint(testCase);
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');

result = run_figure_replay(dataRoot);
verifyTrue(testCase, isfile(result.publishedManifestPath));
verifyFalse(testCase, isfolder(result.stagingDirectory));
end

function assertEntrypoint(testCase)
assertEqual(testCase, exist('run_figure_replay', 'file'), 2);
end

function dataRoot = localDataRoot
dataRoot = fullfile(getenv('USERPROFILE'), ...
    'OneDrive - Technion', 'office computer files', 'images_output', '3_6_26');
end

function localRemoveIfPresent(paths)
if ischar(paths) || isstring(paths)
    paths = cellstr(paths);
end
for index = 1:numel(paths)
    if isfolder(paths{index})
        rmdir(paths{index}, 's');
    end
end
end
