# Sage 2017 - DeconvolutionLab2: open-source software for deconvolution microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

D. Sage, L. Donati, F. Soulez, D. Fortun, G. Schmit, A. Seitz, R. Guiet, C. Vonesch, M. Unser, "DeconvolutionLab2: An open-source software for deconvolution microscopy", Methods 115 (2017) 28-41. DOI 10.1016/j.ymeth.2016.12.015 (printed on the paper). Received 7 Sep 2016, available online 3 Jan 2017. No discrepancy with the assignment metadata (an issue number is not printed on the paper).

## What was read

File C4b_30.txt (printed pp. 28-41), main text read in full: Introduction, Sections 2-6, Appendix A. Table 2 (printed p. 36) was checked against the PDF page image because the text extraction scrambled its rows. Not read: the reference list (pp. 40-41) and the Java code snippet in Appendix A.2; figure images (Figs. 1-7) were not inspected except Figs. 4-5 and Table 2 on PDF pages 8-9; Table 3 numbers were taken from the text extraction only.

## Why This Matters

This is a software and methods description of eight standard 3D deconvolution algorithms for widefield data, with an explicit statement of what they need (a known PSF, a shift-invariant model, parameter tuning) and what goes wrong (noise amplification, ringing, ghosts, long run time). It is a usable primary source for the generic cost, noise and artifact side of G25, with measured run times in Table 2.

## Key Claims (paraphrased)

- **Artifacts without tuning (p. 29, Introduction).** Without proper parameter tuning, the deconvolved volume can be corrupted by artifacts; the main ones named are noise amplification, ringing and aliasing. [anchor: "the most notable ones are noise amplification"]
- **Noise is also said to be mitigated (p. 29).** The same introduction lists contrast enhancement and noise reduction among the indirect benefits of deconvolution, so noise amplification is presented as a tuning problem, not as inherent. [anchor: "As it mitigates the effect of"]
- **Cost in practice (p. 29).** A 512 x 512 x 64 volume can be deconvolved on a consumer 8 GB computer in about a couple of minutes at most; commercial packages are quoted at USD 5000 to 10,000. [anchor: "less than a couple minutes"] [anchor: "USD 5000 and USD 10,000"]
- **Heavy computation (p. 31, Section 2.2.1).** Deconvolution is described as heavy in running time and memory; the FFTs inside the iterations can take more than nine tenths of the runtime. [anchor: "Deconvolution is a heavy computational task in terms of"] [anchor: "which can consume more than nine tenth of the runtime"]
- **Measured time, iterative versus direct (p. 36, Table 2).** On a synthetic 16-million-voxel volume (single Mac Xeon workstation), the direct filters NIF, RIF and TR take 6-8 s, whereas Landweber, FISTA, Tikhonov-Miller, Richardson-Lucy and RL-TV take 1400-2759 s (RL: 1661 s, SNR 3.66 dB). The text (p. 34, Section 5.1) says the benefit of iterative methods comes with higher computational needs. [anchor: "the cost of doing so"]
- **Noise amplification of the basic methods (pp. 32-33, Sections 3.2, 3.5, 3.8).** Naive inverse filtering amplifies noise and gives spurious oscillations; maximum-likelihood iterations (Landweber, Richardson-Lucy) overfit noise at convergence, so the iteration count must be set heuristically to stop early. [anchor: "NIF tends to amplify measurement noise, resulting in spurious"] [anchor: "same noise-amplification problem as NIF and LW"] [anchor: "should be heuristically set to stop"]
- **Parameter sensitivity (pp. 35, Fig. 4 caption and Section 5.2).** The optimal parameters per algorithm were set by visual assessment; too many Landweber iterations produce high-frequency artifacts near the bead, too little regularization gives ringing. [anchor: "algorithm was performed through visual assessment"] [anchor: "using a too large number of iterations leads to high frequency"]
- **Fourier-related artifacts (pp. 33-34, Section 4.3.1).** FFT-based implementations cause ghosts (periodic wrap-around) and ringing; countermeasures (apodization, zero-padding) either reduce intensity or cost more compute. [anchor: "ghosts and ringing"]
- **PSF requirement (p. 33, Section 4.2).** The quality of deconvolution depends on the accuracy of the 3D PSF, which can be measured from bead stacks or computed from a model. Microscopists are said to agree that an experimental PSF captures the aberrations of the microscope. [anchor: "The quality of the deconvolution relies on the accuracy of the"] [anchor: "generally agree that the experimental PSF captures well the"]
- **Known PSF and shift invariance are assumptions (pp. 31, 39).** The image model assumes a shift-invariant PSF; the main body of the paper assumes the PSF is known, and the last section treats blind and space-varying cases separately. [anchor: "Fluorescence microscopes are often assumed to be shift-"] [anchor: "Up to now in this paper, we have assumed that the PSF was"]
- **Blind deconvolution (p. 39, Section 6.1).** Estimating object and PSF jointly is described as strongly ill-posed and nonlinear, with scale degeneracy; current blind methods alternate between deconvolution and PSF estimation. [anchor: "Blind deconvolution attempts to jointly estimate the object"]
- **Space-varying PSF and spherical aberration (p. 39, Section 6.2).** In practice the PSF varies across the field; a depth-varying PSF arises from refractive-index mismatch, giving spherical aberration that grows with depth. Space-varying deconvolution is no longer a convolution, cannot use FFTs, and its cost rises roughly with the square of the voxel count; PSF variation must be inferred from the data except in the index-mismatch case. [anchor: "a depth-varying PSF is often induced by a refractive index"] [anchor: "the PSF suffers of spherical aberrations that get stronger"] [anchor: "The computational cost of space-varying deconvolution tends to"] [anchor: "one has to infer the PSFs"]

## Relevance to the thesis

- Supports: G25 (software solutions need a PSF and deconvolution; iterative variants are costly in run time and memory; noise amplification, ringing and ghost artifacts occur when parameters are poorly chosen; blind and space-varying versions are harder). G24 only weakly: index mismatch causes depth-dependent spherical aberration (p. 39) and an experimental PSF embeds the microscope aberrations (p. 33).
- Does not support: "deconvolution is slow" as a blanket statement (the paper says practical volumes run in minutes); "deconvolution inherently amplifies noise" (it lists noise reduction as a benefit and treats amplification as a parameter issue); anything about adaptive optics, wavefront sensing or light-field microscopy.

## Differences to state if cited

- Scope is 3D widefield deconvolution with standard algorithms and a known (measured or theoretical) PSF; the thesis works on 2D scenes imaged with FLFM.
- Timings are for one volume size and one workstation; the direct methods are fast (seconds), only the iterative ones are slow.
- Table 2 was read from the PDF image. The quality ranking in Table 2 depends on visually tuned parameters and the specific synthetic data; the authors themselves warn against using it as a performance ranking (p. 35).
- The paper does not discuss aberration correction as a goal; aberrations appear only as a source of PSF variation.

## Still unread

- Reference list and Java snippet (Appendix A.2); Figs. 1-3, 6-7 as images; supplementary online data.

## Safe Wording

Deconvolution depends on an accurate PSF and, in its iterative forms, is computationally demanding; poorly tuned parameters lead to noise amplification, ringing and ghost artifacts (Sage et al., 2017, pp. 29, 33-36).
