# Zitova And Flusser 2003 - Image Registration Methods: A Survey

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Barbara Zitova and Jan Flusser, "Image registration methods: a survey," *Image
and Vision Computing* 21(11), 977-1000, 2003. DOI `10.1016/S0262-8856(03)00137-9`
(printed in the file's footer; issue number from Crossref).

## What was read

Author-supplied PDF `literature/Zitová and Flusser 2003.pdf` (git-ignored), the
published article, 24 pages (printed pp. 977-1000; printed page = PDF page + 976).
**Reading status:** a delegated reader covered PDF pages 1-21 and 24; the
author of this note re-read printed p. 982 (Section 4.1.1) and it matches. The
other locators below come from the delegated reading and were not re-checked.

## Why This Matters

General survey that frames the thesis's global stage (one translation per view
estimated by windowed correlation) and the move to a local, spatially varying
correction, and that states the common view that bilinear interpolation is a
standard accuracy-versus-cost choice for resampling.

## What the survey says

- **Correlation-like methods (Section 4.1.1, p. 982).** Classical area-based
  registration matches image windows with cross-correlation and its normalized
  form (formula given); the maximum over window pairs gives the match. The method
  can exactly align images that are mutually translated, and can still work with
  slight rotation or scaling. Sub-pixel accuracy requires interpolating the
  correlation values.
- **Weaknesses (p. 982).** Sensitivity to intensity changes and sensor type;
  smooth, low-detail windows are matched wrongly; flat similarity maxima; high
  computational cost.
- **Window shape (p. 981-982, delegated).** Rectangular windows suit images that
  differ locally by a translation; more complex deformations break the
  assumption.
- **Global versus local mappings (Section 5, pp. ~989-993, delegated).** Global
  models use all control points for one parameter set; local models treat the
  image as patches with position-dependent parameters. A global least-squares fit
  averages out local distortion, which is not desirable when distortion is local.
- **Resampling (Section 6, pp. ~992-994, delegated).** Backward mapping is
  preferred over forward mapping (forward leaves holes); interpolation by kernel
  convolution, with nearest neighbour, bilinear and bicubic the most common;
  bilinear is probably the best accuracy-to-cost trade-off and the most commonly
  used.
- **Hierarchical search (pp. ~984-989, delegated).** Pyramid or coarse-to-fine
  strategies are described for speed; large-scale alignment first, small
  corrections after; they fail if a false match happens at a coarse level.

## What it does not cover

- No light-field or multi-view data, no averaging of registered images, no
  per-pixel displacement search. Optical-flow registration is explicitly out of
  scope; dense stereo is mentioned only as an application.
- No statement about integer-only shifts or a bounded search range (it mentions
  exhaustive search when only translations are estimated).
- No experimental comparison; the survey does not compare algorithms.

## Relevance to the thesis (gap IDs G2, G4, G5)

- Supports: "area-based correlation registers translations; local deformation
  calls for local mappings; bilinear interpolation is a common accuracy-cost
  compromise; backward mapping avoids holes".
- Does not support the specific global-then-local scheme or any claim about
  performance on light-field views. The global-then-local ordering is the
  thesis's own design.

## Safe Wording

Area-based registration estimates the translation between images by maximizing
a cross-correlation measure over a window; local deformations call for
position-dependent mappings, and resampling is usually done by backward mapping
with, for example, bilinear interpolation [Zitova and Flusser 2003,
Sections 4.1.1, 5, 6].
