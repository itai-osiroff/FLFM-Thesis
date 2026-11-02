function result=writeExport(plan,destination)
%WRITEEXPORT Publish the exact frozen arrays reviewed during preflight.
destination=char(java.io.File(destination).getCanonicalPath());
if isfolder(destination) || isfile(destination)
    error('captureedit:InvalidExport','Choose a new destination folder.');
end
parent=fileparts(destination);
if ~isfolder(parent), error('captureedit:InvalidExport','Destination parent does not exist.'); end
if plan.hasFloatOverflow, error('captureedit:ExportFloatOverflow','Native conversion would become nonfinite; choose floating MAT.'); end
if plan.hasClipping && ~plan.options.allowClipping, error('captureedit:ExportClipping','Review and explicitly allow clipping or choose floating MAT.'); end
sources=plan.sources; roles={plan.images.role}; geometry=plan.options.geometry; displayTiff=plan.options.displayTiff;
for j=1:numel(plan.images), checkSource(plan.images(j).source); end
stage=tempname(parent); mkdir(stage); cleanup=onCleanup(@()removeStage(stage,parent));
records=struct('role',{},'filename',{},'hash',{},'sourceHash',{},'relativePath',{},'variable',{},'processingPolicy',{},'format',{},'diagnostics',{},'conversion',{},'displayConversion',{},'class',{},'dimensions',{},'range',{},'displayRange',{},'stack',{},'displayFilename',{},'displayHash',{});
globalEdited=[]; localEdited=[];
for k=1:numel(roles)
    role=roles{k};
    if ~isfield(sources,role), error('captureedit:InvalidExport','Missing role %s.',role); end
    item=plan.images(k); source=item.source;
    if ~strcmp(source.hash,captureedit.sha256(source.path))
        error('captureedit:ChangedSource','Source changed since loading: %s',source.path);
    end
    stack=item.stack; output=item.output; outputSource=source; outputSource.format=item.format; outputSource.variable=item.variable;
    if strcmp(role,'global'), globalEdited=output;
    elseif strcmp(role,'local'), localEdited=output; end
    filename=[role '_edited.' item.format]; path=fullfile(stage,filename);
    writeNative(path,output,outputSource);
    if strcmp(item.format,'mat')
        stored=load(path,item.variable); restored=stored.(item.variable);
    else, restored=imread(path); end
    if ~isequaln(output,restored) || ~strcmp(class(output),class(restored))
        error('captureedit:ExportVerification','Export did not round-trip exactly: %s',filename);
    end
    displayFilename=''; displayHash='';
    if displayTiff && strcmp(item.format,'mat')
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
        'sourceHash',source.hash,'relativePath',source.relativePath,'variable',item.variable,'processingPolicy',plan.options.processingPolicy,'format',item.format,'diagnostics',item.diagnostics,'conversion',item.conversion,'displayConversion',item.displayConversion,'class',class(output), ...
        'dimensions',size(output),'range',source.range,'displayRange',source.displayRange,'stack',stack, ...
        'displayFilename',displayFilename,'displayHash',displayHash); %#ok<AGROW>
end
trioWorkspace=struct('available',false,'filename','','sha256','','sourceRelativePath','', ...
    'sourceHash','','sourceConfigJsonAvailable',false);
if ~isempty(globalEdited) && ~isempty(localEdited) && ...
        strcmp(sources.global.format,'mat') && strcmp(sources.local.format,'mat') && ...
        strcmp(sources.global.path,sources.local.path)
    if ~strcmp(sources.global.hash,captureedit.sha256(sources.global.path))
        error('captureedit:ChangedSource','Source changed since loading: %s',sources.global.path);
    end
    sourceWorkspace=load(sources.global.path,'config_json');
    if ~strcmp(sources.global.hash,captureedit.sha256(sources.global.path))
        error('captureedit:ChangedSource','Source changed while exporting: %s',sources.global.path);
    end
    configJsonAvailable=isfield(sourceWorkspace,'config_json');
    if configJsonAvailable, configJson=sourceWorkspace.config_json; else, configJson='{}'; end
    workspaceData=struct();
    workspaceData.average_rectified_global_image=globalEdited;
    workspaceData.average_rectified_image=localEdited;
    workspaceData.config_json=configJson;
    workspacePath=fullfile(stage,'workspace.mat');
    save(workspacePath,'-struct','workspaceData','-v7.3');
    restored=load(workspacePath,'average_rectified_global_image', ...
        'average_rectified_image','config_json');
    if ~isequaln(globalEdited,restored.average_rectified_global_image) || ...
            ~strcmp(class(globalEdited),class(restored.average_rectified_global_image)) || ...
            ~isequaln(localEdited,restored.average_rectified_image) || ...
            ~strcmp(class(localEdited),class(restored.average_rectified_image)) || ...
            ~isequaln(configJson,restored.config_json)
        error('captureedit:ExportVerification','Combined workspace did not round-trip exactly.');
    end
    trioWorkspace=struct('available',true,'filename','workspace.mat', ...
        'sha256',captureedit.sha256(workspacePath), ...
        'sourceRelativePath',sources.global.relativePath,'sourceHash',sources.global.hash, ...
        'sourceConfigJsonAvailable',configJsonAvailable);
end
[softwareRevision,workingTreeDirty]=revision();
manifest=struct('schemaVersion',2,'processingPolicy',plan.options.processingPolicy,'outputMode',plan.options.outputMode,'allowClipping',plan.options.allowClipping,'createdUtc',char(datetime('now','TimeZone','UTC','Format',"yyyy-MM-dd'T'HH:mm:ss'Z'")), ...
    'softwareRevision',softwareRevision,'workingTreeDirty',workingTreeDirty,'matlabVersion',version, ...
    'geometry',geometry,'images',records,'trioWorkspace',trioWorkspace);
manifestPath=fullfile(stage,'capture-export.json');
fid=fopen(manifestPath,'w'); if fid<0, error('captureedit:ExportWrite','Cannot write manifest.'); end
closer=onCleanup(@()fclose(fid)); fprintf(fid,'%s',jsonencode(manifest,'PrettyPrint',true)); clear closer;
for j=1:numel(plan.images), checkSource(plan.images(j).source); end
[ok,message]=movefile(stage,destination);
if ~ok, error('captureedit:ExportWrite','Could not publish export: %s',message); end
result=struct('directory',destination,'files',records,'manifestPath',fullfile(destination,'capture-export.json'), ...
    'workspacePath','');
if trioWorkspace.available, result.workspacePath=fullfile(destination,trioWorkspace.filename); end
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
function removeStage(path,parent)
canonical=char(java.io.File(path).getCanonicalPath());
parent=char(java.io.File(parent).getCanonicalPath());
if ~startsWith(lower(canonical),lower([parent filesep]))
    error('captureedit:CleanupPath','Refusing cleanup outside export parent.');
end
if isfolder(canonical), rmdir(canonical,'s'); end
end

function checkSource(source)
if ~isfile(source.path) || ~strcmp(source.hash,captureedit.sha256(source.path)), error('captureedit:ChangedSource','Source changed since preflight: %s',source.path); end
end
