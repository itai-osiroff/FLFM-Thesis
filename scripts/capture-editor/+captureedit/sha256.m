function hash = sha256(path)
%SHA256 Stream a source file without retaining its contents in memory.
fid=fopen(path,'rb');
if fid<0, error('captureedit:MissingSource','Cannot read %s.',path); end
cleanup=onCleanup(@()fclose(fid));
digest=java.security.MessageDigest.getInstance('SHA-256');
while ~feof(fid)
    bytes=fread(fid,1024*1024,'*uint8'); digest.update(bytes);
end
hash=lower(reshape(dec2hex(typecast(digest.digest(),'uint8'),2).',1,[]));
end
