function tests = test_trio_manifest_recovery
%TEST_TRIO_MANIFEST_RECOVERY Missing-manifest setup and replay contracts.
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
pipelineRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(pipelineRoot);
testCase.TestData.pipelineRoot = pipelineRoot;
end

function testMissingManifestOffersRecoveryOrBrowse(testCase)
state = struct('status', 'missing', 'candidates', {{}});
[path, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ChoiceFcn', @(varargin) 'Recover run info');
verifyTrue(testCase, completed);
verifyEmpty(testCase, path);
[path, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ChoiceFcn', @(varargin) 'Browse', 'FileFcn', @pickManifest);
verifyTrue(testCase, completed);
verifyEqual(testCase, path, fullfile(tempdir, 'original.json'));
[~, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ChoiceFcn', @(varargin) 'Cancel');
verifyFalse(testCase, completed);
end

function [name, folder] = pickManifest(varargin)
name = 'original.json';
folder = tempdir;
end

function testExistingManifestIsStillSelected(testCase)
state = struct('status', 'single', 'candidates', {{'existing.json'}});
[path, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ChoiceFcn', @(varargin) 'Use manifest');
verifyTrue(testCase, completed);
verifyEqual(testCase, path, 'existing.json');
end

function testAmbiguousManifestsPermitSelectionOrRecovery(testCase)
state = struct('status', 'ambiguous', 'candidates', {{'first.json', 'second.json'}});
[path, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ListFcn', @(varargin) deal(2, true));
verifyTrue(testCase, completed);
verifyEqual(testCase, path, 'second.json');
[path, completed] = triofig.selectRunManifest(tempdir, state, ...
    'ListFcn', @(varargin) deal(3, true));
verifyTrue(testCase, completed);
verifyEmpty(testCase, path);
end

function testRecoveryKeepsConfigEvidenceAndReviewedPath(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct('generation_id', 'gen_saved'));
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
[info, completed] = recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) varargin{4});
verifyTrue(testCase, completed);
verifyEqual(testCase, info.generationId, 'gen_saved');
verifyTrue(testCase, contains(info.generationIdSource, 'config_json.generation_id'));
verifyEqual(testCase, info.stageId, 'candidate7');
verifyTrue(testCase, contains(info.stageIdSource, 'workspace path'));
verifyEqual(testCase, info.availableRunRelativePath, 'algo_run/selected');
verifyEqual(testCase, info.workspaceSha256, triofig.fileSha256(workspacePath));
verifyFalse(testCase, isfile(fullfile(dataRoot, 'algo_run', 'selected', ...
    'experiment_manifest.json')));
end

function testRecoveryRecordsUserSuppliedAndUnknownValues(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct());
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
answers = {'manual_gen', 'Lab notebook page 12', '', '', ...
    'algo_run/selected', 'Reviewed workspace directory', 'Manifest was lost'};
[info, completed] = recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) answers);
verifyTrue(testCase, completed);
verifyEqual(testCase, info.generationId, 'manual_gen');
verifyEqual(testCase, info.generationIdSource, 'Lab notebook page 12');
verifyEqual(testCase, info.stageId, 'unknown');
verifyEqual(testCase, info.stageIdSource, 'unknown');
verifyEqual(testCase, info.note, 'Manifest was lost');
[info, completed] = recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) {});
verifyFalse(testCase, completed);
verifyEmpty(testCase, info);
end

function testGenerationIsNotGuessedFromAcquisitionFilename(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct());
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
info = recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) varargin{4});
verifyEqual(testCase, info.generationId, 'unknown');
verifyEqual(testCase, info.generationIdSource, 'unknown');
end

function testEditingSuggestedIdDoesNotRetainUnsupportedSource(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct('generation_id', 'gen_saved'));
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
info = recover_trio_run_info(dataRoot, workspacePath, 'DialogFcn', @editGeneration);
verifyEqual(testCase, info.generationId, 'edited_gen');
verifyEqual(testCase, info.generationIdSource, 'User supplied; evidence unknown');
end

function answers = editGeneration(varargin)
answers = varargin{4};
answers{1} = 'edited_gen';
end

function testRecoveryValidatesWorkspaceBeforePrompting(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct());
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
config_json = '{}';
save(workspacePath, 'config_json');
verifyError(testCase, @() recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) error('Unexpected metadata dialog')), 'triofig:InvalidWorkspace');
end

function testWorkspaceDirectlyUnderDataRootHasUsableDefaults(testCase)
[dataRoot, workspacePath] = makeWorkspace(struct());
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
flatPath = fullfile(dataRoot, 'workspace.mat');
copyfile(workspacePath, flatPath);
info = recover_trio_run_info(dataRoot, flatPath, 'DialogFcn', @(varargin) varargin{4});
verifyEqual(testCase, info.availableRunRelativePath, '.');
verifyEqual(testCase, info.stageId, 'unknown');
verifyEqual(testCase, info.generationId, 'unknown');
end

function testRecoveredRecipeReplaysAndCarriesProvenance(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
result = replay_trio_figure(recipePath, dataRoot, ...
    'OutputDirectory', fullfile(dataRoot, 'output'), 'Publish', false);
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.schemaVersion, 6);
verifyEqual(testCase, manifest.reconstruction.manifestStatus, 'absent');
verifyEqual(testCase, manifest.reconstruction.generationId, 'unknown');
verifyEqual(testCase, manifest.reconstruction.recovery, recipe.reconstruction.recovery);
verifyFalse(testCase, ismember('runManifest', {manifest.inputs.role}));
verifyEqual(testCase, numel(result.outputs), 9);
end

function testConfiguredMissingManifestDoesNotFallBack(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
recipe.reconstruction.manifestStatus = 'present';
recipe.reconstruction = rmfield(recipe.reconstruction, 'recovery');
recipe.input.runManifestRelativePath = 'missing.json';
recipe.reconstruction.localWorkspace = struct('manifestStatus','present', ...
    'stageId',recipe.reconstruction.stageId, ...
    'availableRunRelativePath',recipe.reconstruction.availableRunRelativePath, ...
    'manifestRecordedRunRelativePath',recipe.reconstruction.manifestRecordedRunRelativePath);
recipe.input.localRunManifestRelativePath = 'missing.json';
triofig.writeRecipe(recipePath, recipe);
verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), 'triofig:MissingInput');
verifyFalse(testCase, isfolder(fullfile(dataRoot, 'output')));
end

function testRecoveryStillRequiresImagesAndWorkspace(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
fields = {'workspaceRelativePath', 'mainCaptureRelativePath', ...
    'thorcamCaptureRelativePath', 'validationCaptureRelativePath'};
for index = 1:numel(fields)
    broken = recipe;
    broken.input.(fields{index}) = 'missing';
    if strcmp(fields{index}, 'workspaceRelativePath')
        broken.reconstruction.recovery.workspaceRelativePath = 'missing';
        broken.input.localWorkspaceRelativePath = 'missing';
        broken.reconstruction.localWorkspace.recovery.workspaceRelativePath = 'missing';
    end
    triofig.writeRecipe(recipePath, broken);
    verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), 'triofig:MissingInput');
end
verifyFalse(testCase, isfolder(fullfile(dataRoot, 'output')));
end

function testRecoveryIsBoundToReviewedWorkspace(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
recipe.reconstruction.recovery.workspaceSha256 = repmat('0', 1, 64);
recipe.reconstruction.localWorkspace.recovery.workspaceSha256 = repmat('0', 1, 64);
triofig.writeRecipe(recipePath, recipe);
verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), ...
    'triofig:InvalidRunInfo');
end

function testRecoveryStillRejectsUnreadableCameraAndInvalidWorkspace(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
writeJson(fullfile(dataRoot, recipe.input.thorcamCaptureRelativePath), struct());
verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), 'triofig:InvalidImage');
imwrite(uint8(reshape(1:1024, 32, 32)), ...
    fullfile(dataRoot, recipe.input.thorcamCaptureRelativePath));
config_json = '{}';
save(fullfile(dataRoot, recipe.input.workspaceRelativePath), 'config_json');
verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), 'triofig:InvalidWorkspace');
end

function testLegacyV2RecipeStillRequiresManifest(testCase)
[dataRoot, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
recipe.schemaVersion = 2;
recipe.presentation = rmfield(recipe.presentation, 'display');
recipe.reconstruction = rmfield(recipe.reconstruction, {'manifestStatus', 'recovery'});
recipe.input.runManifestRelativePath = 'original.json';
writeJson(fullfile(dataRoot, 'original.json'), ...
    struct('generation_id', 'unknown', 'datasets', {{'scene'}}));
triofig.writeRecipe(recipePath, recipe);
result = replay_trio_figure(recipePath, dataRoot, ...
    'OutputDirectory', fullfile(dataRoot, 'output'), 'Publish', false);
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.schemaVersion, 2);
verifyTrue(testCase, ismember('runManifest', {manifest.inputs.role}));
delete(fullfile(dataRoot, 'original.json'));
verifyError(testCase, @() replay_trio_figure(recipePath, dataRoot), 'triofig:MissingInput');
end

function testAbsentManifestNeedsExplicitRecoveryRecord(testCase)
[dataRoot, ~, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(dataRoot, 's')); %#ok<NASGU>
broken = recipe;
broken.reconstruction = rmfield(broken.reconstruction, 'recovery');
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
broken = recipe;
broken.input.runManifestRelativePath = 'original.json';
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
broken = recipe;
broken.input.expectedGenerationId = 'different';
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
broken = recipe;
broken.reconstruction.recovery = [recipe.reconstruction.recovery, recipe.reconstruction.recovery];
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
end

function [dataRoot, workspacePath] = makeWorkspace(config)
dataRoot = tempname;
folder = fullfile(dataRoot, 'algo_run', 'selected', 'runs', 'stage1', 'candidate7', 'scene');
mkdir(folder);
workspacePath = fullfile(folder, 'workspace.mat');
average_rectified_global_image = reshape(1:1024, 32, 32);
average_rectified_image = average_rectified_global_image .^ 0.9;
config_json = jsonencode(config);
save(workspacePath, 'average_rectified_global_image', 'average_rectified_image', 'config_json');
end

function testSchema5IndependentIntensityRetainsMissingManifestRecovery(testCase)
[root, recipePath, recipe] = makeFixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
recipe = triofig.setIntensityMode(recipe, 'separate');
recipe.presentation.intensityMultipliers.global = .7;
recipe.presentation.intensityMultipliers.local = 1.4;
triofig.writeRecipe(recipePath, recipe);
result = replay_trio_figure(recipePath, root, 'OutputDirectory', fullfile(root, 'v4-output'), 'Publish', false);
verifyEqual(testCase, result.status, 'complete');
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.reconstruction.manifestStatus, 'absent');
verifyEqual(testCase, manifest.reconstruction.recovery, recipe.reconstruction.recovery);
verifyEqual(testCase, manifest.intensity.mode, 'separate');
end

function [dataRoot, recipePath, recipe] = makeFixture()
[dataRoot, workspacePath] = makeWorkspace(struct());
info = recover_trio_run_info(dataRoot, workspacePath, ...
    'DialogFcn', @(varargin) varargin{4});
recipe = triofig.defaultRecipe('scene', 'candidate-outputs/figures-source/scene');
recipe.presentation.display.method = 'legacyMinMax';
recipe.input.workspaceRelativePath = info.workspaceRelativePath;
recipe.input.runManifestRelativePath = '';
recipe.input.expectedGenerationId = info.generationId;
recipe.reconstruction.availableRunRelativePath = info.availableRunRelativePath;
recipe.reconstruction.stageId = info.stageId;
recipe.reconstruction.manifestStatus = 'absent';
recipe.reconstruction.recovery = info;
recipe.input.workspaceMode = 'shared';
recipe.input.localWorkspaceRelativePath = info.workspaceRelativePath;
recipe.input.workspaceSha256 = info.workspaceSha256;
recipe.input.localWorkspaceSha256 = info.workspaceSha256;
recipe.input.localRunManifestRelativePath = '';
recipe.input.expectedLocalGenerationId = info.generationId;
recipe.reconstruction.localWorkspace = struct('manifestStatus','absent', ...
    'stageId',info.stageId,'availableRunRelativePath',info.availableRunRelativePath, ...
    'manifestRecordedRunRelativePath','','recovery',info);
names = {'main', 'thorcam', 'validation'};
for index = 1:numel(names)
    name = names{index};
    relative = [name '.png'];
    imwrite(uint8(reshape(mod(1:1024, 255), 32, 32)), fullfile(dataRoot, relative));
    recipe.input.([name 'CaptureRelativePath']) = relative;
end
recipe.registration.transformSource = 'saved';
recipe.registration.cropMode = 'saved';
recipe.registration.crop = struct('rowStartOneBased', 2, ...
    'columnStartOneBased', 2, 'height', 24, 'width', 24);
recipe.cameraPreparation.thorcam.rotationDegrees = 0;
recipe.cameraPreparation.thorcam.flipVertical = false;
recipe.cameraPreparation.validation.rotationDegrees = 0;
recipePath = fullfile(dataRoot, 'recipe.json');
triofig.writeRecipe(recipePath, recipe);
end

function writeJson(path, value)
file = fopen(path, 'w');
cleanup = onCleanup(@() fclose(file)); %#ok<NASGU>
fprintf(file, '%s', jsonencode(value));
end
