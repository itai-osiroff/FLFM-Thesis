# Demmerle 2017 - Strategic and practical guidelines for successful SIM

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Justin Demmerle, Cassandravictoria Innocent, Alison J North, Graeme Ball, Marcel Mueller, Ezequiel Miron, Atsushi Matsuda, Ian M Dobbie, Yolanda Markaki and Lothar Schermelleh, "Strategic and practical guidelines for successful structured illumination microscopy", Nature Protocols 12(5), 988-1010, 2017 (protocol; published online 13 April 2017). DOI 10.1038/nprot.2017.019 (printed on the first page). No discrepancy with the assignment metadata (volume 12, pages 988-1010, 2017); issue 5 is printed in the page footer ("VOL.12 NO.5"). Page 1010 itself was not seen in the text (see below).

## What was read

File C4d_14.txt (23 PDF pages, printed pp. 988-1010 plus). Read: abstract, Introduction, Box 1, Figs 1-7 captions, Overview, Limitations, Experimental design, System calibration and OTF sections, Box 2, Materials list (skimmed), Procedure steps 8-33, Timing, Table 2, Table 3 and Anticipated Results. Not read in detail: Procedure steps 1-7 (bead-slide preparation, partly seen), the reference list and the last text lines of the file, and all Supplementary material (Supplementary Figs 1-10, Supplementary Table 1, Supplementary Manual), which is not in the file. The text file is not valid UTF-8 and the multi-column pages interleave; Table 3 is partly garbled. Figure panels were not interpreted, only the captions. Anchors below are single-line phrases from the left or right column.

## Why This Matters

A protocol by SIM-facility specialists listing what goes wrong in linear 2D/3D SIM and how to check it. It gives the practical basis for saying that SIM depends on an OTF matched to the sample, is sensitive to refractive-index (RI) and spherical aberration, and needs many raw images and calibration.

## Key Claims (paraphrased)

- **Reliance on algorithms and OTF (p. 988-989).** Linear SIM relies on post-processing, which makes it particularly sensitive to artifacts. The reconstruction operates in Fourier space using the OTF and assumes detected light behaves like the acquired PSF, so any mismatch between the OTF and the sample information leads to artifacts. [anchor: "relies on the optical transfer function (OTF)"] [anchor: "will inevitably lead to arti"]
- **Spherical aberration and reconstruction (Box 1, p. 990).** Irregularities such as spherical aberration substantially change the amplitude of information transfer with spatial frequency, so the algorithm can no longer correctly match components. [anchor: "Irregularities such as spherical aberration substantially affect the"]
- **Modulation contrast (pp. 990-991).** Achieved resolution gain depends on stripe contrast on the sample; with no contrast no resolution gain. Major causes of low contrast in biological samples are low SNR and spherical aberration from RI mismatch between immersion medium, mounting medium and sample. [anchor: "practical achievement of the theoretical resolu"] [anchor: "In the extreme case of no modulation contrast, no"]
- **Coherent source (Box 1, p. 990).** A laser (coherent source) is required for maximum contrast; LEDs only with compromises. [anchor: "a coherent light source (i.e., a laser) capable of introducing"]
- **Number of raw images (Fig. 2a, p. 991; Box 1, p. 990).** The 3D-SIM raw set is 15 acquisitions (3 angles, 5 phases) per plane; the phase step size is stated as a fifth of a period (five steps per cycle). [anchor: "typically five steps within the sinusoidal cycle"] [anchor: "SIM raw images (15 acquisitions: 3 angles, 5 phases)"]
- **Photon budget (p. 998).** 3D-SIM needs up to 30 times the number of acquisitions per 3D frame compared with wide-field deconvolution (5 phases, 3 angles, twofold z-sampling), so brightness and photostability of the dye are main selection criteria. [anchor: "requiring up to 30-fold the number"]
- **Photobleaching (pp. 994, 998-999, 1006).** Some fluorophores are not photostable enough for the repeated exposures of SIM; contrast must be balanced against bleaching rate; acquiring full stacks per angle consecutively is more prone to bleaching artifacts than angles interleaved per plane; raising laser power or exposure to gain dynamic range is limited by photobleaching. Reported exposure times for fixed cells are 20-100 ms. [anchor: "do not have sufficient photostability to tolerate the"] [anchor: "acquiring full stacks for each angle consecutively"] [anchor: "until photobleaching becomes limiting"]
- **Sample requirements (p. 995).** Thicker specimens (more than several tens of microns, such as whole mounts or most tissue sections) are often impractical because of excessive spherical aberration, light scattering and out-of-focus blur, which limit stripe contrast; the sample must hold still during one frame (live cells need slow dynamics). [anchor: "impractical for SIM because of excessive spherical aberration"]
- **RI mismatch (p. 993, 1000).** RI mismatch is called a primary cause of SIM artifacts and among the easiest parameters to adjust. High-end objectives are corrected only under ideal conditions (170 um coverslip, matched RI of sample and immersion), so the sample is part of the optical system; the larger the RI mismatch, the larger the aberration with increasing z-depth; temperature changes the effective RI of oil. [anchor: "As RI mismatch is a primary cause of SIM artifacts"] [anchor: "Thus, the sample needs to be regarded as an integral part of the"] [anchor: "degree of aberration with increasing z-depth"]
- **Silicone objectives (p. 998).** With silicone oil objectives (RI about 1.40, close to mounting media 1.37-1.39) RI-mismatch distortion becomes negligible and scattering rather than spherical aberration is the limiting factor, at the cost of lower NA (1.30-1.35). [anchor: "light scattering rather than spherical aberration"]
- **Matching the OTF (p. 1000).** The OTF encodes the level of spherical aberration and the modulation contrast; OTFs measured under the same suboptimal conditions as the sample give better reconstructions than "ideal" OTFs; empirically measured, channel-specific OTFs give better results than theoretical ones because optical elements add aberrations. The recommended correction is by choice of immersion-oil RI, correction collar and a matched measured OTF; it is chosen per channel and per depth, not per pixel. [anchor: "matching a data set acquired under less favo"]
- **Artifact list (pp. 989, 1006-1009, Table 3).** Hammerstroke (reconstructed noise or low modulation), lensing (RI mismatch in the sample), hatching (wrong stripe angle k0 or fit failure), ghosting (RI/spherical aberration mismatch), honeycomb (out-of-focus light, missing cone), z-wrapping, motion/drift, channel misalignment. Wrong parameters or fitting errors can cause severe hatching. [anchor: "settings or fitting errors can cause severe"] [anchor: "Adjust RI of the acquisition"]
- **Reconstruction checks (Steps 29-33, p. 1004; p. 1000-1001).** Reconstruct without discarding negative values, set the Wiener filter from the SIMcheck modulation-contrast-to-noise ratio, and run the SIMcheck spherical-aberration-mismatch check (z-minimum variance, ZMV) and the max-to-min ratio (MMR) check. Quality is also inspected with Fourier plots. Thresholding negatives is called the most common oversight. [anchor: "Perform the spherical aberration mismatch check on the reconstructed"] [anchor: "Perhaps the most common oversight in reconstruction is the dis-"]
- **Limits (p. 993; p. 1001).** The protocol cannot overcome fundamental restrictions of SIM regarding resolution and photostability; computational artifact-correction methods exist but often cost spatial resolution. [anchor: "it cannot overcome fundamental"] [anchor: "artifacts computationally have been described"]
- **Calibration burden (p. 999).** Pattern generation is delicate; even minor disturbances (dust, fingerprints on the objective back) strongly affect reconstruction; five bead calibration slides are recommended; calibration of PSF/OTF sets takes about 2 h with practice. [anchor: "even minor"] [anchor: "calibration slides utilizing various types of synthetic fluorescent"]

## Relevance to the thesis

- Supports: G29 (SIM requires many raw images and a reconstruction that depends on a matched OTF; sensitive to RI mismatch and spherical aberration, to parameter and reconstruction artifacts; needs laser coherence for best contrast; strict calibration). G24 in part: RI mismatch of sample, mounting medium and immersion, sample depth and temperature degrade imaging; the sample is part of the optical system.
- Does not support: G25 (no statement that software solutions are slow or amplify noise in general; the noise remark concerns SIM raw data and the Wiener filter), G26 and G27 (adaptive optics, wavefront sensors and deformable mirrors are not discussed; the corrections it offers are immersion-oil RI, correction collar and OTF matching). Not a source for AO, defocus diversity, light-field or multi-view imaging.

## Differences to state if cited

- SIM here is linear 2D/3D SIM on commercial platforms (OMX, Elyra, N-SIM); reported numbers (RI steps of 0.002, 20-100 ms) were determined on a GE OMX V3 Blaze and may differ between systems (stated in the Fig. 7 caption).
- The aberration it treats is mainly spherical aberration from RI mismatch with depth, handled by matching a measured OTF, not by estimating pupil or per-view shifts.
- It is a protocol: statements on cost are about time and money lost to unsuccessful imaging, not hardware cost of correctors.

## Still unread

- Procedure steps 1-7 (bead slide preparation) and the Materials details, in full.
- Reference list and the end of the text file (the final printed page, 1010, was not located in the text read).
- All Supplementary material (Supplementary Manual, Figs 1-10, Table 1), cited for the artifact images, matrices of sample/OTF RI and temperature effects.
- Figure panels (captions only).

## Safe Wording

Structured illumination reconstruction assumes that the detected light follows the measured point-spread (optical transfer) function, so a mismatch caused for example by refractive-index-induced spherical aberration leads to reconstruction artifacts, and the sample must be treated as part of the optical system (Demmerle et al. 2017, pp. 989, 1000).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use if discussing practical SIM quality control. The protocol supports SIM-specific pitfalls and calibration requirements.
