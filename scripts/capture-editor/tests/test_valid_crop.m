function tests=test_valid_crop
tests=functiontests(localfunctions);
end
function setupOnce(~)
addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testMaximumRectangleExcludesInvalidCorners(t)
mask=logical([0 1 1 1 0;1 1 1 1 1;1 1 1 1 1;0 1 1 1 0]);
c=captureedit.validCrop(mask,[]);
verifyEqual(t,c,struct('rowStartOneBased',1,'columnStartOneBased',2,'height',4,'width',3));
verifyTrue(t,captureedit.isValidCrop(mask,c));
end
function testPreservesPreferredCropOnlyWhenEveryPixelIsValid(t)
mask=true(8); mask(4,4)=false;
preferred=struct('rowStartOneBased',1,'columnStartOneBased',1,'height',3,'width',3);
[c,preserved]=captureedit.validCrop(mask,preferred); verifyTrue(t,preserved); verifyEqual(t,c,preferred);
preferred.height=5; preferred.width=5;
[c,preserved]=captureedit.validCrop(mask,preferred); verifyFalse(t,preserved); verifyTrue(t,captureedit.isValidCrop(mask,c));
end
function testTopThenLeftTieBreakAndDisconnectedMasks(t)
mask=false(6,8); mask(1:2,5:6)=true; mask(4:5,1:2)=true;
c=captureedit.validCrop(mask,[]); verifyEqual(t,[c.rowStartOneBased c.columnStartOneBased c.height c.width],[1 5 2 2]);
mask(1:2,1:2)=true; c=captureedit.validCrop(mask,[]);
verifyEqual(t,[c.rowStartOneBased c.columnStartOneBased],[1 1]);
end
function testThinAndEmptyOverlap(t)
c=captureedit.validCrop(logical([0 1 1 1 0]),[]);
verifyEqual(t,[c.rowStartOneBased c.columnStartOneBased c.height c.width],[1 2 1 3]);
verifyError(t,@() captureedit.validCrop(false(4),[]),'captureedit:NoOverlap');
end
function testRejectsOutsideAndFractionalCrop(t)
mask=true(5);
for values={[0 1 2 2],[1 1 6 2],[1 1 2.5 2],[NaN 1 2 2]}
 v=values{1}; c=struct('rowStartOneBased',v(1),'columnStartOneBased',v(2),'height',v(3),'width',v(4));
 verifyFalse(t,captureedit.isValidCrop(mask,c));
end
end
function testMatchesExhaustiveSmallMasks(t)
% An independent exhaustive oracle catches histogram-stack corner cases.
rng(19);
for trial=1:30
 mask=rand(5,6)>.35; best=[Inf Inf 0 0]; area=0;
 for r=1:5, for c=1:6, for h=1:6-r, for w=1:7-c
  block=mask(r:r+h-1,c:c+w-1);
  if all(block(:)) && (h*w>area || (h*w==area && (r<best(1) || (r==best(1) && c<best(2)))))
   best=[r c h w]; area=h*w;
  end
 end, end, end, end
 out=captureedit.validCrop(mask,[]);
 verifyEqual(t,out.height*out.width,area);
 verifyEqual(t,[out.rowStartOneBased out.columnStartOneBased],best(1:2));
end
end
