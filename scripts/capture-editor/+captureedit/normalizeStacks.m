function value = normalizeStacks(value)
%NORMALIZESTACKS Restore row-oriented state arrays after JSON decoding.
if ~isstruct(value), return; end
if isfield(value,'stacks')
 value.stacks=captureedit.normalizeStacks(value.stacks);
 if isfield(value,'displayRanges')
  names=fieldnames(value.displayRanges);
  for k=1:numel(names), name=names{k}; value.displayRanges.(name)=value.displayRanges.(name)(:).'; end
 end
 if isfield(value,'geometry') && ~isempty(value.geometry)
  value.geometry=normalizeGeometry(value.geometry);
 end
 return;
end
roles={'thorcam','validation','global','local'};
for k=1:numel(roles)
 role=roles{k}; if ~isfield(value,role), continue; end
 nodes=value.(role);
 if isempty(nodes), value.(role)=struct([]); continue; end
 if iscell(nodes), nodes=[nodes{:}]; end
 value.(role)=nodes(:).';
end
end
function g=normalizeGeometry(g)
if isstruct(g) && isfield(g,'calibration')
for role={'thorcam','validation'}
 name=role{1};
 if ~isfield(g.calibration,name), g.calibration.(name)=struct('pointPairs',struct('referenceXY',zeros(0,2),'movingXY',zeros(0,2))); end
 for key={'referenceXY','movingXY'}
  field=key{1};
  if isempty(g.calibration.(name).pointPairs.(field)), g.calibration.(name).pointPairs.(field)=zeros(0,2); end
 end
end
end
if isfield(g,'referenceSize'), g.referenceSize=g.referenceSize(:).'; end
if isfield(g,'registration') && isfield(g.registration,'savedTransforms')
 for name={'thorcamTranslationXY','validationTranslationXY'}
  field=name{1};
  if isfield(g.registration.savedTransforms,field)
   g.registration.savedTransforms.(field)=g.registration.savedTransforms.(field)(:).';
  end
 end
end
end
