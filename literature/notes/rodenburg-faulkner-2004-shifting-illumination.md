# Rodenburg 2004 - A phase retrieval algorithm for shifting illumination

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

J. M. Rodenburg and H. M. L. Faulkner, "A phase retrieval algorithm for shifting illumination", Applied Physics Letters 85(20), 4795-4797, 2004 (received 16 June 2004, accepted 17 September 2004). DOI printed: 10.1063/1.1823034. Metadata matches the assignment (issue number 20 and date 15 Nov 2004 added).

## What was read

File C4c_09.txt: a publisher cover page plus the full 3-page letter (printed pp. 4795-4797), complete including references. Figures (Fig. 2 simulation) were not visually inspected, only the text and caption. The text file shows a few garbled symbols (Greek parameter names lost), so the update-function parameters are described only by role.

## Why This Matters

This is the origin paper of the ptychographic iterative engine (PIE) and the reference behind later Fourier ptychography. For the thesis it documents the principle (known illumination shifted over overlapping positions, only diffraction intensities measured) and that lens aberration is bypassed by using a known probe rather than the lens transfer function. It is background for a ptychography statement, not a source about fluorescence or light-field imaging.

## Key Claims (paraphrased)

- **Goal and mechanism (p. 4795, abstract and intro).** An iterative phase retrieval method that uses measured diffraction-plane intensities and is claimed to avoid the lens-aberration problem, giving much higher resolution than the lens alone. [anchor: "bypasses the problem of lens aberration"]
- **Setup (p. 4795, Fig. 1).** A confined illumination function (a probe, formed using a poor or aberrated lens, modelled as a defocused STEM beam crossover) lights part of an extended object; the object or probe is moved laterally to many positions and a diffraction pattern is recorded at each. [anchor: "formed using a poor or aberrated lens"]
- **Overlap needed (p. 4795).** Only a few diffraction patterns are needed, recorded with the illumination at overlapping positions. The letter gives no quantitative overlap percentage. [anchor: "the illumination beam in overlapping positions"]
- **Known probe assumed (p. 4795).** The algorithm assumes the illumination function is known; it may be known from the beam-forming parameters or determined by other methods (an iterative through-focal-series algorithm is named). With an inaccurately known beam it still works but less accurately. [anchor: "If the incident beam is inaccurately known"] [anchor: "the iterative through focal series algorithm"]
- **What is recovered (p. 4795-4796).** The complex transmission function of a thin object (exit wave = object times shifted probe). Object update is a weighted (Wiener-like) correction that favours strongly illuminated regions. [anchor: "This will generally be accurate for a thin object"]
- **Why not conventional methods (p. 4795).** With strongly curved incident wavefronts, conventional iterative methods fail because of an ambiguity in the defocus value of the reconstruction; shifting the probe breaks this. [anchor: "ambiguity in the defocus value of the reconstruction"]
- **Evidence and limits (p. 4796-4797).** Demonstrated only in simulation (four probe positions, 200 iterations, accurate recovery inside the covered region, poorer outside). Effect of noise is not studied; the authors only say initial tests imply robustness. No experiment, no fluorescence, no coherence discussion beyond the thin-object, wave-function model. [anchor: "although initial tests imply that the algorithm is robust"]

## Relevance to the thesis

- Supports: G28 (origin of ptychography: many overlapping, sequentially shifted illumination positions, intensity-only measurement, phase recovery of the complex object; aberrated illumination handled by using a known probe). Resolution is limited by the angular extent of the detector rather than by the lens.
- Does not support: any statement about fluorescence, incoherent light, Fourier ptychography (LED arrays), pupil-aberration estimation, or numerical aberration removal in general. It does not state explicit coherence requirements (a complex wave function is simply assumed), so "requires coherent illumination" cannot be cited from this paper alone; use Maiden 2009 for the explicit coherence sentence.

## Differences to state if cited

- Shifting-illumination scheme in transmission with electrons or X-rays in mind (STEM probe), not light microscopy of fluorescence.
- Probe is assumed known; aberration is bypassed rather than estimated.
- Many sequential captures by moving the probe or object; the thesis method is single-shot.

## Still unread

- Nothing in the letter was left unread; only the figure images were not inspected. Referenced earlier works (Faulkner 2004 PRL, Nellist 1995/1998) were not read.

## Safe Wording

Rodenburg and Faulkner proposed recovering a complex object from diffraction intensities recorded at several overlapping positions of a known, confined illumination, so that the resolution is not limited by an aberrated lens (Appl. Phys. Lett. 85, 4795, 2004, p. 4795).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Historical origin only if the thesis traces the algorithm lineage. The PDF begins with an AIP cover sheet.
