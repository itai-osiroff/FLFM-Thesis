# Introduction parked text (2026-11-09)

> **Status:** reference
>
> **Reviewed:** 2026-11-09

Author-written text removed from Chapter 1 during the 2026-11-09 content
migration (pass 1). Sentences are verbatim. Text that moved into Chapters 2 and
3 lives in `overleaf/`; this file keeps only the sentences with no current home,
the placement map, and a complete copy of the former chapter. Not thesis source;
nothing here is newly verified science.

## Parked sentences (no chapter destination)

Former paragraph 1 (non-invasive imaging in medicine and biology; no citations):

> Non-invasive imaging techniques have advanced substantially in spatial resolution, speed, and sensitivity. In medicine, magnetic resonance imaging (MRI), ultrasound, and the x-ray-based computed tomography (CT) provide complementary ways to observe internal anatomy and physiological function without surgery. In biological research, imaging also enables the study of deep structures and dynamic processes in vivo. These applications require several properties at once: sufficient spatial resolution and contrast, coverage of a useful volume, adequate temporal resolution, and an acceptable level of exposure or invasiveness.

Former paragraph 2 (CT, MRI, and ultrasound trade-offs; no citations):

> Each of these modalities satisfies the requirements differently and therefore involves trade-offs. CT provides fast volumetric imaging, but uses ionizing radiation, which limits its suitability for repeated, frequent measurements. MRI provides high soft-tissue contrast without ionizing radiation, but is comparatively slow, expensive, and difficult to deploy in compact or portable systems. Ultrasound is portable and does not use ionizing radiation, but its reliance on acoustic propagation limits its spatial resolution for many applications. These limitations motivate complementary imaging approaches that can combine high resolution, speed, and practical sample access.

Former paragraph 3, sentences 1, 2, and 5 (optical methods as a complementary
approach; no citations). Sentences 3 and 4 moved to Chapter 3:

> Optical methods provide one such complementary approach. They avoid ionizing radiation and can offer high spatial resolution in relatively compact systems.
>
> Optical microscopy therefore introduces its own balance among penetration depth, spatial resolution, acquisition speed, and illumination burden.

Possible later use: one sentence of broad motivation in the new Chapter 1, if
the author wants it.

## Placement map

`P` is the former paragraph and `S` the sentence within it.

| Former text | Destination | Bib keys carried |
| --- | --- | --- |
| P1, P2 | Parked (this file) | none |
| P3 S1–S2, S5 | Parked (this file) | none |
| P3 S3–S4 | Ch 3, final paragraph (the "Aberration and scattering" heading was removed; see wording pass) | `jacques2013opticalPropertiesTissues` |
| P4 (all) | Ch 2, new section "Fluorescence microscopy" (`sec:lit-fluorescence-microscopy`) | `helmchen2005deepTissueTwoPhoton`, `swoger2007multiviewFusion`, `preibisch2010beadRegistration` |
| P5 S2–S4 | Ch 1, first paragraph | none |
| P5 S1 | Dropped from Ch 1 in the wording pass; kept here (see below) | none |
| P6 S1, S5 | Ch 1, second paragraph | none |
| P6 S2–S3 | Ch 3, new paragraph after the chapter's opening paragraph | `levoy2006lightFieldMicroscopy`, `levoy2009recordingControlling4d`, `broxton2013waveOpticsLfm` |
| P6 S4 | Ch 2, new section "Light-field microscopy" (`sec:lit-light-field-microscopy`) | `prevedel2014wholeAnimalLfm` |
| P7 S1–S2 | Ch 3, same paragraph as P6 S2–S3 | none |
| P7 S3–S5 | Ch 2, "Light-field microscopy" | `levoy2009recordingControlling4d`, `broxton2013waveOpticsLfm`, `stefanoiu2019artifactFreeDeconvolution`, `guo2019fourierLightField` |
| P8 S1–S2 | Ch 3, second new paragraph | `guo2019fourierLightField` |
| P8 S3 | Ch 2, end of "Light-field microscopy" | none |
| P8 S4 | Ch 1, end of second paragraph | none |

## Wording pass (same day, after pass 1)

Author decisions: Chapter 3 gets no subsections, and small connective edits in
Chapters 1 and 2 are allowed. Each change below is the whole edit; everything
else stayed verbatim. Dropped sentence, kept here:

> This trade-off is important even before considering full volumetric reconstruction.

| Where | Before | After |
| --- | --- | --- |
| Ch 1, first paragraph | (P5 S1 opened the chapter) | P5 S1 dropped; the chapter opens on P5 S2 |
| Ch 1, first paragraph | "complement scanning-based fluorescence methods" | "complement the scanning-based fluorescence methods reviewed in Chapter~\ref{ch:literature-review}" |
| Ch 1, second paragraph | "In this thesis, however, the immediate relevance of LFM is not the promise of general volumetric recovery" | "In this thesis, the immediate relevance of LFM is not general volumetric recovery" |
| Ch 1, second paragraph | "FLFM therefore provides the optical and modeling framework used in this thesis, while" | "The optical and modeling framework used in this thesis is Fourier light-field microscopy (FLFM), which places the microlens array in a pupil-conjugate plane \cite{guo2019fourierLightField}, while" |
| Ch 2, Fluorescence | "address different parts of the same problem rather than" | "address different parts of the same balance among penetration depth, spatial resolution, acquisition speed, and illumination burden, rather than" (list taken from P3 S5, parked) |
| Ch 2, LFM | "This snapshot capability has made LFM important" | "Light-field microscopy (LFM) records spatial information together with angular information in a single exposure, and this snapshot capability has made it important" |
| Ch 2, LFM | "Consequently, LFM performance depends" | "At the same time, LFM performance depends" |
| Ch 2, LFM | "In their implementation, this formulation reduced" | "Fourier light-field microscopy (FLFM), which places the microlens array in a pupil-conjugate plane, addresses these limitations. In the implementation of Guo et al. \cite{guo2019fourierLightField}, this arrangement reduced" |
| Ch 3, opening paragraph | (none) | added "This chapter also describes the optical degradation mechanisms and their effect on scene recovery." (the former section's placeholder sentence, with "also") |
| Ch 3, FLFM paragraph | "FLFM addresses these limitations by placing" | "FLFM instead places" |
| Ch 3, end | `\section{Aberration and scattering}`, placeholder sentence, then "In biological tissue, however, absorption" | heading and placeholder removed; paragraph opens "Beyond the image formation described above, the specimen itself degrades the measurement. In biological tissue, absorption" |

## Open items after the wording pass

- Ch 1 still has no problem statement (aberrated 2D scenes), objectives,
  contributions, or roadmap. That is pass 2.
- Added `\cite{guo2019fourierLightField}` to the Guo-results sentence in Ch 2.
  The original sentence had no key of its own; it relied on the Guo citation in
  the preceding sentence, which now sits in Ch 3. Confirm that the claim (fewer
  sampling artifacts, shorter reconstruction time) matches the source note.
- The new first sentence of Ch 2 "Light-field microscopy" (LFM records spatial
  and angular information in a single exposure) carries no citation, as in the
  original.
- Ch 3: the FLFM paragraph partly overlaps with the light-field-path paragraph
  later in the chapter. "LFM" first appears there without its definition.
- Citation check: `swoger2007multiviewFusion` and `preibisch2010beadRegistration`
  are registered as analogy-only multiview sources but support a light-sheet
  geometry claim in Ch 2. Confirm against the source notes or replace.

## Former Chapter 1 (complete, verbatim)

```latex
\chapter{Introduction}
\label{ch:introduction}
Non-invasive imaging techniques have advanced substantially in spatial resolution, speed, and sensitivity. In medicine, magnetic resonance imaging (MRI), ultrasound, and the x-ray-based computed tomography (CT) provide complementary ways to observe internal anatomy and physiological function without surgery. In biological research, imaging also enables the study of deep structures and dynamic processes in vivo. These applications require several properties at once: sufficient spatial resolution and contrast, coverage of a useful volume, adequate temporal resolution, and an acceptable level of exposure or invasiveness.

Each of these modalities satisfies the requirements differently and therefore involves trade-offs. CT provides fast volumetric imaging, but uses ionizing radiation, which limits its suitability for repeated, frequent measurements. MRI provides high soft-tissue contrast without ionizing radiation, but is comparatively slow, expensive, and difficult to deploy in compact or portable systems. Ultrasound is portable and does not use ionizing radiation, but its reliance on acoustic propagation limits its spatial resolution for many applications. These limitations motivate complementary imaging approaches that can combine high resolution, speed, and practical sample access.

Optical methods provide one such complementary approach. They avoid ionizing radiation and can offer high spatial resolution in relatively compact systems. In biological tissue, however, absorption and scattering reduce penetration and distort the detected light, with the severity depending on the sample and wavelength \cite{jacques2013opticalPropertiesTissues}. This limits the depth and contrast achievable by purely optical systems, especially when the sample is thick, heterogeneous, or strongly scattering. Optical microscopy therefore introduces its own balance among penetration depth, spatial resolution, acquisition speed, and illumination burden.

Fluorescence microscopy is particularly useful when illumination intensity or directionality are limited. Widefield fluorescence microscopy is simple and fast, but out-of-focus fluorescence can reduce contrast in thick samples. Confocal microscopy improves optical sectioning by rejecting out-of-focus light, at the cost of scanning and increased illumination exposure. Two-photon microscopy improves depth in scattering tissue through localized nonlinear excitation, but typically requires point scanning and more specialized excitation optics \cite{helmchen2005deepTissueTwoPhoton}. Light-sheet microscopy reduces unnecessary illumination by exciting a plane rather than the full sample volume, but its geometry often requires side access, sample rotation, or a mounting arrangement compatible with the illumination sheet \cite{swoger2007multiviewFusion,preibisch2010beadRegistration}. These methods therefore address different parts of the same problem rather than applying an all-encompassing solution.

This trade-off is important even before considering full volumetric reconstruction. In many fluorescence experiments, the relevant information is distributed across position, angle, depth, or viewpoint, while the camera records only a two-dimensional projection. Scanning can recover additional information sequentially, but this can reduce temporal resolution and increase exposure costs. An imaging strategy that encodes more of the light leaving the sample in a single exposure can therefore complement scanning-based fluorescence methods, provided that the encoded information can be interpreted computationally.

Light-field microscopy (LFM) follows this strategy by recording spatial information together with the angular information carried by the light. In microlens-based LFM, a microlens array placed at an image plane allows the camera to record a two-dimensional array of local angular measurements in a single exposure. The resulting four-dimensional light field can be computationally resampled to synthesize viewpoints, refocus after acquisition, or, in suitable systems, reconstruct a three-dimensional volume \cite{levoy2006lightFieldMicroscopy,levoy2009recordingControlling4d,broxton2013waveOpticsLfm}. This snapshot capability has made LFM important in high-speed biological imaging, including volumetric demonstrations such as whole-animal neuronal activity imaging \cite{prevedel2014wholeAnimalLfm}. In this thesis, however, the immediate relevance of LFM is not the promise of general volumetric recovery, but the way it converts a single camera frame into a structured set of spatial-angular measurements without the need for scanning.

LFM does not eliminate the imaging trade-offs; it changes where they occur. The finite sensor and optical aperture impose a spatial-angular sampling trade-off: allocating more samples to angular diversity leaves fewer spatial samples per view, while the resulting sampling pattern affects the resolution and quality of computational reconstruction. Consequently, LFM performance depends on the optical geometry, calibration, and reconstruction model, and reconstruction artifacts can arise when the captured information is undersampled or poorly modeled \cite{levoy2009recordingControlling4d,broxton2013waveOpticsLfm,stefanoiu2019artifactFreeDeconvolution}. In image-plane microlens-array LFM, the reconstruction model can also involve a position-dependent point-spread function (PSF) that maps a three-dimensional scene to the two-dimensional sensor measurement, increasing computational cost for volumetric reconstruction \cite{broxton2013waveOpticsLfm,guo2019fourierLightField}. These limitations make the optical architecture used to encode the light field central to both the information that can be recovered and the cost of interpreting it.

Fourier light-field microscopy (FLFM) addresses these limitations by placing the microlens array in a Fourier, or pupil-conjugate, plane of the imaging system. This arrangement records the spatial and angular components of the light field with a spatially invariant sampling scheme and permits a unified three-dimensional PSF under the system model described by Guo et al. \cite{guo2019fourierLightField}. In their implementation, this formulation reduced sampling-related artifacts and reconstruction time relative to conventional LFM; these benefits depend on the optical design, calibration, and reconstruction model rather than following unconditionally. FLFM therefore provides the optical and modeling framework used in this thesis, while the present work is limited to two-dimensional fluorescent scenes and a direct elemental-view rectification procedure rather than full volumetric deconvolution.
```
