function [geometry,accepted] = geometryDialog(sources,geometry)
%GEOMETRYDIALOG Native desktop geometry setup; never writes source images.
if nargin<2 || isempty(geometry), geometry=captureedit.resolveGeometry(sources,[],false); end
original=geometry; accepted=false;
fig=uifigure('Name','Comparison geometry','Position',[100 100 1150 790]);
cleanup=onCleanup(@() closeFigure(fig));
grid=uigridlayout(fig,[5 1],'RowHeight',{120,55,'1x',55,40});
roles={'thorcam','validation'}; values=zeros(2,6);
for k=1:2
 initialRole=roles{k}; s=geometry.cameraPreparation.(initialRole); tr=geometry.registration.savedTransforms;
 values(k,:)=[s.rotationDegrees,double(s.flipVertical),s.downsampleFactor,tr.([initialRole 'RotationDegrees']),tr.([initialRole 'TranslationXY'])];
end
table=uitable(grid,'Data',values,'ColumnName',{'Preparation rotation','Flip vertical (0/1)','Scale','Alignment rotation','X translation','Y translation'},'RowName',roles,'ColumnEditable',true(1,6));
table.CellEditCallback=@(~,~) refresh(false);
buttons=uigridlayout(grid,[1 4]);
uibutton(buttons,'Text','Re-estimate alignment','ButtonPushedFcn',@(~,~) refresh(true));
uibutton(buttons,'Text','Calibrate ThorCam scale','ButtonPushedFcn',@(~,~) calibrate(1));
uibutton(buttons,'Text','Calibrate validation scale','ButtonPushedFcn',@(~,~) calibrate(2));
uibutton(buttons,'Text','Use common crop','ButtonPushedFcn',@(~,~) commonCrop());
plots=uigridlayout(grid,[1 3]); axesHandles=gobjects(1,3);
for k=1:3, axesHandles(k)=uiaxes(plots); end
cropGrid=uigridlayout(grid,[1 8]); fields=gobjects(1,4); c=geometry.registration.crop;
labels={'Row','Column','Height','Width'}; initial=[c.rowStartOneBased,c.columnStartOneBased,c.height,c.width];
for k=1:4
 uilabel(cropGrid,'Text',labels{k}); fields(k)=uieditfield(cropGrid,'numeric','Value',initial(k),'Limits',[1 Inf],'RoundFractionalValues','on','ValueChangedFcn',@(~,~) refresh(false));
end
footer=uigridlayout(grid,[1 3],'ColumnWidth',{'1x',100,100}); note=uilabel(footer,'Text','Geometry affects comparisons only.','WordWrap','on');
uibutton(footer,'Text','Cancel','ButtonPushedFcn',@(~,~) finish(false));
apply=uibutton(footer,'Text','Apply','ButtonPushedFcn',@(~,~) finish(true));
fig.CloseRequestFcn=@(~,~) finish(false); refresh(false); uiwait(fig);
if ~accepted, geometry=original; end
 function candidate=readControls()
  candidate=geometry; v=table.Data;
  validateattributes(v,{'numeric'},{'finite','size',[2 6]});
  for n=1:2
   name=roles{n}; validateattributes(v(n,3),{'numeric'},{'positive'});
   if ~ismember(v(n,2),[0 1]), error('captureedit:Flip','Flip must be zero or one.'); end
   candidate.cameraPreparation.(name)=struct('rotationDegrees',v(n,1),'flipVertical',logical(v(n,2)),'downsampleFactor',v(n,3));
   candidate.registration.savedTransforms.([name 'RotationDegrees'])=v(n,4);
   candidate.registration.savedTransforms.([name 'TranslationXY'])=v(n,5:6);
  end
  candidate.registration.transformSource='saved'; candidate.registration.requireExpectedCrop=false;
  candidate.registration.cropMode='saved';
  candidate.registration.crop=struct('rowStartOneBased',fields(1).Value,'columnStartOneBased',fields(2).Value,'height',fields(3).Value,'width',fields(4).Value);
 end
 function refresh(estimate)
  try
   candidate=readControls();
   if estimate, candidate.registration.cropMode='intersection'; note.Text='Estimating alignment from originals...'; drawnow; end
   candidate=captureedit.resolveGeometry(sources,candidate,estimate);
   images=struct(); for name={'thorcam','validation','global','local'}, images.(name{1})=sources.(name{1}).image; end
   [panels,mask]=captureedit.comparisonPanels(images,candidate);
   overlay(axesHandles(1),panels.global,panels.thorcam,'Global / ThorCam');
   overlay(axesHandles(2),panels.global,panels.validation,'Global / validation');
   imshow(mask,'Parent',axesHandles(3)); title(axesHandles(3),'Common field validity');
   geometry=candidate;
   if estimate
    for n=1:2, name=roles{n}; table.Data(n,4:6)=[candidate.registration.savedTransforms.([name 'RotationDegrees']),candidate.registration.savedTransforms.([name 'TranslationXY'])]; end
    setCrop(candidate.registration.crop);
   end
   note.Text='X is columns, Y is rows on the global grid. Invalid interior pixels are black in the validity panel.'; apply.Enable='on';
  catch cause, note.Text=cause.message; apply.Enable='off';
  end
 end
 function commonCrop()
  try
   candidate=readControls(); candidate.registration.cropMode='intersection'; candidate=captureedit.resolveGeometry(sources,candidate,false);
   setCrop(candidate.registration.crop); refresh(false);
  catch cause, note.Text=cause.message;
  end
 end
 function setCrop(c)
  vals=[c.rowStartOneBased,c.columnStartOneBased,c.height,c.width]; for n=1:4, fields(n).Value=vals(n); end
 end
 function calibrate(index)
  try
   candidate=readControls(); name=roles{index}; s=candidate.cameraPreparation.(name);
   moving=imrotate(double(sources.(name).image),s.rotationDegrees); if s.flipVertical, moving=flipud(moving); end
   f=figure('Name','Scale calibration: draw corresponding feature spans'); closer=onCleanup(@() closeFigure(f));
   ax1=subplot(1,2,1,'Parent',f); imshow(sources.global.image,[],'Parent',ax1); title(ax1,'Draw a reference span; double-click to finish');
   ax2=subplot(1,2,2,'Parent',f); imshow(moving,[],'Parent',ax2); title(ax2,'Then draw the same span in camera image');
   a=drawline(ax1); wait(a); b=drawline(ax2); wait(b);
   ratio=norm(diff(a.Position))/norm(diff(b.Position)); validateattributes(ratio,{'numeric'},{'scalar','finite','positive'});
   table.Data(index,3)=ratio; commonCrop();
  catch cause, note.Text=['Calibration cancelled or invalid: ' cause.message];
  end
 end
 function finish(ok)
  if ok && strcmp(apply.Enable,'off'), return; end
  accepted=ok; uiresume(fig);
 end
end
function overlay(ax,a,b,label)
imshow(cat(3,mat2gray(a),mat2gray(b),zeros(size(a))),'Parent',ax); title(ax,label);
end
function closeFigure(fig)
if isgraphics(fig), delete(fig); end
end
