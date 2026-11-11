# Paxman 1992 - Joint estimation of object and aberrations by phase diversity

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

R. G. Paxman, T. J. Schulz, J. R. Fienup, "Joint estimation of object and aberrations by using phase diversity", J. Opt. Soc. Am. A 9(7), 1072-1085, July 1992 (received 30 Sep 1991, accepted 7 Jan 1992). No DOI is printed on the paper. Metadata in the assignment matches the printed header and page range (14 pages).

## What was read

File C4e_33.txt (1186 lines, pdftotext of the whole paper, printed pp. 1072-1085, title page present). Read in full: abstract, Sec. 1-5, Appendices A-E, reference list. The derivations in Appendices A-E were read for scope only, not re-derived. Several equations are garbled in the text extraction (noted where it matters); no PDF pages were opened. The paper contains no figures of results (only Fig. 1 layout and Fig. 2 sketch).

## Why This Matters

It is the primary source for phase diversity: estimating unknown aberrations of an incoherent imaging system from the object itself, using a second image taken with a known added aberration (for example defocus). It is a model-based, multi-image method from astronomy and general optics, so it is a natural contrast to a single-shot method that does not model the pupil.

## Key Claims (paraphrased)

- **Setting and aim (p. 1072, abstract and Sec. 1).** The paper studies joint maximum-likelihood estimation of an object and of the aberrations of an incoherent imaging system from several images that carry phase diversity. The theory is derived under Gaussian and Poisson noise. [anchor: "estimation of an object and the aberrations of an incoherent"]
- **Idea of phase diversity (p. 1072, Sec. 1).** Two or more images of the same object are collected. One is the ordinary image degraded by unknown aberrations. The others are formed by perturbing the aberrations in a known way, for example by translating the detector along the optical axis to add a known defocus. The goal is an object and aberration combination consistent with all images, given the known diversities. [anchor: "given the known phase diversities."]
- **Contrast with direct sensing (p. 1072).** Aberrations can be measured directly, for example with a Hartmann-Shack sensor, but such techniques need considerable extra optical hardware. Phase retrieval from point-source images is another route, but a point object is often unavailable. [anchor: "Hartmann-Shack wave-front sensor is often used for"]
- **Stated advantages (p. 1072).** Modest hardware (a beam splitter and a second detector array could collect both images at once, Fig. 1, p. 1073), the object serves as the reference, it works for extended objects, and every photon is used for both imaging and aberration estimation. [anchor: "The technique also works well for"]
- **Image model (p. 1073, Sec. 2).** Imaging is assumed space-invariant and incoherent: each diversity image is the object cyclically convolved with a PSF, discretized on an N x N periodic grid. The PSF is the squared modulus of the coherent impulse response obtained from a generalized pupil function. [anchor: "Frequently, space-invariant incoherent imagery is formed"]
- **Diversity enters the pupil (p. 1073, Eqs. 4-5).** The k-th generalized pupil carries the unknown phase plus a known diversity phase. The unknown phase is parameterized by a basis, for example discretized Zernike polynomials for a monolithic aperture, or by point-by-point values. The binary pupil masks are taken as known. [anchor: "known phase function asso-"]
- **Gaussian case (pp. 1073-1076, Sec. 3, Eqs. 14-22).** For fixed aberrations the best object has a closed form in the Fourier domain, so it can be eliminated. This gives an aberration-only objective, a generalization from two to K images of an objective due to Gonsalves, with an analytic gradient. [anchor: "An aberration-only objective function,"]
- **Optimization difficulty (p. 1076).** In simulations with added Gaussian noise the objective has a rough texture with many local maxima, so naive gradient search gets trapped. Suggested remedies are simulated annealing or regularization, tried only preliminarily. [anchor: "takes on a rough texture containing many"]
- **Poisson case (pp. 1076-1079, Sec. 4).** No aberration-only objective was found. The paper gives the log-likelihood, its gradient, and an expectation-maximization algorithm that enforces nonnegativity naturally. With known aberrations and K=1 the EM rule reduces to Richardson-Lucy. [anchor: "with the Gaussian noise case failed."]
- **Point-object caution (p. 1078).** Assuming a point object when the object is not (for example a binary star) can bias the aberration estimates. [anchor: "Care must be used when invoking the point-"]
- **What is demonstrated (p. 1079, Sec. 5).** This paper presents no experiments or simulations of its own. It states that viability was shown earlier by simulation for Gaussian noise with K=2, that the Poisson-case algorithms still have to be exercised, and that more simulations and theory are needed on the number and type of diversities and the noise level. [anchor: "demonstrated through computer simulation for"]
- **Earlier work on subframes (p. 1072).** The authors cite earlier work showing that the method can operate on image subframes, which they call a fundamental requirement for applying it to scenes. [anchor: "ability to operate on image subframes successfully, which"]
- **Fluorescence and microscopy.** Not stated. The paper's examples are atmospheric turbulence, phased-array telescopes, mirror figure errors and the Hubble Space Telescope.

## Relevance to the thesis

- Supports: G30 (a known defocus used as a second measurement to infer aberrations, with extended incoherent objects explicitly in scope, p. 1072). Also a useful statement for contrast with direct wavefront sensing (needs extra hardware, p. 1072) and with a model-based, optimization-based estimator (G25-type wording must not be drawn from here, see below).
- Does not support: any claim about fluorescence microscopy or light-field imaging, since neither is mentioned. It must not be cited for experimental performance (none is reported in this paper), for spatially varying aberrations over a field (the model is space-invariant; subframes are only mentioned as earlier work), or for statements about cost or noise amplification of deconvolution (not discussed in those terms).

## Differences to state if cited

- Phase diversity needs at least two images with a known, controlled difference (for example a known defocus), so it is a multi-image method; a Fourier light-field capture is single-shot and gets its views from the aperture split.
- The estimator is explicitly model based: a pupil function with known support, parameterized phase (Zernike or pixelwise), a known PSF formation model and a noise model. The thesis method models none of these and instead aligns views by shifts.
- It estimates a single (space-invariant) aberration per image or subframe, and the object is recovered by an estimator (maximum likelihood, EM, deconvolution-like). The thesis method is not an estimator of this kind.
- Context is astronomy and general optics under Gaussian or Poisson noise; applicability to extended incoherent objects is stated (p. 1072), but fluorescence microscopy is not addressed here.

## Still unread

- Appendix derivations were skimmed, not verified; some equations are garbled in the text extraction.
- The earlier simulation work (Gonsalves; Paxman and Fienup 1988; Paxman and Crippen 1990) is cited but was not read, so what exactly was demonstrated there is known only from this paper's one-line summary.

## Safe Wording

Phase diversity infers the unknown aberrations of an incoherent imaging system, including for extended objects, by adding a known perturbation such as defocus to a second image and jointly estimating the object and a parameterized pupil phase (Paxman et al. 1992, p. 1072 and Sec. 2).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Add if Chapter 2 explicitly discusses joint phase-diversity estimation. Hanser supplies the more direct fluorescence precedent when discussing retrieval from a known bead.
