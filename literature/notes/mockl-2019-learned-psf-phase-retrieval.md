# Moeckl 2019 - Phase retrieval of 3D PSFs with a residual neural network

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Leonhard Moeckl (printed as "Mockl" with umlaut), Petar N. Petrov, W. E. Moerner, "Accurate phase retrieval of complex 3D point spread functions with deep residual neural networks", Applied Physics Letters 115, 251106 (2019), pp. 251106-1 to 251106-5. Submitted 21 August 2019, accepted 9 December 2019, published online 18 December 2019. DOI 10.1063/1.5125252 (printed on the paper). No discrepancy with the assignment metadata (the paper is a Research Article, Department of Chemistry, Stanford).

## What was read

C4e_29.txt, the whole file: PDF p. 1 (AIP cover page), then printed pp. 251106-1 to 251106-5 (abstract, main text, Figs. 1-3 and captions, references). Text is complete; the extraction garbled a few symbols (lambda, minus signs, the training range of the Zernike coefficients). NOT read: the supplementary material (Tables S1, S2 with the simulation and training parameters, Fig. S1 on coefficient ranges), which the paper refers to but which is not in the file. Figure contents were read only through the captions.

## Why This Matters

A deep-learning way to measure the pupil phase of a fluorescence microscope from a short through-focus stack of the PSF of a point emitter. It is an example of the defocus-based, model-based aberration measurement (a Zernike pupil model fitted to a focal stack of a known point source) that the thesis contrasts with its own single-shot, non-model-based alignment of Fourier light-field views.

## Key Claims (paraphrased)

- **Input is a five-slice focal stack of a point-source PSF (abstract, p. 251106-1; Fig. 2 caption, p. 251106-2).** Five slices of the 3D PSF, at focal positions -1, -0.5, 0, 0.5, +1 um (a 2 um range around focus), are enough to retrieve the phase. The stack enters the network as a 25 x 25 pixel image with five channels. [anchor: "Five slices of the 3D PSF at different focal positions"]
- **Output is Zernike coefficients (p. 251106-1, Fig. 1; p. 251106-3).** The network returns 27 coefficients, Zernike orders 1 to 6 (Noll indices 2 to 28); piston is excluded because it does not change the image. [anchor: "which returns the 27 Zernike coefficients of order"]
- **Conventional phase retrieval is slow and data hungry (p. 251106-1).** Iterative phase retrieval from images at several axial positions is described as computationally demanding and relatively slow, and as needing oversampling of the feature space. [anchor: "they are computationally demanding and, as a result, relatively slow"]
- **Training is entirely on simulated PSFs (p. 251106-1 and -2).** Point emitter at a coverslip in index-matched media, vectorial diffraction model, random Zernike coefficients, with EMCCD-type camera properties, signal and background photons and Poisson noise (excess noise of the EMCCD gain excluded). 2,000,000 training PSFs were used; 200,000 were too few and training failed. Plain convolutional nets failed; a residual net worked. [anchor: "We used 2 000 000 training PSFs."]
- **Training cost and speed (p. 251106-3).** About 12 h and 77 epochs on a desktop with a Titan GPU; inference about 5 ms per PSF on a CPU-only desktop (100 000 validation PSFs in about eight minutes). Retraining is said to be unnecessary unless basic experimental parameters (NA, magnification, major realignment) change. [anchor: "retraining is not necessary unless fundamental parameters"]
- **Accuracy on simulated validation data (p. 251106-3, Fig. 3).** On 100 000 blind validation PSFs the error in the coefficients is unbiased with a standard deviation of about 0.24 (in wavelength units, all 27 coefficients pooled). The pixelwise MSE between input and retrieved PSFs is low, and a large part of it is attributed to the Poisson noise in the input. The paper calls the predictions close to, but not exactly, the ground truth. [anchor: "standard deviation of approximately 0.24"]
- **Engineered PSF test (p. 251106-3).** The 6 um-range Tetrapod PSF (a real 3D-localisation PSF) was retrieved well from noise-free input; some coefficients were predicted correctly well outside the training range. [anchor: "the Tetra6 PSF is well retrieved"]
- **Intended uses beyond the paper (p. 251106-3).** The fast network could initialise conventional phase retrieval if further refinement is wanted, and could help with phase aberrations that vary across the field of view (only mentioned as a possibility, citing other work). [anchor: "be advantageous to initialize parameters if further"]
- **Limits stated or implied.** Validated only on simulations; the Tetrapod case is also simulated (the paper says "realistic simulations"). Fixed to one parameter set (high-NA, index-matched, emitter at the coverslip); index mismatch "straightforward to include" but not done. Non-Zernike phase is listed as future work. Orders above 6 and experimental data are not tested. [anchor: "PR of non-Zernike-like phase information"]

## Relevance to the thesis

- Supports: G30 (a stack of through-focus images of a point source used to recover the pupil phase, here by a neural network instead of iterative phase retrieval; the introduction also says a set of images of a known point source at several axial positions has been used with iterative algorithms to estimate the pupil phase). G25 only indirectly: states that conventional iterative phase retrieval is computationally demanding and slow (not about PSF estimation plus deconvolution as such).
- Does not support: any statement about deconvolution, noise amplification, cost of deformable mirrors, or spatial invariance. Not about light-field or multi-view imaging, and not about extended or 2D fluorescent scenes: the object is a single point emitter. No experimental validation, so it must not be cited as demonstrating aberration measurement on real samples. Fluorescence enters only as the emission of a single molecule (stated in the intro, not as a measured result).

## Differences to state if cited

- It is learned and model-based (Zernike pupil, trained on simulated PSFs); the thesis method is neither.
- It needs a known point source and a deliberate focal scan (five acquisitions at different focal positions); the thesis method is single-shot on an extended 2D scene.
- It returns a global pupil phase for the PSF, not a spatially varying correction; field-dependent aberrations are only named as a future use.

## Still unread

- Supplementary material (simulation parameters, Table S1; training parameters, Table S2; coefficient range study, Fig. S1).
- The meaning of the Zernike coefficient range symbol and of the unit "k" in the text was garbled in extraction; do not quote the training range without checking the PDF.

## Safe Wording

Moeckl et al. trained a deep residual network on simulated point-source PSFs so that a stack of five focal slices spanning 2 um returns the first six orders of Zernike coefficients of the pupil phase in milliseconds (Appl. Phys. Lett. 115, 251106, 2019, abstract and p. 251106-3); the work is validated only in simulation.

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use only for learned pupil recovery. The estimates depend on the training distribution and chosen basis. The AIP cover confirms article 251106.
