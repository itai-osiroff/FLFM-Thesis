function result=exportImages(sources,stacks,roles,destination,geometry,displayTiff,options)
%EXPORTIMAGES Compatibility wrapper over preflight and frozen export writing.
if nargin<5, geometry=struct(); end
if nargin<6, displayTiff=false; end
if nargin<7, options=struct(); end
options.geometry=geometry; options.displayTiff=displayTiff;
plan=captureedit.preflightExport(sources,stacks,roles,options);
result=captureedit.writeExport(plan,destination);
end
