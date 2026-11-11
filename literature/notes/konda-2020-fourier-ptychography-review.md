# Konda 2020 - Fourier ptychography review

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

P. C. Konda, L. Loetgering, K. C. Zhou, S. Xu, A. R. Harvey, R. Horstmeyer, "Fourier ptychography: current applications and future promises", Optics Express 28(7), 9603-9630, 2020 (Review Article). DOI printed: 10.1364/OE.386168. Discrepancy with the assignment metadata: Rodenburg is not an author on the printed title page; the authors are Konda, Loetgering, Zhou, Xu, Harvey, Horstmeyer.

## What was read

File C4c_06.txt, all 28 PDF pages (printed pp. 9603-9630). Main text pp. 9603-9623 read in full; references (pp. 9624-9630) skimmed only for the entries cited below. Figures (1-13) not viewed, only captions read. No supplement in the file.

## Why This Matters

A review that defines Fourier ptychography (FP), states its coherence requirement, its sequential multi-image acquisition, and its pupil (aberration) recovery. It also says that the basic FP microscope was not built for fluorescence and that FP-derived aberrations are used to deconvolve separately acquired fluorescence images. Good single source for G28.

## Key Claims (paraphrased)

- **FP definition (p. 9603, Sec. 1).** FP captures several intensity images and synthesizes a high-resolution complex sample estimate (absorption and phase) in the Fourier domain, solving for phase by an iterative algorithm instead of a reference beam. [anchor: "solves for the missing phase with an iterative reconstruction algorithm"]
- **Acquisition (pp. 9605-9606, Sec. 2.1-2.2, Fig. 1 caption).** An LED array under a thin sample illuminates it from one angle at a time; one image per angle with a low-NA objective; each tilt shifts the sample spectrum across the lens pupil. [anchor: "turned on time-sequentially and one image is captured per illumination angle"]
- **Not fluorescence (p. 9605, Sec. 2.1).** The first FP microscope was not set up for fluorescence; it imaged with the same light that illuminated the sample. [anchor: "not outfitted to image fluorescence"]
- **Coherence requirement (p. 9611, Sec. 3, bullet list).** An FP/ptychographic system is defined as having partially or substantially coherent illumination. [anchor: "illumination source is either partially or substantially coherent"]
- **Partial coherence handling (pp. 9610-9611, Sec. 2.7 item 6).** LEDs are partially coherent; the FOV is split into segments smaller than the spatial coherence length and processed independently. [anchor: "LEDs commonly used for illumination in FP are partially coherent"]
- **Thin-sample assumption (p. 9611, Sec. 2.7 item 9).** The standard forward model assumes a thin sample (projection approximation); deviations can fail the reconstruction. [anchor: "standard FP forward model assumes a thin sample"]
- **Redundancy and number of images (p. 9607, Sec. 2.4; p. 9609, Sec. 2.6).** Spectrum shift is set to a bit under half the aperture, so at least 2N measurements are needed for N reconstructed pixels, often 3N or more; overhead 2-3X at least. [anchor: "at least 2N measurements with the image sensor"]
- **Speed (p. 9617, Sec. 4.4).** Sequential LEDs, long dark-field exposures and redundancy give acquisition times of a few seconds to minutes. [anchor: "few seconds to minutes"]
- **Speed-up routes (pp. 9617-9619, Sec. 4.4).** LED multiplexing and sparsity reduce redundancy; single-shot FP exists (diffractive grating; a light-field-like configuration with LED multiplexing) but trades FOV or resolution and cannot increase SBP; multi-camera parallel systems. [anchor: "inherently tradeoff either the image FOV or resolution, or both"]
- **Aberration recovery (p. 9616, Sec. 4.3).** Embedded pupil recovery (EPRY, ref. 31) estimates the lens coherent transfer function a(fx,fy) from a standard FP data set and corrects it during reconstruction; used with badly aberrated lenses (moldless, phone lens). [anchor: "embedded pupil recovery (EPRY)"]
- **Spatially varying aberration (p. 9616, Sec. 4.3).** FP only partially handles shift-variant aberrations, by dividing the FOV into small segments and recovering a pupil per segment. [anchor: "FP can partially account for shift-variant aberrations"] Also p. 9612, Sec. 3.1.2: the segmentation allows spatially varying aberration correction, not demonstrated in ptychography.
- **Aberration limits (p. 9617, Sec. 4.3).** EPRY is nonlinear and can hit local minima or stagnate if aberrations are severe; remedies: good initialization (e.g. ray tracing), differences between adjacent segments, or a Zernike-coefficient full-field model (ref. 127). [anchor: "can suffer from local minima and stagnation"]
- **Aberrations to deconvolve fluorescence (p. 9616, Sec. 4.3; Fig. 9b p. 9617; p. 9613, Sec. 3.1.3).** Aberrations recovered by FP can be applied to deconvolve simultaneously acquired fluorescence images (refs 24, 93); the fluorescence image is a separate channel, while FP itself runs on the coherent channel. [anchor: "deconvolve simultaneously acquired fluorescence images"]
- **FP and SIM (pp. 9613-9614, Sec. 3.2).** SIM is typically incoherent and fluorescence-based; FP can be viewed as coherent structured illumination. FP algorithms were extended to patterned intensity illumination in fluorescence (ref. 102) and to speckle illumination. [anchor: "patterned intensity-modulation in fluorescence microscopy"]
- **Light-field relation (p. 9618, Sec. 4.4; Table 1 p. 9604).** Only a mention: single-shot FP with a light-field-like configuration plus LED multiplexing (ref. 45); Table 1 lists "light field" among 3D novel hardware. No comparison with light-field microscopy. [anchor: "similar to a light-field imaging setup"]
- **3D (pp. 9619-9620, Sec. 4.5).** 3D extension is intensity diffraction tomography (first Born, Rytov, multislice); the missing-cone problem limits axial resolution; multiple scattering is an open modelling problem. [anchor: "missing cone problem"]
- **Limitations and open challenges (pp. 9609-9611, Sec. 2.6-2.7; p. 9623, Sec. 4.8).** Calibration burden (stray light, LED position and intensity, dynamic range, pupil, approximations; correction algorithms mostly mutually exclusive); exact SBP measurement is an open problem; limited use for new scientific discovery so far. [anchor: "Most of these algorithms are mutually exclusive"]

## Relevance to the thesis

- Supports G28: FP definition (p. 9603); many sequential captures (Sec. 2.2, 2.4, 2.6, 4.4: 2N-3N images, seconds to minutes); coherent or partially coherent illumination as a defining property (Sec. 3); numerical pupil/aberration recovery (EPRY, Sec. 4.3); the basic FP microscope was not a fluorescence microscope (Sec. 2.1); FP-recovered aberrations used to deconvolve fluorescence images (Sec. 4.3).
- Supports a contrast statement: single-shot FP exists but loses FOV or resolution (Sec. 4.4).
- Does not support: "FP cannot be applied to fluorescence at all" (the review cites pattern-illuminated FP for fluorescence, ref. 102, and FP-derived aberrations for fluorescence deconvolution; only the basic LED-array FP is coherent and non-fluorescent). Does not support any claim about light-field microscopy, Fourier light-field microscopy, or Shack-Hartmann/AO comparison (AO is named only as a possible future use, p. 9617).

## Differences to state if cited

- FP recovers a complex (amplitude and phase) object from intensity images of a thin, coherently illuminated sample; the thesis recovers an incoherent 2D fluorescent intensity image.
- FP uses a pupil/transfer-function model (or Zernike) and iterative phase retrieval; the thesis uses neither, only view alignment by shifts.
- FP corrects aberrations per FOV segment (piecewise shift-variant); the thesis does a per-pixel bounded displacement search.
- FP is sequential (seconds to minutes); the thesis is single-shot. The review's own single-shot FP examples lose FOV or resolution.

## Still unread

- All figure content (only captions read); the cited papers (refs 24, 31, 45, 93, 102, 127 seen as titles only).
- Details of ref. 24 (fluorescence deconvolution with FP aberrations) and ref. 102 are not in this review.

## Safe Wording

Fourier ptychography reconstructs a high-resolution complex image from many low-resolution intensity images taken sequentially under different illumination angles with partially or substantially coherent light, and can recover the pupil aberration of the imaging lens from the same data (Konda et al. 2020, Secs. 2 and 4.3, pp. 9605-9616); acquisition takes seconds to minutes (Sec. 4.4, p. 9617).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Chapter 2's one FP overview if needed. Use Zheng, Ou and Chung as primary evidence for their respective demonstrations.
