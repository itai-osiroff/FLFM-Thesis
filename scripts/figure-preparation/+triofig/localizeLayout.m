function localizeLayout(source, destination)
%LOCALIZELAYOUT Keep layout geometry but resolve images inside the bundle.
content = fileread(source);
content = regexprep(content, '(\\TrioComparisonFigure\s*\{)[^}]*\}', '$1../assets}');
fid = fopen(destination, 'w');
if fid < 0
    error('triofig:WriteFailure', 'Cannot write layout %s.', destination);
end
cleanup = onCleanup(@() fclose(fid)); %#ok<NASGU>
fprintf(fid, '%s', content);
end
