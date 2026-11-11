# Wilson 2011 - Optical sectioning in fluorescence microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

T. Wilson, "Optical sectioning in fluorescence microscopy", Journal of Microscopy 242(2), 111-116, 2011 (printed Vol. 242, Pt 2, 2011; received 3 August 2010, accepted 16 September 2010; copyright line 2010). DOI 10.1111/j.1365-2818.2010.03457.x (printed on the paper). No discrepancy with the assignment metadata; note the paper itself carries both 2010 (copyright, acceptance) and 2011 (volume) dates.

## What was read

C4d_20.txt, all six PDF pages (printed pp. 111-116): summary, introduction, theory, all sections, conclusion, references. Complete. Figures 1-6 were not inspected as images, only captions and the text describing them. The file is non-UTF-8; some equations are garbled, and the numeric half-widths below were cross-checked against the surrounding text.

## Why This Matters

A short theory review of how optical sectioning arises from the structure of illumination and detection, comparing wide-field, confocal and structured-illumination approaches. It gives a primary source for the statement that wide-field imaging does not section, that confocal sectioning needs scanning, and that structured illumination needs several images with accurately known phases.

## Key Claims (paraphrased)

- **Why sectioning matters for 3D (p. 111).** A confocal microscope does not make 3D images directly; it records thin optical sections, and a thick specimen needs a whole through-focus series recorded sequentially and then processed. [anchor: "it is necessary to take a whole through-focus"]
- **Scope (p. 111).** Treatment is restricted to single-photon fluorescence, where sectioning comes from the optical system and not from nonlinear interaction. [anchor: "we shall restrict our attention"]
- **Wide-field (pp. 112-113).** With uniform illumination, the image of a thin fluorescent sheet does not change with defocus, so the conventional microscope has no optical sectioning. [anchor: "the conventional microscope does not exhibit optical"]
- **Confocal (p. 113).** Point illumination plus point detection sections, but only one specimen point is probed, so scanning is needed to image an extended region. [anchor: "but at the price of being a scanning"]
- **Confocal sectioning is not optimal (p. 113).** Its sectioning strength is an average over all spatial frequencies in the point illumination, each of which decays with defocus at a different rate, so a single optimally chosen frequency may do better. [anchor: "decays with increasing defocus at different rates"]
- **Structured illumination, computational demodulation (pp. 113-114).** Illumination 1 + cos(frequency) leaves a conventional non-sectioning image superimposed; demodulation records typically three images at set pattern positions and combines them. Half-width of the axial response is 4.4 (in the paper's defocus units) at the best frequency, versus 4.25 for the ideal confocal. [anchor: "typically three, at specific"]
- **Cost of computational route (p. 114).** The processing is nonlinear and the three raw images must be recorded with accurately known phase differences to avoid image artefacts. [anchor: "recorded with precise phase differences in order to avoid"]
- **Structured illumination plus structured detection (pp. 114-116).** Using the same single spatial frequency in the detection plane (optical, lock-in-like demodulation) gives a half-width of 3.22 at the best frequency, about 25% narrower than an ideal confocal with an infinitely small pinhole. [anchor: "25% narrower than the response of the confocal"]
- **Practical embodiment (p. 115-116, Fig. 6).** A striped metallized mask in the detection path passes one complementary image and reflects the other, so two complementary images are recorded simultaneously and the mask is moved or rotated for lock-in demodulation. The paper says it does not discuss implementation practicalities in detail. [anchor: "recorded simultaneously corresponding to"]

## Relevance to the thesis

- Supports: G29 (structured illumination sections optically from several images, computational route needs about three phase-shifted images with accurately known shifts; wide-field gives none; confocal needs scanning) and G30 in a limited way (3D from a through-focus series of sections).
- Does not support: G24-G28 (no aberration treatment at all; ideal diffraction-limited system with defocus only). Not for any statement about light dose, photon efficiency, bleaching or acquisition time: the paper gives no light-budget or timing numbers, and its confocal comparison uses an ideal infinitely small pinhole. Not for "SIM is sensitive to aberrations". Not about light-field or multi-view imaging.

## Differences to state if cited

- Theory-only, 2010 review with no experiments; results are for an ideal system with a thin fluorescent sheet and equal excitation and emission wavelengths.
- Sectioning (rejecting out-of-focus light) is a different goal from aberration correction; the thesis method does neither sectioning nor depth recovery.
- Costs in images: confocal needs a scan over many points; computational structured illumination needs about three images per section (more for lateral resolution, not discussed); optical demodulation records two complementary images simultaneously. Light cost: not stated.

## Still unread

- Figures as images. Nothing else of the paper is unread.

## Safe Wording

Conventional wide-field fluorescence microscopy does not exhibit optical sectioning, confocal sectioning requires point scanning, and structured-illumination sectioning typically needs about three images recorded with accurately known pattern phases (Wilson, 2011, pp. 111-114).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Reserve for a definition or model of optical sectioning. Neil supplies the primary grid-based demonstration.
