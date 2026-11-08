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
    recipe.update(figure_kind=KIND,schema_version=1,layout_version=1,bundle_id=meta['run_id'],
                  crop=[0,0,w,h],sample_yx=[h//2,w//2],enlargement_radius=10,
                  global_arrow_spacing=24,local_arrow_spacing=12,arrow_magnification=1.0,
                  validation={'global_translation':'exact, all views','local_remap':'all views; rtol=1e-6, atol=1e-6'})


def resolve(data, recipe):
    if recipe.get('figure_kind') != KIND or recipe.get('schema_version') != 1 or recipe.get('layout_version') != 1:
        raise ValueError('Unsupported combined figure kind, schema or layout version.')
    images, _, _ = five_images(data, recipe['view'])
    h,w = images[0].shape
    crop = bounds(recipe['crop'], (h,w)); x0,y0,x1,y1 = crop
    for key in ('global_arrow_spacing','local_arrow_spacing','enlargement_radius'):
        if type(recipe[key]) is not int or recipe[key] < 1:
            raise ValueError(f'{key} must be a positive integer.')
    if not np.isfinite(recipe['arrow_magnification']) or recipe['arrow_magnification'] <= 0:
        raise ValueError('Arrow magnification must be positive and finite.')
    sample = recipe['sample_yx']
    if len(sample)!=2 or any(type(v) is not int for v in sample):
        raise ValueError('Sample must be integer [y,x].')
    y,x=sample
    if not (y0<=y<y1 and x0<=x<x1): raise ValueError('Sample must lie inside the shared crop.')
    n=data['original'].shape[0]
    if data['fields'].shape != (n,n,h,w,2) or data['shifts'].shape != (n,n,2):
        raise ValueError('Displacement dimensions do not match images.')
    if not np.isfinite(data['fields']).all() or not np.isfinite(data['shifts']).all():
        raise ValueError('Non-finite displacement.')
    source=np.asarray(sample)-data['fields'][tuple(recipe['view'])][y,x]
    return dict(crop=list(crop),display_limits=display_limits(recipe,images),source_yx=source.tolist(),
                source_in_bounds=bool(0<=source[0]<=h-1 and 0<=source[1]<=w-1),
                displacement_yx=data['fields'][tuple(recipe['view'])][y,x].tolist())


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
    sample=[(y0+y1)//2,(x0+x1)//2]
    if parent['scene']=='beads_2um_dense10_eyedrop_680us' and parent['view']==[1,1] and parent['crop']==[130,228,214,295]: sample=[262,167]
    bundle_id=uuid4().hex
    recipe={k:parent[k] for k in ('source_version','scene','capture','run','original_views','view','crop','display_limits')}
    recipe.update(figure_kind=KIND,schema_version=1,layout_version=1,bundle_id=bundle_id,
                  sample_yx=sample,enlargement_radius=10,global_arrow_spacing=24,local_arrow_spacing=12,
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
    fig=Figure(figsize=(145/25.4,130/25.4)); module.draw(fig,data,recipe,resolved)
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
