function plan=preflightExport(sources,stacks,roles,options)
%PREFLIGHTEXPORT Evaluate once and freeze all selected roles before file creation.
if nargin<4, options=struct(); end
options=defaults(options);
if ischar(roles)||isstring(roles), roles=cellstr(roles); end
if isempty(roles), error('captureedit:InvalidExport','Select at least one image.'); end
if numel(unique(roles))~=numel(roles), error('captureedit:InvalidExport','Duplicate roles are not supported.'); end
items=struct('role',{},'source',{},'stack',{},'raw',{},'output',{},'diagnostics',{},'conversion',{},'displayConversion',{},'format',{},'variable',{});
for k=1:numel(roles)
 role=roles{k};
 if ~isfield(sources,role), error('captureedit:InvalidExport','Missing role %s.',role); end
 source=sources.(role);
 if ~isfile(source.path)||~strcmp(source.hash,captureedit.sha256(source.path)), error('captureedit:ChangedSource','Source changed since loading: %s',source.path); end
 stack=struct([]); if isfield(stacks,role), stack=stacks.(role); end
 [raw,~,diagnostics]=captureedit.evaluate(source.image,stack,source.range,1,options.processingPolicy);
 if any(~isfinite(raw(:))), error('captureedit:ExportNonfinite','Cannot export nonfinite values.'); end
 items(end+1)=struct('role',role,'source',source,'stack',stack,'raw',raw,'output',[], ...
 'diagnostics',diagnostics,'conversion',struct(),'displayConversion',struct(),'format','','variable',''); %#ok<AGROW>
end
plan=struct('images',items,'sources',sources,'options',options,'hasClipping',false,'hasFloatOverflow',false);
plan=captureedit.convertExportPlan(plan,options.outputMode);
end
function options=defaults(options)
d=struct('processingPolicy','legacy-clamp','outputMode','native','displayTiff',false,'allowClipping',false,'geometry',struct());
names=fieldnames(d); for k=1:numel(names), if ~isfield(options,names{k}), options.(names{k})=d.(names{k}); end, end
if ~ismember(options.processingPolicy,{'legacy-clamp','preserve'}), error('captureedit:ProcessingPolicy','Unknown processing policy.'); end
validateattributes(options.displayTiff,{'logical','numeric'},{'scalar','binary'});
validateattributes(options.allowClipping,{'logical','numeric'},{'scalar','binary'});
end
