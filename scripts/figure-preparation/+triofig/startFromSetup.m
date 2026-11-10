function [recipe, figureRoot] = startFromSetup(source)
%STARTFROMSETUP Read an existing recipe or generation as the seed for a new setup.
% source: a recipe .json, a generation directory, or a figure root (which
% resolves to its selected export, else its latest generation). The source
% files are only read. The recipe is upgraded to schema 6 with legacy min/max
% display so replay reproduces the source pixels until the display is edited,
% and its exact-match publish gate is cleared because the new generation is
% expected to differ. figureRoot is the figure the source belongs to.

source = char(string(source));
[recipePath, figureRoot] = resolveSource(source);
recipe = triofig.readRecipe(recipePath);
recipe = triofig.upgradeRecipe(recipe);
recipe.comparison.requireExactCandidateMatchBeforePublish = false;
end

function [recipePath, figureRoot] = resolveSource(source)
if isfile(source)
    recipePath = source;
    figureRoot = rootOfRecipe(source);
    return;
end
if ~isfolder(source)
    error('triofig:StartFromUnavailable', 'StartFrom path does not exist: %s', source);
end
if isfile(fullfile(source, 'figure-index.json'))
    figureRoot = source;
    index = triofig.readFigureIndex(figureRoot);
    generationId = char(string(index.selected));
    if isempty(generationId), generationId = char(string(index.latest)); end
    candidate = fullfile(figureRoot, 'generations', generationId, 'metadata', 'trio-recipe.json');
    if ~isempty(generationId) && isfile(candidate)
        recipePath = candidate;
        return;
    end
    if isfile(fullfile(figureRoot, 'trio-recipe.json'))
        recipePath = fullfile(figureRoot, 'trio-recipe.json');
        return;
    end
elseif isfile(fullfile(source, 'metadata', 'trio-recipe.json'))
    recipePath = fullfile(source, 'metadata', 'trio-recipe.json');
    figureRoot = rootOfRecipe(recipePath);
    return;
elseif isfile(fullfile(source, 'trio-recipe.json'))
    recipePath = fullfile(source, 'trio-recipe.json');
    figureRoot = source;
    return;
end
error('triofig:StartFromUnavailable', ...
    ['No trio-recipe.json was found for %s. Recipe-less legacy imports can be previewed ' ...
    'with preview_trio_figure but cannot seed a new setup.'], source);
end

function figureRoot = rootOfRecipe(recipePath)
folder = fileparts(recipePath);
[parent, name] = fileparts(folder);
if strcmp(name, 'metadata')
    [container, containerName] = fileparts(parent);
    [grand, grandName] = fileparts(container);
    if strcmp(grandName, 'generations')
        figureRoot = grand;
    elseif strcmp(containerName, 'selected')
        figureRoot = container;
    else
        figureRoot = parent;
    end
else
    figureRoot = folder;
end
end
