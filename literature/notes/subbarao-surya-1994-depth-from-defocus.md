# Subbarao 1994 - Depth from defocus, spatial domain approach (STM)

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Murali Subbarao and Gopal Surya, "Depth from Defocus: A Spatial Domain Approach", International Journal of Computer Vision, 13(3), 271-294, 1994 (Kluwer Academic Publishers; received December 15, 1992, revised May 6, 1993 and October 1993). No DOI is printed on the pages. No discrepancy with the metadata given in the assignment.

## What was read

C4e_35.txt, the whole file: printed pp. 271-294 (abstract, Sections 1-7, references). Complete, 24 pages. Figures 1-21 are scanned plots and images; captions and axis labels were read, plot contents were not interpreted beyond what the text states. The file is not valid UTF-8 and OCR garbles equations; formulas were not independently checked, only the surrounding prose.

## Why This Matters

A representative depth-from-defocus (DFD) paper outside microscopy. It shows that depth can be computed from two differently defocused images with local spatial-domain operations, and states clearly what is assumed (known camera model, planar fronto-parallel patch, textured scene, calibration). It is a fallback source for G30 (defocus images used to recover depth). Nothing on microscopy or aberration measurement.

## Key Claims (paraphrased)

- **What the method needs (p. 271, abstract).** Only two images taken with different camera parameters (lens position, focal length, or aperture diameter); neither has to be in focus, so no search for best focus is needed. [anchor: "requires only two images taken"]
- **Arbitrary blur allowed (p. 271).** Both images may be arbitrarily blurred. [anchor: "can be arbitrarily blurred"]
- **Contrast with depth-from-focus (p. 271).** Depth from focus searches camera settings and needs about 10-12 images, with mechanical motion between exposures during which the scene must remain stationary; DFD needs about 2-3 images. [anchor: "scene must remain stationary"]
- **Image formation model (pp. 273-275, Section 2).** Paraxial geometric optics: a defocused point becomes a blur circle with radius set by camera parameters and object distance; the PSF is a uniform disc (cylindrical function). Under constant blur radius over a region the camera is treated as linear shift-invariant, so the blurred image is the focused image convolved with the PSF. The PSF's spread parameter is linear in inverse object distance. [anchor: "For a planar object perpendicular to the"]
- **Real PSF departs from the model (p. 275).** The paper notes that real point images are blobs because of diffraction, polychromatic light and lens aberrations, and reports that the camera's actual point image was close to a cylinder and far from a Gaussian. [anchor: "was quite close to a cylindrical function"]
- **Local polynomial assumption and smoothing (pp. 275-280).** The focused image is assumed locally a cubic polynomial in a small neighbourhood (9 x 9 pixels); this is later relaxed by smoothing both images with least-squares polynomial-fitting filters. Depth then follows from the difference of the two images, their Laplacians and a quadratic (or linear) equation in the blur spread, with a sign fixed from gray-level variances. [anchor: "approximated by a cubic polynomial"]
- **Two variants (p. 279).** STM1 changes lens position (s and f), where the equation becomes linear and has a unique root; STM2 changes only aperture diameter and needs a convention (lens at infinity focus) to avoid a two-fold ambiguity. [anchor: "In STM2, only the diameter of camera"]
- **Practical steps (pp. 279-283).** Brightness normalisation by the image mean; magnification change (about 2 to 3 percent) ignored; frame averaging of typically four frames for noise and flickering lamps; per-pixel estimates pooled in a 48 x 48 interior region by histogram mode. [anchor: "a neighborhood of size 48 x 48"]
- **Calibration is needed (p. 284).** In practice a calibration look-up table (sigma vs distance, from objects at known distances) was used rather than the closed-form equation, because it was found more accurate. [anchor: "table itself is obtained through calibration"]
- **Third image sometimes needed (p. 285).** Theory needs two images, but if the object is near, the first image is too blurred and a third was taken. [anchor: "Theoretically, only two images are"]
- **Autofocus accuracy (p. 273, p. 286).** About 2.3 percent RMS error for autofocusing over about 600 experiments (stated in the introduction); for STM1 the measured RMS error on planar objects was 1.48 steps (room light) to about 2.3 steps (200 and 400 lux) out of 97 lens steps, about 2.5 percent. A depth-from-focus benchmark gave 1.52 steps. [anchor: "RMS error of about 2.3% in autofocusing"]
- **Ranging accuracy (p. 273, p. 287).** Relative distance error grows from about 2.3 percent at 0.6 m to about 20 percent at 5 m (depth-from-focus benchmark: about 1.6 to 12.5 percent). [anchor: "linearly to about 20% at 5.0 meters"]
- **3D objects (p. 293).** The convolution model does not hold for 3D objects; STM then returns an error-prone "average" depth over the window, roughly useful when depth changes are small (cone and teddy-bear examples, qualitative). [anchor: "In the case of 3-D objects, blurred images"]
- **Texture requirement (p. 293).** Plain objects without reflectance variation (white wall) cannot be ranged; projecting a random illumination pattern can add texture. [anchor: "walls which do not exhibit reflectance variation"]
- **Versus stereo (p. 293).** DFD avoids the correspondence problem but is in general less accurate than stereo with a long baseline; suggested as a rough estimate to feed stereo. [anchor: "a random illumination"]
- **Depth of field trade (p. 293).** Cameras are built to maximise depth of field, which reduces ranging accuracy; a small depth of field would improve it. [anchor: "this minimizes the accuracy when ranging is"]
- **Related methods summarised (pp. 272-273).** The introduction reports accuracies of earlier DFD methods (Pentland 1989: 2.5 percent standard error over 1 cubic metre, with a very small aperture causing diffraction and long exposure; Subbarao Fourier method about 4 percent RMS at 0.6 m). These are the authors' descriptions of other work. [anchor: "very small aperture has two main problems"]
- **Wavelength as a parameter (p. 293).** Mentioned in a single sentence as a possible variable parameter (two colour filters), not tested. [anchor: "another camera parameter because focal length"]

## Relevance to the thesis

- Supports: G30, that blur differences between two images taken with different (known) camera parameters give distance; and that DFD needs few images relative to depth from focus (pp. 271-272, 293).
- Does not support: aberration measurement or correction; fluorescence or microscopy (none mentioned; "fluorescent" appears only as room lamps); light-field or multi-view imaging; global-then-local alignment. Accuracy numbers are for macroscopic scenes (0.6 to 5 m) with one specific camera and cannot be transferred to a microscope. Not evidence for a spatially varying aberration model.

## Differences to state if cited

- Two (to three) sequential exposures with changed lens position or aperture, versus one exposure.
- Model-based: needs a known camera model or a calibration table and a locally shift-invariant PSF; the thesis method does not use a PSF model.
- Estimates a single depth per window, assuming a locally fronto-parallel textured surface; 3D variation inside the window gives errors.
- Output is depth or autofocus position, not a corrected image.

## Still unread

- Figures 5, 6, 9-13, 16, 18-21 as images (only captions and axes read). The cited technical reports (Subbarao 1991, 1989a-c; Subbarao and Surya 1992) and Meer and Weiss (1992) filters were not read; derivations in Sections 3-5 were read in OCR form and not re-derived.

## Safe Wording

Depth-from-defocus methods recover distance from two images taken with different camera parameters, using the difference in their blur and a local blur model, rather than searching for best focus (Subbarao and Surya 1994, p. 271); the approach assumes a calibrated camera, a textured, locally planar scene and gives larger errors for distant or non-planar objects (pp. 287, 293).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Reserve for a depth-from-defocus comparison in computer vision. The acquisition and depth-map task differ from through-focus fluorescence pupil estimation.
