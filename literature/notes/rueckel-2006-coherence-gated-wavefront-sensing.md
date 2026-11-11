# Rueckel 2006 - Coherence-gated wavefront sensing for two-photon microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Markus Rueckel, Julia A. Mack-Bucher, Winfried Denk. "Adaptive wavefront correction in two-photon microscopy using coherence-gated wavefront sensing." Proceedings of the National Academy of Sciences 103(46), 17137-17142, 2006 (published 14 November 2006). DOI 10.1073/pnas.0604791103 (printed in the page footer). No discrepancy with the metadata in the assignment.

## What was read

C4a_12.txt, all 6 PDF pages (printed pages 17137-17142): abstract, Results, Discussion, Methods, references. The text is two-column and the extraction interleaves the columns line by line; the main numbers were checked against the PDF image of printed pages 17139 and 17140. Not read: unpublished data cited in the text ("M.R. and W.D., unpublished data"), refs 11, 13, 14 (methods papers for the sensor).

## Why This Matters

Early demonstration that direct (sensor-based) wavefront measurement can be done inside specimens, in a two-photon microscope, without a fluorescent guide star: backscattered light selected by a coherence gate serves as the reference, and the sensor is a virtual (numerical) Shack-Hartmann. It supports the thesis statement that hardware correction means a wavefront sensor plus a deformable mirror, and it states plainly what is hard about it (fluorescence-based schemes bleach and need dense staining; the gated scheme needs scattering, interferometry and speckle averaging). The correction is for one point yet helps a wider field in the example shown.

## Key Claims (paraphrased)

- **Aberration source (p. 17137, Introduction).** Resolution, signal and contrast in confocal and multiphoton microscopy are degraded by refractive-index inhomogeneities of the biological specimen. In the Discussion the authors add that aberrations hurt the focus most in high-resolution microscopy (they name STED and structured illumination as further applications). [anchor: "refractive-index inhomogeneities in biological specimens"] [anchor: "aberrations have a particularly detrimental effect on"]
- **Why a different sensing scheme (p. 17137, Introduction).** The authors state that all earlier wavefront measurement schemes they cite (refs 7-10) rely on fluorescence and need strongly and widely stained specimens. Finding the correction usually needs many iterations, which consume the fluorophores through photobleaching and expose the tissue to photodynamic damage. [anchor: "are based on fluorescence and need strongly and widely stained"] [anchor: "numerous iterations, during which the useful life of fluorophores"]
- **What is sensed and how (p. 17137).** Coherence-gated wavefront sensing (CGWS) uses backscattered light, not fluorescence. A coherence gate rejects most of the returning light and keeps the light scattered near the focus, so the correction parameters can be found at low laser power and in non-fluorescent specimens. [anchor: "the sample is rejected by a coherence gate leaving only that light"]
- **Sensor type (p. 17137).** A Shack-Hartmann sensor is described as measuring the displacement of the foci from a lenslet array. The sensor actually used is a "virtual" Shack-Hartmann sensor: the interferometrically detected field is propagated numerically through a virtual lenslet array. It was used in all experiments. The camera records phase-shifting interferograms; wavefront is fitted with Zernike modes (28 modes, up to sixth radial order; p. 17141, Methods). [anchor: "measuring the displacements in those foci from their positions"] [anchor: "was used in all of our experiments, is particularly suitable in"]
- **Gate is the substitute for a guide star (p. 17141, Methods).** To sense all distortions on the way to the focus, the coherence gate must select backscattered light that originates from the focal region; when a defocus term is detected, the reference-arm length is adjusted until defocus is zero. [anchor: "needs to select backscattered light that originates from the focal"]
- **Single-pass argument (p. 17137-17138).** The gated light passes the specimen twice, but the authors argue (citing Monte Carlo and analytical work labelled "unpublished data") that only the return-pass aberration enters the measurement for scattering samples, because each scatterer acts as an independent spherical source. They report the measured wavefront changed by only about 17 nm while the incoming wavefront was varied. [anchor: "only the return-pass aberrations contribute to the"]
- **Costs of the sensing scheme (p. 17138).** Speckle from coherent backscatter must be averaged: 20 slightly different focus positions were used for the sample with scattering beads. The virtual Shack-Hartmann sensor uses photons inefficiently; its reconstruction error is about 21 times above the quantum limit, and a different sensing method would be needed to reach the quantum limit. Backscatter polarization also matters (a quarter-wave plate is used). The paper makes no statement about the monetary cost of the system. [anchor: "Due to the inherently"] [anchor: "is necessary to achieve sufficient wavefront"]
- **Corrector hardware (Fig. 1 caption, p. 17138; Methods p. 17140).** The corrector is an electrostatically deflected membrane deformable mirror (Oko Technologies, 37 electrodes) in a setup that also holds a Ti:Sapphire laser, a low-coherence interferometer with a reference arm, a CCD, and a calibration arm. Only Zernike modes 5-28 are corrected; tip, tilt and defocus only shift the focus. [anchor: "an electrostatically deflected mem-"] [anchor: "were corrected because these"]
- **Speed (p. 17138-17140).** Closed-loop convergence needed about three iterations in most cases. The authors say the current speed is limited mostly by the numerical wavefront propagation of the virtual sensor, and that the ultimate limit is the number of photons within the coherence gate. They expect on-chip processing could in principle give MHz update rates, but currently available deformable mirrors and spatial phase modulators are considerably slower, so correction speed would be limited by wavefront shaping, not measuring. [anchor: "tion is limited mostly by the time needed for the numerical"] [anchor: "phase modulators are still considerably slower so that, at the"] [anchor: "correction speeds would be limited by wavefront"]
- **Abstract claim about pixel-by-pixel correction (p. 17137).** The authors say it should be possible to perform real-time pixel-by-pixel correction; this is a projection, not a demonstration. In the Discussion they say pixel-by-pixel correction is not necessary, as the zebrafish example shows. [anchor: "should be possible to perform real-time pixel-by-pixel"] [anchor: "(Fig. 4) shows, it is not necessary to provide pixel-by-pixel"]
- **Demonstration with a known aberration (p. 17138).** With a glass capillary producing astigmatism, correction raised the peak fluorescence of beads about six-fold, and the lateral widths of a bead image returned to values comparable to a sample without the capillary. The measured astigmatism (about 276 nm) was close to the expected value (280 nm). [anchor: "we find a 6-fold increase in peak"]
- **Demonstration in a living animal (p. 17139).** In a zebrafish larva, the olfactory bulb at about 50 um depth was severely degraded before correction. The measured specimen aberration was mainly astigmatism and some coma (c6 about -306 nm, c8 about -79 nm); after five iterations the residual was 65 nm, limited by the deformable mirror's drive-voltage limits, not by the measurement. In the forebrain at 200 um, a blood-flow fluorescence signal improved almost two-fold. [anchor: "because several of the DM drive voltages"] [anchor: "almost 2-fold by wavefront correction"]
- **Spatial extent of one correction (p. 17139).** The correction was determined for the centre point of the image only, yet almost uniform improvement in resolution and signal was found over the whole 34 um x 34 um field of view. The authors take this to mean most of the refractive-index inhomogeneities lie well above the focal plane (they suggest skin and cartilage over the brain). This is one specimen and one field size; it does not show invariance in general. [anchor: "center point of the image only, almost uniform improvements in"] [anchor: "of the refractive index inhomogeneities are substantially above"]

## Relevance to the thesis

- Supports: G24 (specimen-induced refractive-index variation degrades confocal and two-photon imaging; aberrations matter most at high resolution). G26 (hardware route = wavefront sensor, here a virtual Shack-Hartmann, plus deformable mirror; also states the problem with fluorescence-based sensing: dense staining, many iterations, bleaching). G27 (one correction applied for a field of view; the correction was measured at one point; deformable mirrors are slow relative to measurement; the paper describes a multi-component interferometric setup). Also G26 caveat: the paper treats this scheme as independent of fluorescence and does not use the words "direct" or "indirect" sensing.
- Does not support: any statement that deformable mirrors are expensive (no price or cost statement); any statement that corrections are spatially invariant as a rule (it reports one favourable case, and the abstract only projects pixel-by-pixel correction); anything about software or deconvolution (G25), or defocus-based measurement (G30). Not a fluorescent guide-star method.

## Differences to state if cited

- Wavefront sensing here is coherence-gated and uses backscattered light plus a virtual (numerical) Shack-Hartmann sensor, not a physical lenslet array on fluorescence.
- Two-photon point-scanning microscope with a membrane deformable mirror, not a wide-field or light-field system; the corrected quantity is the excitation focus.
- The single-pass argument rests on unpublished simulations.
- The uniform improvement over 34 um x 34 um is from one living specimen (fixed larva "data not shown").

## Still unread

- Cited methods papers (refs 11, 13, 14) and the "unpublished data" on the single-pass argument.
- Fixed zebrafish larva results ("data not shown").

## Safe Wording

Rueckel et al. sensed the wavefront of coherence-gated backscattered light with a virtual Shack-Hartmann sensor and corrected it with a deformable mirror in a two-photon microscope, restoring a nearly diffraction-limited focus in a living zebrafish larva (PNAS 103, 17137-17142, 2006, Abstract and p. 17139); they note that the available deformable mirrors, not the sensing, limit correction speed (p. 17140).
