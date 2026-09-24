function canonicalizePng(path)
%CANONICALIZEPNG Remove MATLAB's wall-clock tIME chunk from a generated PNG.

input = fopen(path, 'r');
if input == -1
    error('triofig:ReadFailure', 'Could not read generated PNG %s.', path);
end
inputCleaner = onCleanup(@() fclose(input));
bytes = fread(input, Inf, '*uint8').';
clear inputCleaner
signature = uint8([137, 80, 78, 71, 13, 10, 26, 10]);
if numel(bytes) < numel(signature) || ~isequal(bytes(1:8), signature)
    error('triofig:InvalidPng', 'Generated asset is not a PNG: %s', path);
end
canonical = bytes(1:8);
position = 9;
while position <= numel(bytes)
    if position + 11 > numel(bytes)
        error('triofig:InvalidPng', 'PNG chunk is truncated: %s', path);
    end
    chunkLength = double(bytes(position)) * 256^3 + ...
        double(bytes(position + 1)) * 256^2 + ...
        double(bytes(position + 2)) * 256 + double(bytes(position + 3));
    chunkEnd = position + 12 + chunkLength - 1;
    if chunkEnd > numel(bytes)
        error('triofig:InvalidPng', 'PNG chunk exceeds file length: %s', path);
    end
    chunkType = bytes(position + 4:position + 7);
    if ~isequal(chunkType, uint8('tIME'))
        canonical = [canonical, bytes(position:chunkEnd)]; %#ok<AGROW>
    end
    position = chunkEnd + 1;
end
output = fopen(path, 'w');
if output == -1
    error('triofig:WriteFailure', 'Could not rewrite generated PNG %s.', path);
end
outputCleaner = onCleanup(@() fclose(output));
fwrite(output, canonical, 'uint8');
clear outputCleaner
end
