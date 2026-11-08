"""Combined composition page hosted in the existing single-view wizard."""
import json
from pathlib import Path
import tkinter as tk
from tkinter import ttk, messagebox
from matplotlib.figure import Figure
from matplotlib.widgets import RectangleSelector
import numpy as np
import alignment_evolution as model
from alignment_evolution_panels import draw


def compose(w):
    renderer=draw
    if w.recipe.get('renderer_snapshot'):
        import importlib.util
        source=(w.path.parent/w.recipe['renderer_snapshot']).resolve()
        if model.digest(source)!=w.recipe['renderer_sha256']: raise ValueError('Renderer snapshot hash mismatch.')
        spec=importlib.util.spec_from_file_location('saved_gui_renderer',source)
        module=importlib.util.module_from_spec(spec); spec.loader.exec_module(module); renderer=module.draw
    page=w.page('Combined alignment: view, crop and sampling')
    ttk.Label(page,text='Drag the image to crop; click to place output p. View indices are [i=row, j=column], zero-based.').pack(anchor='w')
    controls=ttk.Frame(page); controls.pack(fill='x')
    values={}
    for key,label,width in [('view','View i,j',7),('crop','Crop x0,y0,x1,y1',19),('sample_yx','Sample y,x',9),('global_arrow_spacing','Global spacing',4),('local_arrow_spacing','Local spacing',4),('enlargement_radius','Zoom radius',4),('arrow_magnification','Arrow scale',4),('display_limits','Intensity limits',14)]:
        ttk.Label(controls,text=label).pack(side='left')
        value=tk.StringVar(value=', '.join(map(str,w.recipe[key])) if isinstance(w.recipe[key],list) else str(w.recipe[key]))
        ttk.Entry(controls,textvariable=value,width=width).pack(side='left',padx=3); values[key]=value
    body=ttk.Frame(page); body.pack(fill='both',expand=True)
    left=ttk.Frame(body); left.pack(side='left',fill='both',expand=True)
    right=ttk.Frame(body); right.pack(side='left',fill='both',expand=True)
    guide=Figure(figsize=(4,5)); ax=guide.add_subplot(); gc=w.canvas(guide,left)
    fig=Figure(figsize=(145/25.4,130/25.4)); pc=w.canvas(fig,right)
    w.preview=None
    buttons=ttk.Frame(page); buttons.pack(fill='x')
    def redraw():
        d=model.resolve(w.bundle,w.recipe); ax.clear(); v=tuple(w.recipe['view'])
        ax.imshow(w.bundle['aligned'][v],cmap='gray',vmin=d['display_limits'][0],vmax=d['display_limits'][1]); ax.set_title('Globally aligned view: crop / click sample')
        x0,y0,x1,y1=d['crop']; from matplotlib.patches import Rectangle
        ax.add_patch(Rectangle((x0-.5,y0-.5),x1-x0,y1-y0,fill=False,edgecolor='orange'))
        y,x=w.recipe['sample_yx']; ax.scatter(x,y,c='magenta',marker='+')
        renderer(fig,w.bundle,w.recipe,d); gc.draw_idle(); pc.draw_idle()
    def dirty(*_):
        w.preview=None; select.configure(state='disabled')
    def apply():
        try:
            updated=dict(w.recipe)
            for key,value in values.items():
                text=value.get().replace(',',' ').split()
                updated[key]=[float(v) for v in text] if key=='display_limits' else [int(v) for v in text] if key in ('view','crop','sample_yx') else float(text[0]) if key=='arrow_magnification' else int(text[0])
            updated.pop('resolved_display',None)
            model.resolve(w.bundle,updated)
            w.recipe=updated; w.checkpoint(); dirty(); redraw(); return True
        except (ValueError,IndexError,KeyError) as exc: w.status.set(str(exc)); return False
    def set_values(updates):
        for key,value in updates.items(): values[key].set(', '.join(map(str,value)))
        apply()
    def crop(a,b):
        if a.xdata is None or b.xdata is None: return
        h,ww=w.bundle['global_average'].shape
        x0,x1=sorted((a.xdata,b.xdata)); y0,y1=sorted((a.ydata,b.ydata))
        crop=[max(0,int(x0)),max(0,int(y0)),min(ww,int(x1)+1),min(h,int(y1)+1)]
        p=w.recipe['sample_yx']
        if not(crop[1]<=p[0]<crop[3] and crop[0]<=p[1]<crop[2]): p=[(crop[1]+crop[3])//2,(crop[0]+crop[2])//2]
        set_values({'crop':crop,'sample_yx':p})
    start=[None]
    def press(e): start[0]=(e.x,e.y) if e.inaxes is ax else None
    def release(e):
        if start[0] and e.inaxes is ax and abs(e.x-start[0][0])+abs(e.y-start[0][1])<5:
            set_values({'sample_yx':[round(e.ydata),round(e.xdata)]})
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
