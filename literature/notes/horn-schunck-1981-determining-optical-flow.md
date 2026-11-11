# Horn And Schunck 1981 - Determining Optical Flow

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Berthold K. P. Horn and Brian G. Schunck, "Determining optical flow," *Artificial
Intelligence* 17(1-3), 185-203, 1981. DOI `10.1016/0004-3702(81)90024-2`
(issue and DOI checked in Crossref).

## What was read

Author-supplied PDF `literature/Horn and Schunck 1981.pdf` (git-ignored), the
journal article, 19 pages (journal pp. 185-203; journal page = PDF page + 184).
**Reading status:** a delegated reader covered the whole file; the author of this
note re-read the title page and abstract (p. 185), which match. Section locators
below come from the delegated reading and were not re-checked. The equations are
unnumbered in the paper, so cite by section.

## What the paper says

- **Definition (Section 1).** Optical flow is the distribution of apparent
  velocities of movement of brightness patterns in an image.
- **Why a second constraint (abstract, p. 185; Sections 1 and 4).** Flow cannot be
  computed locally, because only one independent measurement is available at a
  point while the velocity has two components. A second constraint is needed:
  here, that apparent velocity varies smoothly almost everywhere.
- **Brightness constancy (Section 4; Appendix A).** The constraint
  E_x u + E_y v + E_t = 0, derived with a first-order Taylor expansion for small
  displacements.
- **Smoothness and solution (Sections 5, 9, 12).** Minimise a weighted sum of the
  squared brightness-constraint error and the squared gradient of the flow;
  solved iteratively with neighbourhood averages. A parameter weights smoothness
  against the data term.
- **Small-motion method (Appendix A, Section 7).** Derivatives are estimated from
  first differences over about one pixel and one frame; the experiments use
  synthetic sequences with sub-pixel to one-pixel motion. No multiscale scheme.
- **Self-assessment (summary).** The authors call the resulting field somewhat
  inaccurate.

## Relevance to the thesis (gap ID G3)

- Supports one idea: an image pair can be related by a **dense field**, a
  displacement or velocity vector at every pixel.
- Does not support the thesis's local stage as such. The thesis selects each
  pixel's displacement independently from a bounded candidate set by windowed
  matching and has **no smoothness term**; Horn and Schunck solve a global
  variational problem that depends on a smoothness prior and a small-displacement
  derivative model.

## Safe Wording

Dense displacement or flow fields, assigning a motion vector to every pixel
between two images, were formalized for image sequences by Horn and Schunck,
who combine a brightness-constancy constraint with a smoothness prior
[Horn and Schunck 1981]. Do not attribute independent per-pixel candidate
selection, windowed matching or large-displacement handling to the paper.
