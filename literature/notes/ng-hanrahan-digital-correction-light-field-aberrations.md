# Ng And Hanrahan - Digital Correction Of Lens Aberrations In Light Field Photography

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Ren Ng and Pat Hanrahan, *Digital Correction of Lens Aberrations in Light Field
Photography*, Stanford University.

Local PDF metadata and extracted text indicate:

- PDF metadata title: `lenscorrect.pdf`
- PDF metadata author: `renng`
- Creation/modification date: 2006-10-21
- Pages: 14

The filename says "Ren Ng Thesis", but the extracted document reads like a
paper.

### Inspection record (2026-11-10)

- Read in full (14 PDF pages, as page images) the PDF at
  `https://graphics.stanford.edu/~renng/app/renng-lenscorrect.pdf`, the URL in
  `thesis.bib`. It is a complete paper with abstract, five numbered sections, a
  closing section and 18 references. The title block gives the title, authors and
  Stanford affiliation; it prints no venue or date line.
- **Venue (decision 2026-11-10).** Two records with this title and authors
  exist for the International Optical Design Conference 2006 (Vancouver): the
  full paper in *Proceedings of SPIE* 6342, article 63421E, DOI
  `10.1117/12.692290` (Crossref and OpenAlex), and an Optica/OSA conference item
  with code WB2, DOI `10.1364/IODC.2006.WB2`. The bibliography now cites the SPIE
  paper, because a 14-page paper with this abstract matches a full proceedings
  paper, not a conference-program item. **Confirmed against the SPIE copy
  (`literature/ng2007.pdf`, checked 2026-11-10):** it is marked "Invited Paper",
  carries the footer "International Optical Design Conference 2006, edited by G.
  Groot Gregory, Joseph M. Howard, R. John Koshel, SPIE Vol. 6342, 63421E,
  doi: 10.1117/12.692290", and runs 14 pages (63421E-1 to 63421E-14). Pages 1-3
  and 12-14 were compared with the Stanford copy and the text, figures and
  pagination match, so the locators in this note hold for the SPIE paper (page n
  is 63421E-n). The Stanford PDF is the same paper without the venue line.
- Locators below are PDF page numbers.

| Claim in this note | Where | Result |
| --- | --- | --- |
| Ideal and aberrated ray spaces; correction map `C(x',y',u',v') = (x,y,u,v)` | p. 3, Section 2.2 | Confirmed |
| Prototype: 4096 x 4096 sensor, 296 x 296 array, 125 micron lenslets, f/4 | p. 2, Section 2.1 | Confirmed |
| Weighting function with sigma = 2 | p. 4, Eq. (1) | Confirmed |
| Monochromatic light, chromatic aberration neglected | p. 1, Section 1 | Confirmed |
| Needs an accurate model of the lens | p. 3-4, Sections 2.2 and 3 | Confirmed |
| 8 x 8 directional sampling: average 5.4x effective-resolution gain over 22 lenses, up to 15x | p. 12, Section 5.3 | Confirmed |
| Stronger aberration needs higher directional resolution | p. 9-10, Section 5.2 | Confirmed |
| Spherical-aberration-like high-slope regions limit the gain | p. 13-14, closing | Confirmed |

What the paper does not do: correct aberrations from unknown or
sample-induced sources. The correction map comes from ray-tracing a known lens
design, so the aberration is a model input, not estimated from the recorded
views. That contrast with the thesis method is the reading note's inference, not
a statement in the paper.

## Why This Matters

This is a strong precedent for treating light-field processing as digital
rectification. It frames aberration correction as mapping measured rays from an
aberrated sampling grid into an ideal ray space before forming the output image.

For this thesis, the source is most useful as a conceptual and historical bridge
between light-field angular sampling and the current view-grid rectification
method. It is not evidence for biological scattering correction.

## Key Claims

- A light-field camera records 4D radiance by placing a microlens array before
  the sensor.
- Final images are computed by resampling rays rather than simply accepting the
  raw irradiance image.
- Digital refocusing and aberration correction both rely on re-sorting measured
  rays into desired convergence relationships.
- Refocusing power scales with directional resolution: if each microlens image
  spans `N x N` pixels, blur reduction or depth-of-focus extension scales
  approximately with `N`.
- Aberration correction can be expressed as a mapping from aberrated ray
  coordinates to ideal ray coordinates.
- Weighted correction can reduce the influence of light-field samples that
  project to a large output footprint.

## Evidence And Examples

- Prototype camera: 4096 x 4096 sensor, 296 x 296 microlens array, 125 micron
  microlenses, f/4 main/microlens configuration.
- Plano-convex lens experiment: correction improves contrast and resolution,
  especially near field edges.
- Weighted correction is compared against a reduced-aperture conventional image
  with comparable light-gathering power.
- Lens simulation study: fixed-focal-length photographic lenses from a lens
  database, with directional resolution varied up to `16 x 16`.
- Extracted report: `8 x 8` directional sampling improved effective resolution
  by an average factor of 5.4 across the simulated lens database, with larger
  gains in some cases.

## Useful Equations, Figures, Or Methods

Core correction map:

```text
C(x_prime, y_prime, u_prime, v_prime) = (x, y, u, v)
```

Conceptual construction:

```text
aberrated camera ray -> real lens ray trace -> world ray
world ray -> inverse ideal lens mapping -> ideal camera ray
```

Weighted correction:

```text
w(Delta x, Delta y) = h(Delta x) * h(Delta y)

h(x) = 1                                for x <= 1
h(x) = exp(-(1 - x)^2 / (2 * sigma^2))  for x > 1

sigma = 2
```

Figures to revisit visually before final writing:

- Fig. 1: light-field camera and ray-space refocusing.
- Fig. 2: warped aberrated sampling grid in ideal ray space.
- Fig. 3: uncorrected, corrected, and weighted-corrected prototype outputs.
- Fig. 5: weighted correction versus reduced aperture.
- Figs. 11-12: simulation database and effective-resolution scaling.

## Thesis Placement

Current editorial destinations follow the [authoritative structure and budget](../../planning/revised-thesis-structure.md).
The placement update does not reverify the source or change its inspection scope.

| Chapter | Use |
| --- | --- |
| Chapter 2: Literature Review | Historical precedent for plenoptic/light-field computational imaging. |
| Chapter 3: What is a light-field microscope | Ray-space and angular-sampling language. |
| Chapter 5: Image reconstruction | Conceptual precedent for mapping observed samples into a corrected coordinate frame. |
| Chapter 7: Discussion and Conclusions | Limits of angular sampling, model accuracy, and calibration. |

## Possible Thesis Use

- Background citation for digital light-field aberration correction.
- Motivation for describing the current algorithm as rectification rather than
  full physical inversion.
- Discussion citation for why higher angular resolution can improve correction
  but consumes spatial sampling and photon budget.

## Safe Wording

Ng and Hanrahan formulate aberration correction as a ray-space rectification
problem: measured rays are mapped from an aberrated sampling grid into an ideal
ray space before image formation. For this thesis, the work is best treated as a
geometric-optics precedent rather than direct evidence for biological scattering
correction.

## Caveats

- The source assumes monochromatic light and explicitly neglects chromatic
  aberration.
- It treats deterministic lens aberration, not multiple scattering through
  biological tissue.
- It requires an accurate model of the lens/camera system.
- Stronger distortions require higher angular resolution.
- Weighted correction can trade SNR or light efficiency for contrast.
- Final bibliographic metadata must be verified.

## Bibliography Work

The insertion note below is historical; the current bibliography is
`overleaf/back/thesis.bib`. Its former path is retained as recorded.

Superseded 2026-11-10: the entry in `overleaf/back/thesis.bib` is now an
`@inproceedings` for Proc. SPIE 6342, 63421E (see the venue decision above). The
provisional entry below is kept only as a historical record:

```bibtex
@misc{ngHanrahan2006digitalCorrection,
  author = {Ng, Ren and Hanrahan, Pat},
  title = {Digital Correction of Lens Aberrations in Light Field Photography},
  institution = {Stanford University},
  year = {2006},
  note = {Local PDF metadata title: lenscorrect.pdf; final venue metadata unresolved}
}
```
