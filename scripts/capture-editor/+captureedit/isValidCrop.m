function valid = isValidCrop(mask,crop)
%ISVALIDCROP A crop must contain exclusively shared, valid integer pixels.
valid=false;
keys={'rowStartOneBased','columnStartOneBased','height','width'};
if ~isstruct(crop) || ~isscalar(crop) || ~all(isfield(crop,keys)), return; end
v=[crop.rowStartOneBased crop.columnStartOneBased crop.height crop.width];
if ~isnumeric(v) || ~isreal(v) || numel(v)~=4 || any(~isfinite(v)) || any(v<1) || any(v~=floor(v)), return; end
lastRow=v(1)+v(3)-1; lastColumn=v(2)+v(4)-1;
if lastRow>size(mask,1) || lastColumn>size(mask,2), return; end
block=mask(v(1):lastRow,v(2):lastColumn);
valid=all(block(:));
end
