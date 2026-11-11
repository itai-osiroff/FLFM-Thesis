# Paine 2018 - Machine learning for image-based wavefront sensing

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Scott W. Paine and James R. Fienup, "Machine learning for improved image-based wavefront sensing", Optics Letters 43(6), 1235-1238 (2018). Received 29 December 2017, published 6 March 2018. DOI 10.1364/OL.43.001235 (printed). The Institute of Optics, University of Rochester. Funding: Goddard Space Flight Center. No discrepancy with the assignment metadata.

## What was read

C4e_31.txt, the whole file: printed pp. 1235-1238, including the abstract, all text, Figs. 1-6 captions, Table 1 and references. Complete. The figures themselves were read only through their captions; Fig. 1 to 6 curves were not inspected. No supplement is mentioned.

## Why This Matters

An example of image-based wavefront sensing (a Zernike pupil model fitted to a measured PSF by nonlinear optimisation) and of the capture-range problem that limits it for large aberrations. It documents how the field handles strong aberrations by a model, an optimiser and a learned starting guess, which is the approach the thesis explicitly does not take.

## Key Claims (paraphrased)

- **Image-based wavefront sensing defined (p. 1235).** A parameterised physical model (Zernike polynomials) produces a simulated PSF; a gradient-based nonlinear optimiser adjusts the coefficients until it matches the measured PSF. It needs no extra optical components and is used for alignment and focusing of the James Webb Space Telescope. [anchor: "Image-based wavefront sensing is a method to measure wave-"]
- **Problem addressed (abstract, p. 1235).** For large wavefront error the optimiser is unlikely to converge when the starting guess is far from the truth (local minima, the "capture range problem"). [anchor: "unlikely to converge when the starting guess for the"]
- **Known ways to extend the capture range (p. 1235).** Additional measurements such as phase diversity or a translating subaperture, or many random starting guesses with a similar RMS wavefront error; the random-start method becomes statistically unlikely to succeed at large RMS error. So defocus diversity is mentioned only as a prior remedy, not used here. [anchor: "such as phase diversity [6,7] or a translating"]
- **What is measured and fed to the network (p. 1236-1237).** A single centred, noisy PSF, not a focus-diverse set. The paper states this itself: defocus diversity is normally used for robustness, but results are shown from only a single PSF. [anchor: "Zernike coefficients from a single centered, noisy PSF"]
- **Role of the network (abstract, p. 1235; p. 1237).** An adapted Inception v3 convolutional network, trained as a regression, predicts Zernike coefficients; these serve as the initial estimate for a subsequent nonlinear optimisation (L-BFGS), not as the final answer. [anchor: "machine learning operating on a point-spread function to"]
- **Simulation setup (p. 1236).** Uniformly illuminated JWST aperture, PSFs from second to fifth order global Zernike terms, no piston, tip, tilt or per-segment errors; staged training with 2.3 RMS waves, then 1.0 to 4.0 RMS waves, then added Poisson, read, background noise and dead pixels (Table 1). Final validation loss 0.373 waves RMS between predicted and true coefficients. [anchor: "validation loss was 0.373 waves of RMS"]
- **Result (p. 1237-1238, Figs. 5 and 6).** Monte Carlo, 250 PSFs per RMS level from 0.25 to 4.0 waves, compared with 30 random starts of the same RMS error. The median result from CNN initialisation outperformed random starts by orders of magnitude for true RMS error above 0.5 waves, and the CNN start was more likely to reach residual error below 1/10 of the Marechal criterion (1/140 wave). [anchor: "outperforms random starting guesses by"]
- **Timing (p. 1238).** On a desktop the CNN took 0.2 s, the nonlinear optimisation about 16 s on average; the paper says this is not fast enough for real-time wavefront sensing at these image sizes. [anchor: "not fast enough for real-time wavefront sensing"]
- **Limits stated (p. 1238).** Few Zernike terms, no tip or tilt, simulated PSFs only; application to a measured PSF is future work and would add higher-order terms and different noise. [anchor: "to be applied to a measured PSF from a detector"]

## Relevance to the thesis

- Supports: G30 weakly: defocus and phase diversity are named as additional measurements that extend the capture range of phase retrieval (p. 1235). G26 only as an example of wavefront sensing by an image-based (sensorless-type) method that needs no extra hardware, applied here to telescopes. G25 weakly: model-based wavefront estimation by nonlinear optimisation is sensitive to the starting guess and takes seconds per PSF.
- Does not support: anything about microscopy, fluorescence, extended scenes, light-field or multi-view imaging; nothing in it is demonstrated on measured data. It does NOT use focus-diverse images; do not cite it as through-focus phase retrieval. It says nothing about Shack-Hartmann sensors, deformable mirrors, deconvolution or spatial variation of aberrations.

## Differences to state if cited

- Astronomy (space-telescope) context with a point source (a PSF), simulated only; the thesis is about fluorescence microscopy of extended 2D scenes.
- The learned part only provides an initial guess; the wavefront is still estimated by a physical-model optimisation. The thesis method has neither a learned part nor a wavefront model.
- A single PSF is used here, with a global pupil wavefront.

## Still unread

- Nothing in the text left unread; figure curves (Figs. 4 to 6) not inspected beyond captions.

## Safe Wording

Paine and Fienup showed in simulation that a convolutional network applied to a single noisy PSF gives starting Zernike coefficients that let a nonlinear image-based wavefront sensor converge for large aberrations, where random starts fail (Opt. Lett. 43, 1235, 2018, abstract and p. 1237-1238).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Reserve for learned initialization or capture-range limitations. The cited comparison uses simulated detector noise.
