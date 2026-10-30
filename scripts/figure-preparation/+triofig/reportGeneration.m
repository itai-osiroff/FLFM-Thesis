function reportGeneration(result)
if strcmp(result.status, 'complete')
    fprintf('Trio generation %s\nPreview: %s\n', result.generationId, result.previewPath);
else
    warning('triofig:IncompleteGeneration', ...
        'Generation %s is incomplete: %s\nRetained at: %s', ...
        result.generationId, result.error.message, result.generationDirectory);
end
end
