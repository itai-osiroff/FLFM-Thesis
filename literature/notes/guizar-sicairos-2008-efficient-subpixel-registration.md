# Guizar-Sicairos, Thurman And Fienup 2008 - Efficient Subpixel Image Registration

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Manuel Guizar-Sicairos, Samuel T. Thurman, and James R. Fienup, "Efficient
subpixel image registration algorithms," *Optics Letters* 33(2), 156-158, January
15, 2008 (published online January 10, 2008). DOI `10.1364/OL.33.000156`
(identity checked in Crossref).

## What was read

Author-supplied PDF `literature/Guizar-Sicairos 2008.pdf` (git-ignored), the
published letter, all 3 pages (156-158), read directly. This replaces an earlier
file that was a different paper (the Optics Express phase-retrieval paper).

## What the paper says

- **Problem (p. 156).** Register two images to within a small fraction of a pixel.
  The authors are mainly concerned with evaluating images reconstructed by phase
  retrieval, for which a 2D rigid translation is sufficient; more general
  transformations are needed in other applications.
- **Usual approach (p. 156).** For a pure translation, compute an upsampled cross-
  correlation by FFT and locate its peak. Cost, especially memory, grows with the
  required accuracy; registration to 1/20 pixel for 1024 x 1024 images needs a
  20,480 x 20,480 inverse FFT.
- **Three algorithms (pp. 157-158).** All start from a peak estimate by FFT
  cross-correlation upsampled by 2. Then: (1) conjugate-gradient nonlinear
  optimization of the squared correlation magnitude; (2) a single-step
  matrix-multiply DFT computing the upsampled correlation in a 1.5 x 1.5 pixel
  neighbourhood around the estimate; (3) a two-step version for higher
  upsampling. Complexity O(MN kappa) for the single step, lower for the two-step.
- **Performance (pp. 157-158, Figs. 1-2).** Same accuracy as FFT upsampling, or
  better for the nonlinear optimization (shift error 0.0029 pixel in the test),
  with much less time and memory: for 463 x 463 images at upsampling 25, 235 s
  by FFT versus 0.78 s by the single-step DFT. Registration to a hundredth of a
  pixel becomes manageable on a desktop computer.
- **Limits and extensions (pp. 157-158).** Accuracy is ultimately limited by noise;
  the algorithms extend to variants such as phase correlation and to window
  functions for edge effects. The test uses a complex-valued image, additive noise
  and a known global translation.

## What it does not cover

- Only a global translation of one image relative to another; no local, spatially
  varying or non-rigid displacement.
- No statement about registering many views to a reference or about bounded
  search ranges.

## Relevance to the thesis (gap IDs G2, G8)

- Supports: cross-correlation between two images locates their relative translation,
  and efficient methods reach sub-pixel precision.
- The thesis does **not** use this algorithm. Its global stage selects an integer
  translation by bounded cross-correlation, and its local stage reaches finer than
  one pixel by linear upsampling of the matching images and testing integer
  shifts on the finer grid (Appendix A). Cite the letter as background for
  correlation-based sub-pixel registration, not as the method used.

## Safe Wording

The translation between two images can be estimated from the peak of their
cross-correlation, and efficient algorithms locate that peak to a small
fraction of a pixel [Guizar-Sicairos 2008, pp. 156-157]. Do not state that the
thesis pipeline uses these algorithms.
