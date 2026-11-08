# Broxton 2013 - Wave Optics And 3D Deconvolution For LFM

> **Status:** reference
>
> **Reviewed:** 2026-11-08

## Citation

Michael Broxton, Logan Grosenick, Samuel Yang, Noy Cohen, Aaron Andalman, Karl
Deisseroth, and Marc Levoy, "Wave optics theory and 3-D deconvolution for the
light field microscope," *Optics Express*, 21(21), 25418-25439, 2013.
DOI: `10.1364/OE.21.025418`.

Primary source: <https://doi.org/10.1364/OE.21.025418>

## Why This Matters

This is the main citable source for wave-optics LFM modeling and 3D
deconvolution. It strengthens Chapter 2's reconstruction context and Chapter 3's
forward-model discussion while giving Chapter 7 a clear contrast: the thesis'
software is rectification and averaging, not a full wave-optics inverse solver.

## Key Claims

- LFM can capture a 4D light field in a single exposure and reconstruct a 3D
  volume computationally.
- The paper replaces simple ray optics with a wave-optics model and formulates
  reconstruction as an inverse problem using a measurement matrix.
- The paper explicitly treats fluorescence as an incoherent, linear imaging
  process, while also adopting assumptions such as monochromatic light and no
  scattering in the volume.

## Useful Equations, Figures, Or Methods

- Forward model:

```text
f = H g
```

where `f` is the measured light field, `g` is the volume, and `H` is the
measurement matrix.

- Use the pinhole-view / low-resolution angular-view language cautiously as
  background for elemental views.
- Revisit its assumptions before writing any equation that resembles a
  deconvolution model.

## Thesis Placement

Current editorial destinations follow the [authoritative structure and budget](../../planning/revised-thesis-structure.md).
The placement update does not reverify the source or change its inspection scope.

| Chapter | Use |
| --- | --- |
| Chapter 2: Literature Review | LFM reconstruction and spatial-angular tradeoff. |
| Chapter 3: What is a light-field microscope | Incoherent fluorescence and forward-model framing. |
| Chapter 7: Discussion and Conclusions | Boundary between deconvolution/inverse modeling and this thesis' rectification method. |

## Possible Thesis Use

- Background citation for LFM as snapshot, scanless volumetric imaging.
- Citation for the idea that LFM reconstruction can be formulated as an inverse
  problem.
- Contrast citation for why the thesis should avoid describing the implemented
  method as deconvolution.

## Safe Wording

Broxton et al. formulate LFM reconstruction with a wave-optics forward model
and a 3D deconvolution inverse problem. This thesis can use the paper to frame
standard LFM reconstruction literature and the incoherent-fluorescence
assumption, while explicitly distinguishing the local method as elemental-view
rectification and averaging.

## Caveats

- The paper is image-plane LFM, not FLFM.
- The model assumes no scattering in the volume; do not use it as a tissue
  scattering solution.
- The thesis' implemented method does not construct or invert the Broxton-style
  measurement matrix.
