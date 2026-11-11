# Kirshner 2013 - 3-D PSF fitting for fluorescence microscopy: implementation and localization application

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

H. Kirshner, F. Aguet, D. Sage, M. Unser, "3-D PSF fitting for fluorescence microscopy: implementation and localization application", Journal of Microscopy 249(1), 13-25 (2013), doi 10.1111/j.1365-2818.2012.03675.x. The page header prints "Journal of Microscopy, Vol. 249, Pt 1 2013, pp. 13-25"; received 30 January 2012, accepted 21 September 2012. The assignment says "online 2012": the printed text does not give an online-publication date, but the printed received/accepted dates and DOI (2012 in the DOI string) are consistent with it. The first listed affiliation is the Biomedical Imaging Group, EPFL (a second affiliation, Department of Cell Biology, Harvard Medical School, is printed but its author mapping is garbled in the extraction). No other discrepancy.

## What was read

C4b_23.txt, all 13 pages (13-25): summary, introduction, Gibson-Lanni model, numerical evaluation, applications (localization, defocus/misalignment estimation), conclusions, references, Appendices A and B. Figures were not inspected as images (captions and text only). Equations are garbled in the text extraction, so the derivative expressions (Table 2) and accuracy curves (Figs. 8-11) were not verified numerically.

## Why This Matters

A source for the Gibson-Lanni point spread function model, which is the standard model for a wide-field microscope with refractive-index mismatch between sample, cover slip and immersion layers (it predicts an asymmetric 3D PSF), and for a least-squares routine that fits it to single-emitter data. It is a PSF-modelling and single-molecule localization paper, so it is only loosely connected to correcting aberrations in images.

## Key Claims (paraphrased)

- **Purpose (summary, p. 13).** Localization microscopy normally uses computationally cheap Gaussian approximations of the PSF; the paper shows how to use realistic 3D wide-field PSF models instead, introducing a least-squares fitting framework based on the Gibson-Lanni model with an efficient evaluation of its derivatives. Demonstrated by particle localization and defocus estimation, implemented as ImageJ plugins. [anchor: "particle localization and in defocus estimation."]
- **Why not Gaussian (p. 13).** A Gaussian reproduces the main lobe of the Airy pattern at low cost but discards the side lobes, which matter in 3D PSF modelling; the paper proposes a two-stage use (fast simple model for immediate feedback, realistic model later for accuracy). [anchor: "discards the side-lobes of the PSF,"]
- **Models mentioned (pp. 13, 24).** Theoretical bounds in the literature compare Gaussian, Airy and Gibson-Lanni models (this paper does not run that comparison); Appendix A relates the Gibson-Lanni model to the Born-Wolf model (Gibson-Lanni generalizes it); the plugin also includes Richards-Wolf. [anchor: "Rao lower bounds on the achievable localization accuracy"] [anchor: "Born & Wolf and the Richards & Wolf models."]
- **Gibson-Lanni model (pp. 14-15).** Generalizes Born-Wolf by allowing a refractive-index mismatch between three layers (sample, cover slip, immersion); the Kirchhoff diffraction integral (Li and Wolf approximation) with an optical path difference that depends on NA, n_s, n_i, stage displacement, emitter depth and detector position. The model predicts non-symmetric PSF patterns caused by the index mismatch (Fig. 2). [anchor: "model by accommodating for a refractive index mismatch"] [anchor: "ability to predict nonsymmetric PSF"]
- **Stated limitation of the model (p. 15).** It assumes a homogeneous sample layer; refractive-index variations in tissue are said to be measurable by differential interference contrast or modelled stochastically, in which case n_s can be read as an effective index. [anchor: "model assumes a homogenous sample layer and this is one"] [anchor: "of its limitations. Variations in refractive index values can"]
- **What is fitted (pp. 15-18, 21).** Least-squares (Levenberg-Marquardt) fits of the model to a z-stack of fixed point sources: 3D position (x_p, y_p, z_p) plus amplitude for localization, and for the defocus application (x_p, y_p, detector-plane distance, amplitude) from sources on the cover slip. Local maxima are found with adaptive thresholds; the stage displacement of the slice provides the initial depth guess. [anchor: "us with an initial estimation of the particle depth by means"]
- **Defocus in this paper (pp. 14-15, 21).** Defocus appears as the quadratic term of the optical path difference (relation between stage displacement, emitter depth and detector distance); the defocus-estimation algorithm determines the axial position of a defocused detector plane, motivated by calibration of multiplane (biplane) imaging. It does not estimate an emitter's axial position from the defocus of a single image, and it is not an aberration-measurement scheme. [anchor: "we also introduce an algorithm for estimating the defocus"] [anchor: "Motivated by the calibration stage of multiplane microscopic"]
- **Accuracy (pp. 19-21), simulation only.** Simulated z-stacks of point sources (NA 1.4, n_i 1.5, n_s 1.33, wavelength 520 nm, pixel 150 nm, z-step 100 nm, depths 0-2000 nm), Poisson emission plus Gaussian readout noise and scatter background, 20 realizations per setting. In the low-noise case the highest standard deviation reported is 0.2 nm lateral and 1.4 nm axial; in the high-noise case 1.1 nm lateral and 8.1 nm axial. Lateral accuracy is less sensitive to depth than axial accuracy; axial accuracy improves with more axial data points; sub-pixel lateral position has a minor effect. [anchor: "lateral position was 0.2 (nm), and for the axial position"] [anchor: "can be improved substantially by taking more data points"]
- **Least squares versus maximum likelihood (p. 13-14).** Least squares is expected to be less accurate than maximum likelihood for non-Gaussian noise but follows it closely under the cited comparison (standard deviations larger by no more than 2 nm lateral for Gaussian and Airy patterns, from Abraham et al. 2009); it is simpler and faster. [anchor: "The least-squares localization approach is likely to yield"]
- **Relation to restoration (p. 13).** The authors note that the Gibson-Lanni model has been shown useful for restoration problems (citing Markham and Conchello 2001; Preza and Conchello 2004). [anchor: "the Gibson and Lanni model was shown to be very useful for"]
- **Evidence base.** All accuracy results in the text are from simulations (Fig. 6 onward); no experimental dataset is reported in the text read. [anchor: "Simulation results with z-stack data indicate"]

## Relevance to the thesis

- Supports: G25 only as background on PSF models: that a realistic PSF model (Gibson-Lanni, with refractive-index mismatch) is available and that using it is more demanding than a Gaussian (execution-time trade-off, p. 13); the model's homogeneous-sample assumption is a stated limitation (p. 15). G24, narrowly: refractive-index mismatch between sample and immersion layers produces a non-symmetric PSF (p. 15, Fig. 2).
- Does not support: G25 claims about deconvolution cost, slowness, artifacts or noise amplification (no deconvolution is performed); PSF estimation for deconvolution (the PSF is fitted to isolated point emitters for localization, with known parameters); G30 as stated in the thesis (through-focus images used to measure aberrations or recover 3D): the z-stack localization is of single emitters and the defocus algorithm calibrates a detector plane, not sample aberrations; G26/G27 (no AO, wavefront sensing or deformable mirrors); any experimental result (simulation only); any aberration-correction method.

## Differences to state if cited

- Single-molecule/particle localization with sparse point emitters in simulated wide-field z-stacks; the thesis images dense, extended 2D scenes with light-field optics.
- The PSF is a forward model fitted by least squares, not a software correction pipeline; accuracy figures are nanometre localization precision, not image quality.
- The Gibson-Lanni model describes a single depth-dependent refractive-index-mismatch aberration with a homogeneous sample, not arbitrary sample- or optics-induced aberrations.

## Still unread

- Figures as images (Figs. 1-15); equations and Table 2 (garbled in extraction); the units printed for detector-plane defocus values in Figs. 10-11 captions (symbol garbled, so no numbers are reported); the PSFGenerator and localization plugin documentation (external).

## Safe Wording

The Gibson-Lanni model extends the Born-Wolf model to a refractive-index mismatch between sample, cover slip and immersion layers and predicts an asymmetric 3D point spread function, but it assumes a homogeneous sample layer (Kirshner et al., 2013, pp. 14-15).
