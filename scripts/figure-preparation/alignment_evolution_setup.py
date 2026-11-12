"""Combined composition page hosted in the existing single-view wizard."""
import json
from pathlib import Path
import tkinter as tk
from tkinter import ttk, messagebox
from matplotlib.figure import Figure
from matplotlib.widgets import RectangleSelector
import numpy as np
import alignment_evolution as model
from alignment_evolution_panels import draw, FIGSIZE_IN, REGION_COLORS, arrow_segments


def compose(w):
    renderer=draw
    if w.recipe.get('renderer_snapshot'):
        import importlib.util
        source=(w.path.parent/w.recipe['renderer_snapshot']).resolve()
        if model.digest(source)!=w.recipe['renderer_sha256']: raise ValueError('Renderer snapshot hash mismatch.')
        spec=importlib.util.spec_from_file_location('saved_gui_renderer',source)
        module=importlib.util.module_from_spec(spec); spec.loader.exec_module(module); renderer=module.draw
    if w.recipe.get('layout_version')==1:
        w.recipe=model.as_layout2(w.bundle,w.recipe); w.checkpoint()
    page=w.page('Combined alignment: view, two regions and sampling')
    ttk.Label(page,text='Pick the active region, then drag to set its crop (regions may differ in size and must not overlap). Click centres the active region with the size of the other region. View indices are [i=row, j=column], zero-based.').pack(anchor='w')
    controls=ttk.Frame(page); controls.pack(fill='x')
    values={}; active=tk.IntVar(value=0); overlay=tk.BooleanVar(value=False)
    for k in (0,1): ttk.Radiobutton(controls,text=f'Region {k+1}',variable=active,value=k).pack(side='left')
    ttk.Checkbutton(controls,text='Local field',variable=overlay,command=lambda: redraw()).pack(side='left',padx=4)
    for key,label,width in [('view','View i,j',7),('region_1','R1 x0,y0,x1,y1',19),('region_2','R2 x0,y0,x1,y1',19),('global_arrow_spacing','Global spacing',4),('local_arrow_spacing','Local spacing',4),('arrow_magnification','Global arrow scale',4),('local_arrow_magnification','Local arrow scale',4),('display_limits','Intensity limits',14)]:
        ttk.Label(controls,text=label).pack(side='left')
        init=w.recipe['regions'][int(key[-1])-1] if key.startswith('region_') else w.recipe.get(key,w.recipe['arrow_magnification']) if key=='local_arrow_magnification' else w.recipe[key]
        value=tk.StringVar(value=', '.join(map(str,init)) if isinstance(init,list) else str(init))
        ttk.Entry(controls,textvariable=value,width=width).pack(side='left',padx=3); values[key]=value
    body=ttk.Frame(page); body.pack(fill='both',expand=True)
    left=ttk.Frame(body); left.pack(side='left',fill='both',expand=True)
    right=ttk.Frame(body); right.pack(side='left',fill='both',expand=True)
    guide=Figure(figsize=(4,5)); ax=guide.add_subplot(); gc=w.canvas(guide,left)
    fig=Figure(figsize=FIGSIZE_IN); pc=w.canvas(fig,right)
    w.preview=None
    buttons=ttk.Frame(page); buttons.pack(fill='x')
    def redraw():
        d=model.resolve(w.bundle,w.recipe); ax.clear(); v=tuple(w.recipe['view'])
        ax.imshow(w.bundle['aligned'][v],cmap='gray',vmin=d['display_limits'][0],vmax=d['display_limits'][1]); ax.set_title('Globally aligned view: regions')
        from matplotlib.patches import Rectangle
        for k,g in enumerate(d['regions']):
            x0,y0,x1,y1=g['crop']; ax.add_patch(Rectangle((x0-.5,y0-.5),x1-x0,y1-y0,fill=False,edgecolor=REGION_COLORS[k],linewidth=2 if k==active.get() else 1))
        if overlay.get():
            h,ww=w.bundle['global_average'].shape
            t,hd,_=arrow_segments(w.bundle['fields'][v],(0,0,ww,h),25,w.recipe['arrow_magnification'],(h,ww))
            if len(t): ax.quiver(t[:,1],t[:,0],hd[:,1]-t[:,1],hd[:,0]-t[:,0],angles='xy',scale_units='xy',scale=1,pivot='tail',color='yellow',width=.004)
        renderer(fig,w.bundle,w.recipe,d); gc.draw_idle(); pc.draw_idle()
    def dirty(*_):
        w.preview=None; select.configure(state='disabled')
    def apply():
        try:
            updated=dict(w.recipe)
            regions=[None,None]
            for key,value in values.items():
                text=value.get().replace(',',' ').split()
                if key.startswith('region_'): regions[int(key[-1])-1]=[int(v) for v in text]; continue
                updated[key]=[float(v) for v in text] if key=='display_limits' else [int(v) for v in text] if key=='view' else float(text[0]) if key in ('arrow_magnification','local_arrow_magnification') else int(text[0])
            updated['regions']=regions; updated.pop('resolved_display',None)
            model.resolve(w.bundle,updated)
            w.recipe=updated; w.checkpoint(); dirty(); redraw(); w.status.set(''); return True
        except (ValueError,IndexError,KeyError) as exc: w.status.set(str(exc)); return False
    def set_values(updates):
        for key,value in updates.items(): values[key].set(', '.join(map(str,value)))
        apply()
    def place(k,box):
        """Set region k to `box`. The regions may differ in size; the other region is left alone."""
        set_values({f'region_{k+1}':box})
    def crop(a,b):
        if a.xdata is None or b.xdata is None: return
        h,ww=w.bundle['global_average'].shape
        x0,x1=sorted((a.xdata,b.xdata)); y0,y1=sorted((a.ydata,b.ydata))
        place(active.get(),[max(0,int(x0)),max(0,int(y0)),min(ww,int(x1)+1),min(h,int(y1)+1)])
    start=[None]
    def press(e): start[0]=(e.x,e.y) if e.inaxes is ax else None
    def release(e):
        if start[0] and e.inaxes is ax and abs(e.x-start[0][0])+abs(e.y-start[0][1])<5:
            k=active.get(); x0,y0,x1,y1=w.recipe['regions'][1-k]; bw,bh=x1-x0,y1-y0
            h,ww=w.bundle['global_average'].shape
            cx=min(max(int(round(e.xdata))-bw//2,0),ww-bw); cy=min(max(int(round(e.ydata))-bh//2,0),h-bh)
            place(k,[cx,cy,cx+bw,cy+bh])
        start[0]=None
    def preview():
        if not apply(): return
        try:
            w.preview=model.render(w.path,w.recipe); select.configure(state='normal'); w.status.set(f'Preview ready: {w.preview}')
        except (OSError,ValueError,KeyError) as exc: messagebox.showerror('Preview failed',str(exc))
    def use():
        try: w.status.set(f'Selected {model.select_export(w.preview,w.path.parent)}')
        except (OSError,ValueError) as exc: messagebox.showerror('Selection failed',str(exc))
    def restore():
        try:
            p=w.path.parent/'selected'/'figure.recipe.json'; r=json.loads(p.read_text()); w.bundle,w.metadata=model.load_bundle(p,r)
            r['run_bundle']=str((p.parent/r['run_bundle']).resolve()); r.pop('resolved_display',None)
            r['renderer_snapshot']=str((p.parent/r['renderer_snapshot']).resolve())
            w.recipe=r; w.checkpoint(); compose(w)
        except (OSError,ValueError) as exc: messagebox.showerror('Restore failed',str(exc))
    def adopt():
        nonlocal renderer
        renderer=draw
        w.recipe.pop('renderer_snapshot',None); w.recipe.pop('renderer_sha256',None)
        w.checkpoint(); dirty(); redraw(); w.status.set('Current renderer adopted for the next preview.')
    for label,fn in [('Run details',lambda:w.run_review(w.review)),('Change source run',w.change_run),('Apply values',apply),('Generate preview',preview),('Open preview',lambda: __import__('os').startfile(w.preview) if w.preview else None),('Restore selected',restore),('Adopt current renderer',adopt)]:
        ttk.Button(buttons,text=label,command=fn).pack(side='left',padx=3)
    select=ttk.Button(buttons,text='Use this figure',command=use,state='disabled'); select.pack(side='left')
    for value in values.values(): value.trace_add('write',dirty)
    gc.selector=RectangleSelector(ax,crop,button=[1],minspanx=6,minspany=6,spancoords='pixels')
    gc.mpl_connect('button_press_event',press); gc.mpl_connect('button_release_event',release)
    redraw()
