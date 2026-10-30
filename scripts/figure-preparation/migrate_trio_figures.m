function results = migrate_trio_figures(sourceRoot, varargin)
%MIGRATE_TRIO_FIGURES Import flat bundles, preserving all historical bytes.
%   Repeatable: successful imports are reused. Originals are removed only
%   after a derived PDF succeeds and every preserved source hash is checked.
if nargin == 0
    repo = fileparts(fileparts(fileparts(mfilename('fullpath'))));
    sourceRoot = fullfile(repo, 'candidate-outputs', 'figures-source');
end
parser = inputParser;
addParameter(parser, 'CompilerExecutable', 'pdflatex', @(x) ischar(x) || isstring(x));
parse(parser, varargin{:});
sourceRoot = char(java.io.File(char(sourceRoot)).getCanonicalPath());
globalLock = triofig.lockFigure(sourceRoot); %#ok<NASGU>
entries = dir(sourceRoot);
results = {};
emptyDirectories = {};
for k = 1:numel(entries)
    if ~entries(k).isdir || startsWith(entries(k).name, '.') || ...
            ismember(entries(k).name, {'tmp', 'legacy-unassociated'})
        continue;
    end
    root = fullfile(sourceRoot, entries(k).name);
    index = triofig.readFigureIndex(root);
    if isfield(index, 'migration')
        imported = fullfile(root, 'generations', index.migration.generationId);
        if index.migration.finalized
            continue;
        end
    elseif isfile(fullfile(root, 'trio-layout.tex')) || strcmp(entries(k).name, 'example')
        imported = importBundle(sourceRoot, root);
    else
        files = dir(root);
        if numel(files) == 2
            emptyDirectories{end + 1} = entries(k).name; %#ok<AGROW>
        end
        continue;
    end
    result = preview_trio_figure(imported, 'CompilerExecutable', parser.Results.CompilerExecutable);
    results{end + 1} = result; %#ok<AGROW>
    if strcmp(result.status, 'complete')
        finishImport(sourceRoot, root, imported);
    end
end
% Preserve the copied PDF and orphan compile files without associating them
% with an experiment or making up a relationship to a known generation.
unassociated = archiveUnassociated(sourceRoot);
reportPath = fullfile(sourceRoot, 'migration-report.json');
if isfile(reportPath)
    previous = jsondecode(fileread(reportPath));
    unassociated = [previous.unassociatedFiles(:); unassociated(:)];
end
triofig.writeJsonFile(reportPath, struct('schemaVersion', 1, ...
    'emptyDirectories', {emptyDirectories}, 'unassociatedFiles', unassociated, ...
    'notes', {{'Import time is not historical generation time.', ...
    'July 12 wrapper repeats the June 3 caption; original text is retained without correction.', ...
    'Legacy template snapshots record the renderer available at import; the historical renderer is unknown.'}}));
end

function directory = importBundle(sourceRoot, root)
lock = triofig.lockFigure(root); %#ok<NASGU>
[directory, generation] = triofig.newGeneration(root, 'legacy-import', '');
unique = char(java.util.UUID.randomUUID);
id = ['legacy-' unique(1:12)];
target = fullfile(root, 'generations', id);
movefile(directory, target);
directory = target;
generation.id = id;
generation.status = 'legacy_imported';
generation.comparisonApproved = true;
original = fullfile(directory, 'legacy-original', 'bundle');
mkdir(original);
files = dir(root);
preserved = repmat(struct('source', '', 'preserved', '', 'sha256', ''), 0, 1);
for k = 1:numel(files)
    if files(k).isdir || ismember(files(k).name, {'.figure-lock', 'figure-index.json', 'README.md'})
        continue;
    end
    source = fullfile(root, files(k).name);
    destination = fullfile(original, files(k).name);
    preserved(end + 1) = preserve(sourceRoot, directory, source, destination); %#ok<AGROW>
    [~, ~, extension] = fileparts(source);
    if strcmpi(extension, '.png')
        copyfile(source, fullfile(directory, 'assets', lower(files(k).name)));
    end
end
recipePath = fullfile(root, 'trio-recipe.json');
comparisonEvidence = struct('basis', 'No exact historical replay gate required.');
if isfile(recipePath)
    copyfile(recipePath, fullfile(directory, 'metadata', 'trio-recipe.json'));
    recipe = triofig.readRecipe(recipePath);
    if recipe.comparison.requireExactCandidateMatchBeforePublish
        generation.comparisonApproved = false;
        oldManifestPath = fullfile(root, 'replay-manifest.json');
        if isfile(oldManifestPath)
            old = jsondecode(fileread(oldManifestPath));
            [generation.comparisonApproved, comparisonEvidence] = ...
                triofig.legacyComparisonApproval(recipePath, fullfile(directory, 'assets'), old);
        end
    end
end
[~, folder] = fileparts(root);
wrapper = '';
switch folder
    case 'eyedrop_3_6'
        wrapper = 'fig_eyedrop_3_6';
    case '12_7_26'
        wrapper = 'fig_eyedrop_12_7';
    case 'example'
        wrapper = 'fig_example_inlet';
end
if ~isempty(wrapper)
    wrapperFiles = dir(fullfile(sourceRoot, [wrapper '.*']));
    destinationRoot = fullfile(directory, 'legacy-original', 'wrappers');
    mkdir(destinationRoot);
    for k = 1:numel(wrapperFiles)
        source = fullfile(sourceRoot, wrapperFiles(k).name);
        preserved(end + 1) = preserve(sourceRoot, directory, source, ...
            fullfile(destinationRoot, wrapperFiles(k).name)); %#ok<AGROW>
    end
end
layout = fullfile(root, 'trio-layout.tex');
if ~isfile(layout)
    % The illustrative example has an inline macro call, not a recipe.
    layout = fullfile(directory, 'legacy-original', 'inline-layout.tex');
    writeInlineLayout(fullfile(sourceRoot, [wrapper '.tex']), layout);
end
triofig.localizeLayout(layout, fullfile(directory, 'latex', 'trio-layout.tex'));
template = fullfile(root, 'trio-comparison-template.tex');
if ~isfile(template)
    template = fullfile(sourceRoot, 'trio-comparison-template.tex');
end
copyfile(template, fullfile(directory, 'latex', 'trio-comparison-template.tex'));
manifest = struct('schemaVersion', 1, 'generation', generation, ...
    'historicalGenerationTime', 'unknown', 'reconstructionReplayAvailable', isfile(recipePath), ...
    'repositoryAtImport', triofig.repositoryRecord(), 'legacySources', preserved, ...
    'legacyComparisonEvidence', comparisonEvidence, ...
    'rendererProvenance', 'Snapshot available at import; historical renderer not established.', ...
    'files', triofig.fileInventory(directory));
triofig.updateGeneration(root, directory, manifest, false);
index = triofig.readFigureIndex(root);
index.migration = struct('generationId', id, 'finalized', false);
triofig.saveFigureIndex(root, index);
end

function record = preserve(sourceRoot, directory, source, destination)
copyfile(source, destination);
hash = triofig.fileSha256(source);
if ~strcmp(hash, triofig.fileSha256(destination))
    error('triofig:MigrationMismatch', 'Copy verification failed for %s.', source);
end
record = struct('source', strrep(source(numel(sourceRoot) + 2:end), '\', '/'), ...
    'preserved', strrep(destination(numel(directory) + 2:end), '\', '/'), 'sha256', hash);
end

function finishImport(sourceRoot, root, directory)
lock = triofig.lockFigure(root); %#ok<NASGU>
manifest = jsondecode(fileread(fullfile(directory, 'metadata', 'generation-manifest.json')));
sources = manifest.legacySources;
% Verify every source before deleting any of them. Only individual files
% explicitly copied by this import can be removed; never recurse over roots.
for k = 1:numel(sources)
    source = fullfile(sourceRoot, sources(k).source);
    saved = fullfile(directory, sources(k).preserved);
    if ~isfile(saved) || ~strcmp(triofig.fileSha256(saved), sources(k).sha256) || ...
            (isfile(source) && ~strcmp(triofig.fileSha256(source), sources(k).sha256))
        error('triofig:MigrationMismatch', 'Migration source changed: %s', source);
    end
end
for k = 1:numel(sources)
    source = fullfile(sourceRoot, sources(k).source);
    if strcmp(source, fullfile(root, 'trio-recipe.json'))
        continue; % Keep the author-editable working recipe.
    end
    if isfile(source)
        delete(source);
    end
end
index = triofig.readFigureIndex(root);
index.migration.finalized = true;
triofig.saveFigureIndex(root, index);
end

function records = archiveUnassociated(sourceRoot)
files = dir(sourceRoot);
records = repmat(struct('source', '', 'preserved', '', 'sha256', ''), 0, 1);
for k = 1:numel(files)
    if files(k).isdir
        continue;
    end
    [~, ~, extension] = fileparts(files(k).name);
    if ~ismember(lower(extension), {'.pdf', '.aux', '.log', '.fls', '.fdb_latexmk', '.gz'})
        continue;
    end
    [~, stem] = fileparts(files(k).name);
    if isfile(fullfile(sourceRoot, [stem '.tex']))
        continue; % Still belongs to an unfinished import, not an orphan.
    end
    destinationRoot = fullfile(sourceRoot, 'legacy-unassociated');
    if ~isfolder(destinationRoot)
        mkdir(destinationRoot);
    end
    source = fullfile(sourceRoot, files(k).name);
    destination = fullfile(destinationRoot, files(k).name);
    if isfile(destination) && ~strcmp(triofig.fileSha256(source), triofig.fileSha256(destination))
        error('triofig:MigrationMismatch', 'Unassociated archive already contains a different %s.', files(k).name);
    end
    records(end + 1) = preserve(sourceRoot, sourceRoot, source, destination); %#ok<AGROW>
    delete(source);
end
end

function writeInlineLayout(wrapper, destination)
text = fileread(wrapper);
start = strfind(text, '\TrioComparisonFigure');
if isempty(start)
    error('triofig:MissingInput', 'No inline trio layout in %s.', wrapper);
end
start = start(1);
depth = 0;
arguments = 0;
for k = start + strlength('\TrioComparisonFigure'):numel(text)
    if text(k) == '{'
        depth = depth + 1;
    elseif text(k) == '}'
        depth = depth - 1;
        if depth == 0
            arguments = arguments + 1;
            if arguments == 5
                fid = fopen(destination, 'w');
                cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
                fprintf(fid, '%s\n', text(start:k));
                return;
            end
        end
    end
end
error('triofig:InvalidLayout', 'Could not recover five inline macro arguments.');
end
