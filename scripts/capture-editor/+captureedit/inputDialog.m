function [paths,accepted]=inputDialog(root)
%INPUTDIALOG Stage and validate all roles in one place before replacement.
paths=struct(); accepted=false; roles={'thorcam','validation','global','local'};
fig=uifigure('Name','Choose acquisition inputs','Position',[180 180 850 490]);
clean=onCleanup(@() closeIfValid(fig));
grid=uigridlayout(fig,[7 1],'RowHeight',{54,60,60,60,60,45,40});
uilabel(grid,'Text','Choose files for the roles you have. Empty rows are skipped. A MAT workspace may supply both reconstruction roles.','WordWrap','on');
fields=gobjects(1,4); status=uilabel(grid,'Text',''); status.Layout.Row=6;
try, discovery=triofig.discoverInputs(root,''); catch, discovery=[]; end
for k=1:4
 row=uigridlayout(grid,[1 4],'ColumnWidth',{85,'1x',85,65}); row.Layout.Row=k+1;
 uilabel(row,'Text',roles{k}); fields(k)=uieditfield(row,'text','Placeholder','Skip this role');
 uibutton(row,'Text','Browse…','ButtonPushedFcn',@(~,~) browse(k));
 uibutton(row,'Text','Clear','ButtonPushedFcn',@(~,~) clearRole(k));
end
footer=uigridlayout(grid,[1 3],'ColumnWidth',{'1x',100,100}); footer.Layout.Row=7;
uilabel(footer,'Text','Originals stay unchanged.');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
uibutton(footer,'Text','Load','ButtonPushedFcn',@(~,~) finish(true));
fig.CloseRequestFcn=@(~,~) finish(false); uiwait(fig);
 function browse(index)
  role=roles{index}; kind=role; if ismember(role,{'global','local'}), kind='workspace'; end
  if ~isempty(discovery) && isfield(discovery,kind)
   candidates=discovery.(kind).candidates;
   if ~isempty(candidates)
    labels=[candidates(:);{'Browse for another file…'}];
    [which,ok]=listdlg('ListString',labels,'SelectionMode','single','ListSize',[650 240],'PromptString',['Suggested ' role ' files — confirm a selection']);
    if ~ok, return; end
    if which<=numel(candidates), fields(index).Value=candidates{which}; return; end
   end
  end
  [f,p]=uigetfile({'*.tif;*.tiff;*.png;*.mat','Grayscale TIFF, PNG or MAT'},['Choose ' role],root);
  if isequal(f,0), return; end
  fields(index).Value=fullfile(p,f);
 end
 function clearRole(index), fields(index).Value=''; end
 function finish(ok)
  if ok
   candidate=struct();
   for n=1:4, if ~isempty(strtrim(fields(n).Value)), candidate.(roles{n})=strtrim(fields(n).Value); end, end
   if isempty(fieldnames(candidate)), status.Text='Choose at least one image.'; return; end
   try
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
