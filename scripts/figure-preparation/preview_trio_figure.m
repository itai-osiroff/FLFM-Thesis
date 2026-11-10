function result = preview_trio_figure(sourceDirectory, varargin)
%PREVIEW_TRIO_FIGURE Derive a new PDF generation using saved images only.
%   Defaults to the source generation's renderer. UseCurrentTemplate=true
%   explicitly adopts today's shared renderer. The source is never modified.
parser = inputParser;
addParameter(parser, 'OutputDirectory', '', @(x) ischar(x) || isstring(x));
addParameter(parser, 'CompilerExecutable', 'pdflatex', @(x) ischar(x) || isstring(x));
addParameter(parser, 'UseCurrentTemplate', false, @(x) islogical(x) && isscalar(x));
addParameter(parser, 'Publish', true, @(x) islogical(x) && isscalar(x));
parse(parser, varargin{:});
options = parser.Results;
sourceDirectory = char(java.io.File(char(sourceDirectory)).getCanonicalPath());
isGeneration = isfolder(fullfile(sourceDirectory, 'metadata'));
if isGeneration
    sourceAssets = fullfile(sourceDirectory, 'assets');
    sourceLatex = fullfile(sourceDirectory, 'latex');
    parentManifest = jsondecode(fileread(fullfile(sourceDirectory, 'metadata', 'generation-manifest.json')));
    triofig.verifyGeneration(sourceDirectory, parentManifest, 'triofig:ChangedGeneration');
    parentId = parentManifest.generation.id;
    figureRoot = fileparts(fileparts(sourceDirectory));
else
    sourceAssets = sourceDirectory;
    sourceLatex = sourceDirectory;
    parentManifest = struct();
    parentId = '';
    figureRoot = sourceDirectory;
end
if strlength(string(options.OutputDirectory)) > 0
    figureRoot = char(options.OutputDirectory);
end
figureRoot = char(java.io.File(figureRoot).getCanonicalPath());
layout = fullfile(sourceLatex, 'trio-layout.tex');
template = fullfile(sourceLatex, 'trio-comparison-template.tex');
if options.UseCurrentTemplate || ~isfile(template)
    template = currentTemplate();
end
if ~isfile(layout)
    error('triofig:MissingInput', 'Missing saved layout: %s', layout);
end
names = {'thorcam_downsampled.png', 'global_average.png', 'local_average.png', ...
    'thorcam_zoom_1.png', 'thorcam_zoom_2.png', 'global_zoom_1.png', ...
    'global_zoom_2.png', 'local_zoom_1.png', 'local_zoom_2.png'};
for k = 1:numel(names)
    if ~isfile(fullfile(sourceAssets, names{k}))
        error('triofig:MissingInput', 'Missing saved asset: %s', names{k});
    end
end
% Stacked second versions of zoom insets, when the source generation has them.
extraFiles = dir(fullfile(sourceAssets, '*_zoom_*_emphasis.png'));
names = [names, {extraFiles.name}];
lock = triofig.lockFigure(figureRoot); %#ok<NASGU>
[directory, generation] = triofig.newGeneration(figureRoot, 'preview', parentId);
generation.published = options.Publish;
manifest = struct('schemaVersion', 1, 'generation', generation, ...
    'parent', struct('generationId', parentId));
try
manifest.repository = triofig.repositoryRecord();
if isGeneration
    manifest.parent.manifestSha256 = triofig.fileSha256(fullfile(sourceDirectory, 'metadata', 'generation-manifest.json'));
    % Retain input/reconstruction provenance without claiming new processing.
    manifest.sourceProvenance = parentManifest;
end
    for k = 1:numel(names)
        copyfile(fullfile(sourceAssets, names{k}), fullfile(directory, 'assets', names{k}));
    end
    triofig.localizeLayout(layout, fullfile(directory, 'latex', 'trio-layout.tex'));
    copyfile(template, fullfile(directory, 'latex', 'trio-comparison-template.tex'));
    recipePath = fullfile(sourceDirectory, 'trio-recipe.json');
    if isGeneration
        recipePath = fullfile(sourceDirectory, 'metadata', 'trio-recipe.json');
    end
    if isfile(recipePath)
        copyfile(recipePath, fullfile(directory, 'metadata', 'trio-recipe.json'));
    end
    manifest.preview = triofig.compilePreview(directory, options.CompilerExecutable);
    if isGeneration
        manifest.generation.comparisonApproved = parentManifest.generation.comparisonApproved;
    else
        % Standalone legacy previews do not perform or certify pixel replay.
        % A required exact-match gate must be established through replay.
        manifest.generation.comparisonApproved = ~isfile(recipePath);
        if isfile(recipePath)
            recipe = triofig.readRecipe(recipePath);
            manifest.generation.comparisonApproved = ~recipe.comparison.requireExactCandidateMatchBeforePublish;
        end
    end
    if strcmp(manifest.preview.status, 'complete') && manifest.generation.comparisonApproved
        manifest.generation.status = 'complete';
    elseif ~manifest.generation.comparisonApproved
        manifest.generation.error = struct('identifier', 'triofig:CandidateMismatch', ...
            'message', 'The source has not passed its required comparison gate; use replay to establish it.');
    else
        manifest.generation.error = struct('identifier', 'triofig:PreviewFailure', ...
            'message', manifest.preview.error);
    end
catch cause
    manifest.generation.error = struct('identifier', cause.identifier, 'message', cause.message);
end
manifest.files = triofig.fileInventory(directory);
triofig.updateGeneration(figureRoot, directory, manifest, options.Publish);
result = triofig.generationResult(figureRoot, directory, manifest);
triofig.reportGeneration(result);
end

function path = currentTemplate()
repo = fileparts(fileparts(fileparts(mfilename('fullpath'))));
path = fullfile(repo, 'candidate-outputs', 'figures-source', 'trio-comparison-template.tex');
end
