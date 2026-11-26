function result = line_profile_figure(action, varargin)
%LINE_PROFILE_FIGURE Recipe-driven intensity-profile figures (separate from trio figures).
%
%   recipe = line_profile_figure('setup', figureDir, trioFigureDir, zoomId, dataRoot)
%       Writes figureDir/profile-recipe.json with a PROPOSED segment through the
%       bright spots of one trio zoom region of the final rectified image. The
%       trio recipe is read as data only (inputs, saved registration, crop,
%       zoom region); no trio code runs. Edit the segment coordinates by hand
%       if needed, then render.
%   recipe = line_profile_figure('offsets', figureDir, dataRoot)
%       For each segment, measures how far the same beads are displaced in the
%       regular-camera image and in G relative to the final image (local
%       normalized cross-correlation, lineprofile.localOffset) and writes the
%       offsets into the recipe. Each image is then sampled along the segment
%       moved by its offset, so all three profiles cross the same beads.
%   gen = line_profile_figure('render', figureDir, dataRoot)
%       Samples the regular-camera image, the global-stage average G and the
%       final rectified image along each segment and writes a new generation
%       (figure.pdf, figure.png, profiles.csv, recipe copy, manifest.json).
%   sel = line_profile_figure('select', figureDir, generationId)
%       Verifies the generation's hashes and copies it to figureDir/selected.
%
%   Segment coordinates are one-based [column, row] positions on the
%   reconstruction grid (the 400x400 workspace images). DATAROOT is the
%   acquisition folder outside Git (for example images_output\16_6_26).
switch lower(char(action))
    case 'setup'
        result = setupFigure(varargin{:});
    case 'offsets'
        result = offsetsFigure(varargin{:});
    case 'render'
        result = renderFigure(varargin{:});
    case 'select'
        result = selectFigure(varargin{:});
    otherwise
        error('lineprofile:UnknownAction', 'Unknown action "%s".', char(action));
end
end

% ---------------------------------------------------------------- setup
function recipe = setupFigure(figureDir, trioFigureDir, zoomId, dataRoot)
figureDir = canonical(figureDir);
trioFigureDir = canonical(trioFigureDir);
trioRecipePath = fullfile(trioFigureDir, 'selected', 'metadata', 'trio-recipe.json');
if ~isfile(trioRecipePath)
    error('lineprofile:MissingInput', 'No selected trio recipe at %s.', trioRecipePath);
end
trio = jsondecode(fileread(trioRecipePath));
if ~strcmp(trio.registration.transformSource, 'saved')
    error('lineprofile:UnsupportedRegistration', 'The trio recipe has no saved transforms.');
end
crop = trio.registration.crop;
up = trio.presentation.upsampleFactor;
rois = trio.presentation.zoomRois;
roi = rois([rois.id] == zoomId);
if isempty(roi)
    error('lineprofile:MissingInput', 'Trio recipe has no zoom region %d.', zoomId);
end
gridRoi = [crop.columnStartOneBased + roi.xZeroBased / up, ...
    crop.rowStartOneBased + roi.yZeroBased / up, roi.width / up, roi.height / up];
inputs = struct( ...
    'workspaceRelativePath', trio.input.workspaceRelativePath, ...
    'localWorkspaceRelativePath', localWorkspacePath(trio.input), ...
    'regularCaptureRelativePath', trio.input.thorcamCaptureRelativePath);
[~, local] = loadAverages(dataRoot, inputs);
segment = lineprofile.proposeSegment(local, gridRoi, 4);
recipe = struct();
recipe.schemaVersion = 1;
recipe.sceneId = trio.sceneId;
recipe.status = 'proposed';
recipe.trio = struct('figureFolder', repoRelative(trioFigureDir), ...
    'recipeRelativePath', repoRelative(trioRecipePath), ...
    'recipeSha256', lineprofile.fileSha256(trioRecipePath), ...
    'note', 'Read as data only: inputs, saved registration, crop and zoom region.');
recipe.input = inputs;
recipe.registration = struct( ...
    'camera', struct('rotationDegrees', trio.cameraPreparation.thorcam.rotationDegrees, ...
        'flipVertical', trio.cameraPreparation.thorcam.flipVertical, ...
        'downsampleFactor', trio.cameraPreparation.thorcam.downsampleFactor), ...
    'savedTransforms', struct( ...
        'rotationDegrees', trio.registration.savedTransforms.thorcamRotationDegrees, ...
        'translationXY', trio.registration.savedTransforms.thorcamTranslationXY(:).'), ...
    'rotationInterpolation', trio.registration.rotationInterpolation, ...
    'crop', crop);
recipe.segments = struct('id', 1, ...
    'source', sprintf('Proposed from trio zoom region %d (%s): %s in the final image.', ...
        zoomId, roi.color, kindText(segment.kind)), ...
    'startXY', round(segment.startXY, 2), 'endXY', round(segment.endXY, 2));
recipe.sampling = struct('stepPixels', 0.25, 'interpolation', 'bilinear');
recipe.panels = struct('marginPixels', 6, 'display', 'each crop linear from its minimum to its maximum');
recipe.normalization = 'each profile divided by its own maximum';
if ~isfolder(figureDir)
    mkdir(figureDir);
end
writeJson(fullfile(figureDir, 'profile-recipe.json'), recipe);
indexPath = fullfile(figureDir, 'figure-index.json');
if ~isfile(indexPath)
    writeJson(indexPath, struct('selected', '', 'generations', {{}}));
end
end

% -------------------------------------------------------------- offsets
function recipe = offsetsFigure(figureDir, dataRoot)
figureDir = canonical(figureDir);
recipePath = fullfile(figureDir, 'profile-recipe.json');
recipe = jsondecode(fileread(recipePath));
[globalAverage, localAverage] = loadAverages(dataRoot, recipe.input);
regular = lineprofile.registerRegular(imread(fullfile(dataRoot, recipe.input.regularCaptureRelativePath)), ...
    recipe.registration, size(globalAverage));
margin = 6;
maxShift = 6;
segments = recipe.segments;
for k = 1:numel(segments)
    s = segments(k);
    corners = [s.startXY(:).'; s.endXY(:).'];
    columns = floor(min(corners(:, 1))) - margin:ceil(max(corners(:, 1))) + margin;
    rows = floor(min(corners(:, 2))) - margin:ceil(max(corners(:, 2))) + margin;
    [regularOffset, regularPeak] = lineprofile.localOffset(regular, localAverage, columns, rows, maxShift);
    [globalOffset, globalPeak] = lineprofile.localOffset(globalAverage, localAverage, columns, rows, maxShift);
    offsets = struct('regular', round(regularOffset, 2), 'global', round(globalOffset, 2), 'final', [0, 0]);
    offsets.method = sprintf(['Displacement of the window [columns %d-%d, rows %d-%d] of the final image ', ...
        'in each other image: background removed (minus a sigma-4 px Gaussian blur), peak of the ', ...
        'normalized cross-correlation within +-%d px, parabolic ', ...
        'sub-pixel refinement (peak %.3f regular, %.3f G).'], columns(1), columns(end), rows(1), rows(end), ...
        maxShift, regularPeak, globalPeak);
    newSegments(k) = setfield(rmfieldIfPresent(s, 'offsetsXY'), 'offsetsXY', offsets); %#ok<AGROW,SFLD>
end
recipe.segments = newSegments;
writeJson(recipePath, recipe);
end

function s = rmfieldIfPresent(s, name)
if isfield(s, name)
    s = rmfield(s, name);
end
end

function offsets = segmentOffsets(s)
if isfield(s, 'offsetsXY')
    offsets = [s.offsetsXY.regular(:).'; s.offsetsXY.global(:).'; s.offsetsXY.final(:).'];
else
    offsets = zeros(3, 2);
end
end

% --------------------------------------------------------------- render
function result = renderFigure(figureDir, dataRoot)
figureDir = canonical(figureDir);
recipePath = fullfile(figureDir, 'profile-recipe.json');
recipe = jsondecode(fileread(recipePath));
trioRecipePath = recipe.trio.recipeRelativePath;
if ~java.io.File(trioRecipePath).isAbsolute()
    trioRecipePath = fullfile(repoRoot(), trioRecipePath);
end
if isfile(trioRecipePath) && ~strcmp(lineprofile.fileSha256(trioRecipePath), recipe.trio.recipeSha256)
    error('lineprofile:ChangedInput', 'The trio recipe changed since setup: %s.', trioRecipePath);
end
[globalAverage, localAverage, workspacePaths] = loadAverages(dataRoot, recipe.input);
capturePath = fullfile(dataRoot, recipe.input.regularCaptureRelativePath);
[regular, valid] = lineprofile.registerRegular(imread(capturePath), recipe.registration, size(globalAverage));

crop = recipe.registration.crop;
rows = crop.rowStartOneBased + (0:crop.height - 1);
columns = crop.columnStartOneBased + (0:crop.width - 1);
residual = registrationResidual(regular(rows, columns), globalAverage(rows, columns));

segments = recipe.segments;
step = recipe.sampling.stepPixels;
profiles = struct([]);
for k = 1:numel(segments)
    s = segments(k);
    offsets = segmentOffsets(s);
    startXY = s.startXY(:).';
    endXY = s.endXY(:).';
    [d, r, xs, ys] = lineprofile.sampleProfile(regular, startXY + offsets(1, :), endXY + offsets(1, :), step);
    [~, g] = lineprofile.sampleProfile(globalAverage, startXY + offsets(2, :), endXY + offsets(2, :), step);
    [~, l] = lineprofile.sampleProfile(localAverage, startXY + offsets(3, :), endXY + offsets(3, :), step);
    if ~all(valid(sub2ind(size(valid), round(ys), round(xs))))
        error('lineprofile:OutsideRegular', 'Segment %d leaves the registered regular-camera field.', s.id);
    end
    profiles(k).id = s.id; %#ok<AGROW>
    profiles(k).offsets = offsets;
    profiles(k).distance = d;
    profiles(k).raw = [r; g; l];
    profiles(k).normalized = [r / max(r); g / max(g); l / max(l)];
end

[generationDir, generationId] = newGeneration(figureDir);
copyfile(recipePath, fullfile(generationDir, 'profile-recipe.json'));
writeProfiles(fullfile(generationDir, 'profiles.csv'), profiles);
drawFigure(generationDir, recipe, profiles, regular, globalAverage, localAverage);

manifest = struct();
manifest.generationId = generationId;
manifest.createdUtc = char(datetime('now', 'TimeZone', 'UTC', 'Format', 'yyyy-MM-dd''T''HH:mm:ss''Z'''));
manifest.recipeSha256 = lineprofile.fileSha256(recipePath);
manifest.inputs = struct( ...
    'dataRoot', char(dataRoot), ...
    'workspace', fileRecord(workspacePaths{1}), ...
    'localWorkspace', fileRecord(workspacePaths{2}), ...
    'regularCapture', fileRecord(capturePath), ...
    'trioRecipe', struct('path', recipe.trio.recipeRelativePath, 'sha256', recipe.trio.recipeSha256));
manifest.registrationCheck = residual;
manifest.repository = repositoryRecord();
manifest.matlab = version;
manifest.outputs = outputRecords(generationDir, {'figure.pdf', 'figure.png', 'profiles.csv', 'profile-recipe.json'});
writeJson(fullfile(generationDir, 'manifest.json'), manifest);

index = readIndex(figureDir);
index.generations{end + 1} = generationId;
writeJson(fullfile(figureDir, 'figure-index.json'), index);
result = struct('generationId', generationId, 'directory', generationDir, ...
    'pdf', fullfile(generationDir, 'figure.pdf'), 'registrationCheck', residual);
end

% --------------------------------------------------------------- select
function result = selectFigure(figureDir, generationId)
figureDir = canonical(figureDir);
generationId = char(generationId);
if isempty(regexp(generationId, '^[A-Za-z0-9_-]+$', 'once'))
    error('lineprofile:NotSelectable', 'Invalid generation ID.');
end
source = fullfile(figureDir, 'generations', generationId);
manifest = jsondecode(fileread(fullfile(source, 'manifest.json')));
for k = 1:numel(manifest.outputs)
    out = manifest.outputs(k);
    if ~strcmp(lineprofile.fileSha256(fullfile(source, out.name)), out.sha256)
        error('lineprofile:ChangedGeneration', 'Output %s no longer matches its hash.', out.name);
    end
end
destination = fullfile(figureDir, 'selected');
if isfolder(destination)
    rmdir(destination, 's');
end
copyfile(source, destination);
index = readIndex(figureDir);
index.selected = generationId;
writeJson(fullfile(figureDir, 'figure-index.json'), index);
result = struct('generationId', generationId, 'pdf', fullfile(destination, 'figure.pdf'));
end

% -------------------------------------------------------------- drawing
function drawFigure(generationDir, recipe, profiles, regular, globalAverage, localAverage)
colors = struct('regular', [0.42, 0.42, 0.39], 'global', hex('#2a78d6'), ...
    'local', hex('#eb6834'), 'segment', hex('#eda100'));
margin = recipe.panels.marginPixels;
s = recipe.segments(1);
p = profiles(1);
corners = [s.startXY(:).'; s.endXY(:).'];
% A square crop centred on the segment, so the three panels fill their tiles.
% The same window in all three panels, so a moved segment shows its offset.
centre = mean(corners, 1);
half = ceil(max(abs(corners(2, :) - corners(1, :))) / 2 + margin + max(abs(p.offsets(:))));
columnRange = max(1, round(centre(1)) - half):min(size(regular, 2), round(centre(1)) + half);
rowRange = max(1, round(centre(2)) - half):min(size(regular, 1), round(centre(2)) + half);
images = {regular, globalAverage, localAverage};
titles = {'Regular camera', 'After global alignment', 'After local refinement (final)'};

figureHandle = figure('Visible', 'off', 'Color', 'w', 'Units', 'centimeters', 'Position', [0, 0, 16, 11.5]);
cleanup = onCleanup(@() close(figureHandle));
layout = tiledlayout(figureHandle, 2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');
for k = 1:3
    ax = nexttile(layout, k);
    patch = images{k}(rowRange, columnRange);
    imagesc(ax, columnRange, rowRange, patch, [min(patch(:)), max(patch(:))]);
    colormap(ax, gray(256));
    axis(ax, 'image');
    ax.XTick = [];
    ax.YTick = [];
    hold(ax, 'on');
    plot(ax, corners(:, 1) + p.offsets(k, 1), corners(:, 2) + p.offsets(k, 2), '-', ...
        'Color', colors.segment, 'LineWidth', 1.5);
    hold(ax, 'off');
    title(ax, titles{k}, 'FontSize', 9, 'FontWeight', 'normal');
end
ax = nexttile(layout, 4, [1, 3]);
hold(ax, 'on');
plot(ax, p.distance, p.normalized(1, :), '--', 'Color', colors.regular, 'LineWidth', 2, ...
    'DisplayName', 'Regular camera');
plot(ax, p.distance, p.normalized(2, :), '-', 'Color', colors.global, 'LineWidth', 2, ...
    'DisplayName', 'After global alignment ({\itG})');
plot(ax, p.distance, p.normalized(3, :), '-', 'Color', colors.local, 'LineWidth', 2, ...
    'DisplayName', 'After local refinement ({\itI}_{rect})');
hold(ax, 'off');
box(ax, 'off');
grid(ax, 'on');
ax.GridColor = [0.85, 0.85, 0.85];
ax.GridAlpha = 1;
ax.FontSize = 9;
xlim(ax, [p.distance(1), p.distance(end)]);
ylim(ax, [0, 1.05]);
xlabel(ax, 'Distance along the segment (reconstruction pixels)');
ylabel(ax, 'Normalized intensity');
legend(ax, 'Location', 'northoutside', 'Orientation', 'horizontal', 'Box', 'off', ...
    'Interpreter', 'tex', 'FontSize', 9);
exportgraphics(figureHandle, fullfile(generationDir, 'figure.pdf'), 'ContentType', 'vector');
exportgraphics(figureHandle, fullfile(generationDir, 'figure.png'), 'Resolution', 300);
end

% -------------------------------------------------------------- helpers
function [globalAverage, localAverage, paths] = loadAverages(dataRoot, inputs)
globalPath = fullfile(dataRoot, inputs.workspaceRelativePath);
localPath = fullfile(dataRoot, inputs.localWorkspaceRelativePath);
g = load(globalPath, 'average_rectified_global_image');
l = load(localPath, 'average_rectified_image');
globalAverage = double(g.average_rectified_global_image);
localAverage = double(l.average_rectified_image);
paths = {globalPath, localPath};
end

function path = localWorkspacePath(input)
if isfield(input, 'localWorkspaceRelativePath') && ~isempty(input.localWorkspaceRelativePath)
    path = input.localWorkspaceRelativePath;
else
    path = input.workspaceRelativePath;
end
end

function residual = registrationResidual(regular, reference)
% Peak of the normalized cross-correlation between the registered regular
% image and G over the trio crop: [dx, dy] = 0 means no leftover shift.
correlation = normxcorr2(regular, reference);
[peak, index] = max(correlation(:));
[row, column] = ind2sub(size(correlation), index);
residual = struct('dxPixels', column - size(regular, 2), 'dyPixels', row - size(regular, 1), ...
    'peakCorrelation', peak);
end

function writeProfiles(path, profiles)
lines = {'segment,distance_px,regular_raw,global_raw,final_raw,regular_norm,global_norm,final_norm'};
for k = 1:numel(profiles)
    p = profiles(k);
    for n = 1:numel(p.distance)
        lines{end + 1} = sprintf('%d,%.4f,%.6g,%.6g,%.6g,%.6f,%.6f,%.6f', p.id, p.distance(n), ...
            p.raw(:, n), p.normalized(:, n)); %#ok<AGROW>
    end
end
fid = fopen(path, 'w');
fprintf(fid, '%s\n', lines{:});
fclose(fid);
end

function [directory, id] = newGeneration(figureDir)
stamp = char(datetime('now', 'TimeZone', 'UTC', 'Format', 'yyyyMMdd''T''HHmmssSSS''Z'''));
token = char(java.util.UUID.randomUUID);
id = sprintf('%s-%s', stamp, token(1:8));
directory = fullfile(figureDir, 'generations', id);
mkdir(directory);
end

function index = readIndex(figureDir)
path = fullfile(figureDir, 'figure-index.json');
if isfile(path)
    index = jsondecode(fileread(path));
    if isempty(index.generations)
        index.generations = {};
    elseif ~iscell(index.generations)
        index.generations = cellstr(index.generations);
    end
else
    index = struct('selected', '', 'generations', {{}});
end
end

function records = outputRecords(directory, names)
records = struct('name', names, 'sha256', '');
for k = 1:numel(names)
    records(k).sha256 = lineprofile.fileSha256(fullfile(directory, names{k}));
end
end

function record = fileRecord(path)
record = struct('path', char(path), 'sha256', lineprofile.fileSha256(path));
end

function record = repositoryRecord()
[status, head] = system(sprintf('git -C "%s" rev-parse HEAD', repoRoot()));
[~, dirty] = system(sprintf('git -C "%s" status --porcelain -- scripts/figure-preparation', repoRoot()));
if status ~= 0
    head = 'unknown';
end
record = struct('revision', strtrim(head), 'figureToolsModified', ~isempty(strtrim(dirty)));
end

function writeJson(path, value)
fid = fopen(path, 'w');
fprintf(fid, '%s\n', jsonencode(value, 'PrettyPrint', true));
fclose(fid);
end

function root = repoRoot()
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
end

function relative = repoRelative(path)
root = [repoRoot() filesep];
relative = strrep(erase(char(path), root), '\', '/');
end

function path = canonical(path)
path = char(java.io.File(char(path)).getCanonicalPath());
end

function text = kindText(kind)
if strcmp(kind, 'pair')
    text = 'through the two brightest local maxima';
else
    text = 'horizontal through the brightest local maximum';
end
end

function rgb = hex(code)
rgb = sscanf(code(2:end), '%2x%2x%2x', [1, 3]) / 255;
end
