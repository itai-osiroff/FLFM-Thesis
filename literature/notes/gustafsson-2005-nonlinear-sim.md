# Gustafsson 2005 - Nonlinear (saturated) structured-illumination microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. G. L. Gustafsson. "Nonlinear structured-illumination microscopy: Wide-field fluorescence imaging with theoretically unlimited resolution." Proceedings of the National Academy of Sciences USA 102(37), 13081-13086, 13 September 2005. DOI printed on the paper (in the footer, partly garbled by extraction): 10.1073/pnas.0406877102. No discrepancy with the assignment metadata.

## What was read

File C4d_17.txt, the whole 6-page paper (printed pp. 13081-13086), including abstract, Principle, Measurements, Discussion, Conclusions and references. The file is complete (it starts at the title and ends with the reference list). Two-column layout is interleaved with the figure captions, but all passages cited below were readable. Figures were read only through their captions. No supplement is mentioned in the text.

## Why This Matters

This paper shows what saturating the fluorophore adds to linear SIM (higher resolution via extra pattern harmonics) and what it costs (more images, much more light, photobleaching, motion and aberration sensitivity). It is optional context for the thesis: it is useful to say that SIM-type resolution gains come with a heavy acquisition and photon budget.

## Key Claims (paraphrased)

- **Linear SIM limit (p. 13082).** Normal linear SIM (and confocal microscopy, as a special case) can extend resolution only by a factor of two, because the illumination frequencies are themselves diffraction limited. [anchor: "only by a factor of 2"]
- **What saturation adds (pp. 13081-13082).** A nonlinear dependence of emission on illumination intensity puts higher harmonics of the pattern into the effective excitation, so higher-frequency sample information is moved into the observable region; a non-polynomial nonlinearity gives infinitely many harmonics, so the resolution is limited in practice only by signal-to-noise ratio and photostability. [anchor: "to introduce high-frequency harmonics into the effective"] [anchor: "thus produces an infinite number of"] [anchor: "matters of signal-to-noise ratio and photostability"]
- **Mechanism (p. 13082).** The nonlinearity used is saturation of the excited state S1, which occurs in all fluorophores and needs only a single, inexpensive laser; here a 532 nm pulsed (0.64 ns) source with a 100x 1.4 NA objective was used. [anchor: "is saturation of the excited state S1"]
- **Cost in images (p. 13084).** Each harmonic order adds information components, so more phase images are needed: with three harmonics (nine components) nine phase images were acquired per orientation, and the procedure was repeated for 12 pattern orientations. The paper does not state the total; nine times 12 is 108 images for one 2D reconstruction (my arithmetic, 2D only). [anchor: "a sequence of nine images was acquired"] [anchor: "was repeated for 12 different pattern orientations"] Exposure was 0.15 s (900 pulses) per image. [anchor: "exposure time of 0.15 s"]
- **Cost in light and photobleaching (p. 13085).** The main obstacle for cells is that photobleaching seems to accelerate under saturating illumination, and the number of detected photons needed for a given signal-to-noise ratio is greatly increased relative to a single conventional image (scaled with the number of orientations and the inverse square of the highest harmonic coefficient). [anchor: "the photobleaching rate of at least some fluorophores seems to"] [anchor: "required for a given signal-to-noise-ratio is greatly increased"] In practice bright, photostable samples are required. 3D imaging increases the photostability requirement in proportion to the number of sections. [anchor: "increases further in proportion to the number of sections"]
- **Resolution (pp. 13084-13085).** On 50 nm beads the average FWHM of 100 profiles was 58.6 nm (versus 265 nm conventional), and 48.8 nm after removing the bead shape by linear deconvolution (an estimated 2D point resolution under 50 nm). [anchor: "average FWHM of 100 such profiles was 58.6"]
- **Aberration sensitivity (p. 13085).** Because it relies on clean intensity zeros, the method is said to be more sensitive than conventional microscopy to sample-induced aberrations. [anchor: "relies on clean intensity zeros"]
- **Live samples (p. 13085).** The processing assumes a stationary sample (50 nm motion over many seconds for the shown data set), so live imaging would likely be restricted to slow-moving structures; saturation may increase phototoxicity. [anchor: "live imaging will most likely be"]
- **Calibration (p. 13084).** Pattern orientation, spacing and phase were fitted from the data, but modulation depths were entered by hand because the signal-to-noise in the highest components was too low for automatic determination. [anchor: "preferable to enter the modulation"]
- **Fluorescence and coherence (p. 13086).** The method relies on the emission of different sample points being mutually incoherent, so intensities add; the paper covers only fluorescence. [anchor: "are mutually incoherent, so that"] Wide-field: no scanning is needed, so a whole field is imaged at once. [anchor: "Because no scanning is necessary"]

## Relevance to the thesis

- Supports: G29 (SIM-type methods need many sequential captures, here nine phases times 12 orientations for 2D, and a reconstruction; saturation raises the resolution limit but adds photobleaching and photon cost; the method is more sensitive to sample-induced aberrations than conventional microscopy, p. 13085).
- Does not support: G24 to G27 and G30. It is not evidence that SIM in general (linear SIM) is aberration sensitive: the aberration statement is made for the saturated, nonlinear variant that relies on clean intensity zeros. It says nothing about adaptive optics, blind reconstruction, or light-field imaging.

## Differences to state if cited

- Nonlinear (saturated) SIM is a super-resolution method with pulsed excitation and about 100 images for a 2D result; the thesis method is single-shot, linear, uses no structured illumination, and aims to correct aberrated 2D scenes rather than exceed the diffraction limit.
- The reconstruction here uses a known (measured or computed) OTF and a Wiener-like weighted average; the thesis method uses no PSF model.

## Still unread

- Figures 1-7 were read only via captions, not visually.
- Reference list entries (cited works) were not followed up.

## Safe Wording

Saturated structured-illumination microscopy reaches 2D resolution below 50 nm by acquiring nine phase images at each of 12 pattern orientations, but it needs bright, photostable samples because photobleaching and the required photon count increase under saturating illumination (Gustafsson 2005, p. 13085), and the author notes it is more sensitive than conventional microscopy to sample-induced aberrations.

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use only for nonlinear SIM. The theoretical limit depends on the model and does not imply unlimited experimental resolution.
