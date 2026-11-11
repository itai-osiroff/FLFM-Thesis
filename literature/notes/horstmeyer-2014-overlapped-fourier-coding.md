# Horstmeyer 2014 - Overlapped Fourier coding for aberration removal

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

R. Horstmeyer, X. Ou, J. Chung, G. Zheng, C. Yang, "Overlapped Fourier coding for optical aberration removal," Optics Express 22(20), 24062-24080 (2014), DOI 10.1364/OE.22.024062 (printed on the paper). Received 2 Jul 2014, published 24 Sep 2014 (issue dated 6 Oct 2014). No discrepancy with the assignment metadata. Printed pp. 24062-24063 are the title page, abstract and reference list; the main text starts at p. 24064.

## What was read

Whole of C4c_05.txt (19 pp, printed pp. 24062-24080), including all figure captions. Figures were not inspected as images. The text file is not valid UTF-8, so symbols and equation glyphs are garbled; equations were read from the surrounding prose. Footers for printed pp. 24065, 24067, 24070, 24074, 24077 and 24078 are missing from the text (figure pages), so material on those pages is located by a page range plus section name.

## Why This Matters

Horstmeyer 2014 introduces overlapped Fourier coding (OFC): a coherent-illumination, many-snapshot, model-based (Zernike plus alignment parameters) method that estimates a camera's aberration and removes it numerically. It is the ancestor of the incoherent variant in Chung 2019 and a clear contrast case for a single-shot, model-free, incoherent Fourier light-field method.

## Key Claims (paraphrased)

- **Procedure (Sec. 1-2.1, pp. 24064-24066).** A spatial light modulator in the Fourier (aperture) plane displays a small square sub-aperture stepped across the pupil; one image is recorded per position and the images are fused numerically into a full-resolution complex field. [anchor: "digitally pans a small aperture across a camera's pupil plane"]
- **Cost is many snapshots (Abstract, p. 24062; Sec. 1, p. 24064).** The authors say they trade lens complexity for acquisition speed. [anchor: "at the expense of taking multiple snapshots over time"]
- **Number of images (Sec. 2.1, pp. 24065-24066; Sec. 4).** A 9 by 9 grid gives 81 images per sequence, with about 75% (simulation) or about 70% (experiment) overlap of neighbouring sub-apertures. In the experiment each position was shot three times (0.01, 0.1, 1 s) and combined by high-dynamic-range processing. A total capture time is not stated. [anchor: "requiring a total of n2 = 81 images per capture sequence"]
- **Coherent illumination is assumed (Sec. 2.1, pp. 24065-24066).** The model assumes spatially coherent, quasi-monochromatic sample illumination; the authors say it extends to partially coherent illumination. [anchor: "coherent and quasi-monochromatic light, as defined in"] [anchor: "OFC directly extends to operate"]
- **Coherence in the experiment (Sec. 4, pp. 24077-24078).** A collimated 632 nm laser was used; the spatial coherence length must be as wide as the sample (about 5 mm there) and the source must be narrow-band (about 10 nm was observed to suffice, citing other work). [anchor: "must be as wide as the sample at the object plane"]
- **Incoherent correction is called ill-posed (Sec. 1, p. 24064).** Incoherent setups do not measure phase, so their digital aberration removal must follow an ill-posed intensity PSF deconvolution (attempted before in fluorescence and light-field microscopy); OFC avoids this by estimating a complex coherent transfer function. [anchor: "digital removal of system aberrations must follow an ill-posed"]
- **Aberration model and estimator (Sec. 3, pp. 24070-24075).** One multiplicative Fourier-plane phase function, written with Zernike modes (defocus in the first simulations; defocus, x/y astigmatism and x/y coma in the experiment), plus separate parameters for sub-aperture position and size (geometric misalignment). Parameters are found by simulated annealing: random candidates are compared with each sub-image by mean-squared error. [anchor: "iteratively update the global aberration function"]
- **Prior knowledge of the search space (Sec. 3, p. 24070).** The user must assume which subspace of imperfections to search, and search time grows with its dimension. [anchor: "a-priori knowledge about which subspace of imperfections to search through"]
- **Global, not field-dependent (Secs. 2-4).** A single aberration map is estimated for the whole image; no per-region or field-dependent estimate is described. Spatially varying aberration appears only as cited prior work (ref. 33) that pre-calibrates aberrations. [anchor: "can pre-calibrate for optical aberrations for later removal"]
- **Resolution claim is bounded (Sec. 1, p. 24064).** OFC cannot exceed the aperture-defined cutoff; it recovers resolution lost to aberration and misalignment. [anchor: "resolution beyond its aperture-defined cutoff"]
- **Demonstration (Secs. 3-4, pp. 24071-24078).** Simulation: resolution target with cubic phase and a blood-smear phase object, 2% noise. Experiment: two f = 75 mm singlet lenses in a 4f arrangement, an LCD amplitude SLM, 632 nm laser, CMOS detector; a resolution target feature (group 4 element 6) unresolved before correction was resolved after, and 117 um polystyrene microspheres gave quantitative phase. Annealing improved NMSE by a factor of 3-4 but fell short of perfect recovery. [anchor: "improves our reconstruction NMSE by a factor of 3-4"]
- **Computational limits (Sec. 3.3, pp. 24074-24075; Sec. 5, pp. 24079-24080).** Searching p parameters needs T to the power p candidate tests; the authors name computation scaling and non-orthogonality of parameter types (possible stagnation) as the two main shortcomings. [anchor: "time will grow exponentially"]
- **Light throughput (Sec. 5, p. 24079).** Small sub-apertures make exposure times long. [anchor: "required exposure times are quite long"]
- **Fluorescence only as an outlook (Sec. 5, p. 24080).** The authors say the setup may extend to fluorescence images; no fluorescence experiment or simulation is reported. [anchor: "improve the SBP of fluorescence-based images"]

## Relevance to the thesis

- Supports: G28 (ptychography-type method recovering a high-resolution complex field from many low-resolution captures and estimating the system aberration numerically; requires coherent or quasi-coherent illumination and 81 sequential captures; not demonstrated on fluorescence). Sec. 1 also records the authors' view that incoherent aberration removal is an ill-posed deconvolution (usable for G25 only as their statement, not as a measured result).
- Does not support: any claim about fluorescence, light-field microscopy or spatially varying aberration (one global map); any acquisition-time figure; a claim that such methods "cannot" be used with fluorescence (the paper only says OFC "may extend").

## Differences to state if cited

- OFC uses coherent laser illumination and amplitude-only measurements; the thesis images incoherent fluorescence emission.
- OFC needs 81 sequential SLM-gated exposures; the thesis method is single-shot.
- OFC is model-based (Zernike modes plus alignment parameters, simulated annealing) and returns a pupil aberration map; the thesis method estimates no pupil or wavefront and treats aberrations as local shifts between views.
- OFC removes one global aberration; the thesis targets local misalignment.

## Still unread

- Figures were read through captions only.
- No supplement is referenced.
- The exact printed page of the coherence text (within pp. 24077-24078) and of Sec. 2.2 (within pp. 24067-24068) could not be resolved from the footers.

## Safe Wording

Overlapped Fourier coding steps a small aperture across the pupil of a camera and records 81 images under spatially coherent illumination, from which it estimates a low-order (Zernike) aberration map and a complex sample field by simulated annealing (Horstmeyer et al. 2014, Secs. 2-4, pp. 24065-24078); the authors suggest extension to fluorescence only as a future possibility (p. 24080).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Consider if distinguishing pupil-plane scanning from illumination-angle scanning. The experiment uses sequential snapshots with controlled aperture positions.
