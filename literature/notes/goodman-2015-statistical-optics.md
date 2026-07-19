# Goodman 2015 - Statistical Optics

## Citation

Joseph W. Goodman, *Statistical Optics*, 2nd edition, Wiley Series in Pure and
Applied Optics, John Wiley & Sons, Hoboken, New Jersey, 2015.

Visible metadata:

- ISBN: `978-1-119-00945-0`
- Library of Congress classification visible in extraction: `QC355.2.G66 2015`

## Why This Matters

This is the core theory source for coherence, partial-coherence imaging,
speckle, random phase screens, imaging through randomly inhomogeneous media,
OTF/PSF degradation, and detection noise.

For this thesis, Goodman should support Chapter 4 and selected parts of Chapter
2. It should not be used as a direct model of biological tissue unless the
assumptions are stated carefully.

## Key Claims

- Real optical systems often need statistical models because objects, fields,
  media, and detection processes include uncertainty.
- Mutual coherence and mutual intensity describe how optical fields correlate
  across space and time.
- Coherent and incoherent imaging are limiting cases; partial coherence changes
  image formation.
- In incoherent imaging, image intensity can be modeled as object intensity
  convolved with an intensity PSF.
- Random phase screens degrade the average OTF according to the phase structure
  function.
- Randomly inhomogeneous media can degrade long- and short-exposure imaging in
  different ways.
- Speckle is a natural consequence of coherent imaging through random media or
  rough structures.
- Detection limits combine photon shot noise, excess intensity noise, and read
  noise.

## Useful Equations, Figures, Or Methods

Coherence definitions:

```text
J(P1, P2) = Gamma(P1, P2; 0)
mu(P1, P2) = J(P1, P2) / sqrt(I(P1) * I(P2))
0 <= |mu| <= 1
```

Thin transmitting structure:

```text
J_t(P1, P2) = t_A(P1) * conj(t_A(P2)) * J_i(P1, P2)
```

Hopkins-style propagation relation:

```text
J_2(Q1, Q2) =
  integral integral K(Q1, P1) * conj(K(Q2, P2)) * J_1(P1, P2) dP1 dP2
```

Incoherent imaging limit:

```text
I_image = |t_object|^2 convolved with |K|^2
```

Coherent imaging limit:

```text
I_image = |K convolved with t_object|^2
```

Random phase screen average OTF:

```text
H_bar(nu) = H_0(nu) * H_s(nu)
H_s(nu_U, nu_V) = exp[-0.5 * D_phi(lambda * f * nu_U, lambda * f * nu_V)]
```

For a wide-sense stationary Gaussian phase:

```text
D_phi(Delta x, Delta y) = 2 * sigma_phi^2 * [1 - gamma_phi(Delta x, Delta y)]
```

Long-exposure random-media/turbulence OTF:

```text
H_bar(nu) = H_0(nu) * exp[-0.5 * D(lambda * f * nu)]
```

Sections to revisit:

- Chapter 5: mutual coherence and Van Cittert-Zernike theorem.
- Chapter 7: partial coherence in imaging systems, Hopkins formula, speckle.
- Chapter 8: random phase screens and randomly inhomogeneous media.
- Chapter 9: photoelectric detection and noise.

## Thesis Placement

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Statistical optics context, coherence, noise, and speckle terminology. |
| Chapter 3: FLFM Forward Model and Sampling Geometry | Only where mutual intensity or incoherent imaging assumptions are needed. |
| Chapter 4: Aberration and Scattering | Primary theory support for random phase screens, OTF degradation, and random media. |
| Chapter 6: Experimental Setup, Data, and Evaluation Protocol | Noise and detection limits, if needed for camera/exposure discussion. |
| Chapter 8: Discussion | Limits of random-screen analogies and weak-scattering assumptions. |

## Possible Thesis Use

- Theory citation for partial-coherence imaging.
- Theory citation for random phase screens and average OTF degradation.
- Theory citation for speckle and detection noise.
- Discussion support for why strong biological scattering should not be
  oversimplified into a single deterministic warp.

## Safe Wording

Goodman provides the statistical-optics framework needed to discuss
media-induced degradation as random phase, random field, or partially coherent
imaging effects. Random phase screen theory is a useful first model for
wavefront distortion, but it should not be presented as a complete model of
multiple scattering in thick biological tissue.

## Caveats

- Chapter 8 is largely atmospheric/random-media theory, not biological tissue
  optics.
- The atmospheric sections explicitly exclude some particulate scattering
  effects; biological media may include absorption, anisotropy, multiple
  scattering, and dynamic structure.
- Many derivations assume scalar, paraxial, quasimonochromatic, homogeneous,
  isotropic, Gaussian, or ergodic conditions.
- Born and Rytov approximations are weak-fluctuation tools and may fail under
  strong multiple scattering.
- Exact equation formatting should be checked visually before final thesis use.

## Bibliography Work

Verified BibTeX entry added to `overleaf/refs/thesis.bib`:

```bibtex
@book{goodman2015statisticalOptics,
  author    = {Goodman, Joseph W.},
  title     = {Statistical Optics},
  edition   = {2},
  publisher = {John Wiley & Sons},
  address   = {Hoboken, New Jersey},
  year      = {2015},
  isbn      = {978-1-119-00945-0},
  series    = {Wiley Series in Pure and Applied Optics}
}
```
