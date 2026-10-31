function tests=test_capture_session_geometry
 tests=functiontests(localfunctions);
end
function setupOnce(t)
 addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testHistory(t)
 h=captureedit.editHistory('new'); a=struct('stacks',struct('global',struct([]))); b=a; b.geometry=1;
 [h,s]=captureedit.editHistory('commit',h,a,b); verifyEqual(t,s,b);
 [h,s]=captureedit.editHistory('undo',h,b); verifyEqual(t,s,a);
 [h,s]=captureedit.editHistory('redo',h,a); verifyEqual(t,s,b);
 [h,~]=captureedit.editHistory('undo',h,b); [h,~]=captureedit.editHistory('commit',h,a,struct('x',2)); verifyEmpty(t,h.redo);
end
function testFrozenGeometry(t)
 im=reshape(1:400,20,20); sources=struct();
 for role={'thorcam','validation','global','local'}, sources.(role{1})=struct('image',im); end
 g=captureedit.resolveGeometry(sources,[],false);
 images=struct('thorcam',im,'validation',im,'global',im,'local',im);
 panels=captureedit.comparisonPanels(images,g); verifyEqual(t,panels.global,im);
 images.thorcam=im*2; result=captureedit.comparisonPanels(images,g);
 verifyEqual(t,result.thorcam,panels.thorcam*2,'AbsTol',1e-10);
 verifyEqual(t,result.global,panels.global);
end

function testSessionRoundtripAndChangedSource(t)
 root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
 imwrite(uint16(reshape(1:100,10,10)),fullfile(root,'camera.tif'));
 sources=captureedit.loadSources(root,struct('thorcam','camera.tif'));
 stacks=struct('thorcam',struct([])); h=captureedit.editHistory('new'); path=fullfile(root,'session.json');
 captureedit.saveSession(path,root,sources,stacks,[],h,struct('mode','Single'));
 [restored,s,g,history,v]=captureedit.loadSession(path,root);
 verifyEqual(t,restored.thorcam.image,sources.thorcam.image); verifyEqual(t,s,stacks); verifyEmpty(t,g);
 verifyEmpty(t,history.undo); verifyEqual(t,v.mode,'Single');
 imwrite(uint16(zeros(10)),fullfile(root,'camera.tif'));
 verifyError(t,@() captureedit.loadSession(path,root),'captureedit:SourceChanged');
end
function testMalformedRangeAndFailedSave(t)
 root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
 imwrite(uint8(ones(5)),fullfile(root,'camera.png'));
 sources=captureedit.loadSources(root,struct('thorcam','camera.png')); path=fullfile(root,'session.json');
 captureedit.saveSession(path,root,sources,struct('thorcam',struct([])),[],captureedit.editHistory('new'),struct());
 original=fileread(path); r=jsondecode(original); r.sources.thorcam.range=[2 1];
 fid=fopen(path,'w'); fprintf(fid,'%s',jsonencode(r)); fclose(fid);
 verifyError(t,@() captureedit.loadSession(path,root),'captureedit:SessionRange');
 fid=fopen(path,'w'); fprintf(fid,'%s',original); fclose(fid);
 verifyError(t,@() captureedit.saveSession(fullfile(root,'missing','session.json'),root,sources,struct(),[],struct(),struct()),'captureedit:SessionDirectory');
 verifyEqual(t,fileread(path),original);
end

function testHistoryRetainsStateShape(t)
 g=struct('referenceSize',[20 30],'registration',struct('savedTransforms',struct('thorcamTranslationXY',[1 2],'validationTranslationXY',[3 4])));
 a=struct('stacks',struct('thorcam',struct([])),'geometry',g,'displayRanges',struct('thorcam',[0 99]));
 b=a; b.displayRanges.thorcam=[1 100]; h=captureedit.editHistory('new');
 [h,~]=captureedit.editHistory('commit',h,a,b); [h,s]=captureedit.editHistory('undo',h,b); verifyEqual(t,s,a);
 [~,s]=captureedit.editHistory('redo',h,a); verifyEqual(t,s,b);
end
function testTrioGeometryCorrespondence(t)
 addpath(fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))),'figure-preparation'));
 recipe=triofig.defaultRecipe('synthetic','candidate-outputs/figures-source/synthetic');
 recipe.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
 recipe.cameraPreparation.validation=recipe.cameraPreparation.thorcam;
 recipe.registration.transformSource='saved';
 im=reshape(1:600,20,30); images=struct('thorcam',im,'validation',im,'global',im,'local',im*2);
 sources=struct(); for name=fieldnames(images).', sources.(name{1})=struct('image',images.(name{1})); end
 g=captureedit.resolveGeometry(sources,recipe,false); panels=captureedit.comparisonPanels(images,g);
 prepared=triofig.preparePanels(im,im*2,im,im,recipe);
 joint=[min([panels.global(:);panels.local(:)]),max([panels.global(:);panels.local(:)])];
 verifyEqual(t,(panels.global-joint(1))/diff(joint),prepared.global,'AbsTol',1e-14);
 lo=min(panels.thorcam(:)); hi=max(panels.thorcam(:));
 verifyEqual(t,(panels.thorcam-lo)/(hi-lo),prepared.thorcam,'AbsTol',1e-14);
end

function testSessionCannotOverwriteSource(t)
 root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
 source=fullfile(root,'camera.png'); imwrite(uint8(ones(5)),source);
 sources=captureedit.loadSources(root,struct('thorcam',source)); before=captureedit.sha256(source);
 verifyError(t,@() captureedit.saveSession(source,root,sources,struct(),[],struct(),struct()),'captureedit:SourceOverwrite');
 verifyEqual(t,captureedit.sha256(source),before);
 verifyError(t,@() captureedit.saveSession(fullfile(root,'session.txt'),root,sources,struct(),[],struct(),struct()),'captureedit:SessionExtension');
end

function testDefaultComparisonGeometry(t)
 imGlobal=reshape(1:1600,40,40);
 imThorcam=reshape(1:8000,80,100);
 imVal=reshape(1:12000,100,120);
 sources=struct('global',struct('image',imGlobal),'local',struct('image',imGlobal), ...
  'thorcam',struct('image',imThorcam),'validation',struct('image',imVal));
 g=captureedit.resolveGeometry(sources,[],false);
 verifyEqual(t,g.cameraPreparation.thorcam.rotationDegrees,-90);
 verifyEqual(t,g.cameraPreparation.thorcam.flipVertical,true);
 verifyEqual(t,g.cameraPreparation.validation.rotationDegrees,-90);
 verifyEqual(t,g.cameraPreparation.validation.flipVertical,false);
 thorcam=imrotate(imThorcam,-90); thorcam=flipud(thorcam);
 validation=imrotate(imVal,-90);
 expectedThorcam=min(1,median([40/size(thorcam,1),40/size(thorcam,2)]));
 expectedValidation=min(1,median([40/size(validation,1),40/size(validation,2)]));
 verifyEqual(t,g.cameraPreparation.thorcam.downsampleFactor,expectedThorcam);
 verifyEqual(t,g.cameraPreparation.validation.downsampleFactor,expectedValidation);
 verifyLessThan(t,expectedThorcam,1);
 verifyLessThan(t,expectedValidation,1);
end

function testGeometryDialogCloseLifecycle(t)
 assumeTrue(t,usejava('desktop'),'Geometry dialog lifecycle test requires MATLAB desktop graphics.');
 root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
 paths=struct();
 for role={'thorcam','validation','global','local'}
  name=role{1}; side=20;
  if ismember(name,{'global','local'}), side=10; end
  path=fullfile(root,[name '.tif']); imwrite(uint16(reshape(1:side^2,side,side)),path); paths.(name)=path;
 end
 sources=captureedit.loadSources(root,paths);
 timerCancel=timer('ExecutionMode','fixedSpacing','Period',.5,'StartDelay',.5,'TimerFcn',@(~,~) clickDialogButton('Cancel'));
 timerApply=timer('ExecutionMode','fixedSpacing','Period',.5,'StartDelay',.5,'TimerFcn',@(~,~) editAndApply());
 timerClose=timer('ExecutionMode','fixedSpacing','Period',.5,'StartDelay',.5,'TimerFcn',@(~,~) closeDialog());
 timerCleanup=onCleanup(@() delete([timerCancel timerApply timerClose]));
 start(timerCancel);
 [~,acceptedCancel]=captureedit.geometryDialog(sources,[]);
 verifyFalse(t,acceptedCancel);
 verifyEmpty(t,findall(groot,'Type','figure','Name','Comparison geometry'));

 start(timerApply);
 [appliedGeometry,acceptedApply]=captureedit.geometryDialog(sources,[]);
 verifyTrue(t,acceptedApply);
 verifyEqual(t,appliedGeometry.registration.crop.columnStartOneBased,4);
 verifyEqual(t,appliedGeometry.registration.crop.width,7);
 verifyEmpty(t,findall(groot,'Type','figure','Name','Comparison geometry'));

 start(timerClose);
 [~,acceptedClose]=captureedit.geometryDialog(sources,[]);
 verifyFalse(t,acceptedClose);
 verifyEmpty(t,findall(groot,'Type','figure','Name','Comparison geometry'));
 function clickDialogButton(btnText)
  figs=findall(groot,'Type','figure','Name','Comparison geometry','Tag','capture-geometry-ready');
  if ~isempty(figs)
   btn=findall(figs(1),'Type','uibutton','Text',btnText);
   if ~isempty(btn), stop(timerCancel); btn.ButtonPushedFcn(btn,[]); end
  end
 end

 function editAndApply()
  figs=findall(groot,'Type','figure','Name','Comparison geometry','Tag','capture-geometry-ready');
  if ~isempty(figs)
   stop(timerApply);
   field=findall(figs(1),'Tag','capture-translation-x');
   field.Value=3;
   field.ValueChangedFcn(field,[]);
   reset=findall(figs(1),'Type','uibutton','Text','Fit valid crop');
   reset.ButtonPushedFcn(reset,[]);
   btn=findall(figs(1),'Type','uibutton','Text','Apply');
   if ~isempty(btn), btn.ButtonPushedFcn(btn,[]); end
  end
 end
 function closeDialog()
  figs=findall(groot,'Type','figure','Name','Comparison geometry','Tag','capture-geometry-ready');
  if ~isempty(figs), stop(timerClose); figs(1).CloseRequestFcn(figs(1),[]); end
 end
end
