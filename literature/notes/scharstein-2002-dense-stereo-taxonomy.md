# Scharstein And Szeliski 2002 - Taxonomy Of Dense Two-Frame Stereo Correspondence

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Daniel Scharstein and Richard Szeliski, "A taxonomy and evaluation of dense
two-frame stereo correspondence algorithms," *International Journal of Computer
Vision* 47(1-3), 7-42, 2002. DOI `10.1023/A:1014573219977` (identity checked in
Crossref, 2026-11-10).

## What was read

The Middlebury-hosted PDF (`vision.middlebury.edu/stereo/taxonomy-IJCV.pdf`),
fetched 2026-11-10 and not stored in the repo: PDF pages 1-10 (abstract,
Sections 1-4 including Table 1 and Table 2). Sections 5-8 (evaluation,
experiments, comparison of 20 algorithms) were not read. PDF page n is journal
page n + 6. Locators below are PDF page numbers.

## Why This Matters

Names and describes the family the thesis's local stage belongs to: local,
window-based correspondence, where a matching cost is computed per candidate
displacement, aggregated over a support region, and the best candidate is chosen
independently at each pixel (winner-take-all).

## What the paper says

- **Four building blocks (p. 3, Section 3).** Stereo algorithms generally perform
  matching-cost computation, cost aggregation, disparity computation or
  optimization, and disparity refinement.
- **Local algorithms (p. 3).** The disparity at a point depends only on intensity
  values within a finite window, usually making an implicit smoothness assumption
  by aggregating support. The sum-of-squared-differences example is cost, then
  aggregation by summing over square windows, then selecting the minimal
  aggregated value at each pixel.
- **Costs that merge steps 1 and 2 (p. 3).** Some local algorithms use a matching
  cost based on a support region, such as normalized cross-correlation or the rank
  transform.
- **Matching costs (p. 3-4, Section 3.1).** Squared and absolute differences are
  the most common; normalized cross-correlation is another traditional cost and
  behaves similarly to SSD. Robust (truncated) costs limit the influence of
  mismatches during aggregation.
- **Aggregation (p. 4, Section 3.2, Eq. 2).** Aggregation over a fixed support
  region is a convolution of the initial cost volume with a window function;
  square windows or Gaussian convolution are the traditional choices.
- **Local winner-take-all (p. 4, Section 3.3).** In local methods the emphasis is
  on matching cost and aggregation; computing the final disparity is trivial:
  choose at each pixel the candidate with the minimum cost. A stated limitation is
  that uniqueness of matches is enforced only for the reference image.
- **Contrast with global methods (p. 4-5).** Global methods add explicit
  smoothness terms and minimize an energy; a smoothness-free local choice is the
  case where the independent per-pixel selection stands.
- **Optic-flow-style methods (p. 6, Section 3.5).** Images are successively
  warped and motion estimates incrementally updated, often in a coarse-to-fine
  hierarchical framework.
- **Scope (p. 1-2).** Calibrated two-frame stereo with rectified image pairs and
  a one-dimensional disparity along the scanline.

## Relevance to the thesis

- Supports describing the Chapter 5 local stage as a local, window-based search
  with Gaussian-weighted aggregation and independent per-pixel winner-take-all
  selection (gap ID G3). Whether the thesis's normalized, regularized product score
  falls under "normalized cross-correlation as a support-region cost" is the note's
  inference, not the paper's statement.
- Cite the taxonomy for the family and vocabulary only. Do not attribute the
  thesis's specific score, the bounded 2D displacement set or the use of the global
  average as the reference to the paper.

## Differences to state if cited

- The paper is about rectified stereo pairs with a 1D disparity. The thesis
  searches a bounded set of 2D displacements for each of N x N views against a
  composite reference.
- No smoothness term appears in the thesis's local selection, consistent with
  the local-method case, but the paper discusses this in a stereo context.

## Safe Wording

Local window-based correspondence methods compute a matching cost for each
candidate displacement, aggregate it over a support region, and select the
best candidate independently at each pixel [Scharstein and Szeliski 2002,
Section 3]. Do not attribute any thesis-specific score to the paper.
