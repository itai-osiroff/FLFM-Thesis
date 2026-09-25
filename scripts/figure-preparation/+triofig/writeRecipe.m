function writeRecipe(path, recipe)
%WRITERECIPE Write a recipe atomically without changing its semantics.

path = char(string(path));
parent = fileparts(path);
if ~isempty(parent) && ~isfolder(parent)
    mkdir(parent);
end
temporaryPath = [tempname(parent) '.json'];
cleaner = onCleanup(@() deleteIfPresent(temporaryPath));
file = fopen(temporaryPath, 'w');
if file == -1
    error('triofig:WriteFailure', 'Could not write recipe %s.', path);
end
fileCleaner = onCleanup(@() fclose(file));
fprintf(file, '%s\n', jsonencode(recipe, 'PrettyPrint', true));
clear fileCleaner
[moved, message] = movefile(temporaryPath, path, 'f');
if ~moved
    error('triofig:WriteFailure', 'Could not publish recipe %s: %s', path, message);
end
clear cleaner
end

function deleteIfPresent(path)
if isfile(path)
    delete(path);
end
end
