# Zheng 2021 - Concept, implementations and applications of Fourier ptychography

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Guoan Zheng, Cheng Shen, Shaowei Jiang, Pengming Song, Changhuei Yang, "Concept, implementations and applications of Fourier ptychography", Nature Reviews Physics 3, 207-223, 2021 (Technical Review; published online 10 February 2021; issue March 2021). DOI printed on the paper: 10.1038/s42254-021-00280-y. No discrepancy with the assignment metadata; the text file covers printed pages 207-223 (pp. 221-223 are references and acknowledgements).

## What was read

File C4c_11.txt (1390 lines, 17 form-feed-separated PDF pages). Page footers carry printed journal page numbers ("volume 3 | March 2021 | 207" etc.), so locators below are printed pages. The whole main text, Boxes 1-2, Table 1, figure captions, Outlook and the reference list (titles only) were read. Not read: the Supplementary Note, the cited primary papers (refs 4, 65, 66, 88, 98, 101, 102, 121, 122 are known here only through this review), figure content beyond captions and labels. The file is not valid UTF-8 (dashes and symbols show as odd bytes, words hyphenated mid-line) but the text is complete.

## Why This Matters

Authoritative review of Fourier ptychography (FP) for the claim that FP recovers a high-resolution complex image from many low-resolution captures and corrects pupil aberrations numerically, under coherent or partially coherent illumination. It also states how FP reaches incoherent fluorescence, which bounds what the thesis may say.

## Key Claims (paraphrased)

- **Definition and acquisition (pp. 207-208).** FP expands the space-bandwidth product of a regular microscope. An LED array lights the sample from a series of angles; each angle gives one low-resolution intensity image (a shifted circular pupil region in Fourier space); the images are synthesized by iterative phase retrieval into a high-resolution complex image that keeps the wide field of view of the low-NA objective. The original set-up used a 2x, 0.08-NA objective. [anchor: "Fourier ptychography (FP) was developed to expand"]
- **Overlap needed (p. 208).** Aperture overlap between adjacent acquisitions is critical for a successful reconstruction; without it the phase ambiguities of the problem remain. [anchor: "For both techniques, data redundancy"]
- **Coherence requirement (p. 208).** The imaging model suggests spatially coherent sources. A real finite source is treated as an incoherent mixture of coherent states, modelled as multiple incoherent modes of the pupil; partial spatial coherence of LEDs is said to be well handled. [anchor: "mixture of coherent states"]
- **Number of images and speed (pp. 210-212, 215-217).** Speed of the original set-up is limited by the large number of images and long darkfield exposures. The only count given for the original set-up is 137 images, reduced to 68 by non-uniform Fourier sampling. Other speed measures: content-adaptive illumination, multiplexed LEDs (angle or colour), laser or DMD steering, single-photon detection. About 30 raw images give fourfold gain with diffuser modulation (p. 216); annular illumination QPI used four images at 25 Hz (Fig. 3c, p. 217); a 96-camera system images a 96-well plate at 0.7 frames per second (p. 215). Exposure or total time of the original set-up is not stated. [anchor: "from 137 in the original FP set-u p to 68"]
- **Pupil aberration recovery (p. 213).** Three imperfections can be corrected inside the iterative reconstruction: LED intensity, LED incident angles, pupil aberration. Pupil aberration is handled by measuring spatially varying aberrations with a calibration target, by jointly recovering object and pupil, or by a field-dependent model for full-field recovery; an image-quality metric can recover Zernike modes. [anchor: "Another solution is to jointly recover both the object and"]
- **Aberration is field dependent; tiling (Box 2, p. 211; p. 218).** Images are cut into small tiles (for example 256 x 256 pixels) so that the pupil aberration is spatially invariant within a tile. A 2019 full-field model (ref. 66) uses the field dependence across the whole field of view, reducing degrees of freedom. [anchor: "treated as spatially invariant across the area"]
- **Defocus is an aberration (p. 207 key points; p. 218).** Defocus is a pupil phase factor, so FP refocuses digitally and extends the depth of field by about two orders of magnitude compared with a conventional microscope of similar NA (ref. 4). [anchor: "Defocus is a type of aberration and, thus, FP can"]
- **Aberration metrology used for fluorescence (p. 218).** After FP finds the system aberration it can be applied to other modalities on the same set-up. CACAO-FB stitches sequentially opened pupil sub-apertures by FP and uses the recovered coherent transfer function to deconvolve coded-aperture images under incoherent illumination (in vivo retinal imaging); a multimodal system uses FP-recovered pupils to deconvolve fluorescence images (Fig. 5c). So FP measures the aberration and a separate deconvolution corrects the incoherent image. [anchor: "the recovered coherent transfer function is then used to"]
- **Fluorescence and incoherent extensions (pp. 213, 215, 218).** Standard FP is coherent and its images carry coherent artefacts; unsupervised image translation (neural network) can render virtual fluorescence staining of FP reconstructions (Fig. 4b), which is style transfer, not a fluorescence measurement. Translated unknown speckle illumination works for coherent and incoherent imaging; for fluorescence it is conceptually similar to structured illumination microscopy, with 4-fold (fluorescence microscope) and 13-fold (through a low-pass diffusing layer) resolution gain cited. [anchor: "it is conceptually similar to"]
- **Coherent or incoherent speckle (p. 215).** The translated-speckle scheme is stated to be usable for both coherent and incoherent imaging. [anchor: "can be used for both coherent and"]
- **Single-shot implementations (p. 215).** Lens array at the Fourier plane (angular multiplexing), diffraction grating, or colour-multiplexed annular illumination give single-shot FP, but at the cost of field of view. [anchor: "essentially trade off the"]
- **Thin-object model limit (p. 216).** FP multiplies a thin object by a tilted plane wave. For thick objects, multi-slice modelling or diffraction tomography are used; reconstruction may take hours or days for a full 3D volume. Aperture or diffuser modulation at the detection path avoids the thin-object limit. [anchor: "take hours or days to recover the full 3D volume"]
- **Limitations (pp. 213, 218, 220).** Coherent artefacts reduce colour accuracy in pathology (p. 218). Phase retrieval needs a good initial guess (p. 213). Hard cases for blind FP include severe unknown aberrations and light sources of low spatial and temporal coherence (p. 220). [anchor: "severe unknown aberrations"]
- **Light-field links (reference list, pp. 221-223).** The review does not discuss light-field, Fourier light-field or multi-view microscopy. The only light-field wording is the title of ref. 111 (Tian and Waller, 3D intensity and phase imaging from light field measurements in an LED array microscope), cited for multi-slice modelling (p. 216). The lens-array single-shot FP (ref. 98) resembles FLFM optically, but the review does not draw that link. [anchor: "from light field measurements in an LED array"]

## Relevance to the thesis

- Supports: G28. FP recovers a complex high-resolution image from many low-resolution captures (pp. 207-208); recovers pupil aberration numerically, per tile or full field (pp. 211, 213, 218); needs coherent or partially coherent illumination (p. 208); needs many overlapping sequential captures (pp. 208, 210-212). Fluorescence is reached only indirectly: FP-recovered aberrations used to deconvolve fluorescence images (p. 218), or speckle-scanning variants (p. 215). G30 partly: defocus treated as pupil aberration and refocused digitally (pp. 207, 218). G29 weakly: one sentence linking incoherent translated-speckle FP to SIM (p. 215).
- Does not support: that FP "cannot" be applied to fluorescence (the review shows fluorescence variants); any statement on light-field or Fourier light-field microscopy; a fixed image count (counts range from 4 to 137, and single-shot variants exist); correction of sample-induced aberration in incoherent emission.

## Differences to state if cited

- FP uses sequential angled coherent illumination plus phase retrieval to estimate a pupil function; the thesis method is single-shot incoherent capture with shift-based view alignment, no pupil model, no phase retrieval.
- FP aberration recovery is for the system pupil (per tile or full field), not for sample-induced aberration in an incoherent emission image.
- Fluorescence-capable FP-family methods exist (translated speckle, CACAO-FB, single-shot variants), so "not applicable to fluorescence" needs qualification.

## Still unread

- Supplementary Note; primary papers refs 4, 65, 66, 88, 98, 101, 102, 121, 122 (image counts, exposure times, aberration models for fluorescence).

## Safe Wording

Fourier ptychography synthesizes a high-resolution complex image from many low-resolution intensity images taken under varied coherent illumination angles, and it can recover the system pupil aberration computationally (Zheng et al. 2021, pp. 207-208, 213). Because it relies on coherent or partially coherent illumination, it reaches fluorescence indirectly, for example by deconvolving fluorescence images with an FP-recovered pupil (p. 218).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Alternative to Konda for a broader implementation taxonomy. One FP review is sufficient for a short comparison.
