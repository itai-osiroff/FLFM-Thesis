function cleanup = lockFigure(figureRoot)
%LOCKFIGURE Reject concurrent writers, including selection and migration.
if ~isfolder(figureRoot)
    mkdir(figureRoot);
end
lockPath = fullfile(figureRoot, '.figure-lock');
lockFile = java.io.File(lockPath);
if ~lockFile.createNewFile()
    error('triofig:FigureLocked', ...
        'Figure is locked: %s. If the writer crashed, remove this lock after checking no writer is running.', lockPath);
end
cleanup = onCleanup(@() release(lockPath));
end

function release(path)
if isfile(path)
    delete(path);
end
end
