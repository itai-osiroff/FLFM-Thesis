# Richardson 1972 - Bayesian-based iterative image restoration

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

W. H. Richardson, "Bayesian-Based Iterative Method of Image Restoration", Journal of the Optical Society of America 62(1), 55-59, January 1972 (received 15 September 1970). Author affiliation: Visibility Laboratory, University of California San Diego. No DOI is printed on the paper. No discrepancy with the metadata in the assignment (JOSA 62(1), 55-59, 1972).

## What was read

File C4b_29.txt, the whole paper (PDF pp. 1-5, printed pp. 55-59), including the conclusions and the reference list. Equations (1)-(10) and the figure captions were read from the text layer. Several equations and Figs. 1-7 are garbled in the extraction, so the equation forms below are described from the surrounding text and the final printed forms (Eqs. 5-7) only in outline; the images in Figs. 3-7 were not inspected.

## Why This Matters

This is the origin citation for the iterative restoration scheme that later became known as Richardson-Lucy (RL) deconvolution. For the thesis it can anchor the statement that iterative deconvolution needs the point spread function (PSF) as an input. It says nothing about microscopy, Poisson noise, or blind estimation of the PSF.

## Key Claims (paraphrased)

- **Problem and model (p. 55, Assumptions).** The degraded image H is modelled as the convolution of the original image W with a point spread function S, all treated as discrete arrays of non-negative "probability-frequency" values that need not be normalised. [anchor: "the form H=W*S, where W is the original image, S is"]
- **The PSF is an input, not an unknown (p. 55, Discussion).** The task is posed as finding W from a known degraded image H and a known PSF S. The paper contains no treatment of an unknown PSF. [anchor: "Given the degraded image H, the point spread func-"]
- **The method (p. 55, Eqs. 1-7).** Bayes's theorem is applied to the conditional probability that an event at an original location i caused a count at degraded location k. The unknown prior P(W_i) is replaced by an estimate of it, which turns Bayes's theorem into an iteration (Eq. 4, and in array form Eqs. 5-7). [anchor: "use an estimate of the P(Wi) function to"]
- **Update form (p. 56, Eq. 6).** The paper describes the summation over k in the update as a corrective factor applied to the current estimate; in the usual reading this factor is built from the ratio of the degraded image to the re-blurred estimate, summed against the PSF (the equations are partly garbled in the text layer). [anchor: "summation over k is a corrective factor on"]
- **Start value and conservation (p. 55).** The first estimate may be uniform (Bayes's postulate), and the restoration is described as a conservative process, so the total intensities of the restored and degraded images are equal. [anchor: "since the restoration is a conservative process"]
- **Claim about noise (abstract, p. 55; Fig. 4, p. 57).** The abstract states the method works effectively in the presence of noise. The introduction says Fourier-transform methods fail to give recognisable images at high noise levels. [anchor: "method functions effectively in the presence of noise"]
- **Noise tested (p. 57, Eq. 10).** The only noise tested is multiplicative noise added after degradation, with a normal random deviate and fraction r = 0.1 (Fig. 4), plus single-pixel disturbances (Figs. 6-7, p. 58). Poisson or photon noise is not mentioned anywhere in the paper. [anchor: "multiplicative noise added after degradation. The"; also "r is the fraction of added noise, and d is the random"]
- **Behaviour with noise (p. 57).** Without noise the procedure tends toward a perfect restoration; with noise the restoration continues to improve over the 10, 20 and 30 iterations shown. The paper does not report noise growing with iteration number and gives no stopping rule. [anchor: "toward a perfect restoration, whereas with noise the"]
- **Comparison with Fourier restoration (p. 57 text, Fig. 5 on p. 58).** A Fourier least-squares filter with estimated parameters leaves background noise in the restoration that the iterative restorations do not show; the paper adds that this could be a detriment in more complex images. [anchor: "The presence of background noise in"]
- **Convergence (p. 58, Conclusions).** No proof of convergence is given. The process converged in every case where it was used, and the author calls it plausible because it is self-correcting. The text also notes that individual values can initially move in the wrong direction. [anchor: "Although no proof of convergence on a solution has"]
- **Edge artefact (p. 58).** When only part of an image is processed, energy from outside the region contaminates the edges and produces a bright border, almost entirely in the outer one or two rows; the author suggests discarding those rows or tapering the edges. [anchor: "bright edge around the restoration, almost entirely"]
- **Cost (p. 58).** The restorations of Figs. 3 and 4 averaged 7.4 s per iteration on a CDC 3600; the conclusion says the method gives intelligible results in some cases where the Fourier process cannot, at higher cost. [anchor: "although at higher cost than the Fourier process."]
- **Self-description (p. 58).** The author calls the process an iterative deconvolution approximation. [anchor: "process may be considered an iterative deconvolution"]

## Relevance to the thesis

- Supports: G25, weakly and only for the premise that classical deconvolution needs a PSF as input. It is a suitable origin reference for the iterative update that RL-type methods use, to be cited together with Lucy 1974 (see below). It can also support the narrow statement that iterative restoration was introduced to cope with noise where Fourier inversion failed.
- Does not support: any claim that deconvolution is costly, slow, artifact-prone or amplifies noise in modern microscopy. The paper claims the reverse for noise relative to Fourier filtering, and its cost statement refers to a 1970s mainframe. It does not support anything about PSF estimation, blind deconvolution, fluorescence microscopy, Poisson statistics or maximum likelihood. It does not mention Lucy or the name "Richardson-Lucy".
- Appropriateness for "Richardson-Lucy": Cite Richardson 1972 as the origin of the Bayesian iteration, but not alone for the name "Richardson-Lucy". The algorithm is credited to two independent papers, and Lucy 1974 (not available to us) is the other. Kenig 2010 cites both ([41] Lucy, [53] Richardson) for "the Richardson-Lucy (RL) algorithm" and Holmes 1992 lists both as refs 23 and 24, so citing the pair is the convention in the papers we hold. The Poisson/maximum-likelihood reading of the update does not come from this paper; Kenig 2010 footnote 1 (p. 2193) says MLEM and RL derive from different assumptions but give the same iteration.

## Differences to state if cited

- The thesis method is not deconvolution and does not model a PSF; Richardson's method needs S as input.
- Richardson treats images as probability-frequency functions with no photon-noise model; fluorescence deconvolution papers (Holmes, Kenig) add a Poisson model.
- Evidence about noise is a single multiplicative-noise example on synthetic targets (r = 0.1), not microscopy data.

## Still unread

- Images in Figs. 1-7 were not inspected, and the equations in the extracted text are partly garbled. Equation numbers and the description of Eqs. 4-7 above follow the text around them; check against the PDF before quoting any equation.
- Lucy 1974 is not in the set and was not read.

## Safe Wording

Richardson introduced an iterative Bayesian image-restoration scheme in which the point spread function is assumed known and the estimate is updated by a multiplicative correction factor (Richardson 1972, p. 55); it is usually cited together with Lucy (1974) as Richardson-Lucy deconvolution.
