function tests=test_range_policy
tests=functiontests(localfunctions);
end
function setupOnce(~)
addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testPreserveInverseAndIdentity(t)
a=node('brightness'); a.params.gain=2; b=a; b.params.gain=.5;
x=[.1 .4 .6 .9];
verifyEqual(t,captureedit.evaluate(x,[a b],[0 1],1,'preserve'),x,'AbsTol',1e-15);
verifyEqual(t,captureedit.evaluate(x,[a b],[0 1]),[.1 .4 .5 .5]);
u=uint16([0 32 65535]); verifyEqual(t,captureedit.evaluate(u,struct([]),[0 65535],1,'preserve'),u);
verifyClass(t,captureedit.evaluate(u,a,[0 65535],1,'preserve'),'double');
end
function testClipAndWindow(t)
a=node('window'); a.params.black=.2; a.params.white=.8;
[y,~,d]=captureedit.evaluate([0 .2 .8 1],a,[0 1],1,'preserve');
verifyLessThan(t,y(1),0); verifyGreaterThan(t,y(4),1);
verifyEqual(t,d.stages.belowCount,1); verifyEqual(t,d.stages.aboveCount,1);
b=node('clip'); [z,~,d]=captureedit.evaluate([0 .2 .8 1],[a b],[0 1],1,'preserve');
verifyEqual(t,z,[0 0 1 1],'AbsTol',1e-15);
verifyEqual(t,d.stages(2).clippedLowCount,1); verifyEqual(t,d.stages(2).clippedHighCount,1);
[~,~,d]=captureedit.evaluate([0 1],b,[0 1],1,'preserve');
verifyEqual(t,d.stages.clippedLowCount,0); verifyEqual(t,d.stages.clippedHighCount,0);
b.params.lower=.8; b.params.upper=.2;
verifyError(t,@()captureedit.evaluate([0 1],b,[0 1],1,'preserve'),'captureedit:InvalidParameter');
end
function testDomainAndNonfinite(t)
a=node('gamma'); a.params.gamma=.5;
verifyError(t,@()captureedit.evaluate([-.1 .5],a,[0 1],1,'preserve'),'captureedit:FilterDomain');
a.params.gamma=1; verifyEqual(t,captureedit.evaluate([-.1 .5],a,[0 1],1,'preserve'),[-.1 .5]);
a=node('clahe'); verifyError(t,@()captureedit.evaluate(ones(8)*1.1,a,[0 1],1,'preserve'),'captureedit:FilterDomain');
a.params.amount=0; verifyEqual(t,captureedit.evaluate(ones(8)*1.1,a,[0 1],1,'preserve'),ones(8)*1.1);
a=node('brightness'); a.params.gain=5;
verifyError(t,@()captureedit.evaluate(ones(2)*realmax,a,[0 1],1,'preserve'),'captureedit:NonfiniteResult');
end
function testSharpenAndThreshold(t)
x=repmat([ones(1,8)*.05 ones(1,8)*.95],16,1); a=node('laplacian');
y=captureedit.evaluate(x,a,[0 1],1,'preserve'); verifyLessThan(t,min(y(:)),0); verifyGreaterThan(t,max(y(:)),1);
a=node('threshold'); [~,~,d]=captureedit.evaluate([0 .05 .5],a,[0 1],1,'preserve');
verifyEqual(t,d.stages.thresholdAffectedCount,1); verifyEqual(t,d.stages.clippedLowCount,0);
end
function n=node(type)
c=captureedit.catalog(); d=c(strcmp({c.type},type));
n=struct('id',type,'type',type,'enabled',true,'params',d.params);
end
