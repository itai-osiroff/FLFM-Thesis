function fit = fitPointAlignment(points,orientedSize)
%FITPOINTALIGNMENT Least-squares similarity in the editor's pixel coordinates.
% Points refer to the full reference and oriented, unscaled camera images.
% Positive rotation matches imrotate (counterclockwise; image Y points down).
if ~isstruct(points) || ~isfield(points,'referenceXY') || ~isfield(points,'movingXY')
 error('captureedit:InvalidPoints','Provide at least two complete, distinct point pairs.');
end
reference=double(points.referenceXY); moving=double(points.movingXY);
if ~isreal(reference) || ~isreal(moving) || size(reference,2)~=2 || ...
 ~isequal(size(reference),size(moving)) || size(reference,1)<2 || ...
 any(~isfinite(reference(:))) || any(~isfinite(moving(:)))
 error('captureedit:InvalidPoints','Provide at least two complete, finite point pairs.');
end
validateattributes(orientedSize,{'numeric'},{'numel',2,'integer','positive','finite'});
x=moving-mean(moving,1); y=reference-mean(reference,1);
energy=sum(x(:).^2); referenceEnergy=sum(y(:).^2);
if energy<=eps(max(1,sum(moving(:).^2))) || referenceEnergy<=eps(max(1,sum(reference(:).^2)))
 error('captureedit:InvalidPoints','Choose distinct features in both images.');
end
a=sum(x(:,1).*y(:,1)+x(:,2).*y(:,2))/energy;
b=sum(x(:,2).*y(:,1)-x(:,1).*y(:,2))/energy;
factor=hypot(a,b);
if ~isfinite(factor) || factor<=0
 error('captureedit:InvalidPoints','The pairs do not define a finite positive scale.');
end
angle=atan2d(b,a);
quarterTurn=90*round(angle/90);
if abs(angle-quarterTurn)<=32*eps(max(1,abs(angle))), angle=quarterTurn; end
rotation=[cosd(angle) sind(angle);-sind(angle) cosd(angle)];
% Roundoff at an exact resize-size boundary must not create an extra row or
% column (e.g. a fitted 1+eps instead of 1). Keep the change within 32 ulps.
for dimension=double(orientedSize(:).')
 boundary=round(factor*dimension)/dimension;
 if boundary>0 && abs(factor-boundary)<=32*eps(factor), factor=boundary; end
end
% imresize with a scalar uses that requested scale, and ceil for output size.
resizedSize=ceil(double(orientedSize(:).')*factor);
center=(fliplr(resizedSize)+1)/2;
% At exact quarter turns, imrotate(...,'crop') rotates a centered square
% subarray. Its center differs for nonsquare arrays with mixed size parity.
if rem(angle,90)==0 && mod(round(angle/90),2)~=0 && resizedSize(1)~=resizedSize(2)
 begin=(max(resizedSize)==resizedSize)*abs(diff(floor(resizedSize/2)));
 center=(min(resizedSize)+1)/2+fliplr(begin);
end
resized=(moving-.5)*factor+.5;
rotated=(resized-center)*rotation.'+center;
translation=mean(reference-rotated,1);
predicted=rotated+translation;
residual=sqrt(sum((predicted-reference).^2,2));
fit=struct('scale',factor,'rotationDegrees',angle,'translationXY',translation, ...
 'predictedReferenceXY',predicted,'residualPixels',residual, ...
 'rmsErrorPixels',sqrt(mean(residual.^2)),'maxErrorPixels',max(residual));
end
