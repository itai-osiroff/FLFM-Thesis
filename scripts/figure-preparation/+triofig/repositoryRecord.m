function record = repositoryRecord()
%REPOSITORYRECORD Record current revision and exact relevant working files.
scriptRoot = fileparts(fileparts(mfilename('fullpath')));
repo = fileparts(fileparts(scriptRoot));
% Pass each argument directly: spaces and shell metacharacters stay literal.
[code, commit] = runGit(repo, {'rev-parse', 'HEAD'});
if code ~= 0
    commit = 'unknown';
end
[~, dirty] = runGit(repo, {'status', '--porcelain', '--', ...
    'scripts/figure-preparation', 'candidate-outputs/figures-source/trio-comparison-template.tex'});
paths = [dir(fullfile(scriptRoot, '*.m')); dir(fullfile(scriptRoot, '+triofig', '*.m'))];
files = repmat(struct('path', '', 'sha256', ''), numel(paths), 1);
for k = 1:numel(paths)
    path = fullfile(paths(k).folder, paths(k).name);
    files(k) = struct('path', strrep(path(numel(repo) + 2:end), '\', '/'), ...
        'sha256', triofig.fileSha256(path));
end
record = struct('commit', strtrim(commit), 'relevantWorkingTreeDirty', ~isempty(strtrim(dirty)), 'files', files);
end

function [code, output] = runGit(repo, gitArguments)
logPath = tempname;
cleanup = onCleanup(@() removeLog(logPath));
builder = java.lang.ProcessBuilder([{'git', '-C', repo}, gitArguments]);
builder.redirectErrorStream(true);
builder.redirectOutput(java.io.File(logPath));
try
    process = builder.start();
catch
    code = 1;
    output = '';
    return;
end
if ~process.waitFor(30, java.util.concurrent.TimeUnit.SECONDS)
    process.destroyForcibly();
    error('triofig:RepositoryTimeout', 'Git repository inspection exceeded 30 seconds.');
end
code = process.exitValue();
output = fileread(logPath);
end

function removeLog(path)
if isfile(path), delete(path); end
end
