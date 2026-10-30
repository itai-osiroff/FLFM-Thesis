function result = select_trio_figure(figureDirectory, generationId)
%SELECT_TRIO_FIGURE Explicitly export a complete generation for thesis use.
figureDirectory = char(java.io.File(char(figureDirectory)).getCanonicalPath());
generationId = char(generationId);
if isempty(regexp(generationId, '^[A-Za-z0-9_-]+$', 'once'))
    error('triofig:NotSelectable', 'Invalid generation ID.');
end
lock = triofig.lockFigure(figureDirectory); %#ok<NASGU>
source = fullfile(figureDirectory, 'generations', generationId);
path = fullfile(source, 'metadata', 'generation-manifest.json');
if ~isfile(path)
    error('triofig:NotSelectable', 'Generation is unavailable on this checkout.');
end
manifest = jsondecode(fileread(path));
if ~strcmp(manifest.generation.status, 'complete') || ...
        ~manifest.generation.comparisonApproved || ~isfile(fullfile(source, 'preview.pdf'))
    error('triofig:NotSelectable', 'Only complete, comparison-approved generations can be selected.');
end
% Validate the saved inventory before exporting potentially changed history.
triofig.verifyGeneration(source, manifest, 'triofig:NotSelectable');
temporary = fullfile(figureDirectory, ['.selection-' char(java.util.UUID.randomUUID)]);
mkdir(temporary);
cleanup = onCleanup(@() removeDirectory(temporary)); %#ok<NASGU>
for name = {'assets', 'metadata', 'latex'}
    copyfile(fullfile(source, name{1}), fullfile(temporary, name{1}));
end
copyfile(fullfile(source, 'preview.pdf'), temporary);
fid = fopen(fullfile(temporary, 'figure.tex'), 'w');
fprintf(fid, '%% Set \\TrioFigureDirectory to this selected directory from the thesis compile directory.\n');
fprintf(fid, '\\providecommand{\\TrioFigureDirectory}{.}\n');
fprintf(fid, '\\includegraphics[width=\\linewidth]{\\TrioFigureDirectory/preview.pdf}\n');
fclose(fid);
index = triofig.readFigureIndex(figureDirectory);
index.selected = generationId;
destination = fullfile(figureDirectory, 'selected');
backup = fullfile(figureDirectory, '.selected-backup');
if isfolder(backup)
    error('triofig:SelectionRecoveryRequired', ...
        'A previous selection was interrupted. Preserve and inspect .selected-backup before retrying.');
end
hadPrevious = isfolder(destination);
if hadPrevious
    movefile(destination, backup);
end
try
    movefile(temporary, destination);
    triofig.saveFigureIndex(figureDirectory, index);
catch cause
    removeDirectory(destination);
    if hadPrevious
        movefile(backup, destination);
    end
    rethrow(cause);
end
removeDirectory(backup);
result = struct('generationId', generationId, 'selectedDirectory', destination, ...
    'previewPath', fullfile(destination, 'preview.pdf'));
end

function removeDirectory(path)
if isfolder(path)
    rmdir(path, 's');
end
end
