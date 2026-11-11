# Dowski 1995 - Extended depth of field through wave-front coding

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Edward R. Dowski, Jr., and W. Thomas Cathey, "Extended depth of field through wave-front coding", Applied Optics 34(11), 1859-1866 (10 April 1995). Received 12 September 1994, revised manuscript received 5 December 1994. Imaging Systems Laboratory, University of Colorado, Boulder. No DOI printed in the file (only the journal code 0003-6935/95/111859-08). No discrepancy with the assignment metadata.

## What was read

C4e_26.txt, the whole file: printed pp. 1859-1866 (abstract, Sections 1-4, Appendix A, references). Complete. Equations and symbols are garbled in extraction (for example "a : 20" stands for a much larger than 20, and "1x2" for parentheses), so formulas were interpreted from context; check the PDF before citing any equation. Figures 1-10 were read only through captions.

## Why This Matters

The founding paper of wavefront coding: a cubic phase mask makes the incoherent PSF and OTF nearly independent of misfocus, and digital filtering restores the image. It is the standard citation for engineered PSFs that trade optics plus digital processing for depth tolerance, in contrast with the thesis, which uses neither an engineered mask nor deconvolution.

## Key Claims (paraphrased)

- **The system (abstract, p. 1859).** A standard incoherent system with a phase mask in the pupil, followed by digital processing of the resulting intermediate image; the mask makes the PSF and OTF change little with misfocus. [anchor: "with digital processing of the resulting intermediate image"]
- **Misfocus invariance (abstract, p. 1859).** [anchor: "not change appreciably as a function of misfocus"] Because the OTF has no zeros in its passband, one focus-independent digital filter restores the image for all misfocus values, giving a near-diffraction-limited PSF over a far larger focus range. [anchor: "digital processing restores the image for all values of"]
- **The cubic phase element (Section 3, p. 1861; Appendix A, p. 1864-1865).** The one-dimensional mask is exp(j a x^3) over a finite aperture; the stationary-phase method shows the OTF magnitude is approximately independent of misfocus for large a, and shows the exponent 3 is needed. The validity condition (large space-bandwidth product) gives a much greater than about 20; the simulations use a = 90. A two-dimensional rectangularly separable mask is assumed. [anchor: "We term this mask the cubic-phase-modulation"]
- **Cost of the misfocus-dependent term (Appendix A, p. 1865).** A part of the OTF phase depends on misfocus and amounts to a shift of the PSF location at large misfocus; large a minimises it. [anchor: "merely shifting the location of the resulting point-"]
- **Evidence is simulated (Section 3, pp. 1862-1863).** Simulated PSF width (FWHM) after filtering stays roughly constant out to misfocus c = 30 (about 30 times the Hopkins criterion), and simulated spoke targets look nearly unchanged from in-focus standard imaging, while the standard system degrades already at mild misfocus (c = 5). [anchor: "These simulations assumed a noise-free optical"]
- **Intermediate image and filter (p. 1862).** Without filtering the intermediate image is unrecognisable and its PSF is much wider than the in-focus standard PSF. The filter used was a simple least-squares inverse filter. [anchor: "filter used for this example was a simple inverse"]
- **The trade-off: noise and dynamic range (p. 1863 and abstract).** Restoration alters the noise; a signal-to-noise or dynamic-range premium is needed. For the simple inverse filter the maximum gain is about 20 dB, an exaggerated estimate of the SNR premium, about 3.5 extra bits of dynamic range; other filters would need less. The abstract names the price as an increased dynamic range. [anchor: "approximately 20 dB; required extra dynamic range"]
- **Information about focus (p. 1863-1864).** By the Fisher information of misfocus, the cubic system carries much less focus information: at c = 10 the standard system varies 20 dB more with misfocus. An ideal focus-invariant system would produce an image with no information about the focus state; a focus-dependent filter is needed if focus is known. [anchor: "that contains no information pertaining to the focus"]
- **Aberrations other than defocus.** Only misfocus (the W20 term) is analysed, through the parameter c. Other aberrations are not treated; earlier apodizer work is cited, one title mentioning spherical aberration. Not stated otherwise. [anchor: "misfocus aberration constant is given by W20"]

## Relevance to the thesis

- Supports: G30 as an example of an engineered PSF (phase mask in the pupil) combined with digital restoration to handle depth/misfocus for incoherent imaging; and, in a thesis sentence on computational solutions, that digital restoration brings a noise or dynamic-range cost (about 20 dB SNR premium for a simple inverse filter, p. 1863). G25 only in this narrow sense (restoration costs SNR), for a specific filter.
- Does not support: depth recovery or 3D estimation (the goal is the opposite: invariance to focus, and the paper says the image then carries little focus information); any claim about general aberration correction, fluorescence, light-field or multi-view imaging, field-dependent correction, or experiments (none: all results are simulations, no measured data). It does not give contrast numbers; the cost it gives is SNR and dynamic range.

## Differences to state if cited

- It adds a hardware element (a cubic phase mask) and needs a deconvolution-type filter; the thesis method uses neither and operates on the views of a light-field capture.
- It targets misfocus (extended depth of field), not general aberrations; there is no pupil estimation.
- Simulated, incoherent, noise-free imaging; a one-dimensional, rectangularly separable design.

## Still unread

- Figures 1-10 beyond their captions; equations only read as garbled text (see "What was read").

## Safe Wording

Dowski and Cathey modified an incoherent imaging system with a cubic phase mask so that its OTF is nearly invariant to misfocus, and restored the image with one focus-independent digital filter, at the price of an increased signal-to-noise and dynamic-range requirement (Appl. Opt. 34, 1859, 1995, abstract and p. 1863); their evidence is simulated.

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use only to contrast depth-invariant imaging with depth encoding. This method deliberately suppresses changes with defocus.
