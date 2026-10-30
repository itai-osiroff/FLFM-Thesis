function sources = loadSources(root, paths)
%LOADSOURCES Read immutable supported sources and freeze intensity mappings.
root=char(java.io.File(root).getCanonicalPath()); sources=struct();
roles={'thorcam','validation','global','local'};
for k=1:numel(roles)
    role=roles{k};
    if ~isfield(paths,role) || isempty(paths.(role)), continue; end
    path=char(paths.(role));
    if ~isfile(path), path=fullfile(root,path); end
    path=char(java.io.File(path).getCanonicalPath());
    prefix=[root filesep];
    if ~startsWith(lower(path),lower(prefix)), error('captureedit:InvalidSource','Sources must be inside dataRoot.'); end
    [~,~,extension]=fileparts(path); variable=''; info=struct();
    switch lower(extension)
        case '.mat'
            if strcmp(role,'global'), variable='average_rectified_global_image';
            elseif strcmp(role,'local'), variable='average_rectified_image';
            else, error('captureedit:InvalidSource','MAT sources are supported for global/local roles.'); end
            values=load(path,variable);
            if ~isfield(values,variable), error('captureedit:InvalidSource','Missing variable %s.',variable); end
            image=values.(variable); format='mat';
            if ~isa(image,'single') && ~isa(image,'double'), error('captureedit:InvalidSource','MAT reconstruction arrays must be single or double.'); end
        case {'.tif','.tiff','.png'}
            info=imfinfo(path);
            if numel(info)~=1 || ~strcmpi(info.ColorType,'grayscale')
                error('captureedit:InvalidSource','Only single-plane grayscale images are supported.');
            end
            image=imread(path); format=lower(extension(2:end));
            if ~isa(image,'uint8') && ~isa(image,'uint16'), error('captureedit:InvalidSource','Raster images must be uint8 or uint16.'); end
            if info.BitDepth~=8 && info.BitDepth~=16, error('captureedit:InvalidSource','Only 8-bit and 16-bit rasters are supported.'); end
        otherwise, error('captureedit:InvalidSource','Unsupported extension %s.',extension);
    end
    if ~isnumeric(image) || ~isreal(image) || ~ismatrix(image) || isempty(image) || any(~isfinite(image(:)))
        error('captureedit:InvalidSource','Source must contain a finite real 2D image.');
    end
    if isinteger(image), range=[double(intmin(class(image))) double(intmax(class(image)))];
    else, range=safeRange([min(image(:)) max(image(:))]); end
    sources.(role)=struct('image',image,'path',path,'relativePath',path(numel(prefix)+1:end), ...
        'hash',captureedit.sha256(path),'variable',variable,'format',format,'info',info, ...
        'range',double(range),'displayRange',double(safeRange([min(image(:)) max(image(:))])));
end
if isfield(sources,'global') && isfield(sources,'local')
    a=sources.global.image; b=sources.local.image;
    if ~isequal(size(a),size(b)), error('captureedit:InvalidSource','Global/local images must have equal dimensions.'); end
    joint=safeRange([double(min(a(:))) double(min(b(:))) double(max(a(:))) double(max(b(:)))]);
    sources.global.displayRange=joint; sources.local.displayRange=joint;
    if isfloat(a) && isfloat(b), sources.global.range=joint; sources.local.range=joint; end
end
end
function r=safeRange(values)
r=double([min(values) max(values)]);
if r(2)<=r(1), r(2)=r(1)+max(1,abs(r(1))*eps*2); end
end
