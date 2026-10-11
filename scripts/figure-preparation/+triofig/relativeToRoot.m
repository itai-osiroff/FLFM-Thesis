function relative = relativeToRoot(root, path)
%RELATIVETOROOT Canonical relative path for an input beneath the data root.
root = char(java.io.File(root).getCanonicalPath());
path = char(java.io.File(path).getCanonicalPath());
prefix = [root filesep];
if strcmp(root, path)
    relative = '.';
    return;
end
if ~startsWith(path, prefix, 'IgnoreCase', ispc)
    error('triofig:InvalidInput', 'Selected input is outside the data root: %s', path);
end
relative = char(strrep(extractAfter(string(path), strlength(string(prefix))), char(92), '/'));
end
