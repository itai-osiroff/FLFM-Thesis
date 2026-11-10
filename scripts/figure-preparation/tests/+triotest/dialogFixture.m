function [recipe, data] = dialogFixture(method)
%DIALOGFIXTURE In-memory 40x50 synthetic trio inputs and a matching schema-6 recipe.
% method: 'window' (default) or 'legacyMinMax'. Geometry is saved, so no
% registration runs. The ThorCam and validation images equal the global image.

if nargin < 1, method = 'window'; end
[x, y] = meshgrid(1:50, 1:40);
image = sin(x / 3) + cos(y / 5) + x .* y / 1000;
recipe = triofig.defaultRecipe('test', 'candidate-outputs/figures-source/test');
recipe.presentation.display.method = method;
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
