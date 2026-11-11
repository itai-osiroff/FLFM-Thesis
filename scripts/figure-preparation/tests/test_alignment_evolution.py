import json
import sys
import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import alignment_evolution as ae
import alignment_evolution_panels as panels


class EvolutionTest(unittest.TestCase):
    def data(self):
        a = np.arange(4*20*24, dtype=float).reshape(2,2,20,24)
        f = np.zeros((2,2,20,24,2)); f[...,0] = -2; f[...,1] = 3
        return dict(original=a, aligned=a, refined=a, global_average=a.mean((0,1)),
                    final_average=a.mean((0,1)), reference_index=np.array([1,1]),
                    shifts=np.zeros((2,2,2)), fields=f)

    def recipe(self):
        return dict(figure_kind='alignment_evolution', schema_version=1, layout_version=1,
                    view=[0,0], crop=[1,1,23,19], display_limits=[0,2000],
                    sample_yx=[8,10], enlargement_radius=4, global_arrow_spacing=8,
                    local_arrow_spacing=6, arrow_magnification=1.0)

    def recipe2(self):
        r=dict(self.recipe(),layout_version=2,regions=[[1,1,11,9],[12,10,22,18]])
        for key in ('crop','sample_yx','enlargement_radius'): del r[key]
        return r

    def test_sampling_sign_and_validation(self):
        r=self.recipe(); d=self.data()
        self.assertEqual(ae.resolve(d,r)['source_yx'], [10.0,7.0])
        for key,value in [('crop',[3,2,1,9]),('sample_yx',[0,0]),('local_arrow_spacing',0)]:
            bad=dict(r,**{key:value})
            with self.assertRaises(ValueError): ae.resolve(d,bad)
        d['fields'][0,0,8,10]=[40,0]
        self.assertFalse(ae.resolve(d,r)['source_in_bounds'])

    def test_offline_snapshot_and_selection(self):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp); bundle=root/'run.npz'; np.savez_compressed(bundle,**self.data(),metadata=json.dumps({}))
            r=dict(self.recipe2(),run_bundle='run.npz',bundle_sha256=ae.digest(bundle),bundle_id='b')
            path=root/'recipe.json'; ae.save_json(path,r)
            with self.assertRaisesRegex(ValueError,'layout 2'):
                ae.render(path,dict(self.recipe(),run_bundle='run.npz',bundle_sha256=ae.digest(bundle),bundle_id='b'))
            out=ae.render(path,r)
            first=json.loads(out.with_suffix('.recipe.json').read_text())
            another=ae.render(path,r,output=out.parent/'another.pdf',use_current=True)
            second=json.loads(another.with_suffix('.recipe.json').read_text())
            self.assertNotEqual(first['renderer_snapshot'],second['renderer_snapshot'])
            self.assertEqual(ae.digest(out.parent/first['renderer_snapshot']),first['renderer_sha256'])
            selected=ae.select_export(out,root)
            saved=json.loads(selected.with_suffix('.recipe.json').read_text())
            replay=ae.render(selected.with_suffix('.recipe.json'),saved)
            self.assertTrue(replay.is_file())
            self.assertEqual(saved['resolved_display']['regions'][0]['local_mean_yx'],[-2.0,3.0])
            old=selected.read_bytes(); rename=Path.rename
            def failing_stage(path,target):
                if path.name=='selected' and path.parent.name.startswith('tmp'):
                    raise OSError('simulated staging failure')
                return rename(path,target)
            with patch.object(Path,'rename',failing_stage):
                with self.assertRaises(OSError): ae.select_export(out,root)
            self.assertEqual(selected.read_bytes(),old)
            selected.write_bytes(b'altered')
            with self.assertRaises(ValueError): ae.select_export(selected,root)

    def test_layout2_resolve_and_validation(self):
        d=self.data(); d['fields'][0,0,10:18,12:22]=[3,-4]
        got=ae.resolve(d,self.recipe2())
        self.assertNotIn('source_yx',got); self.assertEqual(got['global_shift_yx'],[0.0,0.0])
        self.assertEqual(got['regions'][0]['local_mean_yx'],[-2.0,3.0]); self.assertEqual(got['regions'][1]['local_mean_yx'],[3.0,-4.0])
        self.assertEqual(got['regions'][1]['local_std_yx'],[0.0,0.0])
        for key,value in [('regions',[[1,1,11,9],[5,4,15,12]]),('regions',[[1,1,11,9]]),('local_arrow_spacing',0),
                          ('local_reference_display_limits',[5,5]),('local_reference_display_limits',[0]),
                          ('context_crop',[0,0,20,10])]:
            with self.assertRaises(ValueError): ae.resolve(d,dict(self.recipe2(),**{key:value}))

    def test_regions_may_differ_in_size_and_new_keys_resolve(self):
        d=self.data(); r=dict(self.recipe2(),regions=[[1,1,11,9],[12,10,22,19]],
                              local_reference_display_limits=[0,1100],context_crop=[0,0,24,20])
        got=ae.resolve(d,r)
        self.assertEqual(got['regions'][1]['crop'],[12,10,22,19])
        self.assertEqual(got['local_reference_display_limits'],[0.0,1100.0]); self.assertEqual(got['context_crop'],[0,0,24,20])
        plain=ae.resolve(d,self.recipe2())
        self.assertNotIn('local_reference_display_limits',plain); self.assertNotIn('context_crop',plain)

    def test_render_with_unequal_regions_and_reference_limits(self):
        from matplotlib.figure import Figure
        d=self.data(); r=dict(self.recipe2(),regions=[[1,1,11,9],[12,10,22,19]],
                              local_reference_display_limits=[0,1000],context_crop=[0,0,24,20])
        res=ae.resolve(d,r); fig=Figure(); panels.draw(fig,d,r,res)
        self.assertEqual(len(fig.axes),13)   # 12 stage panels + panel G, no view-grid inset

    def test_arrows_are_forward_and_match_data(self):
        rng=np.random.default_rng(0); h,w=40,48
        aligned=rng.random((h,w)); field=rng.integers(-3,4,(h,w,2)).astype(float)
        refined=np.zeros((h,w))
        for yy in range(h):
            for xx in range(w):
                sy,sx=yy-int(field[yy,xx,0]),xx-int(field[yy,xx,1])
                if 0<=sy<h and 0<=sx<w: refined[yy,xx]=aligned[sy,sx]
        tails,heads,extent=panels.arrow_segments(field,(5,4,35,30),6,1.0,(h,w))
        self.assertGreater(len(tails),5)
        hy,hx=heads.astype(int).T; ty,tx=tails.astype(int).T
        np.testing.assert_array_equal(tails,heads-field[hy,hx])
        np.testing.assert_array_equal(refined[hy,hx],aligned[ty,tx])
        x0,y0,x1,y1=extent
        self.assertTrue((tx>=x0).all() and (tx<x1).all() and (ty>=y0).all() and (ty<y1).all())
        self.assertTrue(x0<=5 or x0==0); self.assertTrue(x1>=35)
        # magnification scales the tail only; the head stays on the output grid.
        t2,h2,_=panels.arrow_segments(field,(5,4,35,30),6,2.0,(h,w))
        np.testing.assert_array_equal(h2,h2.astype(int)); self.assertTrue(np.isin(h2,heads).all() or len(h2)<=len(heads))

    def test_global_arrows_are_identical_across_regions(self):
        shift=np.array([16.,32.]); shape=(400,400)
        for crop in ((130,228,214,295),(250,60,334,127)):
            tails,heads,extent=panels.arrow_segments(shift,crop,24,1.0,shape)
            np.testing.assert_array_equal(heads-tails,np.broadcast_to(shift,heads.shape))
            self.assertLessEqual(extent[0],crop[0]); self.assertLessEqual(extent[1],crop[1])

    def test_suggest_region_and_upgrade(self):
        d=self.data(); d['fields']=np.zeros_like(d['fields']); d['fields'][...,0]=np.linspace(-4,4,24)
        d['fields'][...,1]=np.linspace(-4,4,24)
        first=[0,0,10,8]; second=ae.suggest_region(d,[0,0],first,stride=2)
        self.assertEqual((second[2]-second[0],second[3]-second[1]),(10,8))
        self.assertTrue(second[0]>=10 or second[1]>=8)
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp); bundle=root/'run.npz'; np.savez_compressed(bundle,**self.data(),metadata=json.dumps({}))
            r=dict(self.recipe(),run_bundle='run.npz',bundle_sha256=ae.digest(bundle),bundle_id='b',crop=[0,0,10,8],sample_yx=[4,5])
            path=root/'recipe.json'; ae.save_json(path,r)
            ae.upgrade_layout(path)
            up=json.loads(path.read_text()); self.assertEqual(up['layout_version'],2)
            self.assertNotIn('crop',up); self.assertNotIn('sample_yx',up); self.assertEqual(up['regions'][0],[0,0,10,8])
            self.assertEqual(json.loads((root/'recipe.layout1.json').read_text())['layout_version'],1)
            with self.assertRaises(ValueError): ae.upgrade_layout(path)

    def test_version_and_hash_rejection(self):
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp)/'recipe.json'
            with self.assertRaises(ValueError): ae.load_bundle(p,dict(self.recipe(),schema_version=9))
            b=p.parent/'run.npz'; b.write_bytes(b'wrong')
            with self.assertRaises(ValueError): ae.load_bundle(p,dict(self.recipe(),run_bundle='run.npz',bundle_sha256='wrong'))

    def test_global_axes_and_zero_boundaries(self):
        d=self.data(); d['shifts'][0,0]=[2,-3]
        d['aligned']=d['original'].copy(); d['aligned'][0,0]=0
        d['aligned'][0,0,2:,:-3]=d['original'][0,0,:-2,3:]
        ae.check_global(d)
        d['shifts'][0,0]=[-3,2]
        with self.assertRaises(ValueError): ae.check_global(d)

    def test_migration_mismatch_preserves_parent(self):
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp)/'parent.json'; p.write_text(json.dumps(dict(self.recipe(),run='missing')))
            original=p.read_bytes(); data=self.data()
            meta={'artifacts':{'workspace.npz':'hash'},'effective_config':{}}
            fields=dict(aligned=data['aligned']+1,global_average=data['global_average'],
                        final_average=data['final_average'],reference=data['reference_index'])
            with patch('single_view_figure.load_bundle',return_value=(data,meta)), patch('displacement_figure.read_run',return_value=(fields,{})):
                with self.assertRaisesRegex(ValueError,'mismatch'): ae.migrate(p,'test_mismatch_not_created')
            self.assertEqual(p.read_bytes(),original)

    def test_configuration_conflict_preserves_parent(self):
        with tempfile.TemporaryDirectory() as tmp:
            p=Path(tmp)/'parent.json'; p.write_text(json.dumps(dict(self.recipe(),run='missing')))
            d=self.data(); meta={'artifacts':{'workspace.npz':'hash'},'effective_config':{}}
            f=dict(aligned=d['aligned'],global_average=d['global_average'],final_average=d['final_average'],reference=d['reference_index'])
            with patch('single_view_figure.load_bundle',return_value=(d,meta)), patch('displacement_figure.read_run',return_value=(f,{'effective_config':{'changed':True}})), patch('single_view_import.read_workspace',return_value={'pixel_rectified_views':d['refined']}):
                with self.assertRaisesRegex(ValueError,'configuration'): ae.migrate(p,'test_conflict_not_created')

    def test_legacy_renderer_pixels_unchanged(self):
        import subprocess, types
        from matplotlib.figure import Figure
        from matplotlib.backends.backend_agg import FigureCanvasAgg
        import single_view_figure as current
        src=subprocess.check_output(['git','show','HEAD:scripts/figure-preparation/single_view_figure.py'],text=True)
        old=types.ModuleType('legacy'); exec(compile(src,'legacy','exec'),old.__dict__)
        d=self.data(); images,n,ref=current.five_images(d,[0,0]); pixels=[]
        for draw in (old.draw,current.draw):
            fig=Figure(figsize=(6,5)); canvas=FigureCanvasAgg(fig)
            draw(fig,images,[1,1,23,19],[0,2000],n,ref,[0,0]); canvas.draw(); pixels.append(np.asarray(canvas.buffer_rgba()).copy())
        np.testing.assert_array_equal(*pixels)

if __name__=='__main__': unittest.main()
