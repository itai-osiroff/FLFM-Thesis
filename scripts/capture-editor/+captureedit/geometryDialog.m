function [geometry,accepted] = geometryDialog(sources,geometry)
%GEOMETRYDIALOG Stage original-only geometry until Apply.
if nargin<2, geometry=[]; end
geometry=captureedit.resolveGeometry(sources,geometry,false);
original=geometry; accepted=false; images=struct(); names=fieldnames(sources);
for k=1:numel(names), images.(names{k})=sources.(names{k}).image; end
roles=intersect({'thorcam','validation'},names,'stable');
fig=uifigure('Name','Comparison geometry','Position',[80 80 1200 820]); cleanup=onCleanup(@() closeFigure(fig));
grid=uigridlayout(fig,[5 1],'RowHeight',{140,45,'1x',60,45});
controls=uigridlayout(grid,[3 6]);
uilabel(controls,'Text','Camera');
items=roles; if isempty(items), items={'No cameras'}; end
camera=uidropdown(controls,'Items',items,'ValueChangedFcn',@(~,~) selectCamera());
uilabel(controls,'Text','Preparation rotation'); rotation=number(controls,0);
uilabel(controls,'Text','Scale camera to global'); scale=number(controls,1); scale.Limits=[eps Inf];
flip=uicheckbox(controls,'Text','Flip vertically','ValueChangedFcn',@(~,~) refresh(false,false,true));
flip.Layout.Row=2; flip.Layout.Column=[1 2];
uilabel(controls,'Text','Alignment rotation'); angle=number(controls,0);
uilabel(controls,'Text','X columns'); tx=number(controls,0); tx.Tag='capture-translation-x';
uilabel(controls,'Text','Y rows'); ty=number(controls,0); ty.Tag='capture-translation-y';
uibutton(controls,'Text','Left 1 px','ButtonPushedFcn',@(~,~) nudge(-1,0));
uibutton(controls,'Text','Right 1 px','ButtonPushedFcn',@(~,~) nudge(1,0));
uibutton(controls,'Text','Up 1 px','ButtonPushedFcn',@(~,~) nudge(0,-1));
uibutton(controls,'Text','Down 1 px','ButtonPushedFcn',@(~,~) nudge(0,1));
buttons=uigridlayout(grid,[1 7],'ColumnWidth',{170,130,140,130,65,'1x',145});
estimate=uibutton(buttons,'Text','Re-estimate alignment','ButtonPushedFcn',@(~,~) refresh(true,true));
calibration=uibutton(buttons,'Text','Match points...','ButtonPushedFcn',@(~,~) calibrate());
uibutton(buttons,'Text','Use common field','ButtonPushedFcn',@(~,~) refresh(false,true));
uibutton(buttons,'Text','Draw crop','ButtonPushedFcn',@(~,~) drawCrop());
uilabel(buttons,'Text','Opacity'); opacity=uislider(buttons,'Limits',[0 1],'Value',.5,'ValueChangedFcn',@(~,~) refresh(false,false));
checker=uicheckbox(buttons,'Text','Checkerboard','ValueChangedFcn',@(~,~) refresh(false,false));
plots=uigridlayout(grid,[1 3]); ax=gobjects(1,3); for k=1:3, ax(k)=uiaxes(plots); end
cropGrid=uigridlayout(grid,[1 8]); fields=gobjects(1,4); c=geometry.registration.crop;
labels={'Row','Column','Height','Width'}; vals=[c.rowStartOneBased c.columnStartOneBased c.height c.width];
for k=1:4
 uilabel(cropGrid,'Text',labels{k}); fields(k)=uieditfield(cropGrid,'numeric','Value',vals(k),'Limits',[1 Inf],'RoundFractionalValues','on','ValueChangedFcn',@(~,~) refresh(false,false));
end
footer=uigridlayout(grid,[1 3],'ColumnWidth',{'1x',100,100}); note=uilabel(footer,'Text','Viewing only','WordWrap','on');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false)); apply=uibutton(footer,'Text','Apply','ButtonPushedFcn',@(~,~) finish(true));
if isempty(roles)
 disabled={camera,rotation,flip,scale,angle,tx,ty,estimate,calibration};
 for k=1:numel(disabled), disabled{k}.Enable='off'; end
else, selectCamera(); end
fig.CloseRequestFcn=@(~,~) finish(false); refresh(false,false); fig.Tag='capture-geometry-ready'; uiwait(fig);
if isgraphics(fig), delete(fig); end
if ~accepted, geometry=original; end
 function f=number(parent,value)
  f=uieditfield(parent,'numeric','Value',value,'ValueChangedFcn',@(~,~) refresh(false,false,true));
 end
 function selectCamera()
  if isempty(roles), return; end
  s=geometry.cameraPreparation.(camera.Value); tr=geometry.registration.savedTransforms;
  rotation.Value=s.rotationDegrees; flip.Value=s.flipVertical; scale.Value=s.downsampleFactor;
  angle.Value=tr.([camera.Value 'RotationDegrees']); shift=tr.([camera.Value 'TranslationXY']); tx.Value=shift(1); ty.Value=shift(2);
  refresh(false,false);
 end
 function candidate=readControls()
  candidate=geometry;
  if ~isempty(roles)
   name=camera.Value; candidate.cameraPreparation.(name)=struct('rotationDegrees',rotation.Value,'flipVertical',flip.Value,'downsampleFactor',scale.Value);
   candidate.registration.savedTransforms.([name 'RotationDegrees'])=angle.Value;
   candidate.registration.savedTransforms.([name 'TranslationXY'])=[tx.Value ty.Value];
  end
  if ~isempty(roles)
   old=geometry.cameraPreparation.(camera.Value); current=candidate.cameraPreparation.(camera.Value);
   if old.rotationDegrees~=current.rotationDegrees || old.flipVertical~=current.flipVertical
    candidate.calibration.(camera.Value).pointPairs=struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2));
   end
  end
  candidate.registration.transformSource='saved'; candidate.registration.requireExpectedCrop=false; candidate.registration.cropMode='saved';
  candidate.registration.crop=struct('rowStartOneBased',fields(1).Value,'columnStartOneBased',fields(2).Value,'height',fields(3).Value,'width',fields(4).Value);
 end
 function nudge(x,y)
  if isempty(roles), return; end
  tx.Value=tx.Value+x; ty.Value=ty.Value+y; refresh(false,false,true);
 end
 function refresh(estimateAlignment,common,repairTransformCrop)
  if nargin<3, repairTransformCrop=false; end
  try
   candidate=readControls(); if common, candidate.registration.cropMode='intersection'; end
   if estimateAlignment, note.Text='Estimating from originals...'; drawnow; end
   repairTransformCrop=repairTransformCrop && isequaln(candidate.registration.crop,geometry.registration.crop);
   try
    candidate=captureedit.resolveGeometry(sources,candidate,estimateAlignment);
   catch cause
    if repairTransformCrop && strcmp(cause.identifier,'captureedit:InvalidCrop')
     candidate.registration.cropMode='intersection'; candidate=captureedit.resolveGeometry(sources,candidate,false);
    else, rethrow(cause); end
   end
   full=candidate; full.registration.crop=[];
   [p,mask]=captureedit.comparisonPanels(images,full); a=mat2gray(p.global);
   imshow(a,'Parent',ax(1)); title(ax(1),'Global reference - original');
   preview=a;
   if ~isempty(roles)
    b=mat2gray(p.(camera.Value));
    if checker.Value
     [xx,yy]=meshgrid(1:size(a,2),1:size(a,1)); choose=mod(floor((xx-1)/16)+floor((yy-1)/16),2)==0; preview(choose)=b(choose);
    else, preview=(1-opacity.Value)*a+opacity.Value*b; end
   end
   imshow(preview,'Parent',ax(2)); title(ax(2),'Original-only alignment overlay');
   imshow(mask,'Parent',ax(3)); title(ax(3),'Common field - draw crop here'); c=candidate.registration.crop;
   hold(ax(3),'on'); rectangle(ax(3),'Position',[c.columnStartOneBased-.5 c.rowStartOneBased-.5 c.width c.height],'EdgeColor',[0 .5 1],'LineWidth',2); hold(ax(3),'off');
   geometry=candidate; setCrop(c);
   if estimateAlignment && ~isempty(roles)
    tr=geometry.registration.savedTransforms; angle.Value=tr.([camera.Value 'RotationDegrees']); shift=tr.([camera.Value 'TranslationXY']); tx.Value=shift(1); ty.Value=shift(2);
   end
   pairs=0; if ~isempty(roles), pairs=size(geometry.calibration.(camera.Value).pointPairs.referenceXY,1); end
   note.Text=[sprintf('%d saved pairs. Preparation rotation/flip changes clear pairs. ',pairs) 'Viewing only. Common field: ' strjoin(candidate.participants,', ') '. X columns; Y rows.']; apply.Enable='on';
  catch cause, note.Text=[cause.message ' Use common field to reset the crop.']; apply.Enable='off'; end
 end
 function setCrop(c)
  values=[c.rowStartOneBased c.columnStartOneBased c.height c.width]; for n=1:4, fields(n).Value=values(n); end
 end
 function drawCrop()
  try
   roi=drawrectangle(ax(3)); wait(roi); p=roi.Position; delete(roi);
   setCrop(struct('rowStartOneBased',max(1,round(p(2)+.5)),'columnStartOneBased',max(1,round(p(1)+.5)),'height',max(1,round(p(4))),'width',max(1,round(p(3))))); refresh(false,false);
  catch cause, note.Text=['Crop cancelled: ' cause.message]; end
 end
 function calibrate()
  try
   candidate=readControls(); s=candidate.cameraPreparation.(camera.Value); moving=imrotate(double(sources.(camera.Value).image),s.rotationDegrees); if s.flipVertical, moving=flipud(moving); end
   [points,factor,ok]=triofig.setupCalibrationDialog(sources.global.image,moving,candidate.calibration.(camera.Value).pointPairs,camera.Value);
   if ~ok, return; end
   candidate.calibration.(camera.Value).pointPairs=points;
   candidate.cameraPreparation.(camera.Value).downsampleFactor=factor;
   candidate.registration.cropMode='intersection';
   candidate=captureedit.resolveGeometry(sources,candidate,false);
   geometry=candidate; scale.Value=factor; setCrop(candidate.registration.crop); refresh(false,false);
  catch cause, note.Text=['Calibration cancelled: ' cause.message]; end
 end
 function finish(ok)
  if ok && strcmp(apply.Enable,'off'), return; end
  accepted=ok; uiresume(fig); if isgraphics(fig), delete(fig); end
 end
end
function closeFigure(fig)
if isgraphics(fig), delete(fig); end
end
