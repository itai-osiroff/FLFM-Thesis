function saveSetupDraft(path, draft)
%SAVESETUPDRAFT Replace a checkpoint only after successful serialization.
draft.updatedAt = char(datetime('now', 'TimeZone', 'UTC', ...
    'Format', "yyyy-MM-dd'T'HH:mm:ss'Z'"));
try
    jsonencode(draft); % Validate serialization before opening a file.
    % writeRecipe uses a sibling temporary file with cleanup on failure.
    triofig.writeRecipe(path, draft);
catch cause
    error('triofig:DraftWriteFailure', 'Could not save the setup checkpoint: %s', cause.message);
end
end
