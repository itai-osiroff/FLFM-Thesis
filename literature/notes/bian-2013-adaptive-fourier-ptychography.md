# Bian 2013 - Adaptive system correction for Fourier ptychography

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Zichao Bian, Siyuan Dong, Guoan Zheng, "Adaptive system correction for robust Fourier ptychographic imaging", Optics Express 21(26), 32400-32410, 2013. DOI 10.1364/OE.21.032400 (printed on the paper). Received 14 Oct 2013, published 20 Dec 2013 (issue date 30 Dec 2013). No discrepancy with the assignment metadata.

## What was read

C4c_01.txt, all 11 PDF pages (printed pp. 32400-32410), abstract through conclusion plus figure captions. Figures were not inspected as images. No supplement mentioned.

## Why This Matters

Primary source for the statement that FP can estimate and remove pupil aberration of the objective numerically, by optimizing an image-quality metric, with no adaptive-optics hardware. It also shows what the correction is limited to: coherent, many-image, brightfield-type FP data and a small low-order parametric pupil.

## Key Claims (paraphrased)

- **FP data and illumination (Sec. 1, p. 32401; Sec. 2, p. 32403).** FP uses a fixed LED array as partially coherent sources; one low-resolution intensity image is recorded per LED, and the images are stitched in Fourier space into a high-resolution complex (amplitude and phase) image. The simulation uses a 15x15 LED matrix, 225 images; the experiment geometry is said to be similar (number of experimental images not stated in this paper). [anchor: "fixed LED array is used as partially coherent light sources"]
- **Which errors are corrected (abstract, p. 32400).** Two systematic sources are named: LED intensity fluctuation and pupil aberration of the optics. A third set of unknown system parameters is also recovered. [anchor: "intensity fluctuation of multiple LED elements and the pupil aberrations"]
- **Method: metric plus search (Sec. 2, Eq. 1, pp. 32403-32404).** Borrowing from adaptive optics and phase retrieval, the method defines a "convergence index" comparing the intensity images predicted from the reconstruction with the measured ones, and adjusts system parameters until that index is maximized. The authors argue against a sharpness metric because unmodelled aberrations can produce sharp but false features. [anchor: "FP reduces the optical system to a complex transfer function"]
- **Software-only correction (Sec. 2, p. 32403).** The paper notes conventional AO needs a wavefront sensor plus a deformable mirror, or an image-quality metric as guide star if no sensor exists; in FP the correction is purely computational and needs no adaptive optical component. [anchor: "no adaptive optical component is needed"]
- **Intensity correction (Sec. 3, pp. 32404-32407).** A per-LED correction factor (ratio of sums of predicted to measured intensity) is updated each iteration until its standard deviation drops below 0.01, typically 5-10 iterations. Authors observed about 40% intensity drift for some LEDs over several hours. Tested in simulation (up to 200% drift) and on a breast pathology slide with a 2X, 0.08 NA objective without calibrating LED intensity. [anchor: "we observe ~40% intensity drift for certain LED elements"]
- **Pupil aberration (Sec. 4, pp. 32407-32408).** The pupil is modelled with three second-order Zernike modes (three parameters), found by Generalized Pattern Search maximizing the convergence index. Shown on a USAF target (group 9, element 3, 0.78 um line width resolved with correction) and on a blood smear. The recovered pupil is a single function for the reconstruction, not a field-dependent map. [anchor: "We use three Zernike modes (i.e., three unknown parameters)"]
- **Field dependence acknowledged but not solved here (Sec. 1, p. 32402).** The paper states field-dependent pupil aberrations of the low-NA objective must be characterized in recovery, citing earlier work [27]. The adaptive scheme in this paper fits one global pupil. [anchor: "field-dependent pupil aberrations of the objective lens need to be characterized"]
- **Other parameters recovered (Sec. 5, pp. 32408-32410).** By scanning the convergence index: sample defocus distance (recovered -150.1 um versus actual -150 um), LED matrix position (85.0 mm versus 85.0 mm independent measurement), and central LED wavelength (635.0 nm versus 635.2 nm). Individual LED angles or positions are not corrected; "LED position" means the distance of the whole matrix. [anchor: "corresponds to a defocused distance of -150.1"]
- **Defocus use (Sec. 5, pp. 32408-32409).** Sample defocus is treated as an unknown parameter in the pupil transfer function; the authors suggest finding it per image segment for samples on curved surfaces. It is used for refocusing a thin sample, not for recovering 3D structure. [anchor: "we can model the sample defocus in the pupil transfer function"]
- **Stated limits (Sec. 1, Sec. 6).** Any modification of the FP setup may need new calibration; authors list recovering the full coherent transfer function by a difference map as future work. Optimization is nonlinear and large intensity drift needs more iterations (Fig. 4 caption). Cost of the pupil search in run time is not stated. [anchor: "may require a new calibration process"]

## Relevance to the thesis

- Supports G28: FP estimates and removes pupil aberration numerically (three Zernike modes, one global pupil), and corrects LED intensity drift, with no hardware. Also supports that FP needs many sequential captures (225 simulated; scanned LED array) and partially coherent illumination.
- Supports G26 only as a contrast: the paper describes AO as wavefront sensor plus adaptive element, and notes sensorless image-metric feedback when no sensor is available (the Ji 2010 caveat applies equally here).
- Supports G30 only weakly: defocus distance is recovered by through-parameter search, not by through-focus image stacks.
- Does not support: any claim about fluorescence (the paper is brightfield-type, coherent, with 632-635 nm LEDs); any claim that the correction is spatially varying; light-field or single-shot use; a statement that FP is "inapplicable" to fluorescence (this paper does not say that; Dong 2014 does).

## Differences to state if cited

- Needs coherent or partially coherent illumination, a sequence of LED captures, and an iterative phase-retrieval forward model; the thesis method is a single-shot incoherent capture with no pupil model.
- Aberration is a low-order parametric pupil (3 Zernike modes) shared across the field, whereas the thesis models aberration as local view-to-view shifts.
- LED position correction is of the whole array, not per LED.

## Still unread

- Figures as images (only captions and text read). Cited papers (e.g. Ou 2014 embedded pupil recovery, Zheng 2013 spatially varying aberrations) not read.

## Safe Wording

Fourier ptychography can estimate a low-order pupil aberration of the objective (three second-order Zernike modes) and LED intensity errors purely computationally, by maximizing an image-consistency metric over many sequentially captured images, without adaptive optical hardware (Bian et al. 2013, Sec. 4, pp. 32407-32408).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use if Chapter 2 discusses FPM calibration or compares optimization objectives. These are system parameters in an angle-illuminated coherent acquisition.
