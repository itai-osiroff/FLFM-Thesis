classdef Editor < handle
    %EDITOR Native-image editing controller and persistent MATLAB desktop UI.
    properties
        Figure
        Sources = struct()
        State = struct('stacks',struct(),'geometry',[],'displayRanges',struct(),'processingPolicy','preserve')
        History
        Root
        Dirty = false
        SessionPath = ''
        SelectedRole = ''
        SelectedNode = 0
        Status
    end
    properties (Access=private)
        Policy
        Diagnostics
        PreviewValid = false
        Roles
        Details
        Mode
        PairLeft
        PairRight
        Original
        Clipping
        Histogram
        FilterList
        FilterType
        Enabled
        Parameters
        Viewer
        HistAxes
        Center
        Views
        Tabs
        Target
        ExportDetails
        ExportRoles
        ExportRoleNames = {}
        Operation
        SpaceHeld = false
        SpaceOriginal = false
        LastExport = ''
        PendingRole = ''
        PendingPoint = []
        Axes = gobjects(0)
        Images = gobjects(0)
        Links = []
        Catalog
        GestureBefore = []
        LastPreview = []
        Cache
        CacheBytes = 0
        Revision = 0
        Rendering = false
        PendingRender = false
    end
    methods
        function app=Editor(root,options)
            arguments
                root
                options.Visible = 'on'
            end
            app.Root=char(root);
            if ~isfolder(app.Root), error('captureedit:MissingRoot','Data root does not exist.'); end
            addpath(fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))),'figure-preparation'));
            app.Catalog=captureedit.catalog(); app.History=captureedit.editHistory('new');
            app.Cache=containers.Map('KeyType','char','ValueType','any');
            app.build(options.Visible);
        end
        function accepted=loadPaths(app,paths,geometry)
            accepted=false;
            sources=captureedit.loadSources(app.Root,paths);
            if isempty(fieldnames(sources)), return; end
            if nargin<3
                geometry=[];
                if isfield(sources,'global'), geometry=captureedit.resolveGeometry(sources,[],false); end
            end
            if ~app.allowReplace(), return; end
            app.Sources=sources; app.State=struct('stacks',struct(),'geometry',[],'displayRanges',struct(),'processingPolicy','preserve');
            names=fieldnames(sources);
            for k=1:numel(names)
                app.State.stacks.(names{k})=app.emptyStack();
                app.State.displayRanges.(names{k})=sources.(names{k}).displayRange;
            end
            app.State.geometry=geometry;
            app.ExportRoleNames={};
            app.History=captureedit.editHistory('new'); app.GestureBefore=[];
            app.SessionPath=''; app.Dirty=false; app.SelectedRole=names{1}; app.SelectedNode=0;
            app.clearCache(); app.refresh(); app.defaultView(); app.refresh();
            accepted=true;
        end
        function importRecipe(app,path)
            recipe=triofig.readRecipe(path); input=recipe.input;
            paths=struct('thorcam',fullfile(app.Root,input.thorcamCaptureRelativePath), ...
                'validation',fullfile(app.Root,input.validationCaptureRelativePath), ...
                'global',fullfile(app.Root,input.workspaceRelativePath),'local',fullfile(app.Root,input.workspaceRelativePath));
            if isfield(input,'workspaceMode') && strcmp(input.workspaceMode,'separate')
                paths.local=fullfile(app.Root,input.localWorkspaceRelativePath);
            end
            staged=captureedit.loadSources(app.Root,paths);
            geometry=captureedit.resolveGeometry(staged,recipe,false);
            if ~app.loadPaths(paths,geometry), return; end
            app.State.geometry=geometry;
            app.Mode.Value='Trio'; app.Dirty=true; app.refresh();
        end
        function openSession(app,path)
            [sources,stacks,geometry,history,view,policy]=captureedit.loadSession(path,app.Root);
            if ~app.allowReplace(), return; end
            app.Sources=sources; app.State=struct('stacks',stacks,'geometry',geometry,'displayRanges',struct(),'processingPolicy',policy);
            names=fieldnames(sources);
            for k=1:numel(names), app.State.displayRanges.(names{k})=sources.(names{k}).displayRange; end
            if isfield(view,'displayRanges'), app.State.displayRanges=view.displayRanges; end
            app.ExportRoleNames={};
            app.History=history; app.SessionPath=char(path); app.Dirty=false;
            app.SelectedRole=names{1}; app.SelectedNode=0;
            if isfield(view,'selectedRole') && isfield(sources,view.selectedRole), app.SelectedRole=view.selectedRole; end
            app.clearCache(); app.refresh();
            for name={'mode','pairLeft','pairRight'}
                if ~isfield(view,name{1}), continue; end
                switch name{1}
                    case 'mode', control=app.Mode;
                    case 'pairLeft', control=app.PairLeft;
                    case 'pairRight', control=app.PairRight;
                end
                if any(strcmp(control.Items,view.(name{1}))), control.Value=view.(name{1}); end
            end
            if isfield(view,'section'), app.selectSection(view.section); end
            for field={'histogram','clipping','original'}
                if ~isfield(view,field{1}), continue; end
                switch field{1}
                    case 'histogram', app.Histogram.Value=logical(view.histogram);
                    case 'clipping', app.Clipping.Value=logical(view.clipping);
                    case 'original', app.Original.Value=logical(view.original);
                end
            end
            app.render(false);
        end
        function saved=saveSession(app,path)
            saved=false;
            if isempty(fieldnames(app.Sources)), return; end
            if nargin<2 || isempty(path)
                if isempty(app.SessionPath)
                    [f,p]=uiputfile('*.json','Save editing session',fullfile(app.Root,'capture-edit-session.json'));
                    if isequal(f,0), return; end
                    path=fullfile(p,f);
                else, path=app.SessionPath;
                end
            end
            app.finishGesture();
            view=struct('displayRanges',app.State.displayRanges,'selectedRole',app.SelectedRole, ...
                'mode',app.Mode.Value,'pairLeft',app.PairLeft.Value,'pairRight',app.PairRight.Value, ...
                'section',app.Tabs.SelectedTab.Title,'histogram',app.Histogram.Value,'clipping',app.Clipping.Value,'original',app.Original.Value);
            captureedit.saveSession(path,app.Root,app.Sources,app.State.stacks,app.State.geometry,app.History,view,app.State.processingPolicy);
            app.SessionPath=char(path); app.Dirty=false; saved=true;
            app.Operation.Text=['Session saved: ' char(path)]; app.updateWorkspace();
        end
        function setProcessingPolicy(app,policy)
            validatestring(policy,{'preserve','legacy-clamp'});
            app.finishGesture(); before=app.State; app.State.processingPolicy=policy;
            app.clearCache(); app.commit(before); app.refresh();
        end
        function addFilter(app,type)
            if isempty(app.SelectedRole), return; end
            app.finishGesture(); before=app.State;
            def=app.Catalog(strcmp({app.Catalog.type},type));
            node=struct('id',char(java.util.UUID.randomUUID()),'type',def.type,'enabled',true,'params',def.params);
            stack=app.State.stacks.(app.SelectedRole); if isempty(stack), stack=node; else, stack(end+1)=node; end
            app.State.stacks.(app.SelectedRole)=stack; app.SelectedNode=numel(stack);
            app.commit(before); app.refresh();
        end
        function toggleFilter(app,value)
            if ~app.hasNode(), return; end
            before=app.State; app.State.stacks.(app.SelectedRole)(app.SelectedNode).enabled=logical(value);
            app.commit(before); app.refresh();
        end
        function removeFilter(app)
            if ~app.hasNode(), return; end
            before=app.State; stack=app.State.stacks.(app.SelectedRole); stack(app.SelectedNode)=[];
            app.State.stacks.(app.SelectedRole)=stack; app.SelectedNode=min(app.SelectedNode,numel(stack));
            app.commit(before); app.refresh();
        end
        function moveFilter(app,delta)
            if ~app.hasNode(), return; end
            stack=app.State.stacks.(app.SelectedRole); target=app.SelectedNode+delta;
            if target<1 || target>numel(stack), return; end
            before=app.State; stack([app.SelectedNode target])=stack([target app.SelectedNode]);
            app.State.stacks.(app.SelectedRole)=stack; app.SelectedNode=target;
            app.commit(before); app.refresh();
        end
        function setParameter(app,name,value,phase)
            if ~app.hasNode(), return; end
            if nargin<4, phase='changed'; end
            if isempty(app.GestureBefore), app.GestureBefore=app.State; end
            node=app.State.stacks.(app.SelectedRole)(app.SelectedNode);
            def=app.Catalog(strcmp({app.Catalog.type},node.type)); knob=def.knobs(strcmp({def.knobs.name},name));
            value=min(max(value,knob.min),knob.max);
            if strcmp(name,'size')
                if strcmp(node.type,'gaussian') && value<1, value=0;
                else, value=max(1,2*round((value-1)/2)+1); end
            elseif ismember(name,{'binary','radius','tiles'}) && ~strcmp(node.type,'unsharp'), value=round(value);
            end
            if strcmp(node.type,'window')
                if strcmp(name,'black'), value=min(value,node.params.white-1e-6);
                else, value=max(value,node.params.black+1e-6); end
            elseif strcmp(node.type,'clip')
                if strcmp(name,'lower'), value=min(value,node.params.upper-1e-6);
                else, value=max(value,node.params.lower+1e-6); end
            end
            app.State.stacks.(app.SelectedRole)(app.SelectedNode).params.(name)=value;
            app.Revision=app.Revision+1;
            if strcmp(phase,'changing')
                if isempty(app.LastPreview) || toc(app.LastPreview)>=.1
                    app.LastPreview=tic; app.render(true);
                end
            else
                app.finishGesture(); app.refresh();
            end
        end
        function resetFilter(app)
            if ~app.hasNode(), return; end
            app.finishGesture(); before=app.State;
            node=app.State.stacks.(app.SelectedRole)(app.SelectedNode);
            def=app.Catalog(strcmp({app.Catalog.type},node.type));
            app.State.stacks.(app.SelectedRole)(app.SelectedNode).params=def.params;
            app.commit(before); app.refresh();
        end
        function resetStack(app)
            if isempty(app.SelectedRole), return; end
            app.finishGesture(); before=app.State;
            app.State.stacks.(app.SelectedRole)=app.emptyStack(); app.SelectedNode=0;
            app.commit(before); app.refresh();
        end
        function undo(app)
            app.finishGesture(); [app.History,app.State]=captureedit.editHistory('undo',app.History,app.State);
            app.Dirty=true; app.refresh();
        end
        function redo(app)
            app.finishGesture(); [app.History,app.State]=captureedit.editHistory('redo',app.History,app.State);
            app.Dirty=true; app.refresh();
        end
        function render(app,approximate)
            app.updateWorkspace();
            if isempty(fieldnames(app.Sources)), return; end
            if app.Rendering, app.PendingRender=true; return; end
            app.Rendering=true; cleanup=onCleanup(@() app.finishRender());
            revision=app.Revision;
            if approximate, app.Status.Text='Approximate preview - release the control for native-resolution processing';
            else, app.Status.Text='Processing native-resolution images...'; end
            drawnow limitrate;
            try
                names=app.viewRoles(); aligned=~strcmp(app.Mode.Value,'Single') && ~isempty(app.State.geometry);
                if strcmp(app.Mode.Value,'Pair') && strcmp(names{1},names{2}), aligned=false; end
                if aligned, required=fieldnames(app.Sources); else, required=unique(names,'stable'); end
                if app.Histogram.Value, required=unique([required(:);{app.SelectedRole}],'stable'); end
                edited=struct(); original=struct(); diagnostics=struct(); support=[];
                for k=1:numel(required)
                    role=required{k}; original.(role)=app.Sources.(role).image;
                    [edited.(role),diagnostics.(role)]=app.process(role,approximate);
                end
                if aligned
                    [edited,~,support]=captureedit.comparisonPanels(edited,app.State.geometry);
                    original=captureedit.comparisonPanels(original,app.State.geometry);
                end
                if revision~=app.Revision, app.PendingRender=true; return; end
                app.ensureAxes(numel(names));
                for k=1:numel(names)
                    role=names{k}; showOriginal=app.Original.Value;
                    if strcmp(app.Mode.Value,'Pair')
                        if k==1, showOriginal=contains(app.PairLeft.Value,'original');
                        else, showOriginal=contains(app.PairRight.Value,'original'); end
                        showOriginal=showOriginal || app.Original.Value;
                    end
                    if showOriginal, image=original.(role); variant='original';
                    else, image=edited.(role); variant='edited'; end
                    range=app.State.displayRanges.(role); raw=(double(image)-range(1))/diff(range);
                    normalized=min(max(raw,0),1);
                    valid=true(size(raw)); if aligned, valid=support; end
                    low=raw<0 & valid; high=raw>1 & valid;
                    if app.Clipping.Value
                        rgb=repmat(normalized,1,1,3);
                        colors=[0 .45 .74;.85 .33 .1]; masks={low,high};
                        for side=1:2
                            for channel=1:3, plane=rgb(:,:,channel); plane(masks{side})=colors(side,channel); rgb(:,:,channel)=plane; end
                        end
                        normalized=rgb;
                    end
                    setappdata(app.Axes(k),'displayCounts',[nnz(low) nnz(high) nnz(valid)]);
                    app.Images(k).CData=normalized; app.Images(k).XData=[1 size(image,2)]; app.Images(k).YData=[1 size(image,1)];
                    if ~isappdata(app.Axes(k),'initialized') || ~isequal(getappdata(app.Axes(k),'imageSize'),size(image))
                        app.Axes(k).XLim=[.5 size(image,2)+.5]; app.Axes(k).YLim=[.5 size(image,1)+.5];
                        setappdata(app.Axes(k),'initialized',true); setappdata(app.Axes(k),'imageSize',size(image));
                    end
                    if strcmp(role,app.SelectedRole), active='EDITING: '; else, active=''; end
                    if aligned, gridLabel='aligned'; else, gridLabel='native'; end
                    title(app.Axes(k),sprintf('%s%s - %s - %s | view low/high %d/%d (N=%d)',active,role,variant,gridLabel,nnz(low),nnz(high),nnz(valid)),'Interpreter','none');
                    app.Images(k).ButtonDownFcn=@(~,~) app.beginSelection(role);
                end
                if (aligned || (all(ismember(names,{'global','local'})) && numel(names)>1)), linkaxes(app.Axes,'xy'); else, linkaxes(app.Axes,'off'); end
                if app.Histogram.Value
                    range=app.State.displayRanges.(app.SelectedRole); values=(double(edited.(app.SelectedRole))-range(1))/diff(range);
                    histogram(app.HistAxes,values(:),64); xline(app.HistAxes,0,'b--'); xline(app.HistAxes,1,'--','Color',[.85 .33 .1]); title(app.HistAxes,[app.SelectedRole ' - edited intensity']);
                    app.HistAxes.Visible='on';
                else, cla(app.HistAxes); app.HistAxes.Visible='off'; end
                if approximate, quality='Approximate'; else, quality='Exact'; end
                if aligned, context='aligned common field'; else, context='native grid'; end
                if ~aligned && numel(unique(names))>1 && ~all(ismember(names,{'global','local'})), context='unaligned native grids - independent coordinates'; end
                app.PreviewValid=~approximate; app.setExportEnabled(~approximate);
                app.showDiagnostics(diagnostics,approximate);
                app.Status.Text=sprintf('%s - %s - filters operate in native pixels',quality,context);
            catch cause
                app.PreviewValid=false; app.setExportEnabled(false);
                app.Diagnostics.Text=['STALE preview: ' cause.message];
                for index=1:numel(app.Axes), title(app.Axes(index),'STALE - filter evaluation failed'); end
                app.Status.Text=['STALE preview: ' cause.message];
            end
        end
    end
    methods (Access=private)
        function build(app,visible)
            app.Figure=uifigure('Name','Native Capture Editor','Position',[40 40 1450 900], ...
                'Visible',visible,'Tag','capture-editor','CloseRequestFcn',@(~,~) app.close());
            app.Figure.WindowKeyPressFcn=@(~,e) app.key(e);
            app.Figure.WindowKeyReleaseFcn=@(~,e) app.releaseKey(e);
            app.Figure.WindowButtonUpFcn=@(~,~) app.finishSelection();
            grid=uigridlayout(app.Figure,[4 1],'RowHeight',{42,44,'1x',58});
            toolbar=uigridlayout(grid,[1 6],'ColumnWidth',{110,110,90,90,'1x',140});
            app.button(toolbar,'Open session',@() app.chooseSession());
            app.button(toolbar,'Save session',@() app.saveSession());
            app.button(toolbar,'Undo',@() app.undo()); app.button(toolbar,'Redo',@() app.redo());
            app.Target=uilabel(toolbar,'Text','Choose an acquisition to begin','FontWeight','bold','Tag','capture-target');
            app.button(toolbar,'Export...',@() app.selectSection('Export'));
            views=uigridlayout(grid,[1 8],'ColumnWidth',{100,140,140,110,60,60,'1x',190});
            app.Views=views;
            app.Mode=uidropdown(views,'Items',{'Single','Pair','Trio'},'Tag','capture-view','ValueChangedFcn',@(~,~) app.safe(@() app.refresh()));
            app.PairLeft=uidropdown(views,'Items',{'No inputs'},'Tag','capture-pair-left','ValueChangedFcn',@(~,~) app.render(false));
            app.PairRight=uidropdown(views,'Items',{'No inputs'},'Tag','capture-pair-right','ValueChangedFcn',@(~,~) app.render(false));
            app.button(views,'Before / after',@() app.beforeAfter());
            app.button(views,'Fit',@() app.fit(false)); app.button(views,'1:1',@() app.fit(true));
            uilabel(views,'Text','Viewing only - alignment and display range');
            app.Original=uicheckbox(views,'Text','Show original (hold Space)','ValueChangedFcn',@(~,~) app.render(false));
            body=uigridlayout(grid,[1 3],'ColumnWidth',{170,'1x',340});
            left=uigridlayout(body,[7 1],'RowHeight',{24,150,120,28,28,28,'1x'});
            uilabel(left,'Text','Edit target','FontWeight','bold');
            app.Roles=uilistbox(left,'Items',{'Load inputs to begin'},'ValueChangedFcn',@(~,~) app.selectRole());
            app.Details=uilabel(left,'Text','Original sources stay unchanged.','WordWrap','on');
            app.Clipping=uicheckbox(left,'Text','Outside viewing range','ValueChangedFcn',@(~,~) app.render(false));
            app.Histogram=uicheckbox(left,'Text','Show histogram','ValueChangedFcn',@(~,~) app.render(false));
            app.Policy=uidropdown(left,'Items',{'Preserve values','Legacy: clamp each filter'},'ItemsData',{'preserve','legacy-clamp'},'Tag','capture-policy','ValueChangedFcn',@(s,~)app.setProcessingPolicy(s.Value));
            diagnosticsPanel=uipanel(left,'Scrollable','on','Title','Native diagnostics');
            diagnosticsGrid=uigridlayout(diagnosticsPanel,[1 1],'RowHeight',{'fit'});
            app.Diagnostics=uilabel(diagnosticsGrid,'Text','Native filter diagnostics','WordWrap','on','Tag','capture-diagnostics');
            app.Center=uigridlayout(body,[2 1],'RowHeight',{'1x',0});
            app.Viewer=uigridlayout(app.Center,[1 1]); app.HistAxes=uiaxes(app.Center,'Visible','off');
            app.Tabs=uitabgroup(body,'Tag','capture-sections');
            inputs=uitab(app.Tabs,'Title','Inputs'); il=uigridlayout(inputs,[5 1],'RowHeight',{80,36,36,36,'1x'});
            uilabel(il,'Text','Load an acquisition, import an existing trio recipe, or resume a saved session. Select only the roles you have.','WordWrap','on');
            app.button(il,'Choose inputs...',@() app.chooseInputs()); app.button(il,'Import trio recipe...',@() app.chooseRecipe()); app.button(il,'Open session...',@() app.chooseSession());
            uilabel(il,'Text','All selected files are validated before replacing this session. Cameras can be skipped. Aligned comparisons use global as the reference.','WordWrap','on');
            alignment=uitab(app.Tabs,'Title','Alignment'); al=uigridlayout(alignment,[4 1],'RowHeight',{90,36,36,'1x'});
            uilabel(al,'Text','Viewing only. Align loaded cameras against global, then choose their common field. Edits never re-estimate alignment.','WordWrap','on');
            app.button(al,'Set up alignment and common crop...',@() app.setupGeometry()); app.button(al,'Display range...',@() app.displayRange());
            uilabel(al,'Text','Global and local already share a grid. Without global, camera comparisons remain on their native grids.','WordWrap','on');
            edit=uitab(app.Tabs,'Title','Edit'); right=uigridlayout(edit,[9 1],'RowHeight',{48,32,32,110,92,28,32,24,'1x'});
            uilabel(right,'Text','Affects exported pixels - reversible ordered filters','FontWeight','bold','WordWrap','on');
            labels={app.Catalog.label};
            if isfield(app.Catalog,'category'), labels=arrayfun(@(d) [d.category ' - ' d.label],app.Catalog,'UniformOutput',false); end
            app.FilterType=uidropdown(right,'Items',labels,'ItemsData',{app.Catalog.type},'ValueChangedFcn',@(~,~) app.filterHelp());
            app.filterHelp();
            app.button(right,'Add filter',@() app.addFilter(app.FilterType.Value));
            app.FilterList=uilistbox(right,'Items',{'No filters'},'ValueChangedFcn',@(~,~) app.selectNode(),'Tag','capture-filters');
            controls=uigridlayout(right,[3 3],'RowHeight',{25,25,25},'Padding',[0 0 0 0],'RowSpacing',4);
            app.button(controls,'Remove',@() app.removeFilter()); app.button(controls,'Duplicate',@() app.duplicate()); app.button(controls,'Copy...',@() app.copy(false));
            app.button(controls,'Move up',@() app.moveFilter(-1)); app.button(controls,'Move down',@() app.moveFilter(1)); app.button(controls,'Copy stack...',@() app.copy(true));
            app.button(controls,'Reset filter',@() app.resetFilter()); app.button(controls,'Reset stack',@() app.resetStack());
            app.Enabled=uicheckbox(right,'Text','Enabled','ValueChangedFcn',@(s,~) app.toggleFilter(s.Value));
            app.button(right,'Viewing intensity range...',@() app.displayRange());
            uilabel(right,'Text','Parameters - spatial units are native pixels','FontWeight','bold');
            panel=uipanel(right,'Scrollable','on'); app.Parameters=uigridlayout(panel,[1 1]);
            ex=uitab(app.Tabs,'Title','Export'); el=uigridlayout(ex,[8 1],'RowHeight',{130,100,36,36,36,36,36,'1x'});
            app.ExportDetails=uilabel(el,'Text','Load inputs to see native export formats.','WordWrap','on');
            app.ExportRoles=uilistbox(el,'Items',{'No inputs'},'Multiselect','on','Tag','capture-export-roles');
            app.button(el,'Export chosen images...',@() app.export(false,app.ExportRoles.Value));
            app.button(el,'Export selected image...',@() app.export(false)); app.button(el,'Export all loaded images...',@() app.export(true));
            app.button(el,'Save editing session...',@() app.saveSession()); app.button(el,'Open last export folder',@() app.openExport());
            uilabel(el,'Text','Native exports retain dimensions and numeric class. Comparison crop and geometry affect viewing only. MAT images can also produce optional display-mapped TIFFs.','WordWrap','on');
            footer=uigridlayout(grid,[2 1],'RowHeight',{24,24},'Padding',[0 0 0 0],'RowSpacing',2);
            app.Status=uilabel(footer,'Text','Ready - choose inputs or import a recipe','Tag','capture-status');
            app.Operation=uilabel(footer,'Text','Originals remain unchanged.','Tag','capture-operation');
            app.Figure.UserData=app; app.updateWorkspace();
        end
        function filterHelp(app)
            def=app.Catalog(strcmp({app.Catalog.type},app.FilterType.Value));
            if isfield(def,'description'), app.FilterType.Tooltip=def.description; end
        end
        function selectSection(app,title)
            tabs=app.Tabs.Children;
            for k=1:numel(tabs), if strcmp(tabs(k).Title,title), app.Tabs.SelectedTab=tabs(k); return; end, end
        end
        function defaultView(app)
            names=fieldnames(app.Sources);
            if all(isfield(app.Sources,{'thorcam','global','local'})), app.Mode.Value='Trio';
            elseif all(isfield(app.Sources,{'global','local'})), app.Mode.Value='Pair'; app.PairLeft.Value='global edited'; app.PairRight.Value='local edited';
            elseif numel(names)>1, app.Mode.Value='Pair'; app.PairLeft.Value=[names{1} ' edited']; app.PairRight.Value=[names{2} ' edited'];
            else, app.Mode.Value='Single'; end
        end
        function updateWorkspace(app)
            loaded=~isempty(fieldnames(app.Sources)); app.Mode.Enable=matlab.lang.OnOffSwitchState(loaded);
            app.FilterType.Enable=matlab.lang.OnOffSwitchState(loaded); app.Policy.Value=app.State.processingPolicy;
            if all(isfield(app.Sources,{'thorcam','global','local'}))
                app.Mode.Items={'Single','Pair','Trio'}; app.Mode.Tooltip='Choose single, pair, or aligned trio inspection.';
            else
                if strcmp(app.Mode.Value,'Trio'), app.Mode.Value='Single'; end
                app.Mode.Items={'Single','Pair'}; app.Mode.Tooltip='Trio requires ThorCam, global, and local. Pair supports original versus edited for a single source.';
            end
            pair=strcmp(app.Mode.Value,'Pair'); app.PairLeft.Visible=pair; app.PairRight.Visible=pair;
            if pair, app.Views.ColumnWidth={100,140,140,110,60,60,'1x',190}; else, app.Views.ColumnWidth={100,0,0,110,60,60,'1x',190}; end
            if app.Histogram.Value, app.Center.RowHeight={'1x',135}; else, app.Center.RowHeight={'1x',0}; end
            if isempty(app.SelectedRole), return; end
            marker='Saved'; if app.Dirty, marker='Unsaved changes'; end
            app.Target.Text=['Editing: ' app.SelectedRole ' - ' marker];
            if strcmp(app.Mode.Value,'Trio') && ~all(isfield(app.Sources,{'thorcam','global','local'})), app.Mode.Value='Single'; end
            names=fieldnames(app.Sources);
            if ~isequal(names(:),app.ExportRoleNames(:))
                app.ExportRoles.Items=names; app.ExportRoles.Value={app.SelectedRole}; app.ExportRoleNames=names;
            end
            lines=cell(1,numel(names));
            for k=1:numel(names), source=app.Sources.(names{k}); lines{k}=sprintf('%s: %d x %d - %s - %s',names{k},size(source.image,2),size(source.image,1),class(source.image),source.format); end
            app.ExportDetails.Text=strjoin([{['Selected target: ' app.SelectedRole];'Native export formats:'};lines(:)],newline);
        end
        function beforeAfter(app)
            if isempty(app.SelectedRole), return; end
            app.Mode.Value='Pair'; app.PairLeft.Value=[app.SelectedRole ' original']; app.PairRight.Value=[app.SelectedRole ' edited']; app.refresh();
        end
        function beginSelection(app,role)
            app.PendingRole=role; app.PendingPoint=app.Figure.CurrentPoint;
        end
        function finishSelection(app)
            role=app.PendingRole; point=app.PendingPoint; app.PendingRole=''; app.PendingPoint=[];
            if isempty(role) || isempty(point) || norm(app.Figure.CurrentPoint-point)>4, return; end
            if strcmp(app.Figure.SelectionType,'normal') && ~strcmp(app.SelectedRole,role)
                app.finishGesture(); app.SelectedRole=role; app.Roles.Value=role; app.refresh();
            end
        end
        function openExport(app)
            if ~isempty(app.LastExport) && isfolder(app.LastExport), winopen(app.LastExport); end
        end
        function refresh(app)
            names=fieldnames(app.Sources); if isempty(names), return; end
            if ~ismember(app.SelectedRole,names), app.SelectedRole=names{1}; end
            app.Roles.Items=names; app.Roles.Value=app.SelectedRole;
            choices={}; for k=1:numel(names), choices=[choices {[names{k} ' edited'],[names{k} ' original']}]; end %#ok<AGROW>
            left=app.PairLeft.Value; right=app.PairRight.Value;
            app.PairLeft.Items=choices; app.PairRight.Items=choices;
            if ismember(left,choices), app.PairLeft.Value=left; else, app.PairLeft.Value=choices{1}; end
            if ismember(right,choices), app.PairRight.Value=right; else, app.PairRight.Value=choices{min(2,numel(choices))}; end
            source=app.Sources.(app.SelectedRole);
            app.Details.Text=sprintf('%s\n%d x %d - %s - %s\n%s',app.SelectedRole,size(source.image,2),size(source.image,1),class(source.image),source.format,source.relativePath);
            stack=app.State.stacks.(app.SelectedRole);
            if isempty(stack)
                app.SelectedNode=0; app.FilterList.Items={'No filters'}; app.FilterList.ItemsData=0;
            else
                labels=cell(1,numel(stack));
                for k=1:numel(stack)
                    def=app.Catalog(strcmp({app.Catalog.type},stack(k).type));
                    if stack(k).enabled, flag='on'; else, flag='off'; end
                    labels{k}=sprintf('%d - %s [%s]',k,def.label,flag);
                end
                app.FilterList.Items=labels; app.FilterList.ItemsData=1:numel(stack);
                app.SelectedNode=min(max(app.SelectedNode,1),numel(stack)); app.FilterList.Value=app.SelectedNode;
            end
            app.parameterControls(); app.render(false);
        end
        function parameterControls(app)
            delete(app.Parameters.Children); app.Parameters.RowHeight={'1x'};
            app.Enabled.Enable=matlab.lang.OnOffSwitchState(app.hasNode());
            if ~app.hasNode(), app.Enabled.Value=false; return; end
            node=app.State.stacks.(app.SelectedRole)(app.SelectedNode); app.Enabled.Value=node.enabled;
            def=app.Catalog(strcmp({app.Catalog.type},node.type));
            app.Parameters.RowHeight=repmat({82},1,numel(def.knobs));
            for k=1:numel(def.knobs)
                knob=def.knobs(k); row=uigridlayout(app.Parameters,[3 2],'RowHeight',{22,22,22},'ColumnWidth',{'1x',85});
                uilabel(row,'Text',knob.label);
                if strcmp(knob.name,'binary')
                    uicheckbox(row,'Text','Binary output','Value',logical(node.params.binary),'ValueChangedFcn',@(c,~) app.setParameter('binary',double(c.Value),'changed')); continue;
                end
                if strcmp(node.type,'gaussian') && strcmp(knob.name,'size')
                    uicheckbox(row,'Text','Automatic kernel','Value',node.params.size==0,'ValueChangedFcn',@(c,~) app.gaussianAutomatic(c.Value));
                end
                field=uieditfield(row,'numeric','Limits',[knob.min knob.max],'Value',node.params.(knob.name), ...
                    'ValueChangedFcn',@(s,~) app.safe(@() app.setParameter(knob.name,s.Value,'changed')));
                slider=uislider(row,'Limits',[knob.min knob.max],'Value',node.params.(knob.name),'MajorTicks',[],'MinorTicks',[]);
                slider.Layout.Column=[1 2];
                slider.ValueChangingFcn=@(s,e) app.parameterDrag(knob.name,e.Value,field,s);
                slider.ValueChangedFcn=@(s,~) app.safe(@() app.setParameter(knob.name,s.Value,'changed'));
                hint=''; range=app.Sources.(app.SelectedRole).range;
                if ismember(knob.name,{'cutoff','black','white','lower','upper'}), hint=sprintf('Native intensity: %.6g',range(1)+node.params.(knob.name)*diff(range));
                elseif strcmp(knob.name,'offset'), hint=sprintf('Native offset: %.6g',node.params.offset*diff(range));
                end
                label=uilabel(row,'Text',hint,'FontSize',10); label.Layout.Column=[1 2];
            end
        end
        function parameterDrag(app,name,value,field,~)
            field.Value=value; app.safe(@() app.setParameter(name,value,'changing'));
        end
        function selectRole(app)
            if ~isfield(app.Sources,app.Roles.Value), return; end
            app.finishGesture(); app.SelectedRole=app.Roles.Value; app.SelectedNode=0; app.refresh();
        end
        function selectNode(app)
            app.finishGesture(); app.SelectedNode=app.FilterList.Value; app.parameterControls();
        end
        function duplicate(app)
            if ~app.hasNode(), return; end
            before=app.State; stack=app.State.stacks.(app.SelectedRole); node=stack(app.SelectedNode);
            node.id=char(java.util.UUID.randomUUID()); stack=[stack(1:app.SelectedNode),node,stack(app.SelectedNode+1:end)];
            app.State.stacks.(app.SelectedRole)=stack; app.SelectedNode=app.SelectedNode+1;
            app.commit(before); app.refresh();
        end
        function copy(app,whole)
            if isempty(app.SelectedRole), return; end
            if ~whole && ~app.hasNode(), return; end
            names=setdiff(fieldnames(app.Sources),{app.SelectedRole},'stable');
            if isempty(names), return; end
            [destinations,answer]=captureedit.copyDialog(names);
            if isempty(destinations), return; end
            app.finishGesture(); before=app.State; sourceNodes=app.State.stacks.(app.SelectedRole);
            if ~whole, sourceNodes=sourceNodes(app.SelectedNode); end
            for d=1:numel(destinations)
                nodes=sourceNodes;
                for k=1:numel(nodes), nodes(k).id=char(java.util.UUID.randomUUID()); end
                destination=destinations{d};
                if strcmp(answer,'Append'), nodes=[app.State.stacks.(destination),nodes]; end
                app.State.stacks.(destination)=nodes;
            end
            app.commit(before); app.refresh();
        end
        function commit(app,before)
            if isequaln(before,app.State), return; end
            [app.History,~]=captureedit.editHistory('commit',app.History,before,app.State);
            app.Dirty=true; app.Revision=app.Revision+1;
        end
        function finishGesture(app)
            if isempty(app.GestureBefore), return; end
            before=app.GestureBefore; app.GestureBefore=[]; app.commit(before);
        end
        function valid=hasNode(app)
            valid=~isempty(app.SelectedRole) && isfield(app.State.stacks,app.SelectedRole) && ...
                app.SelectedNode>=1 && app.SelectedNode<=numel(app.State.stacks.(app.SelectedRole));
        end
        function [image,diagnostics]=process(app,role,approximate)
            source=app.Sources.(role); image=source.image; scale=1;
            if approximate, scale=min(1,1024/max(size(image))); end
            key=[role app.State.processingPolicy jsonencode(app.State.stacks.(role)) num2str(scale,17)];
            if isKey(app.Cache,key), entry=app.Cache(key); image=entry.image; diagnostics=entry.diagnostics; return; end
            if scale<1
                if strcmp(app.State.processingPolicy,'preserve'), image=double(image); end
                image=imresize(image,scale,'bilinear');
            end
            [image,~,diagnostics]=captureedit.evaluate(image,app.State.stacks.(role),source.range,scale,app.State.processingPolicy);
            if scale<1, image=imresize(image,size(source.image),'bilinear'); end
            entry=struct('image',image,'diagnostics',diagnostics); info=whos('entry');
            if app.CacheBytes+info.bytes>512*1024^2, app.clearCache(); end
            if info.bytes<512*1024^2, app.Cache(key)=entry; app.CacheBytes=app.CacheBytes+info.bytes; end
        end
        function setExportEnabled(app,enabled)
            controls=findobj(app.Figure,'Tag','capture-export-action');
            for k=1:numel(controls), controls(k).Enable=matlab.lang.OnOffSwitchState(enabled); end
        end
        function showDiagnostics(app,diagnostics,approximate)
            if approximate, app.Diagnostics.Text='Approximate preview: native counts pending'; return; end
            if ~isfield(diagnostics,app.SelectedRole), app.Diagnostics.Text='Select a viewed role for native filter counts'; return; end
            d=diagnostics.(app.SelectedRole); lines={'Native stages: low / high excursions; clipped low / high'};
            for k=1:numel(d.stages)
                n=d.stages(k); lines{end+1}=sprintf('%d %s: %d / %d; clipped %d / %d; masked %d (N=%d)',n.index,n.type,n.belowCount,n.aboveCount,n.clippedLowCount,n.clippedHighCount,n.thresholdAffectedCount,n.totalCount);
            end
            lines{end+1}='Counts are per stage, not additive. Blue/orange: below/above viewing range.';
            app.Diagnostics.Text=strjoin(lines,newline);
        end
        function clearCache(app)
            app.Cache=containers.Map('KeyType','char','ValueType','any'); app.CacheBytes=0;
        end
        function finishRender(app)
            app.Rendering=false;
            if app.PendingRender && isvalid(app.Figure)
                app.PendingRender=false; app.render(false);
            end
        end
        function names=viewRoles(app)
            switch app.Mode.Value
                case 'Single', names={app.SelectedRole};
                case 'Trio'
                    names={'thorcam','global','local'};
                    if ~all(isfield(app.Sources,names)), error('captureedit:MissingInputs','Trio needs ThorCam, global and local inputs.'); end
                case 'Pair'
                    left=split(app.PairLeft.Value,' '); right=split(app.PairRight.Value,' '); names={char(left(1)),char(right(1))};
            end
        end
        function ensureAxes(app,count)
            if numel(app.Axes)==count && all(isgraphics(app.Axes)), return; end
            delete(app.Viewer.Children); app.Viewer.ColumnWidth=repmat({'1x'},1,count);
            app.Axes=gobjects(1,count); app.Images=gobjects(1,count);
            for k=1:count
                app.Axes(k)=uiaxes(app.Viewer); app.Images(k)=imshow(zeros(2),'Parent',app.Axes(k));
                app.Axes(k).Toolbar.Visible='on'; app.Axes(k).Interactions=[zoomInteraction panInteraction];
                app.Axes(k).DataAspectRatio=[1 1 1];
            end
        end
        function fit(app,oneToOne)
            for k=1:numel(app.Axes)
                if ~isappdata(app.Axes(k),'imageSize'), continue; end
                sz=getappdata(app.Axes(k),'imageSize');
                if oneToOne
                    position=getpixelposition(app.Axes(k)); center=[mean(app.Axes(k).XLim),mean(app.Axes(k).YLim)];
                    app.Axes(k).XLim=center(1)+[-1 1]*position(3)/2; app.Axes(k).YLim=center(2)+[-1 1]*position(4)/2;
                else, app.Axes(k).XLim=[.5 sz(2)+.5]; app.Axes(k).YLim=[.5 sz(1)+.5]; end
            end
        end
        function chooseInputs(app)
            [paths,accepted]=captureedit.inputDialog(app.Root);
            if ~accepted, return; end
            app.Operation.Text='Loading and validating selected sources...'; drawnow;
            if app.loadPaths(paths), app.Operation.Text='Inputs loaded. Choose Alignment or Edit.'; end
        end
        function gaussianAutomatic(app,value)
            if value, app.setParameter('size',0,'changed'); else, app.setParameter('size',3,'changed'); end
        end
        function chooseRecipe(app)
            [f,p]=uigetfile('*.json','Choose trio recipe'); if ~isequal(f,0), app.importRecipe(fullfile(p,f)); end
        end
        function chooseSession(app)
            [f,p]=uigetfile('*.json','Open editing session'); if ~isequal(f,0), app.openSession(fullfile(p,f)); end
        end
        function setupGeometry(app)
            if ~isfield(app.Sources,'global')
                error('captureedit:MissingInputs','Load a global reference to configure aligned comparisons.');
            end
            before=app.State; [geometry,accepted]=captureedit.geometryDialog(app.Sources,app.State.geometry);
            if accepted, app.State.geometry=geometry; app.commit(before); app.refresh(); end
        end
        function displayRange(app)
            if isempty(app.SelectedRole), return; end
            range=app.State.displayRanges.(app.SelectedRole);
            answer=inputdlg({'Black (native intensity)','White (native intensity)'},'Display range',1, ...
                {num2str(range(1),17),num2str(range(2),17)});
            if isempty(answer), return; end
            range=[str2double(answer{1}),str2double(answer{2})];
            if any(~isfinite(range)) || range(2)<=range(1), error('captureedit:InvalidRange','White must exceed black; both must be finite.'); end
            app.State.displayRanges.(app.SelectedRole)=range;
            if ismember(app.SelectedRole,{'global','local'})
                for name={'global','local'}, if isfield(app.Sources,name{1}), app.State.displayRanges.(name{1})=range; end, end
            end
            app.Dirty=true; app.render(false);
        end
        function export(app,allImages,chosenRoles)
            if isempty(app.SelectedRole), return; end
            if ~app.PreviewValid, error('captureedit:StalePreview','Correct the failed or approximate preview before exporting.'); end
            app.finishGesture();
            if nargin>=3
                names=chosenRoles; if ischar(names), names={names}; end
                if isempty(names), return; end
                if ~all(isfield(app.Sources,names)), error('captureedit:MissingInputs','Choose loaded images for export.'); end
            elseif allImages, names=fieldnames(app.Sources); else, names={app.SelectedRole}; end
            destination=uigetdir(app.Root,'Choose parent folder for a new export folder');
            if isequal(destination,0), return; end
            displayTiff=false;
            if any(cellfun(@(r) strcmp(app.Sources.(r).format,'mat'),names))
                choice=uiconfirm(app.Figure,'Also export display-mapped 16-bit TIFFs for MAT arrays?', ...
                    'Optional display TIFF','Options',{'MAT only','MAT + display TIFF','Cancel'},'CancelOption','Cancel');
                if strcmp(choice,'Cancel'), return; end
                displayTiff=strcmp(choice,'MAT + display TIFF');
            end
            restorePreview=onCleanup(@() app.render(false));
            app.Status.Text='Exporting and verifying native-resolution images...'; drawnow;
            % Export gets the current viewing ranges only for optional display TIFFs.
            sources=app.Sources;
            for k=1:numel(names), sources.(names{k}).displayRange=app.State.displayRanges.(names{k}); end
            uniqueName=['capture-edit-' char(datetime('now','Format','yyyyMMdd-HHmmss')) '-' char(java.util.UUID.randomUUID())];
            options=struct('processingPolicy',app.State.processingPolicy,'outputMode','native','displayTiff',displayTiff,'geometry',app.State.geometry);
            plan=captureedit.preflightExport(sources,app.State.stacks,names,options);
            lines={};
            for k=1:numel(plan.images)
                record=plan.images(k); c=record.conversion; dc=record.displayConversion;
                lines{end+1}=sprintf('%s: native low/high %d/%d, rounded %d, precision %d; display low/high %d/%d',record.role,c.lowCount,c.highCount,c.roundingCount,c.precisionCount,dc.lowCount,dc.highCount);
            end
            if plan.hasClipping || plan.hasFloatOverflow
                choices={'Floating MAT','Clip native','Cancel'};
                if plan.hasFloatOverflow, choices={'Floating MAT','Cancel'}; end
                choice=uiconfirm(app.Figure,strjoin(lines,newline),'Review export losses','Options',choices,'DefaultOption',1,'CancelOption','Cancel');
                if strcmp(choice,'Cancel'), return; end
                if strcmp(choice,'Floating MAT'), plan=captureedit.convertExportPlan(plan,'floating-mat'); end
                if plan.hasClipping
                    if strcmp(choice,'Floating MAT')
                        answer=uiconfirm(app.Figure,'Floating values are preserved. The requested display TIFF still clips at the viewing limits. Export it deliberately?','Display export clipping','Options',{'Export','Cancel'},'CancelOption','Cancel');
                        if strcmp(answer,'Cancel'), return; end
                    end
                    plan.options.allowClipping=true;
                end
            elseif any(arrayfun(@(r)r.conversion.roundingCount+r.conversion.precisionCount,plan.images))
                choice=uiconfirm(app.Figure,strjoin(lines,newline),'Review export conversion','Options',{'Native export','Floating MAT','Cancel'},'CancelOption','Cancel');
                if strcmp(choice,'Cancel'), return; end
                if strcmp(choice,'Floating MAT'), plan=captureedit.convertExportPlan(plan,'floating-mat'); end
            end
            if plan.hasClipping && ~plan.options.allowClipping
                answer=uiconfirm(app.Figure,'The requested display TIFF clips values at the viewing limits. Export this derivative deliberately?','Display export clipping','Options',{'Export','Cancel'},'CancelOption','Cancel');
                if strcmp(answer,'Cancel'), return; end
                plan.options.allowClipping=true;
            end
            result=captureedit.writeExport(plan,fullfile(destination,uniqueName));
            app.LastExport=result.directory; app.Operation.Text=['Export verified: ' result.directory];
        end
        function yes=allowReplace(app)
            app.finishGesture(); yes=true;
            if ~app.Dirty, return; end
            answer=uiconfirm(app.Figure,'Save this editing session before continuing?','Unsaved edits', ...
                'Options',{'Save','Discard','Cancel'},'DefaultOption','Save','CancelOption','Cancel');
            if strcmp(answer,'Cancel'), yes=false;
            elseif strcmp(answer,'Save'), yes=app.saveSession(); end
        end
        function close(app)
            app.safe(@finish);
            function finish()
                if app.allowReplace(), delete(app.Figure); end
            end
        end
        function key(app,event)
            focus=app.Figure.CurrentObject;
            if isa(focus,'matlab.ui.control.EditField') || isa(focus,'matlab.ui.control.NumericEditField') || isa(focus,'matlab.ui.control.TextArea'), return; end
            if strcmp(event.Key,'space') && ~app.SpaceHeld
                app.SpaceHeld=true; app.SpaceOriginal=app.Original.Value; app.Original.Value=true; app.render(false);
            elseif ismember('control',event.Modifier)
                if strcmp(event.Key,'z') && ~ismember('shift',event.Modifier), app.safe(@() app.undo());
                elseif strcmp(event.Key,'y') || (strcmp(event.Key,'z') && ismember('shift',event.Modifier)), app.safe(@() app.redo());
                elseif strcmp(event.Key,'s'), app.safe(@() app.saveSession()); end
            end
        end
        function releaseKey(app,event)
            if strcmp(event.Key,'space') && app.SpaceHeld, app.SpaceHeld=false; app.Original.Value=app.SpaceOriginal; app.render(false); end
        end
        function safe(app,action)
            try, action(); catch cause
                app.Operation.Text=cause.message;
                if strcmp(app.Figure.Visible,'on'), uialert(app.Figure,cause.message,'Capture editor'); end
            end
        end
        function button(app,parent,text,action)
            control=uibutton(parent,'Text',text,'ButtonPushedFcn',@(~,~) app.safe(action));
            if startsWith(text,'Export chosen') || startsWith(text,'Export selected') || startsWith(text,'Export all'), control.Tag='capture-export-action'; control.Enable='off'; end
        end
    end
    methods (Static, Access=private)
        function stack=emptyStack()
            stack=struct('id',{},'type',{},'enabled',{},'params',{});
        end
        function image=normalize(image,range)
            image=min(max((double(image)-range(1))/(range(2)-range(1)),0),1);
        end
    end
end
