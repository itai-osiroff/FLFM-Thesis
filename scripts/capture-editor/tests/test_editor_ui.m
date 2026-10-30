function tests = test_editor_ui
tests = functiontests(localfunctions);
end
function testEditingAndGestureHistory(testCase)
root = tempname; mkdir(root); cleanup = onCleanup(@() rmdir(root,'s'));
imwrite(uint16(reshape(0:99,10,10)),fullfile(root,'capture.tif'));
app = captureedit.Editor(root,'Visible','off'); closeApp = onCleanup(@() delete(app.Figure));
app.loadPaths(struct('thorcam',fullfile(root,'capture.tif')));
app.addFilter('brightness');
verifyEqual(testCase,numel(app.State.stacks.thorcam),1);
before = app.State;
app.setParameter('gain',2,'changing');
verifyTrue(testCase,contains(app.Status.Text,'Approximate'));
app.setParameter('gain',3,'changed');
verifyEqual(testCase,app.State.stacks.thorcam.params.gain,3);
app.undo(); verifyEqual(testCase,app.State,before);
app.redo(); verifyEqual(testCase,app.State.stacks.thorcam.params.gain,3);
app.toggleFilter(false);
verifyFalse(testCase,app.State.stacks.thorcam.enabled);
app.addFilter('gamma'); app.moveFilter(-1);
verifyEqual(testCase,app.State.stacks.thorcam(1).type,'gamma');
app.removeFilter(); verifyEqual(testCase,numel(app.State.stacks.thorcam),1);
verifyTrue(testCase,contains(app.Status.Text,'Exact'));
end
function testAlignedPairSessionAndProxy(testCase)
root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
paths=struct();
for role={'thorcam','validation','global','local'}
 name=role{1}; side=20;
 if ismember(name,{'global','local'}), side=10; end
 path=fullfile(root,[name '.tif']); imwrite(uint16(reshape(1:side^2,side,side)),path); paths.(name)=path;
end
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure)); app.loadPaths(paths);
app.State.geometry=captureedit.resolveGeometry(app.Sources,[],false);
view=findobj(app.Figure,'Tag','capture-view'); view.Value='Trio'; app.render(false);
verifyTrue(testCase,contains(app.Status.Text,'aligned common field'));
app.addFilter('brightness'); frozen=app.State.geometry;
app.setParameter('gain',1.4,'changing'); verifyTrue(testCase,contains(app.Status.Text,'Approximate'));
app.setParameter('gain',1.5,'changed'); verifyEqual(testCase,app.State.geometry,frozen);
view.Value='Pair'; left=findobj(app.Figure,'Tag','capture-pair-left'); right=findobj(app.Figure,'Tag','capture-pair-right');
left.Value='thorcam original'; right.Value='thorcam edited'; app.render(false);
verifyTrue(testCase,contains(app.Status.Text,'Exact'));
session=fullfile(root,'session.json'); app.saveSession(session);
other=captureedit.Editor(root,'Visible','off'); closeOther=onCleanup(@() delete(other.Figure)); other.openSession(session);
verifyEqual(testCase,other.State.stacks.thorcam.params.gain,1.5);
verifyTrue(testCase,contains(other.Status.Text,'Exact'));
end
