# Milkie, Betzig And Ji 2011 - Pupil-Segmentation AO With Full-Pupil Illumination

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Daniel E. Milkie, Eric Betzig, and Na Ji, "Pupil-segmentation-based adaptive
optical microscopy with full-pupil illumination," *Optics Letters* 36(21),
4206-4208, November 1, 2011 (published October 25, 2011). DOI
`10.1364/OL.36.004206` (identity checked in Crossref, 2026-11-10).

## What was read

The Janelia-hosted copy of the published letter (3 pages, with figures),
fetched 2026-11-10; it is not stored in the repo. Its PDF metadata carries a
leftover title ("Slide 1") but the content is the article. Locators are journal
page numbers and figure numbers.

## What the paper says

- **Context (p. 4206).** Summarizes the earlier approach of Ji et al.: images
  taken with different pupil zones illuminated one at a time give the local
  wavefront tilt from image shift; the full wavefront follows by interference or
  phase reconstruction. It calls the approach zonal and reminiscent of a
  Shack-Hartmann sensor.
- **New contribution (p. 4206-4207, Figs. 1-3).** Illuminate the whole pupil
  during measurement. All segments but one are held fixed while one segment's ray
  is scanned across the focus; the displacement of the resulting intensity
  extremum from the expected centre gives the local tilt (Fig. 1). The fixed rays
  interfere with the scanned one, so the signal modulation is 5-20% of the
  baseline, and an offset of pi/2 or pi is added when no extremum appears.
- **Results (p. 4207-4208, Figs. 2-4).** Recovers diffraction-limited
  performance in two-photon microscopy; in dense three-dimensional samples
  full-pupil illumination measures displacements unambiguously where
  single-segment illumination fails (Fig. 4).
- **Limitations (p. 4208).** Speed, limited by the 20 Hz SLM; initial
  underperformance versus single-segment illumination for strongly aberrated
  foci, improving with iterations.
- **Scope (p. 4208).** Says the method is independent of the contrast
  mechanism and potentially better suited to widefield AO.

## Relevance to the thesis

- **Weaker fit than Ji et al. 2010.** It extends the same zonal tilt idea with a
  different measurement (scanning one ray against a fixed background), which the
  thesis does not use. Cite Ji 2010 for the principle; cite this letter only if the
  full-pupil variant matters.
- **Do not pair it with "disparities between angular measurements".** Wu et al.
  2021 cite it for estimating aberrations from such disparities (Wu p. 3319),
  but this letter itself describes scanning a pupil segment in a two-photon
  excitation path; it says nothing about light-field angular views.

## Safe Wording

Milkie et al. extended pupil-segmentation adaptive optics to measure each
segment's tilt with the rest of the pupil illuminated, by scanning the
segment's ray and finding the displacement of the signal extremum [Milkie 2011,
Fig. 1]. Do not attribute light-field or digital correction to it.
