# Tian 2015 - 3D intensity and phase imaging from light field measurements in an LED array microscope

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Lei Tian and Laura Waller, "3D intensity and phase imaging from light field measurements in an LED array microscope", Optica 2(2), 104-111, 2015. DOI printed on the paper: 10.1364/OPTICA.2.000104. No discrepancy with the metadata in the assignment.

## What was read

File C4c_10.txt (printed pp. 104-111), complete: abstract, Introduction, Methods (2A-2C), Experimental Results (3A-3C), Discussion, Conclusion and reference list; the title page and all text pages are present. Figures were not interpreted visually (only captions read). Supplement 1 (detailed axial-resolution analysis, simulations) is cited by the paper but was NOT read. The text file has some garbled equations (two-column interleaving); equation numbers are quoted from the text but the formulas themselves were not re-derived.

## Why This Matters

It is the closest "light-field plus phase retrieval" paper in the C4c set: it builds a 4D light-field-style data set in an LED-array microscope and then uses it for 3D intensity and phase recovery with Fourier ptychography. It shows concretely why a ptychographic approach needs coherent illumination, many sequential images and a transmissive (label-free) sample, which contrasts with a single-shot incoherent fluorescence method. It also shows where light-field refocusing, defocus and pupil-aberration estimation appear together.

## Key Claims (paraphrased)

- **Light-field data from an LED array (p. 105, Sec. 2A).** The LED array sits far enough above the sample that each LED acts as a spatially coherent plane wave from a unique angle. Turning LEDs on one after another while capturing images yields a 4D data set (two spatial, two angular variables) similar to a light-field measurement. [anchor: "every LED's illumination as a plane wave from a u"]
- **Sequential, not single-shot (p. 105, Sec. 2A; p. 107, Sec. 3).** The angular data are acquired by scanning LEDs in time, one image per LED. The camera runs at up to 100 frames per second at full frame, and longer exposures are used for dark-field images, so acquisition time is traded against image quality. No total acquisition time is stated. [anchor: "Sequentially turning on each LED in the 2D array"] [anchor: "capable of 100 frames per second"]
- **Number of images (p. 107 Sec. 3A; p. 110 Sec. 4).** The bright-field-only comparison uses a 69-LED circle at the array centre; the Spirogyra experiment uses 225 captured images to reconstruct 11 slices plus one pupil function. The authors say they always need significantly more data pixels than reconstructed pixels (about 10 times in that example). [anchor: "data set has 225 captured images"] [anchor: "always need to collect significantly more pixels of data than we"]
- **Light-field refocusing as depth cue and initial guess (p. 105, Sec. 2A; p. 107, Sec. 2C).** Features at different depths trace tilted lines in a space-angle plot, with slope set by depth; light-field refocusing undoes the geometric shift and sums over angles. It ignores diffraction, so lateral resolution in refocused images degrades with defocus. The authors use the refocused result as the initial guess of an iterative multislice reconstruction, which they describe as a diffraction correction for light fields. [anchor: "compensation for the geometric shift that occurs"] [anchor: "deteriorates due to unaccounted for diffraction"] [anchor: "our algorithm can be thought of as a diffraction correction"]
- **What is recovered (p. 104 abstract; p. 105 Sec. 2B; p. 108-109 Figs. 3-4).** The 3D complex transmittance (intensity and phase) of a thick sample, modelled as a stack of thin slices with multiply-and-propagate steps, with no weak or single-scattering approximation. Depth is therefore obtained through the multislice forward model plus angular diversity, not through a defocus series. Demonstrated on resolution targets at two depths (-55 and 55 um) and a 100 um thick Spirogyra sample in 11 slices. [anchor: "models the sample as a series of thin slices"]
- **Resolution gain and depth resolution (p. 108-110, Secs. 3B-3C).** Dark-field LEDs extend lateral resolution to the sum of illumination and objective NA (0.69 um with a 4x 0.1 NA objective, about five times the objective NA). Axial resolution improves less than lateral; for 0.25 NA objective and 0.41 illumination NA the predicted axial resolution is 5.4 um. The 3D transfer-function theory used assumes single or weak scattering. [anchor: "with the caveat that this theory assumes a single- or weak"]
- **Aberration handling (p. 107 Sec. 2C; p. 110 Sec. 4).** A pupil function that includes aberrations is estimated jointly with the sample by Fourier-ptychographic updates (citing Ou et al., ref. 40); the Spirogyra reconstruction solves for a single complex pupil function for digital aberration removal. No Zernike parametrization is stated in the text read. Whether the pupil varies across the field of view is not stated; reconstruction is done patch by patch and stitched, but per-patch pupils are not discussed. [anchor: "ction for digital aberration removal"]
- **Coherence (p. 105 Sec. 2A; p. 107 Sec. 3).** Illumination must be treated as coherent plane waves; with 120 um square LEDs at 74 mm the coherence area is about 400 x 400 um, so images are reconstructed in patches smaller than that and stitched. The sample is transmissive; the paper presents the method as label-free and stain-free. [anchor: "resulting in an illumination coherence"] [anchor: "The method is label-free and stain-free"]
- **Limitations stated (p. 108-110).** Resolution degrades away from focus in experiment, which the authors attribute to LED position miscalibration (accurate LED calibration is called crucial for higher magnifications). Iterative phase retrieval can stall in local minima; the light-field initial guess is said to help. Data requirements are only characterized empirically. [anchor: "We believe this error to be due to LED position"] [anchor: "provided by the light field result helps to avoid this problem"]
- **Thin vs thick samples (p. 104, Introduction).** Earlier angle-diversity phase methods assume a thin sample; for thick samples the angle-dependent data are tomographic. The paper claims to do both 2D phase and 3D recovery. [anchor: "All of these approaches assume a thin sample"]
- **Fluorescence (not stated).** The paper does not mention fluorescence emission, incoherent emission or fluorescence imaging in the text read.

## Relevance to the thesis

- Supports: G28 (Fourier ptychography recovers a high-resolution complex image from many low-resolution captures, estimates a pupil with aberrations numerically, and relies on coherent plane-wave illumination, sequential LED captures, and image patches within a coherence area). G30 (light-field refocusing and angular data used to recover depth/3D; defocus enters as the refocus distance and as the cause of diffraction-limited degradation). Also usable as a source that places light-field refocusing next to wave-optical phase retrieval.
- Does not support: any claim about fluorescence, incoherent emission or Fourier light-field microscopy (FLFM) with a microlens array; the "light field" here is built from sequential illumination angles, not from a single-shot detection-side multi-view capture. It does not support a claim that ptychography "cannot" be used for fluorescence (not discussed). It gives no spatially varying aberration correction and no statement about cost of deformable mirrors or deconvolution.

## Differences to state if cited

- Angular diversity is in the illumination (LED array), acquired sequentially; the thesis method uses detection-side views of a fluorescence scene in a single shot.
- Sample is a transmissive, coherently illuminated, mostly thin-to-moderately-thick object with a complex transmittance; the thesis scene is incoherent fluorescent emission.
- The reconstruction is a model-based iterative inverse problem (multislice forward model, pupil estimate); the thesis method is non-model-based global-then-local alignment and averaging.
- Aberration is a global pupil function estimate (per reconstruction), whereas the thesis assumes aberrations appear as local shifts between views.

## Still unread

- Supplement 1 (axial resolution analysis, simulations).
- Figure content beyond captions (Figs. 2-6 not visually inspected).
- Cited works (Ou 2014 embedded pupil recovery, Zheng 2013, Tian 2014) were not read.

## Safe Wording

Tian and Waller capture a 4D light-field-like data set by switching LEDs on one at a time under spatially coherent illumination, and use Fourier ptychography with a multislice model to recover 3D intensity and phase and a pupil function with aberrations (Optica 2(2), 104-111, 2015, pp. 105-107 and 110).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Keep for a comparison with angle-scanned 3D transmission imaging. Its use of light-field terminology does not make its measurements equivalent to fluorescence FLFM detection views.
