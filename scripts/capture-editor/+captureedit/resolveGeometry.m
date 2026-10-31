function geometry = resolveGeometry(sources,recipe,estimate)
%RESOLVEGEOMETRY Freeze original-only transforms, matching trio geometry rules.
if nargin<2, recipe=[]; end
if nargin<3, estimate=false; end
if ~isfield(sources,'global'), error('captureedit:MissingReference','Load global to enable aligned comparisons.'); end
roles=fieldnames(sources); images=struct();
for k=1:numel(roles)
 name=roles{k};
 images.(name)=sources.(name).image;
end
if isfield(images,'local') && ~isequal(size(images.global),size(images.local)), error('captureedit:GridMismatch','Global and local must share a grid.'); end
referenceSize=size(images.global);
if isempty(recipe)
 geometry=struct('referenceSize',referenceSize,'cameraPreparation',struct(),'registration',struct());
 geometry.cameraPreparation.thorcam=struct('rotationDegrees',-90,'flipVertical',true,'downsampleFactor',1);
 geometry.cameraPreparation.validation=struct('rotationDegrees',-90,'flipVertical',false,'downsampleFactor',1);
 for role={'thorcam','validation'}
  name=role{1}; if ~isfield(images,name), continue; end; prep=geometry.cameraPreparation.(name);
  oriented=imrotate(images.(name),prep.rotationDegrees);
  if prep.flipVertical, oriented=flipud(oriented); end
  geometry.cameraPreparation.(name).downsampleFactor=min(1,median([referenceSize(1)/size(oriented,1),referenceSize(2)/size(oriented,2)]));
 end
 geometry.registration=struct('transformSource','saved','rotationStartDegrees',-2, ...
 'rotationStopDegrees',2,'rotationStepDegrees',.25,'rotationInterpolation','bilinear', ...
 'cropMode','intersection','requireExpectedCrop',false,'crop',[], ...
 'savedTransforms',struct('thorcamRotationDegrees',0,'thorcamTranslationXY',[0 0], ...
 'validationRotationDegrees',0,'validationTranslationXY',[0 0]));
else
 geometry=struct('referenceSize',referenceSize,'cameraPreparation',recipe.cameraPreparation,'registration',recipe.registration);
end
if estimate || strcmp(geometry.registration.transformSource,'automatic')
 fixed=double(images.global); reg=geometry.registration;
 angles=reg.rotationStartDegrees:reg.rotationStepDegrees:reg.rotationStopDegrees;
 if isempty(angles) || numel(angles)>2001, error('captureedit:Angles','Invalid rotation search range.'); end
 for role={'thorcam','validation'}
  name=role{1}; if ~isfield(images,name), continue; end; s=geometry.cameraPreparation.(name); moving=imrotate(double(images.(name)),s.rotationDegrees);
  if s.flipVertical, moving=flipud(moving); end
  factor=s.downsampleFactor; validateattributes(factor,{'numeric'},{'scalar','positive','finite'});
  moving=imresize(imgaussfilt(moving,1/factor/2),factor,'bilinear'); best=-Inf;
  for angle=angles
   candidate=imrotate(moving,angle,reg.rotationInterpolation,'crop');
   correlation=normxcorr2(candidate,fixed); peak=max(correlation(:));
   if isfinite(peak) && peak>best
    best=peak; [row,col]=find(correlation==peak,1);
    geometry.registration.savedTransforms.([name 'RotationDegrees'])=angle;
    geometry.registration.savedTransforms.([name 'TranslationXY'])=[col-size(candidate,2),row-size(candidate,1)];
   end
  end
  if ~isfinite(best), error('captureedit:Alignment','No finite correlation peak; use manual alignment.'); end
 end
end
if ~isfield(geometry,'calibration'), geometry.calibration=struct(); end
if ~isempty(recipe) && isfield(recipe,'calibration'), geometry.calibration=recipe.calibration; end
for role={'thorcam','validation'}
 name=role{1};
 if ~isfield(geometry.calibration,name)
  geometry.calibration.(name)=struct('pointPairs',struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2)));
 end
end
geometry.participants=roles(:);
geometry.registration.transformSource='saved'; savedCrop=geometry.registration.crop;
geometry.registration.crop=[];
[~,mask]=captureedit.comparisonPanels(images,geometry);
[rows,cols]=find(mask); if isempty(rows), error('captureedit:NoOverlap','Camera images have no common field.'); end
bounds=struct('rowStartOneBased',min(rows),'columnStartOneBased',min(cols),'height',max(rows)-min(rows)+1,'width',max(cols)-min(cols)+1);
if strcmp(geometry.registration.cropMode,'saved') && ~isempty(savedCrop)
 geometry.registration.crop=savedCrop;
else
 if isfield(geometry.registration,'requireExpectedCrop') && geometry.registration.requireExpectedCrop && ~isempty(savedCrop) && ~isequal(bounds,savedCrop)
  error('captureedit:UnexpectedCrop','Calculated common crop differs from the imported recipe.');
 end
 geometry.registration.crop=bounds;
end
c=geometry.registration.crop;
if c.rowStartOneBased<bounds.rowStartOneBased || c.columnStartOneBased<bounds.columnStartOneBased || c.rowStartOneBased+c.height>bounds.rowStartOneBased+bounds.height || c.columnStartOneBased+c.width>bounds.columnStartOneBased+bounds.width
 error('captureedit:InvalidCrop','Crop is outside the common field bounds.');
end
end
