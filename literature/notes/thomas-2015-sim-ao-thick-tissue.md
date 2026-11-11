# Thomas 2015 - Structured illumination with adaptive optics through thick tissue

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

B. Thomas, A. Wolstenholme, S. N. Chaudhari, E. T. Kipreos, P. Kner, "Enhanced resolution through thick tissue with structured illumination and adaptive optics", Journal of Biomedical Optics 20(2), 026006 (February 2015), pp. 026006-1 to 026006-8, DOI 10.1117/1.JBO.20.2.026006. No discrepancy with the assignment metadata (the paper has no conventional page range; it is article number 026006).

## What was read

File C4d_24.txt, all 9 PDF pages: title page, Secs. 1-5, acknowledgments and the start of the reference list (printed footer 026006-1 to 026006-8; the reference list continues beyond line 500 of the text file and was not read past Ref. 11, the remaining entries are citations only). Figures were read through captions only; no image content inspected. Equations were read for their statements. The text file is Windows-1252 encoded: Greek mu is dropped, so quantities such as "35 m" mean micrometres.

## Why This Matters

Shows resolution-doubling 2D SIM combined with sensorless AO and a deformable mirror, and gives the paper's own account of field-dependent (anisoplanatic) aberrations: one DM correction gives a bounded corrected field, and fusing corrections or multiconjugate AO is suggested but not shown. Useful for G29, G27 (spatial invariance), and G26/G30 (sensorless AO, phase retrieval from through-focus stacks).

## Key Claims (paraphrased)

- **Aberrations degrade SIM (abstract, p. 026006-1).** In thick samples aberrations degrade SIM performance and limit resolution. [anchor: "aberrations degrade the performance and limit the resolution"]
- **Cause of aberrations (Sec. 1, p. 026006-1).** Refractive index differences within the sample and between sample, immersion medium and cover glass cause aberrations that cost resolution and signal-to-noise ratio (SNR). [anchor: "differences in the sample and the refractive index differences"]
- **How aberrations hurt SIM (Sec. 1, p. 026006-1; Sec. 3, p. 026006-3).** Aberrations widen the PSF and lower its peak, weakening the high-frequency information that SIM relies on; the OTF is reduced at high frequencies, leaving gaps in frequency support that produce artifacts even at high SNR (simulation: 1.0 rad rms astigmatism, NA 1.2, 510 nm). [anchor: "Optical aberrations will reduce the strength of the OTF at"]
- **SIM images needed (Sec. 3, p. 026006-3).** 2D SIM uses nine raw images (three pattern orientations by three phases); reconstruction is a Wiener-type filter in the Fourier domain with parameter w. [anchor: "in 2-D SIM, nine raw images"]
- **Noise amplification in SIM reconstruction (Sec. 3, p. 026006-3).** Noise is boosted where the OTF is low, in the SIM reconstruction denominator; raising w limits noise at the cost of resolution. This is a statement about SIM reconstruction, not about deconvolution in general. [anchor: "is boosted by the low value of the OTF in"]
- **Knowing the aberrated OTF is not enough (Sec. 3, p. 026006-3).** Using the aberrated OTF in the reconstruction partly compensates but needs knowledge of that OTF and still gives a degraded image (simulation). [anchor: "requires knowledge of the aberrated OTF and still results in a"]
- **Sensorless AO, no wavefront sensor (Sec. 4.3, p. 026006-5).** The system has no wavefront sensor; the DM (Mirao 52-e, 52 actuators) is set by optimising an image metric over Zernike mode coefficients. Metric here: peak intensity of a 200 nm bead. Modes 5, 6, 7, 8 and 11 (astigmatism, coma, spherical) corrected one after another by a parabolic fit to five data points per mode. [anchor: "Our system does not contain a wavefront sensor"]
- **Phase retrieval from a through-focus stack (Sec. 4.3, p. 026006-5).** Phase retrieval from 3D stacks of a single 200 nm bead (axial range about 2 um either side of focus) was used to measure DM actuator influence functions and to flatten system aberrations (repeated two or three times); after that the Strehl ratio exceeded 0.80 across the camera field on the coverslip. The through-focus stack is used for system calibration, not for the sample correction. [anchor: "We use phase retrieval to measure the DM actuator influence"]
- **Sample (Sec. 4.2, p. 026006-5; Sec. 4.5, p. 026006-7).** 100 nm and 200 nm fluorescent beads dried on a slide beneath fixed wild-type C. elegans (about 35 um wide); the worm itself is not fluorescently labelled. Correction is done with one 200 nm bead under the centre of the worm. [anchor: "Future work will involve applying 3-D AO-"]
- **Results (Sec. 4.4-4.5, p. 026006-6-7; Sec. 5).** Stripe period 290 nm in image space (65% of the NA), deliberately modest, giving 140 nm resolution (full width at half maximum of a 100 nm bead). Total rms wavefront removed 2.23 rad, mostly astigmatism. SNR of the SIM reconstruction 13.3 without AO, 21.5 with AO. Peak intensity doubled by AO and quadrupled with SIM relative to corrected widefield. Without AO the SIM reconstruction is highly distorted. [anchor: "With AO correction, the SNR increases to"] [anchor: "achieve a resolution of 140 nm"]
- **SIM may fail without AO (Sec. 5, p. 026006-7).** [anchor: "magnitude of the aberrations, SIM may not be possible without"]
- **Deconvolution comparison (Sec. 4.5, p. 026006-6).** Deconvolved widefield after AO resolves less than SIM after AO, though AO plus deconvolution is a large improvement over uncorrected widefield. [anchor: "combination of AO correction and deconvolution is a significant"]
- **Spatial variation, theory (Sec. 2, p. 026006-2; Figs. 1-2).** The isoplanatic patch (region sharing one aberration) can be a few microns when aberrations come from small structures near the focal plane, large for slowly varying body-scale structure, and the whole field for a planar index mismatch. Ray-trace simulation of a 25 um cylinder with a 0.02 index difference: Strehl ratio 0.22 at the centre and 0.003 halfway to the edge; after correcting the centre wavefront, Strehl is 1.0 at the centre and 0.025 halfway to the edge. With Strehl above 0.2 as acceptable, the corrected lateral field grows from under 1 um to almost 10 um. [anchor: "imaging as a Strehl ratio greater than 0.2"]
- **Spatial variation, experiment (Sec. 4.5, p. 026006-7; Figs. 10-11).** A single correction from one bead gave an average bead-intensity increase of 60% across the worm width, with improvement along 35 um of the anterior-posterior axis, over a 35 um by 20 um field; near the worm edge (about 10 um off axis) the SIM image without AO fails to identify the 100 nm beads. The 60% figure includes slices where many beads are not imaged through the worm. [anchor: "correction based on one bead near the center of the image"] [anchor: "The average intensity increase is 60% across"]
- **Anisoplanatism produces artifacts (Sec. 3, p. 026006-4).** If a correction fixes only the isoplanatic part, the leftover anisoplanatic part adds noise-like artifacts peaked at the pattern frequencies, strongest where the residual PSF differs most. [anchor: "These terms will contribute artifacts which will typically"]
- **Stated remedies for limited field (Sec. 5, p. 026006-7).** Different corrections for different areas combined by image fusion, or multiconjugate AO; neither is demonstrated. Contrast with scanning microscopy where correction can in principle be point by point; widefield and SIM use one correction for the whole captured field. [anchor: "different corrections can be applied for different areas of the"]

## Relevance to the thesis

- Supports: G29 (resolution-doubling SIM needs nine raw images and a reconstruction; aberrations degrade it, produce artifacts and lower SNR; AO is used to cope). G27 (widefield AO normally applies one correction to the whole field; corrected field is limited by isoplanatic patch size; spatially varying fixes are only proposed). G26 (sensorless AO is the route used here instead of a wavefront sensor). G24 (index mismatch in the sample and its surroundings produces aberrations that degrade high-NA fluorescence imaging; simulation numbers). G30 (phase retrieval from through-focus bead stacks is used to calibrate DM and system aberrations).
- Does not support: any claim of cost or complexity of deformable mirrors (not stated). Any claim about software PSF estimation or deconvolution as costly or slow (only a single widefield-deconvolution comparison is shown). Any claim that AO was demonstrated in real labelled tissue (the sample is beads beneath an unlabelled worm). Any light-field or multi-view statement (none). Acquisition time for the SIM stack or the AO optimisation is not stated.

## Differences to state if cited

- Sample is beads under a fixed whole worm, a favourable test case with a single dominant aberration (astigmatism) and a bright guide-star bead under the sample, which is not available in typical samples.
- Correction used the bead peak intensity as metric, so the AO step is sequential with the SIM acquisition (not single-shot).
- Spatial variation results (Fig. 10) are averages over bead positions across the worm; the 140 nm resolution figure is for beads in the corrected region.
- The spatial-variation remedies (fusion, multiconjugate AO) are suggestions only.

## Still unread

- Image content of Figs. 5-11 (captions only). Reference list past Ref. 11 (citation entries only, no claims). No supplement referenced.

## Safe Wording

Thomas et al. combined sensorless adaptive optics with structured illumination microscopy and, using a single deformable-mirror correction, restored 140 nm resolution through a 35 um fixed C. elegans body, while noting that widefield AO applies one correction to the whole field and that corrected field size is limited by the isoplanatic patch (J. Biomed. Opt. 20(2), 026006, 2015; Secs. 2 and 5, pp. 026006-2, 026006-7).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Use if Chapter 2 compares super-resolution SIM under a biological aberrator. The biological specimen is the aberrating medium in this demonstration; do not generalize to arbitrary thick tissue.
