function saveFigureIndex(figureRoot, index)
%SAVEFIGUREINDEX Write the machine index, then its disposable human view.
triofig.writeJsonFile(fullfile(figureRoot, 'figure-index.json'), index);
try
    writeReadme(figureRoot, index);
catch cause
    % The JSON commit is authoritative. A disposable view must never cause
    % selection to roll back its export after that commit succeeded.
    warning('triofig:ReadmeFailure', 'Index saved, but README could not be refreshed: %s', cause.message);
end
end

function writeReadme(figureRoot, index)
fid = fopen(fullfile(figureRoot, 'README.md'), 'w', 'n', 'UTF-8');
if fid < 0
    error('triofig:WriteFailure', 'Cannot write figure README.');
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '# %s\n\nLatest successful: `%s`  \nSelected: `%s`\n\n', ...
    index.figureId, index.latest, index.selected);
fprintf(fid, 'Generation history is local unless explicitly tracked. A missing folder on another checkout means its history has not been shared.\n\n');
fprintf(fid, '| Generation | Operation | Status | Storage here | Preview |\n| --- | --- | --- | --- | --- |\n');
for k = 1:numel(index.generations)
    item = index.generations{k};
    relative = ['generations/' item.id];
    exists = isfolder(fullfile(figureRoot, relative));
    preview = '-';
    if isfile(fullfile(figureRoot, relative, 'preview.pdf'))
        preview = ['[PDF](' relative '/preview.pdf)'];
    end
    storage = 'unavailable';
    if exists
        storage = 'present (Git tracking optional)';
    end
    fprintf(fid, '| `%s` | %s | %s | %s | %s |\n', ...
        item.id, item.operation, item.status, storage, preview);
end
fprintf(fid, '\nUse `preview_trio_figure(generationDirectory)` without raw data. Use `select_trio_figure(figureDirectory, generationId)` to export a version; selection is not scientific qualification.\n\n');
fprintf(fid, 'Include the selected PDF with `\\includegraphics[width=\\linewidth]{path/to/this/figure/selected/preview.pdf}`.\n\n');
fprintf(fid, 'To share a generation: `git add -f path/to/this/figure/generations/<id>` (omit build intermediates). Legacy imports are tracked by default.\n');
end
