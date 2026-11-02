function tests=test_export_range
tests=functiontests(localfunctions);
end
function testReviewBeforeWrite(t)
root=tempname; mkdir(root); clean=onCleanup(@()rmdir(root,'s')); %#ok<NASGU>
imwrite(uint8([0 100;200 255]),fullfile(root,'a.png'));
s=captureedit.loadSources(root,struct('thorcam','a.png'));
n=struct('id','gain','type','brightness','enabled',true,'params',struct('gain',2,'offset',0));
p=captureedit.preflightExport(s,struct('thorcam',n),{'thorcam'},struct('processingPolicy','preserve'));
verifyTrue(t,p.hasClipping); verifyEqual(t,p.images(1).conversion.highCount,2);
verifyError(t,@()captureedit.writeExport(p,fullfile(root,'bad')),'captureedit:ExportClipping');
verifyFalse(t,isfolder(fullfile(root,'bad')));
p=captureedit.convertExportPlan(p,'floating-mat');
r=captureedit.writeExport(p,fullfile(root,'float'));
a=load(fullfile(r.directory,'thorcam_edited.mat'));
verifyEqual(t,a.image,double(s.thorcam.image)*2);
re=captureedit.loadSources(root,struct('thorcam','float/thorcam_edited.mat'));
verifyEqual(t,re.thorcam.image,a.image);
m=jsondecode(fileread(r.manifestPath)); verifyEqual(t,m.schemaVersion,2);
end
function testFrozenAndExplicitClipping(t)
root=tempname; mkdir(root); clean=onCleanup(@()rmdir(root,'s')); %#ok<NASGU>
imwrite(uint8([0 100;200 255]),fullfile(root,'a.png'));
s=captureedit.loadSources(root,struct('thorcam','a.png'));
n=struct('id','gain','type','brightness','enabled',true,'params',struct('gain',2,'offset',-.1));
p=captureedit.preflightExport(s,struct('thorcam',n),{'thorcam'},struct('processingPolicy','preserve'));
verifyEqual(t,p.images(1).conversion.lowCount,1);
p.options.allowClipping=true;
r=captureedit.writeExport(p,fullfile(root,'out'));
verifyEqual(t,imread(fullfile(r.directory,'thorcam_edited.png')),uint8([0 175;255 255]));
end
function testSingleOverflowAndPrecision(t)
root=tempname; mkdir(root); clean=onCleanup(@()rmdir(root,'s')); %#ok<NASGU>
average_rectified_global_image=single([0 realmax('single');1 2]); %#ok<NASGU>
save(fullfile(root,'a.mat'),'average_rectified_global_image');
s=captureedit.loadSources(root,struct('global','a.mat'));
n=struct('id','gain','type','brightness','enabled',true,'params',struct('gain',2,'offset',0));
p=captureedit.preflightExport(s,struct('global',n),{'global'},struct('processingPolicy','preserve'));
verifyTrue(t,p.hasFloatOverflow);
verifyError(t,@()captureedit.writeExport(p,fullfile(root,'bad')),'captureedit:ExportFloatOverflow');
p=captureedit.convertExportPlan(p,'floating-mat');
verifyFalse(t,p.hasFloatOverflow); verifyTrue(t,all(isfinite(p.images.output(:))));
end
function testDisplayReviewAndFrozenData(t)
root=tempname; mkdir(root); clean=onCleanup(@()rmdir(root,'s')); %#ok<NASGU>
imwrite(uint8([0 100;200 255]),fullfile(root,'a.png'));
s=captureedit.loadSources(root,struct('global','a.png'));
p=captureedit.preflightExport(s,struct(),{'global'},struct('processingPolicy','preserve','outputMode','floating-mat','displayTiff',true));
verifyFalse(t,p.hasClipping); % Equal endpoints are valid.
verifyEqual(t,p.images.variable,'average_rectified_global_image');
s.global.image(:)=0; %#ok<NASGU> % Later editor state cannot affect frozen plan.
r=captureedit.writeExport(p,fullfile(root,'out'));
a=load(fullfile(r.directory,'global_edited.mat'));
verifyEqual(t,a.average_rectified_global_image,double([0 100;200 255]));
end
