function recipe = readRecipe(path)
%READRECIPE Load and validate a versioned trio-figure recipe.

path = char(string(path));
if ~isfile(path)
    error('triofig:MissingRecipe', 'Recipe is missing: %s', path);
end
recipe = triofig.normalizeZoom(jsondecode(fileread(path)));
triofig.validateRecipe(recipe);
end
