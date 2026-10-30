function record = repositoryRecord()
%REPOSITORYRECORD Record current revision and exact relevant working files.
scriptRoot = fileparts(fileparts(mfilename('fullpath')));
repo = fileparts(fileparts(scriptRoot));
% Fixed repository path only; no recipe-supplied shell fragments.
original = pwd;
cleanup = onCleanup(@() cd(original)); %#ok<NASGU>
cd(repo);
[code, commit] = system('git rev-parse HEAD');
if code ~= 0
    commit = 'unknown';
end
[~, dirty] = system('git status --porcelain -- scripts/figure-preparation candidate-outputs/figures-source/trio-comparison-template.tex');
paths = [dir(fullfile(scriptRoot, '*.m')); dir(fullfile(scriptRoot, '+triofig', '*.m'))];
files = repmat(struct('path', '', 'sha256', ''), numel(paths), 1);
for k = 1:numel(paths)
    path = fullfile(paths(k).folder, paths(k).name);
    files(k) = struct('path', strrep(path(numel(repo) + 2:end), '\', '/'), ...
        'sha256', triofig.fileSha256(path));
end
record = struct('commit', strtrim(commit), 'relevantWorkingTreeDirty', ~isempty(strtrim(dirty)), 'files', files);
end
