function [directory, record] = newGeneration(figureRoot, operation, parentId)
%NEWGENERATION Allocate immutable history; caller must hold the figure lock.
timestamp = char(datetime('now', 'TimeZone', 'UTC', 'Format', "yyyyMMdd'T'HHmmssSSS'Z'"));
unique = char(java.util.UUID.randomUUID);
id = [timestamp '-' unique(1:12)];
directory = fullfile(figureRoot, 'generations', id);
mkdir(fullfile(directory, 'assets'));
mkdir(fullfile(directory, 'metadata'));
mkdir(fullfile(directory, 'latex'));
mkdir(fullfile(directory, 'build'));
record = struct('id', id, 'createdUtc', timestamp, 'operation', operation, ...
    'parentGenerationId', parentId, 'status', 'incomplete', ...
    'comparisonApproved', false, 'published', false, 'error', struct('identifier', '', 'message', ''));
manifest = struct('generation', record);
triofig.writeJsonFile(fullfile(directory, 'metadata', 'generation-manifest.json'), manifest);
if ~strcmp(operation, 'legacy-import')
    % A killed process still leaves a discoverable incomplete attempt.
    triofig.updateGeneration(figureRoot, directory, manifest, false);
end
end
