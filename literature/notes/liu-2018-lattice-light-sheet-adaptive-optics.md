# Liu 2018 - Observing the cell in its native state (AO lattice light-sheet)

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

T.-L. Liu, S. Upadhyayula, D. E. Milkie, V. Singh, K. Wang, I. A. Swinburne, K. R. Mosaliganti, Z. M. Collins, T. W. Hiscock, J. Shea, A. Q. Kohrman, T. N. Medwig, D. Dambournet, R. Forster, B. Cunniff, Y. Ruan, H. Yashiro, S. Scholpp, E. M. Meyerowitz, D. Hockemeyer, D. G. Drubin, B. L. Martin, D. Q. Matus, M. Koyama, S. G. Megason, T. Kirchhausen, E. Betzig, "Observing the cell in its native state: Imaging subcellular dynamics in multicellular organisms", Science 360(6386), eaaq1392 (20 April 2018), DOI 10.1126/science.aaq1392 (printed on the paper). No discrepancy with the assignment metadata (the assignment gave Science 360, eaaq1392, 2018).

## What was read

C4a_09.txt, which is 14 printed pages of the article (page footers "1 of 13" to "13 of 13") plus a one-page research summary at the start and a one-page Science editor's summary at the end (16 PDF pages in total; article page N of 13 is PDF page N+1). Read: the research summary, the introduction and AO system description (p. 1), the first results on PSF correction and deconvolution (pp. 2-3), the whole "Tiled acquisition for aberrations varying in space and time" section (pp. 6-7), the Discussion and its caveats (pp. 11-12), and the Methods on the AO subsystem (pp. 12-13). The biology results sections (clathrin, mitosis, axon growth cones, immune and cancer cells, roughly pp. 3-5 and 7-11) were only searched by keyword for aberration, wavefront and Shack-Hartmann statements, not read in full. The supplementary material (supplementary notes 1-6, figs. S1-S20, table S1, movies) is NOT in the file and was NOT read; the main text only points to it. Figures were read through captions only.

## Why This Matters

The state-of-the-art example of hardware AO in a high-resolution fluorescence microscope: a Shack-Hartmann sensor reading a two-photon guide star plus a deformable mirror and a spatial light modulator, with the authors themselves stating that corrections are valid only over small isoplanatic patches and that field-wide correction would need multiconjugate AO at substantial cost and complexity. This is a good primary source for G26 and G27 (spatially varying versus invariant correction), and for G24.

## Key Claims (paraphrased)

- **Aberration source (p. 1, Introduction).** The inhomogeneous refractive index of multicellular specimens causes sample-induced aberrations that AO corrects. [anchor: "rations caused by the inhomogeneous refractive"]
- **Additional aberration sources (p. 11, Discussion).** AO-LLSM corrects not only sample-induced aberrations but also those from the mounting and immersion media and imperfections in the optical path of the microscope. [anchor: "ing and immersion media (e.g., Fig. 1E) or imper-"]
- **Detection and excitation see different aberrations (p. 1).** In LLSM, light passes through different specimen regions for excitation and detection, so independent AO systems are used for each. [anchor: "Hence, independent AO systems are needed"]
- **Direct sensing with a guide star (p. 1; Methods p. 12).** A two-photon-excited fluorescent guide star is scanned in the specimen, its light is descanned and sent to a Shack-Hartmann wavefront sensor, and the inverse of the measured aberration is applied to a deformable mirror (detection) or to the SLM that also forms the light sheet (excitation). The paper does not use the terms "direct" or "indirect" for its own method (only in a cited title, ref. 8); it is a Shack-Hartmann measurement on a guide star. [anchor: "to a Shack-Hartmann wavefront sensor (DSH)"]
- **Guide-star limits (p. 11).** Accurate sensing needs a sufficient guide-star signal; absorbing structures (blood vessels, melanin) in the detection cone can block guide-star light from enough sensor cells. Only weakly scattering specimens can be imaged because detection is widefield. [anchor: "for accurate wavefront measurement. Highly"] and [anchor: "only weakly scattering specimens"]
- **Scanning gives an average correction (p. 1).** Scanning the guide star over the region gives an average correction that is often more accurate than a single-point correction, which matters because a poor AO correction is often worse than none. [anchor: "that is often more accurate than single-"]
- **Correctors (pp. 1, 12).** An SLM is used for excitation because the lattice light sheet occupies only a thin annulus at the pupil, so a pupil-conjugate DM would be ineffective over most of its surface; the SLM offers thousands of independently corrective pixels. Detection correction uses a DM (ALPAO 97-15 per Methods). [anchor: "of independently corrective pixels. To do so, we"]
- **Aberrated deconvolution (p. 3).** Applying deconvolution to an aberrated image gives a distorted result because the OTF falls below the noise floor asymmetrically; accurate deconvolution needs AO first. [anchor: "applying deconvolution to an aberrated image"]
- **Isoplanatic patch size (p. 6).** The size and temporal stability of the isoplanatic patch (the field over which a single AO correction is valid) are difficult to estimate a priori; empirically, in zebrafish embryos younger than 72 hpf, one excitation-detection correction pair is usually valid over 30 to 60 micrometres in each direction for at least 1 hour. [anchor: "difficult to estimate a priori the size or temporal"] and [anchor: "is usually valid across 30 to 60 mm"]
- **Tiled correction (p. 6, Fig. 4).** For larger volumes, independent AO correction per tile (e.g. 7 by 7 by 3 tiles) is needed. A centre-tile correction applied to all tiles gives better results at the centre but, outside the isoplanatic patch, worse resolution than no correction at all. [anchor: "was outside the isoplanatic patch over which the"]
- **Tile maps determined empirically (p. 11).** Wavefront variation across a specimen can at present only be determined empirically for each specimen type and developmental stage to decide how to tile; tile maps tend to be consistent between specimens of the same type and age. C. elegans may need a denser mesh of corrections. [anchor: "determined empirically for each specimen type"]
- **Cost and complexity (pp. 11-12).** For conventional wide-field light-sheet microscopes, one AO correction gives only partial correction, tiling would negate their high-speed, large-field advantage, and simultaneous full-field correction would likely need multiconjugate AO, substantially increasing cost and complexity. [anchor: "would negate the high-speed, large-"] and [anchor: "tially increasing cost and complexity"]

## Relevance to the thesis

- Supports: G24 (sample refractive-index heterogeneity, plus mounting media and microscope imperfections, p. 1 and p. 11). G26 (a Shack-Hartmann sensor with a two-photon guide star driving a DM or SLM, pp. 1 and 12). G27 (spatially varying correction: a single correction is valid only over an isoplanatic patch of tens of micrometres, tiled per-region correction is used, and the authors say full-field simultaneous correction would substantially increase cost and complexity, pp. 6 and 11-12). Note that the cost and complexity sentence refers to multiconjugate AO for large-field light-sheet systems, not to deformable mirrors in general.
- Does not support: G25 (software PSF estimation; deconvolution here uses a measured, system-corrected PSF after AO, not a blind estimate). A claim that deformable mirrors themselves are expensive (no price given). A claim that corrections are "usually" spatially invariant: the paper shows the opposite need and handles it by tiling. G30. Any statement about scattering inversion; the paper says only weakly scattering specimens can be imaged.

## Differences to state if cited

- The imaging modality is a lattice light-sheet microscope with two optical paths, not widefield epi-fluorescence or light-field microscopy.
- The system needs a guide star (two-photon laser) and a Shack-Hartmann sensor on each arm; the paper does not discuss image-based (sensorless) AO as an alternative.
- Isoplanatic patch numbers (30 to 60 micrometres) are empirical for zebrafish embryos below 72 hpf and are not general.
- The 2018 text states cost and complexity only for multiconjugate AO; it does not compare against software correction.

## Still unread

- The supplementary notes (1 to 6), figs. S1 to S20 and table S1 are not in the file (notes on system design, descanning, tile geometry, simulated aberration effects, fig. S19) and were not read.
- Biology results sections (pp. 3-5, 7-11) were keyword-searched only.
- Figure image content was not inspected.

## Safe Wording

Adaptive-optics lattice light-sheet microscopy measures aberrations from a scanned two-photon guide star with a Shack-Hartmann sensor and corrects them with a deformable mirror or spatial light modulator, but a single correction is valid only over an isoplanatic patch of tens of micrometres, so larger volumes need tiled corrections, and simultaneous full-field correction would require multiconjugate AO at substantially higher cost and complexity (Liu et al. 2018, pp. 1, 6, 11-12).
