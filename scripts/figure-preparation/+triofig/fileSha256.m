function checksum = fileSha256(path)
%FILESHA256 Return a lowercase SHA-256 digest for a file.

digest = java.security.MessageDigest.getInstance('SHA-256');
input = java.io.FileInputStream(java.io.File(path));
stream = java.security.DigestInputStream(input, digest);
cleaner = onCleanup(@() stream.close());
buffer = zeros(1, 65536, 'int8');
while stream.read(buffer, 0, numel(buffer)) ~= -1
end
bytes = typecast(digest.digest(), 'uint8');
clear cleaner
checksum = lower(reshape(dec2hex(bytes, 2).', 1, []));
end
