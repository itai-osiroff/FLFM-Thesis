# Levin 2009 - Understanding and evaluating blind deconvolution algorithms

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

A. Levin, Y. Weiss, F. Durand, W. T. Freeman, "Understanding and evaluating blind deconvolution algorithms", Proc. IEEE Conference on Computer Vision and Pattern Recognition (CVPR) 2009, pp. 1964-1971. Printed copyright line: 978-1-4244-3991-1/09/$25.00 (c) 2009 IEEE. No DOI is printed on the pages. The conference name does not appear in the extracted text (the reference list cites the technical report MIT-CSAIL-TR-2009-014); "CVPR 2009" and the page range come from the assignment metadata and the printed page numbers 1964-1971.

## What was read

File C4b_25.txt (8 pages, printed pp. 1964-1971), read in full including the discussion and reference list. Equations were read in the extracted text; the proofs and the technical report [13] (extra examples) were not available. Figures were not inspected as images.

## Why This Matters

This is a computer-vision paper on camera motion blur, not microscopy. It supplies two general findings about blind deconvolution: the simple formulation of jointly estimating image and blur kernel by MAP fails in a specific, explained way, and the usual shift-invariant blur assumption is often violated in real data. It can serve as a fallback for the general difficulty of blind deconvolution (G25), not for microscopy.

## Key Claims (paraphrased)

- **Blind deconvolution is ill-posed (p. 1964).** For a blurred image there is an infinite set of (sharp image, kernel) pairs that explain it, among them the trivial no-blur pair (delta kernel, image equal to the input), so extra assumptions are needed. [anchor: "is an infinite set of pairs"]
- **Naive joint MAP fails (pp. 1964-1966).** Maximizing the posterior over the image and the kernel together mostly favors the no-blur explanation, even with a sparse-gradient prior. The proof of Claim 1 is a scaling argument (shrinking the image and enlarging the kernel keeps the data term and improves the prior), and blurring natural images makes their gradient statistics more probable under the sparse prior; in an experiment on blurred real image windows (Gaussian blur) the blurred version was preferred in over 97 percent of 15 x 15 windows. [anchor: "favorable solution under a sparse prior is usually a blurry"] [anchor: "approach is the no-blur explanation"] [anchor: "Claim 1 Let x be an arbitrarily large image sampled from"]
- **What works instead (pp. 1964, 1966-1967).** Estimating the kernel alone while marginalizing over the image succeeds because the kernel has few unknowns relative to the image; the authors argue the choice of estimator matters more than the prior, and a weak Gaussian prior can work with the right estimator. [anchor: "the strong asymmetry"] [anchor: "not the choice of prior, but the thought-"] [anchor: "since the kernel size is often smaller than the image"]
- **Practical caveat (pp. 1969-1970).** Optimization errors have a large effect on the success of practical algorithms, and the marginalization is computationally more challenging, though existing approximations are said to be powerful. [anchor: "optimization errors do have"] [anchor: "marginalization are more challenging"]
- **Comparison result (pp. 1964, 1970).** On a new ground-truth set (4 images, 8 kernels, 32 test images, kernel support 10 to 25 pixels, 255 x 255 windows) the variational Bayes method of Fergus et al. outperformed the other tested algorithms; the naive joint MAP returned near-delta kernels. [anchor: "the variational Bayes approach of [4] outperforms"]
- **Shift invariance is often violated (pp. 1964, 1969, 1971).** Even for a planar scene, hand-held blur varied between image corners (in-plane rotation), so a spatially uniform blur is unrealistic and models relaxing it are said to be promising. [anchor: "the shift-invariant blur"] [anchor: "assuming a uniform blur over the"] [anchor: "popular spatially uniform blur assumption"]
- **Richardson-Lucy artifacts (p. 1970).** In the evaluation, the authors replaced the Richardson-Lucy non-blind step used by one method with a sparse deconvolution because Richardson-Lucy is a source of ringing artifacts. [anchor: "Since this algorithm is a source"]

## Relevance to the thesis

- Supports: G25 only as general background, namely that blind estimation of the blur together with the image is intrinsically ill-posed, that the simplest joint formulation fails, and that success depends on careful estimators plus assumptions such as a small kernel; also that a spatially invariant blur model can be wrong.
- Does not support: any statement about fluorescence microscopy, PSF estimation cost in microscopy, run time, noise amplification (noise is only modeled as i.i.d. Gaussian), adaptive optics, or aberrations. The sentence about Richardson-Lucy ringing is a single side remark in a motion-blur experiment.

## Differences to state if cited

- Domain: single-image camera shake with a 2D kernel, assuming a fixed small kernel and a sparse natural-image prior; the thesis domain is a microscope PSF, with the sample, depth and optics causing aberrations.
- Their positive result requires the kernel to have far fewer degrees of freedom than the image; a spatially varying or high-dimensional aberration PSF does not satisfy that in the same way (this inference is ours, not stated in the paper).
- The best method is a variational Bayes approach from 2006; the paper's ranking reflects 2009 algorithms.

## Still unread

- Technical report [13] (details, more images); figures were not inspected as images.

## Safe Wording

Blind deconvolution, which estimates the blur and the sharp image from a single observation, is severely ill-posed, and straightforward joint maximum-a-posteriori estimation tends to return the unblurred input as its solution (Levin et al., 2009, pp. 1964-1966).
