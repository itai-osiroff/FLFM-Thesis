function tests = test_trio_figure_pipeline
%TEST_TRIO_FIGURE_PIPELINE Integration tests for reusable trio figures.
tests = functiontests(localfunctions);
end

function testPublicEntrypointsExist(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
verifyEqual(testCase, exist(fullfile(pipelineRoot, 'setup_trio_figure.m'), 'file'), 2);
verifyEqual(testCase, exist(fullfile(pipelineRoot, 'replay_trio_figure.m'), 'file'), 2);
end

function testDefaultRecipeUsesOneWorkspaceForBothAverages(testCase)
recipe = triofig.defaultRecipe('synthetic_scene', ...
    'candidate-outputs/figures-source/synthetic_scene');
verifyEqual(testCase, recipe.schemaVersion, 5);
verifyEqual(testCase, recipe.input.workspaceMode, 'shared');
verifyEqual(testCase, recipe.input.workspaceRelativePath, recipe.input.localWorkspaceRelativePath);
triofig.validateRecipe(recipe);
end

function testRecipeRoundTripPreservesCalibration(testCase)
recipe = triofig.defaultRecipe('synthetic_scene', ...
    'candidate-outputs/figures-source/synthetic_scene');
recipe.calibration.thorcam.pointPairs.referenceXY = [10, 20; 30, 40];
recipe.calibration.thorcam.pointPairs.movingXY = [100, 200; 300, 400];
recipe.cameraPreparation.thorcam.downsampleFactor = 0.125;

recipePath = [tempname '.json'];
cleanup = onCleanup(@() localRemoveIfPresent(recipePath)); %#ok<NASGU>
triofig.writeRecipe(recipePath, recipe);
loaded = triofig.readRecipe(recipePath);

verifyEqual(testCase, loaded.schemaVersion, 5);
verifyEqual(testCase, loaded.calibration.thorcam.pointPairs.referenceXY, [10, 20; 30, 40]);
verifyEqual(testCase, loaded.calibration.thorcam.pointPairs.movingXY, [100, 200; 300, 400]);
verifyEqual(testCase, loaded.cameraPreparation.thorcam.downsampleFactor, 0.125);
end

function testDiscoveryReportsMissingAndAmbiguousInputs(testCase)
dataRoot = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(dataRoot)); %#ok<NASGU>
mkdir(fullfile(dataRoot, 'main'));
mkdir(fullfile(dataRoot, 'thorcam'));
fclose(fopen(fullfile(dataRoot, 'main', 'sceneA_first.tiff'), 'w'));
fclose(fopen(fullfile(dataRoot, 'main', 'sceneA_second.tiff'), 'w'));
fclose(fopen(fullfile(dataRoot, 'thorcam', 'sceneA_reference.tif'), 'w'));

discovery = triofig.discoverInputs(dataRoot, 'sceneA');

verifyEqual(testCase, discovery.main.status, 'ambiguous');
verifyNumElements(testCase, discovery.main.candidates, 2);
verifyEqual(testCase, discovery.thorcam.status, 'single');
verifyEqual(testCase, discovery.validation.status, 'missing');
verifyEqual(testCase, discovery.workspace.status, 'missing');
end

function testReplayRejectsInvalidRecipeBeforeWritingOutput(testCase)
recipe = triofig.defaultRecipe('synthetic_scene', ...
    'candidate-outputs/figures-source/synthetic_scene');
recipe.schemaVersion = 999;
recipePath = [tempname '.json'];
outputDirectory = tempname;
cleanup = onCleanup(@() localRemoveIfPresent({recipePath, outputDirectory})); %#ok<NASGU>
triofig.writeRecipe(recipePath, recipe);

verifyError(testCase, @() replay_trio_figure(recipePath, tempdir, ...
    'OutputDirectory', outputDirectory, 'Publish', false), 'triofig:InvalidRecipe');
verifyFalse(testCase, isfolder(outputDirectory));
end

function testRecipePreflightRejectsFieldsUsedAfterStaging(testCase)
recipe = triofig.defaultRecipe('synthetic_scene', ...
    'candidate-outputs/figures-source/synthetic_scene');
fields = {'reconstruction', 'calibration', 'comparison'};
for index = 1:numel(fields)
    broken = rmfield(recipe, fields{index});
    recipePath = [tempname '.json'];
    outputDirectory = tempname;
    cleanup = onCleanup(@() localRemoveIfPresent({recipePath, outputDirectory})); %#ok<NASGU>
    triofig.writeRecipe(recipePath, broken);

    verifyError(testCase, @() replay_trio_figure(recipePath, tempdir, ...
        'OutputDirectory', outputDirectory, 'Publish', false), 'triofig:InvalidRecipe');
    verifyFalse(testCase, isfolder(outputDirectory));
end
end

function testInteractiveHelpersKeepImagesAndUseRoiDisplayColors(testCase)
figureHandle = figure('Visible', 'off');
cleanup = onCleanup(@() closeIfValid(figureHandle)); %#ok<NASGU>
axesHandle = axes('Parent', figureHandle);
imshow(zeros(40, 40), 'Parent', axesHandle);

triofig.addCalibrationPoint(axesHandle, [10, 10]);
verifyNumElements(testCase, findobj(axesHandle, 'Type', 'image'), 1);
verifyNumElements(testCase, findobj(axesHandle, 'Type', 'line'), 1);

orange = triofig.roiDisplayColor('orange');
verifyEqual(testCase, orange, [1, 0.5, 0]);
roi = drawrectangle(axesHandle, 'Position', [5, 5, 10, 10], 'Color', orange);
[position, completed] = triofig.roiPosition(roi, figureHandle);
verifyTrue(testCase, completed);
verifyEqual(testCase, position, [5, 5, 10, 10]);
end

function testDense4RecipeReplaysExactCandidateAndWritesLayout(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
repositoryRoot = fileparts(fileparts(pipelineRoot));
recipePath = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
verifyTrue(testCase, isfile(recipePath));
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');

outputDirectory = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(outputDirectory)); %#ok<NASGU>
result = replay_trio_figure(recipePath, dataRoot, ...
    'OutputDirectory', outputDirectory, 'Publish', false);

verifyTrue(testCase, isfolder(result.stagingDirectory));
verifyEqual(testCase, numel(result.outputs), 9);
verifyTrue(testCase, all([result.candidateComparison.samePixels]));
verifyEqual(testCase, result.status, 'complete');
verifyTrue(testCase, isfile(result.previewPath));
verifyTrue(testCase, isfile(fullfile(result.generationDirectory, 'latex', 'trio-layout.tex')));
layout = fileread(fullfile(result.generationDirectory, 'latex', 'trio-layout.tex'));
verifyTrue(testCase, contains(layout, '\TrioComparisonFigure'));
verifyTrue(testCase, contains(layout, '../assets'));
verifyTrue(testCase, contains(layout, 'orange/1'));
verifyTrue(testCase, contains(layout, 'cyan/2'));
end

function testReplayIsDeterministicAndOutputBundlesAreIsolated(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
repositoryRoot = fileparts(fileparts(pipelineRoot));
recipePath = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
dataRoot = localDataRoot();
testCase.assumeTrue(isfile(recipePath) && isfolder(dataRoot), ...
    'The dense4 recipe or local June 3 source data is unavailable.');

firstOutput = tempname;
secondOutput = tempname;
secondRecipePath = [tempname '.json'];
cleanup = onCleanup(@() localRemoveIfPresent({firstOutput, secondOutput, secondRecipePath})); %#ok<NASGU>
secondRecipe = triofig.readRecipe(recipePath);
secondRecipe.candidateOutputRelativePath = ...
    'candidate-outputs/figures-source/eyedrop_3_6_isolated';
secondRecipe.figure.id = 'eyedrop_3_6_isolated';
secondRecipe.figure.assetDirectoryFromWrapper = './eyedrop_3_6_isolated';
secondRecipe.comparison.requireExactCandidateMatchBeforePublish = false;
triofig.writeRecipe(secondRecipePath, secondRecipe);
first = replay_trio_figure(recipePath, dataRoot, ...
    'OutputDirectory', firstOutput, 'Publish', false);
second = replay_trio_figure(secondRecipePath, dataRoot, ...
    'OutputDirectory', secondOutput, 'Publish', false);

verifyNotEqual(testCase, first.stagingDirectory, second.stagingDirectory);
verifyEqual(testCase, {first.outputs.sha256}, {second.outputs.sha256});
verifyTrue(testCase, all(cellfun(@isfile, fullfile(first.generationDirectory, 'assets', {first.outputs.filename}))));
verifyTrue(testCase, all(cellfun(@isfile, fullfile(second.generationDirectory, 'assets', {second.outputs.filename}))));
end

function testPublishWritesCompleteBundleAfterExactComparison(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
repositoryRoot = fileparts(fileparts(pipelineRoot));
recipePath = fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
dataRoot = localDataRoot();
testCase.assumeTrue(isfile(recipePath) && isfolder(dataRoot), ...
    'The dense4 recipe or local June 3 source data is unavailable.');

outputDirectory = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(outputDirectory)); %#ok<NASGU>
result = replay_trio_figure(recipePath, dataRoot, ...
    'OutputDirectory', outputDirectory, 'Publish', true);

verifyEqual(testCase, result.status, 'complete');
verifyTrue(testCase, isfolder(result.generationDirectory));
verifyTrue(testCase, isfile(result.publishedManifestPath));
verifyTrue(testCase, isfile(fullfile(outputDirectory, 'trio-recipe.json')));
verifyTrue(testCase, isfile(fullfile(result.generationDirectory, 'latex', 'trio-layout.tex')));
verifyTrue(testCase, all(cellfun(@isfile, fullfile(result.generationDirectory, 'assets', {result.outputs.filename}))));
index = triofig.readFigureIndex(outputDirectory);
verifyEqual(testCase, index.latest, result.generationId);
verifyEmpty(testCase, index.selected);
end

function testLegacyDense4RunnerDelegatesToSharedReplay(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
legacyRoot = fullfile(pipelineRoot, 'eyedrop-2026-06-03-dense4');
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');
addpath(legacyRoot);
pathCleanup = onCleanup(@() rmpath(legacyRoot)); %#ok<NASGU>
outputDirectory = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(outputDirectory)); %#ok<NASGU>

result = run_figure_replay(dataRoot, 'OutputDirectory', outputDirectory, 'Publish', false);

verifyTrue(testCase, all([result.candidateComparison.samePixels]));
verifyTrue(testCase, isfile(fullfile(result.generationDirectory, 'latex', 'trio-layout.tex')));
end

function testLegacyDense4RunnerUsesLegacyEnvironmentFallback(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
legacyRoot = fullfile(pipelineRoot, 'eyedrop-2026-06-03-dense4');
dataRoot = localDataRoot();
testCase.assumeTrue(isfolder(dataRoot), ...
    'The local June 3 source data is unavailable on this machine.');
addpath(legacyRoot);
pathCleanup = onCleanup(@() rmpath(legacyRoot)); %#ok<NASGU>
previousRoot = getenv('EYEDROP_20260603_DATA_ROOT');
environmentCleanup = onCleanup(@() setenv('EYEDROP_20260603_DATA_ROOT', previousRoot)); %#ok<NASGU>
setenv('EYEDROP_20260603_DATA_ROOT', dataRoot);
outputDirectory = tempname;
cleanup = onCleanup(@() localRemoveIfPresent(outputDirectory)); %#ok<NASGU>

result = run_figure_replay('OutputDirectory', outputDirectory, 'Publish', false);

verifyTrue(testCase, all([result.candidateComparison.samePixels]));
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
    elseif isfile(paths{index})
        delete(paths{index});
    end
end
end

function closeIfValid(figureHandle)
if isgraphics(figureHandle)
    close(figureHandle);
end
end
