# Guo 2019 - Fourier Light-Field Microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-08

## Citation

Changliang Guo, Wenhao Liu, Xuanwen Hua, Haoyu Li, and Shu Jia, "Fourier
light-field microscopy," *Optics Express*, 27(18), 25573-25594, 2019.
DOI: `10.1364/OE.27.025573`.

Primary source: <https://doi.org/10.1364/OE.27.025573>

## Why This Matters

This is the primary source that turns the local FLFM working note into a citable
foundation. It establishes FLFM as a Fourier-domain light-field microscope and
is the main source for describing pupil/Fourier-plane light-field processing in
Chapters 2 and 3.

For this thesis, the paper supports the optical lineage and modeling language.
It should not be used as direct evidence that the present rectification method
solves biological scattering or recovers arbitrary samples.

## Key Claims

- FLFM processes light-field information through the Fourier domain, giving the
  thesis a primary citation for naming and positioning Fourier light-field
  microscopy.
- The paper provides a theoretical and algorithmic framework for light
  propagation, image formation, and system characterization in FLFM.
- The article is volumetric-reconstruction oriented; this thesis should use it
  to support the view-grid/Fourier-plane framing, not to imply that the current
  method performs full 3D deconvolution.

## Useful Equations, Figures, Or Methods

- Use for Fourier-domain FLFM lineage and optical path framing.
- Use to define how FLFM differs from image-plane LFM before introducing the
  thesis' practical elemental-view representation.
- Revisit figures on system layout and reconstruction before writing Chapter 3.

## Inspection record (2026-11-12)

Read the open-access PDF `literature/Guo 2019 - Fourier Light-Field Microscopy.pdf` (printed pages 25573-25576; abstract, introduction, setup and image-formation overview). Locators are printed journal pages.

- **Conventional LFM limits (p. 25574):** the sampling pattern of the spatial information is uneven and becomes redundant near the native image plane, causing reconstruction artifacts; the PSF is spatially varying in lateral and axial dimensions (a 5D matrix), which makes reconstruction considerably slow.
- **FLFM remedy (abstract, pp. 25574 and 25576):** allocates spatial and angular information in a consistently aliased way, free of redundancy near the native image plane and uniform across the depth of focus; a unified 3D PSF reduces reconstruction time by roughly two orders of magnitude.
- **Layout (pp. 25575-25576):** the microlens array sits at the back focal plane of the Fourier lens, conjugated to the objective's back pupil, and segments the wavefront so that each microlens forms an image in its own region of the camera.
- **Scanning contrast (p. 25573):** LFM is presented as scanning-free, with low photodamage compared with techniques that accumulate spatial information sequentially. This does not state the exposure-phototoxicity link in the Chapter 1 sense.
- Verified for the Chapter 1 sentences on LFM limits, the FLFM remedy and the pupil-plane placement. Not checked: the design-principle and trade-off sections.

## Thesis Placement

Current editorial destinations follow the [authoritative structure and budget](../../planning/revised-thesis-structure.md).
The placement update does not reverify the source or change its inspection scope.

| Chapter | Use |
| --- | --- |
| Chapter 2: Literature Review | Primary FLFM citation and contrast with conventional LFM. |
| Chapter 3: What is a light-field microscope | Fourier/pupil-plane model support and elemental-view framing. |
| Chapter 7: Discussion and Conclusions | Boundary source for noting that standard FLFM literature often targets volumetric inverse problems. |

## Possible Thesis Use

- Background citation for the statement that FLFM is a Fourier-domain LFM
  variant.
- Model citation for describing FLFM as a system where angular information is
  encoded through Fourier/pupil-plane optics.
- Discussion citation for why this thesis is narrower than full volumetric FLFM
  reconstruction.

## Safe Wording

Guo et al. introduced Fourier light-field microscopy as a Fourier-domain
light-field approach with a system-level model for light propagation, image
formation, and FLFM characterization. In this thesis, it is the primary source
for FLFM optical context and model language, while the implemented method
remains a 2D elemental-view rectification pipeline rather than a full FLFM
deconvolution method.

## Caveats

- The paper supports FLFM theory and reconstruction context, not the specific
  local rectification implementation.
- The paper is not direct evidence for recovery through chicken breast,
  eyedrop, or other tested media.
- Avoid citing it as proof of general scattering correction.
