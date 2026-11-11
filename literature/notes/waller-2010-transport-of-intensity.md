# Waller 2010 - Transport-of-intensity imaging with higher order derivatives

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

L. Waller, L. Tian, G. Barbastathis, "Transport of Intensity phase-amplitude imaging with higher order intensity derivatives," Optics Express 18(12), 12552-12561 (2010). Printed footers run 12552 to 12561; received 25 Mar 2010, published 27 May 2010 (issue dated 7 June 2010). No DOI printed on the paper. Metadata in the assignment matches. The text file has content only through p. 12560; the p. 12561 page holds only a footer line.

## What was read

File C4e_38.txt, complete (printed pp. 12552-12561). Page locators are the printed OSA footer numbers; the footer sits under the page text, so text above a footer is assigned to that page (an inference from layout). Figures 1-8 were read only through captions and surrounding text. Table 1 and Eq. (7) were read in garbled form. The PDF itself was not read.

## Why This Matters

This paper explains how many defocus images the transport-of-intensity equation (TIE) needs and what limits accuracy when the defocus range grows. It is a through-focus method for recovering phase and amplitude (gap G30), and it states that TIE works with partially coherent brightfield microscope illumination. It is a transmission phase-imaging method, not a fluorescence one.

## Key Claims (paraphrased)

- **Basic TIE (p. 12553, Sec. 2).** The TIE relates the axial intensity derivative to the lateral divergence of intensity times phase gradient. Phase is computed quantitatively from defocused images, only the paraxial approximation is invoked, and an FFT-based Poisson solver is used (two Poisson equations if intensity is not constant). [anchor: "invokes only the paraxial approximation."]
- **Boundary conditions (p. 12553).** The Poisson solution needs known or imposed boundary conditions. [anchor: "Generally, the solution requires known or imposed boundary"]
- **Two images minimum (p. 12553, Sec. 1).** Standard TIE needs two images defocused from each other; there is a trade-off between defocus amount, accuracy and noise. [anchor: "Generally, TIE requires two images that are defocused from each"]
- **Defocus-step trade-off (p. 12554, Sec. 2).** Large defocus breaks the linearity assumption of the finite-difference derivative and blurs the result; small defocus gives low signal-to-noise and noisy phase. An optimal defocus exists, depending on the object spectrum and camera noise. [anchor: "Thus, there will be an optimal"]
- **Method (pp. 12555-12557, Sec. 3).** The axial intensity at each pixel is expanded in a Taylor series; higher-order axial derivatives are estimated (technique 1: weighted combinations of images; technique 2: per-pixel least-squares polynomial fit) and removed from the first-derivative estimate, then standard TIE is applied. Only even derivative orders carry amplitude information; the 0th order is the in-focus intensity and the 1st gives phase. [anchor: "only the even derivative orders (0th, 2nd,4th...) will contain amplitude"]
- **Number of images (pp. 12556-12557).** Correcting for a derivative order k needs about k+1 or more equally spaced images; the polynomial order must be below the number of images, and more images give better noise performance. [anchor: "The order of the polynomial fit function should be less than the"]
- **Noise cost of higher orders (p. 12556).** Higher-order finite-difference weights amplify noise (example: weight 4 on one image); if the higher-order term is below the noise floor, correction only adds noise; averaging repeated images balances this. Over-fitting also raises actual error (p. 12558). [anchor: "meaning that the noise of I1 is also amplified by a factor of 4."]
- **Simulation (pp. 12557-12559).** Simulated pure-phase object, 80 images at 1 um spacing, 532 nm. A 20th-order fit gave mean phase error 0.010 versus 0.110 for two-image TIE, 0.025 for the Soto-type first-order fit and 0.024 for iterative phase diversity (at the stated noise levels). [anchor: "The data set uses 80 images axially"]
- **Laser experiment (p. 12559).** In-line geometry with a 4f system, 532 nm laser, camera translated 5 um between 60 images, PMMA phase object with 190 nm trenches. Two-image TIE is hidden by low-frequency noise, phase diversity is somewhat noise-sensitive, 20th-order TIE is accurate. [anchor: "Image data were captured on a CCD camera, using laser"]
- **Brightfield microscope (p. 12560).** A 20x objective (NA 0.45), 5 focal positions 2.6 um apart and a broadband tungsten-halogen lamp; amplitude and phase were reconstructed (technique 1, orders 1, 3, 5). Sharp edges and dust appear as amplitude effects. [anchor: "out with a 20x objective (NA = 0.45), adjusting the microscope"]
- **Partial coherence (p. 12553; p. 12560).** TIE is valid for partially coherent illumination (the paper cites Paganin and Nugent), giving resolution to the partially coherent diffraction limit and suiting a brightfield microscope. [anchor: "allowing resolution out to the partially coherent diffraction limit"]
- **Phase diversity comparison (p. 12554).** Iterative methods like phase diversity work at large defocus but generalize less easily to partial coherence and do not suppress noise. [anchor: "they are not as easily generalized to partially coherent illumination"]
- **Computation (p. 12552, abstract).** The authors state computation is fast and efficient and noise sensitivity falls with many images. [anchor: "Computation is fast and efficient, and sensitivity to noise is"]

## Relevance to the thesis

- Supports: G30 (through-focus intensity images used to recover phase and amplitude; phase diversity named as a related iterative defocus method, with ref. 15, Paxman et al., on joint object and aberration estimation listed only in the references, not discussed in the text). Supports that TIE needs at least two, often many, defocused images.
- Does not support: any claim about fluorescence (not mentioned), light-field or multi-view imaging (not mentioned), aberration correction (the word aberration occurs only in a reference title), or spatially varying aberrations. Not a source for AO or deconvolution cost.

## Differences to state if cited

- TIE needs two or more images at different focus positions (camera or stage translated); the thesis uses one Fourier light-field exposure.
- It recovers phase and amplitude of a transmissive object under coherent or partially coherent light; incoherent fluorescence emission is not treated.
- It is a model-based inversion (Poisson solve with boundary conditions); the thesis method is not.
- The microscope demonstration is brightfield with only 5 planes; the 80-image and 60-image stacks are simulation and laser experiment.

## Still unread

- Figures read via captions only; Table 1 and Eq. (7) garbled.
- Reference list (17 items) not read.

## Safe Wording

Transport-of-intensity methods recover phase from images taken at different defocus positions, remain valid for partially coherent illumination, and trade nonlinearity at large defocus against noise at small defocus (Waller et al. 2010, pp. 12553-12554).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Reserve for a quantitative-phase comparison. A defocus stack is shared as a measurement format, while the reconstructed quantity and forward model differ from fluorescence PSF retrieval.
