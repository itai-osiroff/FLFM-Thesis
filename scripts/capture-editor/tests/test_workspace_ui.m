function tests=test_workspace_ui
tests=functiontests(localfunctions);
end
function testWorkspaceAndReset(testCase)
root=tempname; mkdir(root); clean=onCleanup(@() rmdir(root,'s'));
imwrite(uint16(reshape(1:100,10,10)),fullfile(root,'a.tif'));
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure));
verifyEqual(testCase,numel(findall(app.Figure,'Type','uitab')),4);
app.loadPaths(struct('thorcam','a.tif')); app.addFilter('brightness'); app.setParameter('gain',2);
app.resetFilter(); verifyEqual(testCase,app.State.stacks.thorcam.params.gain,1);
app.resetStack(); verifyEmpty(testCase,app.State.stacks.thorcam);
app.undo(); verifyEqual(testCase,numel(app.State.stacks.thorcam),1);
end
function testInvalidLoadKeepsSession(testCase)
root=tempname; mkdir(root); clean=onCleanup(@() rmdir(root,'s'));
imwrite(uint16(ones(10)),fullfile(root,'a.tif'));
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure));
app.loadPaths(struct('thorcam','a.tif')); before=app.Sources;
verifyError(testCase,@() app.loadPaths(struct('thorcam','missing.xyz')),'captureedit:InvalidSource');
verifyEqual(testCase,app.Sources,before);
end

function testViewSessionRoundTrip(testCase)
root=tempname; mkdir(root); clean=onCleanup(@() rmdir(root,'s'));
imwrite(uint16(ones(10)),fullfile(root,'a.tif'));
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure));
app.loadPaths(struct('thorcam','a.tif'));
tabs=findobj(app.Figure,'Tag','capture-sections'); children=tabs.Children;
for k=1:numel(children), if strcmp(children(k).Title,'Export'), tabs.SelectedTab=children(k); end, end
app.saveSession(fullfile(root,'session.json'));
other=captureedit.Editor(root,'Visible','off'); closeOther=onCleanup(@() delete(other.Figure));
other.openSession(fullfile(root,'session.json')); restored=findobj(other.Figure,'Tag','capture-sections');
verifyEqual(testCase,restored.SelectedTab.Title,'Export');
end

function testExportSubsetSelection(testCase)
root=tempname; mkdir(root); clean=onCleanup(@() rmdir(root,'s'));
imwrite(uint16(ones(10)),fullfile(root,'a.tif'));
app=captureedit.Editor(root,'Visible','off'); closeApp=onCleanup(@() delete(app.Figure));
app.loadPaths(struct('thorcam','a.tif','validation','a.tif'));
roles=findobj(app.Figure,'Tag','capture-export-roles');
verifyEqual(testCase,roles.Items,{'thorcam','validation'});
verifyEqual(testCase,roles.Value,{'thorcam'});
verifyEqual(testCase,char(roles.Multiselect),'on');
end

