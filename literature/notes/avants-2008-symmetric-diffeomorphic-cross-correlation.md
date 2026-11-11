# Avants Et Al. 2008 - Symmetric Diffeomorphic Registration With Cross-Correlation

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

B. B. Avants, C. L. Epstein, M. Grossman, and J. C. Gee, "Symmetric
diffeomorphic image registration with cross-correlation: Evaluating automated
labeling of elderly and neurodegenerative brain," *Medical Image Analysis* 12(1),
26-41, 2008. DOI `10.1016/j.media.2007.06.004`.

## What was read

Author-supplied PDF `literature/Avants 2008.pdf` (git-ignored), the published
article, 16 pages (journal page = PDF page + 25). **Reading status:** a delegated
reader covered PDF pages 1-12; the author of this note re-read journal p. 30
(Section 2.3, Eq. 4), which matches. Other locators are from the delegated
reading.

## What the paper says

- **Local cross-correlation (Section 2.3, p. 30, Eq. 4).** The two images (each
  carried to the midpoint of the symmetric mapping) have their local mean subtracted,
  with the mean computed over an n^D window centred at each position (n is usually
  5, D the image dimension); the similarity is the squared inner product divided
  by the product of the two squared norms, all over that window. It is a box window,
  squared and normalized by the local variances; no regularizing constant is stated.
- **Framework (Sections 2.2-2.3, delegated).** Symmetric normalization: smooth,
  invertible maps from time-varying velocity fields, optimized by gradient
  descent with the cross-correlation as the driving similarity and Gaussian
  smoothing of the update. Evaluated on brain MRI labelling.
- **Stated reasons for cross-correlation (p. 30).** It adapts to locally varying
  intensities, depends only on local mean and variance estimates that can be
  measured from few samples, and has performed well where illumination and
  reflectance are unpredictable.

## Relevance to the thesis (gap ID G3), reserve source

- Fair precedent only for **a windowed, locally normalized correlation used as a
  registration similarity**.
- Not a precedent for a Gaussian-weighted window or the thesis's regularized
  denominator (the paper uses a box and no constant), nor for independent per-pixel
  argmax over discrete candidates. Its local scores are coupled by velocity-field
  regularization and a diffeomorphism constraint (delegated reading; inference
  for the contrast).
- Scharstein and Szeliski (already in the bibliography) already describe
  normalized cross-correlation as a support-region matching cost, so this paper is
  redundant unless a medical-image-registration precedent is wanted. Not added to
  `thesis.bib`.
