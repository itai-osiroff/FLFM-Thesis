function paths = workspaceInputPaths(candidate, separate)
%WORKSPACEINPUTPATHS Map the workspace picker(s) to average roles.
paths = struct();
if separate
    if isfield(candidate, 'workspace') && ~isempty(candidate.workspace)
        paths.global = candidate.workspace;
    end
    if isfield(candidate, 'localWorkspace') && ~isempty(candidate.localWorkspace)
        paths.local = candidate.localWorkspace;
    end
elseif isfield(candidate, 'workspace') && ~isempty(candidate.workspace)
    paths.global = candidate.workspace;
    paths.local = candidate.workspace;
end
end
