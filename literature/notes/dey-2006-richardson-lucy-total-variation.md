# Dey 2006 - Richardson-Lucy with total variation regularization for 3D confocal deconvolution

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

N. Dey, L. Blanc-Feraud, C. Zimmer, P. Roux, Z. Kam, J.-C. Olivo-Marin, J. Zerubia, "Richardson-Lucy Algorithm With Total Variation Regularization for 3D Confocal Microscope Deconvolution", Microscopy Research and Technique 69:260-266 (2006), DOI 10.1002/jemt.20294. Received 28 July 2005; accepted in revised form 13 October 2005. The page header prints "69:260-266 (2006)"; the issue number (4) appears only in the Wiley download stamp, not in the article header. No discrepancy with the assignment metadata.

## What was read

C4b_27.txt, all 7 pages (260-266): abstract, introduction, image formation model, RL and RL-TV algorithm, synthetic and real results, conclusion, reference list. Figures were not inspected as images; only captions and text were read. Some Greek symbols and the equations are garbled in the text extraction (the Eq. 11 denominator was read from the surrounding text, not verified against the PDF image).

## Why This Matters

Gives a clear primary-source statement that plain Richardson-Lucy (maximum likelihood under Poisson noise) amplifies noise unless it is stopped early or regularized, which is the noise-amplification part of G25. It is a 3D confocal paper with a known, shift-invariant theoretical PSF, so it supports the generic deconvolution point and not anything about aberrations or PSF estimation.

## Key Claims (paraphrased)

- **Problem addressed: noise amplification in RL (abstract, p. 260).** Confocal images remain degraded by residual out-of-focus light and Poisson noise; RL is the maximum-likelihood method for Poisson statistics, but it tends to amplify noise, so a regularization based on prior knowledge is needed to stabilize it. [anchor: "As this algorithm tends to amplify noise, regu-"]
- **RL does not converge to a usable solution (introduction, p. 260).** The authors state that RL does not converge to the solution because noise is amplified after a small number of iterations; this sensitivity can be reduced with regularization. [anchor: "does not converge to the solution because the noise is"]
- **Why (RL section, p. 262).** The inverse problem is ill-posed and the ML estimator is not regularized, so the iterate at infinite iterations consists of noise only; in practice the algorithm is stopped early, which trades a good deconvolution with sharp edges against noise amplification. [anchor: "only, because of noise amplification. To obtain good"]
- **Existing remedy and its cost (p. 260 and p. 262).** Tikhonov-Miller regularization suppresses noise amplification but smooths edges; maximum-entropy and wavelet-threshold variants are mentioned as partial improvements on that trade-off. [anchor: "expression suppresses noise amplifi-"]
- **Method (p. 262).** Adds a total-variation penalty (weight lambda_TV) to the Poisson negative log-likelihood, minimized with a multiplicative RL-type update (explicit scheme after Green 1990); TV smooths along level lines but not across edges. Lambda_TV = 0.002 for the simulations; the paper notes that it must be neither too small nor too large (too large makes the update denominator zero or negative). [anchor: "term Jreg, defined by the TV of the solution o as in"] [anchor: "Numerically we noticed that the regularization param-"]
- **Image model and PSF (p. 261).** Poisson noise on a convolution of object and PSF; the PSF is a theoretical confocal model (Sheppard-Cogswell, as in van Kempen and van Vliet) with defocus phase, assumed translation invariant, and it is used both to simulate the data and to deconvolve it. PSF is treated as known; PSF estimation is not addressed. [anchor: "Under the assumptions of a translation invariant"] [anchor: "This PSF model will be used both for the creation"]
- **Evaluation protocol favours the baseline (p. 262).** For standard RL the authors used the iteration number that gives minimum I-divergence, which requires the ground-truth image (only available for synthetic data). [anchor: "we used the number of iterations that achieves"]
- **Synthetic results (pp. 262-264).** Three simulated 3D objects degraded by blur and Poisson noise. Final I-divergence, RL versus RL-TV: 0.766 versus 0.220 (cylinder), 1.365 versus 0.691 (composite), 0.462 versus 0.404 (textured, 12.6 percent). Plain RL results show residual blur and intensity oscillation artifacts. [anchor: "intensity oscillation artifacts"]
- **Real data (pp. 264-266).** Zeiss LSM 510, 63x NA 1.4 oil objective, 6 um beads and 15 um spherical shells (fluorescent layer 0.5-0.7 um). Measured shell thickness: raw 0.93 um, RL 0.26 um, RL-TV 0.40 um (true 0.5-0.7 um). For the bead cluster, the caption states RL gives high noise and axial oscillation artifacts, much reduced with RL-TV (lambda_TV = 0.005). Real-data evaluation is visual and by shell thickness only; I-divergence cannot be computed. [anchor: "axial view shows oscillation artifacts"] [anchor: "Deconvolution of a bead cluster image."]
- **Limitation of the proposed fix (p. 263-264).** TV regularization produces a stair-casing effect, mainly in textured regions with small-amplitude oscillations; for the textured object the intensity profiles of RL and RL-TV show no significant difference. [anchor: "a drawback of TV regularization is apparent on the XY"]
- **Conclusion (p. 266).** RL without regularization suffers from unstable noise amplification; RL-TV gives better results qualitatively and quantitatively on simulated and real data. [anchor: "with no regularization suffers from unstable noise"]

## Relevance to the thesis

- Supports: G25, the statement that a computational deconvolution route (Richardson-Lucy, the standard Poisson maximum-likelihood method) amplifies noise unless regularized or stopped early (abstract p. 260, intro p. 260, Section on RL p. 262, conclusion p. 266). Also that unregularized RL output can contain oscillation artifacts (p. 263 text, Fig. 5 caption p. 265), and that the known remedies (Tikhonov-Miller, TV) have their own costs (edge smoothing, stair-casing). Deconvolution here requires a known PSF as input (p. 261, "knowing the PSF h").
- Does not support: that deconvolution is slow or computationally costly (no timings given; not stated); that PSF estimation is hard (PSF is a given theoretical model; not stated); anything about aberrations (only the defocus phase of a nominal confocal PSF is modelled); anything about light-field or wide-field microscopy (3D confocal only); a claim that noise amplification applies to every deconvolution algorithm (the paper concerns RL and mentions Tikhonov-Miller as also needing regularization).

## Differences to state if cited

- Confocal laser scanning microscopy (3D stacks, pinhole, Poisson photon-limited noise), not wide-field, not Fourier light-field.
- The noise-amplification statement is specific to unregularized RL and to ML estimation with an ill-posed inverse problem; it is not a general statement about all software aberration correction.
- The paper's own method is a regularized RL, so it shows noise amplification as fixable, not as a fundamental barrier.
- Quantitative comparison uses synthetic data with the same PSF model for generation and restoration, and RL is stopped at the oracle-best iteration.

## Still unread

- Figure images (only captions and text read); Appendix C of the INRIA technical report (Dey et al. 2004a) cited for the RL derivation; the PDF page images were not opened.

## Safe Wording

Richardson-Lucy deconvolution is the maximum-likelihood estimator for Poisson noise, but because the inverse problem is ill-posed it amplifies noise after a small number of iterations, so it must be stopped early or regularized (Dey et al., 2006, p. 260 and p. 262).
