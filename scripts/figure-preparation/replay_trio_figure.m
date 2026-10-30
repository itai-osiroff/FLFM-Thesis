function result = replay_trio_figure(recipePath, dataRoot, varargin)
%REPLAY_TRIO_FIGURE Rebuild one trio-comparison candidate without dialogs.
%   Each invocation retains a generation and automatically compiles its PDF.
%   Publish controls advancement of latest, never replacement of history.
%   DATAROOT is intentionally outside Git. Failures after preflight return an
%   incomplete generation with diagnostics; preflight failures still throw.

if nargin < 2 || strlength(string(dataRoot)) == 0
    dataRoot = getenv('TRIO_FIGURE_DATA_ROOT');
end
if strlength(string(dataRoot)) == 0 || ~isfolder(dataRoot)
    error('triofig:MissingInput', ...
        'Provide the existing data root as the second argument or TRIO_FIGURE_DATA_ROOT.');
end

parser = inputParser;
parser.FunctionName = mfilename;
addParameter(parser, 'OutputDirectory', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'ReferenceDirectory', '', @(value) ischar(value) || isstring(value));
addParameter(parser, 'Publish', true, @(value) islogical(value) && isscalar(value));
addParameter(parser, 'CompilerExecutable', 'pdflatex', @(value) ischar(value) || isstring(value));
parse(parser, varargin{:});
options = parser.Results;

recipePath = char(string(recipePath));
recipe = triofig.readRecipe(recipePath);
scriptRoot = fileparts(mfilename('fullpath'));
repositoryRoot = fileparts(fileparts(scriptRoot));
dataRoot = char(string(dataRoot));
outputDirectory = resolveOutputDirectory(options.OutputDirectory, recipePath, recipe, repositoryRoot);
referenceDirectory = resolveReferenceDirectory(options.ReferenceDirectory, recipePath);
inputs = resolveInputs(dataRoot, recipe.input);
validateInputs(inputs, recipe);
lock = triofig.lockFigure(outputDirectory); %#ok<NASGU>
[generationDirectory, generation] = triofig.newGeneration(outputDirectory, 'replay', '');
generation.published = options.Publish;
recipeCopyPath = fullfile(generationDirectory, 'metadata', 'trio-recipe.json');
copyfile(recipePath, recipeCopyPath, 'f');
manifest = struct('generation', generation, 'repository', triofig.repositoryRecord());
outputs = [];
comparison = [];
crop = [];
assetNames = {};
try
workspace = load(inputs.workspace, recipe.input.requiredWorkspaceVariables{:});

prepared = triofig.preparePanels( ...
    workspace.average_rectified_global_image, workspace.average_rectified_image, ...
    imread(inputs.thorcam), imread(inputs.validation), recipe);
panels = triofig.renderPanels(prepared, recipe.presentation.upsampleFactor);
zooms = triofig.extractZooms(panels, recipe.presentation.zoomRois);

[assetNames, assetImages] = assetImageMap(panels, zooms);
outputs = writeAssets(fullfile(generationDirectory, 'assets'), assetNames, assetImages);
layoutPath = fullfile(generationDirectory, 'latex', 'trio-layout.tex');
layoutRecipe = recipe;
layoutRecipe.figure.assetDirectoryFromWrapper = '../assets';
writeTexLayout(layoutPath, layoutRecipe, panels);
copyfile(fullfile(repositoryRoot, 'candidate-outputs', 'figures-source', ...
    'trio-comparison-template.tex'), fullfile(generationDirectory, 'latex', 'trio-comparison-template.tex'));
comparison = compareWithCandidate(fullfile(generationDirectory, 'assets'), referenceDirectory, outputs);
manifest = buildManifest(recipe, recipePath, inputs, scriptRoot, repositoryRoot, ...
    prepared, comparison, outputs, layoutPath, recipeCopyPath);
manifest.generation = generation;
manifest.repository = triofig.repositoryRecord();
crop = prepared.crop;
manifest.preview = triofig.compilePreview(generationDirectory, options.CompilerExecutable);
% Record comparison failure even for inspection generations.
try
    assertPublishable(comparison, recipe.comparison);
    manifest.generation.comparisonApproved = true;
catch cause
    manifest.generation.error = struct('identifier', cause.identifier, 'message', cause.message);
end
if strcmp(manifest.preview.status, 'complete') && manifest.generation.comparisonApproved
    manifest.generation.status = 'complete';
elseif isempty(manifest.generation.error.identifier)
    manifest.generation.error = struct('identifier', 'triofig:PreviewFailure', 'message', manifest.preview.error);
end
catch cause
    manifest.generation = generation;
    manifest.generation.error = struct('identifier', cause.identifier, 'message', cause.message);
end
manifest.files = triofig.fileInventory(generationDirectory);
triofig.updateGeneration(outputDirectory, generationDirectory, manifest, options.Publish);
if strcmp(manifest.generation.status, 'complete') && ~isfile(fullfile(outputDirectory, 'trio-recipe.json'))
    copyfile(recipeCopyPath, fullfile(outputDirectory, 'trio-recipe.json'));
end
result = triofig.generationResult(outputDirectory, generationDirectory, manifest);
result.recipePath = recipeCopyPath;
result.assetNames = assetNames;
result.outputs = outputs;
result.crop = crop;
result.candidateComparison = comparison;
triofig.reportGeneration(result);
end

function outputDirectory = resolveOutputDirectory(configuredPath, recipePath, recipe, repositoryRoot)
configuredPath = char(string(configuredPath));
if ~isempty(configuredPath)
    outputDirectory = configuredPath;
elseif isfolder(fileparts(recipePath))
    outputDirectory = fileparts(recipePath);
    if strcmp(string(java.io.File(outputDirectory).getName()), 'metadata') && ...
            strcmp(string(java.io.File(fileparts(fileparts(outputDirectory))).getName()), 'generations')
        outputDirectory = fileparts(fileparts(fileparts(outputDirectory)));
    end
else
    outputDirectory = fullfile(repositoryRoot, strrep(recipe.candidateOutputRelativePath, '/', filesep));
end
outputDirectory = char(java.io.File(outputDirectory).getCanonicalPath());
end

function referenceDirectory = resolveReferenceDirectory(configuredPath, recipePath)
configuredPath = char(string(configuredPath));
if isempty(configuredPath)
    referenceDirectory = fileparts(recipePath);
else
    referenceDirectory = configuredPath;
end
if isfolder(fullfile(referenceDirectory, 'assets'))
    referenceDirectory = fullfile(referenceDirectory, 'assets');
elseif strcmp(string(java.io.File(referenceDirectory).getName()), 'metadata')
    referenceDirectory = fullfile(fileparts(referenceDirectory), 'assets');
elseif isfile(fullfile(referenceDirectory, 'figure-index.json'))
    index = triofig.readFigureIndex(referenceDirectory);
    if ~isempty(index.latest)
        referenceDirectory = fullfile(referenceDirectory, 'generations', index.latest, 'assets');
    end
end
end

function inputs = resolveInputs(dataRoot, inputConfig)
inputs = struct( ...
    'main', fullfile(dataRoot, inputConfig.mainCaptureRelativePath), ...
    'thorcam', fullfile(dataRoot, inputConfig.thorcamCaptureRelativePath), ...
    'validation', fullfile(dataRoot, inputConfig.validationCaptureRelativePath), ...
    'workspace', fullfile(dataRoot, inputConfig.workspaceRelativePath));
if ~isempty(inputConfig.runManifestRelativePath)
    inputs.runManifest = fullfile(dataRoot, inputConfig.runManifestRelativePath);
end
end

function validateInputs(inputs, recipe)
names = fieldnames(inputs);
for index = 1:numel(names)
    path = inputs.(names{index});
    if ~isfile(path)
        error('triofig:MissingInput', 'Required input is missing: %s', path);
    end
end
try
    imfinfo(inputs.main);
    imfinfo(inputs.thorcam);
    imfinfo(inputs.validation);
catch cause
    error('triofig:InvalidImage', ...
        'One or more configured camera captures could not be read: %s', cause.message);
end
workspaceVariables = {whos('-file', inputs.workspace).name};
for index = 1:numel(recipe.input.requiredWorkspaceVariables)
    required = recipe.input.requiredWorkspaceVariables{index};
    if ~ismember(required, workspaceVariables)
        error('triofig:InvalidWorkspace', ...
            'Workspace is missing required variable: %s', required);
    end
end
if ~isfield(inputs, 'runManifest')
    if ~strcmpi(triofig.fileSha256(inputs.workspace), recipe.reconstruction.recovery.workspaceSha256)
        error('triofig:InvalidRunInfo', ...
            'Workspace differs from the file reviewed during metadata recovery. Review its run information again.');
    end
    return;
end
runManifest = jsondecode(fileread(inputs.runManifest));
if ~isfield(runManifest, 'generation_id') || ...
        ~strcmp(runManifest.generation_id, recipe.input.expectedGenerationId)
    error('triofig:InvalidRunManifest', ...
        'Run manifest does not identify generation %s: %s', ...
        recipe.input.expectedGenerationId, inputs.runManifest);
end
if ~contains(fileread(inputs.runManifest), recipe.sceneId)
    error('triofig:InvalidRunManifest', ...
        'Run manifest does not mention the expected scene: %s', recipe.sceneId);
end
end

function [assetNames, assetImages] = assetImageMap(panels, zooms)
assetNames = { ...
    'thorcam_downsampled.png', 'global_average.png', 'local_average.png', ...
    'thorcam_zoom_1.png', 'global_zoom_1.png', 'local_zoom_1.png', ...
    'thorcam_zoom_2.png', 'global_zoom_2.png', 'local_zoom_2.png'};
assetImages = { ...
    panels.thorcam, panels.global, panels.local, ...
    zooms.thorcam_zoom_1, zooms.global_zoom_1, zooms.local_zoom_1, ...
    zooms.thorcam_zoom_2, zooms.global_zoom_2, zooms.local_zoom_2};
end

function outputs = writeAssets(stagingDirectory, assetNames, assetImages)
outputs = repmat(struct('filename', '', 'sha256', '', 'height', 0, 'width', 0), ...
    numel(assetNames), 1);
for index = 1:numel(assetNames)
    path = fullfile(stagingDirectory, assetNames{index});
    image = assetImages{index};
    imwrite(image, path, 'png');
    triofig.canonicalizePng(path);
    outputs(index) = struct( ...
        'filename', assetNames{index}, ...
        'sha256', triofig.fileSha256(path), ...
        'height', size(image, 1), ...
        'width', size(image, 2));
end
end

function comparison = compareWithCandidate(stagingDirectory, referenceDirectory, outputs)
comparison = repmat(struct( ...
    'filename', '', 'referenceExists', false, 'sameDimensions', false, ...
    'samePixels', false, 'maximumAbsolutePixelDifference', [], ...
    'meanAbsolutePixelDifference', []), numel(outputs), 1);
for index = 1:numel(outputs)
    filename = outputs(index).filename;
    generatedPath = fullfile(stagingDirectory, filename);
    candidatePath = fullfile(referenceDirectory, filename);
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
        comparison(index).samePixels = comparison(index).maximumAbsolutePixelDifference == 0;
    else
        comparison(index).maximumAbsolutePixelDifference = Inf;
        comparison(index).meanAbsolutePixelDifference = Inf;
    end
end
end

function assertPublishable(comparison, settings)
if ~settings.requireExactCandidateMatchBeforePublish
    return;
end
for index = 1:numel(comparison)
    item = comparison(index);
    if ~item.referenceExists || ~item.sameDimensions || ~item.samePixels || ...
            item.maximumAbsolutePixelDifference > settings.maximumAbsolutePixelDifference
        error('triofig:CandidateMismatch', ...
            'Generated %s differs from the expected candidate; latest was not advanced.', ...
            item.filename);
    end
end
end

function writeTexLayout(path, recipe, panels)
mainWidth = recipe.figure.mainWidthCm;
zoomWidth = recipe.figure.zoomWidthCm;
insets = cell(1, numel(recipe.presentation.zoomRois));
reference = panels.global;
for index = 1:numel(recipe.presentation.zoomRois)
    roi = recipe.presentation.zoomRois(index);
    x = roi.xZeroBased / size(reference, 2) * mainWidth;
    y = (size(reference, 1) - roi.yZeroBased - roi.height) / size(reference, 1) * mainWidth;
    width = roi.width / size(reference, 2) * mainWidth;
    height = roi.height / size(reference, 1) * mainWidth * ...
        (size(reference, 1) / size(reference, 2));
    insets{index} = sprintf('%.6f/%.6f/%.6f/%.6f/%s/%d', ...
        x, y, width, height, roi.color, roi.id);
end
columnNames = {'thorcam_downsampled.png', 'global_average.png', 'local_average.png'};
zoomPrefixes = {'thorcam', 'global', 'local'};
% These are successive outputs of one global-then-local reconstruction run.
titles = {'ThorCam', '\shortstack{After global\\alignment}', ...
    '\shortstack{After local\\refinement (final)}'};
columnImages = {panels.thorcam, panels.global, panels.local};
columns = cell(1, numel(columnNames));
for index = 1:numel(columnNames)
    image = columnImages{index};
    columns{index} = sprintf('%s/%s/%s/%.6f', columnNames{index}, ...
        zoomPrefixes{index}, titles{index}, size(image, 1) / size(image, 2));
end

file = fopen(path, 'w');
if file == -1
    error('triofig:WriteFailure', 'Could not write generated TeX layout %s.', path);
end
cleaner = onCleanup(@() fclose(file));
fprintf(file, '%% Generated from trio-recipe.json by replay_trio_figure.m.\n');
fprintf(file, '%% Keep caption text in the author-maintained figure wrapper.\n');
fprintf(file, '\\TrioComparisonFigure\n');
fprintf(file, '    {%s}\n', recipe.figure.assetDirectoryFromWrapper);
fprintf(file, '    {%.6f}\n', mainWidth);
fprintf(file, '    {%.6f}\n', zoomWidth);
fprintf(file, '    {%s}\n', strjoin(insets, ','));
fprintf(file, '    {%s}\n', strjoin(columns, ','));
clear cleaner
end

function manifest = buildManifest(recipe, recipePath, inputs, scriptRoot, repositoryRoot, ...
        prepared, comparison, outputs, layoutPath, recipeCopyPath)
inputNames = fieldnames(inputs);
relativePaths = struct( ...
    'main', recipe.input.mainCaptureRelativePath, ...
    'thorcam', recipe.input.thorcamCaptureRelativePath, ...
    'validation', recipe.input.validationCaptureRelativePath, ...
    'runManifest', recipe.input.runManifestRelativePath, ...
    'workspace', recipe.input.workspaceRelativePath);
inputRecords = repmat(struct('role', '', 'path', '', 'sha256', ''), numel(inputNames), 1);
for index = 1:numel(inputNames)
    name = inputNames{index};
    inputRecords(index) = struct('role', name, 'path', relativePaths.(name), ...
        'sha256', triofig.fileSha256(inputs.(name)));
end
manifest = struct( ...
    'schemaVersion', recipe.schemaVersion, ...
    'generationManifestSchemaVersion', 1, ...
    'sceneId', recipe.sceneId, ...
    'recipe', struct('filename', 'trio-recipe.json', ...
        'sha256', triofig.fileSha256(recipePath), ...
        'publishedCopySha256', triofig.fileSha256(recipeCopyPath)), ...
    'pipeline', pipelineRecord(scriptRoot), ...
    'inputs', inputRecords, ...
    'reconstruction', struct( ...
        'generationId', recipe.input.expectedGenerationId, ...
        'availableRunRelativePath', recipe.reconstruction.availableRunRelativePath, ...
        'manifestRecordedRunRelativePath', recipe.reconstruction.manifestRecordedRunRelativePath, ...
        'workspaceRelativePath', recipe.input.workspaceRelativePath), ...
    'cameraPreparation', recipe.cameraPreparation, ...
    'registration', prepared.registration, ...
    'crop', prepared.crop, ...
    'intensity', appendRecoveryNote(prepared.intensity, recipe.presentation), ...
    'zoomRois', recipe.presentation.zoomRois, ...
    'calibration', recipe.calibration, ...
    'sourceSnapshots', sourceSnapshots(recipe, repositoryRoot), ...
    'environment', environmentRecord(), ...
    'candidateComparison', comparison, ...
    'outputs', outputs, ...
    'texLayout', struct('filename', 'trio-layout.tex', 'path', 'latex/trio-layout.tex', ...
        'sha256', triofig.fileSha256(layoutPath)));
if recipe.schemaVersion == 3
    manifest.reconstruction.manifestStatus = recipe.reconstruction.manifestStatus;
    manifest.reconstruction.stageId = recipe.reconstruction.stageId;
    if strcmp(recipe.reconstruction.manifestStatus, 'absent')
        manifest.reconstruction.recovery = recipe.reconstruction.recovery;
    end
end
end

function result = appendRecoveryNote(intensity, presentation)
result = intensity;
if isfield(presentation, 'recoveryNote')
    result.recoveryNote = presentation.recoveryNote;
end
end

function record = pipelineRecord(scriptRoot)
paths = [{fullfile(scriptRoot, 'replay_trio_figure.m')}; ...
    fullfile({dir(fullfile(scriptRoot, '+triofig', '*.m')).folder}, ...
    {dir(fullfile(scriptRoot, '+triofig', '*.m')).name})'];
records = repmat(struct('path', '', 'sha256', ''), numel(paths), 1);
for index = 1:numel(paths)
    records(index) = struct('path', strrep(erase(paths{index}, [scriptRoot filesep]), char(92), '/'), ...
        'sha256', triofig.fileSha256(paths{index}));
end
record = struct('entryPoint', 'scripts/figure-preparation/replay_trio_figure.m', ...
    'files', records);
end

function records = sourceSnapshots(recipe, repositoryRoot)
records = repmat(struct('filename', '', 'sha256', ''), 0, 1);
if ~isfield(recipe, 'provenance') || ...
        ~isfield(recipe.provenance, 'sourceSnapshotDirectoryRelativePath') || ...
        isempty(recipe.provenance.sourceSnapshotDirectoryRelativePath)
    return;
end
directory = fullfile(repositoryRoot, strrep( ...
    recipe.provenance.sourceSnapshotDirectoryRelativePath, '/', filesep));
if ~isfolder(directory)
    return;
end
entries = dir(fullfile(directory, '*.m'));
records = repmat(struct('filename', '', 'sha256', ''), numel(entries), 1);
for index = 1:numel(entries)
    path = fullfile(entries(index).folder, entries(index).name);
    records(index) = struct('filename', entries(index).name, ...
        'sha256', triofig.fileSha256(path));
end
end

function record = environmentRecord()
installed = ver;
toolboxNames = {'Image Processing Toolbox', 'Statistics and Machine Learning Toolbox'};
toolboxes = repmat(struct('name', '', 'version', ''), 0, 1);
for index = 1:numel(toolboxNames)
    match = find(strcmp({installed.Name}, toolboxNames{index}), 1);
    if ~isempty(match)
        toolboxes(end + 1) = struct('name', installed(match).Name, ...
            'version', installed(match).Version); %#ok<AGROW>
    end
end
record = struct('matlabVersion', version, 'toolboxes', toolboxes);
end
