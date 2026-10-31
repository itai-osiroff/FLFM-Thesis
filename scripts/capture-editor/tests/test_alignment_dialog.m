function tests=test_alignment_dialog
% Dialog callbacks exercise the real staged UI, without writing source data.
tests=functiontests(localfunctions);
end
function testNudgeUpdatesCommonFieldWithoutReset(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
x=reshape(1:100,10,10); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
completed=false; applyEnabled=false;
job=timer('ExecutionMode','fixedSpacing','Period',.5,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[g,accepted]=captureedit.geometryDialog(sources,[]);
verifyTrue(t,completed); verifyTrue(t,applyEnabled); verifyTrue(t,accepted);
verifyEqual(t,g.registration.savedTransforms.thorcamTranslationXY,[1 0]);
verifyEqual(t,g.registration.crop.columnStartOneBased,2);
verifyEqual(t,g.registration.crop.width,9);
 function act(~,~)
  fig=findall(groot,'Type','figure','Name','Comparison geometry','Tag','capture-geometry-ready'); if isempty(fig), return; end
  right=findall(fig,'Type','uibutton','Text','Right 1 px'); apply=findall(fig,'Type','uibutton','Text','Apply');
  if isempty(right) || isempty(apply), return; end
  stop(job); right.ButtonPushedFcn(right,[]); applyEnabled=strcmp(apply.Enable,'on'); completed=true;
  if applyEnabled, apply.ButtonPushedFcn(apply,[]); else, fig.CloseRequestFcn(fig,[]); end
 end
end
function testNoCameraDialogCanCancel(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
x=reshape(1:100,10,10); sources=struct('global',struct('image',x),'local',struct('image',x));
original=captureedit.resolveGeometry(sources,[],false); completed=false;
job=timer('ExecutionMode','fixedSpacing','Period',.5,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[g,accepted]=captureedit.geometryDialog(sources,original);
verifyTrue(t,completed); verifyFalse(t,accepted); verifyEqual(t,g,original);
 function act(~,~)
  fig=findall(groot,'Type','figure','Name','Comparison geometry','Tag','capture-geometry-ready'); if isempty(fig), return; end
  cancel=findall(fig,'Type','uibutton','Text','Cancel'); if isempty(cancel), return; end
  stop(job); completed=true; cancel.ButtonPushedFcn(cancel,[]);
 end
end
function dispose(job)
if isvalid(job), stop(job); delete(job); end
end

function testPointAlignmentThenRepeatedCropEdits(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
x=reshape(1:10000,100,100); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
g.registration.savedTransforms.thorcamTranslationXY=[30 0]; g.registration.cropMode='intersection';
g=captureedit.resolveGeometry(sources,g,false);
points=struct('movingXY',[10 10;30 10;10 30],'referenceXY',[20 25;40 25;20 45]);
g=captureedit.applyPointAlignment(sources,g,'thorcam',points);
completed=false; failure=[];
opener=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(opener)); start(opener);
[out,accepted]=captureedit.geometryDialog(sources,g);
if ~isempty(failure), rethrow(failure); end
verifyTrue(t,completed); verifyTrue(t,accepted);
verifyEqual(t,out.registration.savedTransforms.thorcamTranslationXY,[10 15],'AbsTol',1e-12);
images=struct('global',x,'thorcam',x); [~,mask]=captureedit.comparisonPanels(images,out); verifyTrue(t,all(mask(:)));
 function act(~,~)
  fig=findall(groot,'Tag','capture-geometry-ready'); if isempty(fig), return; end; stop(opener);
  try
   apply=findall(fig,'Type','uibutton','Text','Apply'); verifyEqual(t,char(apply.Enable),'on');
   for widths=[20 15 25]
    field=findall(fig,'Tag','capture-crop-width'); field.Value=widths; field.ValueChangedFcn(field,[]);
    verifyEqual(t,char(apply.Enable),'on');
   end
   field.Value=100; field.ValueChangedFcn(field,[]); verifyEqual(t,char(apply.Enable),'off');
   b=findall(fig,'Tag','capture-fit-crop'); b.ButtonPushedFcn(b,[]); verifyEqual(t,char(apply.Enable),'on');
   completed=true; apply.ButtonPushedFcn(apply,[]);
  catch e, failure=e; fig.CloseRequestFcn(fig,[]); end
 end
end
function testPreparationRequiresPerCameraReviewAndCancelRestores(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
x=reshape(1:400,20,20); sources=struct('global',struct('image',x),'thorcam',struct('image',x),'validation',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false); completed=false; failure=[];
job=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[out,accepted]=captureedit.geometryDialog(sources,g);
if ~isempty(failure), rethrow(failure); end
verifyTrue(t,completed); verifyFalse(t,accepted); verifyEqual(t,out,g);
 function act(~,~)
  fig=findall(groot,'Tag','capture-geometry-ready'); if isempty(fig), return; end; stop(job);
  try
   scale=findall(fig,'Tag','capture-scale'); scale.Value=.9; scale.ValueChangedFcn(scale,[]);
   apply=findall(fig,'Type','uibutton','Text','Apply'); verifyEqual(t,char(apply.Enable),'off');
   camera=findall(fig,'Tag','capture-camera'); camera.Value='validation'; camera.ValueChangedFcn(camera,[]);
   verifyEqual(t,scale.Value,1); verifyEqual(t,char(apply.Enable),'off');
   camera.Value='thorcam'; camera.ValueChangedFcn(camera,[]); verifyEqual(t,scale.Value,.9);
   b=findall(fig,'Tag','capture-use-manual'); b.ButtonPushedFcn(b,[]); verifyEqual(t,char(apply.Enable),'on');
   tx=findall(fig,'Tag','capture-translation-x'); tx.Value=1000; tx.ValueChangedFcn(tx,[]); verifyEqual(t,tx.Value,0);
   completed=true; fig.CloseRequestFcn(fig,[]);
  catch e, failure=e; fig.CloseRequestFcn(fig,[]); end
 end
end
function testLegacyInvalidCropNeedsExplicitRepair(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
x=reshape(1:400,20,20); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false); g.registration.savedTransforms.thorcamRotationDegrees=15;
g=captureedit.resolveGeometry(sources,g,false); completed=false; failure=[];
job=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[out,accepted]=captureedit.geometryDialog(sources,g);
if ~isempty(failure), rethrow(failure); end
verifyTrue(t,completed); verifyTrue(t,accepted);
[~,mask]=captureedit.comparisonPanels(struct('global',x,'thorcam',x),out); verifyTrue(t,all(mask(:)));
 function act(~,~)
  fig=findall(groot,'Tag','capture-geometry-ready'); if isempty(fig), return; end; stop(job);
  try
   apply=findall(fig,'Type','uibutton','Text','Apply'); verifyEqual(t,char(apply.Enable),'off');
   b=findall(fig,'Tag','capture-fit-crop'); b.ButtonPushedFcn(b,[]); verifyEqual(t,char(apply.Enable),'on');
   completed=true; apply.ButtonPushedFcn(apply,[]);
  catch e, failure=e; fig.CloseRequestFcn(fig,[]); end
 end
end
function testImageEstimationRepairsCropAfterTranslation(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
rng(23); moving=rand(20); fixed=zeros(40); fixed(6:25,10:29)=imgaussfilt(moving,.5);
sources=struct('global',struct('image',fixed),'thorcam',struct('image',moving));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
g.registration.cropMode='intersection'; g.registration.rotationStartDegrees=0; g.registration.rotationStopDegrees=0;
g=captureedit.resolveGeometry(sources,g,false); g.registration.cropMode='saved'; completed=false; failure=[];
job=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[out,accepted]=captureedit.geometryDialog(sources,g);
if ~isempty(failure), rethrow(failure); end
verifyTrue(t,completed); verifyTrue(t,accepted);
verifyEqual(t,out.registration.savedTransforms.thorcamTranslationXY,[9 5]);
verifyEqual(t,[out.registration.crop.rowStartOneBased out.registration.crop.columnStartOneBased],[6 10]);
 function act(~,~)
  fig=findall(groot,'Tag','capture-geometry-ready'); if isempty(fig), return; end; stop(job);
  try
   b=findall(fig,'Type','uibutton','Text','Estimate from images'); b.ButtonPushedFcn(b,[]);
   apply=findall(fig,'Type','uibutton','Text','Apply'); completed=true; apply.ButtonPushedFcn(apply,[]);
  catch e, failure=e; fig.CloseRequestFcn(fig,[]); end
 end
end

function testCalibrationPreservedThroughResolutionAndHistory(t)
x=reshape(1:100,10,10); sources=struct('global',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false);
points=struct('referenceXY',[2 2;4 4],'movingXY',[2 2;6 6]);
g.calibration.thorcam.pointPairs=points;
resolved=captureedit.resolveGeometry(sources,g,false);
verifyEqual(t,resolved.calibration.thorcam.pointPairs,points);
state=captureedit.normalizeStacks(jsondecode(jsonencode(struct('stacks',struct(),'geometry',resolved))));
verifyEqual(t,state.geometry.calibration.thorcam.pointPairs,points);
verifySize(t,state.geometry.calibration.validation.pointPairs.referenceXY,[0 2]);
legacy=rmfield(g,'calibration');
state=captureedit.normalizeStacks(struct('stacks',struct(),'geometry',legacy));
verifyEqual(t,state.geometry,legacy);
end
