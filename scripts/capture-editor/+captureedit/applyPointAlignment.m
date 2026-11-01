function geometry = applyPointAlignment(sources,geometry,role,points)
%APPLYPOINTALIGNMENT Atomically stage fit, provenance, and a fully valid crop.
if ~ismember(role,{'thorcam','validation'}) || ~isfield(sources,role)
 error('captureedit:MissingCamera','Choose a loaded camera to align.');
end
preparation=geometry.cameraPreparation.(role);
moving=imrotate(double(sources.(role).image),preparation.rotationDegrees);
if preparation.flipVertical, moving=flipud(moving); end
fit=captureedit.fitPointAlignment(points,size(moving));
preferred=geometry.registration.crop;
geometry.cameraPreparation.(role).downsampleFactor=fit.scale;
geometry.registration.savedTransforms.([role 'RotationDegrees'])=fit.rotationDegrees;
geometry.registration.savedTransforms.([role 'TranslationXY'])=fit.translationXY;
geometry.registration.transformSource='saved';
geometry.registration.requireValidPixels=true;
geometry.registration.cropMode='intersection'; geometry.registration.requireExpectedCrop=false;
geometry.calibration.(role).pointPairs=points;
geometry.calibration.(role).alignmentFit=struct('method','similarity', ...
 'preparation',geometry.cameraPreparation.(role),'pointPairs',points, ...
 'orientedSize',size(moving),'parameters',fit);
geometry=captureedit.resolveGeometry(sources,geometry,false);
images=struct(); roles=fieldnames(sources);
for k=1:numel(roles), images.(roles{k})=sources.(roles{k}).image; end
full=geometry; full.registration.crop=[];
[~,mask]=captureedit.comparisonPanels(images,full);
geometry.registration.crop=captureedit.validCrop(mask,preferred);
geometry.registration.cropMode='saved';
end
