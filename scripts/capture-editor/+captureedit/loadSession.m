function [sources,stacks,geometry,history,view] = loadSession(path,root)
%LOADSESSION Verify immutable source identity before restoring edits.
r=jsondecode(fileread(path));
if ~isfield(r,'schemaVersion') || r.schemaVersion~=1
 error('captureedit:SessionVersion','Unsupported session schema.');
end
if nargin<2 || isempty(root), root=r.dataRoot; end
paths=struct(); roles=fieldnames(r.sources);
for k=1:numel(roles)
 role=roles{k}; s=r.sources.(role); candidate=fullfile(root,s.relativePath);
 if ~isfile(candidate) || ~strcmp(captureedit.sha256(candidate),s.hash)
  error('captureedit:SourceChanged','Source is missing or changed: %s',candidate);
 end
 canonical=char(java.io.File(candidate).getCanonicalPath());
 prefix=[char(java.io.File(root).getCanonicalPath()) filesep];
 if ~startsWith(lower(canonical),lower(prefix)), error('captureedit:SessionPath','Source path escapes dataRoot.'); end
 paths.(role)=candidate;
end
sources=captureedit.loadSources(root,paths);
for k=1:numel(roles)
 role=roles{k}; saved=r.sources.(role); actual=sources.(role);
 if ~strcmp(class(actual.image),saved.class) || ~isequal(size(actual.image),saved.size(:).') || ~strcmp(actual.variable,saved.variable)
  error('captureedit:SourceChanged','Source shape, class, or variable differs.');
 end
 validateattributes(saved.range,{'numeric'},{'finite','numel',2});
 validateattributes(saved.displayRange,{'numeric'},{'finite','numel',2});
 if saved.range(2)<=saved.range(1) || saved.displayRange(2)<=saved.displayRange(1)
  error('captureedit:SessionRange','Saved intensity ranges must increase.');
 end
 sources.(role).range=saved.range(:).'; sources.(role).displayRange=saved.displayRange(:).';
end
state=captureedit.normalizeStacks(struct('stacks',r.stacks,'geometry',r.geometry));
stacks=state.stacks; geometry=state.geometry; history=r.history; view=r.view;
if isfield(view,'displayRanges')
 names=fieldnames(view.displayRanges);
 for k=1:numel(names), name=names{k}; view.displayRanges.(name)=view.displayRanges.(name)(:).'; end
end
if ~isempty(geometry)
 images=struct(); names=fieldnames(sources);
 for k=1:numel(names), images.(names{k})=sources.(names{k}).image; end
 if ~isequal(geometry.referenceSize(:).',size(images.global)), error('captureedit:SessionGeometry','Saved reference grid differs.'); end
 captureedit.comparisonPanels(images,geometry);
end
for key={'undo','redo'}
 name=key{1}; entries=history.(name);
 if isempty(entries), entries={}; elseif ischar(entries), entries={entries}; elseif isstring(entries), entries=cellstr(entries); end
 history.(name)=entries;
end
end
