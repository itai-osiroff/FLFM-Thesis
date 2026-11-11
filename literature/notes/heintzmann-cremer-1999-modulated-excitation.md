# Heintzmann 1999 - Laterally modulated excitation microscopy with a diffraction grating

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

R. Heintzmann and C. Cremer, "Laterally Modulated Excitation Microscopy: Improvement of resolution by using a diffraction grating", Proc. SPIE 3568, 185-196, 1999 (EUROPTO Conference on Optical Microscopy, Stockholm, September 1998; Applied Optics and Information Processing, Institute of Applied Physics, University of Heidelberg). The footer reads SPIE Vol. 3568, 0277-786X/99; no DOI printed. Discrepancy: Gustafsson (2000) cites this work as 1998, pp. 185-195; the file runs to p. 196 (the last page is the reference list), and the volume is dated 1999.

## What was read

File C4d_19.txt (pdftotext/OCR), 12 PDF pages = printed pp. 185-196. This is the full paper: abstract, sections 1-6 (introduction, lateral modulation, setup, algorithm and results, discussion, acknowledgements), references. The OCR is poor: equations 1-3 are garbled, Figures 3-9 labels and captions are partly corrupted, and the figures themselves were not inspected as images. Quantitative statements below come from the readable running text.

## Why This Matters

This is an early (1998) experimental demonstration of lateral SIM-type resolution improvement with a grating, mostly of interest for completeness and because Gustafsson (2000) builds on it. Its real gain was small (about 40 percent), and it uses a short algorithm that also begins with a cross-correlation image alignment, a step analogous to the global-shift step in the thesis.

## Key Claims (paraphrased)

- **Principle (p. 185-186).** Sinusoidal excitation creates three Fourier peaks, so the object appears in three shifted copies in the emission; if each copy is extracted and moved to the origin, the detectable frequency range grows by up to a factor of two. [anchor: "the object structure is present in three shifted"] [anchor: "The factor of two is obtained if"]
- **Simulation (p. 186).** Ideal conditions (530 nm, NA 1.4): PSF FWHM 188 nm conventional versus 95 nm with the method and algorithm. [anchor: "a FWHM of 95 nm for the method of laterally modulated"]
- **Real-world remark (p. 185).** The authors note that conventional resolution is hard to reach in practice because of an imperfect beam path. This is the only statement near aberrations; it is one clause and not developed. [anchor: "difficult to achieve due to an imperfect beampath."]
- **Hardware (p. 187).** Zeiss Standard 25 epifluorescence microscope, Hg lamp, 63x NA 1.4 oil objective, a lithographic aluminium bar grating (30 um period) replacing the illumination aperture at the conjugate object plane, projected to a 476 nm fringe period; incoherent lamp, no laser. The grating position was aligned manually by maximizing the pattern modulation on beads. [anchor: "resulting in 476 nm fringe distance in"] [anchor: "maximising the modulation of the projected pattern onto the focused beads"]
- **Number of images (p. 187-188).** The stage was stepped by 40 nm and four images at about 0, 90, 180 and 270 degrees of illumination phase were selected; the grating was then rotated by hand about 90 degrees and a second set taken, so eight images in total. Three would be enough in principle; four simplify reconstruction. [anchor: "four images having a phase shift of the illumination grating relative"]
- **Alignment preparation (p. 188-189).** Images are registered to the first one by the sub-pixel centre of mass of the cross-correlation peak, applied as a Fourier-domain shift; photobleaching scaling and offset are also corrected. Registration is stated to be not needed if the grating rather than the object is moved. [anchor: "Evaluation of the centre of mass of the maximum"] [anchor: "A different scaling (due to photobleaching) and a different offset"]
- **Reconstruction (p. 189-190, steps 1-6).** Phase-differenced images cancel the zero order and isolate one sideband, which is shifted back in Fourier space; the complex conjugate is added; the two orientations are summed; the low frequencies are restored by adding the mean of all images with an empirical weight of 1/26. Cost is O(N) in pixels. [anchor: "yielded negative values in the image and a overestimation"]
- **Artifacts (p. 190).** Suppressing low frequencies produces negative values and overestimated edge-like structures; the empirical low-frequency weight was chosen so only very small negative values remain. Simulated PSFs also show negative values if step 6 is omitted (Fig. 1 caption, p. 186). [anchor: "yielded negative values in the image and a overestimation"]
- **Measured gain (p. 194, 196).** FWHM of 140 nm beads: about 330 nm in the summed (conventional-equivalent) image versus about 230 nm reconstructed. Nearest-neighbour distance of attached 416 nm beads measured 402 nm, and without reconstruction individual beads could not be separated by any global threshold. The authors state the improvement so far is only about 40 percent. [anchor: "So far, only a slight resolution improvement of about 40%"]
- **Difference from deconvolution (p. 195).** The method enlarges the detectable frequencies and is described as qualitatively different from Wiener or maximum-likelihood deconvolution; combination with deconvolution is proposed as future work. [anchor: "is qualitatively different from"]
- **Partial coherence and axial effects (p. 186).** With an incoherent source a decoherence effect fades the modulation away from focus and may improve axial resolution, and the method could be used for optical sectioning (citing Wilson et al.). [anchor: "there is a decoherence effect, that fades the modulation"]
- **Limits stated (p. 186-187, 196).** Grating spacing is limited by the objective NA (must pass at least the +/-1 orders); modulation depth depends on grating quality and objective transfer; low modulation depth and the strong zero order limit efficiency. A grating with better modulation, smaller fringe period, or split-laser illumination is suggested. [anchor: "must allow to transmit at least the plus and minus"]

## Relevance to the thesis

- Supports: G29, as an early demonstration that several images (eight here) under shifted and rotated lateral grating illumination, plus a Fourier-space reconstruction, improve lateral resolution; also that the pattern's modulation depth and the grating alignment are practical limits. Useful, if desired, for the observation that images must be registered before combination.
- Does not support: sensitivity of SIM to aberrations in pattern or PSF (not stated apart from the one-clause beam-path remark); artifact claims beyond negative values and edge overestimation; any claim of a factor-of-two experimental gain (they obtained about 40 percent); G28 or G30.

## Differences to state if cited

- Resolution gain: theoretical and simulated up to 2x; experimentally about 40 percent. Do not quote 2x as measured. Gustafsson (2000) is the paper that demonstrates 2x.
- Manual hand rotation of the grating and stage-stepped phase shift; a research prototype.
- Experiment used beads only; no biological sample.

## Still unread

- Equations 1-3 and the figures (Figs. 1-9) are only partly legible in the text file; not checked against the PDF images.
- Cited works (Wilson et al., Gustafsson and Sedat) not read.

## Safe Wording

Heintzmann and Cremer projected a diffraction grating into the sample of an epifluorescence microscope, acquired phase-shifted images at two grating orientations, and recombined them in Fourier space, obtaining a lateral resolution improvement of about 40 percent in experiment, against a theoretical limit of a factor of two (Heintzmann and Cremer 1999, pp. 185-186, 194, 196).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Keep for early attribution if the text traces SIM's origins. Prefer the measured result in Gustafsson 2000 for a brief quantitative comparison.
