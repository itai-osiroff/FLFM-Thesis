# Jeon Et Al. 2015 - Depth From A Lenslet Light-Field Camera

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Hae-Gon Jeon, Jaesik Park, Gyeongmin Choe, Jinsun Park, Yunsu Bok, Yu-Wing
Tai, and In So Kweon, "Accurate depth map estimation from a lenslet light field
camera," *2015 IEEE Conference on Computer Vision and Pattern Recognition
(CVPR)*, 1547-1555, 2015. DOI `10.1109/CVPR.2015.7298762` (Crossref).

## What was read

Author-supplied PDF `literature/Jeon 2015.pdf` (git-ignored): the CVF open-access
version, 9 pages (printed pp. 1547-1555; printed page = PDF page + 1546).
**Reading status:** a delegated reader covered all 9 pages; the author of this
note re-read printed pp. 1549-1550 (Sections 3.2, 4.1, 4.2 and Eqs. 2-9), which
match. The other locators come from the delegated reading.

## What the paper says

- **Setting (Sections 1, 3.1, 5).** Lenslet (microlens-array) light-field cameras
  such as Lytro and Raytrix, plus a lab-built camera. Sub-aperture images are
  angular slices of the 4D light field. Baselines are extremely narrow, with
  disparities of about one pixel or less on the Lytro, so sub-pixel accuracy is
  needed.
- **Sub-pixel shifting (Section 4.1, Eqs. 3-4, p. 1550).** Each sub-aperture image
  is shifted by a fractional displacement using the Fourier phase-shift theorem,
  chosen over bilinear or bicubic interpolation to avoid blur (Fig. 4). Exact for
  band-limited images; the authors note real light fields are not always
  band-limited.
- **Shift per label (Eq. 7).** The shift of a view is a label times a step times
  the view's offset from the centre view, so shifts grow linearly with angular
  offset.
- **Cost volume (Section 4.2, Eqs. 5-9, p. 1550).** For each pixel and label,
  truncated sum of absolute differences and gradient differences between the centre
  view and the shifted other views, over a small window and over all views; the
  gradient direction is weighted by the view's angular position.
- **Selection (Section 4.2, delegated).** Each cost slice is edge-preserving
  filtered, a winner-take-all gives an initial map, then a multi-label graph cut
  with a smoothness term and a quadratic sub-label refinement (printed pp. 1550-1551).
- **Aberration correction (Section 3.2, p. 1549).** The paper corrects astigmatism
  and field curvature by a second-order correction of epipolar-image slopes; it
  describes this as a low-order approach and names Ng and Hanrahan as a more
  general aberration-correction technique.

## Relevance to the thesis (gap ID G6)

- Nearest light-field analogue found: shift each non-centre sub-aperture view by a
  hypothesized displacement, compare with a reference view, pick the best per
  pixel, refine to sub-pixel.
- The paper also gives a citable pairing with Ng and Hanrahan: its own wording
  places that work as general aberration correction for light-field cameras.

## Differences to state if cited

- The displacement is scene depth: one label per pixel scaled by the view's
  offset from the centre. Aberration-induced displacement need not be linear in
  view offset, may differ per view, and has no depth meaning (inference).
- Regular lenslet light-field cameras, not FLFM, and a centre-view reference
  rather than a global-stage average.
- Uses graph-cut regularization and sub-label refinement that the thesis local
  stage does not.

## Safe Wording

For lenslet light-field cameras, Jeon et al. estimate depth by shifting each
sub-aperture view by a sub-pixel amount proportional to its angular offset,
comparing it with the centre view in a cost volume, and selecting the best label
per pixel [Jeon 2015, Sections 4.1-4.2]. Do not describe it as aberration
estimation.
