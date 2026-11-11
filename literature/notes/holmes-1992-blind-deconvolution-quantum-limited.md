# Holmes 1992 - Blind deconvolution of quantum-limited imagery by maximum likelihood

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Timothy J. Holmes, "Blind deconvolution of quantum-limited incoherent imagery: maximum-likelihood approach", Journal of the Optical Society of America A 9(7), 1052-1061, July 1992 (received 23 October 1990, revised 2 December 1991, accepted 3 December 1991). Department of Biomedical Engineering, Rensselaer Polytechnic Institute. No DOI is printed on the paper. No discrepancy with the metadata in the assignment.

## What was read

File C4b_21.txt, PDF pp. 1-10 (printed pp. 1052-1061): the abstract, Sections 1-5 (introduction, derivation, constraints, three simulations, discussion and conclusions), and the start of the reference list. Equations (12)-(31) were skimmed for what is estimated and how, not re-derived. The images in Figs. 2-11 were not inspected; the text describes them and gives captions with numeric ranges. The end of the reference list was not read.

## Why This Matters

This is the early maximum-likelihood (expectation-maximization) formulation of blind deconvolution for fluorescence microscopy, in which the object and the point spread function (PSF, here "impulse response") are estimated together. For the thesis it is a primary source that a PSF-unknown deconvolution needs extra constraints on the PSF, and that even the simulations show noise artifacts and divergence. It is simulation only.

## Key Claims (paraphrased)

- **Setting (abstract, p. 1052).** The paper extends earlier maximum-likelihood restoration for incoherent imaging to the case where the impulse response of the system is unknown, motivated by wide-field and confocal fluorescence microscopy. Some prior knowledge about the PSF, namely circular symmetry and band limit, is used. [anchor: "These simulations demonstrate the potential utility and present limitations"]
- **Earlier methods need the PSF (p. 1053).** All published image-reconstruction approaches for these microscopy problems in principle require the PSF to be known. It can be measured by calibration, but the author expects such calibration to limit wide use, and a life scientist may want to restore images for which no calibration was done or where it is imprecise. [anchor: "is required that the impulse response of the system be"]
- **Calibration practicality (p. 1053).** The calibration methods are described as esoteric. [anchor: "they are esoteric, and this we"]
- **What is estimated (p. 1053).** The object (fluorophore intensity function) and the PSF are estimated simultaneously with the expectation-maximization algorithm; the total photon count is also an estimated parameter but turns out to be trivially the measured photon count. [anchor: "estimate h(-) simultaneously while estimating"]
- **Noise model (p. 1053).** Photon detections are modelled as a Poisson random point process, justified by the use of a cooled CCD camera that works essentially as a photon counter. This differs from earlier blind-deconvolution studies cited in the paper, which used autoregressive scene models and additive Gaussian noise. [anchor: "Poisson random-point-process model for the set of photon"]
- **Noise model contrast (p. 1052).** [anchor: "additive Gaussian noise to characterize"]
- **Implicit constraints (pp. 1053, 1055).** Because object and PSF are treated as probability densities, the estimates are automatically non-negative with unit volume for the PSF, and each iteration preserves the photon count. [anchor: "the MLE procedure automatically constrains them to be"]
- **Algorithm form (p. 1056, Fig. 1 flowchart).** Each iteration convolves the PSF with the object estimate, divides the data by the result, and updates the object and the PSF by correlating the ratio with the other estimate. Steps 2-5 for the object have the same form as the known-PSF update. [anchor: "Divide the collected data Nd(du) point by point by"]
- **Symmetry constraint (p. 1055).** The PSF can be constrained to have regions of constant value, for example circular symmetry, implemented by averaging the PSF update over those regions. [anchor: "It is possible to incorporate some prior knowledge about"]
- **Band-limit constraint (p. 1056).** The PSF of an optical system is band limited, and this is imposed by a Gerchberg-Saxton-style step: zero the optical transfer function outside a region, transform back, clip negative values. The author could not derive a Lagrange-multiplier solution and calls this an interim, pragmatic approach. [anchor: "It is well known that the point-spread function of an opti-"]
- **Simulations (pp. 1056-1059).** Three simulations on a 64 by 64 array with 4000 photons per pixel on average (16,384,000 total), within the range the author gives for low-light fluorescence with a cooled CCD. Circle PSF (Sim. 1) and annular PSF (Sim. 2) with the symmetry constraint; an Airy pattern for NA 1.0 and 0.5 um emission (Sim. 3) with the band-limit constraint at 500 iterations, using a cutoff 25 percent above the true cutoff. All data are simulated; no real microscope data. [anchor: "of 4000 photons per pixel. This is within the range of"]
- **Results (pp. 1057-1059).** In all simulations the general shapes of the object and PSF were restored. Simulation 3 at 100 photons per pixel also gave a reasonable object and PSF after 50 iterations, with blind and non-blind results similar. [anchor: "the general shapes"]
- **Blind versus non-blind (p. 1059).** With the PSF known, the reconstructions at 50 and 500 iterations look similar to the blind ones, so the author attributes the noise artifact at low photon count to maximum likelihood itself, not to blindness. [anchor: "blind and the nonblind algorithms yield similar recon-"]
- **Divergence (p. 1057, Sim. 1).** The reconstruction seems to diverge after a number of iterations, which the author expects regularization to address. [anchor: "cates a limitation in that the reconstruction seems to di-"]
- **Noise artifact (p. 1059).** The noise artifact at 100 photons per pixel is inherent in maximum likelihood when the photon count is low and no regularization is used. [anchor: "in Fig. 11(f) is inherent in the MLE approach when the"]
- **Constraints are necessary (p. 1059, Sec. 4.D).** Without any constraint on the PSF the simulations gave reconstructions with little resemblance to the true object and PSF, even though the log likelihood still increased with every iteration. [anchor: "we found that it was necessary to constrain the"]
- **Trivial solution (p. 1059).** With only the circular-symmetry constraint, at 1000 iterations the object estimate drifted toward the degraded image and the PSF toward an impulse; the band-limit constraint rules this out. [anchor: "Using the band-limiting constraint, as we have done, rules"]
- **Local maxima (p. 1059).** Without the band limit the log likelihood is thought to stagnate at a local maximum or other stationary point. [anchor: "stagnating at a local maximum or"]
- **Stopping early (p. 1060).** As an interim measure the author suggests stopping early, for example at 50 iterations, and expects regularization (sieve, MAP) to help in future. [anchor: "reconstruction early, say, at 50 iterations."]
- **Overall conclusion (p. 1059).** Maximum likelihood, or a variant such as MAP, is a workable approach to blind deconvolution when the imaging system follows an incoherent model, with present limitations. [anchor: "is a workable approach to the blind de-"]
- **Open practical issues (p. 1060).** Truncated data, faulty detector elements, non-uniform quantum efficiency and dark current are not addressed. [anchor: "nonuniform detector quantum efficiency (flat field cor-"]

## Relevance to the thesis

- Supports: G25, in part. The PSF is assumed known by earlier restoration methods (p. 1053); when it is unknown, blind maximum-likelihood deconvolution needs constraints on the PSF and still shows divergence, noise artifacts, and stagnation in the author's own simulations (pp. 1057-1060). Also supports that deconvolution in fluorescence microscopy is formulated as an iterative estimation with a Poisson photon-noise model. It also gives a primary description of the 1992 state of calibration-based PSF measurement in microscopy (p. 1053).
- Does not support: that software solutions are costly or slow (no run times or cost are reported; the paper does say it used 50 to 1000 iterations), that deconvolution amplifies noise in general (the paper says the noise artifact appears at low photon counts in maximum-likelihood restoration, for known and unknown PSF alike), anything about aberrations, adaptive optics, wavefront sensing or spatially varying correction, or any real microscope data. It also does not say that the PSF changes with aberrations; the PSF in the simulations is a fixed circle, annulus, or Airy pattern.

## Differences to state if cited

- It is a simulation study of a 2D object, with a spatially invariant PSF (a convolution model); the thesis models aberrations as local shifts between sub-aperture views and does not estimate a PSF.
- It is a first attempt by the author's own words; its limitations were later addressed by the field, and this paper should not be cited as the current state of blind deconvolution.
- Photon-counting noise only; no background, read noise, or detector non-uniformity.

## Still unread

- Figures 2-11 as images; the later part of the reference list; the exact derivation of Eqs. (12)-(31).
- The citation numerals in the sentence about independently developed astronomy algorithms (p. 1052) are garbled in the text layer; Refs. 23 (Richardson 1972) and 24 (Lucy 1974) are in the reference list, so the sentence probably cites them, but this was not confirmed from the PDF.

## Safe Wording

Early maximum-likelihood blind deconvolution for fluorescence microscopy estimated the object and the PSF together under a Poisson photon-counting model, but needed constraints on the PSF (symmetry, band limit) to avoid trivial or meaningless solutions, and showed divergence and noise artifacts in simulation (Holmes 1992, pp. 1057-1060).
