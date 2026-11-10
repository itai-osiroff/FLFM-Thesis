function tests = test_trio_generation_history
tests = functiontests(localfunctions);
end

function testPreviewHistorySelectionAndFailure(testCase)
[root, source] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
figureRoot = fullfile(root, 'figure with spaces');
first = preview_trio_figure(source, 'OutputDirectory', figureRoot);
verifyEqual(testCase, first.status, 'complete');
verifyTrue(testCase, isfile(first.previewPath));
select_trio_figure(figureRoot, first.generationId);
selectedHash = triofig.fileSha256(fullfile(figureRoot, 'selected', 'preview.pdf'));
second = preview_trio_figure(first.generationDirectory);
verifyEqual(testCase, second.status, 'complete');
verifyNotEqual(testCase, first.generationId, second.generationId);
verifyTrue(testCase, isfile(first.previewPath));
index = jsondecode(fileread(fullfile(figureRoot, 'figure-index.json')));
verifyEqual(testCase, index.latest, second.generationId);
verifyEqual(testCase, index.selected, first.generationId);
verifyEqual(testCase, triofig.fileSha256(fullfile(figureRoot, 'selected', 'preview.pdf')), selectedHash);
% A leftover backup signals an interrupted selection and must not be deleted.
mkdir(fullfile(figureRoot, '.selected-backup'));
verifyError(testCase, @() select_trio_figure(figureRoot, second.generationId), 'triofig:SelectionRecoveryRequired');
verifyEqual(testCase, triofig.fileSha256(fullfile(figureRoot, 'selected', 'preview.pdf')), selectedHash);
rmdir(fullfile(figureRoot, '.selected-backup'));
% Failure of the disposable README after the JSON commit must not roll back
% only the export and leave index.selected pointing at a different version.
delete(fullfile(figureRoot, 'README.md'));
mkdir(fullfile(figureRoot, 'README.md'));
select_trio_figure(figureRoot, second.generationId);
index = triofig.readFigureIndex(figureRoot);
verifyEqual(testCase, index.selected, second.generationId);
verifyEqual(testCase, triofig.fileSha256(fullfile(figureRoot, 'selected', 'preview.pdf')), triofig.fileSha256(second.previewPath));
rmdir(fullfile(figureRoot, 'README.md'));
failed = preview_trio_figure(second.generationDirectory, 'CompilerExecutable', 'missing-trio-compiler-xyz');
verifyEqual(testCase, failed.status, 'incomplete');
verifyTrue(testCase, isfile(failed.manifestPath));
verifyTrue(testCase, isfolder(fullfile(failed.generationDirectory, 'assets')));
index = jsondecode(fileread(fullfile(figureRoot, 'figure-index.json')));
verifyEqual(testCase, index.latest, second.generationId);
verifyError(testCase, @() select_trio_figure(figureRoot, failed.generationId), 'triofig:NotSelectable');
end

function testCompilerFailureKeepsLogAndSnapshot(testCase)
[root, source] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
path = fullfile(source, 'trio-comparison-template.tex');
writeText(path, '\thisCommandDoesNotExist');
result = preview_trio_figure(source, 'OutputDirectory', fullfile(root, 'figure'));
verifyEqual(testCase, result.status, 'incomplete');
verifyTrue(testCase, isfile(fullfile(result.generationDirectory, 'build', 'compiler.log')));
verifyTrue(testCase, contains(fileread(fullfile(result.generationDirectory, 'build', 'compiler.log')), 'Undefined control sequence'));
end

function testLockRejectsSecondWriter(testCase)
root = tempname;
mkdir(root);
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
lock = triofig.lockFigure(root); %#ok<NASGU>
verifyError(testCase, @() triofig.lockFigure(root), 'triofig:FigureLocked');
end

function testMigrationIsHashVerifiedAndRepeatable(testCase)
[root, source] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
before = triofig.fileSha256(fullfile(source, 'global_average.png'));
results = migrate_trio_figures(root);
verifyEqual(testCase, numel(results), 1);
verifyEqual(testCase, results{1}.status, 'complete');
index = triofig.readFigureIndex(source);
verifyEmpty(testCase, index.selected);
verifyEqual(testCase, numel(index.generations), 2);
legacy = fullfile(source, 'generations', index.migration.generationId);
verifyEqual(testCase, triofig.fileSha256(fullfile(legacy, 'legacy-original', 'bundle', 'global_average.png')), before);
verifyFalse(testCase, isfile(fullfile(source, 'global_average.png')));
migrate_trio_figures(root);
again = triofig.readFigureIndex(source);
verifyEqual(testCase, numel(again.generations), 2);
end

function testReplayRetainsHistoryAndComparisonFailure(testCase)
[root, ~] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
recipe = triofig.defaultRecipe('scene', 'candidate-outputs/figures-source/scene');
recipe.presentation.display.method = 'legacyMinMax';
average_rectified_global_image = reshape(1:1024, 32, 32);
average_rectified_image = average_rectified_global_image .^ 0.9;
config_json = '{}';
save(fullfile(root, 'workspace.mat'), 'average_rectified_global_image', 'average_rectified_image', 'config_json');
recipe.input.workspaceRelativePath = 'workspace.mat';
for name = {'main', 'thorcam', 'validation'}
    path = [name{1} '.png'];
    imwrite(uint8(mod(average_rectified_global_image, 255)), fullfile(root, path));
    recipe.input.([name{1} 'CaptureRelativePath']) = path;
end
recipe.input.runManifestRelativePath = 'experiment.json';
triofig.writeJsonFile(fullfile(root, 'experiment.json'), struct('generation_id', 'unknown', 'scene', 'scene'));
recipe.registration.transformSource = 'saved';
recipe.registration.cropMode = 'saved';
recipe.registration.crop = struct('rowStartOneBased', 2, 'columnStartOneBased', 2, 'height', 24, 'width', 24);
recipe.cameraPreparation.thorcam.rotationDegrees = 0;
recipe.cameraPreparation.thorcam.flipVertical = false;
recipe.cameraPreparation.validation.rotationDegrees = 0;
recipePath = fullfile(root, 'synthetic-recipe.json');
triofig.writeRecipe(recipePath, recipe);
destination = fullfile(root, 'history');
first = replay_trio_figure(recipePath, root, 'OutputDirectory', destination);
verifyEqual(testCase, first.status, 'complete');
recipe.comparison.requireExactCandidateMatchBeforePublish = true;
triofig.writeRecipe(recipePath, recipe);
second = replay_trio_figure(recipePath, root, 'OutputDirectory', destination, ...
    'ReferenceDirectory', first.generationDirectory);
verifyEqual(testCase, second.status, 'complete');
verifyEqual(testCase, {first.outputs.sha256}, {second.outputs.sha256});
recipe.presentation.intensityMultipliers.globalLocal = 1.5;
triofig.writeRecipe(recipePath, recipe);
failed = replay_trio_figure(recipePath, root, 'OutputDirectory', destination, ...
    'ReferenceDirectory', first.generationDirectory);
verifyEqual(testCase, failed.status, 'incomplete');
verifyEqual(testCase, failed.error.identifier, 'triofig:CandidateMismatch');
index = triofig.readFigureIndex(destination);
verifyEqual(testCase, index.latest, second.generationId);
verifyEqual(testCase, numel(index.generations), 3);
verifyTrue(testCase, isfile(first.previewPath));
inspection = replay_trio_figure(second.recipePath, root, 'Publish', false);
verifyEqual(testCase, inspection.outputDirectory, destination);
index = triofig.readFigureIndex(destination);
verifyEqual(testCase, index.latest, second.generationId);
end

function testAllocatedAttemptIsIndexed(testCase)
root = tempname;
mkdir(root);
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
lock = triofig.lockFigure(root); %#ok<NASGU>
[~, record] = triofig.newGeneration(root, 'replay', '');
index = triofig.readFigureIndex(root);
verifyEqual(testCase, numel(index.generations), 1);
verifyEqual(testCase, index.generations{1}.id, record.id);
verifyEqual(testCase, index.generations{1}.status, 'incomplete');
verifyEmpty(testCase, index.latest);
end

function testSavedRendererAndSourceIntegrity(testCase)
[root, source] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
template = fullfile(source, 'trio-comparison-template.tex');
fid = fopen(template, 'a');
fprintf(fid, '\n%% Saved renderer marker\n');
fclose(fid);
first = preview_trio_figure(source, 'OutputDirectory', fullfile(root, 'history'));
second = preview_trio_figure(first.generationDirectory);
verifyEqual(testCase, triofig.fileSha256(fullfile(second.generationDirectory, 'latex', 'trio-comparison-template.tex')), triofig.fileSha256(template));
current = preview_trio_figure(first.generationDirectory, 'UseCurrentTemplate', true);
verifyNotEqual(testCase, triofig.fileSha256(fullfile(current.generationDirectory, 'latex', 'trio-comparison-template.tex')), triofig.fileSha256(template));
fid = fopen(fullfile(first.generationDirectory, 'assets', 'global_average.png'), 'a');
fprintf(fid, 'changed');
fclose(fid);
verifyError(testCase, @() preview_trio_figure(first.generationDirectory), 'triofig:ChangedGeneration');
verifyError(testCase, @() select_trio_figure(first.outputDirectory, first.generationId), 'triofig:NotSelectable');
end

function testLegacyApprovalRequiresMatchingRecipeAndAssets(testCase)
[root, source] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
recipe = fullfile(source, 'trio-recipe.json');
files = dir(fullfile(source, '*.png'));
outputs = repmat(struct('filename', '', 'sha256', ''), 9, 1);
for k = 1:numel(files)
    outputs(k) = struct('filename', files(k).name, 'sha256', triofig.fileSha256(fullfile(source, files(k).name)));
end
old = struct('recipe', struct('sha256', triofig.fileSha256(recipe)), ...
    'outputs', outputs, 'candidateComparison', repmat(struct('samePixels', true), 9, 1));
verifyTrue(testCase, triofig.legacyComparisonApproval(recipe, source, old));
fid = fopen(recipe, 'a');
fprintf(fid, ' ');
fclose(fid);
verifyFalse(testCase, triofig.legacyComparisonApproval(recipe, source, old));
old.recipe.sha256 = triofig.fileSha256(recipe);
fid = fopen(fullfile(source, files(1).name), 'a');
fprintf(fid, 'changed');
fclose(fid);
verifyFalse(testCase, triofig.legacyComparisonApproval(recipe, source, old));
end

function [root, source] = fixture()
root = tempname;
source = fullfile(root, 'legacy source');
mkdir(source);
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
repo = fileparts(fileparts(pipelineRoot));
original = fullfile(repo, 'candidate-outputs', 'figures-source', 'eyedrop_3_6');
assets = original;
layout = fullfile(original, 'trio-layout.tex');
if isfile(fullfile(original, 'figure-index.json'))
    index = triofig.readFigureIndex(original);
    saved = fullfile(original, 'generations', index.migration.generationId);
    assets = fullfile(saved, 'assets');
    layout = fullfile(saved, 'latex', 'trio-layout.tex');
end
files = dir(fullfile(assets, '*.png'));
for k = 1:numel(files)
    copyfile(fullfile(assets, files(k).name), source);
end
copyfile(layout, fullfile(source, 'trio-layout.tex'));
copyfile(fullfile(original, 'trio-recipe.json'), source);
recipe = triofig.readRecipe(fullfile(source, 'trio-recipe.json'));
recipe.comparison.requireExactCandidateMatchBeforePublish = false;
triofig.writeRecipe(fullfile(source, 'trio-recipe.json'), recipe);
copyfile(fullfile(repo, 'candidate-outputs', 'figures-source', 'trio-comparison-template.tex'), source);
end

function writeText(path, value)
fid = fopen(path, 'w');
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '%s', value);
end
