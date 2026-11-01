function [destinations,mode]=copyDialog(names)
%COPYDIALOG Choose independent copy destinations and mode in one confirmation.
destinations={}; mode=''; fig=uifigure('Name','Copy filters','Position',[250 250 390 400]);
clean=onCleanup(@() closeIfValid(fig)); layout=uigridlayout(fig,[5 1],'RowHeight',{45,'1x',32,30,35});
uilabel(layout,'Text','Select one or more destination images. Copies are independent.','WordWrap','on');
list=uilistbox(layout,'Items',names,'Multiselect','on','Value',names(1));
choice=uidropdown(layout,'Items',{'Append','Replace'});
uilabel(layout,'Text','Replace removes the destination filters; Undo restores them.','FontSize',11);
buttons=uigridlayout(layout,[1 2]);
uibutton(buttons,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
uibutton(buttons,'Text','Copy','ButtonPushedFcn',@(~,~) finish(true));
fig.CloseRequestFcn=@(~,~) finish(false); uiwait(fig);
 function finish(ok)
  if ok, destinations=list.Value; if ischar(destinations), destinations={destinations}; end, mode=choice.Value; end
  uiresume(fig); delete(fig);
 end
end
function closeIfValid(fig)
if isgraphics(fig), delete(fig); end
end
