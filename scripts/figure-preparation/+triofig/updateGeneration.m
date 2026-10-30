function updateGeneration(figureRoot, directory, manifest, advanceLatest)
%UPDATEGENERATION Persist attempt before exposing it in the figure index.
triofig.writeJsonFile(fullfile(directory, 'metadata', 'generation-manifest.json'), manifest);
index = triofig.readFigureIndex(figureRoot);
record = manifest.generation;
ids = cellfun(@(item) item.id, index.generations, 'UniformOutput', false);
match = find(strcmp(ids, record.id), 1);
if isempty(match)
    index.generations{end + 1} = record;
else
    index.generations{match} = record;
end
if advanceLatest && strcmp(record.status, 'complete') && record.comparisonApproved
    index.latest = record.id;
end
triofig.saveFigureIndex(figureRoot, index);
end
