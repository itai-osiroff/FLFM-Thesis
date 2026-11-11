# Dong 2014 - Pattern-illuminated Fourier ptychography for fluorescence

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Siyuan Dong, Pariksheet Nanda, Radhika Shiradkar, Kaikai Guo, Guoan Zheng, "High-resolution fluorescence imaging via pattern-illuminated Fourier ptychography", Optics Express 22(17), 20856-20870, 2014. DOI 10.1364/OE.22.020856 (printed on the paper). Received 8 May 2014, published 21 Aug 2014 (issue date 25 Aug 2014). No discrepancy with the assignment metadata.

## What was read

C4c_04.txt, all 15 PDF pages (printed pp. 20856-20870), including abstract, Sections 1-5, figure captions and references list. Figures themselves were not inspected as images; only captions and text were used. No supplement is mentioned in the text.

## Why This Matters

It is the primary source for the statement that original Fourier ptychography (FP) is coherent and cannot be used on fluorescence, and for the one fluorescence-compatible variant that exists in this line of work. The variant is still sequential (tens of images, moved sample or rotated pattern) and is a resolution-enhancement method for a 2D sample, not an aberration-correction method.

## Key Claims (paraphrased)

- **FP is coherent, so not directly usable for fluorescence (Sec. 2, p. 20859).** Original FP is a coherent technique using angle-varied LED illumination to recover a high-resolution complex image. The authors say it cannot be used for fluorescence because fluorophores do not respond to the phase of the excitation wave, so changing the illumination angle leaves the emission unchanged and adds no information. [anchor: "fluorophores are not responsive to phase variation of the excitation waves"]
- **What "pattern illumination" means (Sec. 2, p. 20859).** The fix is to replace plane-wave illumination by intensity-varied patterns, to which fluorophores do respond. Each low-resolution image then carries extra high-frequency information about the sample emission. [anchor: "replace the plane wave illuminations with intensity-varied patterns"]
- **Forward model is incoherent (Sec. 2, Eq. 1, pp. 20859-20860).** Each measurement is the sample emission times the illumination pattern, then filtered by the incoherent optical transfer function (OTF) of the objective. The recovery alternates between spatial-domain updates (intensity constraint) and Fourier-domain updates (incoherent OTF as support). It is iterative, converging in about 5-20 loops. [anchor: "incoherent optical-transfer-function of the objective lens"]
- **Unknown pattern allowed (Sec. 2, Eq. 4, p. 20861; Sec. 3, p. 20863).** One unknown speckle pattern, translated to different positions (scan step on the order of the speckle size), is enough; the algorithm recovers the sample and the pattern together. Unlike conventional SIM, no phase stepping of a known sinusoid is needed. [anchor: "reported algorithm requires no phase stepping of the sinusoidal pattern"]
- **Number of images (Sec. 3 and 4, pp. 20861-20869).** Simulation with sinusoidal patterns: 18, 36 and 54 raw images (orientations only; extra illumination NAs add 18 each). Simulation with a translated speckle: 169 positions. Experiment: 49 sample positions on a Nikon Ti-E epi-fluorescence microscope, 488 nm laser diode with a diffuser in the reflector cube, 10X 0.25 NA objective, Andor Clara CCD, mouse kidney section. The authors report that reconstruction converges at 25 raw images (compared 9, 16, 25, 49). [anchor: "the FP reconstruction converges with 25 raw images"]
- **Resolution gain (Sec. 4, pp. 20867-20868).** Two lines 0.66 um apart, unresolved at 10X, are barely resolved after reconstruction and match a 40X reference image. Estimated NA of the recovered image is about 0.44, an enhancement of about 1.8 against a theoretical limit of 2 for epi geometry (same objective for illumination and collection). [anchor: "resolution enhancement factor is ~1.8, close to the theoretical limit of 2"]
- **Acquisition and compute (Sec. 5, p. 20870).** Scanning range is restricted to 15 um by 15 um (on the order of the speckle size). Compute is under one second on an Intel i7 CPU. Acquisition time of the 49-frame set is not stated. [anchor: "computational time is less than one second using an Intel i7 CPU"]
- **Limitations stated (Sec. 5, p. 20870).** (1) Epi configuration caps the gain at 2. (2) Sample scan positions are assumed known (needs a precise stage). (3) The sample is assumed to be a 2D section; a 3D treatment is future work. [anchor: "We assume the sample is a 2D section"]
- **Aberration is not treated in this paper (Sec. 5, p. 20870).** The reconstruction uses the ideal incoherent OTF of the objective. The authors only note that the earlier pupil-recovery scheme [38] and the adaptive system correction scheme [41] could be integrated into the framework in future. No aberration experiment or simulation is reported. [anchor: "can be integrated into the reported framework for factoring out system uncertainties"]
- **Relation to SIM (Sec. 1, p. 20858; Sec. 3, p. 20862).** Typical SIM uses a sinusoidal pattern with at least three phase steps per orientation; the authors state the resolution effect of their scheme is essentially the same as SIM (frequency mixing). The paper also compares against deconvolution of the diffraction-limited image in simulation (Figs. 4 and 7). [anchor: "uses at least three phase steps to laterally shift the pattern"]
- **Robustness in simulation (Sec. 3, pp. 20862-20866).** Simulated errors tested: additive Gaussian noise, pattern rotation or positional error, uniform background. MSE rises with each; at 100% background MSE reaches about 10%. [anchor: "robust against rotational error and auto-fluorescence background level"]

## Relevance to the thesis

- Supports G28: FP as originally formulated is coherent and needs many sequential captures, and is not directly applicable to fluorescence emission (p. 20859). Supports the statement that a fluorescence variant exists but then needs patterned excitation and tens of sequential frames (49 in the experiment, 18-54 in sinusoidal simulations).
- Supports G29 in part: the paper describes SIM as needing multiple images with shifted or rotated patterns and a reconstruction (p. 20858), and presents itself as an alternative to SIM. It does not itself state that SIM is sensitive to aberrations.
- Does not support: any claim that FP or this method corrects aberrations in fluorescence (aberration is not treated). Does not support claims about light-field, multi-view, 3D or depth (2D only, 3D is future work). Does not support claims about acquisition time (not stated) or about speed relative to other methods.

## Differences to state if cited

- It is not the original FP (Zheng 2013); it keeps the FP-style iterative update but changes the physics to incoherent emission with patterned excitation.
- It needs controlled excitation (diffuser plus stage scanning), not just a camera, so it is active-illumination and sequential, whereas the thesis method is a single-shot capture of the emission.
- Resolution gain here is lateral, up to 2 in epi mode, whereas the thesis method targets aberration-robust recovery of a 2D scene, not resolution beyond the NA.
- Experimental validation is on one sample and one objective; most robustness claims are simulation only.

## Still unread

- Figures as images (only captions and text read). Reference list read but not followed up. No supplement referenced.

## Safe Wording

Fourier ptychography in its original form is a coherent technique and cannot be applied directly to fluorescence, because fluorophores do not respond to the phase of the excitation; a fluorescence variant instead uses intensity-patterned excitation and a stack of sequential images, 49 in the reported experiment (Dong et al. 2014, Sec. 2, p. 20859; Sec. 4, p. 20867).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Use if naming a direct fluorescence adaptation of the FP framework. Its excitation diversity and incoherent intensity model distinguish it from classical angle-scanned pupil recovery and from Chung's modality transfer.
