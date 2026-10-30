function writeJsonFile(path, value)
%WRITEJSONFILE Replace a JSON document via a sibling temporary file.
temporary = [path '.' char(java.util.UUID.randomUUID) '.tmp'];
fid = fopen(temporary, 'w', 'n', 'UTF-8');
if fid < 0
    error('triofig:WriteFailure', 'Cannot write %s.', temporary);
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '%s\n', jsonencode(value, 'PrettyPrint', true));
clear cleanup
[ok, message] = movefile(temporary, path, 'f');
if ~ok
    error('triofig:WriteFailure', 'Cannot replace %s: %s', path, message);
end
end
