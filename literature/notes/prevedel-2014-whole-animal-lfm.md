# Prevedel 2014 - Whole-Animal 3D Imaging With LFM

> **Status:** reference
>
> **Reviewed:** 2026-11-08

## Citation

Robert Prevedel, Young-Gyu Yoon, Maximilian Hoffmann, Nikita Pak, Gordon
Wetzstein, Saul Kato, Tina Schrodel, Ramesh Raskar, Manuel Zimmer, Edward S.
Boyden, and Alipasha Vaziri, "Simultaneous whole-animal 3D imaging of neuronal
activity using light-field microscopy," *Nature Methods*, 11(7), 727-730,
2014. DOI: `10.1038/nmeth.2964`.

Primary source: <https://doi.org/10.1038/nmeth.2964>

## Why This Matters

This is a flagship biological LFM application paper. It helps Chapter 2 explain
why single-snapshot volumetric imaging is valuable for fast biological dynamics,
especially when the target is neural activity rather than static calibration
objects.

## Key Claims

- The paper demonstrates simultaneous functional imaging of neuronal activity
  in *C. elegans* and larval zebrafish.
- It reports capture of spiking-neuron dynamics in volumes around 700 by 700 by
  200 micrometers at 20 Hz.
- It motivates speed and volume, but not the thesis' specific 2D scattering
  recovery problem.

## Useful Equations, Figures, Or Methods

- Use figures and abstract-level result only as motivation for LFM's value in
  fast biological imaging.
- Do not borrow its performance numbers for the local system.

## Thesis Placement

Current editorial destinations follow the [authoritative structure and budget](../../planning/revised-thesis-structure.md).
The placement update does not reverify the source or change its inspection scope.

| Chapter | Use |
| --- | --- |
| Chapter 2: Literature Review | Biological motivation for high-speed LFM. |
| Chapter 7: Discussion and Conclusions | Context for future biological extensions beyond bead scenes. |

## Possible Thesis Use

- Background citation for high-speed volumetric neuronal imaging with LFM.
- Contextual citation when comparing bead-scene validation with biological
  imaging ambitions.

## Safe Wording

Prevedel et al. demonstrate that LFM can support simultaneous whole-animal 3D
functional imaging at biologically relevant speeds. This thesis should cite the
paper for biological LFM motivation, not as evidence that the current FLFM
rectification method handles whole organisms or neural activity.

## Caveats

- The paper is not about the thesis' rectification algorithm.
- The sample, system, and evaluation target differ sharply from 2D fluorescent
  bead scenes through tested media.
