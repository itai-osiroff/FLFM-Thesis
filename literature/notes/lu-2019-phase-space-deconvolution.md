# Lu Et Al. 2019 - Phase-Space Deconvolution For Light Field Microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Zhi Lu, Jiamin Wu, Hui Qiao, You Zhou, Tao Yan, Zijing Zhou, Xu Zhang, Jingtao
Fan, and Qionghai Dai, "Phase-space deconvolution for light field microscopy,"
*Optics Express* 27(13), 18131-18145, 2019. DOI `10.1364/OE.27.018131`.

## What was read

Author-supplied PDF `literature/Lu et al., Optics Express 27(13), 18131, 2019.pdf`
(git-ignored), the open-access published article, 15 pages (journal pp.
18131-18145). **Reading status:** a delegated reader covered all 15 pages; the
author of this note re-read journal pp. 18131-18132 (abstract, introduction, start
of the method), which match. Other locators come from the delegated reading.

## What the paper says

- **Problem (abstract, introduction pp. 18131-18132).** Traditional 3D deconvolution
  for LFM uses a high-precision beam-propagation model that is not robust to
  system errors such as aberrations and background fluorescence, causing periodic
  artifacts and reduced contrast; strong artifacts and low resolution appear close
  to the native object plane because of low spatial sampling. The 3D PSF is
  spatially non-uniform and stored as a large matrix, raising computation and
  memory cost and limiting depth range.
- **Setup (Section 2, p. 18132, Fig. 1a).** A conventional LFM: a microlens array at
  the image plane of a commercial microscope (63x/1.4 NA), relayed to the sensor,
  100 um pitch, about 13 x 13 pixels per lenslet.
- **Phase-space idea (Section 2, pp. 18132-18137, delegated).** Pixels sharing the
  same position under their lenslet (the angular or spatial-frequency coordinate)
  are regrouped, so that for each such component the PSF is spatially invariant
  and much smaller (Fig. 1b-c: 6.5 and 7.2 um widths against 17.8 um for the 3D
  PSF). The imaging process is modelled in this phase-space domain; the realigned
  low-resolution data are upsampled with a smoothness prior and reconstructed by
  sequential Richardson-Lucy updates over spatial-frequency components.
- **Results (pp. 18138-18143, delegated).** Abstract: contrast enhancement,
  fewer artifacts and 10-times less computational cost without hardware
  modification. Simulation: about 11 times faster to reach a given SNR; worm data
  with 188.3 min per frame for 3D deconvolution (20 iterations) against 14.6 min
  for two phase-space iterations; one CPU in MATLAB.
- **Limits (delegated).** It cannot raise the intrinsic native-plane sampling limit;
  mild halo artifacts remain; the smoothness prior assumes semi-transparent samples
  without occlusion; no aberration or scattering inversion is claimed.

## Relevance to the thesis (gap IDs G14, G19)

- A second family of LFM reconstruction: a representation change (shift-invariant
  per-angle PSFs plus a smoothness prior) that speeds Richardson-Lucy
  deconvolution, beyond Broxton's position-dependent PSF model.
- Primary-source support for the statements that image-plane LFM deconvolution
  uses a non-uniform PSF with high computational cost and shows artifacts near the
  native object plane (p. 18131-18132).
- The paper treats image-plane LFM only; it says nothing about Fourier layouts.
  A conceptual link to FLFM (views with shift-invariant PSFs) is the note's
  inference, not the paper's statement.

## Safe Wording

Lu et al. model light-field imaging in a phase-space domain in which, for each
angular component, the PSF is spatially uniform and much smaller than the full 3D
PSF, and reconstruct by an Richardson-Lucy-type deconvolution with a smoothness
prior [Lu 2019, Section 2]. Do not attribute aberration correction to it.
