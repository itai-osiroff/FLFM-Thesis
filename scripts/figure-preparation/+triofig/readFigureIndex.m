function index = readFigureIndex(figureRoot)
path = fullfile(figureRoot, 'figure-index.json');
if isfile(path)
    index = jsondecode(fileread(path));
else
    [~, id] = fileparts(figureRoot);
    index = struct('schemaVersion', 1, 'figureId', id, 'latest', '', ...
        'selected', '', 'generations', {{}});
end
% A cell array allows different legacy and current metadata without struct
% concatenation restrictions; JSON still represents an ordinary array.
if isstruct(index.generations)
    index.generations = num2cell(index.generations);
elseif isempty(index.generations)
    index.generations = {};
end
end
