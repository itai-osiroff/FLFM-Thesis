# Cong Et Al. 2017 - XLFM: Whole-Brain Imaging Of Freely Behaving Zebrafish

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Lin Cong, Zeguan Wang, Yuming Chai, Wei Hang, Chunfeng Shang, Wenbin Yang, Lu
Bai, Jiulin Du, Kai Wang, and Quan Wen, "Rapid whole brain imaging of neural
activity in freely behaving larval zebrafish (*Danio rerio*)," *eLife* 6, e28158,
2017. DOI `10.7554/eLife.28158` (open access, CC-BY).

## What was read

Author-supplied PDF `literature/Cong et al., eLife 6, e28158, 2017.pdf`
(git-ignored), the published article, 20 pages. **Reading status:** a delegated
reader covered all 20 pages; the author of this note re-read pp. 3-4 (Results
start, Fig. 1), which match. Other locators come from the delegated reading.

## What the paper says

- **Layout (p. 3, Fig. 1a; Methods pp. 11-13, delegated).** The extended
  field-of-view light-field microscope (XLFM) places a customized lenslet array at
  a plane conjugate to the rear pupil of the objective, "instead of at the imaging
  plane as in LFM" (p. 3); the sensor sits at an image plane. In ideal conditions
  a spatially invariant 2D PSF can be defined; in practice it is approximately
  invariant.
- **Design (pp. 3, 11-12, delegated).** A custom array of 27 microlenses (1.3 mm
  diameter, 26 mm focal length) in two groups displaced axially by 2.5 mm, giving
  multifocal imaging; lenslet aperture is decoupled from spacing and arrangement
  so field of view and resolution can be optimized together. Objective 25x/1.05;
  sCMOS camera; the light collected is about 16% of the NA 1.05 light.
- **Reconstruction (p. 12-13, delegated).** The PSF is measured with a bead scanned
  axially; the algorithm is derived from Richardson-Lucy deconvolution over two
  PSFs, about 30 iterations, about 4 min per volume on a GPU.
- **Performance (p. 3, spot-checked).** About 800 um diameter by more than 400 um
  depth, optimal resolution of 3.4 x 3.4 x 5 um over 200 um depth in the design
  case, degrading beyond about 500 um x 100 um because of lenslet focal-length
  variation; 77 volumes/s; imaging for about 100 min and more than 300,000
  volumes.
- **Limits (pp. 3, 9, 13-16, delegated).** Near single-cell resolution requires
  sparse activity (critical sparseness about 0.11); the characterization assumes no
  aberration or scattering and tissue aberration will degrade resolution; sensor
  pixels limit the reconstructable voxels.
- **Relation to other work (p. 13, delegated).** Contrasted explicitly with Broxton
  et al. 2013: different optics, shift-invariant instead of spatially varying PSF,
  measured instead of simulated. Guo et al. 2019 postdates it and is not cited. The
  word "Fourier" is not used.

## Relevance to the thesis (gap IDs G14, G15)

- An earlier pupil-plane light-field design with an approximately shift-invariant
  PSF, from 2017. That is the same optical idea as the pupil-conjugate FLFM
  arrangement attributed to Guo et al. 2019 in Chapters 1-3 (the identification is
  the note's inference; the paper does not call it Fourier LFM).
- **Check the thesis wording.** If any chapter implies that placing the microlens
  array in a pupil-conjugate plane originated with Guo et al., Cong et al. 2017 is
  an earlier precedent. The thesis currently cites Guo for FLFM, which is
  accurate; only a first-or-novel claim would be affected.
- Not a precedent for aberration correction: it explicitly assumes an
  aberration-free, scattering-free characterization.

## Safe Wording

Cong et al. placed a lenslet array in a plane conjugate to the objective's rear
pupil, not at the image plane, so that a spatially invariant PSF could be
approximately defined, and reconstructed volumes by Richardson-Lucy-type
deconvolution with a measured PSF [Cong 2017, p. 3]. Do not call the design a
Fourier light-field microscope.
