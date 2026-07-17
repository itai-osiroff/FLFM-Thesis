# Ng And Hanrahan - Digital Correction Of Lens Aberrations In Light Field Photography

## Citation

Ren Ng and Pat Hanrahan, *Digital Correction of Lens Aberrations in Light Field
Photography*, Stanford University.

Local PDF metadata and extracted text indicate:

- PDF metadata title: `lenscorrect.pdf`
- PDF metadata author: `renng`
- Creation/modification date: 2006-10-21
- Pages: 14

The filename says "Ren Ng Thesis", but the extracted document reads like a
paper. Venue, DOI, and final bibliographic form need verification before thesis
citation.

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

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Historical precedent for plenoptic/light-field computational imaging. |
| Chapter 3: FLFM Forward Model and Sampling Geometry | Ray-space and angular-sampling language. |
| Chapter 5: Rectification-Based Reconstruction Method | Conceptual precedent for mapping observed samples into a corrected coordinate frame. |
| Chapter 8: Discussion | Limits of angular sampling, model accuracy, and calibration. |

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

Provisional local-data entry only:

```bibtex
@misc{ng_hanrahan_digital_correction_lf,
  author = {Ng, Ren and Hanrahan, Pat},
  title = {Digital Correction of Lens Aberrations in Light Field Photography},
  institution = {Stanford University},
  year = {2006},
  note = {Local PDF metadata title: lenscorrect.pdf; venue not available in PDF}
}
```
