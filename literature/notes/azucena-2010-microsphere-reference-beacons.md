# Azucena 2010 - Wavefront measurement and correction through tissue with microsphere guide stars

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Oscar Azucena, Justin Crest, Jian Cao, William Sullivan, Peter Kner, Donald Gavel, Daren Dillon, Scot Olivier, Joel Kubby. "Wavefront aberration measurements and corrections through thick tissue using fluorescent microsphere reference beacons." Optics Express 18(16), 17521-17532, 2010 (received 10 Jun 2010, published 30 Jul 2010; issue dated 2 August 2010). No DOI is printed on the paper (OSA manuscript number #129768 is). No discrepancy with the metadata in the assignment.

## What was read

C4a_01.txt, all 12 PDF pages (printed pages 17521-17532): abstract, reference list, Introduction, Methods, Results, Discussion and conclusions. Single-column text, extracted cleanly. Figures were interpreted from captions and the text only. Not read: refs 11, 20, 25 (related coherence-gating, multi-bead and Drosophila-aberration papers).

## Why This Matters

An early, explicit statement of why direct wavefront sensing was rarely used in microscopy (sensor complexity, no natural point-source reference) and a demonstration with a Shack-Hartmann sensor and a MEMS deformable mirror using injected fluorescent beads as guide stars. It also measures how large an area a single-guide-star correction covers (the isoplanatic patch), which is the best direct evidence in this group for G27's "one correction, small field" point.

## Key Claims (paraphrased)

- **Aberration source (p. 17522, Introduction; p. 17526, Results).** Changes in refractive index due to tissue composition limit the resolving power of biological microscopy and are worse in deep tissue. For the Drosophila embryo, the measured wavefront was dominated by astigmatism and other low-order terms, attributed to index mismatches in the optical path and the curved body of the embryo. Cover slip and air-glass terms were removed by a reference measurement. [anchor: "Changes in the index of refraction due to tissue composition"] [anchor: "index mismatches in the optical path as well as the curved body"]
- **Why direct sensing was rare (p. 17522).** Most adaptive optics microscopes had not measured the wavefront directly because of the complexity of adding a sensor and the lack of natural point-source references like the astronomy guide stars; instead they optimized a detector signal with hill-climbing. [anchor: "Most adaptive optics microscope systems so far have not directly measured"] [anchor: "lack of natural point-source references such as the"] [anchor: "optimizing a signal received at a photo-detector by using a hill-climbing algorithm"]
- **Coherence gating is limited (p. 17522).** The earlier coherence-gated method works well but needs a sample with a relatively high scattering coefficient. The paper also cites Booth for the difficulties of using a Shack-Hartmann sensor in AO microscopy, saying most could be overcome with a suitable fluorescent point-source beacon. [anchor: "This method worked well but it requires a sample with a"] [anchor: "of these difficulties can be overcome if a suitable fluorescent point source"]
- **What is sensed and how (p. 17521, p. 17523-17525).** A Shack-Hartmann sensor (44 x 44 lenslets, 328 um diameter, 24 mm focal length, cooled CCD) measures the wavefront of light from a fluorescent microsphere used as an artificial guide star. The reference source is a 1 um crimson microsphere injected into a Drosophila embryo; excitation is a 633 nm HeNe through a fibre with stationary confocal illumination of one bead at a time. Spot displacements are found by cross-correlation centroiding relative to a reference image and reconstructed by FFT, then expanded in Zernike modes. [anchor: "Shack-Hartmann wavefront sensor is used to directly measure the wavefront"] [anchor: "taken by seeding the embryo with fluorescent microspheres used as"] [anchor: "allows for one microsphere to be illuminated at a time"]
- **Guide-star size and brightness (p. 17531).** The bead should be smaller than the diffraction limit of one sensor sub-aperture; smaller beads give less light (emission scales with radius cubed). The authors say a 1 um bead gives enough light for a 10 ms loop with a 40x, NA 0.75 objective, and a bead 10 times smaller would still work with lower signal-to-noise, compensated by a 100 ms loop or fewer pixels per sub-aperture. [anchor: "The size of the beads should be smaller than the diffraction"]
- **Background and scattered light (p. 17531-17532).** Nearby beads in other focal planes appear as background on the sensor. The authors state that cross-correlation centroiding does not sense the background and that scattered light inside the embryo adds to the background but does not change the measurement. Two beads within about 5 PSF widths in the same plane give an averaged wavefront. [anchor: "adds to the background but it does not change the wavefront sensor"]
- **Astronomy comparison, cost (p. 17524).** In astronomy, a laser creates the artificial guide star in the sodium layer; the authors say powerful and expensive lasers are needed, but the result is correction over a much larger part of the sky than a natural guide star allows. This is about astronomical lasers, not about deformable mirrors in microscopy. [anchor: "Powerful and expensive lasers are needed to do so"]
- **Corrector hardware (p. 17523, p. 17532).** A micro-electro-mechanical (MEMS) deformable mirror (Boston Micromachines), placed in the image path and conjugate to the objective pupil, driven by the inverse of the measured wavefront. No statement is made about the mirror's cost or complexity. [anchor: "Micro-Electro-Mechanical Systems (MEMS) deformable mirror"]
- **Aberration size and Strehl estimates (p. 17528).** Measurements on beads 40 to 100 um deep gave mean peak-to-valley 0.765 um and RMS 0.104 um (largest 1.37 um and 0.19 um, at 40x), and a mean Strehl ratio of about 0.30. Removing the first 14 Zernike modes numerically raises the mean Strehl in the table to about 0.60. The "improvement by 2 times on average" in the abstract therefore comes from this simulated mode removal, whereas the closed-loop test (next item) shows 10x for one bead. [anchor: "Column Five demonstrates the effect of removing the first 14 Zernike's modes"] [anchor: "by 2 times on average and as high as 10 times"]
- **Closed-loop correction (p. 17529).** One bead 100 um below the embryo surface (40x, NA 0.75): the loop ran in 10 ms steps with gain 0.4 (limit before oscillation), converged in about four steps, residual RMS under about 7 nm, and the peak intensity improved about 10 times. The final DM shape differed from the measured wavefront by 30 nm RMS. The authors explain that DM nonlinearity makes small, gradual steps necessary. [anchor: "each correction step was 10 milliseconds apart"] [anchor: "The improvement in Strehl was approximately 10X"]
- **Spatial extent of one correction (p. 17530-17532).** The isoplanatic region was estimated from pairs of beads 14, 18 and 25 um apart (40x, NA 0.75): mean isoplanatic half-width 19 um (std 5.6 um), described in the abstract and conclusion as a corrected field of view 38 um in diameter. A guide star plus AO is said to improve images at and around the bead. The Results text says "within a circle 10 microns in radius", which does not match the 19 um half-width stated in the abstract and conclusion; this inconsistency is in the paper. [anchor: "The results also show that the isoplanatic half-width is"] [anchor: "within a circle 10 microns in radius"]
- **Future extensions, not demonstrated (p. 17532).** Tomographic AO with several beads and several sensors is suggested to extend the isoplanatic angle by correcting wavefront aberrations common to a larger field of view. [anchor: "This technique can also extend the isoplanatic angle by correcting"]

## Relevance to the thesis

- Supports: G24 (index variation of tissue limits resolution; Drosophila embryo aberrations mainly low-order, with PV up to 1.37 um at 40x NA 0.75). G26 (Shack-Hartmann plus deformable mirror, explicit statement that direct wavefront sensing in microscopy was rare because of sensor complexity and the missing natural guide star, and that sensorless hill-climbing was the usual practice). G27 (the correction from one guide star is valid over an isoplanatic region on the order of tens of micrometres, so one correction does not cover a wide field; tomographic AO named as a future way to extend it).
- Does not support: any claim that deformable mirrors are expensive (the only "expensive" is astronomy lasers); high-NA claims beyond NA 0.75; G25, G30; the abstract's "improves the Strehl ratio by 2 times on average" as a measured closed-loop result (it is mostly from removing 14 modes numerically).

## Differences to state if cited

- Wide-field style imaging of a bead onto a science camera with a Shack-Hartmann sensor on the same fluorescence; objectives 20x NA 0.40 and 40x NA 0.75, not high-NA.
- The guide star is an injected 1 um bead; the embryos in the methods are fixed in formaldehyde, but the paper also says injection works very well in live embryos and does not say which were used for each measurement.
- Isoplanatic half-width of 19 um (or 10 um in the Results sentence) is from three bead pairs with a 40x objective in one specimen type.
- Scattered light is said not to disturb centroiding for this sample; this is not shown for strongly scattering tissue.

## Still unread

- Refs 11 (Feierabend coherence gating), 20 (multi-bead measurement), 25 (Drosophila aberrations).
- Figures beyond captions (Figs 4-9).

## Safe Wording

Azucena et al. measured wavefront aberrations of a Drosophila embryo directly, with a Shack-Hartmann sensor on injected fluorescent microspheres, and corrected them with a MEMS deformable mirror (Opt. Express 18, 17521, 2010, p. 17521); they state that most adaptive optics microscopes had not measured the wavefront because of the complexity of adding a sensor and the lack of natural guide stars (p. 17522), and that a single guide star corrects an isoplanatic field of about 38 um in diameter (p. 17521, p. 17532).
