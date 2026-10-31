function tests=test_capture_core
tests=functiontests(localfunctions);
end
function setupOnce(t)
addpath(fileparts(fileparts(mfilename('fullpath'))));
t.TestData.root=tempname; mkdir(t.TestData.root);
end
function teardownOnce(t)
rmdir(t.TestData.root,'s');
end
function testIdentityAndDisabled(t)
x=uint16(reshape(0:99,10,10)); n=node('brightness'); n.enabled=false;
verifyEqual(t,captureedit.evaluate(x,n,[0 65535]),x);
verifyEqual(t,captureedit.evaluate(x,struct([]),[0 65535]),x);
end
function testThresholdAndOrder(t)
x=uint8([0 50 100 200 255]); a=node('threshold'); a.params.cutoff=.3;
verifyEqual(t,captureedit.evaluate(x,a,[0 255]),uint8([0 0 100 200 255]));
b=node('brightness'); b.params.gain=2;
verifyNotEqual(t,captureedit.evaluate(x,[a b],[0 255]),captureedit.evaluate(x,[b a],[0 255]));
a.params.binary=1;
verifyEqual(t,captureedit.evaluate(x,a,[0 255]),uint8([0 0 255 255 255]));
end
function testFiltersPreserveConstantAndShape(t)
defs=captureedit.catalog(); x=ones(17,19)*.4;
for k=1:numel(defs)
    a=node(defs(k).type); out=captureedit.evaluate(x,a,[0 1]);
    verifySize(t,out,size(x)); verifyClass(t,out,'double'); verifyTrue(t,all(isfinite(out(:))));
    if ismember(a.type,{'gaussian','mean','median','unsharp','laplacian'})
        verifyEqual(t,out,x,'AbsTol',1e-12);
    end
end
end
function testInvalidKernelAndWindow(t)
a=node('median'); a.params.size=4;
verifyError(t,@()captureedit.evaluate(zeros(3),a,[0 1]),'captureedit:InvalidParameter');
a=node('window'); a.params.black=.8; a.params.white=.2;
verifyError(t,@()captureedit.evaluate(zeros(3),a,[0 1]),'captureedit:InvalidParameter');
end
function testNativeRoundTrips(t)
root=t.TestData.root;
imwrite(uint16(reshape(0:119,10,12)),fullfile(root,'thor.tiff'));
imwrite(uint8(reshape(0:119,10,12)),fullfile(root,'val.png'));
average_rectified_global_image=reshape(linspace(-3,10,120),10,12); %#ok<NASGU>
average_rectified_image=single(ones(10,12)*5); %#ok<NASGU>
save(fullfile(root,'arrays.mat'),'average_rectified_global_image','average_rectified_image');
s=captureedit.loadSources(root,struct('thorcam','thor.tiff','validation','val.png','global','arrays.mat','local','arrays.mat'));
verifyEqual(t,s.global.range,s.local.range);
result=captureedit.exportImages(s,struct(),fieldnames(s),fullfile(root,'export'),struct(),true);
verifyTrue(t,isfile(result.manifestPath));
verifyEqual(t,imread(fullfile(result.directory,'thorcam_edited.tiff')),s.thorcam.image);
v=load(fullfile(result.directory,'local_edited.mat')); verifyEqual(t,v.average_rectified_image,s.local.image);
verifyEqual(t,captureedit.sha256(s.thorcam.path),s.thorcam.hash);
verifyError(t,@()captureedit.exportImages(s,struct(),{'thorcam'},result.directory),'captureedit:InvalidExport');
imwrite(uint16(ones(10,12)),s.thorcam.path);
verifyError(t,@()captureedit.exportImages(s,struct(),{'thorcam'},fullfile(root,'bad')),'captureedit:ChangedSource');
verifyFalse(t,isfolder(fullfile(root,'bad')));
end
function n=node(type)
c=captureedit.catalog(); d=c(strcmp({c.type},type));
n=struct('id',type,'type',type,'enabled',true,'params',d.params);
end
function testAdditionalRasterFormatsAndProvenance(t)
root=t.TestData.root;
imwrite(uint16(reshape(1:120,10,12)),fullfile(root,'wide.png'));
imwrite(uint8(reshape(1:120,10,12)),fullfile(root,'small.tif'),'Resolution',123);
s=captureedit.loadSources(root,struct('global','wide.png','local','small.tif'));
result=captureedit.exportImages(s,struct(),{'global','local'},fullfile(root,'export2'));
verifyEqual(t,imread(fullfile(result.directory,'global_edited.png')),s.global.image);
info=imfinfo(fullfile(result.directory,'local_edited.tif'));
verifyEqual(t,info.XResolution,123);
m=jsondecode(fileread(result.manifestPath));
verifyEqual(t,m.images(1).relativePath,'wide.png');
verifyEqual(t,m.images(1).displayRange(:)',s.global.displayRange);
verifyTrue(t,isfield(m,'workingTreeDirty'));
end
function testFloatConstantAndDisplayTiffRecord(t)
root=t.TestData.root;
average_rectified_global_image=ones(7)*8; %#ok<NASGU>
average_rectified_image=single(ones(7)*8); %#ok<NASGU>
save(fullfile(root,'constant.mat'),'average_rectified_global_image','average_rectified_image');
s=captureedit.loadSources(root,struct('global','constant.mat','local','constant.mat'));
n=node('gamma'); n.params.gamma=2;
verifyEqual(t,captureedit.evaluate(s.global.image,n,s.global.range),s.global.image);
r=captureedit.exportImages(s,struct(),{'global'},fullfile(root,'export3'),struct(),true);
m=jsondecode(fileread(r.manifestPath));
verifyEqual(t,m.images.displayHash,captureedit.sha256(fullfile(r.directory,m.images.displayFilename)));
end
function testMixedNumericDisplayRange(t)
root=t.TestData.root;
imwrite(uint16(ones(7)*100),fullfile(root,'mixed.tif'));
average_rectified_image=ones(7)*-1.5; %#ok<NASGU>
save(fullfile(root,'mixed.mat'),'average_rectified_image');
s=captureedit.loadSources(root,struct('global','mixed.tif','local','mixed.mat'));
verifyEqual(t,s.global.displayRange,[-1.5 100]);
end
