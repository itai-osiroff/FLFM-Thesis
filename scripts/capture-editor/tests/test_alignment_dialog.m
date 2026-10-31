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
