# Tao 2011 - Direct wavefront sensing with fluorescent protein guide stars

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Xiaodong Tao, Oscar Azucena, Min Fu, Yi Zuo, Diana C. Chen, Joel Kubby. "Adaptive optics microscopy with direct wavefront sensing using fluorescent protein guide stars." Optics Letters 36(17), 3389-3391, 2011 (published 24 August 2011 online, issue dated 1 September 2011; Doc. ID 147708). No DOI is printed on the paper. No discrepancy with the metadata in the assignment.

## What was read

C4a_14.txt, all 3 PDF pages (printed pages 3389-3391), including the abstract, the whole text, figure captions and the reference list. Numbers with unit symbols that were garbled in the text extraction (RMS errors in wavelength units) were checked against the PDF images of pages 3390 and 3391. Figures were not interpreted in detail beyond their captions. Not read: the cited methods papers (refs 4-6, 10-14).

## Why This Matters

A short, clear statement of why direct wavefront sensing in tissue has been rare (no natural guide star; indirect methods bleach; backscatter depends on tissue; injected beads are invasive) and a confocal demonstration that a Shack-Hartmann sensor plus a deformable mirror can use a genetically expressed fluorescent protein as the guide star. Useful for G26 and G27; the demonstration is for a single corrected region in fixed tissue.

## Key Claims (paraphrased)

- **Aberration source (p. 3389).** Aberrations are induced by the inhomogeneous optical properties of the sample and degrade the image. [anchor: "optical properties of the sample distort the light and"]
- **Why a guide star is needed and hard to find (p. 3389).** Wavefront sensors often need a guide star, a point-like reference behind the inhomogeneous medium. Astronomy has natural and laser-generated guide stars, but the authors say it is hard to find one in biological tissue. [anchor: "star has been used in astronomy. However, it is hard to"] [anchor: "behind the inhomogeneous medium for measuring the"]
- **Indirect methods and their cost (p. 3389).** Most AO microscopes so far use indirect measurement based on processing of the final image. The authors say the long exposure causes photobleaching and limits the bandwidth for live imaging. [anchor: "microscopes developed so far are based on indirect meth-"] [anchor: "cause photobleaching and limit the bandwidth for live"]
- **Alternatives to a fluorescent guide star (p. 3389).** Backscattered light has been used for direct sensing, but it depends heavily on tissue backscattering efficiency. Injected fluorescent microspheres work as guide stars but complicate sample preparation and are invasive, so side effects on tissue function must be considered for live imaging. [anchor: "on the backscattering efficiency of the tissue. A direct"] [anchor: "sample preparation procedure. As an invasive method,"]
- **Proposed guide star (p. 3389).** Fluorescent proteins that label cellular structures (here YFP in neurons of a transgenic mouse) are used as the guide stars, avoiding injection of other labels. [anchor: "To overcome these disadvantages, fluorescent pro-"]
- **Sensing hardware (p. 3389).** A confocal microscope (515 nm laser, 60x water objective, NA 1.2, galvanometer scanning) with a Boston Micromachines 140-actuator deformable mirror and a Shack-Hartmann sensor (44 x 44 lenslet array, 400 um pitch, 24 mm focal length, EMCCD camera). A beam splitter currently sends half of the emission to the sensor and half to the detector; the authors say a switchable mirror will replace it in a future system. The sensing is a direct measurement of the wavefront, not a process on the final image. [anchor: "deformable mirror (DM, 140 actuators, Boston Micro-"] [anchor: "other half of the light is used for wavefront sensing."]
- **Guide-star requirements (p. 3390).** To measure accurately, the guide star must be smaller than the diffraction limit of one sensor lenslet; its size is limited by the illumination point spread function (reported as 1.4 um for 80% encircled energy at 70 um depth). Irises in the path remove out-of-focus light. Background YFP away from the focus can still affect accuracy. [anchor: "light from a given point is proportional to the light inten-"] [anchor: "distribution in the background may affect the accuracy of"]
- **Procedure (p. 3390).** The focus is parked on the YFP region and the focal plane is chosen by maximizing the intensity of the Hartmann spots. The mirror then corrects in closed loop with a direct-slope algorithm, and the corrected confocal image of the isoplanatic region around the guide star is captured. Laser power is lowered to avoid bleaching during sensing (23 nW at the objective back aperture for sensing, 20 uW for imaging). [anchor: "aberration in a closed loop using the direct slope algo-"] [anchor: "planatic region [6] around the YFP guide star is captured"]
- **Speed (p. 3391).** The wavefront error converged after about 10 iterations, about 0.30 s. Sensing exposure was 30 ms (cell body) to 500 ms (dendrite). The authors call the method noninvasive and high speed. [anchor: "wavefront error converges after approximately 10 itera-"] [anchor: "To conclude, as a noninvasive and high speed method,"]
- **Demonstrated benefit (p. 3391, Fig. 4).** For a fixed mouse brain slice with a neuron cell body at 70 um depth as guide star, RMS wavefront error fell from 0.35 to 0.034 wavelengths, the peak intensity of a dendrite/spine profile rose 3x, contrast improved, and the Strehl ratio rose from 0.29 to 0.96. [anchor: "ratio is improved from 0.29 to 0.96, a significant"] [anchor: "as shown in Fig. 2(b). The RMS wavefront errors"]
- **Validation (p. 3391).** Wavefronts measured from the fluorescent protein and from a microsphere 3 um away agreed to about 0.027 wavelengths RMS (average over 20 measurements). [anchor: "The average RMS difference between these two"]
- **Spatial extent of the correction (p. 3390-3391).** The correction is computed for the guide star and the image captured is of the isoplanatic region around it. The paper does not state the size of that region or test how the correction degrades away from the guide star. [anchor: "planatic region [6] around the YFP guide star is captured"]

## Relevance to the thesis

- Supports: G26 (direct wavefront sensing with a Shack-Hartmann sensor plus a deformable mirror; and a clear statement that direct sensing needs a guide star that is hard to find in tissue, with indirect methods being the usual alternative). G24 (sample-induced aberrations degrade the image). G27 (the correction is tied to the isoplanatic region around one guide star, i.e. a local correction).
- Does not support: any statement about the cost of deformable mirrors (not mentioned); the claim that corrections are spatially invariant (not stated or tested here); anything about high-NA light-field or widefield imaging (confocal only, NA 1.2 objective); G25, G30.

## Differences to state if cited

- Confocal point-scanning microscope, fixed (not live) mouse brain tissue in the demonstration; "live in vivo imaging" is only called suitable in the final sentence.
- The sensor is a physical Shack-Hartmann on fluorescence from the same structure being imaged, and a fluorescent protein expressed in the tissue is the guide star.
- Wavefront error values are in wavelengths (lambda = 527 nm quoted for the iris estimate).

## Still unread

- Cited method papers for the PSF calculation, photon-noise error and isoplanatic region (refs 6, 10, 13, 14).
- Detailed figure content (Figs. 2 and 4 beyond their captions).

## Safe Wording

Tao et al. note that wavefront sensors need a point-like guide star, that one is hard to find in biological tissue, and that most adaptive optics microscopes therefore use indirect, image-based measurement (Opt. Lett. 36, 3389, 2011, p. 3389); they used a fluorescent-protein-labelled neuron as the guide star for a Shack-Hartmann sensor and deformable mirror in a confocal microscope (p. 3390).
