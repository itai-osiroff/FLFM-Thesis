function [geometry,accepted] = geometryDialog(sources,geometry)
%GEOMETRYDIALOG Transactional Prepare / Match and align / Crop workspace.
if nargin<2, geometry=[]; end
if isempty(geometry), geometry=captureedit.resolveGeometry(sources,[],false); end
original=geometry; accepted=false; names=fieldnames(sources); images=struct();
for k=1:numel(names), images.(names{k})=sources.(names{k}).image; end
roles=intersect({'thorcam','validation'},names,'stable');
if ~isfield(geometry,'calibration'), geometry.calibration=struct(); end
for k=1:numel(roles)
 if ~isfield(geometry.calibration,roles{k})
  geometry.calibration.(roles{k})=struct('pointPairs',struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2)));
 end
end
review=struct(); status=struct();
for k=1:numel(roles)
 role=roles{k}; review.(role)=false; status.(role)='Saved alignment';
 if currentFit(role), status.(role)='Aligned from points'; end
end
mask=[]; roi=[]; syncing=false; selected='';
fig=uifigure('Name','Comparison geometry','Position',[80 80 1200 820],'WindowStyle','modal');
cleanup=onCleanup(@() closeFigure(fig));
root=uigridlayout(fig,[4 1],'RowHeight',{46,'1x',42,42},'Padding',[16 12 16 12],'RowSpacing',10);
heading=uigridlayout(root,[1 2],'ColumnWidth',{235,'1x'},'Padding',0);
uilabel(heading,'Text','Alignment and crop','FontSize',20,'FontWeight','bold');
uilabel(heading,'Text',['Shared field: ' strjoin(names,', ') '. All loaded cameras contribute.'],'WordWrap','on');
body=uigridlayout(root,[1 2],'ColumnWidth',{300,'1x'},'Padding',0,'ColumnSpacing',14);
sidebar=uigridlayout(body,[5 1],'RowHeight',{170,160,32,0,235},'Padding',0,'RowSpacing',8,'Scrollable','on');
prepare=uipanel(sidebar,'Title','1  Prepare','FontWeight','bold');
prep=uigridlayout(prepare,[4 2],'RowHeight',{30,30,30,'1x'},'ColumnWidth',{125,'1x'},'Padding',[10 8 10 8],'RowSpacing',6);
uilabel(prep,'Text','Camera'); items=roles; if isempty(items), items={'No cameras'}; end
camera=uidropdown(prep,'Items',items,'Tag','capture-camera','ValueChangedFcn',@(~,~) selectCamera());
uilabel(prep,'Text','Rotation (degrees)'); rotation=numeric(prep,'capture-preparation-rotation',@preparationChanged);
uilabel(prep,'Text','Scale to reference'); scale=numeric(prep,'capture-scale',@preparationChanged); scale.Value=1; scale.Limits=[eps Inf];
flip=uicheckbox(prep,'Text','Flip vertically','Tag','capture-flip','ValueChangedFcn',@(~,~) preparationChanged()); flip.Layout.Column=[1 2];
align=uipanel(sidebar,'Title','2  Match and align','FontWeight','bold');
al=uigridlayout(align,[4 1],'RowHeight',{32,30,28,'1x'},'Padding',[10 8 10 8],'RowSpacing',5);
pointButton=uibutton(al,'Text','Align from points','Tag','capture-align-points','FontWeight','bold','ButtonPushedFcn',@(~,~) calibrate());
estimateButton=uibutton(al,'Text','Estimate from images','ButtonPushedFcn',@(~,~) estimate());
manualButton=uibutton(al,'Text','Use manual alignment','Tag','capture-use-manual','ButtonPushedFcn',@(~,~) acceptManual());
fitInfo=uilabel(al,'Text','','WordWrap','on','Tag','capture-fit-info');
advanced=uibutton(sidebar,'Text','Show manual controls','ButtonPushedFcn',@(~,~) toggleManual());
manual=uipanel(sidebar,'Title','Manual alignment','Visible','off');
mg=uigridlayout(manual,[5 2],'RowHeight',{30,30,30,30,30},'ColumnWidth',{125,'1x'},'Padding',[10 8 10 8]);
uilabel(mg,'Text','Rotation (degrees)'); angle=numeric(mg,'capture-alignment-rotation',@manualChanged);
uilabel(mg,'Text','X (columns, px)'); tx=numeric(mg,'capture-translation-x',@manualChanged);
uilabel(mg,'Text','Y (rows, px)'); ty=numeric(mg,'capture-translation-y',@manualChanged);
uibutton(mg,'Text','Left 1 px','ButtonPushedFcn',@(~,~) nudge(-1,0));
uibutton(mg,'Text','Right 1 px','ButtonPushedFcn',@(~,~) nudge(1,0));
uibutton(mg,'Text','Up 1 px','ButtonPushedFcn',@(~,~) nudge(0,-1));
uibutton(mg,'Text','Down 1 px','ButtonPushedFcn',@(~,~) nudge(0,1));
cropPanel=uipanel(sidebar,'Title','3  Crop','FontWeight','bold');
cg=uigridlayout(cropPanel,[6 2],'RowHeight',{30,28,28,28,28,'1x'},'ColumnWidth',{125,'1x'},'Padding',[10 8 10 8],'RowSpacing',4);
fitCrop=uibutton(cg,'Text','Fit valid crop','Tag','capture-fit-crop','ButtonPushedFcn',@(~,~) resetCrop()); fitCrop.Layout.Column=[1 2];
fields=gobjects(1,4); labels={'Row','Column','Height','Width'};
for k=1:4
 uilabel(cg,'Text',labels{k});
 fields(k)=uieditfield(cg,'numeric','Limits',[1 Inf],'RoundFractionalValues','on', ...
  'Tag',['capture-crop-' lower(labels{k})],'ValueChangedFcn',@(~,~) cropChanged());
end
cropHint=uilabel(cg,'Text','Drag the blue rectangle. Only shared pixels can be applied.','WordWrap','on'); cropHint.Layout.Column=[1 2];
viewer=uigridlayout(body,[2 1],'RowHeight',{35,'1x'},'Padding',0);
viewControls=uigridlayout(viewer,[1 3],'ColumnWidth',{95,'1x',115},'Padding',0);
uilabel(viewControls,'Text','Camera opacity');
opacity=uislider(viewControls,'Limits',[0 1],'Value',.5,'MajorTicks',[0 .5 1], ...
 'MajorTickLabels',{'0%','50%','100%'},'MinorTicks',[],'ValueChangedFcn',@(~,~) render());
checker=uicheckbox(viewControls,'Text','Checkerboard','ValueChangedFcn',@(~,~) render());
plots=uigridlayout(viewer,[2 2],'RowHeight',{'1x','1x'},'Padding',0);
ax=gobjects(1,3); for k=1:3, ax(k)=uiaxes(plots); end
ax(3).Layout.Row=2; ax(3).Layout.Column=[1 2]; imageHandles=gobjects(1,3);
note=uilabel(root,'Text','','WordWrap','on','Tag','capture-geometry-message');
footer=uigridlayout(root,[1 3],'ColumnWidth',{'1x',100,130},'Padding',0);
summary=uilabel(footer,'Text','','WordWrap','on','Tag','capture-alignment-status');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
apply=uibutton(footer,'Text','Apply','FontWeight','bold','ButtonPushedFcn',@(~,~) finish(true));
if isempty(roles)
 disabledControls={camera,rotation,scale,flip,angle,tx,ty,pointButton,estimateButton,manualButton,advanced};
 for controlIndex=1:numel(disabledControls), disabledControls{controlIndex}.Enable='off'; end
else, selected=camera.Value; loadCamera(); end
setCrop(geometry.registration.crop); render();
if ~captureedit.isValidCrop(mask,geometry.registration.crop)
 updateStatus('Saved crop includes pixels outside the shared field. Choose Fit valid crop or adjust the rectangle.');
else, updateStatus('Review alignment, then drag the crop rectangle. Changes affect comparison viewing only.'); end
fig.CloseRequestFcn=@(~,~) finish(false); fig.Tag='capture-geometry-ready'; uiwait(fig);
if isgraphics(fig), delete(fig); end
if ~accepted, geometry=original; end

 function field=numeric(parent,tag,callback)
  field=uieditfield(parent,'numeric','Value',0,'Tag',tag,'ValueDisplayFormat','%.6g','ValueChangedFcn',@(~,~) callback());
 end
 function loadCamera()
  if isempty(selected), return; end
  s=geometry.cameraPreparation.(selected); tr=geometry.registration.savedTransforms;
  rotation.Value=s.rotationDegrees; flip.Value=s.flipVertical; scale.Value=s.downsampleFactor;
  angle.Value=tr.([selected 'RotationDegrees']); shift=tr.([selected 'TranslationXY']); tx.Value=shift(1); ty.Value=shift(2);
 end
 function selectCamera()
  selected=camera.Value; loadCamera(); render(); updateStatus('');
 end
 function candidate=readCamera()
  candidate=geometry; if isempty(selected), return; end
  candidate.cameraPreparation.(selected)=struct('rotationDegrees',rotation.Value,'flipVertical',flip.Value,'downsampleFactor',scale.Value);
  candidate.registration.savedTransforms.([selected 'RotationDegrees'])=angle.Value;
  candidate.registration.savedTransforms.([selected 'TranslationXY'])=[tx.Value ty.Value];
 end
 function preparationChanged()
  if isempty(selected), return; end
  candidate=readCamera(); old=geometry.cameraPreparation.(selected); new=candidate.cameraPreparation.(selected);
  oriented=old.rotationDegrees~=new.rotationDegrees || old.flipVertical~=new.flipVertical;
  if isequaln(old,new), return; end
  if oriented, candidate.calibration.(selected).pointPairs=struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2)); end
  try
   stage(candidate); review.(selected)=true; status.(selected)='Needs alignment review';
   message='Scale changed - review alignment using points, image estimation, or Use manual alignment.';
   if oriented, message='Orientation changed; point pairs cleared. Review alignment before applying.'; end
   updateStatus(message);
  catch cause, loadCamera(); updateStatus([cause.message ' Previous alignment retained.']); end
 end
 function manualChanged()
  if isempty(selected), return; end
  try
   preserved=stage(readCamera()); status.(selected)='Manually adjusted';
   message='Manual alignment updated.'; if ~preserved, message=[message ' Crop adjusted to remain inside the shared field.']; end
   updateStatus(message);
  catch cause, loadCamera(); updateStatus([cause.message ' Previous alignment retained.']); end
 end
 function nudge(x,y)
  tx.Value=tx.Value+x; ty.Value=ty.Value+y; manualChanged();
 end
 function acceptManual()
  if isempty(selected), return; end
  try
   stage(readCamera()); review.(selected)=false; status.(selected)='Manual alignment reviewed'; updateStatus('Manual alignment accepted. Review the shared crop.');
  catch cause, loadCamera(); updateStatus(cause.message); end
 end
 function estimate()
  if isempty(selected), return; end
  note.Text='Estimating alignment from original images...'; apply.Enable='off'; drawnow;
  try
   candidate=readCamera(); subset=struct('global',sources.global); subset.(selected)=sources.(selected);
   estimateCandidate=candidate; estimateCandidate.registration.cropMode='intersection';
   estimateCandidate.registration.requireExpectedCrop=false;
   estimated=captureedit.resolveGeometry(subset,estimateCandidate,true);
   candidate.registration.savedTransforms.([selected 'RotationDegrees'])=estimated.registration.savedTransforms.([selected 'RotationDegrees']);
   candidate.registration.savedTransforms.([selected 'TranslationXY'])=estimated.registration.savedTransforms.([selected 'TranslationXY']);
   preserved=stage(candidate); review.(selected)=false; status.(selected)='Estimated from images'; loadCamera();
   message='Image alignment estimated. Review the overlay.'; if ~preserved, message=[message ' Crop adjusted to remain inside the shared field.']; end
   updateStatus(message);
  catch cause, loadCamera(); updateStatus([cause.message ' Adjust preparation or align from points.']); end
 end
 function calibrate()
  if isempty(selected), return; end
  try
   candidate=readCamera(); s=candidate.cameraPreparation.(selected);
   moving=imrotate(double(sources.(selected).image),s.rotationDegrees); if s.flipVertical, moving=flipud(moving); end
   [pairs,ok]=captureedit.pointAlignmentDialog(sources.global.image,moving,candidate.calibration.(selected).pointPairs,selected);
   if ~ok, return; end
   previous=geometry.registration.crop;
   candidate=captureedit.applyPointAlignment(sources,candidate,selected,pairs);
   geometry=candidate; review.(selected)=false; status.(selected)='Aligned from points'; loadCamera(); setCrop(geometry.registration.crop); render();
   message='Point alignment applied to the preview. Review the overlay and crop.';
   if ~isequaln(previous,geometry.registration.crop), message=[message ' Crop adjusted to remain inside the shared field.']; end
   updateStatus(message);
  catch cause, loadCamera(); updateStatus([cause.message ' Previous alignment retained.']); end
 end
 function preserved=stage(candidate)
  preferred=geometry.registration.crop;
  candidate.registration.transformSource='saved'; candidate.registration.requireExpectedCrop=false; candidate.registration.cropMode='intersection';
  candidate.registration.requireValidPixels=true;
  candidate=captureedit.resolveGeometry(sources,candidate,false);
  full=candidate; full.registration.crop=[]; [~,valid]=captureedit.comparisonPanels(images,full);
  [candidate.registration.crop,preserved]=captureedit.validCrop(valid,preferred);
  candidate.registration.cropMode='saved'; geometry=candidate; setCrop(geometry.registration.crop); render();
 end
 function render()
  full=geometry; full.registration.crop=[]; full.registration.requireValidPixels=true;
  [p,mask]=captureedit.comparisonPanels(images,full);
  a=mat2gray(p.global); preview=a;
  if ~isempty(selected)
   b=mat2gray(p.(selected));
   if checker.Value
    [xx,yy]=meshgrid(1:size(a,2),1:size(a,1)); choose=mod(floor((xx-1)/16)+floor((yy-1)/16),2)==0; preview(choose)=b(choose);
   else, preview=(1-opacity.Value)*a+opacity.Value*b; end
  end
  common=repmat(a,1,1,3); red=common(:,:,1); red(~mask)=.25+.75*red(~mask); common(:,:,1)=red;
  for channel=2:3, plane=common(:,:,channel); plane(~mask)=plane(~mask)*.65; common(:,:,channel)=plane; end
  data={a,preview,common}; titles={'Global reference - original','Alignment overlay - originals','Shared field - drag crop; red is invalid'};
  for j=1:3
   if isgraphics(imageHandles(j)), imageHandles(j).CData=data{j};
   else, imageHandles(j)=imshow(data{j},'Parent',ax(j)); title(ax(j),titles{j}); end
  end
  syncing=true;
  if isempty(roi) || ~isvalid(roi)
   roi=drawrectangle(ax(3),'Position',position(geometry.registration.crop),'Color',[0 .45 .8],'LineWidth',1.5,'Deletable',false);
   roi.Tag='capture-crop-roi';
   addlistener(roi,'MovingROI',@(~,event) moveCrop(event.CurrentPosition,false));
   addlistener(roi,'ROIMoved',@(~,event) moveCrop(event.CurrentPosition,true));
  else, roi.Position=position(geometry.registration.crop); end
  syncing=false;
  if ~isempty(selected)
   count=size(geometry.calibration.(selected).pointPairs.referenceXY,1); fitInfo.Text=sprintf('%d saved point pairs',count);
   if currentFit(selected)
    f=geometry.calibration.(selected).alignmentFit.parameters;
    fitInfo.Text=sprintf('%d pairs | RMS %.3f px | Max %.3f px',count,f.rmsErrorPixels,f.maxErrorPixels);
   end
  end
 end
 function tf=currentFit(role)
  tf=false;
  if ~isfield(geometry,'calibration') || ~isfield(geometry.calibration,role), return; end
  c=geometry.calibration.(role); if ~isfield(c,'alignmentFit'), return; end; f=c.alignmentFit;
  if ~all(isfield(f,{'preparation','pointPairs','parameters'})), return; end
  tr=geometry.registration.savedTransforms; shift=tr.([role 'TranslationXY']);
  tf=isequaln(f.preparation,geometry.cameraPreparation.(role)) && isequaln(f.pointPairs,c.pointPairs) && ...
   isequaln(f.parameters.rotationDegrees,tr.([role 'RotationDegrees'])) && isequaln(f.parameters.translationXY(:).',shift(:).');
 end
 function resetCrop()
  try
   geometry.registration.crop=captureedit.validCrop(mask,[]); geometry.registration.cropMode='saved';
   setCrop(geometry.registration.crop); render(); updateStatus('Crop fitted to the largest rectangle of shared valid pixels.');
  catch cause, updateStatus(cause.message); end
 end
 function cropChanged()
  c=readCrop();
  if captureedit.isValidCrop(mask,c)
   geometry.registration.crop=c; geometry.registration.cropMode='saved'; syncROI(c); updateStatus('Crop updated.');
  else, updateStatus('Crop includes pixels outside the shared field. Adjust the values or choose Fit valid crop.'); end
 end
 function moveCrop(p,finished)
  if syncing, return; end
  c=struct('rowStartOneBased',round(p(2)+.5),'columnStartOneBased',round(p(1)+.5),'height',round(p(4)),'width',round(p(3)));
  valid=captureedit.isValidCrop(mask,c);
  if ~finished
   if valid, roi.Color=[0 .45 .8]; else, roi.Color=[.85 .2 .1]; end
   if ~valid, note.Text='Outside the shared field. Release to restore the previous crop.'; end
   return;
  end
  if valid
   geometry.registration.crop=c; geometry.registration.cropMode='saved'; setCrop(c); syncROI(c); updateStatus('Crop updated.');
  else
   setCrop(geometry.registration.crop); syncROI(geometry.registration.crop); updateStatus('Crop restored. Keep the rectangle inside the shared valid area.');
  end
 end
 function syncROI(c)
  syncing=true; if ~isempty(roi) && isvalid(roi), roi.Position=position(c); roi.Color=[0 .45 .8]; end; syncing=false;
 end
 function p=position(c)
  p=[c.columnStartOneBased-.5 c.rowStartOneBased-.5 c.width c.height];
 end
 function setCrop(c)
  values=[c.rowStartOneBased c.columnStartOneBased c.height c.width]; for j=1:4, fields(j).Value=values(j); end
 end
 function c=readCrop()
  c=struct('rowStartOneBased',fields(1).Value,'columnStartOneBased',fields(2).Value,'height',fields(3).Value,'width',fields(4).Value);
 end
 function updateStatus(message)
  pending=false; descriptions=cell(1,numel(roles));
  for j=1:numel(roles), role=roles{j}; pending=pending || review.(role); descriptions{j}=[role ': ' status.(role)]; end
  if isempty(roles), descriptions={'Global reference grid'}; end
  summary.Text=strjoin(descriptions,' | ');
  apply.Enable=matlab.lang.OnOffSwitchState(~pending && captureedit.isValidCrop(mask,readCrop()));
  if ~isempty(message), note.Text=message;
  elseif pending, note.Text='Review alignment for each camera marked as needing review before applying.'; end
 end
 function toggleManual()
  if strcmp(manual.Visible,'off')
   manual.Visible='on'; sidebar.RowHeight={170,160,32,195,235}; advanced.Text='Hide manual controls';
  else, manual.Visible='off'; sidebar.RowHeight={170,160,32,0,235}; advanced.Text='Show manual controls'; end
 end
 function finish(ok)
  if ok
   updateStatus(''); if strcmp(apply.Enable,'off'), return; end
   geometry.registration.crop=readCrop(); geometry.registration.cropMode='saved'; geometry.registration.requireValidPixels=true;
  end
  accepted=ok; uiresume(fig);
 end
end
function closeFigure(fig)
if isgraphics(fig), delete(fig); end
end
