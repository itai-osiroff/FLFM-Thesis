function [approved, evidence] = legacyComparisonApproval(recipePath, assets, old)
%LEGACYCOMPARISONAPPROVAL Link historical gate results to imported bytes.
approved = false;
evidence = struct('approved', false, 'recipeMatch', 'none', ...
    'actualRecipeSha256', triofig.fileSha256(recipePath), ...
    'recordedRecipeSha256', '', 'assetsMatch', false);
if ~isfield(old, 'recipe') || ~isfield(old.recipe, 'sha256') || ...
        ~isfield(old, 'outputs') || numel(old.outputs) ~= 9 || ...
        ~isfield(old, 'candidateComparison') || numel(old.candidateComparison) ~= 9 || ...
        ~all([old.candidateComparison.samePixels])
    return;
end
evidence.recordedRecipeSha256 = old.recipe.sha256;
if strcmp(evidence.actualRecipeSha256, old.recipe.sha256)
    evidence.recipeMatch = 'exact';
else
    % Git historically converted this JSON between LF and CRLF. Accept only
    % that byte transformation, and record it explicitly rather than silently
    % trusting a historical comparison after arbitrary recipe edits.
    fid = fopen(recipePath, 'rb');
    cleanup = onCleanup(@() fclose(fid));
    bytes = fread(fid, Inf, '*uint8');
    clear cleanup
    crlf = bytes == 13 & [bytes(2:end) == 10; false];
    bytes = bytes(~crlf);
    digest = java.security.MessageDigest.getInstance('SHA-256');
    digest.update(typecast(bytes, 'int8'));
    hash = lower(reshape(dec2hex(typecast(digest.digest(), 'uint8'), 2).', 1, []));
    if strcmp(hash, old.recipe.sha256)
        evidence.recipeMatch = 'LF-normalized (historical Git line endings)';
    else
        return;
    end
end
expected = sort(["thorcam_downsampled.png", "global_average.png", "local_average.png", ...
    "thorcam_zoom_1.png", "thorcam_zoom_2.png", "global_zoom_1.png", ...
    "global_zoom_2.png", "local_zoom_1.png", "local_zoom_2.png"]);
if ~isequal(sort(lower(string({old.outputs.filename}))), expected)
    return;
end
for k = 1:numel(old.outputs)
    item = old.outputs(k);
    file = fullfile(assets, item.filename);
    if ~isfile(file) || ~strcmp(triofig.fileSha256(file), item.sha256)
        return;
    end
end
evidence.assetsMatch = true;
evidence.approved = true;
approved = true;
end
