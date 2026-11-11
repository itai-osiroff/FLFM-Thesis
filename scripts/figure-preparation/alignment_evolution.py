"""Versioned combined figures from saved reconstruction products (no reconstruction)."""
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
from tempfile import TemporaryDirectory
from uuid import uuid4
import numpy as np
from single_view_figure import digest, save_json, bounds, five_images, display_limits

KIND = 'alignment_evolution'
RENDERER = Path(__file__).with_name('alignment_evolution_panels.py')


def initialize_new(recipe, data, meta):
    from displacement_figure import read_run
    workspace=next(Path(p) for p in meta['artifacts'] if Path(p).name in ('workspace.npz','workspace.mat'))
    fields,fmeta=read_run(workspace,meta['artifacts'][str(workspace)])
    if meta['effective_config']!=fmeta['effective_config']: raise ValueError('Effective configuration differs.')
    data.update(shifts=fields['shifts'],fields=fields['fields']); check_global(data)
    h,w=data['global_average'].shape
    recipe.pop('crop',None)
    first=default_region((h,w))
    second=suggest_region(data,recipe['view'],first)
    recipe.pop('sample_yx',None); recipe.pop('enlargement_radius',None)
    recipe.update(figure_kind=KIND,schema_version=1,layout_version=2,bundle_id=meta['run_id'],
                  regions=[first,second],global_arrow_spacing=24,local_arrow_spacing=12,arrow_magnification=1.0,
                  validation={'global_translation':'exact, all views','local_remap':'all views; rtol=1e-6, atol=1e-6'})


def default_region(shape):
    """A centred box about a quarter of the view on each side."""
    h,w=shape; bh,bw=max(1,h//4),max(1,w//4)
    x0,y0=(w-bw)//2,(h-bh)//2
    return [x0,y0,x0+bw,y0+bh]


def suggest_region(data, view, first, stride=None):
    """Same-size, non-overlapping window whose mean local displacement differs most
    from `first`, among the brightest quarter of windows (so beads are present)."""
    view=tuple(view); x0,y0,x1,y1=first; bw,bh=x1-x0,y1-y0
    stride=stride or max(1,min(16,bw//4,bh//4))
    field=data['fields'][view]; image=data['aligned'][view]; h,w=image.shape
    base=field[y0:y1,x0:x1].reshape(-1,2).mean(0)
    cands=[(ya,xa) for ya in range(0,h-bh+1,stride) for xa in range(0,w-bw+1,stride)
           if xa>=x1 or xa+bw<=x0 or ya>=y1 or ya+bh<=y0]
    if not cands: raise ValueError('No room for a second region of the same size.')
    brightness=np.array([image[ya:ya+bh,xa:xa+bw].mean() for ya,xa in cands])
    ok=brightness>=np.percentile(brightness,75)
    best=max((c for c,keep in zip(cands,ok) if keep),
             key=lambda c: np.linalg.norm(field[c[0]:c[0]+bh,c[1]:c[1]+bw].reshape(-1,2).mean(0)-base))
    return [best[1],best[0],best[1]+bw,best[0]+bh]


def as_layout2(data, recipe):
    """Return a layout-2 copy of a layout-1 recipe (region 1 = the old crop, region 2 suggested)."""
    first=list(recipe['crop'])
    out={k:val for k,val in recipe.items() if k not in ('crop','resolved_display','renderer_snapshot','renderer_sha256','sample_yx','enlargement_radius')}
    out.update(layout_version=2,regions=[first,suggest_region(data,recipe['view'],first)])
    return out


def upgrade_layout(path):
    """Rewrite a layout-1 combined recipe as layout 2, keeping a layout-1 backup beside it."""
    path=Path(path).resolve(); recipe=json.loads(path.read_text(encoding='utf-8'))
    if recipe.get('layout_version')!=1: raise ValueError('Only layout 1 recipes can be upgraded.')
    data,_=load_bundle(path,recipe); upgraded=as_layout2(data,recipe)
    resolve(data,upgraded)
    backup=path.with_name(path.stem+'.layout1.json')
    if backup.exists(): raise ValueError(f'{backup.name} already exists; remove or rename it first.')
    backup.write_bytes(path.read_bytes()); save_json(path,upgraded)
    return path


def resolve(data, recipe):
    if recipe.get('figure_kind') != KIND or recipe.get('schema_version') != 1 or recipe.get('layout_version') not in (1,2):
        raise ValueError('Unsupported combined figure kind, schema or layout version.')
    layout=recipe['layout_version']
    images, _, _ = five_images(data, recipe['view'])
    h,w = images[0].shape
    crops=[bounds(recipe['crop'], (h,w))] if layout==1 else regions_of(recipe,(h,w))
    spacing_keys=('global_arrow_spacing','local_arrow_spacing')+(('enlargement_radius',) if layout==1 else ())
    for key in spacing_keys:
        if type(recipe[key]) is not int or recipe[key] < 1:
            raise ValueError(f'{key} must be a positive integer.')
    if not np.isfinite(recipe['arrow_magnification']) or recipe['arrow_magnification'] <= 0:
        raise ValueError('Arrow magnification must be positive and finite.')
    if layout==2:
        n=data['original'].shape[0]
        if data['fields'].shape != (n,n,h,w,2) or data['shifts'].shape != (n,n,2):
            raise ValueError('Displacement dimensions do not match images.')
        if not np.isfinite(data['fields']).all() or not np.isfinite(data['shifts']).all():
            raise ValueError('Non-finite displacement.')
        view=tuple(recipe['view']); field=data['fields'][view]
        regions=[]
        for c in crops:
            block=field[c[1]:c[3],c[0]:c[2]].reshape(-1,2)
            regions.append(dict(crop=list(c),local_mean_yx=[round(float(m),3) for m in block.mean(0)],
                                local_std_yx=[round(float(m),3) for m in block.std(0)]))
        out=dict(regions=regions,global_shift_yx=data['shifts'][view].tolist(),display_limits=display_limits(recipe,images))
        if 'local_reference_display_limits' in recipe:
            lim=recipe['local_reference_display_limits']
            if (not isinstance(lim,list) or len(lim)!=2 or not np.isfinite(lim).all() or lim[1]<=lim[0]):
                raise ValueError('local_reference_display_limits must be finite [low, high] with high > low.')
            out['local_reference_display_limits']=[float(lim[0]),float(lim[1])]
        if 'context_crop' in recipe:
            cc=bounds(recipe['context_crop'],(h,w))
            if any(not (cc[0]<=c[0] and cc[1]<=c[1] and c[2]<=cc[2] and c[3]<=cc[3]) for c in crops):
                raise ValueError('context_crop must contain both regions.')
            out['context_crop']=list(cc)
        return out
    sample = recipe['sample_yx']
    if len(sample)!=2 or any(type(v) is not int for v in sample):
        raise ValueError('Sample must be integer [y,x].')
    y,x=sample
    x0,y0,x1,y1=crops[0]
    if not (y0<=y<y1 and x0<=x<x1): raise ValueError('Sample must lie inside the shared crop.')
    n=data['original'].shape[0]
    if data['fields'].shape != (n,n,h,w,2) or data['shifts'].shape != (n,n,2):
        raise ValueError('Displacement dimensions do not match images.')
    if not np.isfinite(data['fields']).all() or not np.isfinite(data['shifts']).all():
        raise ValueError('Non-finite displacement.')
    view=tuple(recipe['view']); field=data['fields'][view]
    source=np.asarray(sample)-field[y,x]
    return dict(crop=list(crops[0]),display_limits=display_limits(recipe,images),source_yx=source.tolist(),
                source_in_bounds=bool(0<=source[0]<=h-1 and 0<=source[1]<=w-1),
                displacement_yx=field[y,x].tolist())


def regions_of(recipe, shape):
    regions=recipe.get('regions')
    if not isinstance(regions,list) or len(regions)!=2: raise ValueError('Layout 2 needs exactly two regions.')
    crops=[bounds(c,shape) for c in regions]
    (a0,b0,a1,b1),(c0,d0,c1,d1)=crops
    if not (c0>=a1 or c1<=a0 or d0>=b1 or d1<=b0): raise ValueError('The two regions must not overlap.')
    return crops


def load_bundle(path, recipe):
    if recipe.get('schema_version')!=1 or recipe.get('figure_kind')!=KIND:
        raise ValueError('Unsupported combined recipe version.')
    bundle=(path.parent/recipe['run_bundle']).resolve()
    if digest(bundle)!=recipe['bundle_sha256']: raise ValueError('Bundle hash mismatch.')
    with np.load(bundle,allow_pickle=False) as z:
        data={k:z[k] for k in z.files if k!='metadata'}; meta=json.loads(z['metadata'].item())
    if meta.get('source'):
        from single_view_figure import source_spec
        if meta['source']!=source_spec(recipe): raise ValueError('Recipe source identity differs from bundle.')
    resolve(data,recipe)
    return data,meta


def check_global(data):
    for ij in np.ndindex(*data['original'].shape[:2]):
        shift=data['shifts'][ij]
        if not np.array_equal(shift,np.round(shift)): raise ValueError('Global translation must be integer.')
        dy,dx=map(int,shift); original=data['original'][ij]; h,w=original.shape
        expected=np.zeros_like(original)
        ya,yb=max(0,dy),min(h,h+dy); xa,xb=max(0,dx),min(w,w+dx)
        if ya<yb and xa<xb: expected[ya:yb,xa:xb]=original[ya-dy:yb-dy,xa-dx:xb-dx]
        if not np.array_equal(expected,data['aligned'][ij]):
            raise ValueError(f'Global translation does not reproduce view {ij}.')


def migrate(parent_path, name, workspace=None):
    from single_view_figure import load_bundle as load_parent
    from displacement_figure import read_run
    parent_path=Path(parent_path).resolve(); parent=json.loads(parent_path.read_text(encoding='utf-8'))
    if not re.fullmatch(r'[A-Za-z0-9_-]+',name): raise ValueError('Invalid figure folder name.')
    root=Path(__file__).resolve().parents[2]/'candidate-outputs'/'figures-source'/name
    if root.exists(): raise ValueError('Destination exists; choose another name or reopen it.')
    data,meta=load_parent(parent_path,parent)
    workspace=Path(workspace or Path(parent['run'])/'workspace.npz').resolve()
    if not workspace.is_file() and workspace.suffix=='.npz': workspace=workspace.with_suffix('.mat')
    recorded=meta.get('artifacts',{})
    expected=next((v for k,v in recorded.items() if Path(k).name in ('workspace.npz','workspace.mat')),None)
    if not expected: raise ValueError('Parent has no recorded workspace hash.')
    fields,fmeta=read_run(workspace,expected)
    for k,fk in [('aligned','aligned'),('global_average','global_average'),('final_average','final_average'),('reference_index','reference')]:
        if not np.array_equal(data[k],fields[fk]): raise ValueError(f'Parent/workspace mismatch: {k}')
    from single_view_import import read_workspace
    raw=read_workspace(workspace,('pixel_rectified_views',))
    if not np.array_equal(data['refined'],raw.get('pixel_rectified_views',raw.get('rectified_views'))):
        raise ValueError('Parent/workspace refined images differ.')
    if meta['effective_config']!=fmeta['effective_config']: raise ValueError('Effective configuration differs.')
    data.update(shifts=fields['shifts'],fields=fields['fields']); check_global(data)
    x0,y0,x1,y1=bounds(parent['crop'],data['global_average'].shape)
    first=[x0,y0,x1,y1]; second=suggest_region(data,parent['view'],first)
    bundle_id=uuid4().hex
    recipe={k:parent[k] for k in ('source_version','scene','capture','run','original_views','view','display_limits')}
    recipe.update(figure_kind=KIND,schema_version=1,layout_version=2,bundle_id=bundle_id,
                  regions=[first,second],global_arrow_spacing=24,local_arrow_spacing=12,
                  arrow_magnification=1.0,index_convention='i=row,j=column; image=y,x; crop=x0,y0,x1,y1 half-open',
                  parent_recipe={'path':str(parent_path),'sha256':digest(parent_path)},
                  validation={'global_translation':'exact, all views','local_remap':'all views; rtol=1e-6, atol=1e-6',
                              'parent_arrays':'exact','configuration':'exact'})
    resolve(data,recipe)
    root.mkdir(parents=True); gen=root/'generations'/bundle_id; gen.mkdir(parents=True)
    save_json(gen/'parent.recipe.json',parent)
    bundle=gen/'run.npz'; np.savez_compressed(bundle,**data,metadata=json.dumps(meta))
    recipe.update(run_bundle=bundle.relative_to(root).as_posix(),bundle_sha256=digest(bundle))
    save_json(root/'recipe.json',recipe)
    return root/'recipe.json'


def render(path, recipe, output=None, use_current=False):
    data,meta=load_bundle(path,recipe); resolved=resolve(data,recipe)
    if 'resolved_display' in recipe and recipe['resolved_display']!=resolved:
        raise ValueError('Resolved settings differ from saved preview.')
    source=RENDERER
    if recipe.get('renderer_snapshot') and not use_current:
        source=(path.parent/recipe['renderer_snapshot']).resolve()
        if digest(source)!=recipe['renderer_sha256']: raise ValueError('Renderer snapshot hash mismatch.')
    preview_id=uuid4().hex
    root=path.parent.parent if path.parent.name=='selected' else path.parent
    output=Path(output or root/'previews'/preview_id/'figure.pdf').resolve()
    if output.exists(): raise ValueError('Replay destination exists; historical previews cannot be overwritten.')
    output.parent.mkdir(parents=True,exist_ok=True)
    snapshot=output.parent/f'renderer-{preview_id}.py'
    if source.resolve()!=snapshot.resolve(): shutil.copyfile(source,snapshot)
    spec=importlib.util.spec_from_file_location('evolution_renderer_'+preview_id,snapshot)
    module=importlib.util.module_from_spec(spec); spec.loader.exec_module(module)
    from matplotlib.figure import Figure
    import matplotlib
    import cv2
    fig=Figure(figsize=getattr(module,'FIGSIZE_IN',(145/25.4,130/25.4))); module.draw(fig,data,recipe,resolved)
    fig.savefig(output,metadata={'CreationDate':None,'ModDate':None})
    revision=subprocess.run(['git','rev-parse','HEAD'],capture_output=True,text=True).stdout.strip()
    out=dict(recipe,preview_id=preview_id,resolved_display=resolved,run_provenance=meta,
             run_bundle=os.path.relpath(path.parent/recipe['run_bundle'],output.parent),
             renderer_snapshot=snapshot.name,renderer_sha256=digest(snapshot),pdf_sha256=digest(output),
             software={'numpy':np.__version__,'matplotlib':matplotlib.__version__,'opencv':cv2.__version__,'python':sys.version},repository_revision=revision,
             working_file_hashes={p.name:digest(p) for p in (Path(__file__),RENDERER,*(Path(__file__).with_name(n) for n in ('single_view_figure.py','single_view_import.py','displacement_figure.py','single_view_setup.py','alignment_evolution_setup.py')))})
    if recipe.get('preview_id'): out['parent_preview_id']=recipe['preview_id']
    save_json(output.with_suffix('.recipe.json'),out)
    return output


def select_export(preview, folder):
    preview=Path(preview); folder=Path(folder)
    recipe=json.loads(preview.with_suffix('.recipe.json').read_text())
    if digest(preview)!=recipe['pdf_sha256']: raise ValueError('Preview PDF hash mismatch.')
    load_bundle(preview,recipe)
    renderer=preview.parent/recipe['renderer_snapshot']
    if digest(renderer)!=recipe['renderer_sha256']: raise ValueError('Renderer snapshot hash mismatch.')
    selected=folder/'selected'
    with TemporaryDirectory(dir=folder) as tmp:
        stage=Path(tmp)/'selected'; stage.mkdir()
        shutil.copyfile(preview,stage/'figure.pdf'); shutil.copyfile(renderer,stage/'renderer.py')
        saved=dict(recipe,run_bundle=os.path.relpath(preview.parent/recipe['run_bundle'],selected),renderer_snapshot='renderer.py')
        save_json(stage/'figure.recipe.json',saved); save_json(stage/'provenance.json',saved)
        backup=folder/('.selected-backup-'+uuid4().hex)
        if selected.exists(): selected.rename(backup)
        try: stage.rename(selected)
        except OSError:
            if backup.exists(): backup.rename(selected)
            raise
        if backup.exists(): shutil.rmtree(backup)
    return selected/'figure.pdf'
