function records = fileInventory(directory)
%FILEINVENTORY Hash retained artifacts; exclude mutable manifest/build files.
entries = dir(fullfile(directory, '**', '*'));
records = repmat(struct('path', '', 'sha256', ''), 0, 1);
for k = 1:numel(entries)
    if entries(k).isdir
        continue;
    end
    path = fullfile(entries(k).folder, entries(k).name);
    relative = strrep(path(numel(directory) + 2:end), '\', '/');
    if startsWith(relative, 'build/') || strcmp(relative, 'metadata/generation-manifest.json')
        continue;
    end
    records(end + 1) = struct('path', relative, 'sha256', triofig.fileSha256(path)); %#ok<AGROW>
end
end
