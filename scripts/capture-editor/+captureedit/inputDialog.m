function [paths,accepted]=inputDialog(root)
%INPUTDIALOG Stage and validate all roles in one place before replacement.
paths=struct(); accepted=false; roles={'thorcam','validation','workspace','localWorkspace'};
fig=uifigure('Name','Choose acquisition inputs','Position',[180 180 850 510]);
clean=onCleanup(@() closeIfValid(fig));
grid=uigridlayout(fig,[8 1],'RowHeight',{48,34,60,60,60,60,42,40});
uilabel(grid,'Text','Choose files for the roles you have. One workspace supplies both reconstruction averages by default.','WordWrap','on');
separate=uicheckbox(grid,'Text','Use separate workspaces for global and local averages', ...
    'Value',false,'ValueChangedFcn',@(~,~) updateWorkspaceRows()); separate.Layout.Row=2;
fields=gobjects(1,4); workspaceLabel=[]; status=uilabel(grid,'Text',''); status.Layout.Row=7;
try, discovery=triofig.discoverInputs(root,''); catch, discovery=[]; end
for k=1:4
 row=uigridlayout(grid,[1 4],'ColumnWidth',{120,'1x',85,65}); row.Layout.Row=k+2;
 label=roles{k};
 if strcmp(label,'workspace'), label='shared workspace'; elseif strcmp(label,'localWorkspace'), label='local workspace'; end
 labelControl=uilabel(row,'Text',label);
 if k==3, workspaceLabel=labelControl; end
 fields(k)=uieditfield(row,'text','Placeholder','Skip this role');
 uibutton(row,'Text','Browse…','ButtonPushedFcn',@(~,~) browse(k));
 uibutton(row,'Text','Clear','ButtonPushedFcn',@(~,~) clearRole(k));
end
footer=uigridlayout(grid,[1 3],'ColumnWidth',{'1x',100,100}); footer.Layout.Row=8;
uilabel(footer,'Text','Originals stay unchanged.');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
uibutton(footer,'Text','Load','ButtonPushedFcn',@(~,~) finish(true));
fig.CloseRequestFcn=@(~,~) finish(false);
updateWorkspaceRows();
uiwait(fig);
 function browse(index)
  role=roles{index}; kind=role;
  if ismember(role,{'workspace','localWorkspace'}), kind='workspace'; end
  if ~isempty(discovery) && isfield(discovery,kind)
   candidates=discovery.(kind).candidates;
   if ~isempty(candidates)
    labels=[candidates(:);{'Browse for another file…'}];
    [which,ok]=listdlg('ListString',labels,'SelectionMode','single','ListSize',[650 240],'PromptString',['Suggested ' role ' files — confirm a selection']);
    if ~ok, return; end
    if which<=numel(candidates)
     fields(index).Value=candidates{which};
     if index==3 && ~separate.Value, fields(4).Value=fields(3).Value; end
     return;
    end
   end
  end
  [f,p]=uigetfile({'*.tif;*.tiff;*.png;*.mat','Grayscale TIFF, PNG or MAT'},['Choose ' role],root);
  if isequal(f,0), return; end
  fields(index).Value=fullfile(p,f);
  if index==3 && ~separate.Value, fields(4).Value=fields(3).Value; end
 end
 function clearRole(index)
  fields(index).Value='';
  if index==3 && ~separate.Value, fields(4).Value=''; end
 end
 function updateWorkspaceRows()
  if ~isgraphics(fields(4)), return; end
  if separate.Value
   fields(4).Enable='on'; workspaceLabel.Text='global workspace';
  else
   fields(4).Enable='off'; fields(4).Value=fields(3).Value; workspaceLabel.Text='shared workspace';
  end
 end
 function finish(ok)
  if ok
   candidate=struct();
   for n=1:4, if ~isempty(strtrim(fields(n).Value)), candidate.(roles{n})=strtrim(fields(n).Value); end, end
   if isempty(fieldnames(candidate)), status.Text='Choose at least one image.'; return; end
   try
    averagePaths=captureedit.workspaceInputPaths(candidate,separate.Value);
    candidate=rmfield(candidate,intersect(fieldnames(candidate),{'workspace','localWorkspace'}));
    averageNames=fieldnames(averagePaths);
    for n=1:numel(averageNames), candidate.(averageNames{n})=averagePaths.(averageNames{n}); end
    status.Text='Validating images…'; drawnow; captureedit.loadSources(root,candidate);
   catch cause, status.Text=cause.message; return;
   end
   paths=candidate; accepted=true;
  end
  uiresume(fig); delete(fig);
 end
end
function closeIfValid(fig)
if isgraphics(fig), delete(fig); end
end
