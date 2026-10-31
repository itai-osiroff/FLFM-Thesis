function saveSession(path,root,sources,stacks,geometry,history,view)
%SAVESESSION Atomically save metadata and edits without source pixels.
if nargin<7, view=struct(); end
canonical=char(java.io.File(path).getCanonicalPath());
sourceRoles=fieldnames(sources);
for index=1:numel(sourceRoles)
 sourcePath=char(java.io.File(sources.(sourceRoles{index}).path).getCanonicalPath());
 if strcmpi(canonical,sourcePath), error('captureedit:SourceOverwrite','A session cannot overwrite an original source.'); end
end
[~,~,extension]=fileparts(path);
if ~strcmpi(extension,'.json'), error('captureedit:SessionExtension','Save sessions with a .json extension.'); end
record=struct('schemaVersion',2,'dataRoot',char(root),'sources',struct(), ...
 'stacks',stacks,'geometry',geometry,'history',history,'view',view);
roles=fieldnames(sources);
for k=1:numel(roles)
 role=roles{k}; s=sources.(role);
 record.sources.(role)=struct('relativePath',s.relativePath,'hash',s.hash, ...
 'variable',s.variable,'class',class(s.image),'size',size(s.image), ...
 'range',s.range,'displayRange',s.displayRange);
end
folder=fileparts(path); if isempty(folder), folder=pwd; end
if ~isfolder(folder), error('captureedit:SessionDirectory','Session directory does not exist.'); end
stage=[tempname(folder) '.json']; cleanup=onCleanup(@() removeStage(stage));
fid=fopen(stage,'w','n','UTF-8'); if fid<0, error('captureedit:SessionWrite','Cannot write session.'); end
try
 count=fprintf(fid,'%s',jsonencode(record)); status=fclose(fid);
catch cause
 fclose(fid); rethrow(cause);
end
if count<=0 || status~=0, error('captureedit:SessionWrite','Session write failed.'); end
jsondecode(fileread(stage));
[ok,msg]=movefile(stage,path,'f'); if ~ok, error('captureedit:SessionWrite','%s',msg); end
end
function removeStage(path)
if isfile(path), delete(path); end
end
