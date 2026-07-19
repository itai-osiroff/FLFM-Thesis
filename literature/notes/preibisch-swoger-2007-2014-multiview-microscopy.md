# Swoger And Preibisch 2007-2014 - Multiview Microscopy Registration And Fusion

## Citation

Jim Swoger, Peter Verveer, Klaus Greger, Jan Huisken, and Ernst H. K. Stelzer,
"Multi-view image fusion improves resolution in three-dimensional microscopy,"
*Optics Express*, 15(13), 8029-8042, 2007.
DOI: `10.1364/OE.15.008029`.

Stephan Preibisch, Stephan Saalfeld, Johannes Schindelin, and Pavel Tomancak,
"Software for bead-based registration of selective plane illumination microscopy
data," *Nature Methods*, 7(6), 418-419, 2010.
DOI: `10.1038/nmeth0610-418`.

Stephan Preibisch, Fernando Amat, Evangelia Stamataki, Mihail Sarov, Robert H.
Singer, Eugene Myers, and Pavel Tomancak, "Efficient Bayesian-based multiview
deconvolution," *Nature Methods*, 11(6), 645-648, 2014.
DOI: `10.1038/nmeth.2929`.

Primary sources:

- <https://doi.org/10.1364/OE.15.008029>
- <https://doi.org/10.1038/nmeth0610-418>
- <https://doi.org/10.1038/nmeth.2929>

## Why This Matters

These papers are not light-field papers, but they provide useful adjacent
precedent for registering, fusing, and deconvolving multiple microscopy views.
They support the thesis' conceptual framing that multiple viewpoints can be
aligned and combined, while preserving the distinction between multiview
light-sheet/SPIM workflows and this thesis' elemental FLFM view grid.

## Key Claims

- Multi-view fusion can improve resolution and isotropy in 3D microscopy.
- Bead-based registration is an established strategy for aligning selective
  plane illumination microscopy views.
- Bayesian multiview deconvolution can improve resolution and contrast in
  light-sheet datasets, but it is a different physical and computational model
  from warp-and-average rectification.

## Useful Equations, Figures, Or Methods

- Use as conceptual precedent for view registration/fusion.
- Use for validation language around beads as fiducial or calibration objects,
  while being careful that thesis beads are also the sample, not necessarily
  external fiducials.

## Thesis Placement

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Adjacent multiview microscopy context. |
| Chapter 5: Rectification-Based Reconstruction Method | Conceptual precedent for alignment and fusion, not algorithmic derivation. |
| Chapter 8: Discussion | Distinguish simple averaging from deconvolution-based multiview reconstruction. |

## Possible Thesis Use

- Citation for multiview registration and fusion as established microscopy
  ideas.
- Discussion citation for why the thesis' method is a lightweight fusion
  strategy rather than a multiview deconvolution framework.

## Safe Wording

Multiview microscopy literature shows that registering and combining multiple
views is a standard route to improved microscopy reconstructions. This thesis
can cite Swoger and Preibisch as adjacent precedent for view alignment and
fusion, while making clear that its FLFM elemental-view rectification is not
SPIM registration or Bayesian multiview deconvolution.

## Caveats

- These papers are not FLFM sources.
- Do not cite them as evidence for the thesis' optical model or tissue-like
  media performance.
- Do not imply that the implemented method performs multiview deconvolution.
