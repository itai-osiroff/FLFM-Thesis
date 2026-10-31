function tests=test_advanced_filters
tests=functiontests(localfunctions);
end
function setupOnce(~)
addpath(fileparts(fileparts(mfilename('fullpath'))));
end
function testBackgroundSubtractsConstantAndPreservesPeak(t)
x=ones(31,33)*.2; x(16,17)=.9; n=node('background'); n.params.radius=4;
y=captureedit.evaluate(x,n,[0 1]);
verifyEqual(t,y(1,1),0,'AbsTol',1e-12);
verifyEqual(t,y(16,17),.7,'AbsTol',1e-12);
n.params.strength=0; verifyEqual(t,captureedit.evaluate(x,n,[0 1]),x);
end
function testClaheMatchesExplicitReference(t)
x=reshape(linspace(.1,.8,32*34),32,34); n=node('clahe');
expected=adapthisteq(x,'NumTiles',[8 8],'ClipLimit',.01,'NBins',256,'Distribution','uniform','Range','full');
verifyEqual(t,captureedit.evaluate(x,n,[0 1]),expected,'AbsTol',1e-12);
end
function testBilateralMatchesReferenceAndScaledPixels(t)
x=repmat([zeros(1,12) ones(1,12)*.8],24,1); x(8,8)=.1; n=node('bilateral');
expected=imbilatfilt(x,.05^2,2,'Padding','replicate');
verifyEqual(t,captureedit.evaluate(x,n,[0 1]),expected,'AbsTol',1e-12);
expected=imbilatfilt(x,.05^2,1,'Padding','replicate');
verifyEqual(t,captureedit.evaluate(x,n,[0 1],.5),expected,'AbsTol',1e-12);
end
function testBackgroundProxyScalesNativeRadius(t)
x=repmat(linspace(.1,.4,21),19,1); x(10,11)=.9;
n=node('background'); n.params.radius=8;
padded=padarray(x,[4 4],'replicate'); expected=imopen(padded,strel('disk',4,0));
expected=max(0,x-expected(4+(1:19),4+(1:21)));
verifyEqual(t,captureedit.evaluate(x,n,[0 1],.5),expected,'AbsTol',1e-12);
end
function testInvalidAdvancedParameters(t)
n=node('background'); n.params.radius=2.5;
verifyError(t,@()captureedit.evaluate(zeros(8),n,[0 1]),'captureedit:InvalidParameter');
n=node('clahe'); n.params.tiles=3.5;
verifyError(t,@()captureedit.evaluate(zeros(8),n,[0 1]),'captureedit:InvalidParameter');
n=node('bilateral'); n.params.intensitySigma=0;
verifyError(t,@()captureedit.evaluate(zeros(8),n,[0 1]),'captureedit:InvalidParameter');
end
function testClassesTinyArraysAndDisabledIdentity(t)
for type={'background','clahe','bilateral'}
 n=node(type{1});
 for x={uint8([0 60;120 255]),uint16(ones(5)*30000),single(ones(7)*.4),ones(1,5)*.2}
  a=x{1}; r=[0 1]; if isinteger(a), r=[0 double(intmax(class(a)))]; end
  y=captureedit.evaluate(a,n,r); verifyClass(t,y,class(a)); verifySize(t,y,size(a)); verifyTrue(t,all(isfinite(y(:))));
  verifyEqual(t,captureedit.evaluate(a,n,r),y);
  off=n; off.enabled=false; verifyEqual(t,captureedit.evaluate(a,off,r),a);
 end
end
n=node('clahe'); x=single([.1 .2;.3 .4]); verifyEqual(t,captureedit.evaluate(x,n,[0 1]),x);
end
function n=node(type)
c=captureedit.catalog(); d=c(strcmp({c.type},type));
assert(~isempty(d),'Advanced filter missing: %s',type);
n=struct('id',type,'type',type,'enabled',true,'params',d.params);
end
