# Zheng 2013 - Wide-field, high-resolution Fourier ptychographic microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Guoan Zheng, Roarke Horstmeyer, Changhuei Yang. "Wide-field, high-resolution Fourier ptychographic microscopy". Nature Photonics 7(9), 739-745, 2013 (published online 28 July 2013; corrected after print 30 July 2015). DOI 10.1038/NPHOTON.2013.187 (printed on the paper). No discrepancy with the assignment metadata (volume 7, pp. 739-745, 2013, DOI). The file also contains the 2015 corrigendum (last PDF page, unnumbered), which changes the resolution definition (see below).

## What was read

File C4c_12.txt, complete: all 8 PDF pages (printed pp. 739-745 plus the corrigendum page), including Methods and reference list. The text extraction turns the micro sign into "mm" in places (e.g. "0.78 mm" means 0.78 um; "120 mm2" is mm^2 in the abstract; "80 mm" depth of focus is 80 um; "0.3 mm" depth of focus is 0.3 mm = 300 um, "150 mm" defocus is 150 um); numbers below are interpreted accordingly and the corrigendum text confirms the 0.78 um / 1.56 um reading. NOT read: the Supplementary Information (Notes S1-S4, Figs S1-S9, Movie S1); anything the main text defers to it (computational cost, simulations, aberration characterization procedure, FOV validation) is unread. Figures were interpreted only through their captions.

## Why This Matters

Founding paper of Fourier ptychographic microscopy. It is the canonical example of a computational method that recovers a high-resolution complex image from many low-resolution captures and that estimates and removes pupil aberration numerically. It also states explicitly that it is not a fluorescence technique, and it contrasts itself with light-field microscopy, which makes it directly useful for positioning the thesis against FPM.

## Key Claims (paraphrased)

- **Principle (p. 739, abstract; p. 740 Principle of FPM).** FPM iteratively stitches many variably illuminated low-resolution intensity images together in Fourier space to produce a wide-field, high-resolution complex (amplitude and phase) image. The recovery alternates between spatial and Fourier domains, following phase-retrieval ideas. [anchor: "iteratively stitches together a"]
- **Data collection and illumination (p. 739-740).** A two-dimensional sample sits at the focus of a low-NA objective; N images are collected while the sample is lit in turn by plane waves from N different angles. Only intensities are recorded, no interferometric or phase measurement. [anchor: "successively illuminated by plane waves at N different"]
- **Setup and number of images (p. 742 Experimental set-up; p. 744 Methods).** Olympus BX 41 microscope, 2x apochromatic objective (0.08 NA), Kodak KAI-29050 interline CCD (5.5 um pixels), and a programmable colour LED matrix 8 cm below the sample stage (32 x 32 LEDs, 4 mm pitch). 137 LEDs were used for the 0.5 synthetic NA reconstruction, with about 65% spectrum overlap between neighbouring LED regions. [anchor: "we used 137 LEDs for illumination"]
- **Coherence (p. 744, Methods; p. 740).** Each LED is treated as an approximately spatially coherent quasi-monochromatic source (centre wavelengths 632, 532, 472 nm; bandwidth 20 nm). The model treats an oblique plane wave on a thin sample as a shift of the sample spectrum, with a coherent transfer function that is a circular pupil. [anchor: "approximately spatially coherent"]
- **Acquisition time (p. 744, Methods).** Long exposures were needed because of weak LED intensity; the central 49 LEDs were each imaged at three exposure times (0.005, 0.1, 0.5 s) and the others at two (0.1, 0.8 s) for HDR. Total acquisition time of the prototype was 3 minutes. The authors project several seconds for a gigapixel image with a 53 fps camera and brighter LEDs (a projection, not a demonstration). [anchor: "total acquisition time for the current prototype was 3 min"]
- **Resolution, FOV, SBP (p. 739 abstract; p. 741-743; p. 745 corrigendum).** Reported: 0.78 um half-pitch resolution at synthetic NA 0.5, field of view 120 mm^2, depth of focus 0.3 mm, characterized at 632 nm; SBP 0.23 gigapixels. The 2015 corrigendum states the originally reported resolution was half-pitch and that full-pitch resolution (1.56 um) is the better definition; SBP is defined with full pitch. Raw data pixel 2.75 um at the object, reconstructed pixel 0.275 um. The USAF target group 9 element 3 was resolved. [anchor: "full-pitch resolution offers a better definition of the imaging sys-"]
- **Computation time (p. 744, Methods).** Reconstruction is done per 150 x 150 pixel segment (to 1,500 x 1,500) in about 1.5 s each in Matlab on an i7 CPU without GPU; total about 10 min for the full FOV; colour multiplies acquisition and processing time by 3. [anchor: "total processing time for creating a final"]
- **Aberration recovery / correction (p. 741 Digital wavefront correction; p. 742).** A digital pupil function (a phase map, inspired by adaptive optics) is inserted in two multiplication steps of the iteration to model aberrations and invert them, giving an aberration-free reconstruction. Defocus is treated as a defocus aberration phase on the pupil (Eq. 1). In the main text the pupil phase is imposed with a known defocus distance; if unknown, z is scanned and the sharpest result is chosen. The paper only says that pupil-function recovery by modified ptychographic iterations is a topic for future publication; characterization procedure is deferred to Supplementary Note S4 (unread). [anchor: "digitally introduce a phase map to our coherent optical transfer"]
- **Global vs spatially varying (p. 742; p. 744).** The paper states it corrects spatially varying aberrations of the objective by dividing the FOV into small segments, each reconstructed independently and assignable its own aberration-correcting pupil function (the method section also uses a per-segment illumination wavevector). [anchor: "Each small portion can be assigned a specific aberration-correcting"]
- **Depth of focus (p. 741-742).** Natural depth of focus of the 0.08 NA objective is 80 um; with digital wavefront correction the prototype reaches a resolution-invariant 0.3 mm, demonstrated for a target defocused by 150 um (known defocus). Tilted samples can be handled by choosing z per region. [anchor: "resolution-invariant depth of"]
- **Relation to light-field microscopy (p. 741).** The paper compares FPM with a microlens-array light-field microscope: both capture multiple perspective views corresponding to small sub-apertures of the pupil. Three differences are listed: FPM records larger scattering angles; the light-field microscope sacrifices spatial resolution to take all views in one snapshot while FPM acquires views over time; and the light-field microscope uses spatial-angular information for refocusing in 3D while FPM uses it to raise the 2D resolution. The paper adds that an FPM data set of a 3D object can be processed like a light-field microscope to refocus and render 3D. [anchor: "light-field microscopes sacrifice spatial resolution to acquire all perspective"]
- **Fluorescence (p. 744 Discussion).** The authors state FPM is not a fluorescence technique because fluorescent emission is unchanged under angle-varied illumination. They only believe patterned illumination might allow a fluorescence variant (speculation). [anchor: "not a fluorescence technique, as fluorescent emission profiles"]
- **Sample assumption (p. 744 Discussion).** The method assumes effectively two-dimensional (thin) samples; extended samples are left to possible future variants. [anchor: "that samples are effectively two-dimensional"]
- **Stated limitations (p. 744 Discussion).** Imaging speed is limited by weak edge-LED intensity; the prototype is not optimized for speed; overlap of at least about 65% between spectral regions is needed for convergence; more accurate back-aperture (pupil) characterization is wanted; the method works if the pupil function is accurately characterized ("known aberrations" wording). [anchor: "requires an overlap of the Fourier-domain"]

## Relevance to the thesis

- Supports: G28 in part. FPM recovers a high-resolution complex image from many low-resolution captures (N = 137 here, about 3 min acquisition); it numerically estimates and removes pupil aberration (a pupil phase factor, incl. defocus; segment-wise so it can vary over the field); it needs coherent illumination (spatially coherent quasi-monochromatic LEDs) and sequential acquisition; and the authors themselves say it is not a fluorescence technique. G30 in part: defocus is modelled as a pupil aberration and corrected numerically (known or searched z), extending depth of focus. Also supports the contrast with single-shot light-field imaging (resolution cost of snapshot capture; FPM trades time for resolution).
- Does not support: any claim that FPM works with incoherent fluorescence emission or has been demonstrated on fluorescence (the paper says the opposite and offers only a speculation). Does not support a claim that FPM is a PSF-estimation/deconvolution method (it is phase retrieval on a pupil model). Does not support quantitative claims about aberration estimation accuracy (main text gives no aberration-estimation result beyond defocus with known z; Zernike modes are not mentioned in the main text). Do not cite the 0.78 um as "resolution" without the half-pitch qualification (corrigendum).

## Differences to state if cited

- FPM: many sequential intensity captures (137 here) under coherent angle-varied illumination, transmission geometry, thin 2D sample, iterative phase retrieval with an explicit pupil function; the thesis method: single shot, incoherent fluorescence, sub-aperture views from a Fourier light-field microscope, shifts estimated by cross-correlation and local displacement search, no pupil or wavefront model.
- FPM obtains views by changing the illumination angle over time; a Fourier light-field microscope obtains views simultaneously by splitting the pupil. The paper itself describes the light-field microscope as the snapshot, resolution-sacrificing counterpart.
- FPM aberration correction needs the pupil model (known or searched parameters) and the paper deferred general pupil recovery to future work (as of 2013); later FPM papers are not covered by this note.

## Still unread

- Supplementary Notes S1-S4 and Figs S1-S9, Movie S1 (computational cost, simulations, sampling, aberration characterization procedure, FOV validation).
- Figure content beyond captions.

## Safe Wording

Fourier ptychographic microscopy recovers a high-resolution complex image from many low-resolution images taken under different coherent illumination angles (137 LEDs, about 3 min acquisition in the original prototype) and corrects pupil aberrations, including defocus, numerically, but its authors state that it is not a fluorescence technique (Zheng et al. 2013, p. 744; Methods p. 744).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Primary source for introducing classical FPM in Chapter 2. Use Ou for joint unknown-pupil recovery and Chung for fluorescence deconvolution.
