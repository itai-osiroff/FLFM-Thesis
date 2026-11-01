function [points,accepted] = pointAlignmentDialog(reference,moving,points,role)
%POINTALIGNMENTDIALOG Pick complete, axis-checked pairs and review a full fit.
original=points; accepted=false; pending=[]; picking=false; fit=[];
if isempty(points.referenceXY), points=struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2)); end
fig=uifigure('Name',[role ' - Align from points'],'Position',[70 70 1200 760],'WindowStyle','modal');
cleanup=onCleanup(@() closeFigure(fig));
grid=uigridlayout(fig,[5 1],'RowHeight',{44,'1x',140,46,44},'Padding',[18 14 18 14]);
uilabel(grid,'Text','Match the same features in both images','FontSize',18,'FontWeight','bold');
plots=uigridlayout(grid,[1 3]); axesHandles=gobjects(1,3);
for n=1:3, axesHandles(n)=uiaxes(plots); end
pairGrid=uigridlayout(grid,[1 2],'ColumnWidth',{'1x',190});
list=uilistbox(pairGrid,'Items',{},'Tag','capture-point-pairs');
actions=uigridlayout(pairGrid,[3 1],'RowHeight',{32,32,'1x'},'Padding',0,'RowSpacing',5);
uibutton(actions,'Text','Add pair','Tag','capture-add-pair','ButtonPushedFcn',@(~,~) addPair());
remove=uibutton(actions,'Text','Remove selected pair','Tag','capture-remove-pair','ButtonPushedFcn',@(~,~) removePair());
uilabel(actions,'Text','Two pairs fit a transform. More pairs help assess consistency.','WordWrap','on');
note=uilabel(grid,'Text','','WordWrap','on');
footer=uigridlayout(grid,[1 3],'ColumnWidth',{'1x',100,150});
summary=uilabel(footer,'Text','','WordWrap','on');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
use=uibutton(footer,'Text','Use alignment','ButtonPushedFcn',@(~,~) finish(true),'Tag','capture-use-point-alignment');
fig.CloseRequestFcn=@(~,~) finish(false); fig.WindowKeyPressFcn=@keyPress;
draw(); fig.Tag='capture-point-ready'; uiwait(fig);
if isgraphics(fig), delete(fig); end
if ~accepted, points=original; end
 function draw()
  refImage=imshow(mat2gray(reference),'Parent',axesHandles(1)); title(axesHandles(1),'1. Global reference');
  movImage=imshow(mat2gray(moving),'Parent',axesHandles(2)); title(axesHandles(2),'2. Oriented camera - full resolution');
  refImage.Tag='capture-point-reference'; movImage.Tag='capture-point-moving';
  refImage.ButtonDownFcn=@(~,event) pick('reference',event.IntersectionPoint(1:2));
  movImage.ButtonDownFcn=@(~,event) pick('moving',event.IntersectionPoint(1:2));
  for j=1:size(points.referenceXY,1)
   marker(axesHandles(1),points.referenceXY(j,:),num2str(j));
   marker(axesHandles(2),points.movingXY(j,:),num2str(j));
  end
  if ~isempty(pending), marker(axesHandles(1),pending,'next'); end
  count=size(points.referenceXY,1); items=cell(1,count); fit=[];
  try
   fit=captureedit.fitPointAlignment(points,size(moving));
   scaled=imresize(imgaussfilt(double(moving),1/fit.scale/2),fit.scale,'bilinear');
   rotated=imrotate(scaled,fit.rotationDegrees,'bilinear','crop');
   shift=fit.translationXY; transform=affine2d([1 0 0;0 1 0;shift 1]);
   aligned=imwarp(rotated,transform,'OutputView',imref2d(size(reference)));
   overlay=cat(3,mat2gray(reference),mat2gray(aligned),zeros(size(reference)));
   imshow(overlay,'Parent',axesHandles(3)); title(axesHandles(3),'Fit preview - reference / camera');
   summary.Text=sprintf('%d pairs | RMS %.3f px | Max %.3f px',count,fit.rmsErrorPixels,fit.maxErrorPixels);
  catch cause
   imshow(mat2gray(reference),'Parent',axesHandles(3)); title(axesHandles(3),'Fit preview');
   summary.Text=sprintf('%d complete pairs',count);
   if count>=2, note.Text=cause.message; end
  end
  for j=1:count
   suffix=''; if ~isempty(fit), suffix=sprintf(' | error %.3f px',fit.residualPixels(j)); end
   items{j}=sprintf('%d: (%.1f, %.1f) to (%.1f, %.1f)%s',j,points.referenceXY(j,:),points.movingXY(j,:),suffix);
  end
  list.Items=items; list.ItemsData=1:count;
  if count>0, list.Value=count; remove.Enable='on'; else, remove.Enable='off'; end
  use.Enable=matlab.lang.OnOffSwitchState(~isempty(fit) && ~picking);
  if picking
   if isempty(pending), note.Text='Click a feature in the global reference. Escape cancels this pair.';
   else, note.Text='Click the same feature in the camera image. Escape cancels this pair.'; end
  elseif count<2
   note.Text='Add at least two complete pairs, spaced apart across the image.';
  elseif ~isempty(fit)
   note.Text=sprintf('Scale %.6g | Rotation %.3f degrees | Translation X %.3f, Y %.3f px. Review the overlay before accepting.',fit.scale,fit.rotationDegrees,fit.translationXY);
  end
 end
 function marker(ax,xy,label)
  hold(ax,'on');
  plot(ax,xy(1),xy(2),'+','Color',[1 .35 .15],'MarkerSize',10,'LineWidth',1.8,'HitTest','off','PickableParts','none');
  text(ax,xy(1)+2,xy(2),label,'Color',[1 .35 .15],'FontWeight','bold','HitTest','off','PickableParts','none');
  hold(ax,'off');
 end
 function addPair()
  picking=true; pending=[]; draw();
 end
 function pick(which,xy)
  if ~picking, return; end
  expected='reference'; shape=size(reference);
  if ~isempty(pending), expected='moving'; shape=size(moving); end
  if ~strcmp(which,expected)
   note.Text=['Choose the feature in the ' expected ' image.']; return;
  end
  if numel(xy)~=2 || any(~isfinite(xy)) || xy(1)<.5 || xy(2)<.5 || xy(1)>shape(2)+.5 || xy(2)>shape(1)+.5
   note.Text='Choose a point inside the image.'; return;
  end
  if isempty(pending), pending=xy;
  else
   points.referenceXY(end+1,:)=pending; points.movingXY(end+1,:)=xy;
   pending=[]; picking=false;
  end
  draw();
 end
 function removePair()
  if isempty(list.Value), return; end
  index=list.Value; points.referenceXY(index,:)=[]; points.movingXY(index,:)=[];
  pending=[]; picking=false; draw();
 end
 function keyPress(~,event)
  if strcmp(event.Key,'escape'), pending=[]; picking=false; draw(); end
 end
 function finish(ok)
  if ok && strcmp(use.Enable,'off'), return; end
  accepted=ok; uiresume(fig);
 end
end
function closeFigure(fig)
if isgraphics(fig), delete(fig); end
end
