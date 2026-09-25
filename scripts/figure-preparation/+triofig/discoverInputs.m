function discovery = discoverInputs(dataRoot, sceneId)
%DISCOVERINPUTS Find likely v1 trio inputs without opening any dialogs.

dataRoot = char(string(dataRoot));
sceneId = char(string(sceneId));
if ~isfolder(dataRoot)
    error('triofig:MissingInput', 'Data root is missing: %s', dataRoot);
end
stem = sceneStem(sceneId);
runManifests = findFiles(fullfile(dataRoot, 'algo_run'), 'experiment_manifest.json', stem);
if isempty(runManifests)
    runManifests = findFiles(fullfile(dataRoot, 'algo_run'), 'experiment_manifest.json', '');
end
discovery = struct( ...
    'main', candidateState(findImages(fullfile(dataRoot, 'main'), stem)), ...
    'thorcam', candidateState(findImages(fullfile(dataRoot, 'thorcam'), stem)), ...
    'validation', candidateState(findImages(fullfile(dataRoot, 'validation'), stem)), ...
    'workspace', candidateState(findFiles(fullfile(dataRoot, 'algo_run'), 'workspace.mat', stem)), ...
    'runManifest', candidateState(runManifests));
end

function candidates = findImages(folder, stem)
extensions = {'*.tif', '*.tiff', '*.png', '*.jpg', '*.jpeg'};
candidates = {};
for index = 1:numel(extensions)
    entries = dir(fullfile(folder, '**', extensions{index}));
    candidates = [candidates; fullfile({entries.folder}, {entries.name})']; %#ok<AGROW>
end
candidates = filterByStem(candidates, stem);
end

function candidates = findFiles(folder, filename, stem)
entries = dir(fullfile(folder, '**', filename));
candidates = fullfile({entries.folder}, {entries.name})';
candidates = filterByStem(candidates, stem);
end

function candidates = filterByStem(candidates, stem)
if isempty(candidates)
    return;
end
if strlength(string(stem)) == 0
    candidates = sort(candidates);
    return;
end
matches = contains(lower(strrep(candidates, char(92), '/')), lower(stem));
candidates = sort(candidates(matches));
end

function state = candidateState(candidates)
if isempty(candidates)
    status = 'missing';
elseif isscalar(candidates)
    status = 'single';
else
    status = 'ambiguous';
end
state = struct('status', status, 'candidates', {candidates});
end

function stem = sceneStem(sceneId)
parts = split(string(sceneId), '_');
if numel(parts) > 1
    stem = strjoin(parts(1:end-1), '_');
else
    stem = string(sceneId);
end
end
