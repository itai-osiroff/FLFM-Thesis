# Booth 2007 - Adaptive optics in microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. J. Booth, "Adaptive optics in microscopy", Philosophical Transactions of the Royal Society A 365(1861), 2829-2843, 2007 (published online 13 September 2007). DOI 10.1098/rsta.2007.0013 (printed on the first page). The metadata given in the assignment matches the paper; no discrepancy. It is a review article (Triennial Issue "Chemistry and engineering"), not a primary experimental paper.

## What was read

File C4a\C4a_03.txt, the whole main text (printed pp. 2829-2838) plus the start of the reference list (pp. 2838-2839); the page printed 2831 (Figure 1, section 2b) was garbled in the text file and was read from the PDF page image. Figure 2 and Figure 3 images were not interpreted beyond their captions. The reference list was not read in full and none of the cited works were consulted.

## Why This Matters

A review of microscope adaptive optics by one of its main developers. It gives a citable overview of where aberrations come from (specimen index variations, index mismatch, imperfect optics), why direct (Shack-Hartmann type) wavefront sensing is awkward in microscopy, why most microscope AO systems use indirect (sensorless) optimisation, and what correction devices exist. It is a scanning-microscope (confocal, two-photon) review; it does not discuss light-field microscopy or computational correction.

## Key Claims (paraphrased)

- **Specimen as source of aberration (p. 2829, section 1).** Spatial variations of refractive index inside the specimen introduce aberrations that degrade image quality, especially deep in thick biological specimens, limiting usable depth to a few cell layers. [anchor: "refractive index of the specimen introduce optical aberrations that compromise"]
- **Aberrations are modelled in the objective pupil (p. 2830, section 2a).** A high-NA objective converts planar wavefronts in the pupil to spherical wavefronts at focus; aberrations distort this and can be modelled as pupil phase variations, expanded in Zernike modes. [anchor: "A high numerical aperture (NA) objective lens transforms planar wavefronts that"]
- **Refractive-index mismatch (p. 2831, section 2b).** Focusing through a planar interface (immersion objective, cover glass, mounting medium) causes focal shift and spherical aberration growing with focusing depth; cover-glass spherical aberration is usually designed out of the objective, water immersion helps for aqueous samples. [anchor: "The primary effects of the refractive index mismatch"]
- **Inhomogeneous specimens (p. 2831, section 2b).** The "more significant problem" is the complex aberration from the inhomogeneous structure of biological specimens; Schwertner et al. measured it interferometrically (Figure 2, C. elegans, 1.2 NA water immersion, 633 nm transmitted light). [anchor: "A more significant problem is presented by the"]
- **System as source of aberration (p. 2832, section 2b).** Not all aberrations come from the specimen: imperfect optics, off-axis use, wrong conjugate, wrong wavelength or temperature also cause them. [anchor: "not all aberrations are caused by the specimen."]
- **Effects (p. 2832, section 2c).** Aberrations spread the focus laterally and, more, elongate it axially, lower focal intensity, reducing resolution, contrast and optical efficiency. Raising laser power restores signal but not resolution and adds photobleaching and phototoxicity. [anchor: "broadly speaking, aberrations lead to"]
- **High NA (p. 2837, section 4).** The statement tying aberrations to high NA is general: tight focusing with high-NA objectives is common to microscopy, data storage, tweezers and fabrication, and these "suffer from aberrations" as light passes through the specimen or substrate. The paper does not state that aberrations get worse as NA rises (not stated). [anchor: "tight focusing of light using high-NA objective lenses"]
- **Direct wavefront sensing is hard in microscopy (p. 2834, section 3b).** Shack-Hartmann and interferometric sensors need a point-like reference source (the astronomical guide star); in a thick specimen the reference is far from point-like, so the sensor receives many wavefronts and direct sensing is not straightforward. [anchor: "Therefore, direct wavefront sensing is not"] The Shack-Hartmann name is spelled "Shack-Hartman" in the paper. [anchor: "the most prominent methods being the Shack-Hartman wavefront sensor and"]
- **Reference source (p. 2834).** The guide-star analogue must be point-like; for reflected or scattered light, coherent interaction causes ambiguity, which does not occur for fluorescence. [anchor: "point-like reference source, such as the distant guide star used in astronomical"] [anchor: "does not occur for fluorescence emission, as the phase information"]
- **Indirect (sensorless) methods dominate (p. 2835, section 3b).** Most adaptive microscopes so far use no wavefront sensor and measure aberrations indirectly, which needs only minor modification of the microscope (adding the adaptive element) and avoids the sensor problems; typically the detector signal is maximised by an optimisation scheme. [anchor: "employed a wavefront sensor but have used indirect methods of aberration"] [anchor: "involves the maximization of the photodetector signal using an appropriate"]
- **Cost of indirect methods (p. 2835).** Stochastic methods (genetic, hill-climbing) need many iterations, possibly impractical where speed or low exposure matters; model-based modal sensing needs fewer measurements. [anchor: "tend to require a large number of iterations that might not be"] [anchor: "approaches based upon modal wavefront sensing have shown better performance,"]
- **Image-based phase retrieval (p. 2835).** Indirect measurement through phase retrieval from images "has also been suggested" (citing Hanser et al. 2004); the paper gives no detail. [anchor: "retrieval from images has also been suggested"]
- **Direct sensing can work with gating (p. 2835).** Direct sensing is applicable if out-of-focus light is excluded (pinhole modal sensor, coherence gating), but measurements still depend to a degree on specimen structure. [anchor: "Direct wavefront sensing can be applicable to microscopy if combined with a"]
- **Correction devices (pp. 2835-2836, section 3c).** Availability of practical, affordable devices was probably the main driver of microscope AO. Liquid-crystal SLMs have drawbacks (polarisation and wavelength dependence) incompatible with fluorescence; MEMS and other deformable mirrors suit fluorescence because of high optical efficiency. [anchor: "The commercial availability of practical, affordable correction devices has"] [anchor: "drawbacks of LC devices are their polarization and wavelength dependence"] [anchor: "where the high optical efficiency of the mirror ensures that"]
- **Choosing a DM (p. 2836).** Selection is "non-trivial"; cost, size, speed and robustness are self-explanatory, but manufacturer figures such as stroke or actuator count are poor guides to correction ability. [anchor: "Given the wide range of DMs available, the selection of an appropriate"] [anchor: "more is not necessarily better"]
- **Device speed (p. 2837, section 5).** Current DMs are limited to a few kilohertz, whereas commercial pixel rates can exceed 100 kHz. [anchor: "DMs are limited in speed to a few kilohertz"]
- **Spatial variation over the field (p. 2837, section 5).** Studies show specimen-induced aberrations can change significantly over the field of view, so real-time AO is desirable; multi-conjugate AO (several adaptive elements) is proposed for field-dependent aberrations. [anchor: "aberrations can change significantly over a microscope's field of view"] [anchor: "correcting field-dependent aberrations through the use of multi"]
- **Extended field by sub-regions (p. 2834, section 3a).** Potsaid et al. combined an objective with designed residual aberrations and a DM correcting over a sub-region of the field, giving diffraction-limited sub-images over an extended field. [anchor: "has been used to extend the field of view of a microscope"]

## Relevance to the thesis

- Supports: G24 (sources of aberration: specimen refractive-index variation, index mismatch, imperfect or misused optics; degradation of resolution, contrast, signal; p. 2829, 2831-2832). G26 (direct sensing with Shack-Hartmann needs a point-like reference and is not straightforward in microscopy; most microscope AO uses indirect, sensor-less optimisation; pp. 2834-2835). G27 in part (device selection is non-trivial, DMs limited to a few kHz, specimen aberrations vary over the field and multi-conjugate AO is proposed; pp. 2836-2837).
- Does not support: G25 (no discussion of PSF estimation, deconvolution, or the cost, noise or artifacts of computational correction; only a passing mention of phase retrieval from images and of image subtraction for background removal by Leray and Mertz, p. 2833, which is not deconvolution). G30 (no through-focus use stated). Any claim that DMs are "expensive" (the paper calls devices "affordable"), or that conventional corrections are spatially invariant (the paper only says field variation exists and requires better schemes). Any light-field or widefield-specific statement. Any claim that aberrations are stronger at high NA.

## Differences to state if cited

- The review frames direct (Shack-Hartmann, interferometric) sensing as hard because the specimen is not a point source, and states that most adaptive microscopes use indirect, signal-maximising methods. A thesis sentence saying "hardware solutions use wavefront sensing such as Shack-Hartmann" needs this caveat.
- Scope is confocal and two-photon scanning microscopy; widefield is mentioned only as future work (p. 2837). Epi-illumination tip/tilt and defocus are noted as self-correcting but causing image distortion (p. 2833), which is specific to scanning systems.
- Booth notes constructive uses of aberrations (wavefront coding, STED phase patterns; p. 2833), so "aberrations always degrade" is not his position.
- The paper describes field-varying aberrations as a motivation for future real-time and multi-conjugate AO, not as a measured limitation of single-correction systems.

## Still unread

- Reference list beyond the first pages, and all cited works (Schwertner et al. 2004a,b; Kam et al. 2007; Potsaid et al. 2005; Hanser et al. 2004).
- Figures 2 and 3 as images (captions only).

## Safe Wording

Aberrations arise from refractive-index variations in the specimen, from index mismatch at interfaces, and from imperfections or off-design use of the optics, and they reduce resolution, contrast and signal (Booth 2007, pp. 2829-2832). Direct wavefront sensing is difficult in microscopy because the specimen provides no point-like reference, so most adaptive-optics microscopes optimise an image-based signal instead of using a wavefront sensor (Booth 2007, pp. 2834-2835).
