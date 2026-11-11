# Scrimgeour 2012 - Segmented-pupil image interferometry for wide-field fluorescence

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

J. Scrimgeour and J. E. Curtis, "Aberration correction in wide-field fluorescence microscopy by segmented-pupil image interferometry", Optics Express 20(13), 14534-14541, 2012 (published 14 Jun 2012; issue dated 18 June 2012). The DOI is not printed on the extracted pages (the footer shows only "#165852"). No discrepancy with the metadata given in the assignment, except that the DOI could not be confirmed from the paper text.

## What was read

File C4a_13.txt, the full paper (printed pp. 14534-14541: abstract, reference list, Introduction, Methods, Results and discussion 3.1-3.3, Conclusions). Figures were not viewed as images; only their captions were read. No supplement is mentioned. The file has some undecodable characters (symbols such as lambda and theta are lost in the extraction), which does not affect the passages used below.

## Why This Matters

This is a wide-field fluorescence precedent for the idea that image displacement between pupil-segment images reports local wavefront tilt. It segments the pupil with an SLM, measures the registration shift of each segment image against a central reference by normalized cross correlation, and corrects it in hardware. It is therefore the closest hardware counterpart to the thesis assumption, but it corrects a pupil-plane wavefront with a single static SLM pattern, whereas the thesis aligns the views computationally and per pixel.

## Key Claims (paraphrased)

- **Principle (p. 14534, Abstract).** Wavefront distortion from system or sample aberrations displaces the images formed by the individual pupil segments. Analysing the registration lets the local wavefront tilt at each segment be corrected relative to a central reference. [anchor: "displacement of the images formed from the individual pupil segments"]
- **Segmentation (p. 14536, Sec. 3.1).** A liquid crystal SLM in the pupil plane is divided into 25 segments in a 5-by-5 array. Segments are normally "off" (a high-frequency grating deflects their light out of the camera field of view) and are switched "on" one at a time with a constant phase. [anchor: "25 individual segments arranged in a 5-by-5 array"]
- **Displacement measurement (p. 14537, Sec. 3.1).** Images are collected one segment at a time. Each probe-segment image is registered against the central reference-segment image with a normalized cross correlation (MatLab), after subtracting a background image with all segments off. The objects imaged are fluorescent microspheres (0.5 um) and BPAE cells (Methods, p. 14536); the paper does not say which sample was used for the tilt calibration beyond the microsphere phase-series example in Fig. 2. [anchor: "normalized cross correlation (MatLab)"]
- **Tilt equals image shift (p. 14537, Sec. 3.1).** Tilt in the wavefront at a probe segment appears as a physical shift of the image position on the camera relative to the reference-segment image. [anchor: "detected as a physical shift, or registration error"]
- **Reference segment (pp. 14536-14537, Sec. 3.1).** The central segment is the reference because it is the brightest and, the authors assume, the least likely to be aberrated, being on axis. [anchor: "it is the brightest"]
- **Tilt correction step (p. 14537, Sec. 3.1).** A detected shift is corrected by applying a suitable grating function to that segment on the SLM, and a second image is acquired to confirm the registration error is removed. [anchor: "grating function to the segment corresponding to that particular"]
- **Second step, phase (pp. 14537-14538, Sec. 3.2).** Tilt correction alone is not enough. A series of constant phase shifts is applied to each probe segment and the interference with the reference image is used to find the phase that gives constructive interference. Three metrics are compared; the third (peak of the normalized cross correlation against the reference image) was used because it was most reliable with large intensity differences between segments. [anchor: "the third metric as it proved to be more reliable"]
- **Whole-image analysis, no object knowledge (pp. 14538-14539, Sec. 3.2).** Metrics 2 and 3 need no prior knowledge of the object geometry; metric 1 (intensity at a microsphere centroid) needs a discrete tracer and is noise-sensitive. Fringe visibility and low light force whole-image analysis rather than a point or area analysis. [anchor: "do not require any a priori knowledge of the imaged object's geometry"]
- **Cost and speed (p. 14539, Sec. 3.3).** The full correction took about 2 minutes, of which 20 seconds was image capture for 400 images, 40 seconds was a conservative SLM update allowance, and the rest was MatLab processing and camera triggering overhead. [anchor: "only 20 seconds of which was used to capture the 400 images"]
- **Light-level limits (p. 14536 Sec. 3.1; p. 14539 Sec. 3.3; p. 14541 Conclusions).** Fluorescence is dim, the pupil intensity is roughly Gaussian, and the SLM sees a range of wavelengths. Peripheral segments can be as dim as the background, and the corner segments were too dim for a meaningful correction. The authors say a uniform square grid cannot simply be extended to more segments. [anchor: "the intensity falling on the corner segments is so low"]
- **Result, aberrations corrected (p. 14540, Sec. 3.3).** The main aberration was the curvature of the SLM's own silicon backplane (a system aberration), seen as astigmatism in through-focus series. With SPII, most of that asymmetry disappeared and the best-focus plane shifted by about 200 nm. [anchor: "astigmatism present in the case of no applied correction"]
- **Result, numbers (p. 14540, Sec. 3.3).** Compared with the SLM's factory correction as benchmark, microsphere peak intensity was 78 +/- 2% uncorrected and 89 +/- 3% with SPII. Line-profile FWHM was 5.8 +/- 0.2, 4.4 +/- 0.1 and 4.1 +/- 0.1 pixels for no correction, SPII and factory correction (105 nm per pixel). SPII is 107% of the factory FWHM versus 141% uncorrected. [anchor: "returns the microsphere's intensity to 89"]
- **Incomplete correction (p. 14541, Conclusions).** SPII did not give full correction relative to the factory correction. Only system aberrations were corrected; sample-induced aberrations are discussed only as a possible extension ("can be applied" to heterogeneous tissue), not demonstrated. [anchor: "performed well but did not provide full correction of the"]
- **Cells (p. 14541, Fig. 5).** BPAE cell actin images show improved contrast and lower background after correction; the paper reports this qualitatively. [anchor: "reduction in the background signal"]
- **Relation to earlier work (p. 14535, Introduction).** Segmented-pupil recentring of sub-aperture images originated in astronomy (refs 2, 3). Hardware AO is described as wavefront detection (ref 4, Hartmann-Shack, Liang 1994) combined with SLMs or deformable mirrors. The paper positions SPII against laser-based segmented-pupil methods including Ji 2010 (ref 12), noting that its on/off segment convention is the reverse of those methods. [anchor: "wavefront detection [4]"]

## Relevance to the thesis

- Supports: G26 only partly. The paper describes hardware AO as wavefront detection (citing a Hartmann-Shack sensor) with an SLM or deformable mirror (p. 14535, Introduction), and itself uses an image-registration-based measurement with an SLM corrector, i.e. an indirect scheme without a separate wavefront sensor. It supports the premise that shifts between pupil-segment images encode local pupil tilt (Abstract, Sec. 3.1), and that segment images are registered by normalized cross correlation. It also supports G24 modestly (aberrations from system or sample degrade fluorescence imaging, p. 14534 Abstract; p. 14535 Introduction).
- Does not support: G25 (nothing on software PSF estimation, deconvolution, cost or noise amplification). G27: the paper does not state that deformable mirrors are expensive or complex, and does not discuss spatially invariant versus spatially varying correction. It does not support any claim of field-dependent (spatially varying) aberration correction, and does not support correcting sample-induced aberrations (not demonstrated). Not a source for G30 beyond using through-focus series to show astigmatism (Fig. 4b), which is a visual check, not a measurement method. Field of view is not stated.

## Differences to state if cited

- Hardware correction: an SLM in the pupil plane applies a tilt grating and a constant phase per segment. The thesis does no hardware correction, only computational alignment after capture.
- Sequential, one segment at a time (plus a reference), about 400 images and about 2 minutes. The thesis uses a single Fourier light-field capture containing all views at once.
- Light loss: all segments except reference and probe are switched off, and dim peripheral segments cannot be used. The thesis uses all sub-aperture views simultaneously.
- Tilt is a single shift per segment from correlation of the whole image, giving one static pupil-plane kinoform for the whole field. A spatially varying (per-pixel) displacement field is not measured or discussed. The paper never says whether the measured tilt is local in the field; its "local" refers to local in the pupil (per segment). The extent of the field of view is not stated.
- Demonstrated only for system aberration (the SLM backplane curvature) with 0.5 um microspheres and fixed cells, with 5-by-5 segmentation. Sample-induced aberration was not demonstrated.
- Includes a second phase-stepping interference step, which has no counterpart in the thesis method.
- Does not cite or mention Shack-Hartmann as a comparison for its own method beyond the Introduction's citation of a Hartmann-Shack sensor as the wavefront detector in AO (ref 4). Relation to Ji 2010 is stated only as in the previous section.

## Still unread

- Figures as images (Figs. 1 to 5); only captions read.
- The DOI is not visible in the extracted text.
- No supplementary material is cited.

## Safe Wording

Scrimgeour and Curtis segmented the pupil of a wide-field fluorescence microscope with a liquid-crystal SLM into a 5-by-5 array, measured the image displacement of each segment against a central reference by normalized cross correlation, and removed it with a per-segment grating, followed by a phase-stepping step (Opt. Express 20(13), 14534-14541, 2012, Secs. 3.1-3.2).
