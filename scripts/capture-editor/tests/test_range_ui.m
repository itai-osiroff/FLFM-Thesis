function tests=test_range_ui
tests=functiontests(localfunctions);
end
function testPolicyAndStale(t)
root=tempname; mkdir(root); cleanup=onCleanup(@()rmdir(root,'s'));
imwrite(uint8([0 64;128 255]),fullfile(root,'a.png'));
app=captureedit.Editor(root,'Visible','off'); closer=onCleanup(@()delete(app.Figure));
app.loadPaths(struct('thorcam','a.png'));
verifyEqual(t,app.State.processingPolicy,'preserve');
app.setProcessingPolicy('legacy-clamp'); verifyEqual(t,app.State.processingPolicy,'legacy-clamp');
app.undo(); verifyEqual(t,app.State.processingPolicy,'preserve');
app.addFilter('brightness'); app.setParameter('offset',-.5,'changed');
app.addFilter('gamma'); app.setParameter('gamma',.5,'changed');
verifyTrue(t,contains(app.Status.Text,'STALE'));
buttons=findobj(app.Figure,'Tag','capture-export-action'); verifyTrue(t,all(strcmp({buttons.Enable},'off')));
app.toggleFilter(false); verifyTrue(t,contains(app.Status.Text,'Exact'));
verifyTrue(t,all(strcmp({buttons.Enable},'on')));
end
function testExactEndpointsNotHighlighted(t)
root=tempname; mkdir(root); cleanup=onCleanup(@()rmdir(root,'s'));
imwrite(uint8([0 64;128 255]),fullfile(root,'a.png'));
app=captureedit.Editor(root,'Visible','off'); closer=onCleanup(@()delete(app.Figure)); app.loadPaths(struct('thorcam','a.png'));
control=findobj(app.Figure,'Text','Outside viewing range'); control.Value=true; app.render(false);
img=findobj(app.Figure,'Type','image'); data=img.CData;
verifyEqual(t,data(:,:,1),data(:,:,2)); verifyEqual(t,data(:,:,2),data(:,:,3));
end
function testAlignedSupportExcludesRotationFill(t)
x=ones(30); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam.rotationDegrees=30;
g.registration.requireValidPixels=false;
[~,legacy,valid]=captureedit.comparisonPanels(struct('global',x,'thorcam',x),g);
verifyTrue(t,any(~valid(:))); verifyTrue(t,any(valid(:))); verifyTrue(t,all(valid(:)<=legacy(:)));
end
function testDiagnosticsCacheAndApproximate(t)
root=tempname; mkdir(root); cleanup=onCleanup(@()rmdir(root,'s'));
imwrite(uint8([0 64;128 255]),fullfile(root,'a.png'));
app=captureedit.Editor(root,'Visible','off'); closer=onCleanup(@()delete(app.Figure)); app.loadPaths(struct('thorcam','a.png'));
app.addFilter('brightness'); app.setParameter('gain',2,'changed');
label=findobj(app.Figure,'Tag','capture-diagnostics'); first=label.Text; app.render(false); verifyEqual(t,label.Text,first);
app.render(true); verifyTrue(t,contains(label.Text,'pending')); app.render(false); verifyEqual(t,label.Text,first);
control=findobj(app.Figure,'Text','Outside viewing range'); control.Value=true; app.render(false);
img=findobj(app.Figure,'Type','image'); counts=getappdata(img.Parent,'displayCounts'); verifyEqual(t,counts,[0 2 4]);
end

function testAlignedSupportRejectsInterpolatedFill(t)
x=ones(80); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam.rotationDegrees=27;
g.cameraPreparation.thorcam.downsampleFactor=.75;
g.registration.requireValidPixels=false;
g.registration.rotationInterpolation='bilinear';
g.registration.savedTransforms.thorcamRotationDegrees=13;
g.registration.savedTransforms.thorcamTranslationXY=[.4 .7];
[p,legacy,valid]=captureedit.comparisonPanels(struct('global',x,'thorcam',x),g);
verifyTrue(t,any(valid(:)));
verifyEqual(t,p.thorcam(valid),ones(nnz(valid),1),'AbsTol',1e-12);
contaminated=p.thorcam>0 & p.thorcam<1-1e-10;
verifyTrue(t,any(contaminated(:)));
verifyFalse(t,any(valid(contaminated)));
verifyTrue(t,all(valid(:)<=legacy(:)));
end
