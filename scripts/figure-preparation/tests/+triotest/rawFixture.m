function [recipePath, root] = rawFixture(parent, recipe, data)
%RAWFIXTURE Write synthetic captures, a workspace and a run manifest for replay.
% Returns the saved recipe path and the data root, ready for replay_trio_figure.

root = fullfile(parent, 'raw'); mkdir(root);
image = uint16(mat2gray(data.globalImage) * 65535);
imwrite(image, fullfile(root, 'main.tif'));
imwrite(image, fullfile(root, 'thorcam.tif'));
imwrite(image, fullfile(root, 'validation.tif'));
average_rectified_global_image = data.globalImage; %#ok<NASGU>
average_rectified_image = data.localImage; %#ok<NASGU>
config_json = '{}'; %#ok<NASGU>
save(fullfile(root, 'workspace.mat'), 'average_rectified_global_image', 'average_rectified_image', 'config_json');
fid = fopen(fullfile(root, 'experiment_manifest.json'), 'w');
fprintf(fid, '%s', '{"generation_id":"test-run","scene":"test"}');
fclose(fid);
recipe.input.mainCaptureRelativePath = 'main.tif';
recipe.input.thorcamCaptureRelativePath = 'thorcam.tif';
recipe.input.validationCaptureRelativePath = 'validation.tif';
recipe.input.workspaceRelativePath = 'workspace.mat';
recipe.input.runManifestRelativePath = 'experiment_manifest.json';
recipe.input.expectedGenerationId = 'test-run';
recipe.input.workspaceSha256 = triofig.fileSha256(fullfile(root, 'workspace.mat'));
recipe.input.workspaceMode = 'shared';
recipe.input.localWorkspaceRelativePath = 'workspace.mat';
recipe.input.localWorkspaceSha256 = recipe.input.workspaceSha256;
recipe.input.localRunManifestRelativePath = 'experiment_manifest.json';
recipe.input.expectedLocalGenerationId = 'test-run';
recipe.reconstruction.localWorkspace = struct('manifestStatus', 'present', ...
    'stageId', recipe.reconstruction.stageId, ...
    'availableRunRelativePath', recipe.reconstruction.availableRunRelativePath, ...
    'manifestRecordedRunRelativePath', recipe.reconstruction.manifestRecordedRunRelativePath);
recipePath = fullfile(root, 'recipe.json');
triofig.writeRecipe(recipePath, recipe);
end
