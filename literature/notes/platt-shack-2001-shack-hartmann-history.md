# Platt And Shack 2001 - History And Principles Of Shack-Hartmann Wavefront Sensing

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Ben C. Platt and Roland Shack, "History and principles of Shack-Hartmann
wavefront sensing," *Journal of Refractive Surgery* 17(5), S573-S577,
September/October 2001. DOI `10.3928/1081-597X-20010901-13` (identity checked
in OpenAlex, 2026-11-10). Presented at the 2nd International Congress of
Wavefront Sensing and Aberration-free Refractive Correction, February 2001.

## What was read

Local PDF `literature/shack hartmann wavefront sensing history principles.pdf`
(git-ignored): all five pages (S573-S577), text and figures. Locators are the
journal page numbers.

## Why This Matters

A primary source for the sensing principle behind the thesis's shift
assumption: a lenslet array samples the wavefront, and the displacement of each
focused spot represents the local wavefront tilt. This supports the
plausibility of describing aberration in a lenslet-based system as per-subaperture
displacements.

## What the paper says

- **Principle (S574, Fig. 3 and its caption).** Displacements of the focused
  spots formed by the lens array are measured to calculate wavefront tilt. The
  caption: displacements of focused spots from the lens array represent
  wavefront tilt. The text adds that, as the derivative of the optical path
  difference map gives wavefront slopes, integrating slopes gives the
  wavefront map (S574).
- **Lineage (S573-S574).** The Hartmann test placed a screen with holes over a
  telescope aperture, recorded the images of the rays inside and outside focus,
  and traced rays through the focal plane from centroids of the images. Shack
  replaced the holes with lenslets so that the wavefront error could be measured
  while an image is taken, for atmospheric correction of satellite imaging (late
  1960s, University of Arizona).
- **Calibration (S576).** A reference set of spots from a calibrated wavefront
  was needed to account for residual aberrations in the setup; repeatability was
  reported as better than lambda/50 and accuracy at least lambda/20 against a
  commercial interferometer.
- **Reconstruction software (S577).** Software converts the two-dimensional
  tilt data into a two-dimensional wavefront; the first such program adapted an
  interferogram-reduction program for shearing interferograms, since those
  also represent wavefront tilt.
- **Applications (S577).** Astronomy, military adaptive optics, ophthalmology;
  the authors state it is not expected to replace the interferometer, only
  complement it.

## What the paper does not say

- No equation relating spot displacement to wavefront slope. The figure labels
  the lenslet focal length (F) and the spot displacement, but the text
  gives no formula, so the paper cannot be cited for a specific relation such as
  displacement = focal length x slope.
- No discussion of dynamic range, spot overlap or lenslet sampling limits.
  It is a historical account, not a technical analysis.

## Relevance to the thesis

- Background citation for "lenslet-sampled wavefronts: aberration appears as
  displacement of each lenslet's image" (gap IDs G9, G22, G23). It supports
  plausibility only; the thesis's FLFM views are sub-aperture images of an
  object, not focal spots of a point source, and the thesis's shift assumption
  stays the author's own.
- If the thesis needs the quantitative relation, add a textbook or technical
  source (for example an optics textbook on aberrations or a Shack-Hartmann
  tutorial); this paper will not carry it.

## Safe Wording

In a Shack-Hartmann sensor, a lenslet array focuses the incoming wave into spots
whose displacements measure the local wavefront tilt [Platt and Shack 2001,
p. S574]. Do not attribute a formula or specific accuracy limits to the paper.
