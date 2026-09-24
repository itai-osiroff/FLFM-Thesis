function result = run_figure_replay(dataRoot, varargin)
%RUN_FIGURE_REPLAY Recreate the June 3 candidate figure inputs in batch mode.
%   RESULT = RUN_FIGURE_REPLAY(DATAROOT) writes validated assets to the
%   candidate bundle only after every staging and comparison check succeeds.
%   Supply 'Publish', false to retain a staging directory for inspection.

scriptRoot = fileparts(mfilename('fullpath'));
defaultConfigPath = fullfile(scriptRoot, 'replay_config.json');
parser = inputParser;
parser.FunctionName = mfilename;
addParameter(parser, 'ConfigPath', defaultConfigPath, @(value) ischar(value) || isstring(value));
addParameter(parser, 'OutputDirectory', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'Publish', true, @(value) islogical(value) && isscalar(value));
parse(parser, varargin{:});
options = parser.Results;

if nargin < 1 || strlength(string(dataRoot)) == 0
    dataRoot = getenv('EYEDROP_20260603_DATA_ROOT');
end
if strlength(string(dataRoot)) == 0 || ~isfolder(dataRoot)
    error('eyedrop_replay:MissingInput', ...
        'Provide the existing June 3 data root as the first argument.');
end
dataRoot = char(dataRoot);
configPath = char(options.ConfigPath);
if ~isfile(configPath)
    error('eyedrop_replay:MissingInput', 'Replay config is missing: %s', configPath);
end
config = jsondecode(fileread(configPath));

repositoryRoot = fileparts(fileparts(fileparts(scriptRoot)));
outputDirectory = char(options.OutputDirectory);
if isempty(outputDirectory)
    outputDirectory = fullfile(repositoryRoot, config.candidateOutputRelativePath);
end
if ~isfolder(outputDirectory)
    mkdir(outputDirectory);
end

inputs = resolveInputs(dataRoot, config.input);
validateInputs(inputs, config);
runManifest = jsondecode(fileread(inputs.runManifest));
validateRunManifest(runManifest, config, inputs.runManifest);
workspace = load(inputs.workspace, config.input.requiredWorkspaceVariables{:});

aligned = downsample_align_crop( ...
    workspace.average_rectified_global_image, workspace.average_rectified_image, ...
    imread(inputs.thorcam), imread(inputs.validation), config);
fullPanels = renderPanels(aligned, config.presentation.upsampleFactor);
zooms = zoom_and_save(fullPanels, config.presentation.zoomRois);

stagingDirectory = createStagingDirectory(outputDirectory);
assetImages = assetImageMap(fullPanels, zooms);
assetNames = fieldnames(assetImages);
outputs = writeAssets(stagingDirectory, assetNames, assetImages);
comparison = compareWithCandidate(stagingDirectory, outputDirectory, assetNames);
manifest = buildManifest(config, inputs, scriptRoot, aligned, comparison, outputs);
manifestPath = fullfile(stagingDirectory, 'replay-manifest.json');
writeJson(manifestPath, manifest);

if options.Publish
    assertPublishable(comparison, config.comparison);
    publishAssets(stagingDirectory, outputDirectory, assetNames);
    copyfile(manifestPath, fullfile(outputDirectory, 'replay-manifest.json'), 'f');
    publishedManifestPath = fullfile(outputDirectory, 'replay-manifest.json');
    [removed, message] = rmdir(stagingDirectory, 's');
    if ~removed
        error('eyedrop_replay:StagingCleanupFailure', ...
            'Published assets, but could not remove staging directory %s: %s', ...
            stagingDirectory, message);
    end
    resultManifestPath = publishedManifestPath;
else
    publishedManifestPath = '';
    resultManifestPath = manifestPath;
end

result = struct( ...
    'configPath', configPath, ...
    'stagingDirectory', stagingDirectory, ...
    'manifestPath', resultManifestPath, ...
    'publishedManifestPath', publishedManifestPath, ...
    'assetNames', {assetNames}, ...
    'crop', aligned.crop, ...
    'comparison', comparison);
end

function inputs = resolveInputs(dataRoot, inputConfig)
inputs = struct( ...
    'main', fullfile(dataRoot, inputConfig.mainCaptureRelativePath), ...
    'thorcam', fullfile(dataRoot, inputConfig.thorcamCaptureRelativePath), ...
    'validation', fullfile(dataRoot, inputConfig.validationCaptureRelativePath), ...
    'runManifest', fullfile(dataRoot, inputConfig.runManifestRelativePath), ...
    'workspace', fullfile(dataRoot, inputConfig.workspaceRelativePath));
end

function validateInputs(inputs, config)
names = fieldnames(inputs);
for index = 1:numel(names)
    path = inputs.(names{index});
    if ~isfile(path)
        error('eyedrop_replay:MissingInput', 'Required input is missing: %s', path);
    end
end
try
    imfinfo(inputs.main);
    imfinfo(inputs.thorcam);
    imfinfo(inputs.validation);
catch cause
    error('eyedrop_replay:InvalidImage', ...
        'One or more configured camera captures could not be read: %s', cause.message);
end
workspaceVariables = {whos('-file', inputs.workspace).name};
for index = 1:numel(config.input.requiredWorkspaceVariables)
    required = config.input.requiredWorkspaceVariables{index};
    if ~ismember(required, workspaceVariables)
        error('eyedrop_replay:InvalidWorkspace', ...
            'Workspace is missing required variable: %s', required);
    end
end
end

function validateRunManifest(runManifest, config, manifestPath)
if ~isfield(runManifest, 'generation_id') || ...
        ~strcmp(runManifest.generation_id, config.input.expectedGenerationId)
    error('eyedrop_replay:InvalidRunManifest', ...
        'Run manifest does not identify generation %s: %s', ...
        config.input.expectedGenerationId, manifestPath);
end
manifestText = fileread(manifestPath);
if ~contains(manifestText, config.sceneId)
    error('eyedrop_replay:InvalidRunManifest', ...
        'Run manifest does not mention the expected scene: %s', config.sceneId);
end
end

function panels = renderPanels(aligned, upsampleFactor)
panels = struct( ...
    'thorcam', toUint8(imresize(aligned.thorcam, upsampleFactor, 'nearest')), ...
    'global', toUint8(imresize(aligned.global, upsampleFactor, 'nearest')), ...
    'local', toUint8(imresize(aligned.local, upsampleFactor, 'nearest')));
end

function image = toUint8(image)
image = uint8(round(min(max(image, 0), 1) * 255));
end

function assets = assetImageMap(panels, zooms)
assets = struct( ...
    'thorcam_downsampled_png', panels.thorcam, ...
    'global_average_png', panels.global, ...
    'local_average_png', panels.local, ...
    'thorcam_zoom_1_png', zooms.thorcam_zoom_1, ...
    'global_zoom_1_png', zooms.global_zoom_1, ...
    'local_zoom_1_png', zooms.local_zoom_1, ...
    'thorcam_zoom_2_png', zooms.thorcam_zoom_2, ...
    'global_zoom_2_png', zooms.global_zoom_2, ...
    'local_zoom_2_png', zooms.local_zoom_2);
end

function outputs = writeAssets(stagingDirectory, assetNames, assets)
outputs = repmat(struct('filename', '', 'sha256', '', 'height', 0, 'width', 0), ...
    numel(assetNames), 1);
for index = 1:numel(assetNames)
    filename = strrep(assetNames{index}, '_png', '.png');
    path = fullfile(stagingDirectory, filename);
    image = assets.(assetNames{index});
    imwrite(image, path, 'png');
    canonicalizePng(path);
    outputs(index) = struct( ...
        'filename', filename, 'sha256', fileSha256(path), ...
        'height', size(image, 1), 'width', size(image, 2));
end
end

function canonicalizePng(path)
% MATLAB adds a tIME chunk to PNG files. Remove it so file hashes describe
% image content rather than the wall-clock time at which imwrite ran.
input = fopen(path, 'r');
if input == -1
    error('eyedrop_replay:ReadFailure', 'Could not read generated PNG %s.', path);
end
inputCleaner = onCleanup(@() fclose(input));
bytes = fread(input, Inf, '*uint8').';
clear inputCleaner
signature = uint8([137, 80, 78, 71, 13, 10, 26, 10]);
if numel(bytes) < numel(signature) || ~isequal(bytes(1:8), signature)
    error('eyedrop_replay:InvalidPng', 'Generated asset is not a PNG: %s', path);
end
canonical = bytes(1:8);
position = 9;
while position <= numel(bytes)
    if position + 11 > numel(bytes)
        error('eyedrop_replay:InvalidPng', 'PNG chunk is truncated: %s', path);
    end
    chunkLength = double(bytes(position)) * 256^3 + ...
        double(bytes(position + 1)) * 256^2 + ...
        double(bytes(position + 2)) * 256 + double(bytes(position + 3));
    chunkEnd = position + 12 + chunkLength - 1;
    if chunkEnd > numel(bytes)
        error('eyedrop_replay:InvalidPng', 'PNG chunk exceeds file length: %s', path);
    end
    chunkType = bytes(position + 4:position + 7);
    if ~isequal(chunkType, uint8('tIME'))
        canonical = [canonical, bytes(position:chunkEnd)]; %#ok<AGROW>
    end
    position = chunkEnd + 1;
end
output = fopen(path, 'w');
if output == -1
    error('eyedrop_replay:WriteFailure', 'Could not rewrite generated PNG %s.', path);
end
outputCleaner = onCleanup(@() fclose(output));
fwrite(output, canonical, 'uint8');
clear outputCleaner
end

function comparison = compareWithCandidate(stagingDirectory, candidateDirectory, assetNames)
comparison = repmat(struct( ...
    'filename', '', 'referenceExists', false, 'sameDimensions', false, ...
    'maximumAbsolutePixelDifference', [], 'meanAbsolutePixelDifference', []), ...
    numel(assetNames), 1);
for index = 1:numel(assetNames)
    filename = strrep(assetNames{index}, '_png', '.png');
    generatedPath = fullfile(stagingDirectory, filename);
    candidatePath = fullfile(candidateDirectory, filename);
    comparison(index).filename = filename;
    comparison(index).referenceExists = isfile(candidatePath);
    if ~comparison(index).referenceExists
        continue;
    end
    generated = imread(generatedPath);
    candidate = imread(candidatePath);
    comparison(index).sameDimensions = isequal(size(generated), size(candidate));
    if comparison(index).sameDimensions
        difference = abs(double(generated) - double(candidate));
        comparison(index).maximumAbsolutePixelDifference = max(difference(:));
        comparison(index).meanAbsolutePixelDifference = mean(difference(:));
    else
        comparison(index).maximumAbsolutePixelDifference = Inf;
        comparison(index).meanAbsolutePixelDifference = Inf;
    end
end
end

function manifest = buildManifest(config, inputs, scriptRoot, aligned, comparison, outputs)
inputNames = fieldnames(inputs);
relativePaths = struct( ...
    'main', config.input.mainCaptureRelativePath, ...
    'thorcam', config.input.thorcamCaptureRelativePath, ...
    'validation', config.input.validationCaptureRelativePath, ...
    'runManifest', config.input.runManifestRelativePath, ...
    'workspace', config.input.workspaceRelativePath);
inputRecords = repmat(struct('role', '', 'path', '', 'sha256', ''), numel(inputNames), 1);
for index = 1:numel(inputNames)
    inputRecords(index) = struct( ...
        'role', inputNames{index}, 'path', relativePaths.(inputNames{index}), ...
        'sha256', fileSha256(inputs.(inputNames{index})));
end
snapshotNames = {'downsample_point_match.m', 'downsample_align_crop.m', 'zoom_and_save.m', 'temp.m'};
snapshots = repmat(struct('filename', '', 'sha256', ''), numel(snapshotNames), 1);
for index = 1:numel(snapshotNames)
    snapshotPath = fullfile(scriptRoot, 'source-snapshots', snapshotNames{index});
    snapshots(index) = struct('filename', snapshotNames{index}, ...
        'sha256', fileSha256(snapshotPath));
end
intensity = aligned.intensity;
intensity.recoveryNote = config.presentation.recoveryNote;
manifest = struct( ...
    'schemaVersion', config.schemaVersion, ...
    'sceneId', config.sceneId, ...
    'inputs', inputRecords, ...
    'reconstruction', struct( ...
        'generationId', config.input.expectedGenerationId, ...
        'availableRunRelativePath', config.archivedRun.availableRelativePath, ...
        'manifestRecordedRunRelativePath', config.archivedRun.manifestRecordedRelativePath, ...
        'workspaceRelativePath', config.input.workspaceRelativePath), ...
    'cameraPreparation', config.cameraPreparation, ...
    'registration', aligned.registration, ...
    'crop', aligned.crop, ...
    'intensity', intensity, ...
    'zoomRois', config.presentation.zoomRois, ...
    'sourceSnapshots', snapshots, ...
    'environment', struct('matlabVersion', version), ...
    'candidateComparison', comparison, ...
    'outputs', outputs);
end

function stagingDirectory = createStagingDirectory(outputDirectory)
stagingDirectory = fullfile(outputDirectory, ...
    ['replay-staging-' char(java.util.UUID.randomUUID)]);
[created, message] = mkdir(stagingDirectory);
if ~created
    error('eyedrop_replay:StagingFailure', ...
        'Could not create staging directory %s: %s', stagingDirectory, message);
end
end

function assertPublishable(comparison, settings)
if ~settings.requireExactCandidateMatchBeforePublish
    return;
end
for index = 1:numel(comparison)
    item = comparison(index);
    if ~item.referenceExists || ~item.sameDimensions || ...
            item.maximumAbsolutePixelDifference > settings.maximumAbsolutePixelDifference
        error('eyedrop_replay:CandidateMismatch', ...
            'Generated %s differs from the candidate bundle; assets were not replaced.', ...
            item.filename);
    end
end
end

function publishAssets(stagingDirectory, outputDirectory, assetNames)
for index = 1:numel(assetNames)
    filename = strrep(assetNames{index}, '_png', '.png');
    copied = copyfile(fullfile(stagingDirectory, filename), ...
        fullfile(outputDirectory, filename), 'f');
    if ~copied
        error('eyedrop_replay:PublishFailure', 'Could not publish %s.', filename);
    end
end
end

function writeJson(path, value)
file = fopen(path, 'w');
if file == -1
    error('eyedrop_replay:WriteFailure', 'Could not write %s.', path);
end
cleaner = onCleanup(@() fclose(file));
fprintf(file, '%s\n', jsonencode(value, 'PrettyPrint', true));
clear cleaner
end

function checksum = fileSha256(path)
digest = java.security.MessageDigest.getInstance('SHA-256');
input = java.io.FileInputStream(java.io.File(path));
stream = java.security.DigestInputStream(input, digest);
cleaner = onCleanup(@() stream.close());
buffer = zeros(1, 65536, 'int8');
while stream.read(buffer, 0, numel(buffer)) ~= -1
end
bytes = typecast(digest.digest(), 'uint8');
clear cleaner
checksum = lower(reshape(dec2hex(bytes, 2).', 1, []));
end
