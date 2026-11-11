# Maiden 2009 - An improved ptychographical phase retrieval algorithm (ePIE)

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Andrew M. Maiden and John M. Rodenburg, "An improved ptychographical phase retrieval algorithm for diffractive imaging", Ultramicroscopy 109, 1256-1262, 2009 (received 20 Feb 2009, accepted 26 May 2009). DOI printed: 10.1016/j.ultramic.2009.05.012. Metadata matches the assignment (issue number not printed on the paper).

## What was read

File C4c_07.txt (printed pp. 1256-1262), complete: abstract, all sections, conclusions and references. Figures were not inspected visually, only captions. Some equation symbols in the text file are garbled; only the verbal description of the update functions is used.

## Why This Matters

This paper introduces ePIE, which recovers the probe together with the object, removing the need for an accurate illumination model. For the thesis it is the standard source for "ptychography needs overlapping, sequentially recorded diffraction patterns, a highly coherent probe, and a probe estimate", and it is the explicit-coherence statement missing from the 2004 letter.

## Key Claims (paraphrased)

- **Problem addressed (p. 1256, abstract and intro).** The original PIE needs an accurate model of the illumination probe, which can be time-consuming or impossible to measure well enough; ePIE removes this requirement by updating probe and object together. [anchor: "an accurate model of the illumination function"]
- **What is acquired (p. 1256-1257, Sec. 2).** A series of J far-field diffraction patterns recorded as a localised probe is moved over overlapping positions relative to a transmissive sample; the exit wave is the product of object and shifted probe. Sequential acquisition, intensity only. [anchor: "good results requiring an overlap of around"]
- **Overlap (p. 1257, Sec. 2).** Good results need an overlap of about 60-70% between probe positions; the optical experiment used about 70%. [anchor: "good results requiring an overlap of around"]
- **Coherence (p. 1257, Sec. 2).** Propagation to the detector is modelled as a Fourier transform, which the authors say implies a high degree of coherence at the sample plane. [anchor: "coherence is required from the probe at the plane of the sample"]
- **Known inputs (p. 1257-1258, Secs. 2-3).** Probe positions are assumed known (simulation); the probe itself is not required to be known, only a rough initial guess such as a support of about the right size, with free space as the initial object guess. [anchor: "which are assumed known by the"] [anchor: "initial probe waveform is taken as a support function roughly the"]
- **Algorithm (p. 1257-1258, Sec. 2.2, Fig. 1).** Serial updates in random order: form exit wave, replace its Fourier modulus with the measured one, then update both object and probe using weights proportional to the other function's intensity. Described as a serial counterpart of the parallel projection method (pPIE). Solutions are not unique up to a constant scale/phase factor and a lateral shift. [anchor: "These solutions are not"]
- **Performance (p. 1258-1262, Secs. 3-5).** In simulation (256 x 256 object, 144 probe positions, Poisson noise) and an optical bench test (100 positions on a 10 x 10 grid, bee-leg slide, iris-formed probe), ePIE converges in fewer iterations (each iteration costing a half to a third of the time of the pPIE) and is more robust to noise, and recovers the probe including fringes. Periodic-grid scan positions cause artifacts. [anchor: "behaves well in spite of a high level of noise"]
- **Aberrations (not stated as such).** The paper does not discuss lens aberrations or pupil/wavefront aberration estimation. The probe is allowed to be inaccurately known and is then recovered, with a rough or imperfect initial guess (aperture too wide by about 2 pixels in simulation); the paper frames this as removing the need for an accurate probe model, not as aberration correction. [anchor: "much improved reconstructions"]
- **Limitations stated (p. 1257, p. 1259, p. 1262).** Zeros in the exit wave can stagnate phase retrieval and the authors are unsure how much ptychography suffers from this; they note possible near-field and phase-plate probes as future options. Fluorescence is not mentioned. [anchor: "can result in stagnation of"]

## Relevance to the thesis

- Supports: G28 (ptychography recovers a complex object from many overlapping, sequential diffraction patterns, with high coherence; probe, including a poorly known or aberrated one, can be recovered numerically). The explicit coherence sentence and the 60-70% overlap figure are citable from this paper.
- Does not support: any claim about fluorescence, incoherent emission, Fourier ptychography with LED arrays, or aberration/pupil correction specifically; the word aberration is not used in the text read. Do not cite it for acquisition time (not stated).

## Differences to state if cited

- Real-space (probe-scanning) ptychography with far-field detection, in contrast to Fourier ptychography; the probe is solved, not a pupil.
- Many sequential captures with moving mechanical stage; the thesis method is single-shot.
- Coherent transmissive sample (X-ray, electron, optical); the thesis scene is incoherent fluorescence.

## Still unread

- Nothing in the main text left unread; figure images not inspected. Cited works (Thibault 2008 and 2009, Guizar-Sicairos 2008) not read.

## Safe Wording

Maiden and Rodenburg extend the ptychographical iterative engine so that the illumination probe is recovered together with the object, which removes the need for an accurate probe model; the method needs overlapping diffraction patterns (about 60-70% overlap) and a highly coherent probe (Ultramicroscopy 109, 1256-1262, 2009, pp. 1256-1257).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Algorithm history if needed. Its translated-probe diffraction model is distinct from fluorescence image formation and from FPM pupil estimation.
