# Ayuk 2013 - Filtered blind-SIM with distorted excitations

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

R. Ayuk, H. Giovannini, A. Jost, E. Mudry, J. Girard, T. Mangeat, N. Sandeau, R. Heintzmann, K. Wicker, K. Belkebir, A. Sentenac, "Structured illumination fluorescence microscopy with distorted excitations using a filtered blind-SIM algorithm", Optics Letters 38(22), 4723-4726, 2013 (issue dated November 15, 2013; published online November 12, 2013). DOI 10.1364/OL.38.004723 (printed on the paper). No discrepancy with the assignment metadata.

## What was read

C4d_23.txt, all four PDF pages (printed pp. 4723-4726): abstract, main text, figure captions, conclusion, reference list. Complete. The figures themselves (Figs. 1-3) were not inspected as images, only their captions and the text describing them. The tool output flagged the file as non-UTF-8 (garbled symbols and equations); the equations were read only approximately, which does not affect the claims below.

## Why This Matters

It states directly that aberrations in the excitation pattern wreck standard SIM, and shows a reconstruction that tolerates them by estimating the patterns from the data. It is a concrete example of coping with aberrations computationally, at the price of many sequential images and an iterative inverse problem, which contrasts with a single-shot, model-free alignment.

## Key Claims (paraphrased)

- **SIM is sensitive to aberrations (abstract, p. 4723).** SIM gives super-resolved fluorescence maps but is very sensitive to aberrations or misalignments of the excitation patterns. [anchor: "very sensitive to aberrations or misalignments affecting the excitation patterns"]
- **Sample-induced distortion (p. 4723).** Even with good experimental control, the pattern distortion and misalignment caused by the sample itself cannot be avoided; this matters most when the illumination frequency is close to the detection cutoff. [anchor: "and misalignment induced by the sample itself cannot be"]
- **What standard SIM needs (p. 4723).** For correct reconstruction the pattern must stay periodic inside the sample and its position in every image must be known very precisely; earlier a-posteriori position/period estimators assume periodicity and cannot handle distortion (refs. 10, 11). [anchor: "it is crucial that the excitation pattern remain periodic"]
- **Method (pp. 4723-4724).** The sample and the L illumination patterns are estimated jointly by iterative conjugate-gradient minimization of a cost functional, using only that the patterns average to a roughly homogeneous field and that the fluorescence density is positive. [anchor: "average is roughly homogenous over the sample"]
- **Filter (p. 4724).** An extra constraint confines each pattern's Fourier transform near the three approximately known peaks of the sinusoidal grating, using Gaussian filters whose width was set to 20% of the approximate grid frequency after several trials. [anchor: "a width equal to 20% of the approximate light"]
- **Simulation (pp. 4724-4725).** Synthetic 2D sample, NA 1.49, three orientations with three shifts each (nine images), Poisson plus Gaussian noise. With aberrated patterns (astigmatism and coma) the filtered method recovered the distorted illumination and gave an artifact-free image, while classical SIM was significantly deteriorated. [anchor: "three shifts of one-third of the period were performed"]
- **Experiment (p. 4725).** Home-built epi-illumination SIM, 633 nm, NA 1.49 objective, three orientations and eight shifts each (24 images); a granular plastic sheet in the illumination path introduced uncontrolled aberrations; same field and conditions with and without it. [anchor: "placing a transparent plastic sheet on the"]
- **Experimental outcome (pp. 4725-4726).** Filtered blind-SIM with the sheet stayed close to its undistorted result; classical SIM showed more background noise and large changes in sample features. Bead samples were said to behave similarly (data not shown). [anchor: "SIM reconstruction was strongly degraded with both"]
- **PSF assumed known (p. 4725).** For all reconstructions the detection PSF was measured by averaging images of isolated fluorophores; only the illumination is treated as unknown. [anchor: "the PSF was determined experimentally"]
- **Limitation, 2D only (p. 4724).** The algorithm is implemented for two-dimensional data, restricting it to in-focus thin samples; 3D and thick samples are future work. [anchor: "restricts its use to in-focus thin samples"]
- **Requirement (p. 4726).** Needs only approximate pattern frequencies (within a 20% margin) and no regularization tuning. [anchor: "approximate knowledge of the pattern spatial"]

## Relevance to the thesis

- Supports: G29 (SIM needs several images, sensitive to illumination-pattern aberrations, blind/computational methods used to cope; images needed: 9 simulated, 24 experimental). G24 weakly (sample-induced distortion unavoidable; but this concerns the illumination, not emission).
- Does not support: G25 or G26 (no wavefront sensing, no AO; the paper's coping strategy is an inverse-problem algorithm, not PSF deconvolution of aberrated detection). Not a statement about aberrations of the detection PSF: the PSF is measured and assumed known. Not evidence about light-field or multi-view imaging, nor about runtime, cost, or noise amplification (computation time not stated). Not for a claim that SIM is sensitive to aberrations in the PSF.

## Differences to state if cited

- The distortion handled here is in the excitation patterns, estimated per image and per pixel (so spatially varying), not emission aberrations of the imaging path.
- It needs many sequential exposures with a patterned illuminator; the thesis method uses one exposure and no illumination control.
- Reconstruction is an iterative inverse problem with positivity and a measured PSF; the thesis method is shift-based alignment.
- Aim here is resolution beyond the diffraction limit of a 2D in-focus sample; not depth or 3D.

## Still unread

- Figure images (only captions read); any supplementary material (none referenced in the text). Acquisition time and reconstruction runtime: not stated.

## Safe Wording

Structured illumination microscopy is very sensitive to aberrations or misalignments of the excitation patterns, and blind reconstruction of both sample and illumination can tolerate strongly distorted patterns, but only in two dimensions and from many sequential images (Ayuk et al., 2013, pp. 4723, 4726).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Use if comparing a computational response to distorted illumination. The test addresses excitation distortion under the paper's detection model.
