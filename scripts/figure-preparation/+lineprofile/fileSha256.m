function digest = fileSha256(path)
%FILESHA256 Lower-case hex SHA-256 of a file, read in chunks.
digestor = java.security.MessageDigest.getInstance('SHA-256');
stream = java.io.FileInputStream(java.io.File(char(path)));
cleanup = onCleanup(@() stream.close());
buffer = zeros(1, 4 * 1024 * 1024, 'int8');
while true
    count = stream.read(buffer);
    if count <= 0
        break
    end
    digestor.update(buffer, 0, count);
end
bytes = typecast(digestor.digest(), 'uint8');
digest = lower(reshape(dec2hex(bytes, 2).', 1, []));
end
