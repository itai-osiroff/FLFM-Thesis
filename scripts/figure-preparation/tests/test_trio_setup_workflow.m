function tests = test_trio_setup_workflow
tests = functiontests(localfunctions);
end

function testRepositoryRecordFromCurrentFolderOnly(testCase)
originalFolder = pwd;
originalPath = path;
cleanup = onCleanup(@() restoreEnvironment(originalFolder, originalPath)); %#ok<NASGU>
pipeline = fileparts(fileparts(mfilename('fullpath')));
cd(pipeline);
rmpath(pipeline);
clear triofig.fileSha256 triofig.repositoryRecord
beforePath = path;
record = triofig.repositoryRecord();
verifyEqual(testCase, pwd, pipeline);
verifyEqual(testCase, path, beforePath);
verifyNotEmpty(testCase, record.files);
verifyTrue(testCase, all(cellfun(@(v) numel(v) == 64, {record.files.sha256})));
end

function restoreEnvironment(folder, savedPath)
cd(folder);
path(savedPath);
end

function testRepositoryPathWithSpacesAndMetadataFailures(testCase)
pipeline = fileparts(fileparts(mfilename('fullpath')));
repo = fileparts(fileparts(pipeline));
root = fullfile(tempname, 'repository with spaces');
copied = fullfile(root, 'scripts', 'figure-preparation');
mkdir(copied);
copyfile(fullfile(pipeline, '*.m'), copied);
copyfile(fullfile(pipeline, '+triofig'), fullfile(copied, '+triofig'));
oldPath = path; oldFolder = pwd;
cleanup = onCleanup(@() restoreCopiedRepository(root, oldFolder, oldPath)); %#ok<NASGU>
system(['git init -q "' root '"']);
addpath(copied, '-begin');
clear triofig.repositoryRecord replay_trio_figure preview_trio_figure
record = triofig.repositoryRecord();
verifyTrue(testCase, record.relevantWorkingTreeDirty);
verifyEqual(testCase, pwd, oldFolder);
writeText(fullfile(copied, '+triofig', 'repositoryRecord.m'), sprintf( ...
    'function record=repositoryRecord()\nerror(''triofig:TestRepositoryFailure'',''Forced metadata failure'');\nend\n'));
clear triofig.repositoryRecord
source = fullfile(root, 'preview source'); mkdir(source);
names = {'thorcam_downsampled', 'global_average', 'local_average', ...
    'thorcam_zoom_1', 'thorcam_zoom_2', 'global_zoom_1', 'global_zoom_2', 'local_zoom_1', 'local_zoom_2'};
for k = 1:numel(names), imwrite(uint8([0, 128; 192, 255]), fullfile(source, [names{k} '.png'])); end
writeText(fullfile(source, 'trio-layout.tex'), 'unused layout');
copyfile(fullfile(repo, 'candidate-outputs', 'figures-source', 'trio-comparison-template.tex'), source);
[recipe, data] = dialogFixture();
[recipePath, dataRoot] = rawFixture(root, recipe, data);
for operation = {'preview', 'replay'}
    output = fullfile(root, ['failed-' operation{1}]);
    if strcmp(operation{1}, 'preview')
        result = preview_trio_figure(source, 'OutputDirectory', output);
    else
        result = replay_trio_figure(recipePath, dataRoot, 'OutputDirectory', output);
    end
    verifyEqual(testCase, result.status, 'incomplete');
    verifyEqual(testCase, result.error.identifier, 'triofig:TestRepositoryFailure');
    manifest = jsondecode(fileread(result.manifestPath));
    verifyEqual(testCase, manifest.generation.error.message, 'Forced metadata failure');
    index = triofig.readFigureIndex(output);
    verifyEmpty(testCase, index.latest);
    verifyEmpty(testCase, index.selected);
end
% A snapshot copy can fail after allocation too; retain that diagnostic.
copyfile(fullfile(pipeline, '+triofig', 'repositoryRecord.m'), ...
    fullfile(copied, '+triofig', 'repositoryRecord.m'), 'f');
source = fileread(fullfile(copied, '+triofig', 'newGeneration.m'));
writeText(fullfile(copied, '+triofig', 'realNewGeneration.m'), ...
    strrep(source, 'function [directory, record] = newGeneration(', ...
        'function [directory, record] = realNewGeneration('));
writeText(fullfile(copied, '+triofig', 'newGeneration.m'), sprintf( ...
    'function [d,r]=newGeneration(varargin)\n[d,r]=triofig.realNewGeneration(varargin{:});\ndelete(''%s'');\nend\n', ...
    strrep(recipePath, '''', '''''')));
clear triofig.repositoryRecord triofig.newGeneration
result = replay_trio_figure(recipePath, dataRoot, 'OutputDirectory', fullfile(root, 'snapshot-failure'));
verifyEqual(testCase, result.status, 'incomplete');
verifyNotEmpty(testCase, result.error.identifier);
manifest = jsondecode(fileread(result.manifestPath));
verifyNotEmpty(testCase, manifest.generation.error.message);
end

function restoreCopiedRepository(root, folder, savedPath)
restoreEnvironment(folder, savedPath);
clear triofig.repositoryRecord replay_trio_figure preview_trio_figure
clear triofig.newGeneration triofig.realNewGeneration
rmdir(fileparts(root), 's');
end

function testZoomDialogRepairsRetainedOutOfBoundsRegions(testCase)
[recipe, data] = dialogFixture();
recipe.registration.crop.width = 12;
recipe.registration.crop.height = 14;
setappdata(groot, 'trioDialogError', []);
task = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
    'TimerFcn', @(source, ~) repairZoom(source));
cleanup = onCleanup(@() disposeTimer(task)); %#ok<NASGU>
start(task);
[edited, action] = triofig.setupDialog(5, recipe, data);
problem = getappdata(groot, 'trioDialogError');
if ~isempty(problem), rethrow(problem); end
verifyEqual(testCase, action, 'next');
verifyEqual(testCase, [edited.presentation.zoomRois.xZeroBased], [0, 5]);
verifyEqual(testCase, [edited.presentation.zoomRois.yZeroBased], [0, 5]);
end

function repairZoom(task)
fig = findall(groot, 'Tag', 'trio-setup');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
stop(task);
try
    next = findobj(fig, 'Tag', 'setup-next');
    assert(strcmp(next.Enable, 'off'));
    tags = {'zoom-x', 'zoom-y', 'zoom-width', 'zoom-height'};
    for region = 1:2
        if region == 2
            selector = findobj(fig, 'Tag', 'zoom-selector');
            selector.Value = '2'; selector.ValueChangedFcn(selector, []);
        end
        values = [1, 1, 4, 4];
        if region == 2, values = [6, 6, 4, 4]; end
        for k = 1:4
            field = findobj(fig, 'Tag', tags{k}); field.Value = num2str(values(k));
        end
        field.ValueChangedFcn(field, []);
    end
    assert(strcmp(next.Enable, 'on'));
    next.ButtonPushedFcn(next, []);
catch cause
    setappdata(groot, 'trioDialogError', cause);
    uiresume(fig);
end
end

function [recipePath, root] = rawFixture(parent, recipe, data)
root = fullfile(parent, 'raw'); mkdir(root);
image = uint16(mat2gray(data.globalImage) * 65535);
imwrite(image, fullfile(root, 'main.tif'));
imwrite(image, fullfile(root, 'thorcam.tif'));
imwrite(image, fullfile(root, 'validation.tif'));
average_rectified_global_image = data.globalImage; %#ok<NASGU>
average_rectified_image = data.localImage; %#ok<NASGU>
config_json = '{}'; %#ok<NASGU>
save(fullfile(root, 'workspace.mat'), 'average_rectified_global_image', 'average_rectified_image', 'config_json');
writeText(fullfile(root, 'experiment_manifest.json'), '{"generation_id":"test-run","scene":"test"}');
recipe.input.mainCaptureRelativePath = 'main.tif';
recipe.input.thorcamCaptureRelativePath = 'thorcam.tif';
recipe.input.validationCaptureRelativePath = 'validation.tif';
recipe.input.workspaceRelativePath = 'workspace.mat';
recipe.input.runManifestRelativePath = 'experiment_manifest.json';
recipe.input.expectedGenerationId = 'test-run';
recipePath = fullfile(root, 'recipe.json');
triofig.writeRecipe(recipePath, recipe);
end

function testSeparateBrightnessAndRelinkingPreserveSharedNormalization(testCase)
[recipe, data] = dialogFixture();
recipe.presentation.intensityMultipliers.globalLocal = 1.7;
separate = triofig.setIntensityMode(recipe, 'separate');
verifyEqual(testCase, separate.schemaVersion, 4);
verifyEqual(testCase, separate.presentation.intensityMultipliers.global, 1.7);
verifyEqual(testCase, separate.presentation.intensityMultipliers.local, 1.7);
separate.presentation.intensityMultipliers.global = .5;
separate.presentation.intensityMultipliers.local = 2;
triofig.validateRecipe(separate);
baseline = triofig.setupPreview(data, separate, true);
[preview, clipping] = triofig.applySetupIntensity(baseline, separate.presentation);
export = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, separate);
verifyEqual(testCase, preview.global, export.global);
verifyEqual(testCase, preview.local, export.local);
verifyEqual(testCase, export.global, baseline.global * .5);
verifyEqual(testCase, export.local, min(baseline.local * 2, 1));
verifyGreaterThan(testCase, clipping.local, 0);
verifyEqual(testCase, export.intensity.mode, 'separate');
verifyEqual(testCase, export.intensity.globalMultiplier, .5);
verifyEqual(testCase, export.intensity.localMultiplier, 2);
linked = triofig.setIntensityMode(separate, 'linked');
verifyEqual(testCase, linked.presentation.intensityMultipliers.globalLocal, .5);
linkedAgain = triofig.setIntensityMode(linked, 'separate');
verifyEqual(testCase, linkedAgain.presentation.intensityMultipliers.local, .5);
broken = separate;
broken.schemaVersion = 3;
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
broken = separate;
broken.presentation.intensityMultipliers.local = NaN;
verifyError(testCase, @() triofig.validateRecipe(broken), 'triofig:InvalidRecipe');
legacy = recipe;
legacy.schemaVersion = 2;
legacy.reconstruction = rmfield(legacy.reconstruction, {'manifestStatus', 'stageId'});
upgraded = triofig.setIntensityMode(legacy, 'separate');
triofig.validateRecipe(upgraded);
verifyEqual(testCase, upgraded.reconstruction.manifestStatus, 'present');
end

function testIndependentBrightnessDraftAndExportMetadata(testCase)
[recipe, data] = dialogFixture();
parent = tempname; mkdir(parent);
cleanup = onCleanup(@() rmdir(parent, 's')); %#ok<NASGU>
recipe = triofig.setIntensityMode(recipe, 'separate');
recipe.presentation.intensityMultipliers.global = .6;
recipe.presentation.intensityMultipliers.local = 1.9;
[recipePath, root] = rawFixture(parent, recipe, data);
recipe = triofig.readRecipe(recipePath);
selected = struct('main', fullfile(root, 'main.tif'), 'thorcam', fullfile(root, 'thorcam.tif'), ...
    'validation', fullfile(root, 'validation.tif'), 'workspace', fullfile(root, 'workspace.mat'), ...
    'runManifest', fullfile(root, 'experiment_manifest.json'));
draft = triofig.newSetupDraft(recipe, root, selected);
path = fullfile(root, 'setup-draft.json');
triofig.saveSetupDraft(path, draft);
[saved, issue] = triofig.loadSetupDraft(path, root);
verifyEmpty(testCase, issue);
verifyEqual(testCase, saved.recipe.presentation.intensityMode, 'separate');
verifyEqual(testCase, saved.recipe.presentation.intensityMultipliers.local, 1.9);
result = replay_trio_figure(recipePath, root, 'OutputDirectory', fullfile(parent, 'output'));
verifyEqual(testCase, result.status, 'complete');
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.schemaVersion, 4);
verifyEqual(testCase, manifest.intensity.mode, 'separate');
verifyEqual(testCase, manifest.intensity.globalMultiplier, .6);
verifyEqual(testCase, manifest.intensity.localMultiplier, 1.9);
data.thorcam = imread(selected.thorcam); data.validation = imread(selected.validation);
baseline = triofig.setupPreview(data, saved.recipe, true);
prepared = triofig.applySetupIntensity(baseline, saved.recipe.presentation);
panels = triofig.renderPanels(prepared, saved.recipe.presentation.upsampleFactor);
verifyEqual(testCase, imread(fullfile(result.generationDirectory, 'assets', 'global_average.png')), panels.global);
verifyEqual(testCase, imread(fullfile(result.generationDirectory, 'assets', 'local_average.png')), panels.local);
draft.accepted(:) = true;
relinked = triofig.setIntensityMode(recipe, 'linked');
updated = triofig.updateSetupDraft(draft, relinked, 4, 'save');
verifyFalse(testCase, updated.accepted(4));
verifyFalse(testCase, updated.accepted(6));
end

function testIndependentBrightnessDialogAndActiveZoomRow(testCase)
[recipe, data] = dialogFixture();
for step = [4, 5]
    setappdata(groot, 'trioDialogError', []);
    task = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
        'TimerFcn', @(source, ~) driveNewControls(source, step));
    cleanup = onCleanup(@() disposeTimer(task));
    start(task);
    [edited, action] = triofig.setupDialog(step, recipe, data);
    problem = getappdata(groot, 'trioDialogError');
    if ~isempty(problem), rethrow(problem); end
    verifyEqual(testCase, action, 'next');
    if step == 4
        verifyEqual(testCase, edited.schemaVersion, 4);
        verifyEqual(testCase, edited.presentation.intensityMode, 'separate');
        verifyEqual(testCase, edited.presentation.intensityMultipliers.global, .6);
        verifyEqual(testCase, edited.presentation.intensityMultipliers.local, 1.9);
    else
        verifyEqual(testCase, edited.presentation.zoomRois, recipe.presentation.zoomRois);
    end
    clear cleanup
end
end

function driveNewControls(task, step)
fig = findall(groot, 'Tag', 'trio-setup');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
stop(task);
try
    if step == 4
        toggle = findobj(fig, 'Tag', 'separate-brightness');
        toggle.Value = true; toggle.ValueChangedFcn(toggle, []);
        globalField = findobj(fig, 'Tag', 'global-multiplier');
        localField = findobj(fig, 'Tag', 'local-multiplier');
        globalField.Value = .6; globalField.ValueChangedFcn(globalField, []);
        localField.Value = 1.9; localField.ValueChangedFcn(localField, []);
    else
        images = findall(fig, 'Type', 'image');
        assert(numel(images) == 6, 'Zoom selection must display three main images and one active zoom row.');
        selector = findobj(fig, 'Tag', 'zoom-selector');
        selector.Value = '2'; selector.ValueChangedFcn(selector, []);
        currentImages = findall(fig, 'Type', 'image');
        assert(all(arrayfun(@(h) any(h == currentImages), images)), 'Switching region must update existing image objects.');
        fig.WindowState = 'normal'; fig.Position = [30, 30, 1280, 860]; drawnow;
        selector.Value = '1'; selector.ValueChangedFcn(selector, []);
    end
    next = findobj(fig, 'Tag', 'setup-next');
    assert(strcmp(next.Enable, 'on'));
    next.ButtonPushedFcn(next, []);
catch cause
    setappdata(groot, 'trioDialogError', cause);
    uiresume(fig);
end
end

function testCheckpointRoundTripAndInputChanges(testCase)
[root, draft] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
path = fullfile(root, 'figure', 'setup-draft.json');
draft.accepted(:) = true;
draft.step = 5;
triofig.saveSetupDraft(path, draft);
[loaded, issue] = triofig.loadSetupDraft(path, root);
verifyEmpty(testCase, issue);
verifyEqual(testCase, loaded.step, 5);
verifyTrue(testCase, all(loaded.accepted));
verifyFalse(testCase, isfile(fullfile(root, 'figure', 'figure-index.json')));
writeText(fullfile(root, 'thorcam.tif'), 'changed capture');
[~, issue] = triofig.loadSetupDraft(path, root);
verifyTrue(testCase, contains(issue, 'thorcam'));
delete(fullfile(root, 'workspace.mat'));
[~, issue] = triofig.loadSetupDraft(path, root);
verifyTrue(testCase, contains(issue, 'workspace'));
end

function testMalformedDraftAndFailedSavePreserveCheckpoint(testCase)
[root, draft] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
path = fullfile(root, 'setup-draft.json');
triofig.saveSetupDraft(path, draft);
before = fileread(path);
broken = draft;
broken.recipe.badValue = @sin; % JSON serialization must fail before replacement.
verifyError(testCase, @() triofig.saveSetupDraft(path, broken), 'triofig:DraftWriteFailure');
verifyEqual(testCase, fileread(path), before);
writeText(path, '{broken');
[loaded, issue] = triofig.loadSetupDraft(path, root);
verifyEmpty(testCase, loaded);
verifyNotEmpty(testCase, issue);
writeText(path, '{"schemaVersion":1,"step":99}');
[loaded, issue] = triofig.loadSetupDraft(path, root);
verifyEmpty(testCase, loaded);
verifyNotEmpty(testCase, issue);
end

function testBackPreservesChoicesAndChangesRequireReview(testCase)
[root, draft] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
draft.accepted(:) = true;
recipe = draft.recipe;
recipe.cameraPreparation.thorcam.rotationDegrees = 0;
draft = triofig.updateSetupDraft(draft, recipe, 1, 'back');
verifyEqual(testCase, draft.recipe.cameraPreparation.thorcam.rotationDegrees, 0);
verifyFalse(testCase, any(draft.accepted));
draft = triofig.updateSetupDraft(draft, recipe, 1, 'next');
verifyTrue(testCase, draft.accepted(1));
verifyEqual(testCase, draft.step, 2);
draft.accepted(:) = true;
recipe.registration.savedTransforms.thorcamTranslationXY = [4, 2];
draft = triofig.updateSetupDraft(draft, recipe, 2, 'next');
verifyTrue(testCase, all(draft.accepted(1:2)));
verifyFalse(testCase, any(draft.accepted(3:6)));
draft.accepted(:) = true;
recipe.registration.crop.width = 10;
draft = triofig.updateSetupDraft(draft, recipe, 3, 'next');
verifyFalse(testCase, draft.accepted(5));
verifyTrue(testCase, draft.accepted(3));
draft.accepted(:) = true;
recipe.presentation.upsampleFactor = 2;
draft = triofig.updateSetupDraft(draft, recipe, 4, 'back');
verifyFalse(testCase, draft.accepted(5));
end

function testFreshDraftDoesNotInheritApprovals(testCase)
[root, draft] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
draft.accepted(:) = true;
fresh = triofig.newSetupDraft(draft.recipe, root, draft.selected);
verifyFalse(testCase, any(fresh.accepted));
verifyEqual(testCase, fresh.step, 1);
end

function testDraftRecipeAndInputIdentityMustAgree(testCase)
[root, draft] = fixture();
cleanup = onCleanup(@() rmdir(root, 's')); %#ok<NASGU>
path = fullfile(root, 'setup-draft.json');
draft.recipe.input.thorcamCaptureRelativePath = 'another-camera.tif';
triofig.saveSetupDraft(path, draft);
[loaded, issue] = triofig.loadSetupDraft(path, root);
verifyEmpty(testCase, loaded);
verifyNotEmpty(testCase, issue);
end

function testBrightnessUsesUnclippedBaselineAndExportMapping(testCase)
baseline = struct('thorcam', [0, .25; .75, 1], ...
    'global', [0, .25; .75, 1], 'local', [0, .5; .8, 1], ...
    'validation', [0, .25; .75, 1]);
multipliers = struct('globalLocal', 2, 'thorcam', .5, 'validation', 1);
[prepared, clipping, masks] = triofig.applySetupIntensity(baseline, multipliers);
verifyEqual(testCase, prepared.global, [0, .5; 1, 1]);
verifyEqual(testCase, prepared.local, [0, 1; 1, 1]);
verifyEqual(testCase, prepared.thorcam, [0, .125; .375, .5]);
verifyEqual(testCase, clipping.global, 50);
verifyEqual(testCase, clipping.local, 50);
verifyEqual(testCase, masks.global, logical([0, 0; 1, 1]));
panels = triofig.renderPanels(prepared, 1);
verifyEqual(testCase, panels.global, uint8([0, 128; 255, 255]));
multipliers.globalLocal = .5;
prepared = triofig.applySetupIntensity(baseline, multipliers);
verifyEqual(testCase, prepared.global, [0, .125; .375, .5]);
end

function testRectangleCoordinatesDoNotSilentlyClamp(testCase)
roi = triofig.setupRectangle('zoom', [1, 2, 3, 2], [10, 12], 2);
verifyEqual(testCase, [roi.xZeroBased, roi.yZeroBased, roi.width, roi.height], [0, 1, 3, 2]);
verifyEqual(testCase, roi.color, 'cyan');
crop = triofig.setupRectangle('crop', [.5, 1.5, 3, 2], [10, 12]);
verifyEqual(testCase, [crop.columnStartOneBased, crop.rowStartOneBased, crop.width, crop.height], [1, 2, 3, 2]);
verifyError(testCase, @() triofig.setupRectangle('zoom', [11, 1, 3, 2], [10, 12], 1), 'triofig:InvalidRoi');
verifyError(testCase, @() triofig.setupRectangle('crop', [.5, .5, 0, 2], [10, 12]), 'triofig:InvalidRoi');
end

function testAdjustmentDialogsValidateAndRetainEdits(testCase)
[recipe, data] = dialogFixture();
for step = 1:6
    task = timer('StartDelay', 1, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
        'TimerFcn', @(source, ~) driveDialog(step, source));
    cleanup = onCleanup(@() disposeTimer(task));
    setappdata(groot, 'trioDialogError', []);
    start(task);
    [edited, action] = triofig.setupDialog(step, recipe, data);
    problem = getappdata(groot, 'trioDialogError');
    if ~isempty(problem), rethrow(problem); end
    verifyEqual(testCase, action, 'next');
    if step == 2
        verifyEqual(testCase, edited.registration.savedTransforms.thorcamTranslationXY(1), 1);
    elseif step == 4
        verifyEqual(testCase, edited.presentation.intensityMultipliers.globalLocal, .5);
    elseif step == 5
        verifyEqual(testCase, edited.presentation.zoomRois(2).xZeroBased, 4);
    end
    clear cleanup
end
end

function testControllerResumesPausesAndGenerates(testCase)
[recipe, data] = dialogFixture();
root = tempname;
mkdir(root);
cleanup = onCleanup(@() cleanupController(root)); %#ok<NASGU>
selected = struct('main', fullfile(root, 'main.tif'), 'thorcam', fullfile(root, 'thorcam.tif'), ...
    'validation', fullfile(root, 'validation.tif'), 'workspace', fullfile(root, 'workspace.mat'), ...
    'runManifest', fullfile(root, 'experiment_manifest.json'));
image = uint16(mat2gray(data.globalImage) * 65535);
imwrite(image, selected.main); imwrite(image, selected.thorcam); imwrite(image, selected.validation);
average_rectified_global_image = data.globalImage; %#ok<NASGU>
average_rectified_image = data.localImage; %#ok<NASGU>
config_json = '{}'; %#ok<NASGU>
save(selected.workspace, 'average_rectified_global_image', 'average_rectified_image', 'config_json');
writeText(selected.runManifest, '{"generation_id":"setup-test-run","scene":"test"}');
recipe.input.mainCaptureRelativePath = 'main.tif';
recipe.input.thorcamCaptureRelativePath = 'thorcam.tif';
recipe.input.validationCaptureRelativePath = 'validation.tif';
recipe.input.workspaceRelativePath = 'workspace.mat';
recipe.input.runManifestRelativePath = 'experiment_manifest.json';
recipe.input.expectedGenerationId = 'setup-test-run';
draft = triofig.newSetupDraft(recipe, root, selected);
draft.accepted(1:2) = true;
draft.step = 3;
output = fullfile(root, 'figure');
path = fullfile(output, 'setup-draft.json');
triofig.saveSetupDraft(path, draft);
for mode = {'pause', 'generate', 'compiler-failure'}
    setappdata(groot, 'trioControllerError', []);
    task = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
        'UserData', false, 'TimerFcn', @(source, ~) driveController(source, mode{1}));
    timerCleanup = onCleanup(@() disposeTimer(task));
    start(task);
    compiler = 'pdflatex';
    if strcmp(mode{1}, 'compiler-failure'), compiler = 'missing-setup-compiler'; end
    result = setup_trio_figure(root, 'SceneId', 'test', 'FigureId', 'test', ...
        'OutputDirectory', output, 'CompilerExecutable', compiler);
    problem = getappdata(groot, 'trioControllerError');
    if ~isempty(problem), rethrow(problem); end
    verifyEqual(testCase, result.draftPath, path);
    if strcmp(mode{1}, 'pause')
        verifyTrue(testCase, result.cancelled);
        saved = triofig.loadSetupDraft(path, root);
        verifyEqual(testCase, saved.step, 4);
        verifyEqual(testCase, saved.recipe.presentation.intensityMultipliers.globalLocal, .7);
        verifyFalse(testCase, isfile(fullfile(output, 'figure-index.json')));
    elseif strcmp(mode{1}, 'generate')
        verifyFalse(testCase, result.cancelled);
        verifyEqual(testCase, result.status, 'complete');
        verifyTrue(testCase, isfile(result.previewPath));
        successfulId = result.generationId;
        previewData = data;
        previewData.thorcam = image; previewData.validation = image;
        saved = triofig.loadSetupDraft(path, root);
        baseline = triofig.setupPreview(previewData, saved.recipe, true);
        prepared = triofig.applySetupIntensity(baseline, saved.recipe.presentation.intensityMultipliers);
        panels = triofig.renderPanels(prepared, saved.recipe.presentation.upsampleFactor);
        verifyEqual(testCase, imread(fullfile(result.generationDirectory, 'assets', 'global_average.png')), panels.global);
    else
        verifyEqual(testCase, result.status, 'incomplete');
        index = triofig.readFigureIndex(output);
        verifyEqual(testCase, index.latest, successfulId);
        verifyTrue(testCase, isfile(path));
    end
    delete(findall(groot, 'Tag', 'trio-setup-result'));
    clear timerCleanup
end
end

function testUnsavedCheckpointStillOffersSaveOnWindowClose(testCase)
[recipe, data] = dialogFixture();
setappdata(groot, 'trioDialogError', []);
closeTask = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
    'TimerFcn', @(source, ~) closePendingDialog(source));
answerTask = timer('StartDelay', .7, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
    'TimerFcn', @(source, ~) answerPendingClose(source));
cleanup = onCleanup(@() disposeTwoTimers(closeTask, answerTask)); %#ok<NASGU>
start(closeTask); start(answerTask);
[saved, action] = triofig.setupDialog(4, recipe, data, true);
problem = getappdata(groot, 'trioDialogError');
if ~isempty(problem), rethrow(problem); end
verifyEqual(testCase, action, 'save');
verifyEqual(testCase, saved.presentation.intensityMultipliers.globalLocal, 1);
end

function testCalibrationRetainsAcceptedPointPairs(testCase)
[~, data] = dialogFixture();
points = struct('referenceXY', [2, 2; 4, 4], 'movingXY', [2, 2; 6, 6]);
for choice = {'Use calibration', 'Cancel'}
    task = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
        'TimerFcn', @(source, ~) driveCalibration(source, choice{1}));
    cleanup = onCleanup(@() disposeTimer(task));
    start(task);
    [saved, factor, accepted] = triofig.setupCalibrationDialog(data.globalImage, data.thorcam, points, 'Test');
    verifyEqual(testCase, saved, points);
    verifyEqual(testCase, accepted, strcmp(choice{1}, 'Use calibration'));
    if accepted, verifyEqual(testCase, factor, .5, 'AbsTol', 1e-12); end
    clear cleanup
end
end

function driveCalibration(task, choice)
fig = findall(groot, 'Type', 'figure', 'Name', 'Test · point-pair calibration');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
stop(task);
button = findobj(fig, 'String', choice);
callback = get(button, 'Callback');
callback(button, []);
end

function closePendingDialog(task)
fig = findall(groot, 'Tag', 'trio-setup');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
stop(task);
fig.CloseRequestFcn(fig, []);
end

function answerPendingClose(task)
fig = findall(groot, 'Tag', 'setup-choice', 'Name', 'Pause figure setup');
if ~isscalar(fig), return; end
button = findobj(fig, 'Tag', 'setup-choice-1');
if ~isscalar(button), return; end
stop(task);
button.ButtonPushedFcn(button, []);
end

function disposeTwoTimers(first, second)
disposeTimer(first);
disposeTimer(second);
end

function driveController(task, mode)
try
    prompt = findall(groot, 'Tag', 'setup-choice', 'Name', 'Resume trio figure');
    if isscalar(prompt) && strcmp(get(prompt, 'WaitStatus'), 'waiting')
        button = findobj(prompt, 'Tag', 'setup-choice-1');
        button.ButtonPushedFcn(button, []);
        return;
    end
    fig = findall(groot, 'Tag', 'trio-setup');
    if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
    if contains(fig.Name, '4/6:') && strcmp(mode, 'pause')
        field = findobj(fig, 'Tag', 'globalLocal-multiplier');
        field.Value = .7; field.ValueChangedFcn(field, []);
        button = findobj(fig, 'Tag', 'setup-save');
    elseif contains(fig.Name, '4/6:') && strcmp(mode, 'generate') && ~task.UserData
        task.UserData = true;
        button = findobj(fig, 'Tag', 'setup-back');
    else
        button = findobj(fig, 'Tag', 'setup-next');
    end
    assert(strcmp(button.Enable, 'on'), 'A valid resumed step must permit navigation.');
    button.ButtonPushedFcn(button, []);
catch cause
    setappdata(groot, 'trioControllerError', cause);
    stop(task);
    fig = findall(groot, 'Tag', 'trio-setup');
    if isscalar(fig), uiresume(fig); end
end
end

function cleanupController(root)
delete(findall(groot, 'Tag', 'trio-setup-result'));
if isfolder(root), rmdir(root, 's'); end
end

function driveDialog(step, task)
fig = findall(groot, 'Tag', 'trio-setup');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting')
    return;
end
stop(task);
try
    assert(isscalar(fig), 'One setup dialog must be open.');
    if step == 2
        field = findobj(fig, 'Tag', 'thorcam-x');
        field.Value = 'NaN';
        field.ValueChangedFcn(field, []);
        next = findobj(fig, 'Tag', 'setup-next');
        assert(strcmp(next.Enable, 'off'), 'Invalid alignment must block Next.');
        field.Value = '1';
        field.ValueChangedFcn(field, []);
    elseif step == 4
        field = findobj(fig, 'Tag', 'globalLocal-multiplier');
        field.Value = .5;
        field.ValueChangedFcn(field, []);
    elseif step == 5
        selector = findobj(fig, 'Tag', 'zoom-selector');
        selector.Value = '2';
        selector.ValueChangedFcn(selector, []);
        field = findobj(fig, 'Tag', 'zoom-x');
        field.Value = '5';
        field.ValueChangedFcn(field, []);
    end
    next = findobj(fig, 'Tag', 'setup-next');
    assert(strcmp(next.Enable, 'on'), 'Valid preview must allow Next.');
    next.ButtonPushedFcn(next, []);
catch cause
    setappdata(groot, 'trioDialogError', cause);
    if isscalar(fig) && isvalid(fig), uiresume(fig); end
end
end

function disposeTimer(task)
stop(task);
delete(task);
end

function [recipe, data] = dialogFixture()
[x, y] = meshgrid(1:50, 1:40);
image = sin(x / 3) + cos(y / 5) + x .* y / 1000;
recipe = triofig.defaultRecipe('test', 'candidate-outputs/figures-source/test');
for role = {'thorcam', 'validation'}
    recipe.cameraPreparation.(role{1}) = struct('rotationDegrees', 0, ...
        'flipVertical', false, 'downsampleFactor', 1);
end
recipe.registration.transformSource = 'saved';
recipe.registration.cropMode = 'saved';
recipe.registration.crop = struct('rowStartOneBased', 2, 'columnStartOneBased', 2, 'height', 35, 'width', 45);
recipe.presentation.upsampleFactor = 1;
recipe.presentation.zoomRois(1) = struct('id', 1, 'xZeroBased', 3, 'yZeroBased', 3, 'width', 8, 'height', 6, 'color', 'orange');
recipe.presentation.zoomRois(2) = struct('id', 2, 'xZeroBased', 5, 'yZeroBased', 12, 'width', 8, 'height', 6, 'color', 'cyan');
data = struct('globalImage', image, 'localImage', image + .1 * sin(x), ...
    'thorcam', image, 'validation', image, ...
    'cache', containers.Map('KeyType', 'char', 'ValueType', 'any'));
end

function [root, draft] = fixture()
root = tempname;
mkdir(root);
names = {'main', 'thorcam', 'validation', 'workspace', 'runManifest'};
selected = struct();
for k = 1:numel(names)
    selected.(names{k}) = fullfile(root, [names{k} '.tif']);
    writeText(selected.(names{k}), names{k});
end
movefile(selected.workspace, fullfile(root, 'workspace.mat'));
selected.workspace = fullfile(root, 'workspace.mat');
recipe = triofig.defaultRecipe('scene', 'candidate-outputs/figures-source/scene');
recipe.input.mainCaptureRelativePath = 'main.tif';
recipe.input.thorcamCaptureRelativePath = 'thorcam.tif';
recipe.input.validationCaptureRelativePath = 'validation.tif';
recipe.input.workspaceRelativePath = 'workspace.mat';
recipe.input.runManifestRelativePath = 'runManifest.tif';
draft = triofig.newSetupDraft(recipe, root, selected);
end

function writeText(path, value)
fid = fopen(path, 'w');
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '%s', value);
end
