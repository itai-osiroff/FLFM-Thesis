# Ou 2014 - Embedded pupil function recovery for FPM

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

X. Ou, G. Zheng, C. Yang, "Embedded pupil function recovery for Fourier ptychographic microscopy", Optics Express 22(5), 4960-4972, 2014. DOI 10.1364/OE.22.004960 (printed in page footer). No discrepancy with the assignment metadata.

## What was read

C4c_08.txt, the whole paper (printed pp. 4960-4972, 13 PDF pages; title page present, text complete). Figures were not viewed, only captions and body text. No supplement is referenced. Note: the paper numbers two sections "5" (the second, "Comparison with original phase retrieval algorithm", is effectively Section 6 of its own outline), and the USAF resolution is printed as "~780um" (sic, evidently nm; 0.78 um is the value given in the Introduction).

## Why This Matters

Canonical example of numerical pupil (aberration) recovery jointly with the sample in FPM, a non-hardware computational route to aberration correction. It is a good citation for what FPM can do about aberrations and for the contrast with a single-shot incoherent method, since EPRY needs a sequence of captures under angled plane-wave illumination and a full pupil model.

## Key Claims (paraphrased)

- **Joint recovery (Abstract, p. 4960).** EPRY is an add-on to the FPM phase-retrieval algorithm that recovers the sample Fourier spectrum and the imaging-system pupil function together, removing the need for prior knowledge of the aberration. [anchor: "recover both the Fourier spectrum of sample and the pupil function"]
- **FPM acquisition model (Sec. 2, p. 4962).** A sequence of images is captured under plane-wave illumination from varying angles; each intensity image is the squared modulus of the sample spectrum, shifted by the illumination wavevector, times the pupil, inverse transformed. The PSF is taken as spatially invariant within the processed region. [anchor: "illuminating the sample with plane waves from varying angles"]
- **Model: full complex pupil P(u) (Eqs. 1, 3, 4, pp. 4962-4964).** The aberration is the whole pupil function (modulus and phase), updated by a gradient-like rule alternating with the sample-spectrum update, one captured image at a time, over several iterations. Initial guess is a circular low-pass filter (ones in the passband, zero phase). A constraint zeroes pupil values outside the physical aperture stop to suppress noise. [anchor: "updated pupil function and sample spectrum is extracted from this result"]
- **No parametric (Zernike) model in the fit (Sec. 3 pp. 4964-4965, Sec. 4 p. 4967, Sec. 5b p. 4971).** Earlier FPM used a pre-characterised pupil with only the lowest orders of Zernike polynomials; EPRY instead fits the entire pupil, and Zernike decomposition is applied only afterwards to interpret the recovered phase (first 30 modes; defocus and astigmatism dominant at the analysed spot). [anchor: "entire pupil function rather than focusing on just the lower orders"]
- **Spatially varying aberration handled by tiling (Sec. 5, p. 4968).** For a large FOV the aberration is expected to vary, so the FOV is cut into tiles (350 um x 350 um) where it is treated as constant; EPRY is run independently per tile, seeded with the neighbouring tile's recovered pupil, and the tile images are mosaicked. So the pupil model is spatially invariant within a tile and varies between tiles. [anchor: "segment the entire FOV into small tiles"]
- **Number of captures (Sec. 3 p. 4965; Sec. 4 p. 4967).** Simulation: 225 images, 100 iterations, with enough overlap in the Fourier domain for convergence. Experiment: 225 images from the centre 15 x 15 red LEDs, 5 iterations through all images. Colour: three such sets (R, G, B). [anchor: "captured a sequence of 225 images using the center 15 by 15"]
- **Hardware and illumination (Sec. 4, p. 4967).** Conventional microscope, 2X NA 0.08 objective, CCD camera, programmable colour LED matrix as the source; Wright-Giemsa stained blood smear, USAF target, pathology slide (thin samples, transmission). Coherence is not discussed explicitly; the model assumes plane-wave illumination. Fluorescence is not mentioned anywhere. [anchor: "a programmable color LED matrix as the light source"]
- **Results (Sec. 3-5, pp. 4965-4972).** Simulation: uncorrected FPM stalls at normalised error about 0.08, EPRY reaches under 0.01 for the spectrum and about 0.05 for the pupil. Experiment: blurry blood-cell image at 35% of FOV radius becomes sharp with EPRY. USAF: with EPRY group 9 element 3 resolved across the FOV (printed "~780um", sic), better than FPM with pre-characterised defocus and astigmatism. [anchor: "group 9 element 3 can be resolved"]
- **Other corrections obtained (pp. 4967, 4969).** Pupil shift reveals LED-matrix misalignment (wavevector error); defocus in the recovered pupil lets each colour channel be refocused (axial chromatic aberration corrected); lateral chromatic shift is corrected separately by cross-correlating channels; pupil shape becomes elliptical at the FOV edge because the 2X objective is not telecentric. [anchor: "axial chromatic aberration, which is caused by different wavelengths"]
- **Costs and limits stated (Intro p. 4961; Sec. 2 p. 4964; Sec. 5b pp. 4971-4972).** Earlier pre-characterisation is computationally onerous and sensitive to element movement; adaptive image-metric correction is computationally heavy and handles only a few low orders. EPRY's extra cost over FPM is stated as small (9n + 2n log n versus 5n + 2n log n per loop). Edge-of-FOV quality is lower because the synthesised spectrum is asymmetric and distortion makes the wavevector estimate imprecise. Fourier-domain overlap between captures is required. [anchor: "incremental computational cost of 4n is ignorable"]
- **Acquisition time (p. 4972).** The paper calls earlier pupil characterisation "time-consuming and laborious" and EPRY "less time consuming", but gives no acquisition or reconstruction times in seconds. Not stated numerically. [anchor: "time-consuming and laborious acquisition of pupil characterization data"]
- **Wider use claimed (Conclusion, p. 4972).** The recovered pupil could benchmark lens quality or guide correction optics; highly aberrated systems or ones without a clear aperture stop could now be used. [anchor: "characterize optical system aberrations for purposes beyond FPM"]

## Relevance to the thesis

- Supports: G28 in part. FPM recovers a high-resolution complex (modulus and phase) image from many low-resolution captures taken at different illumination angles (p. 4960 Abstract, p. 4962); the pupil aberration is estimated and removed numerically (Abstract, Sec. 2); many sequential captures are needed (225 per data set, p. 4967); spatially varying aberration is handled tile by tile (p. 4968). Also loosely supports the point that computational aberration correction in FPM needs a model of the image formation (pupil times shifted spectrum).
- Does not support: any statement that FPM or EPRY cannot work with fluorescence, or that it requires coherent illumination as such. The paper never mentions fluorescence, coherence or partial coherence; it only describes plane-wave LED illumination of thin transmissive samples. Cite another source for the incoherent-emission limitation. Also not a source for acquisition time in seconds, for light-field or multi-view imaging, or for defocus-based 3D (defocus appears only as one Zernike term and for per-channel refocusing; G30 marginal at best).

## Differences to state if cited

- Illumination-angle scanning with sequential captures versus a single snapshot of a Fourier light-field image.
- Plane-wave transmission imaging of thin samples versus incoherent fluorescence emission.
- Explicit full-pupil model estimated by iterative phase retrieval versus the thesis's non-model-based shift-based alignment of views.
- Pupil constant within each tile (350 um x 350 um) versus the thesis's per-pixel local displacement search.
- EPRY needs known illumination wavevectors (errors in them degrade the edge FOV, p. 4972) and Fourier-domain overlap between captures.

## Still unread

- Nothing in the text. Figures 1-6 were not inspected, only captions and body text. No supplement is mentioned.

## Safe Wording

Fourier ptychographic microscopy reconstructs a high-resolution complex image from a sequence of low-resolution images captured under angularly varied plane-wave illumination, and the embedded pupil function recovery extension estimates the system pupil aberration jointly with the sample, treating it as constant within tiles of the field of view (Ou et al., 2014, pp. 4962, 4968; 225 captures per data set, p. 4967).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Chapter 2 evidence for computational aberration estimation from redundant coherent measurements. The inferred quantity is a pupil function, distinct from image-domain displacements.
