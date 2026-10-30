function result = generationResult(figureRoot, directory, manifest)
manifestPath = fullfile(directory, 'metadata', 'generation-manifest.json');
preview = fullfile(directory, 'preview.pdf');
if ~isfile(preview)
    preview = '';
end
published = '';
if manifest.generation.published && strcmp(manifest.generation.status, 'complete') && manifest.generation.comparisonApproved
    published = manifestPath;
end
result = struct('generationId', manifest.generation.id, ...
    'generationDirectory', directory, 'outputDirectory', figureRoot, ...
    'stagingDirectory', directory, 'manifestPath', manifestPath, ...
    'publishedManifestPath', published, 'previewPath', preview, ...
    'status', manifest.generation.status, 'error', manifest.generation.error);
end
