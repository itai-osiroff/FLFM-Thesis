# Wagner Et Al. 2019 - Iso-LFM: Dual-View Light-Field Microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Nils Wagner, Nils Norlin, Jakob Gierten, Gustavo de Medeiros, Balint Balazs,
Joachim Wittbrodt, Lars Hufnagel, and Robert Prevedel, "Instantaneous isotropic
volumetric imaging of fast biological processes," *Nature Methods* 16(6), 497-500,
2019 (Brief Communication). DOI `10.1038/s41592-019-0393-z`.

## What was read

Author-supplied PDF `literature/Wagner et al., Nature Methods 16(6), 497–500, 2019.pdf`
(git-ignored), the published article plus Methods and reporting summary (7 pages).
The supplementary notes and figures are not in the file. **Reading status:** a
delegated reader covered all seven pages; the author of this note re-read journal
pp. 497-498 (abstract, introduction, Fig. 1), which match. Other locators come from
the delegated reading.

## What the paper says

- **Limitations of LFM (introduction, p. 497).** The authors list inherent
  trade-offs between spatial resolution and 3D field of view, non-uniform
  spatial resolution across depth, and strong reconstruction artifacts around the
  native focal plane and at the edges of the field of view.
- **System (pp. 497-498, Fig. 1a).** Iso-LFM: selective-volume illumination
  from a third objective plus two identical detection objectives placed
  perpendicular to each other, each with its own microlens array (125 um pitch);
  both light fields are recorded simultaneously (an upright SPIM-type geometry;
  conventional image-plane LFM, by inference from the Methods, delegated).
- **Pipeline (p. 498, Fig. 1b; Methods, delegated).** Cropping, light-field
  resampling ("rectification"), per-view light-field deconvolution (PSFs from
  vectorial diffraction theory), affine registration of the two reconstructed
  volumes (transform estimated from beads and applied to all time points), then
  multiview deconvolution; semi-automatic and processed offline on a cluster.
- **Results (p. 498, Fig. 1e).** Near-isotropic resolution of about 2.0 um lateral
  and 2.9 um axial after dual-view deconvolution, against about 2.9 um and 8.0 um
  for a single view on average; heart imaging at 143 Hz over about 300 um cubed,
  and blood flow at 200 Hz over 200 um cubed in medaka larvae.
- **Limitations (p. 500, delegated).** Restricted volumetric field of view, camera
  readout-limited speed, optical access from three sides, and scattering or
  shadowing degrading the individual views.

## Relevance to the thesis (gap IDs G14, G17, G19)

- A primary-source statement of LFM limits (non-uniform resolution, artifacts near
  the native focal plane) from a 2019 Nature Methods paper (p. 497).
- An LFM example that **registers reconstructed volumes from multiple views and
  fuses them**, parallel in spirit to the multiview fusion cited from light-sheet
  microscopy (Swoger, Preibisch). It registers two 3D volumes with an affine
  transform, not sub-aperture views of one image.
- Not an aberration-correction method and not FLFM.

## Safe Wording

Wagner et al. record two perpendicular light fields simultaneously, reconstruct
each by light-field deconvolution, register the volumes and fuse them by multiview
deconvolution to reach near-isotropic resolution [Wagner 2019, p. 498]. Do not
describe it as a single-camera or single-view method.
