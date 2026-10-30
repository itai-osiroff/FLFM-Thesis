function result = exportImages(sources, stacks, roles, destination, geometry, displayTiff)
%EXPORTIMAGES Stage, verify, then publish native images into a new directory.
if nargin<5, geometry=struct(); end
if nargin<6, displayTiff=false; end
if ischar(roles) || isstring(roles), roles=cellstr(roles); end
if isempty(roles), error('captureedit:InvalidExport','Select at least one image.'); end
destination=char(java.io.File(destination).getCanonicalPath());
if isfolder(destination) || isfile(destination)
    error('captureedit:InvalidExport','Choose a new destination folder.');
end
parent=fileparts(destination);
if ~isfolder(parent), error('captureedit:InvalidExport','Destination parent does not exist.'); end
stage=tempname(parent); mkdir(stage); cleanup=onCleanup(@()removeStage(stage));
records=struct('role',{},'filename',{},'hash',{},'sourceHash',{},'relativePath',{},'variable',{},'class',{},'dimensions',{},'range',{},'displayRange',{},'stack',{},'displayFilename',{},'displayHash',{});
for k=1:numel(roles)
    role=roles{k};
    if ~isfield(sources,role), error('captureedit:InvalidExport','Missing role %s.',role); end
    source=sources.(role);
    if ~strcmp(source.hash,captureedit.sha256(source.path))
        error('captureedit:ChangedSource','Source changed since loading: %s',source.path);
    end
    stack=struct([]); if isfield(stacks,role), stack=stacks.(role); end
    output=captureedit.evaluate(source.image,stack,source.range);
    filename=[role '_edited.' source.format]; path=fullfile(stage,filename);
    writeNative(path,output,source);
    if strcmp(source.format,'mat')
        stored=load(path,source.variable); restored=stored.(source.variable);
    else, restored=imread(path); end
    if ~isequaln(output,restored) || ~strcmp(class(output),class(restored))
        error('captureedit:ExportVerification','Export did not round-trip exactly: %s',filename);
    end
    displayFilename=''; displayHash='';
    if displayTiff && strcmp(source.format,'mat')
        view=(double(output)-source.displayRange(1))/diff(source.displayRange);
        displayFilename=[role '_display16.tiff']; displayPath=fullfile(stage,displayFilename);
        displayImage=uint16(round(min(max(view,0),1)*65535));
        imwrite(displayImage,displayPath);
        if ~isequal(imread(displayPath),displayImage)
            error('captureedit:ExportVerification','Display TIFF did not round-trip exactly.');
        end
        displayHash=captureedit.sha256(displayPath);
    end
    records(end+1)=struct('role',role,'filename',filename,'hash',captureedit.sha256(path), ...
        'sourceHash',source.hash,'relativePath',source.relativePath,'variable',source.variable,'class',class(output), ...
        'dimensions',size(output),'range',source.range,'displayRange',source.displayRange,'stack',stack, ...
        'displayFilename',displayFilename,'displayHash',displayHash); %#ok<AGROW>
end
[softwareRevision,workingTreeDirty]=revision();
manifest=struct('schemaVersion',1,'createdUtc',char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss'Z'")), ...
    'softwareRevision',softwareRevision,'workingTreeDirty',workingTreeDirty,'matlabVersion',version,'geometry',geometry,'images',records);
manifestPath=fullfile(stage,'capture-export.json');
fid=fopen(manifestPath,'w'); if fid<0, error('captureedit:ExportWrite','Cannot write manifest.'); end
closer=onCleanup(@()fclose(fid)); fprintf(fid,'%s',jsonencode(manifest,'PrettyPrint',true)); clear closer;
[ok,message]=movefile(stage,destination);
if ~ok, error('captureedit:ExportWrite','Could not publish export: %s',message); end
result=struct('directory',destination,'files',records,'manifestPath',fullfile(destination,'capture-export.json'));
end
function writeNative(path,image,source)
if strcmp(source.format,'mat')
    data=struct(); data.(source.variable)=image; save(path,'-struct','data','-v7.3');
elseif ismember(source.format,{'tif','tiff'})
    t=Tiff(path,'w'); closeTiff=onCleanup(@()t.close());
    tags=struct('ImageLength',size(image,1),'ImageWidth',size(image,2), ...
        'Photometric',Tiff.Photometric.MinIsBlack,'BitsPerSample',8*(1+isa(image,'uint16')), ...
        'SamplesPerPixel',1,'RowsPerStrip',min(size(image,1),64),'PlanarConfiguration',Tiff.PlanarConfiguration.Chunky, ...
        'Compression',Tiff.Compression.None,'SampleFormat',Tiff.SampleFormat.UInt);
    if isfield(source.info,'Orientation'), tags.Orientation=source.info.Orientation; end
    for field={'XResolution','YResolution'}
        name=field{1}; if isfield(source.info,name), tags.(name)=source.info.(name); end
    end
    if isfield(source.info,'ResolutionUnit')
        unit=source.info.ResolutionUnit;
        if isnumeric(unit), tags.ResolutionUnit=unit;
        elseif strcmpi(unit,'Inch'), tags.ResolutionUnit=Tiff.ResolutionUnit.Inch;
        elseif strcmpi(unit,'Centimeter'), tags.ResolutionUnit=Tiff.ResolutionUnit.Centimeter;
        end
    end
    t.setTag(tags); t.write(image); clear closeTiff;
else
    args={};
    if isfield(source.info,'XResolution') && isfield(source.info,'YResolution') && ...
            isfield(source.info,'ResolutionUnit') && strcmpi(source.info.ResolutionUnit,'meter')
        args={'XResolution',source.info.XResolution,'YResolution',source.info.YResolution,'ResolutionUnit','meter'};
    end
    imwrite(image,path,args{:});
end
end
function [value,dirty]=revision()
root=fileparts(fileparts(fileparts(fileparts(mfilename('fullpath')))));
[status,value]=system(sprintf('git -C "%s" rev-parse HEAD',root));
if status~=0, value='unknown'; else, value=strtrim(value); end
[status,changes]=system(sprintf('git -C "%s" status --porcelain',root));
dirty=status~=0 || ~isempty(strtrim(changes));
end
function removeStage(path)
if isfolder(path), rmdir(path,'s'); end
end
