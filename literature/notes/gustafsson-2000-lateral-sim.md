# Gustafsson 2000 - Doubled lateral resolution by structured illumination

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. G. L. Gustafsson, "Surpassing the lateral resolution limit by a factor of two using structured illumination microscopy" (Short Communication), Journal of Microscopy 198(2), 82-87, May 2000. Received 12 January 2000, accepted 3 March 2000. The DOI is not printed in the paper itself; the Wiley download banner on each page shows 10.1046/j.1365-2818.2000.00710.x. No discrepancy with the assignment metadata (vol. 198, issue 2, pp. 82-87, 2000).

## What was read

File C4d_18.txt (pdftotext), PDF pages 1-6 = printed pp. 82-87. The whole paper was read: summary, concept, methods, results, discussion, references. Figures 1-4 were read through their captions only (images not inspected). The text file has some mojibake characters (dashes, degree signs) but is otherwise complete.

## Why This Matters

This is the standard primary source for 2D SIM with about 2x lateral resolution gain: nine widefield images under shifted and rotated line patterns, linear reconstruction in Fourier space. It lets the thesis describe SIM accurately as a multi-capture, calibrated, reconstruction-based method, in contrast to the single-shot thesis method. It does not discuss aberrations at all.

## Key Claims (paraphrased)

- **Principle (p. 82-83, Concept; Fig. 1).** Fluorescence emission is proportional to dye density times local excitation intensity, so a known striped excitation pattern produces moire fringes that carry sample frequencies the objective alone could not pass; the pattern moves information in reciprocal space into the observable region. [anchor: "the observed emission light image"]
- **Number of images (p. 83, Concept).** One image cannot separate the three superposed frequency components; three or more images at different known pattern phases allow separation by simple arithmetic. [anchor: "By recording three or more"]
- **Acquisition used (p. 84, Acquisition).** Three phase steps of 120 degrees per orientation, repeated at pattern rotations of 60 and 120 degrees, total nine images, recorded with a cooled CCD at the normal pixel size. [anchor: "a total of nine images. Each image was acquired at the"] Fig. 2 caption (p. 85) mentions sequences of seven to nine images. [anchor: "seven to nine such images"]
- **Resolution gain (p. 82, Summary; p. 85, Fig. 3).** Lateral resolution beyond the classical limit by a factor of two, with no emission light discarded. Measured on 121 nm beads: FWHM about 130 nm (structured illumination) versus 290 nm (conventional) and 210 nm (confocal). [anchor: "of isolated beads is approximately 130 nm in the"] Actin fibres in fixed HeLa cells: about 115 nm versus about 290 nm (p. 86, Fig. 4).
- **Hardware (p. 84, Microscope).** Laser light, spatially scrambled and fibre-coupled, through a linear phase grating in a secondary image plane; only the +1 and -1 orders retained and focused near opposite edges of the objective rear aperture; 0.23 um stripe spacing with a 100x NA 1.4 oil objective; measured modulation depth 70-90 percent; grating on a piezo stage that sets phase and orientation. [anchor: "modulation depth of the stripe pattern was measured to be"]
- **Coherence (p. 84).** Laser coherence is reduced by a rotating diffuser, which limits the pattern's axial extent and reduces sensitivity to stray interference fringes; lower-coherence sources are said to be possible and even advantageous. [anchor: "decrease its spatial coherence, which has two advantages:"]
- **Processing needs calibration (p. 84-85, Processing).** Pattern orientation, spacing, modulation depth and initial phase are estimated from the data by comparing overlapping components; reassembly multiplies each component by the previously measured 2D optical transfer function (OTF), Wiener-like weighting. [anchor: "measured) 2D optical transfer function (OTF) of the"]
- **Artifacts (p. 85, Processing).** The reassembled spectrum has sharp edges, so it is apodized with a cosine bell to reduce ringing. [anchor: "ringing artefacts caused by the sharp edges of the new"]
- **Linearity (p. 86).** The reconstruction is stated to be linear and deterministic, with no non-negativity-constrained deconvolution applied. [anchor: "is completely linear and deterministic."]
- **Time (p. 86).** Total exposure 1-10 s; about 30 s processing for a 512 x 512 output including parameter fitting. [anchor: "processing required about 30 s for a 512"]
- **Scope limits (p. 86-87).** The 2D version is appropriate only for flat samples; 3D needs a focal series and a 3D OTF. A single 2D pattern would avoid rotation but would need more phase images. [anchor: "for this demonstration paper is appropriate only for flat"]
- **Resolution versus confocal (p. 85).** Observable region in 2D is in theory no larger than confocal's; the practical advantage is stronger signal in the high-frequency region. [anchor: "no larger than that of confocal"]

## Relevance to the thesis

- Supports: G29, SIM yields resolution gain (about 2x lateral) from several images (nine here) under shifted and rotated patterns, followed by a computational reconstruction that needs a known or measured OTF and fitted pattern parameters. Also supports that SIM is a multi-capture method (1-10 s total exposure here).
- Does not support: any statement that SIM is sensitive to aberrations in the pattern or PSF (the paper never mentions aberrations); any statement about reconstruction artifacts beyond ringing and the apodization used to suppress it; adaptive optics or blind methods (not mentioned). G25-type claims of noise amplification are not made here either (noise weighting is mentioned only as Wiener-like).

## Differences to state if cited

- Fluorescence, incoherent emission, but the excitation pattern relies on coherent interference of two beams. The thesis method uses no structured illumination.
- This paper is 2D, flat samples, fixed cells, ideal oil-immersion conditions. No aberrated samples were tested.
- Resolution gain is a lateral resolution doubling, not optical sectioning, in this paper (sectioning is only discussed as a possible extension, citing Neil et al.).

## Still unread

- Figures 1-4 as images (captions only).
- Cited works (Heintzmann and Cremer 1998, Neil 1997/1998, patents) not read here.

## Safe Wording

Structured illumination microscopy acquires several images of the sample under shifted and rotated sinusoidal excitation patterns (nine images in the original 2D demonstration) and combines them linearly in Fourier space, using a measured optical transfer function, to double the lateral resolution (Gustafsson 2000, pp. 83-85).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Chapter 2 primary evidence for approximately twofold lateral resolution extension in linear wide-field fluorescence SIM.
