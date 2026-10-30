function record = compilePreview(directory, compiler)
%COMPILEPREVIEW Run a compiler directly, without shell command interpolation.
latex = fullfile(directory, 'latex');
build = fullfile(directory, 'build');
source = fullfile(latex, 'preview.tex');
fid = fopen(source, 'w');
if fid < 0
    error('triofig:WriteFailure', 'Cannot write preview wrapper.');
end
cleanup = onCleanup(@() fclose(fid));
fprintf(fid, '\\documentclass[border=2pt]{standalone}\n');
fprintf(fid, '\\usepackage{graphicx}\n\\usepackage{tikz}\n\\usetikzlibrary{calc,positioning}\n');
fprintf(fid, '\\input{trio-comparison-template}\n\\begin{document}\n\\input{trio-layout}\n\\end{document}\n');
clear cleanup
record = struct('executable', char(compiler), 'version', '', 'status', 'failed', ...
    'exitCode', [], 'log', 'build/compiler.log', 'error', '');
try
    args = {char(compiler), '-interaction=nonstopmode', '-halt-on-error', ...
        '-no-shell-escape', '-output-directory', build, 'preview.tex'};
    builder = java.lang.ProcessBuilder(args);
    builder.directory(java.io.File(latex));
    builder.redirectErrorStream(true);
    builder.redirectOutput(java.io.File(fullfile(build, 'compiler.log')));
    builder.environment().put('MIKTEX_ENABLE_INSTALLER', '0');
    process = builder.start();
    finished = process.waitFor(120, java.util.concurrent.TimeUnit.SECONDS);
    if ~finished
        process.destroyForcibly();
        record.error = 'LaTeX exceeded the 120 second timeout.';
        return;
    end
    record.exitCode = process.exitValue();
    log = fileread(fullfile(build, 'compiler.log'));
    firstLine = regexp(log, '[^\r\n]+', 'match', 'once');
    record.version = firstLine;
    pdf = fullfile(build, 'preview.pdf');
    if record.exitCode == 0 && isfile(pdf)
        copyfile(pdf, fullfile(directory, 'preview.pdf'));
        record.status = 'complete';
    else
        record.error = 'LaTeX failed; inspect build/compiler.log.';
    end
catch cause
    record.error = cause.message;
    fid = fopen(fullfile(build, 'compiler.log'), 'a');
    if fid >= 0
        fprintf(fid, '%s\n', cause.message);
        fclose(fid);
    end
end
end
