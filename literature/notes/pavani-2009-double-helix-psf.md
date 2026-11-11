# Pavani 2009 - Double-helix PSF 3D single-molecule imaging

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Sri Rama Prasanna Pavani, Michael A. Thompson, Julie S. Biteen, Samuel J. Lord, Na Liu, Robert J. Twieg, Rafael Piestun, W. E. Moerner, "Three-dimensional, single-molecule fluorescence imaging beyond the diffraction limit by using a double-helix point spread function", Proceedings of the National Academy of Sciences 106(9), 2995-2999, 3 March 2009 (contributed by Moerner, January 9, 2009). The DOI is printed with its slashes lost in the text layer ("0900245106", i.e. 10.1073/pnas.0900245106). Assignment metadata matches; no discrepancy.

## What was read

File C4e_32.txt, 5 PDF pages (journal pp. 2995-2999): complete main text, figure captions, Methods, reference list. The two-column layout is interleaved with page watermark text but readable. The SI Appendix (phase-mask design, fluorophore synthesis, estimator details, camera calibration) is not in the file and was not read.

## Why This Matters

Pavani et al. is the standard example of PSF engineering for depth: a phase mask in the Fourier plane of a 4f relay turns each point emitter into two lobes whose angle rotates with z. For the thesis it is a contrast case: depth from a designed PSF, calibrated beforehand, for sparse single emitters over a larger axial range than astigmatism.

## Key Claims (paraphrased)

- **Summary of the method (Abstract).** A wide-field microscope with a double-helix PSF has two dominant lobes in the image plane whose angular orientation rotates with the emitter's axial position. Single molecules in a thick polymer sample were localized in single 500 ms acquisitions with 10-20 nm precision over about 2 um depth. [anchor: "orientation rotates with the axial (z) position of the emitter"]
- **Depth range and comparison (p. 2995).** The paper says the astigmatic approach had a depth of field of only 600 nm and multiplane about 1 um (2.5 um with bright quantum dots); the DH-PSF more than doubles the depth of field. [anchor: "the depth of field was only 600 nm, whereas in the extensively"]
- **Encoding mechanism (p. 2996, Fundamentals).** x, y come from the midpoint of the line joining the two lobes; z from the angle of that line, using a calibration plot that maps angle to axial position. The lobes are horizontal in focus and rotate counterclockwise as the emitter moves toward the objective, clockwise away from it. [anchor: "the axial position is estimated from the angle of"]
- **Hardware (p. 2996, Fundamentals; p. 2998-2999, Methods).** A conventional inverted microscope (1.4 NA, 100x oil objective) with a 4f relay (two 15 cm achromats) whose Fourier plane carries a reflective liquid-crystal phase-only SLM; a polarizer follows, and an EMCCD records. The phase pattern is a DH-PSF mask designed for the emission wavelength (578 nm used). [anchor: "The signal-processing section is essentially a 4f imaging"]
- **Calibration required (p. 2996; p. 2998, Methods).** The angle-to-z curve is measured with fluorescent beads (505/515 and 565/580 nm, immobilized in a thin PVA layer) while the objective is moved with a piezo, at two emission wavelengths. [anchor: "Axial position calibration data were obtained at 2 different"]
- **Precision (p. 2997, Fig. 2).** For one photoactivated molecule localized 44 times with an average of about 9,300 photons per estimate and 48 photons per pixel background fluctuation, standard deviations were 12.8, 12.1 and 19.5 nm in x, y and z. The authors say these are expected single-measurement precisions and that precision is within the same range as astigmatic and multiplane methods. [anchor: "of 12.8, 12.1, and 19.5 nm in x, y,"]
- **Estimators are not optimal (p. 2997).** The simple estimators (Gaussian lobe fit, or the faster centroid used for Figs. 3-4) do not reach the Cramer-Rao bound, so information in the images is not fully used. [anchor: "are not statistically efficient because they do not reach the"]
- **Costs and limits (p. 2996-2998).** The SLM reflection loses about 75% of the light; the DH-PSF image has slightly raised background because photons are spread across lobes over a long axial range; a custom phase mask, better estimators, background minimization and closed-loop drift correction are listed as future improvements. [anchor: "the 75% loss associated with the SLM reflection arising from"]
- **Sparse emitters only (p. 2997).** Many molecules can be located in one image only as long as the PSFs of different emitters do not overlap appreciably. Super-resolution of high concentrations is obtained by repeated photoactivation of sparse subsets (30 cycles of 30 frames of 500 ms in Fig. 4), each molecule bleaching before the next subset. [anchor: "do not appreciably overlap"]
- **Labeling density for structures (p. 2998).** For labeled structures, super-resolution information can be extracted if labeling density is high enough to satisfy the Nyquist criterion; the paper itself demonstrates only single molecules in polymer film. [anchor: "labeling density is sufficiently high to"]
- **Imaging rate (p. 2998-2999, Methods).** Single-molecule data were acquired at 2 Hz with 500 ms exposures. [anchor: "acquisition rate for all single-molecule imaging was 2 Hz"]

## Relevance to the thesis

- Supports: G30, in the engineered-PSF sense: depth from a designed PSF read from the lobe angle through a prior calibration curve; also a source for the depth-range comparison with astigmatism and multiplane methods.
- Does not support: G24-G27 (no aberration correction or AO statements, SLM is used as a PSF-shaping element, not as a corrector). Not for dense or extended scenes (only sparse non-overlapping emitters). No light-field or multi-view statement. Nothing on spatially varying aberration.

## Differences to state if cited

- Needs a phase-mask SLM with 75% light loss in the setup used; the thesis method adds no active element and is single-shot on an extended scene.
- Calibrated beforehand for a specific emission wavelength and objective; the mask is designed for one wavelength.
- Sparse emitters with non-overlapping PSFs; precision stated for photon counts of thousands per molecule.
- Axial range about 2 um, compared with 600 nm for astigmatism as stated by the authors.

## Still unread

- SI Appendix (mask design, fluorophore synthesis, detailed estimators, gain calibration).
- Cited works.

## Safe Wording

Pavani et al. replaced the PSF with a double-helix design, so that each emitter appears as two lobes whose connecting line rotates with depth, and recovered x, y and z of sparse single molecules from one image using an angle-to-depth calibration curve, with precision of about 12 nm laterally and 20 nm axially over about 2 um (PNAS 106, p. 2995-2997).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use only if giving a second engineered PSF beyond astigmatism. Precision is specific to the demonstrated optical and photon conditions.
