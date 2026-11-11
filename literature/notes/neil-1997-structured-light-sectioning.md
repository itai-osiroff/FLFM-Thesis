# Neil 1997 - Optical sectioning with structured light in a wide-field microscope

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. A. A. Neil, R. Juskaitis, T. Wilson, "Method of obtaining optical sectioning by using structured light in a conventional microscope", Optics Letters 22(24), 1905-1907, 15 December 1997 (received 26 August 1997). Department of Engineering Science, University of Oxford. No DOI printed on the paper (the page footer shows only the ISSN code 0146-9592/97/241905-03). No discrepancy with the assignment metadata.

## What was read

File C4d_22.txt (pdftotext), 3 PDF pages = printed pp. 1905-1907. The whole letter was read (abstract, theory, experiment, Figs. 1-3 captions, references). Equations came through partly garbled (square roots and Greek symbols); I read them from the text but did not open the PDF page images. Figures 1-3 were not inspected as images.

## Why This Matters

This is the primary source for optical sectioning by grid projection in a wide-field microscope: three phase-shifted images combined by a square-law formula remove the grid and the unmodulated background. It is a clear example of a multi-capture structured-light method that relies on defocus attenuating the pattern. It says almost nothing about aberrations.

## Key Claims (paraphrased)

- **Number of images (p. 1905, abstract; col. 2).** A single-frequency grid is projected onto the object and three images at three grid positions (relative phases 0, 2pi/3, 4pi/3) are processed, in real time, into a sectioned image. [anchor: "Images taken at three spatial positions of the grid are"] [anchor: "which correspond to the relative spatial phases"]
- **How sectioning is computed (p. 1905, Eqs. 3-5).** Each image is I0 plus a cos-weighted and a sin-weighted term (Ic, Is); the section image is the root of the sum of squared pairwise differences of the three images (or equivalently a complex sum with phase factors), which cancels I0 and the grid. [anchor: "which is analogous to square-law detection in commu-"]
- **Conventional image recoverable (p. 1906).** The ordinary wide-field image I0 is recovered as the sum of the three images. [anchor: "note that the conventional image, I0, can be recovered"]
- **Physical basis (p. 1905, col. 1).** In wide-field imaging only the zero spatial frequency fails to attenuate with defocus, so a projected grid is imaged efficiently only where it is in focus. [anchor: "it is only the zero spatial frequency that does not"] [anchor: "of the object where the grid pattern is in focus."]
- **Defocus sensitivity (p. 1906, Eqs. 8-10).** For a plane mirror, the sectioned response vs defocus u has the same form as the weak-object transfer function of a conventional microscope (Stokseth approximation), giving sectioning like a confocal system. Strength depends on the normalized grid frequency, maximal near normalized frequency 1. [anchor: "The strength of the sectioning does, of course,"] [anchor: "maximum sectioning strength is found to correspond to a"]
- **Measured axial response (p. 1906-1907).** 50x NA 0.75: predicted axial FWHM 0.87 um, measured 0.91 um (normalized frequency 0.4). 150x NA 0.95 dry: predicted 0.27 um, measured 0.43 um, equivalent to NA about 0.85. [anchor: "which compares well with the measured value of"] [anchor: "In practice, we measured 0.43 mm, which"]
- **Possible cause of the high-NA discrepancy (p. 1907).** The authors suggest effective pupil apodization from strong attenuation of marginal rays, among other possible causes. This is the only statement near an aberration or pupil effect; it is speculative and about an apodization, not an aberration. [anchor: "marginal rays that leads to an effective apodization of"]
- **Hardware (p. 1906).** A 40 line/mm grid, tungsten-halogen lamp with a 100 nm green filter, separate illumination and imaging lenses, CCD with frame grabber; the grid moves in a saw-tooth synchronized to the camera so three successive frames correspond to a third of a period. [anchor: "40-line/mm one-dimensional grid into the illumina-"] [anchor: "corresponded to a spatial shift of one third of a"]
- **Artifact from grid motion (p. 1906).** Moving the grid during exposure reduces the modulated terms by a sinc factor, 0.955 in their case (0.827 worst case). A look-up table maps the three 8-bit pixel values to the output. [anchor: "this factor is only 0.955."]
- **Difference from confocal (p. 1907).** Image formation is formally different from confocal and transfer functions differ slightly for features varying in different directions, but the images are described as substantially similar. [anchor: "were substantially similar to those obtained with"]

## Relevance to the thesis

- Supports: G29 (partly), structured illumination gives optical sectioning from three images at shifted grid positions with a simple per-pixel computation; the pattern is imaged efficiently only in focus. G30 (partly), defocus attenuation of the projected pattern is what produces depth discrimination (but not a use of defocus to measure aberrations).
- Does not support: that SIM or this method is sensitive to aberration (not stated); any resolution gain claim (this is sectioning only); noise amplification, artifacts other than the residual grid and motion blur factor (not discussed in detail); adaptive optics.

## Differences to state if cited

- Sectioning, not lateral super-resolution; incoherent lamp illumination of a grid, not interferometric patterns.
- Needs three sequential frames per section (up to about 40 ms frame period here), so it is not single-shot.
- Axial FWHM at high NA was worse than theory (0.43 um vs 0.27 um); the paper offers possible causes but names no aberration.

## Still unread

- Figure images (Figs. 1-3) not inspected; no supplement exists.
- Cited background (Wilson and Sheppard book, Stokseth 1969, Wilson and Juskaitis 1995) not read.

## Safe Wording

Neil et al. showed that projecting a one-dimensional grid onto a sample and combining three images taken at one-third-period grid shifts removes the grid and yields wide-field optical sections comparable to confocal ones, because only the in-focus part of the projected pattern is imaged efficiently (Neil et al. 1997, pp. 1905-1906).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Chapter 2 primary evidence for rejecting out-of-focus signal by structured illumination. Use Gustafsson for lateral super-resolution.
