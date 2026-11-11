# Kenig 2010 - Blind deconvolution with a learned PSF prior for 3D microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Tal Kenig, Zvi Kam, and Arie Feuer, "Blind Image Deconvolution Using Machine Learning for Three-Dimensional Microscopy", IEEE Transactions on Pattern Analysis and Machine Intelligence 32(12), 2191-2204, December 2010. DOI printed on the paper: 10.1109/TPAMI.2010.45 (manuscript received 7 May 2009, accepted 3 November 2009). No discrepancy with the metadata in the assignment.

## What was read

File C4b_17.txt, PDF pp. 1-14 (printed pp. 2191-2204): abstract, Sections 1-8, footnotes and the start of the reference list. The two-column layout interleaves in places (equations 7 and 21 in particular are garbled), so equation content was taken from the surrounding prose. Figures 1-9 were not inspected as images; their captions were read. The reference list beyond what is quoted below was not read, and no supplement exists in the file.

## Why This Matters

This is the most relevant fluorescence-microscopy paper in this group for the thesis claim about software solutions. It states why blind deconvolution is ill-posed, why microscopy PSFs cannot be known in advance because the sample itself changes them, and it reports run time and the failure modes of iterative blind schemes. It is a software, PSF-estimation approach to a depth (spherical) aberration, which is the contrast case to the thesis's view-alignment method.

## Key Claims (paraphrased)

- **What is estimated (p. 2191, Eq. 1).** The acquired image is modelled as the imaged object convolved with the PSF and corrupted by noise; blind deconvolution estimates the object and the PSF from the image and any extra prior knowledge. [anchor: "deconvolution algorithms is indispensable, yielding excellent results."]
- **Noise model (p. 2191, Eq. 2).** The dominant noise is taken to be photon noise, Poisson distributed, with the noise-free pixel value as its parameter. The authors say this noise is strongly correlated with the signal, which makes it much harder to handle than additive noise. [anchor: "It can be easily observed that this type of noise is highly"]
- **Ill-posedness (p. 2191).** The problem is ill-posed in the sense that many solutions exist, including the trivial one (object equal to the image, PSF equal to a delta function), and it is underdetermined because one image is used to estimate two unknowns. [anchor: "It is not difficult to realize that problem (1) is ill-posed, in"]
- **Underdetermination (p. 2191).** [anchor: "underdetermined, i.e., there are more unknowns than inputs."]
- **Regularization is always needed (p. 2192).** Because of the ill-posedness every blind method uses some prior; regularizing the object can harm when the object has high-frequency structure, so the authors regularize the PSF instead, since the PSF is tied to the imaging system. [anchor: "Due to this ill-posedness, all BD methods use some sort of"]
- **What is learned (p. 2192, Sec. 4, pp. 2194-2197).** A space of admissible PSFs ("PSF-space") is learned from example PSFs by linear PCA or kernel PCA. During the iterations, after each update, the PSF estimate is softly pulled toward its best approximation in that space (Eq. 6, weight lambda between 0 and 1). [anchor: "We propose regularizing the PSF by attracting it to a space"]
- **Base algorithm (p. 2193, Sec. 3).** The iteration is an alternating maximum-likelihood / maximum-a-posteriori update of object and PSF with a Poisson likelihood, described as similar to Richardson-Lucy (cites Lucy 1974 and Richardson 1972); footnote 1 says the two derivations differ but give the same iteration. [anchor: "the Richardson-Lucy (RL) algorithm [41], [53]."]
- **Denoising step (p. 2194, Sec. 3.2).** To handle noise, the residual between the data and the re-blurred estimate is denoised at each iteration (3 by 3 by 3 median filter in the experiments), following an astronomical-imaging idea. [anchor: "In order to overcome the noise, we use a generalization"]
- **How the PSF is estimated (p. 2199-2200, Sec. 7.1).** Microscope parameters are assumed known and the only unknown is the sample depth d (equivalently the sample refractive index), so the learned PSF-space is in effect a one-parameter family of depth-aberrated PSFs. The training set is 201 PSFs simulated with a wide-field model, d from -4.6 to 4.6 um, rather than measured beads, because acquiring many is tedious; the authors note beads could be used. [anchor: "microscope parameters are known and the only unknown"]
- **Training data (p. 2199).** [anchor: "tedious and cumbersome task, we used simulated"]
- **Parameters (p. 2200).** Soft-projection weight 0.05 (range 0.01 to 0.1 found adequate), 10 principal components (5 to 30 performed well), kernel width set from the distances between training PSFs; initial object estimate is the acquired image and the initial PSF estimate is a symmetric support. [anchor: "The algorithm was initialized with the"]
- **Why the PSF is unknown in microscopy (p. 2198, Sec. 6.1).** In many systems the PSF follows from the instrument, but in microscopy the imaged sample itself influences the PSF, so exact a priori knowledge is unavailable. [anchor: "In microscopy, however, the imaged sample itself"]
- **Depth aberration (p. 2198, Sec. 6.3).** Refractive-index mismatch between sample and immersion oil produces a spherical aberration that depends on the imaging depth, which the paper calls depth aberration; because it depends on the sample, it is described as the root cause of the unavailability of an exact PSF. [anchor: "root cause for the inability of obtaining exact a priori"]
- **Aberration definition (p. 2198).** [anchor: "spherical aberration caused by imaging into a specific depth"]
- **Shift-invariance assumption (p. 2198, Sec. 6.2).** The paper says the wide-field degradation model is in fact shift variant, since it depends on the depth of the focal plane, but the convolutive model is a very good approximation and is assumed, with d then the average sample depth. [anchor: "the degradation model is shift variant, as it is dependent"]
- **Through-focus data (p. 2197-2198, Sec. 6.1).** The 3D image is a stack of 2D sections collected by focusing at different depths (optical sectioning); each section also contains out-of-focus light. [anchor: "This process is named optical sectioning"]
- **Cost (p. 2200, Sec. 7.1).** One iteration on a 128 by 128 by 128 volume took about 14 s on a single core of a 2.4 GHz processor and about 750 MB; typically 500-600 iterations were needed, around 2 hours in total, mostly FFT time (about 70 percent), with the PSF regularization about 20 percent. [anchor: "converged in 500-600 iterations, yielding a total processing"]
- **Run time (p. 2200).** [anchor: "iteration (requiring three convolution operations) took"]
- **Local maxima (p. 2200, Sec. 7.1, Fig. 3).** The maximum-likelihood iteration is very sensitive to local maxima; many training PSFs correspond to local optima, so a hard projection onto the PSF-space (weight 1) was not useful and a soft projection is used. [anchor: "iterative process is very sensitive to local maxima, we found"]
- **No convergence guarantee (p. 2197, Sec. 5).** The plain alternating scheme gives non-decreasing likelihood, but with the denoising and prior terms there is no guarantee of reaching even a local optimum; in practice likelihood was non-decreasing except in the first iterations for some data sets; a relative-change stopping rule is used. [anchor: "there is no guarantee that the iterative scheme we"]
- **Likelihood behaviour (p. 2197).** [anchor: "produces sequences of estimates with nondecreasing like-"]
- **Synthetic results (p. 2200-2201, Fig. 6).** For a PSF without depth aberration, PCA and KPCA regularization are close to non-blind deconvolution; for a depth-aberrated PSF both fall short of non-blind deconvolution (KPCA somewhat better than PCA). The competing method AIDA (a PSF-prior blind method) gave smooth results with worse error and failed to detect the depth aberration. [anchor: "regularization methods fall short of the nonblind deconvo-"]
- **Real data (p. 2201, Figs. 7-9).** Three wide-field fluorescence stacks (two known to have depth aberration, produced by changing the immersion medium; one with little), cropped to 256 by 256 pixels per section. The authors report more resolved detail, reconstructions that seem free of noise, estimated PSFs that are asymmetric along z when aberration is present, and PCA that seems to overestimate the depth aberration. Evaluation of real images is visual; no error metric is given for them. [anchor: "reconstructed images seem free of noise"]
- **Aberration estimation (p. 2201).** [anchor: "that the proposed algorithm succeeds in estimating the depth"]
- **Radial symmetry footnote (p. 2198, footnote 5).** The paper treats in-plane aberrations as practically fully corrected within the field for high-quality objectives, which justifies a radially symmetric PSF. [anchor: "5. This is a good assumption since in-plane aberrations are practically"]
- **Motion blur and spatially variant blur (p. 2193).** The authors say their method does not address motion blur, and that spatially variant blur and multi-image or dedicated-device approaches are outside their scope. [anchor: "outside the scope of this work."]

## Relevance to the thesis

- Supports: G25 (software solutions need PSF estimation and deconvolution): blind deconvolution estimates object and PSF jointly; it is ill-posed and needs regularization (p. 2191-2192); in microscopy the PSF depends on the sample so it cannot simply be measured in advance (p. 2198); the iteration is slow, about 2 hours for a 128-cubed volume (p. 2200); and it is prone to local maxima, lacks a convergence guarantee, and can mis-estimate depth aberration (PCA overestimation; AIDA failure) (pp. 2197, 2200, 2201). Also supports G24 in part: sample refractive-index mismatch gives a depth-dependent spherical aberration in wide-field fluorescence (p. 2198). Weak support for G30: 3D images from through-focus sections, with aberration estimated from the resulting stack (pp. 2197-2198, 2201).
- Does not support: "amplify noise" as a general statement. The paper says Poisson noise is hard to handle and adds a denoising step, and the reported results are described as low-noise, but it never states that deconvolution amplifies noise. It does not support claims about hardware solutions, wavefront sensing, adaptive optics, deformable mirrors or spatially varying correction. It does not describe high-NA imaging specifically, and its aberration is a depth-dependent, spatially invariant one. It is also not a statement about artifacts in general: the failure modes listed above are specific to this scheme and to AIDA on these datasets.

## Differences to state if cited

- Wide-field fluorescence, 3D stacks, spherical aberration from refractive-index mismatch; the thesis is FLFM of a 2D scene with sub-aperture views.
- The method assumes a convolutive (shift-invariant) model and radially symmetric PSF, with the sample depth as the only unknown; it does not handle spatially varying aberrations, which the paper itself says is out of scope for the related spatially variant blur work.
- It learns a PSF prior from simulated PSFs with PCA or kernel PCA; this is a learning step on PSFs, not on images, and the thesis method is not learned.
- Time and memory figures are for a 2009-era processor and one 128-cubed volume.

## Still unread

- Figures 1-9 as images (captions only), equation 21 and 17-19 details from the garbled text, and the full reference list.
- Reference [8] (Carasso 1999), cited in footnote 1 for the RL versus MLEM derivations, was not read.

## Safe Wording

Blind deconvolution in fluorescence microscopy estimates the object and the PSF from a single image, a problem the authors call ill-posed and underdetermined that requires regularization (Kenig et al. 2010, p. 2191-2192); because the sample itself alters the PSF, it cannot be known in advance (p. 2198), and their iterative scheme took about two hours for a 128-cubed volume (p. 2200).
