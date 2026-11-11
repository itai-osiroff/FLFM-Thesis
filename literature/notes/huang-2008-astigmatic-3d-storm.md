# Huang 2008 - 3D STORM by astigmatism

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Bo Huang, Wenqin Wang, Mark Bates, Xiaowei Zhuang, "Three-Dimensional Super-Resolution Imaging by Stochastic Optical Reconstruction Microscopy", Science 319(5864), 810-813, 8 February 2008. DOI printed: 10.1126/science.1153529 (published online 3 January 2008). The assignment metadata matches; no discrepancy.

## What was read

File C4e_27.txt, which holds 5 PDF pages: (1) journal p. 810 (the top of the page carries the end of an unrelated preceding article's references, which was ignored), (2) p. 811, (3) p. 812, (4) p. 813 (the reference list of this paper continues here, followed by an unrelated article), (5) the Science download cover page. The text file therefore starts mid-page but the title page and the full main text (abstract, introduction, results, figure captions, reference list) are present. The Supporting Online Material (Materials and Methods, figs. S1-S2, movie S1) is not part of the file and was not read; the paper defers the analysis details (defocusing fit function, calibration procedure, z rescaling) to it. The text is partly two-column interleaved but readable.

## Why This Matters

This is the standard citation for astigmatic 3D localization in single-molecule super-resolution microscopy: a weak cylindrical lens turns the PSF into an ellipse whose shape encodes z. It illustrates, like Kao and Verkman 1994, that a deliberately added aberration plus a calibration curve gives depth, but only for sparse, photoswitched emitters.

## Key Claims (paraphrased)

- **Principle (p. 810).** A weak cylindrical lens in the imaging path gives the x and y directions slightly different focal planes, so the ellipticity and orientation of a fluorophore's image change with z: round at the average focal plane, long axis along x above it, along y below it. Fitting a 2D elliptical Gaussian gives the x, y peak position and the widths wx and wy, from which z is determined unambiguously. [anchor: "ellipticity and orientation of a fluorophore's"]
- **Credit to earlier work (p. 810).** The paper cites Kao and Verkman 1994 and Holtzer et al. 2007 for astigmatism, and defocusing papers for the other way to get z. [anchor: "defocusing (21"]
- **Calibration (p. 810-811).** A calibration curve of wx and wy against z is measured by scanning the sample in z over immobilized Alexa 647-labeled streptavidin molecules or quantum dots on glass; each point is the average of six molecules and is fitted with a defocusing function (details in the unread SOM). Each molecule's z is then found by comparing its measured wx and wy with the curves. For samples in aqueous solution on glass, all z values are rescaled by 0.79 to account for the refractive-index mismatch between glass and water. [anchor: "all z localizations were rescaled by a factor"]
- **Accuracy (p. 811-812, Fig. 1C).** From repeated switching of single immobilized molecules within 100 nm of the average focal plane, standard deviations were 9 nm in x, 11 nm in y and 22 nm in z (FWHM 21, 26 and 52 nm), with an average of about 6000 photons per switching cycle. z accuracy was about twice the lateral accuracy. In cells, isolated antibody clusters gave FWHM 22, 28 and 55 nm. [anchor: "were 9 nm in x, 11 nm in y, and 22"]
- **Resolution claim (Abstract).** The authors state image resolution of 20-30 nm laterally and 50-60 nm axially. [anchor: "nanometers in the lateral dimensions and 50 to 60 nanometers in the axial dimension"]
- **Depth limit (p. 812).** Image width grows away from focus, so localization accuracy falls with |z|, especially laterally. A usable z range of about 600 nm near the focal plane was chosen (accuracy varying by less than 1.6 laterally and 1.3 axially versus the focal plane); larger depth may need z scanning in future. [anchor: "we typically chose a z imaging depth of about"]
- **Sparse activation is required (p. 810, 812).** STORM relies on single-molecule detection and photoswitchable probes to separate otherwise overlapping molecular images in time, and images are built from iterative stochastic activation of sparse, optically resolvable subsets. No extra acquisition time per molecule is needed for 3D compared with 2D STORM. [anchor: "activation of sparse subsets of optically resolv-"]
- **Probes and acquisition (p. 810-812).** Cy3 and Alexa 647 activator-reporter pairs, 657 nm and 532 nm lasers, TIRF or epifluorescence, an EMCCD; many frames are needed to build one image (acquisition time per image not stated in the main text). [anchor: "photoswitchable probes enables"]
- **Applications (p. 811-812).** Microtubules in BS-C-1 cells resolved in 3D, with two filaments about 100 nm apart in z separated; clathrin-coated pits shown as half-spherical cages. [anchor: "Multiple layers of"]

## Relevance to the thesis

- Supports: G30, in the engineered-PSF sense: depth is read from the astigmatic shape of single-emitter images via a pre-measured calibration curve. It also supports a statement that 3D localization methods depend on sparse emitters and calibration.
- Does not support: G24-G27 (nothing on aberration correction, AO or deconvolution in the main text). Not for dense extended scenes: the main text is explicitly about photoswitched sparse subsets of molecules. No light-field or multi-view statement. No statement on spatially varying aberration.

## Differences to state if cited

- Single-molecule localization with temporal separation of emitters (many frames, photoswitchable dyes); the thesis is a single-shot method for an extended 2D scene.
- Astigmatism is deliberately added and calibrated; the thesis treats aberration as an unknown shift between views and does not use a PSF model.
- Axial range about 600 nm usable here.
- Calibration beads or molecules must be measured, and an index-mismatch rescale (0.79) is applied for aqueous samples.

## Still unread

- Supporting Online Material: Materials and Methods, figs. S1-S2, movie S1 (fit function, drift correction, acquisition times, frame counts).
- Cited works.

## Safe Wording

Huang et al. introduced a weak cylindrical lens into the imaging path so that the ellipticity of a single fluorophore's image encodes its axial position, which is read from a calibration curve of the two image widths; with sparsely activated photoswitchable probes they reported localization standard deviations of about 9 nm, 11 nm and 22 nm in x, y and z over a depth of about 600 nm (Science 319, p. 810-812).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use if extending Kao and Verkman into 3D single-molecule localization. The PDF begins on a shared journal page; the STORM article occupies printed pp. 810–813.
