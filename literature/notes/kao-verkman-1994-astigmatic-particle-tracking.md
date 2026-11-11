# Kao 1994 - Cylindrical-lens 3D tracking of single fluorescent particles

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

H. Pin Kao and A. S. Verkman, "Tracking of Single Fluorescent Particles in Three Dimensions: Use of Cylindrical Optics to Encode Particle Position", Biophysical Journal, volume 67, pp. 1291-1300, September 1994 (issue number not printed on the pages read). No DOI printed. The assignment metadata (Biophys. J. 67, 1291-1300, 1994) matches; no discrepancy.

## What was read

File C4e_28.txt, all 10 PDF pages (journal pp. 1291-1300), including methods, results, discussion and reference list. The text is OCR-quality with many garbled characters, especially Eqs. 5-6 and the figure panels. Page 1292 (lens specification) and page 1298 (resolution comparison) were checked against the PDF image. Figures were not interpreted beyond their captions. No supplement exists for this paper.

## Why This Matters

Kao and Verkman is the original reference for encoding axial position in the image of a point-like emitter with a deliberate astigmatism from a weak cylindrical lens, later reused by single-molecule localization microscopy (the 3D STORM paper cites it for this). For the thesis it is a primary example of an engineered, deliberately introduced aberration used to recover depth, in contrast to aberrations treated as a nuisance. It works on isolated bright particles and needs a prior calibration curve.

## Key Claims (paraphrased)

- **Principle (p. 1291, Abstract; p. 1293, Image analysis).** A weak cylindrical lens in the detection path makes the image of a small fluorescent particle circular at focus and elliptical above and below focus, with the long axis turning by 90 degrees when passing through focus. The x, y position is the image centroid; z comes from the ellipse shape and orientation. [anchor: "weak cylindrical lens in the detection optic"]
- **Hardware (p. 1292, Optical instrumentation).** Standard epifluorescence microscope (60x, 1.40 NA oil objective), a long focal length cylindrical lens (focal length printed as 560 cm) placed 15 mm beyond the objective exit aperture, axis aligned with the CCD rows, plus a microstepper motor on the fine focus. [anchor: "15 mm beyond the exit aperture of the objective len"]
- **Why astigmatism rather than native aberrations (p. 1298, Discussion).** Objectives contain focus-dependent spherical aberration that could in principle give z, but it depends on the objective and needs complex recognition; the cylindrical-lens asymmetry is objective-independent and aligned with the detector rows and columns, so it is simple and fast to quantify. [anchor: "aberration is independent of the objective and, because of the"]
- **Algorithm (p. 1293, Image analysis).** Row and column intensity sums (projections) are analysed. Two measures of the spread in each projection (a width from the derivative and a peak-detection area) give z, combined into a symmetry function that is zero at the focal plane. The method works on projections because they carry enough information and cost far less computation in real time. [anchor: "sufficent infomation to determine a particle's positin and required re-"]
- **Calibration required (p. 1294-1295, Position measurement utilizing calibration data).** Calibration curves are measured before each experiment with a single immobilized reference bead of the same diameter as the particles, stepping z through 50 positions (about 5.75 um below to 5.75 um above focus, 0.23 um steps), five images per plane, three to five sets. z is then read off these curves. [anchor: "single immobilized reference bead with the same diameter as that used for"]
- **Useful z range (p. 1295, Continuous 3D particle tracking).** The symmetry-function readout is used only between about -2 and +1.8 um from focus; outside that range the stage motor refocuses the particle to within 1 um of focus, and tracking resumes after a pause. The OCR of the passage is partly garbled. [anchor: "outside of the z = -2 to 1.8 p.m region"]
- **Accuracy (p. 1295, Results; p. 1298-1299, Discussion).** Typical measurement standard deviation (precision) 5 nm in x, 2-3 nm in y, 12 nm in z, for an immobilized 264 nm bead within about 2 um of focus. Error in z is largest near the ends of the range (low intensity, low slope of the calibration function). The paper states that scatter in the calibration curves reflects stage hysteresis and gear lash, not the method's precision, which limited accuracy. [anchor: "Typical measurement SD (precision) was 5 nm along"]
- **Refractive-index sensitivity (p. 1295, Results; p. 1298-1299, Discussion).** The calibration curve changes with bead depth in water for an oil-immersion lens (index mismatch) but changes little in 83% glycerol, whose index is close to the oil's. The paper concludes the immersion medium index should equal the sample's, and recommends a water objective for biological samples, or correction factors in the calibration curves otherwise. [anchor: "refractive index of the immersion oil matches that of the"]
- **Cost of the aberration (p. 1298, Discussion).** The paper names degradation of transverse (x, y) resolution as the disadvantage of introducing astigmatism. The numbers printed (FWHM about 0.3 um with the lens, about 0.5 um without, checked on the PDF) seem to point the other way; the paper does not explain this, so do not quote them. [anchor: "radation of the transverse (x, y) microscope resolution"]
- **Speed (p. 1299, Discussion).** Exposure plus transfer about 150 ms and computation about 150 ms on a 25 MHz 486 PC give a maximum of 3-4 Hz. [anchor: "giving a 3-4 Hz maximum sampling rate"]
- **Sparse particles only (p. 1298, Discussion).** The statement that image degradation mainly reduces brightness holds only if particle images remain well separated. The method can follow several particles at once from their images. [anchor: "If the particle images remain well separated, the main effect"]
- **Bead and cell applications (p. 1295-1298, Results).** Diffusion of 264 nm beads in glycerol solutions matched Stokes-Einstein; beads were also tracked in cytoplasm and at the cell surface (cell volume changes). No fluorescent scene is imaged; only individual particles. [anchor: "T'his study demonstated three-dimensional tracking of"]

## Relevance to the thesis

- Supports: G30 only in the engineered-PSF sense: depth is recovered from the shape of the image of an isolated emitter produced by a deliberately inserted astigmatic element, using a calibration curve measured beforehand. It can be cited as an early example that aberration can encode depth.
- Does not support: G24-G27 (no aberration correction, no AO, no deconvolution). Not for dense or extended scenes: it localizes single bright particles whose images stay separated. It says nothing about light-field or multi-view imaging, or about spatially varying aberration. Do not cite it for through-focus image stacks as a measurement method, since z is read from a single image via calibration (a stack is used only to make the calibration).

## Differences to state if cited

- Single-image depth from a deliberately added aberration; the thesis method treats aberrations as nuisance shifts between views, and recovers a 2D scene.
- Point-like emitters of known size (264 nm beads, 93 nm in cells) with a measured calibration for that particle type; the thesis scene is extended and 2D.
- Axial range of only about 4 um with the shape readout valid over about -2 to +1.8 um; the rest is handled by mechanical refocusing.
- Calibration is sensitive to refractive-index mismatch and to stage hysteresis.

## Still unread

- Figure content (panels of Figs. 1-6) beyond captions and the quoted values; Eq. 5 and Eq. 6 are garbled in the OCR text and were not independently reconstructed.
- Cited works (Gibson and Lanni 1991, Qian 1991 and others) were not read.

## Safe Wording

Kao and Verkman introduced a weak cylindrical lens into the detection path of an epifluorescence microscope, so that the image of a small fluorescent particle becomes elliptical away from focus, and the ellipse shape and orientation, read against a calibration curve measured on a reference bead, give the particle's axial position (Biophys. J. 67, p. 1291 and p. 1293). They reported about 12 nm precision in z and 5 nm in x for isolated particles (p. 1295).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Use in Chapter 2 or 3 as a concise example of engineered depth encoding for isolated emitters. The reported precision is setup-specific and does not establish dense 3D reconstruction.
