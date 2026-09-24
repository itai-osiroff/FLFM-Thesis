# Fourier Light Field Microscopy - Local Secondary Note

> **Status:** reference
>
> **Reviewed:** 2026-09-24

## Citation

Visible title: *Fourier Light Field Microscopy*.

No author, venue, date, DOI, or publication metadata were visible in the local
PDF extraction. Treat this file as a local working/survey note until its
publication metadata is verified.

## Why This Matters

This is useful as a reading and synthesis map for FLFM. It explains FLFM as
Fourier/pupil-plane light-field sampling, contrasts it with image-plane LFM,
summarizes forward-model language, and lists several primary sources that should
be verified before the thesis bibliography is finalized.

It should not be cited as primary evidence in the thesis unless its origin is
confirmed.

## Key Claims

- FLFM records a single 2D frame that encodes spatial and angular information.
- The microlens array is placed in or conjugate to the pupil/Fourier plane,
  making each lenslet correspond to a pupil segment or sub-aperture.
- Each sub-aperture forms an elemental view with reduced effective NA.
- Compared with image-plane LFM, FLFM is presented as closer to a
  shift-invariant elemental-view model and therefore computationally more
  convenient for deconvolution-style reconstruction.
- The standard volumetric inverse-problem form can be written as:

```text
y = A x + n
```

where `x` is a fluorophore distribution, `y` is the sensor measurement, `A` is
the forward operator, and `n` is noise.

- FLFM gains snapshot volumetric acquisition and more uniform modeling at the
  cost of reduced effective NA per view and calibration sensitivity.

## Evidence And Examples

The local note points toward, but does not itself verify, the following evidence
families:

- Guo/Jia-style FLFM papers for pupil-plane microlens placement and unified PSF
  modeling.
- Practical FLFM setup guidance for Fourier-plane placement, field stops, and
  elemental-image overlap control.
- Wave-optics LFM papers for the broader `y = A x + n` inverse-problem framing.
- Reconstruction literature including Richardson-Lucy deconvolution, hybrid
  PSFs, dictionary priors, scattering-aware models, and learned reconstruction.

## Useful Equations, Figures, Or Methods

- Optical path skeleton:

```text
sample -> objective -> tube lens -> native image plane
native image plane -> Fourier lens -> pupil/Fourier plane -> MLA
MLA -> relay optics -> sensor
```

- Forward model:

```text
y = A x + n
```

- Modeling concepts to verify in primary sources:
  - incoherent fluorescence as approximately linear intensity superposition;
  - pupil segmentation by sub-aperture window functions;
  - reduced effective NA per elemental view;
  - measured, simulated, and hybrid PSFs;
  - field stop or iris requirements to prevent elemental-image overlap.

## Thesis Placement

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Use as a checklist for missing primary FLFM citations. |
| Chapter 3: FLFM Forward Model and Sampling Geometry | Use as a draft structure for explaining pupil partitioning and elemental views. |
| Chapter 4: Aberration and Scattering | Use calibration/model-mismatch limitations as discussion prompts. |
| Chapter 6: Experimental Setup, Data, and Evaluation Protocol | Use setup concerns as a checklist: pupil conjugation, field stop, PSF measurement, bead calibration. |
| Chapter 8: Discussion | Use as a source of caveat categories, but cite primary papers instead. |

## Possible Thesis Use

- Internal planning map for the FLFM theory chapter.
- Reading queue generator for primary FLFM and reconstruction papers.
- Checklist for what must be verified before writing thesis claims about FLFM.

## Safe Wording

The local FLFM note summarizes the standard view that Fourier-plane microlens
placement partitions the pupil into elemental views and can simplify
reconstruction relative to image-plane LFM. Because the file has no visible
publication metadata, every factual claim should be backed by primary citations
before appearing in the thesis.

## Caveats

- This is not currently a citable primary source.
- It focuses on 3D FLFM reconstruction, while the thesis is currently bounded to
  rectification-based recovery of 2D fluorescent bead scenes.
- The note's embedded citation trail has been partly resolved by the new
  primary notes; remaining learned-reconstruction leads should be verified only
  if they are needed in the final discussion.

## Bibliography Work

Primary entries now added or noted:

- Guo/Jia FLFM primary paper: added as Guo 2019.
- Applied Optics FLFM design/setup guides: added as Galdon 2022 and Yun 2023.
- Broxton-style wave-optics LFM modeling: added as Broxton 2013.
- Biological LFM motivation: added as Prevedel 2014.
- Scattering-aware LFM comparison: added as Zhang 2021 computational optical
  sectioning.
- Learned LFM/FLFM reconstruction papers remain optional discussion sources;
  add only if the final discussion needs them directly.
