function tests = test_editor_ui
tests = functiontests(localfunctions);
end
function testEditingAndGestureHistory(testCase)
root = tempname; mkdir(root); cleanup = onCleanup(@() rmdir(root,'s'));
imwrite(uint16(reshape(0:99,10,10)),fullfile(root,'capture.tif'));
app = captureedit.Editor(root,'Visible','off'); closeApp = onCleanup(@() delete(app.Figure));
app.loadPaths(struct('thorcam',fullfile(root,'capture.tif')));
app.addFilter('brightness');
verifyEqual(testCase,numel(app.State.stacks.thorcam),1);
before = app.State;
app.setParameter('gain',2,'changing');
verifyTrue(testCase,contains(app.Status.Text,'Approximate'));
app.setParameter('gain',3,'changed');
verifyEqual(testCase,app.State.stacks.thorcam.params.gain,3);
app.undo(); verifyEqual(testCase,app.State,before);
app.redo(); verifyEqual(testCase,app.State.stacks.thorcam.params.gain,3);
app.toggleFilter(false);
verifyFalse(testCase,app.State.stacks.thorcam.enabled);
app.addFilter('gamma'); app.moveFilter(-1);
verifyEqual(testCase,app.State.stacks.thorcam(1).type,'gamma');
app.removeFilter(); verifyEqual(testCase,numel(app.State.stacks.thorcam),1);
verifyTrue(testCase,contains(app.Status.Text,'Exact'));
end
function testAlignedPairSessionAndProxy(testCase)
root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
paths=struct();
for role={'thorcam','validation','global','local'}
 name=role{1}; side=20;
 if ismember(name,{'global','local'}), side=10; end
 path=fullfile(root,[name '.tif']); imwrite(uint16(reshape(1:side^2,side,side)),path); paths.(name)=path;
end
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure)); app.loadPaths(paths);
verifyNotEmpty(testCase,app.State.geometry);
view=findobj(app.Figure,'Tag','capture-view'); view.Value='Trio'; app.render(false);
verifyTrue(testCase,contains(app.Status.Text,'aligned common field'));
app.addFilter('brightness'); frozen=app.State.geometry;
app.setParameter('gain',1.4,'changing'); verifyTrue(testCase,contains(app.Status.Text,'Approximate'));
app.setParameter('gain',1.5,'changed'); verifyEqual(testCase,app.State.geometry,frozen);
view.Value='Pair'; left=findobj(app.Figure,'Tag','capture-pair-left'); right=findobj(app.Figure,'Tag','capture-pair-right');
left.Value='thorcam original'; right.Value='thorcam edited'; app.render(false);
verifyTrue(testCase,contains(app.Status.Text,'Exact'));
session=fullfile(root,'session.json'); app.saveSession(session);
other=captureedit.Editor(root,'Visible','off'); closeOther=onCleanup(@() delete(other.Figure)); other.openSession(session);
verifyEqual(testCase,other.State.stacks.thorcam.params.gain,1.5);
verifyTrue(testCase,contains(other.Status.Text,'Exact'));
end
function testImportSeparateWorkspaceRecipeLoadsEachAverage(testCase)
repo=fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
addpath(fullfile(repo,'scripts','figure-preparation'));
root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
imwrite(uint8(ones(12)),fullfile(root,'main.tif'));
imwrite(uint8(ones(12)),fullfile(root,'thorcam.tif'));
imwrite(uint8(ones(12)),fullfile(root,'validation.tif'));
average_rectified_global_image=ones(12)*2; config_json='{}'; %#ok<NASGU>
save(fullfile(root,'global.mat'),'average_rectified_global_image','config_json');
average_rectified_image=ones(12)*7; %#ok<NASGU>
save(fullfile(root,'local.mat'),'average_rectified_image','config_json');
writeManifest(fullfile(root,'global_manifest.json'),'global-run');
writeManifest(fullfile(root,'local_manifest.json'),'local-run');
recipe=triofig.defaultRecipe('scene','candidate-outputs/figures-source/scene');
recipe.input.mainCaptureRelativePath='main.tif';
recipe.input.thorcamCaptureRelativePath='thorcam.tif';
recipe.input.validationCaptureRelativePath='validation.tif';
recipe.input.workspaceMode='separate'; recipe.input.workspaceRelativePath='global.mat';
recipe.input.workspaceSha256=triofig.fileSha256(fullfile(root,'global.mat'));
recipe.input.localWorkspaceRelativePath='local.mat';
recipe.input.localWorkspaceSha256=triofig.fileSha256(fullfile(root,'local.mat'));
recipe.input.runManifestRelativePath='global_manifest.json';
recipe.input.expectedGenerationId='global-run';
recipe.input.localRunManifestRelativePath='local_manifest.json';
recipe.input.expectedLocalGenerationId='local-run';
recipe.reconstruction.localWorkspace=struct('manifestStatus','present','stageId','local', ...
    'availableRunRelativePath','.','manifestRecordedRunRelativePath','.');
recipe.reconstruction.availableRunRelativePath='.';
recipe.reconstruction.manifestRecordedRunRelativePath='.';
recipe.cameraPreparation.thorcam.rotationDegrees=0;
recipe.cameraPreparation.thorcam.flipVertical=false;
recipe.cameraPreparation.validation.rotationDegrees=0;
recipe.registration.transformSource='saved'; recipe.registration.cropMode='saved';
recipe.registration.crop=struct('rowStartOneBased',1,'columnStartOneBased',1,'height',12,'width',12);
recipePath=fullfile(root,'recipe.json'); triofig.writeRecipe(recipePath,recipe);
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure));
app.importRecipe(recipePath);
verifyEqual(testCase,app.Sources.global.image,ones(12)*2);
verifyEqual(testCase,app.Sources.local.image,ones(12)*7);
verifyEqual(testCase,app.Sources.global.relativePath,'global.mat');
verifyEqual(testCase,app.Sources.local.relativePath,'local.mat');
end
function writeManifest(path,generation)
file=fopen(path,'w'); cleanup=onCleanup(@() fclose(file)); %#ok<NASGU>
fprintf(file,'%s',jsonencode(struct('generation_id',generation,'scene','scene')));
end
