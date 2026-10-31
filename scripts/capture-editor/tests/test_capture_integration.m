function tests=test_capture_integration
tests=functiontests(localfunctions);
end
function testDense4GeometryMatchesExistingTrio(testCase)
repo=fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
addpath(fullfile(repo,'scripts','figure-preparation'));
root=fullfile(getenv('USERPROFILE'),'OneDrive - Technion','office computer files','images_output','3_6_26');
testCase.assumeTrue(isfolder(root),'Dense4 source dataset unavailable.');
recipe=triofig.readRecipe(fullfile(repo,'candidate-outputs','figures-source','eyedrop_3_6','trio-recipe.json'));
paths=struct('thorcam',recipe.input.thorcamCaptureRelativePath,'validation',recipe.input.validationCaptureRelativePath, ...
 'global',recipe.input.workspaceRelativePath,'local',recipe.input.workspaceRelativePath);
sources=captureedit.loadSources(root,paths);
geometry=captureedit.resolveGeometry(sources,recipe,false);
images=struct(); for role={'thorcam','validation','global','local'}, images.(role{1})=sources.(role{1}).image; end
panels=captureedit.comparisonPanels(images,geometry);
prepared=triofig.preparePanels(images.global,images.local,images.thorcam,images.validation,recipe);
c=geometry.registration.crop; rows=c.rowStartOneBased+(0:c.height-1); cols=c.columnStartOneBased+(0:c.width-1);
verifyEqual(testCase,panels.thorcam,prepared.preview.thorcamAligned(rows,cols));
verifyEqual(testCase,panels.validation,prepared.preview.validationAligned(rows,cols));
verifyEqual(testCase,panels.global,images.global(rows,cols));
verifyEqual(testCase,panels.local,images.local(rows,cols));
verifyEqual(testCase,geometry.registration.crop,prepared.crop);
end
