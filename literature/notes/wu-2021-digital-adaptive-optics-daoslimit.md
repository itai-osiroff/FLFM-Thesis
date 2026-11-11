# Wu Et Al. 2021 - Digital Adaptive Optics In Scanning Light-Field Microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Jiamin Wu, Zhi Lu, Dong Jiang, Yuduo Guo, Hui Qiao, Yi Zhang, Tianyi Zhu,
Yeyi Cai, Xu Zhang, Karl Zhanghao, Hao Xie, Tao Yan, Guoxun Zhang, Xiaoxu Li,
Zheng Jiang, Xing Lin, Lu Fang, Bing Zhou, Peng Xi, Jingtao Fan, Li Yu, and
Qionghai Dai, "Iterative tomography with digital adaptive optics permits
hour-long intravital observation of 3D subcellular dynamics at millisecond
scale," *Cell* 184, 3318-3332, June 10, 2021. DOI `10.1016/j.cell.2021.04.029`
(identity checked in OpenAlex and Crossref, 2026-11-10).

## What was read

Local PDF `literature/wu2021cell.pdf` (git-ignored), the version of record:
all 15 journal pages (3318-3332), including the figures, Discussion, Limitations
and reference list. **The STAR Methods and supplementary figures and notes are
online only and are not in this PDF**, so the derivation of the shift model
("Principle of digital adaptive optics") and the tiling details were not read.
Locators below are Cell journal page numbers. An earlier read of the 2019 bioRxiv
preprint (different title and headline numbers) is superseded; use only this
version.

## Why This Matters

Closest precedent found so far for digital, post-processing correction of
sample- and system-induced aberrations in a light-field microscope, tiled over
the field of view. Its shift-based formulation parallels the thesis premise,
which the author has decided to state as the thesis's own modelling assumption.

## Key Claims (paraphrased)

- **System and method (p. 3318-3319).** DAOSLIMIT combines scanning
  light-field microscopy (a 2D galvo shifts the image plane, giving spatial
  overlap between adjacent microlenses at the cost of temporal resolution), digital
  adaptive optics (DAO) with tiled wavefront correction, and iterative
  tomography. Summary figures: 225 x 225 x 16 micron volume, up to 220 nm lateral and
  400 nm axial resolution.
- **Shift model (p. 3319, "Principle and implementation").** Linear phase
  modulations over segmented apertures correspond to spatial shifts of the
  angular components (cites Ji et al. 2010). The authors state that this lets
  them estimate spatially nonuniform aberrations "from the disparities between
  angular measurements" (cites Milkie et al. 2011) and correct them "by
  digitally shifting the angular images" (STAR Methods, Fig. S1, Fig. 1C). They
  call this process DAO.
- **Estimation is coupled to 3D reconstruction (p. 3319).** An ADMM-based
  algorithm, "mutual iterative tomography", incorporates iterative wavefront
  estimation and volume reconstruction with tiled aberration correction.
- **Validation against hardware AO (p. 3323, Fig. 3, Fig. S5).** Aberrations up to
  the 41st Zernike order were introduced with a spatial light modulator at the pupil
  plane as ground truth in Thy1-YFP mouse brain slices. DAO recovered resolution
  and SNR, with residual wavefront error similar to hardware pupil-segmentation AO.
- **Spatial variation (p. 3323, Fig. 3E-J).** DAO handles spatially nonuniform
  aberrations by dividing the field of view into parts. In rat DRG neurons,
  multi-site DAO was needed for a large field: applying the centre aberration
  to a corner region, or the reverse, reduced resolution.
- **Context (pp. 3318-3319, re-checked 2026-11-10).** The introduction states that
  nonuniform refractive-index distributions in tissue lead to severe optical
  aberrations that degrade resolution and SNR (citing Booth 2014 and Ji 2017), and
  that lattice light-sheet microscopy with AO is limited because "both the small
  field of view and tiling AO correction restrict their speed for a large volume".
  **Correction:** an earlier version of this note also said the authors describe
  tiled or averaged hardware correction and call per-pixel modulation impractical.
  That sentence is in the 2019 bioRxiv preprint (p. 3), not in the Cell version of
  record, and must not be cited to Cell.
- **Limitations (p. 3329).** Out-of-focus background fluorescence and the
  limited sensor dynamic range; the missing-cone problem in widefield
  collection; the smoothness assumption of the time-weighted algorithm;
  computational cost of the iterative reconstruction; and that comparisons with
  other methods used static samples, because ground truth for dynamic samples
  in vivo is hard to obtain.

## Relevance to the thesis

- Supports the **plausibility** of a view-shift model of aberration in
  light-field microscopy: pupil-segment tilt acts as a lateral shift of that
  segment's image, and aberrations can be estimated from disparities between
  angular measurements. It does not prove the thesis assumption for the FLFM
  acquisition.
- Supports a **precedent** for digital aberration correction in a
  light-field microscope with spatially tiled correction (gap IDs G16, G21).
- Points to the primary sources of the pupil-segmentation idea: Ji, Milkie and
  Betzig (Nature Methods 2010) and Milkie, Betzig and Ji (Optics Letters 2011).
  Both are listed in its reference list (p. 3331-3332) and are now candidates in
  the [candidates list](../../planning/bibliography-candidates.md).

## Differences to state if cited

- Scanning light-field microscope with galvo shifting of the image plane, not
  single-shot FLFM.
- 3D volume reconstruction by iterative tomography, with a wavefront model
  and Zernike-level validation; the thesis recovers a 2D image by alignment and
  averaging with no PSF or wavefront model.
- The aberration estimate is coupled to the 3D reconstruction, not a standalone
  per-view displacement estimate.

## Still unread

- STAR Methods "Principle of digital adaptive optics" and Fig. S1 (derivation of
  the shift model, tile definition, how disparities are measured).
- Fig. S5H and S5I (division of the field into parts).

Obtain the online STAR Methods if the thesis wants to describe how the shifts are
estimated, not only that they are.

## Safe Wording

Wu et al. corrected sample- and system-induced aberrations digitally in a
scanning light-field microscope: aberrations are estimated from disparities
between angular views, which correspond to lateral shifts of sub-aperture
images, and corrected by shifting those images within an iterative
three-dimensional reconstruction, tile by tile across the field of view
[Wu 2021, p. 3319]. Do not describe it as a 2D or single-shot method.
