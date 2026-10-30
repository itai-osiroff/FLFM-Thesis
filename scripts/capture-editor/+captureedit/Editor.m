classdef Editor < handle
    %EDITOR Native-image editing controller and persistent MATLAB desktop UI.
    properties
        Figure
        Sources = struct()
        State = struct('stacks',struct(),'geometry',[],'displayRanges',struct())
        History
        Root
        Dirty = false
        SessionPath = ''
        SelectedRole = ''
        SelectedNode = 0
        Status
    end
    properties (Access=private)
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
        function accepted=loadPaths(app,paths)
            accepted=false;
            if ~app.allowReplace(), return; end
            sources=captureedit.loadSources(app.Root,paths);
            if isempty(fieldnames(sources)), return; end
            app.Sources=sources; app.State=struct('stacks',struct(),'geometry',[],'displayRanges',struct());
            names=fieldnames(sources);
            for k=1:numel(names)
                app.State.stacks.(names{k})=app.emptyStack();
                app.State.displayRanges.(names{k})=sources.(names{k}).displayRange;
            end
            app.History=captureedit.editHistory('new'); app.GestureBefore=[];
            app.SessionPath=''; app.Dirty=false; app.SelectedRole=names{1}; app.SelectedNode=0;
            app.clearCache(); app.refresh(); accepted=true;
        end
        function importRecipe(app,path)
            recipe=triofig.readRecipe(path); input=recipe.input;
            paths=struct('thorcam',fullfile(app.Root,input.thorcamCaptureRelativePath), ...
                'validation',fullfile(app.Root,input.validationCaptureRelativePath), ...
                'global',fullfile(app.Root,input.workspaceRelativePath),'local',fullfile(app.Root,input.workspaceRelativePath));
            if ~app.loadPaths(paths), return; end
            app.State.geometry=captureedit.resolveGeometry(app.Sources,recipe,false);
            app.Dirty=true; app.refresh();
        end
        function openSession(app,path)
            if ~app.allowReplace(), return; end
            [sources,stacks,geometry,history,view]=captureedit.loadSession(path,app.Root);
            app.Sources=sources; app.State=struct('stacks',stacks,'geometry',geometry,'displayRanges',struct());
            names=fieldnames(sources);
            for k=1:numel(names), app.State.displayRanges.(names{k})=sources.(names{k}).displayRange; end
            if isfield(view,'displayRanges'), app.State.displayRanges=view.displayRanges; end
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
                'mode',app.Mode.Value,'pairLeft',app.PairLeft.Value,'pairRight',app.PairRight.Value);
            captureedit.saveSession(path,app.Root,app.Sources,app.State.stacks,app.State.geometry,app.History,view);
            app.SessionPath=char(path); app.Dirty=false; saved=true;
            app.Status.Text=['Session saved: ' char(path)];
        end
        function addFilter(app,type)
            if isempty(app.SelectedRole), return; end
            app.finishGesture(); before=app.State;
            def=app.Catalog(strcmp({app.Catalog.type},type));
            node=struct('id',char(java.util.UUID.randomUUID()),'type',def.type,'enabled',true,'params',def.params);
            stack=app.State.stacks.(app.SelectedRole); stack(end+1)=node;
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
            elseif strcmp(name,'binary'), value=round(value);
            end
            if strcmp(node.type,'window')
                if strcmp(name,'black'), value=min(value,node.params.white-1e-6);
                else, value=max(value,node.params.black+1e-6); end
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
        function undo(app)
            app.finishGesture(); [app.History,app.State]=captureedit.editHistory('undo',app.History,app.State);
            app.Dirty=true; app.refresh();
        end
        function redo(app)
            app.finishGesture(); [app.History,app.State]=captureedit.editHistory('redo',app.History,app.State);
            app.Dirty=true; app.refresh();
        end
        function render(app,approximate)
            if isempty(fieldnames(app.Sources)), return; end
            if app.Rendering, app.PendingRender=true; return; end
            app.Rendering=true; cleanup=onCleanup(@() app.finishRender());
            revision=app.Revision;
            if approximate, app.Status.Text='Approximate preview · release the control for native-resolution processing';
            else, app.Status.Text='Processing native-resolution images…'; end
            drawnow limitrate;
            try
                names=app.viewRoles(); aligned=~strcmp(app.Mode.Value,'Single') && ~isempty(app.State.geometry);
                if aligned, required=fieldnames(app.Sources); else, required=unique(names,'stable'); end
                if app.Histogram.Value, required=unique([required(:);{app.SelectedRole}],'stable'); end
                edited=struct(); original=struct();
                for k=1:numel(required)
                    role=required{k}; original.(role)=app.Sources.(role).image;
                    edited.(role)=app.process(role,approximate);
                end
                if aligned
                    edited=captureedit.comparisonPanels(edited,app.State.geometry);
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
                    range=app.State.displayRanges.(role); normalized=app.normalize(image,range);
                    if app.Clipping.Value
                        rgb=repmat(normalized,1,1,3); mask=normalized<=0 | normalized>=1;
                        plane=rgb(:,:,1); plane(mask)=1; rgb(:,:,1)=plane;
                        plane=rgb(:,:,2); plane(mask)=0; rgb(:,:,2)=plane;
                        plane=rgb(:,:,3); plane(mask)=1; rgb(:,:,3)=plane; normalized=rgb;
                    end
                    app.Images(k).CData=normalized; app.Images(k).XData=[1 size(image,2)]; app.Images(k).YData=[1 size(image,1)];
                    if ~isappdata(app.Axes(k),'initialized') || ~isequal(getappdata(app.Axes(k),'imageSize'),size(image))
                        app.Axes(k).XLim=[.5 size(image,2)+.5]; app.Axes(k).YLim=[.5 size(image,1)+.5];
                        setappdata(app.Axes(k),'initialized',true); setappdata(app.Axes(k),'imageSize',size(image));
                    end
                    title(app.Axes(k),sprintf('%s · %s',role,variant),'Interpreter','none');
                end
                if aligned && numel(names)>1, linkaxes(app.Axes,'xy'); else, linkaxes(app.Axes,'off'); end
                if app.Histogram.Value
                    values=app.normalize(edited.(app.SelectedRole),app.State.displayRanges.(app.SelectedRole));
                    histogram(app.HistAxes,values(:),64,'BinLimits',[0 1]); title(app.HistAxes,[app.SelectedRole ' · edited intensity']);
                    app.HistAxes.Visible='on';
                else, cla(app.HistAxes); app.HistAxes.Visible='off'; end
                if approximate, quality='Approximate'; else, quality='Exact'; end
                if aligned, context='aligned common field'; else, context='native grid'; end
                app.Status.Text=sprintf('%s · %s · filters operate in native pixels',quality,context);
            catch cause
                app.Status.Text=['Preview failed: ' cause.message];
            end
        end
    end
    methods (Access=private)
        function build(app,visible)
            app.Figure=uifigure('Name','Native Capture Editor','Position',[40 40 1550 930], ...
                'Visible',visible,'Tag','capture-editor','CloseRequestFcn',@(~,~) app.close());
            app.Figure.WindowKeyPressFcn=@(~,e) app.key(e);
            app.Figure.WindowKeyReleaseFcn=@(~,e) app.releaseKey(e);
            grid=uigridlayout(app.Figure,[3 1],'RowHeight',{76,'1x',32});
            toolbar=uigridlayout(grid,[2 8],'RowHeight',{30 30});
            app.button(toolbar,'Load inputs',@() app.chooseInputs());
            app.button(toolbar,'Import trio recipe',@() app.chooseRecipe());
            app.button(toolbar,'Open session',@() app.chooseSession());
            app.button(toolbar,'Save session',@() app.saveSession());
            app.button(toolbar,'Undo',@() app.undo()); app.button(toolbar,'Redo',@() app.redo());
            app.button(toolbar,'Export selected',@() app.export(false)); app.button(toolbar,'Export all',@() app.export(true));
            app.Mode=uidropdown(toolbar,'Items',{'Single','Trio','Pair'},'Tag','capture-view','ValueChangedFcn',@(~,~) app.safe(@() app.refresh()));
            app.PairLeft=uidropdown(toolbar,'Items',{'No inputs'},'Tag','capture-pair-left','ValueChangedFcn',@(~,~) app.render(false));
            app.PairRight=uidropdown(toolbar,'Items',{'No inputs'},'Tag','capture-pair-right','ValueChangedFcn',@(~,~) app.render(false));
            app.button(toolbar,'Comparison setup',@() app.setupGeometry());
            app.button(toolbar,'Fit',@() app.fit(false)); app.button(toolbar,'1:1',@() app.fit(true));
            app.button(toolbar,'Display range',@() app.displayRange());
            app.Original=uicheckbox(toolbar,'Text','Show original (hold Space)','ValueChangedFcn',@(~,~) app.render(false));
            body=uigridlayout(grid,[1 3],'ColumnWidth',{205,'1x',345});
            left=uigridlayout(body,[5 1],'RowHeight',{25,180,110,25,'1x'});
            uilabel(left,'Text','Native inputs','FontWeight','bold');
            app.Roles=uilistbox(left,'Items',{'Load inputs to begin'},'ValueChangedFcn',@(~,~) app.selectRole());
            app.Details=uilabel(left,'Text','Sources remain unchanged.','WordWrap','on');
            app.Clipping=uicheckbox(left,'Text','Highlight clipping','ValueChangedFcn',@(~,~) app.render(false));
            app.Histogram=uicheckbox(left,'Text','Show histogram','ValueChangedFcn',@(~,~) app.render(false));
            center=uigridlayout(body,[2 1],'RowHeight',{'1x',135});
            app.Viewer=uigridlayout(center,[1 1]); app.HistAxes=uiaxes(center,'Visible','off');
            right=uigridlayout(body,[9 1],'RowHeight',{25,30,32,175,68,25,32,25,'1x'});
            uilabel(right,'Text','Ordered filter stack','FontWeight','bold');
            app.FilterType=uidropdown(right,'Items',{app.Catalog.label},'ItemsData',{app.Catalog.type});
            app.button(right,'Add filter',@() app.addFilter(app.FilterType.Value));
            app.FilterList=uilistbox(right,'Items',{'No filters'},'ValueChangedFcn',@(~,~) app.selectNode(),'Tag','capture-filters');
            controls=uigridlayout(right,[2 3]);
            app.button(controls,'Remove',@() app.removeFilter()); app.button(controls,'Duplicate',@() app.duplicate());
            app.button(controls,'Copy…',@() app.copy(false)); app.button(controls,'Move up',@() app.moveFilter(-1));
            app.button(controls,'Move down',@() app.moveFilter(1)); app.button(controls,'Copy stack…',@() app.copy(true));
            app.Enabled=uicheckbox(right,'Text','Enabled','ValueChangedFcn',@(s,~) app.toggleFilter(s.Value));
            uilabel(right,'Text','Gaussian size 0 = automatic; sizes use native pixels','WordWrap','on');
            uilabel(right,'Text','Filter parameters','FontWeight','bold');
            panel=uipanel(right,'Scrollable','on'); app.Parameters=uigridlayout(panel,[1 1]);
            app.Status=uilabel(grid,'Text','Load captures or import a trio recipe to begin.','Tag','capture-status');
            app.Figure.UserData=app;
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
            app.Details.Text=sprintf('%s\n%d × %d · %s · %s\n%s',app.SelectedRole,size(source.image,2),size(source.image,1),class(source.image),source.format,source.relativePath);
            stack=app.State.stacks.(app.SelectedRole);
            if isempty(stack)
                app.SelectedNode=0; app.FilterList.Items={'No filters'}; app.FilterList.ItemsData=0;
            else
                labels=cell(1,numel(stack));
                for k=1:numel(stack)
                    def=app.Catalog(strcmp({app.Catalog.type},stack(k).type));
                    if stack(k).enabled, flag='on'; else, flag='off'; end
                    labels{k}=sprintf('%d · %s [%s]',k,def.label,flag);
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
                field=uieditfield(row,'numeric','Limits',[knob.min knob.max],'Value',node.params.(knob.name), ...
                    'ValueChangedFcn',@(s,~) app.safe(@() app.setParameter(knob.name,s.Value,'changed')));
                slider=uislider(row,'Limits',[knob.min knob.max],'Value',node.params.(knob.name),'MajorTicks',[],'MinorTicks',[]);
                slider.Layout.Column=[1 2];
                slider.ValueChangingFcn=@(s,e) app.parameterDrag(knob.name,e.Value,field,s);
                slider.ValueChangedFcn=@(s,~) app.safe(@() app.setParameter(knob.name,s.Value,'changed'));
                hint=''; range=app.Sources.(app.SelectedRole).range;
                if ismember(knob.name,{'cutoff','black','white'}), hint=sprintf('Native intensity: %.6g',range(1)+node.params.(knob.name)*diff(range));
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
            [index,ok]=listdlg('ListString',names,'SelectionMode','single','PromptString','Copy to image');
            if ~ok, return; end
            answer=uiconfirm(app.Figure,'Append to or replace the destination stack?','Copy filters', ...
                'Options',{'Append','Replace','Cancel'},'DefaultOption','Append','CancelOption','Cancel');
            if strcmp(answer,'Cancel'), return; end
            before=app.State; nodes=app.State.stacks.(app.SelectedRole);
            if ~whole, nodes=nodes(app.SelectedNode); end
            for k=1:numel(nodes), nodes(k).id=char(java.util.UUID.randomUUID()); end
            destination=names{index};
            if strcmp(answer,'Append'), nodes=[app.State.stacks.(destination),nodes]; end
            app.State.stacks.(destination)=nodes; app.commit(before); app.refresh();
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
        function image=process(app,role,approximate)
            source=app.Sources.(role); image=source.image; scale=1;
            if approximate, scale=min(1,1024/max(size(image))); end
            key=[role jsonencode(app.State.stacks.(role)) num2str(scale,17)];
            if isKey(app.Cache,key), image=app.Cache(key); return; end
            if scale<1, image=imresize(image,scale,'bilinear'); end
            image=captureedit.evaluate(image,app.State.stacks.(role),source.range,scale);
            if scale<1, image=imresize(image,size(source.image),'bilinear'); end
            info=whos('image');
            if app.CacheBytes+info.bytes>512*1024^2, app.clearCache(); end
            if info.bytes<512*1024^2, app.Cache(key)=image; app.CacheBytes=app.CacheBytes+info.bytes; end
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
            if ~app.allowReplace(), return; end
            paths=struct(); roles={'thorcam','validation','global','local'};
            discovery=triofig.discoverInputs(app.Root,'');
            for k=1:numel(roles)
                role=roles{k}; discoveryRole=role;
                if ismember(role,{'global','local'}), discoveryRole='workspace'; end
                candidates=discovery.(discoveryRole).candidates;
                if ~isempty(candidates)
                    labels=cellfun(@(p) erase(p,[app.Root filesep]),candidates,'UniformOutput',false);
                    labels=[labels(:);{'Browse for another file…';'Skip this role'}];
                    [index,selected]=listdlg('ListString',labels,'SelectionMode','single', ...
                        'ListSize',[650 260],'PromptString',['Choose ' role ' input; suggestions require explicit selection']);
                    if ~selected || index==numel(labels), continue; end
                    if index<=numel(candidates), paths.(role)=candidates{index}; continue; end
                end
                [file,path]=uigetfile({'*.tif;*.tiff;*.png;*.mat','Grayscale TIFF, PNG or MAT'}, ...
                    ['Choose ' role ' (Cancel skips this role)'],app.Root);
                if ~isequal(file,0), paths.(role)=fullfile(path,file); end
            end
            if isempty(fieldnames(paths)), return; end
            % Save/discard has already been handled above.
            wasDirty=app.Dirty; app.Dirty=false;
            try, app.loadPaths(paths); catch cause, app.Dirty=wasDirty; rethrow(cause); end
        end
        function chooseRecipe(app)
            [f,p]=uigetfile('*.json','Choose trio recipe'); if ~isequal(f,0), app.importRecipe(fullfile(p,f)); end
        end
        function chooseSession(app)
            [f,p]=uigetfile('*.json','Open editing session'); if ~isequal(f,0), app.openSession(fullfile(p,f)); end
        end
        function setupGeometry(app)
            if ~all(isfield(app.Sources,{'thorcam','validation','global','local'}))
                error('captureedit:MissingInputs','Aligned comparison requires all four inputs.');
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
        function export(app,allImages)
            if isempty(app.SelectedRole), return; end
            app.finishGesture(); destination=uigetdir(app.Root,'Choose parent folder for a new export folder');
            if isequal(destination,0), return; end
            if allImages, names=fieldnames(app.Sources); else, names={app.SelectedRole}; end
            displayTiff=false;
            if any(cellfun(@(r) strcmp(app.Sources.(r).format,'mat'),names))
                choice=uiconfirm(app.Figure,'Also export display-mapped 16-bit TIFFs for MAT arrays?', ...
                    'Optional display TIFF','Options',{'MAT only','MAT + display TIFF','Cancel'},'CancelOption','Cancel');
                if strcmp(choice,'Cancel'), return; end
                displayTiff=strcmp(choice,'MAT + display TIFF');
            end
            app.Status.Text='Exporting and verifying native-resolution images…'; drawnow;
            % Export gets the current viewing ranges only for optional display TIFFs.
            sources=app.Sources;
            for k=1:numel(names), sources.(names{k}).displayRange=app.State.displayRanges.(names{k}); end
            uniqueName=['capture-edit-' char(datetime('now','Format','yyyyMMdd-HHmmss')) '-' char(java.util.UUID.randomUUID())];
            result=captureedit.exportImages(sources,app.State.stacks,names,fullfile(destination,uniqueName),app.State.geometry,displayTiff);
            app.Status.Text=['Export verified: ' result.directory];
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
            if strcmp(event.Key,'space') && ~app.Original.Value
                app.Original.Value=true; app.render(false);
            elseif ismember('control',event.Modifier)
                if strcmp(event.Key,'z') && ~ismember('shift',event.Modifier), app.safe(@() app.undo());
                elseif strcmp(event.Key,'y') || (strcmp(event.Key,'z') && ismember('shift',event.Modifier)), app.safe(@() app.redo());
                elseif strcmp(event.Key,'s'), app.safe(@() app.saveSession()); end
            end
        end
        function releaseKey(app,event)
            if strcmp(event.Key,'space'), app.Original.Value=false; app.render(false); end
        end
        function safe(app,action)
            try, action(); catch cause
                app.Status.Text=cause.message;
                if strcmp(app.Figure.Visible,'on'), uialert(app.Figure,cause.message,'Capture editor'); end
            end
        end
        function button(app,parent,text,action)
            uibutton(parent,'Text',text,'ButtonPushedFcn',@(~,~) app.safe(action));
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
