function tests = test_trio_display_mapping
%TEST_TRIO_DISPLAY_MAPPING Schema-6 window mapping, per-region zooms, optional processing.
tests = functiontests(localfunctions);
end

function testLegacyUpgradeIsPixelIdentical(testCase)
% A schema-5 recipe and its schema-6 legacyMinMax upgrade produce identical panels.
[recipe, data] = triotest.dialogFixture('legacyMinMax');
recipe.presentation.intensityMultipliers.globalLocal = 1.3;
recipe.presentation.intensityMultipliers.thorcam = 1.4867;
old = recipe;
old.schemaVersion = 5;
old.presentation = rmfield(old.presentation, 'display');
triofig.validateRecipe(old);
upgraded = triofig.upgradeRecipe(old);
verifyEqual(testCase, upgraded.schemaVersion, 6);
verifyEqual(testCase, upgraded.presentation.display.method, 'legacyMinMax');
triofig.validateRecipe(upgraded);
before = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, old);
after = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, upgraded);
for name = {'global', 'local', 'thorcam', 'validation'}
    verifyEqual(testCase, after.(name{1}), before.(name{1}));
end
verifyEqual(testCase, triofig.renderPanels(after, 4), triofig.renderPanels(before, 4));
end

function testUpgradeFromSchemaTwoKeepsManifestBoundary(testCase)
[recipe, ~] = triotest.dialogFixture('legacyMinMax');
legacy = recipe;
legacy.schemaVersion = 2;
legacy.presentation = rmfield(legacy.presentation, {'display', 'intensityMode'});
legacy.reconstruction = rmfield(legacy.reconstruction, {'manifestStatus', 'stageId'});
triofig.validateRecipe(legacy);
upgraded = triofig.upgradeRecipe(legacy);
triofig.validateRecipe(upgraded);
verifyEqual(testCase, upgraded.schemaVersion, 6);
verifyEqual(testCase, upgraded.reconstruction.manifestStatus, 'present');
verifyEqual(testCase, upgraded.input.workspaceMode, 'shared');
end

function testWindowAndGammaMath(testCase)
window = struct('black', .25, 'white', .75);
off = struct('gamma', struct('enabled', false, 'value', 1));
[mapped, lowPercent, highPercent] = triofig.windowImage([0, .25; .75, 1], window, off);
verifyEqual(testCase, mapped, [0, 0; 1, 1]);
verifyEqual(testCase, lowPercent, 25);
verifyEqual(testCase, highPercent, 25);
identity = struct('black', 0, 'white', 1);
on = struct('gamma', struct('enabled', true, 'value', 2));
verifyEqual(testCase, triofig.windowImage([0, .5, 1], identity, on), [0, .25, 1], 'AbsTol', 1e-12);
verifyEqual(testCase, triofig.windowImage([0, .5, 1], identity, off), [0, .5, 1]);
% Enabled gamma of exactly 1 is the identity.
unity = struct('gamma', struct('enabled', true, 'value', 1));
verifyEqual(testCase, triofig.windowImage([0, .5, 1], identity, unity), [0, .5, 1]);
end

function testPercentilesAndPooledWindow(testCase)
verifyEqual(testCase, triofig.percentileValue(1:101, 50), 51);
verifyEqual(testCase, triofig.percentileValue(1:101, 0), 1);
verifyEqual(testCase, triofig.percentileValue(1:101, 100), 101);
verifyEqual(testCase, triofig.percentileValue([NaN, 1, 2, 3], 50), 2);
window = struct('black', 0, 'white', 1, 'auto', true, 'lowPercentile', 0, 'highPercentile', 100);
pooled = triofig.resolveWindow({1:100, 101:200}, window);
verifyEqual(testCase, [pooled.black, pooled.white], [1, 200]);
verifyTrue(testCase, pooled.auto);
flat = struct('black', 0, 'white', 1, 'auto', true, 'lowPercentile', 10, 'highPercentile', 90);
verifyError(testCase, @() triofig.resolveWindow({ones(5)}, flat), 'triofig:FlatImage');
end

function testLinkedWindowIsSharedAndSeparateWindowsDiffer(testCase)
[recipe, data] = triotest.dialogFixture();
recipe.presentation.display.roles.flfm.black = -1; recipe.presentation.display.roles.flfm.white = 2;
recipe.presentation.display.roles.thorcam.black = -2; recipe.presentation.display.roles.thorcam.white = 3;
baseline = triofig.setupPreview(data, recipe, true);
[mapped, info] = triofig.applyDisplay(baseline.crops, recipe.presentation);
verifyEqual(testCase, info.windows.global, info.windows.local);
verifyEqual(testCase, mapped.global, min(max((baseline.crops.global + 1) / 3, 0), 1));
verifyEqual(testCase, mapped.local, min(max((baseline.crops.local + 1) / 3, 0), 1));
verifyEqual(testCase, mapped.thorcam, min(max((baseline.crops.thorcam + 2) / 5, 0), 1));

separate = triofig.setIntensityMode(recipe, 'separate');
verifyEqual(testCase, separate.presentation.display.roles.global, recipe.presentation.display.roles.flfm);
separate.presentation.display.roles.local.black = 0;
separate.presentation.display.roles.local.white = 1;
triofig.validateRecipe(separate);
[~, separateInfo] = triofig.applyDisplay(baseline.crops, separate.presentation);
verifyNotEqual(testCase, separateInfo.windows.global, separateInfo.windows.local);
relinked = triofig.setIntensityMode(separate, 'linked');
verifyEqual(testCase, relinked.presentation.display.roles.flfm, separate.presentation.display.roles.global);
end

function testOptionalProcessingIsOffByDefaultAndSharedByFlfmImages(testCase)
[recipe, data] = triotest.dialogFixture();
for group = {'flfm', 'thorcam'}
    processing = recipe.presentation.display.processing.(group{1});
    verifyFalse(testCase, processing.background.enabled);
    verifyFalse(testCase, processing.smoothing.enabled);
    verifyFalse(testCase, processing.gamma.enabled);
end
verifyFalse(testCase, triofig.hasSeparateZoom(recipe.presentation.display));
verifyFalse(testCase, isfield(recipe.presentation.display.zoom, 'mode'));
baseline = triofig.setupPreview(data, recipe, true);
[~, plain] = triofig.applyDisplay(baseline.crops, recipe.presentation);
verifyEqual(testCase, plain.source.global, baseline.crops.global);
verifyEqual(testCase, plain.source.thorcam, baseline.crops.thorcam);

recipe.presentation.display.processing.flfm.smoothing = struct('enabled', true, 'sigmaPixels', 2);
[~, smoothed] = triofig.applyDisplay(baseline.crops, recipe.presentation);
verifyEqual(testCase, smoothed.source.global, ...
    imgaussfilt(baseline.crops.global, 2, 'Padding', 'symmetric'));
verifyEqual(testCase, smoothed.source.local, ...
    imgaussfilt(baseline.crops.local, 2, 'Padding', 'symmetric'));
verifyEqual(testCase, smoothed.source.thorcam, baseline.crops.thorcam);

recipe.presentation.display.processing.flfm.background = ...
    struct('enabled', true, 'method', 'gaussian', 'sigmaPixels', 5);
[~, both] = triofig.applyDisplay(baseline.crops, recipe.presentation);
subtracted = baseline.crops.global - imgaussfilt(baseline.crops.global, 5, 'Padding', 'symmetric');
verifyEqual(testCase, both.source.global, imgaussfilt(subtracted, 2, 'Padding', 'symmetric'));
end

function testRecipeValidationRejections(testCase)
[recipe, ~] = triotest.dialogFixture();
triofig.validateRecipe(recipe);

old = recipe; old.schemaVersion = 5;
verifyError(testCase, @() triofig.validateRecipe(old), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.roles.flfm.white = bad.presentation.display.roles.flfm.black;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.roles.thorcam.lowPercentile = 99.9;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.processing.flfm.gamma.value = 9;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.processing.thorcam.smoothing.sigmaPixels = 0;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.zoom.regions(2).id = 7;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.zoom.regions(1).thorcam.view = 'sideways';
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.method = 'legacyMinMax';
bad.presentation.display.zoom.regions(2).flfm.view = 'both';
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.display.method = 'other';
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

bad = recipe; bad.presentation.intensityMultipliers.thorcam = 1.2;
verifyError(testCase, @() triofig.validateRecipe(bad), 'triofig:InvalidRecipe');

legacy = recipe; legacy.presentation.display.method = 'legacyMinMax';
legacy.presentation.intensityMultipliers.thorcam = 1.2;
triofig.validateRecipe(legacy);
end

function testPreparePanelsMatchesSetupPresentation(testCase)
[recipe, data] = triotest.dialogFixture();
recipe.presentation.display.roles.flfm.black = -1; recipe.presentation.display.roles.flfm.white = 2;
recipe.presentation.display.roles.thorcam.black = -1; recipe.presentation.display.roles.thorcam.white = 2;
recipe.presentation.display.processing.flfm.gamma = struct('enabled', true, 'value', .7);
export = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, recipe);
baseline = triofig.setupPreview(data, recipe, true);
preview = triofig.presentPrepared(baseline, recipe);
for name = {'global', 'local', 'thorcam'}
    verifyEqual(testCase, preview.(name{1}), export.(name{1}));
end
verifyEqual(testCase, export.display.method, 'window');
verifyFalse(testCase, isfield(export.display, 'source'));
verifyTrue(testCase, isfield(export, 'source'));
% Baseline stays the legacy normalization with raw crops for re-windowing.
verifyTrue(testCase, isfield(baseline, 'crops'));
verifyFalse(testCase, isfield(baseline, 'display'));
end

function testZoomViewsInheritSeparateAndBothKeepFlfmPairFair(testCase)
[recipe, data] = triotest.dialogFixture();
recipe.presentation.display.roles.flfm.black = -1; recipe.presentation.display.roles.flfm.white = 2;
recipe.presentation.display.roles.thorcam.black = -1; recipe.presentation.display.roles.thorcam.white = 2;
baseline = triofig.setupPreview(data, recipe, true);
inherit = triofig.presentPrepared(baseline, recipe);
[panels, inheritZooms] = triofig.presentZooms(inherit, recipe.presentation, recipe.schemaVersion);
verifyEqual(testCase, inheritZooms, triofig.extractZooms(panels, recipe.presentation.zoomRois));

% Region 1: ThorCam separate (replaces the inset), FLFM both (stacked lower copy).
% Region 2: ThorCam both on the main-panel window values, FLFM inherit.
region = recipe.presentation.display.zoom.regions(1);
region.thorcam.black = 0.5; region.thorcam.white = 1.0; region.thorcam.auto = false;
region.thorcam.view = 'separate';
region.flfm.black = 0; region.flfm.white = 0.8; region.flfm.auto = false;
region.flfm.view = 'both';
recipe.presentation.display.zoom.regions(1) = region;
other = recipe.presentation.display.zoom.regions(2);
other.thorcam = struct('black', -1, 'white', 2, 'auto', false, 'lowPercentile', .5, ...
    'highPercentile', 99.8, 'view', 'both');
other.flfm = other.thorcam;
other.flfm.view = 'inherit';
recipe.presentation.display.zoom.regions(2) = other;
triofig.validateRecipe(recipe);
prepared = triofig.presentPrepared(baseline, recipe);
[~, zooms, extras] = triofig.presentZooms(prepared, recipe.presentation, recipe.schemaVersion);
roi = recipe.presentation.zoomRois(1);
rows = roi.yZeroBased + (1:roi.height); columns = roi.xZeroBased + (1:roi.width);
none = struct('gamma', struct('enabled', false, 'value', 1));
expectThorcam = uint8(round(triofig.windowImage(prepared.source.thorcam(rows, columns), ...
    struct('black', .5, 'white', 1), none) * 255));
expectGlobal = uint8(round(triofig.windowImage(prepared.source.global(rows, columns), ...
    struct('black', 0, 'white', .8), none) * 255));
expectLocal = uint8(round(triofig.windowImage(prepared.source.local(rows, columns), ...
    struct('black', 0, 'white', .8), none) * 255));
% separate: the primary inset itself is rescaled.
verifyEqual(testCase, zooms.thorcam_zoom_1, expectThorcam);
verifyNotEqual(testCase, zooms.thorcam_zoom_1, inheritZooms.thorcam_zoom_1);
% both: the primary inset stays inherited and the lower copy uses the shared FLFM window.
verifyEqual(testCase, zooms.global_zoom_1, inheritZooms.global_zoom_1);
verifyEqual(testCase, zooms.local_zoom_1, inheritZooms.local_zoom_1);
verifyEqual(testCase, extras.global_zoom_1_emphasis, expectGlobal);
verifyEqual(testCase, extras.local_zoom_1_emphasis, expectLocal);
% inherit and both-on-the-main-window cells keep inherited primaries.
verifyEqual(testCase, zooms.global_zoom_2, inheritZooms.global_zoom_2);
verifyEqual(testCase, zooms.thorcam_zoom_2, inheritZooms.thorcam_zoom_2);
verifyEqual(testCase, sort(fieldnames(extras)), ...
    {'global_zoom_1_emphasis'; 'local_zoom_1_emphasis'; 'thorcam_zoom_2_emphasis'});

% Region windows resolve from each ROI's own pixels, pooling global-stage and final.
auto = recipe.presentation.display.zoom.regions;
auto(1).flfm.auto = true; auto(1).thorcam.auto = true;
auto(1).flfm.lowPercentile = 0; auto(1).flfm.highPercentile = 100;
upsampled = triofig.upsampleSources(prepared, 1);
resolved = triofig.resolveRegionWindows(auto, recipe.presentation.zoomRois, upsampled);
pool = [prepared.source.global(rows, columns), prepared.source.local(rows, columns)];
verifyEqual(testCase, [resolved(1).flfm.black, resolved(1).flfm.white], [min(pool(:)), max(pool(:))]);
verifyEqual(testCase, resolved(2).flfm.black, auto(2).flfm.black);
end

function testDisplayCaptionDisclosesWindowsAndOperations(testCase)
[recipe, data] = triotest.dialogFixture();
recipe.presentation.display.roles.flfm.black = 0.1; recipe.presentation.display.roles.flfm.white = 1.9;
baseline = triofig.setupPreview(data, recipe, true);
[~, info] = triofig.applyDisplay(baseline.crops, recipe.presentation);
caption = triofig.displayCaption(rmfield(info, 'source'));
verifySubstring(testCase, caption, '0.1 to 1.9');
verifySubstring(testCase, caption, 'No smoothing, background subtraction, or gamma');
recipe.presentation.display.processing.thorcam.gamma = struct('enabled', true, 'value', .7);
recipe.presentation.display.zoom.regions(1).thorcam.view = 'both';
recipe.presentation.display.zoom.regions(2).flfm.view = 'separate';
[~, info] = triofig.applyDisplay(baseline.crops, recipe.presentation);
caption = triofig.displayCaption(rmfield(info, 'source'));
verifySubstring(testCase, caption, 'ThorCam gamma 0.7');
verifySubstring(testCase, caption, 'Zoom insets: region 1 ThorCam inset shown twice');
verifySubstring(testCase, caption, 'region 2 global-stage and final insets scaled to');
verifySubstring(testCase, caption, 'not comparable in brightness');
end

function testLegacyZoomModeIsMigratedToViews(testCase)
% Recipes written before per-cell views carry display.zoom.mode.
[recipe, ~] = triotest.dialogFixture();
old = recipe;
old.presentation.display.zoom.mode = 'perRegion';
for k = 1:2
    old.presentation.display.zoom.regions(k).thorcam = rmfield(old.presentation.display.zoom.regions(k).thorcam, 'view');
    old.presentation.display.zoom.regions(k).flfm = rmfield(old.presentation.display.zoom.regions(k).flfm, 'view');
end
migrated = triofig.normalizeZoom(old);
verifyFalse(testCase, isfield(migrated.presentation.display.zoom, 'mode'));
for k = 1:2
    verifyEqual(testCase, migrated.presentation.display.zoom.regions(k).thorcam.view, 'separate');
    verifyEqual(testCase, migrated.presentation.display.zoom.regions(k).flfm.view, 'separate');
end
triofig.validateRecipe(migrated);
old.presentation.display.zoom.mode = 'inherit';
verifyFalse(testCase, triofig.hasSeparateZoom(triofig.normalizeZoom(old).presentation.display));
% Existing views are kept, and recipes without a display block pass through.
verifyEqual(testCase, triofig.normalizeZoom(recipe), recipe);
plain = rmfield(recipe.presentation, 'display');
verifyEqual(testCase, triofig.normalizeZoom(struct('presentation', plain)), struct('presentation', plain));
end

function testReplayWritesStackedZoomInsetsAndMarkersPerCell(testCase)
[recipe, data] = triotest.dialogFixture();
parent = tempname; mkdir(parent);
cleanup = onCleanup(@() rmdir(parent, 's')); %#ok<NASGU>
% Replay reads uint16 captures, so the ThorCam window is in 16-bit counts.
recipe.presentation.display.roles.flfm.black = -2; recipe.presentation.display.roles.flfm.white = 3;
recipe.presentation.display.roles.thorcam.black = 0; recipe.presentation.display.roles.thorcam.white = 65535;
% Region 1: ThorCam both, FLFM separate. Region 2: ThorCam separate, FLFM both.
views = {'both', 'separate'; 'separate', 'both'};
for k = 1:2
    region = recipe.presentation.display.zoom.regions(k);
    region.flfm.black = -1; region.flfm.white = 2; region.flfm.auto = false;
    region.thorcam.black = 0; region.thorcam.white = 40000; region.thorcam.auto = false;
    region.thorcam.view = views{k, 1};
    region.flfm.view = views{k, 2};
    recipe.presentation.display.zoom.regions(k) = region;
end
[recipePath, root] = triotest.rawFixture(parent, recipe, data);
result = replay_trio_figure(recipePath, root, 'OutputDirectory', fullfile(parent, 'window'), 'Publish', false);
verifyEqual(testCase, result.status, 'complete');
manifest = jsondecode(fileread(result.manifestPath));
verifyEqual(testCase, manifest.schemaVersion, 6);
verifyEqual(testCase, manifest.display.method, 'window');
verifyEqual(testCase, manifest.display.windows.global.black, -2);
verifyEqual(testCase, manifest.display.zoom.regions(1).thorcam.view, 'both');
verifyEqual(testCase, manifest.display.zoom.regions(2).flfm.view, 'both');
verifyTrue(testCase, contains(manifest.display.caption, 'Zoom insets: region 1 ThorCam inset shown twice'));
captionPath = fullfile(result.generationDirectory, 'latex', 'display-caption.txt');
verifyEqual(testCase, strtrim(fileread(captionPath)), manifest.display.caption);
extraNames = {'global_zoom_2_emphasis.png', 'local_zoom_2_emphasis.png', 'thorcam_zoom_1_emphasis.png'};
for k = 1:numel(extraNames)
    verifyTrue(testCase, isfile(fullfile(result.generationDirectory, 'assets', extraNames{k})));
end
verifyEqual(testCase, numel(result.outputs), 12);
verifyTrue(testCase, all(ismember(extraNames, {result.outputs.filename})));
layout = fileread(fullfile(result.generationDirectory, 'latex', 'trio-layout.tex'));
verifySubstring(testCase, layout, '\def\TrioSecondZoomList{global2,local2,thorcam1}');
verifySubstring(testCase, layout, '\def\TrioZoomMarkerList{global1,local1,thorcam2}');

% A preview derived from the generation carries the stacked insets along.
preview = preview_trio_figure(result.generationDirectory, 'Publish', false);
for k = 1:numel(extraNames)
    verifyTrue(testCase, isfile(fullfile(preview.generationDirectory, 'assets', extraNames{k})));
end

% rawFixture rewrote the input paths in its own copy; continue from the saved recipe.
recipe = triofig.readRecipe(recipePath);
for k = 1:2
    recipe.presentation.display.zoom.regions(k).thorcam.view = 'inherit';
    recipe.presentation.display.zoom.regions(k).flfm.view = 'inherit';
end
triofig.writeRecipe(recipePath, recipe);
plain = replay_trio_figure(recipePath, root, 'OutputDirectory', fullfile(parent, 'inherit'), 'Publish', false);
verifyEqual(testCase, plain.status, 'complete');
verifyEqual(testCase, numel(plain.outputs), 9);
layout = fileread(fullfile(plain.generationDirectory, 'latex', 'trio-layout.tex'));
verifyFalse(testCase, contains(layout, 'TrioZoomMarkerList'));
verifyFalse(testCase, contains(layout, 'TrioSecondZoomList'));

legacy = recipe;
legacy.presentation.display.method = 'legacyMinMax';
triofig.writeRecipe(recipePath, legacy);
old = replay_trio_figure(recipePath, root, 'OutputDirectory', fullfile(parent, 'legacy'), 'Publish', false);
verifyEqual(testCase, old.status, 'complete');
oldManifest = jsondecode(fileread(old.manifestPath));
verifyEqual(testCase, oldManifest.display.method, 'legacyMinMax');
verifyFalse(testCase, isfile(fullfile(old.generationDirectory, 'latex', 'display-caption.txt')));
end

function testStartFromSeedsSchemaSixWithFrozenGeometry(testCase)
[recipe, data] = triotest.dialogFixture('legacyMinMax');
parent = tempname; mkdir(parent);
cleanup = onCleanup(@() rmdir(parent, 's')); %#ok<NASGU>
% A schema-2 source with automatic registration and an exact-match gate.
source = recipe;
source.schemaVersion = 2;
source.presentation = rmfield(source.presentation, {'display', 'intensityMode'});
source.reconstruction = rmfield(source.reconstruction, {'manifestStatus', 'stageId'});
source.registration.transformSource = 'automatic';
source.registration.cropMode = 'intersection';
source.comparison.requireExactCandidateMatchBeforePublish = true;
[sourcePath, root] = triotest.rawFixture(parent, recipe, data);
figureRoot = fullfile(parent, 'figure');
mkdir(figureRoot);
triofig.writeRecipe(fullfile(figureRoot, 'trio-recipe.json'), source);

[seed, foundRoot] = triofig.startFromSetup(figureRoot);
verifyEqual(testCase, foundRoot, figureRoot);
verifyEqual(testCase, seed.schemaVersion, 6);
verifyEqual(testCase, seed.presentation.display.method, 'legacyMinMax');
verifyFalse(testCase, logical(seed.comparison.requireExactCandidateMatchBeforePublish));
% The source recipe on disk is untouched.
verifyEqual(testCase, triofig.readRecipe(fullfile(figureRoot, 'trio-recipe.json')).schemaVersion, 2);

seed.input = recipeInput(sourcePath);
selected = triofig.startFromInputs(seed, root);
verifyTrue(testCase, isfile(selected.main));
verifyTrue(testCase, isfile(selected.workspace));
verifyEqual(testCase, selected.localWorkspace, selected.workspace);

before = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, seed);
frozen = triofig.freezeGeometry(seed, data);
verifyEqual(testCase, frozen.registration.transformSource, 'saved');
verifyEqual(testCase, frozen.registration.cropMode, 'saved');
after = triofig.preparePanels(data.globalImage, data.localImage, data.thorcam, data.validation, frozen);
for name = {'global', 'local', 'thorcam'}
    verifyEqual(testCase, after.(name{1}), before.(name{1}));
end
verifyEqual(testCase, after.crop, before.crop);

emptyFolder = fullfile(parent, 'recipeless'); mkdir(emptyFolder);
verifyError(testCase, @() triofig.startFromSetup(emptyFolder), 'triofig:StartFromUnavailable');
end

function testSetupDraftInvalidatesStepsWhenDisplayChanges(testCase)
[recipe, ~] = triotest.dialogFixture();
draft = struct('recipe', recipe, 'accepted', true(1, 6), 'step', 4);
changed = recipe;
changed.presentation.display.processing.flfm.smoothing = struct('enabled', true, 'sigmaPixels', 1);
updated = triofig.updateSetupDraft(draft, changed, 4, 'save');
verifyFalse(testCase, updated.accepted(4));
verifyFalse(testCase, updated.accepted(6));
verifyTrue(testCase, updated.accepted(5), 'Inherited zooms do not depend on the main display.');

stacked = recipe;
stacked.presentation.display.zoom.regions(1).thorcam.view = 'both';
smoothed = stacked;
smoothed.presentation.display.processing.flfm.smoothing = struct('enabled', true, 'sigmaPixels', 1);
draft.recipe = stacked;
updated = triofig.updateSetupDraft(draft, smoothed, 4, 'save');
verifyFalse(testCase, updated.accepted(5), 'Separately scaled zoom windows depend on the processed image.');

zoomOnly = recipe;
zoomOnly.presentation.display.zoom.regions(2).flfm.view = 'separate';
draft.recipe = recipe;
updated = triofig.updateSetupDraft(draft, zoomOnly, 5, 'save');
verifyTrue(testCase, updated.accepted(4));
verifyFalse(testCase, updated.accepted(6));
end

function testDisplayDialogResolvesAutoWindowsAndZoomDialogResolvesRegions(testCase)
[recipe, data] = triotest.dialogFixture();
for step = [4, 5]
    setappdata(groot, 'trioDialogError', []);
    task = timer('StartDelay', .5, 'ExecutionMode', 'fixedSpacing', 'Period', .5, ...
        'TimerFcn', @(source, ~) driveDisplay(source, step));
    cleanup = onCleanup(@() disposeTimer(task)); %#ok<NASGU>
    start(task);
    [edited, action] = triofig.setupDialog(step, recipe, data);
    problem = getappdata(groot, 'trioDialogError');
    if ~isempty(problem), rethrow(problem); end
    verifyEqual(testCase, action, 'next');
    display = edited.presentation.display;
    if step == 4
        verifyTrue(testCase, display.roles.flfm.white > display.roles.flfm.black);
        verifyNotEqual(testCase, [display.roles.flfm.black, display.roles.flfm.white], [0, 1], ...
            'Auto must replace the 0-1 placeholder with percentile values.');
        verifyTrue(testCase, display.processing.thorcam.gamma.enabled);
        verifyEqual(testCase, display.processing.thorcam.gamma.value, .7);
        verifyFalse(testCase, display.processing.flfm.gamma.enabled);
    else
        verifyEqual(testCase, display.zoom.regions(1).thorcam.view, 'both');
        verifyEqual(testCase, display.zoom.regions(1).flfm.view, 'separate');
        verifyEqual(testCase, display.zoom.regions(2).thorcam.view, 'inherit');
        for k = 1:2
            verifyTrue(testCase, display.zoom.regions(k).flfm.white > display.zoom.regions(k).flfm.black);
        end
        verifyNotEqual(testCase, [display.zoom.regions(1).thorcam.black, display.zoom.regions(1).thorcam.white], [0, 1], ...
            'Auto must replace the 0-1 placeholder with percentile values.');
    end
    clear cleanup
end
end

function driveDisplay(task, step)
fig = findall(groot, 'Tag', 'trio-setup');
if ~isscalar(fig) || ~strcmp(get(fig, 'WaitStatus'), 'waiting'), return; end
stop(task);
try
    if step == 4
        button = findobj(fig, 'Tag', 'flfm-auto');
        button.ButtonPushedFcn(button, []);
        box = findobj(fig, 'Tag', 'thorcam-gamma');
        box.Value = true; box.ValueChangedFcn(box, []);
        value = findobj(fig, 'Tag', 'thorcam-gamma-value');
        value.Value = .7; value.ValueChangedFcn(value, []);
    else
        thorcamView = findobj(fig, 'Tag', 'zoom-thorcam-view');
        thorcamView.Value = 'both'; thorcamView.ValueChangedFcn(thorcamView, []);
        flfmView = findobj(fig, 'Tag', 'zoom-flfm-view');
        flfmView.Value = 'separate'; flfmView.ValueChangedFcn(flfmView, []);
        % The stacked lower copy is previewed in a third row of nine images.
        assert(numel(findall(fig, 'Type', 'image')) == 9, 'Window zoom step must show three rows.');
        button = findobj(fig, 'Tag', 'zoom-auto');
        button.ButtonPushedFcn(button, []);
    end
    next = findobj(fig, 'Tag', 'setup-next');
    assert(strcmp(next.Enable, 'on'), 'Next must stay enabled after valid display edits.');
    next.ButtonPushedFcn(next, []);
catch cause
    setappdata(groot, 'trioDialogError', cause);
    uiresume(fig);
end
end

function disposeTimer(task)
stop(task);
delete(task);
end

function input = recipeInput(recipePath)
input = triofig.readRecipe(recipePath).input;
end
