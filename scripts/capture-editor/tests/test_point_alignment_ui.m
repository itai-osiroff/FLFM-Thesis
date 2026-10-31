function tests=test_point_alignment_ui
tests=functiontests(localfunctions);
end
function setupOnce(~)
addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testWrongPanelAndEscapeNeverCommitHalfPair(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
completed=false; job=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[points,accepted]=captureedit.pointAlignmentDialog(reshape(1:400,20,20),reshape(1:1600,40,40), ...
 struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2)),'thorcam');
verifyTrue(t,completed); verifyFalse(t,accepted); verifyEmpty(t,points.referenceXY);
 function act(~,~)
  fig=findall(groot,'Tag','capture-point-ready'); if isempty(fig), return; end; stop(job);
  b=findall(fig,'Tag','capture-add-pair'); b.ButtonPushedFcn(b,[]);
  ref=findall(fig,'Tag','capture-point-reference'); mov=findall(fig,'Tag','capture-point-moving');
  mov.ButtonDownFcn(mov,struct('IntersectionPoint',[3 3 0]));
  ref.ButtonDownFcn(ref,struct('IntersectionPoint',[2 2 0]));
  fig.WindowKeyPressFcn(fig,struct('Key','escape'));
  b.ButtonPushedFcn(b,[]);
  ref=findall(fig,'Tag','capture-point-reference');
  ref.ButtonDownFcn(ref,struct('IntersectionPoint',[5 5 0]));
  mov=findall(fig,'Tag','capture-point-moving');
  mov.ButtonDownFcn(mov,struct('IntersectionPoint',[10 10 0]));
  list=findall(fig,'Tag','capture-point-pairs'); verifyEqual(t,numel(list.Items),1);
  remove=findall(fig,'Tag','capture-remove-pair'); remove.ButtonPushedFcn(remove,[]);
  verifyEmpty(t,list.Items);
  completed=true; fig.CloseRequestFcn(fig,[]);
 end
end
function dispose(job)
if isvalid(job), stop(job); delete(job); end
end
function testAcceptsCompleteFit(t)
assumeTrue(t,usejava('desktop'),'Requires MATLAB desktop graphics.');
points=struct('referenceXY',[2 2;8 2],'movingXY',[4 4;16 4]);
completed=false; job=timer('ExecutionMode','fixedSpacing','Period',.3,'StartDelay',1,'TimerFcn',@act);
cleanup=onCleanup(@() dispose(job)); start(job);
[out,accepted]=captureedit.pointAlignmentDialog(reshape(1:400,20,20),reshape(1:1600,40,40),points,'thorcam');
verifyTrue(t,completed); verifyTrue(t,accepted); verifyEqual(t,out,points);
 function act(~,~)
  fig=findall(groot,'Tag','capture-point-ready'); if isempty(fig), return; end; stop(job);
  b=findall(fig,'Tag','capture-use-point-alignment'); verifyEqual(t,char(b.Enable),'on');
  completed=true; b.ButtonPushedFcn(b,[]);
 end
end
