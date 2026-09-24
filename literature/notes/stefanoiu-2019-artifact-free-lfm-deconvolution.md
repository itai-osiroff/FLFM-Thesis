# Stefanoiu 2019 - Artifact-Free Deconvolution In Light Field Microscopy

> **Status:** reference
>
> **Reviewed:** 2026-09-24

## Citation

Anca Stefanoiu, Josue Page, Panagiotis Symvoulidis, Gil G. Westmeyer, and Tobias
Lasser, "Artifact-free deconvolution in light field microscopy," *Optics
Express*, 27(22), 31644-31666, 2019. DOI: `10.1364/OE.27.031644`.

Primary source: <https://doi.org/10.1364/OE.27.031644>

## Why This Matters

This paper is useful because it discusses depth-dependent sampling and
reconstruction artifacts in LFM. It gives Chapter 2 and Chapter 8 a modern
computational reconstruction source that is closer to limitations and artifacts
than to simple LFM optimism.

## Key Claims

- LFM sampling patterns are depth-dependent, so recoverable lateral resolution
  is not uniform across depth.
- Standard reconstruction approaches can produce artifacts at axial ranges with
  coarse light-field sampling.
- The paper proposes an aliasing-aware deconvolution scheme and a flexible
  light-field PSF model.

## Useful Equations, Figures, Or Methods

- Use as context for reconstruction artifacts and sampling-dependent
  limitations.
- Useful comparison point when saying the thesis is not doing artifact-free 3D
  LFM deconvolution.

## Thesis Placement

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Computational LFM reconstruction limitations. |
| Chapter 8: Discussion | Support for caveats around artifacts and sampling-dependent performance. |

## Possible Thesis Use

- Background citation for why reconstruction quality depends on LFM sampling
  geometry.
- Discussion citation for avoiding overclaims around resolution recovery.

## Safe Wording

Stefanoiu et al. analyze sampling-dependent LFM reconstruction artifacts and
propose an aliasing-aware deconvolution framework. This thesis can use the work
as evidence that LFM reconstruction has important sampling and artifact limits,
not as evidence for the present 2D rectification pipeline.

## Caveats

- This is not an FLFM paper.
- It is a deconvolution paper; the thesis method should not be described as
  implementing this approach.
