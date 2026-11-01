function tests=test_point_alignment
tests=functiontests(localfunctions);
end
function setupOnce(~)
addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testFitsCompleteSimilarityInsteadOfKeepingOldTranslation(t)
points=struct('movingXY',[1 1;21 1;1 21], ...
 'referenceXY',[20 30;30 30;20 40]);
fit=captureedit.fitPointAlignment(points,[40 60]);
verifyEqual(t,fit.scale,.5,'AbsTol',1e-12);
verifyEqual(t,fit.rotationDegrees,0,'AbsTol',1e-12);
verifyEqual(t,fit.translationXY,[19.25 29.25],'AbsTol',1e-12);
verifyLessThan(t,fit.rmsErrorPixels,1e-12);
end
function testRotationUpsamplingAndNonSquarePixelCenters(t)
% 90 degrees counterclockwise about the resized 12-by-18 image center,
% followed by [5 7]. These literal pairs include the half-pixel resize offset.
points=struct('movingXY',[2 2;4 2;2 4], ...
 'referenceXY',[13 18;13 12;19 18]);
fit=captureedit.fitPointAlignment(points,[4 6]);
verifyEqual(t,fit.scale,3,'AbsTol',1e-12);
verifyEqual(t,fit.rotationDegrees,90,'AbsTol',1e-12);
verifyEqual(t,fit.translationXY,[5 7],'AbsTol',1e-12);
end
function testNoisyExtraPairsUseAllPairs(t)
points=struct('movingXY',[0 0;10 0;0 10;10 10], ...
 'referenceXY',[3 4;13 4;3 14;14 15]);
fit=captureedit.fitPointAlignment(points,[20 20]);
verifyGreaterThan(t,fit.rmsErrorPixels,0);
verifyGreaterThanOrEqual(t,fit.maxErrorPixels,fit.rmsErrorPixels);
verifySize(t,fit.predictedReferenceXY,[4 2]);
verifyEqual(t,mean(fit.predictedReferenceXY,1),mean(points.referenceXY,1),'AbsTol',1e-12);
end
function testFractionalScaleUsesRequestedPixelMappingAndRoundedSize(t)
points=struct('movingXY',[2 3;8 3;2 6], ...
 'referenceXY',[6.825 5.905;6.825 1.525;9.015 5.905]);
fit=captureedit.fitPointAlignment(points,[7 11]);
verifyEqual(t,fit.scale,.73,'AbsTol',1e-12);
verifyEqual(t,fit.rotationDegrees,90,'AbsTol',1e-12);
verifyEqual(t,fit.translationXY,[3.5 -.5],'AbsTol',1e-12);
end
function testRejectsDegenerateAndNonfinitePairs(t)
cases={struct('movingXY',[1 1;1 1],'referenceXY',[1 1;2 2]), ...
 struct('movingXY',[1 1;2 2],'referenceXY',[1 1;1 1]), ...
 struct('movingXY',[1 1;NaN 2],'referenceXY',[1 1;2 2]), ...
 struct('movingXY',[1 1;2 2],'referenceXY',[1 1])};
for k=1:numel(cases)
 verifyError(t,@() captureedit.fitPointAlignment(cases{k},[20 20]),'captureedit:InvalidPoints');
end
end
function testPointFitUpdatesTransformAndPreservesValidCustomCrop(t)
image=reshape(1:10000,100,100); sources=struct('global',struct('image',image),'thorcam',struct('image',image));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
g.registration.savedTransforms.thorcamTranslationXY=[30 0];
g.registration.crop=struct('rowStartOneBased',20,'columnStartOneBased',40,'height',10,'width',10);
g.registration.cropMode='saved';
points=struct('movingXY',[10 10;30 10;10 30],'referenceXY',[20 25;40 25;20 45]);
out=captureedit.applyPointAlignment(sources,g,'thorcam',points);
verifyEqual(t,out.registration.savedTransforms.thorcamTranslationXY,[10 15],'AbsTol',1e-12);
verifyEqual(t,out.registration.crop,g.registration.crop);
verifyEqual(t,out.calibration.thorcam.alignmentFit.method,'similarity');
verifyEqual(t,out.calibration.thorcam.pointPairs,points);
end
function testFitPredictionAgreesWithRenderedImageAfterResizeAndRotation(t)
% Three isolated impulses, upsampled by an integer odd factor: source pixel
% centers map exactly to integer output centers, including a 90-degree turn.
image=zeros(4,6); image(2,2)=10; image(2,4)=20; image(3,3)=30;
sources=struct('global',struct('image',zeros(35,35)),'thorcam',struct('image',image));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
points=struct('movingXY',[2 2;4 2;3 3],'referenceXY',[13 18;13 12;16 15]);
out=captureedit.applyPointAlignment(sources,g,'thorcam',points); out.registration.crop=[];
panels=captureedit.comparisonPanels(struct('global',zeros(35),'thorcam',image),out);
for k=1:3
 xy=points.referenceXY(k,:); patch=panels.thorcam(xy(2)+(-1:1),xy(1)+(-1:1));
 verifyEqual(t,patch(2,2),max(patch(:)),'AbsTol',1e-10);
end
end
function testQuarterTurnMatchesRenderingWithMixedDimensionParity(t)
image=zeros(6,9); image(3,3)=1;
sources=struct('global',struct('image',zeros(20)),'thorcam',struct('image',image));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
% imrotate rotates the centered 6-by-6 subarray (columns 2:7), not the
% geometric center of the complete 6-by-9 array, at exactly 90 degrees.
points=struct('movingXY',[3 3;5 3;3 4],'referenceXY',[7 7;7 5;8 7]);
out=captureedit.applyPointAlignment(sources,g,'thorcam',points);
verifyEqual(t,out.registration.savedTransforms.thorcamTranslationXY,[3 2],'AbsTol',1e-12);
out.registration.crop=[];
p=captureedit.comparisonPanels(struct('global',zeros(20),'thorcam',image),out);
[~,index]=max(p.thorcam(:)); [row,col]=ind2sub(size(p.thorcam),index);
verifyEqual(t,[row col],[7 7]);
end
function testNoOverlapDoesNotProduceGeometry(t)
image=ones(10); sources=struct('global',struct('image',image),'thorcam',struct('image',image));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',false,'downsampleFactor',1);
points=struct('movingXY',[1 1;2 2],'referenceXY',[101 101;102 102]);
verifyError(t,@() captureedit.applyPointAlignment(sources,g,'thorcam',points),'captureedit:NoOverlap');
end
function testNewAlignmentExcludesPreparationRotationPadding(t)
sources=struct('global',struct('image',ones(40)),'thorcam',struct('image',ones(20)));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',30,'flipVertical',false,'downsampleFactor',1);
g.registration.cropMode='intersection'; g=captureedit.resolveGeometry(sources,g,false);
images=struct('global',ones(40),'thorcam',ones(20)); full=g; full.registration.crop=[];
[~,legacyMask]=captureedit.comparisonPanels(images,full);
full.registration.requireValidPixels=true;
[~,strictMask]=captureedit.comparisonPanels(images,full);
verifyLessThan(t,nnz(strictMask),nnz(legacyMask));
points=struct('movingXY',[10 10;15 10],'referenceXY',[10 10;15 10]);
out=captureedit.applyPointAlignment(sources,g,'thorcam',points);
verifyTrue(t,captureedit.isValidCrop(strictMask,out.registration.crop));
end
function testFitMetadataSurvivesSessionAndHistory(t)
root=tempname; mkdir(root); cleanup=onCleanup(@() rmdir(root,'s'));
imwrite(uint16(reshape(1:400,20,20)),fullfile(root,'image.tif'));
sources=captureedit.loadSources(root,struct('global','image.tif','thorcam','image.tif'));
g=captureedit.resolveGeometry(sources,[],false);
g.cameraPreparation.thorcam=struct('rotationDegrees',0,'flipVertical',true,'downsampleFactor',1);
points=struct('referenceXY',[5 5;10 5;5 10],'movingXY',[5 5;10 5;5 10]);
out=captureedit.applyPointAlignment(sources,g,'thorcam',points);
state=struct('stacks',struct('global',struct([]),'thorcam',struct([])),'geometry',g);
after=state; after.geometry=out; h=captureedit.editHistory('new');
[h,~]=captureedit.editHistory('commit',h,state,after);
path=fullfile(root,'session.json'); captureedit.saveSession(path,root,sources,after.stacks,out,h,struct());
[~,~,restored,h]=captureedit.loadSession(path,root);
verifyEqual(t,restored.calibration.thorcam.alignmentFit,out.calibration.thorcam.alignmentFit);
[h,undone]=captureedit.editHistory('undo',h,after); verifyEqual(t,undone.geometry,g);
[~,redone]=captureedit.editHistory('redo',h,undone); verifyEqual(t,redone.geometry,out);
end
