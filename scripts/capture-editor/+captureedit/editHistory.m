function [history,state] = editHistory(action,history,before,after)
%EDITHISTORY JSON snapshots keep heterogeneous filter parameters safe.
state=[];
if strcmp(action,'new'), history=struct('undo',{{}},'redo',{{}}); return; end
if nargin<3, before=[]; end
switch action
 case 'commit'
  if isequaln(before,after), state=after; return; end
  history.undo{end+1}=jsonencode(before); history.redo={}; state=after;
 case 'undo'
  if isempty(history.undo), state=before; return; end
  history.redo{end+1}=jsonencode(before); state=captureedit.normalizeStacks(jsondecode(history.undo{end})); history.undo(end)=[];
 case 'redo'
  if isempty(history.redo), state=before; return; end
  history.undo{end+1}=jsonencode(before); state=captureedit.normalizeStacks(jsondecode(history.redo{end})); history.redo(end)=[];
 otherwise, error('captureedit:HistoryAction','Unknown history action.');
end
end
