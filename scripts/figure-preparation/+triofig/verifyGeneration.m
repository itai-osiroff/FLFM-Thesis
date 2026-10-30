function verifyGeneration(directory, manifest, errorId)
%VERIFYGENERATION Refuse changed snapshots before inheriting their provenance.
if ~isfield(manifest, 'files') || isempty(manifest.files)
    error(errorId, 'Generation has no completed artifact inventory.');
end
root = char(java.io.File(directory).getCanonicalPath());
for k = 1:numel(manifest.files)
    item = manifest.files(k);
    artifact = char(java.io.File(fullfile(directory, item.path)).getCanonicalPath());
    if ~startsWith([artifact filesep], [root filesep]) || ...
            ~isfile(artifact) || ~strcmp(triofig.fileSha256(artifact), item.sha256)
        error(errorId, 'Saved artifact has changed or is missing: %s', item.path);
    end
end
end
