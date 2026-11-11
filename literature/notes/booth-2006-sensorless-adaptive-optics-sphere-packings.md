# Booth 2006 - Wave front sensor-less adaptive optics with sphere packings

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. J. Booth, "Wave front sensor-less adaptive optics: a model-based approach using sphere packings," Optics Express 14(4), 1339-1352, 20 February 2006 (received 15 November 2005, accepted 13 February 2006). No DOI is printed in the extracted text (only "#9494" as the manuscript number). Authors, journal, volume, issue, pages and year match the assignment metadata.

## What was read

C4a_02.txt, the whole paper (printed pp. 1339-1352, 14 PDF pages), including the appendices on Zernike modes, simplex construction and step size. The equations are partly garbled in the text extraction and were read for their stated meaning and the surrounding prose, not re-derived. Figures 2 to 7 were not viewed as images; only their captions and the prose describing them. The proofs in the cited sphere-packing literature are unread.

## Why This Matters

This is the theory reference for the sensorless (wavefront sensor-less) AO approach. It is a general, mathematical paper: a single photodetector behind a pinhole, a phase element in the pupil, and a maximisation of the detected signal. It supplies the definition of the approach and the number of measurements needed (N+1 for N Zernike modes). It contains no microscope experiment, no biological sample and no demonstrated imaging benefit.

## Key Claims (paraphrased)

- **Definition of sensorless AO (p. 1340, introduction).** A conventional AO system has a wavefront sensor, an adaptive correction element and a controller driving the element from the sensor signals. The alternative has no distinct, separate wavefront sensor, only a single photodetector, and adapts the correction element to maximise the detector signal or a related measure. [anchor: "A conventional adaptive optics system employs a wave front"] [anchor: "without a distinct, separate wave front sensor but rather a"] [anchor: "is based upon the maximisation"]
- **Where the sensorless approach has been used (p. 1340).** The paper lists confocal fluorescence and reflection microscopy, two-photon fluorescence microscopy, second-harmonic maximisation, intracavity laser correction, optical tweezers, fibre coupling, and characterisation of adaptive optics, so it is a general technique and microscopy is one application among several. It names modal wavefront sensing among the optimisation schemes used by these sensorless systems, i.e. it treats modal sensing as a sensorless method, in contrast to Neil 2000, which calls the same idea a wavefront sensor. [anchor: "wave front sensorless adaptive systems have been"] [anchor: "and modal wave front sensing"]
- **Why no wavefront sensor (G26).** Not stated. The paper does not say that direct wavefront sensing (Shack-Hartmann or otherwise) is difficult or impossible in microscopy; it only describes sensorless systems as a different design.
- **Measured quantity (pp. 1341-1342, Section 2).** The measured signal is the photodetector intensity behind a pinhole at the nominal focus, equal to the input power times a function f(c) that is equivalent to the Strehl ratio. For small residual aberration f falls as one minus the squared norm of the residual Zernike coefficients, so contours of constant signal are N-dimensional spheres, which is what the sphere-packing algorithms exploit. [anchor: "equivalent to the Strehl ratio"]
- **Modes (pp. 1341, 1346, Appendix A p. 1351).** Aberrations are expanded in N Zernike modes; the paper's numbering starts at i=4 (defocus), covering defocus, two astigmatisms, two comas and trefoil for N up to 6. The aberration is assumed to be well represented by a small number of modes. The results are said to hold for any orthonormal basis, for example the eigenmodes of a deformable mirror. [anchor: "In many practical systems aberrations can be accu-"] [anchor: "the normalised eigenmodes of a deformable"]
- **Measurements per correction (pp. 1339, 1348-1350).** Direct maximisation, using a first-moment (centre of mass) estimate with trial aberrations placed at the vertices of a simplex, recovers N Zernike modes with N+1 intensity measurements. This is the minimum, since there are N coefficients plus the unknown total intensity. Exhaustive searches need a number of evaluations that grows exponentially with N, and steepest-ascent hill climbing about N squared. The direct estimate was accurate to a tolerance of 0.1 (in coefficient units) for input aberration magnitudes up to about 1.05 to 1.26 for the mode sets tested (N up to 6), so it works for small aberration only. [anchor: "Zernike modes with only N + 1 intensity measurements"] [anchor: "number of measurements required in the exhaustive search"]
- **Corrector hardware, aberration sources, cost, spatial variation (G24, G27).** Not stated. The phase element is generic ("could in practice be an adaptive element"); no deformable mirror or SLM is specified, no costs are given, and spatially varying aberrations across a field are not discussed (the model has one aberration, one point detector).
- **Demonstrated benefit.** No experiment and no image is shown. The results are numerical tests on simulated random aberrations (for example 1000 random solutions per mode set in the search tests and direct-estimation tests), showing that the algorithms converge to the required tolerance (Strehl above 0.9 for a tolerance of 0.1). The paper says similar models apply to the other systems it lists, with minor adjustments. [anchor: "direct maximisation scheme permits the measurement of N Zernike"]

## Relevance to the thesis

- Supports: G26 (partially): a primary definition of AO with a wavefront sensor versus AO without one, with image or detector intensity maximisation used in microscopy among other applications (p. 1340). The N+1 or sparse-measurement figure for how many trial images a sensorless method needs.
- Does not support: any G24 statement on sources of aberration; G27 on cost or spatial invariance; any claim that wavefront sensing is hard in microscopy; any claim of demonstrated imaging benefit; G25 or G30. It is not a microscopy-specific paper and has no experiment.

## Differences to state if cited

- Theory and simulation only, for a single point detector behind a pinhole; the microscope papers by the same group (Neil 2000, Debarre 2009) are the experimental counterparts, in two-photon scanning microscopes.
- N+1 measurements assumes the Strehl-like model for a point detector; Debarre 2009 reports 2N+1 for a different metric (mean 2PEF image intensity). Neither paper explains the difference in the text read here.
- The sensorless approach corrects one global pupil aberration; the thesis models aberrations as local shifts between views, with no corrector.

## Still unread

- Cited microscope applications (Booth et al. 2002, Wright et al. 2005, Sherman et al. 2002, Marsh et al. 2003, Albert et al. 2000), the modal sensor theory (Neil et al. 2000), and the sphere-packing references. Figures were not viewed.

## Safe Wording

Adaptive optics systems without a distinct wavefront sensor use a single photodetector and adjust the correction element to maximise its signal; for N Zernike modes the aberration can be estimated from N+1 intensity measurements when the aberration is small (Booth 2006, pp. 1339-1340, 1350).
