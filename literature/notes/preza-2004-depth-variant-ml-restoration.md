# Preza 2004 - Depth-variant maximum-likelihood restoration for 3D fluorescence microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

C. Preza and J.-A. Conchello, "Depth-variant maximum-likelihood restoration for three-dimensional fluorescence microscopy", Journal of the Optical Society of America A 21(9), 1593-1601 (September 2004). Received 27 October 2003; revised 20 April 2004; accepted 28 April 2004 (as printed). No DOI is printed on the extracted text. The printed header gives Vol. 21, No. 9, pp. 1593-1601, which matches the assignment metadata.

## What was read

C4b_28.txt, all 9 pages (1593-1601), including the abstract, introduction, Sections 2-6, and the reference list. Figures were not inspected as images (captions and text only). The two-column layout interleaves in the text file; equations are garbled but the prose was read in full.

## Why This Matters

A primary source that the point spread function of a high-NA fluorescence microscope changes with imaging depth because of spherical aberration from refractive-index mismatch, so shift-invariant (convolutional) models and restoration algorithms are not valid there. It supports the "aberrations come from the sample environment and degrade high-NA imaging" claim and the shift-invariance caveat for computational methods, and it also says what a depth-variant computational model costs.

## Key Claims (paraphrased)

- **Common assumptions (p. 1593).** Almost all computational optical sectioning algorithms assume linearity and space invariance; with both, the forward model is a 3D convolution computable by fast Fourier transform. Space invariance is reasonable when the PSF does not change much over the field of view. [anchor: "logical specimens, however, space invariance does not"]
- **Why it fails for thick specimens (p. 1593).** Invariance does not necessarily hold in thick biological specimens, because of refraction from refractive-index variations in the specimen and because of aberrations that grow with imaging depth. Objectives are aberration-free only for a plane just beneath the cover slip; focusing deeper introduces spherical aberration. [anchor: "Microscope objectives are designed to be free of"] [anchor: "variations in the specimen's refractive index"]
- **What drives the aberration (p. 1593-1594).** The spherical aberration increases with (1) focus depth under the cover slip, (2) the mismatch between the mounting-medium refractive index and those of the immersion medium and cover slip, and (3) the numerical aperture. For aqueous specimens (n about 1.33) imaged with the high-NA objectives needed for resolution (the NA threshold symbol is garbled in the extraction) and immersion oil (n about 1.515), the mismatch is large and the aberration changes strongly with depth. [anchor: "amount of SA introduced increases with three factors:"] [anchor: "cover slip not only introduces a significant amount of SA"]
- **Consequence for shift-invariant restoration (p. 1594).** When the mismatch is large, the forward model can no longer be approximated by a convolution, and estimating the specimen under a space-invariant assumption produces artifactual estimates. [anchor: "forward model can no longer be approximated by a convo-"] [anchor: "suming space invariance produces artifactual estimated"]
- **Cost of the exact depth-varying model (p. 1594).** The space-varying forward model has very high computational complexity in CPU time and memory; a different 3D PSF is needed for each image plane (a four-dimensional PSF array). [anchor: "age formation results in a forward model with a very high"] [anchor: "computational complexity in terms of CPU time and"]
- **Hardware correction mentioned (p. 1593).** The authors note that methods now exist to compensate depth-induced spherical aberration dynamically as the focus changes, using deformable mirrors, and describe them as still under development. These corrections change with focus depth; the paper does not discuss lateral (in-plane) variation of the correction. [anchor: "These methods are based on the use of de-"] [anchor: "such methods are still under development."]
- **What the model includes and excludes (pp. 1593-1594).** The PSF is modelled as varying only with the depth under the cover slip at which the microscope is focused. The model leaves out light scattering and assumes refractive-index variations within the specimen are negligible. [anchor: "The imaging model we derived does not include the effects"]
- **Method (pp. 1594-1595).** A stratum-based approximation: the object space is split into M axial strata, each associated with the interpolation of two spatially invariant PSFs computed at the stratum boundaries. A maximum-likelihood image estimator under Poisson statistics (expectation-maximization, called DV-EM) is derived from it. The forward model needs 2M 3D convolutions; the DV-EM update needs M+1. The number of strata sets the trade-off between accuracy and computation. [anchor: "which requires the computation of 2M 3D convolutions."] [anchor: "Thus the number of strata regulates the trade-off be-"]
- **Model check against a measured bead (p. 1598).** A measured image of a 4 um fluorescent bead (60x NA 1.4 oil objective, mounting medium n = 1.4) is compared with the model prediction; the model reproduces the main feature, the asymmetry along the optical axis caused by spherical aberration. On p. 1600 the authors add that the recorded image was broader along z than the simulated one and say more evaluation is needed. [anchor: "the asymmetry along the optical axis"] [anchor: "The recorded image was found to be broader"]
- **Restoration comparison (pp. 1598-1599).** On synthetic test objects (annulus, two disks), the depth-variant algorithm gives results close to the truth, while the space-invariant EM algorithm gives very artifactual estimates and its I-divergence from the truth starts increasing after about 90 iterations. [anchor: "tion algorithm, the algorithm produces a very artifactual"] [anchor: "deviates from the actual specimen function as is evi-"]
- **Caveats the authors state (p. 1600).** The synthetic data were generated with the stratum model itself, which inherently favours DV-EM. The algorithm assumes the PSF is known at several depths, and determining the exact PSF in practice is an open question; blind estimation is named as a future combination. Applying DV-EM to measured data is deferred. [anchor: "perimental setup is inherently favoring the DV-EM"] [anchor: "an open question that needs to be addressed"] [anchor: "plying the DV-EM algorithm to measured data."]
- **Bottom line (p. 1600).** Existing computational optical sectioning restoration algorithms derived from a space-invariant model cannot fully compensate for the degradation by depth-induced spherical aberration. [anchor: "invariant imaging model, cannot fully compensate for the"]

## Relevance to the thesis

- Supports: G24 (refractive-index mismatch between immersion medium and mounting medium produces depth-dependent spherical aberration that grows with depth, mismatch and NA, so degrades high-NA imaging; p. 1593 and p. 1594; sample refractive-index variations also named as a source, p. 1593). G25 (computational restoration needs a PSF model and is expensive when the PSF is allowed to vary: p. 1594; the PSF must be known at several depths and its determination is open: p. 1600; shift-invariant restoration yields artifacts: p. 1594, p. 1598). G27, shift-invariance part only (standard shift-invariant PSF assumption fails with depth-induced aberration: p. 1593-1594). G27 deformable-mirror part only as a pointer: deformable-mirror correction of depth-induced aberration is described as still under development in 2004 (p. 1593).
- Does not support: that deformable mirrors are expensive or complex (not stated; only "still under development"); that hardware corrections are spatially invariant (not stated; the deformable-mirror methods it mentions adapt per focus depth); G26 (no wavefront sensing or Shack-Hartmann discussion); G30 (depth is a model parameter here, not a measured quantity; no defocus-based aberration measurement); lateral (x-y) shift variance (the model varies only axially); that the numbers or the algorithm work on real restoration data (restoration was tested on synthetic data only); anything about noise amplification.

## Differences to state if cited

- Aberration of interest is spherical aberration from refractive-index mismatch that varies with focal depth in 3D wide-field and confocal sectioning; the thesis deals with sample- and optics-induced aberrations in a 2D scene and FLFM views.
- The shift-variance is axial (one PSF per depth), not a spatially varying lateral shift between views.
- The paper is from 2004; its statement about deformable mirrors being under development reflects that date.
- The restoration evidence is simulated data generated with the same model used for the algorithm.

## Still unread

- Figures as images (Figs. 1-10); the cited earlier works (refs 19-25 on computational adaptive optics and deformable mirrors) were not read.

## Safe Wording

In thick specimens imaged with high-NA objectives, refractive-index mismatch between the immersion and mounting media introduces spherical aberration that grows with focal depth, so the point spread function is no longer shift invariant and restoration that assumes a single PSF yields artifactual estimates (Preza and Conchello, 2004, pp. 1593-1594).
