# Ji, Milkie And Betzig 2010 - Adaptive Optics Via Pupil Segmentation

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Na Ji, Daniel E. Milkie, and Eric Betzig, "Adaptive optics via pupil
segmentation for high-resolution imaging in biological tissues," *Nature
Methods* 7(2), 141-147, February 2010 (published online 27 December 2009).
DOI `10.1038/nmeth.1411`. Crossref lists the online year, 2009; the issue year
is 2010. Use the issue year in the bibliography unless the style says otherwise.

## What was read

The Janelia-hosted copy of the published article (advance online publication,
7 pages, main text including Figures 1-5, Discussion and references),
fetched 2026-11-10; it is not stored in the repo. The Online Methods and
Supplementary Figures are not in the pages read. Locators are section and
figure names plus advance-online page numbers (p. 1-7); the journal pages
are 141-147.

## Why This Matters

Primary source for the idea behind the thesis's shift assumption: divide the
objective's rear pupil into segments, and the image formed through each segment
is displaced in proportion to the local wavefront tilt in that segment, so the
aberration can be read out from image shifts. It is explicitly a zonal method,
analogous to a Shack-Hartmann sensor.

## What the paper says

- **Principle (abstract, p. 1).** The rear pupil is segmented into subregions,
  and light is directed individually to each to measure, "by image shift", the
  deflection faced by each group of rays on the way to the focus.
- **Focus model (p. 1-2, Fig. 1).** An ideal focus forms when all rays through
  the rear pupil meet at one point with a common phase; refractive-index
  inhomogeneities deflect rays and shift their phases. A spatial light
  modulator divided into N subregions, each a planar phase pattern
  controlling tilt and offset, can steer each beamlet back. N below 100 usually
  suffices.
- **Shift measurement (p. 2).** All subregions but one are switched off and
  an image is taken; any deflection along the path appears as a shift relative to a
  full-pupil reference image. The shift is found from the centroid for an isolated
  object, or by image correlation for complex samples; the deflection angle
  follows and an equal and opposite phase ramp is applied.
- **Reconstruction (p. 2).** Directly measuring phase offsets between beamlets,
  or reconstructing the phase from the array of gradient measurements with an
  iterative algorithm similar to that used in a Shack-Hartmann sensor, gives the
  corrective wavefront. Direct measurement leaves lower residual error at a
  cost of about PN more images.
- **Image correlation (p. 5-6, Fig. 5).** Correlating images over a
  user-selected region measures the mean aberration over that region, so one
  corrective wavefront is valid across it (46 x 140 micron in Fig. 5).
- **Limitation for spatial variation (Discussion, p. 6).** Because the
  measured aberration is an average over a larger volume, correction can be
  suboptimal in subregions whose local refractive-index profile differs from
  the average. More local measurements, from local correlation or centroids,
  would be needed, with sub-images stitched together.
- **Scope statement (Discussion, p. 6).** The authors say the principle may be
  applied to other point-scanning and widefield microscopes.
- **Zonal versus modal (Discussion, p. 6).** Zonal correction, with the
  wavefront measured in discrete zones that tile the pupil, is preferred in
  astronomy and ophthalmology over modal approaches, and the authors argue the
  wavefronts in cortical slices are too complex for a few modes.

## Relevance to the thesis

- Supports the **plausibility** that per-pupil-segment image shifts encode
  local wavefront tilt (gap IDs G9, G22, G23). In an FLFM each view is an image
  through one pupil segment, so the same geometric reasoning suggests relative
  shifts between views. That application to detection-path light-field views is
  this note's **inference**; the paper's experiments are two-photon excitation
  with an SLM, not light-field detection.
- The thesis assumption itself stays the author's: Ji et al. do not claim a
  pure translation model for light-field views.
- The averaging limitation (Discussion, p. 6) matches the thesis motivation
  for a local, per-pixel stage on top of a global one; use it only as context.
- Different mechanism: active hardware AO with an SLM, measuring then correcting
  the excitation wavefront; the thesis corrects digitally in post-processing.

## Safe Wording

Ji, Milkie and Betzig measure the local wavefront tilt in each zone of the
objective's rear pupil from the shift of the image formed through that zone, and
use these zonal tilts to correct aberrations by adaptive optics [Ji 2010,
Fig. 1, p. 2]. Do not describe it as a light-field or digital method.
