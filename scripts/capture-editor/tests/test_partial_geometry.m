function tests=test_partial_geometry
tests=functiontests(localfunctions);
end
function testGlobalLocalOnly(testCase)
x=reshape(1:120,10,12); sources=struct('global',struct('image',x),'local',struct('image',x+1));
g=captureedit.resolveGeometry(sources,[],false);
[p,m]=captureedit.comparisonPanels(struct('global',x,'local',x+1),g);
verifyEqual(testCase,p.global,double(x)); verifyTrue(testCase,all(m(:)));
verifyEqual(testCase,g.participants,{'global';'local'});
end
function testOneCamera(testCase)
x=reshape(1:120,10,12); sources=struct('global',struct('image',x),'thorcam',struct('image',x));
g=captureedit.resolveGeometry(sources,[],false);
[p,m]=captureedit.comparisonPanels(struct('global',x,'thorcam',x),g);
verifyTrue(testCase,isfield(p,'thorcam')); verifyFalse(testCase,isfield(p,'validation')); verifyTrue(testCase,any(m(:)));
end
function testMissingReference(testCase)
verifyError(testCase,@() captureedit.resolveGeometry(struct('thorcam',struct('image',ones(10))),[],false),'captureedit:MissingReference');
end
function testMismatchedLocal(testCase)
s=struct('global',struct('image',ones(10)),'local',struct('image',ones(11)));
verifyError(testCase,@() captureedit.resolveGeometry(s,[],false),'captureedit:GridMismatch');
end
