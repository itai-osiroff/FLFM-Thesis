# Kner 2010 - Widefield adaptive optics for depth (spherical) aberration and motionless focusing

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

P. Kner, J. W. Sedat, D. A. Agard, Z. Kam, "High-resolution wide-field microscopy with adaptive optics for spherical aberration correction and motionless focusing", Journal of Microscopy 237(2), 136-147, 2010. doi: 10.1111/j.1365-2818.2009.03315.x (printed on p. 136). Received 4 December 2008, accepted 20 July 2009. Metadata match the assignment; no discrepancy.

## What was read

File C4a\C4a_08.txt, all 12 PDF pages (printed pp. 136-147): summary, introduction, methods, results, discussion, reference list. Figures were not viewed as images; only their captions were read. No supplement is mentioned.

## Why This Matters

A camera-based widefield fluorescence microscope with a deformable mirror (DM) that corrects depth (spherical) aberration, with the correction computed from the known depth and refractive indices instead of measured from the sample. It supports the statement that aberrations from refractive-index mismatch degrade high-NA imaging, and it gives a concrete example of a hardware (AO) solution and of how it is positioned against deconvolution. It does not use Shack-Hartmann sensing to measure the sample aberration.

## Key Claims (paraphrased)

- **Aberration source and effect (p. 136, Summary; p. 136, Introduction).** Depth aberrations are a major cause of image degradation in 3D microscopy, with loss of resolution and intensity deep in the sample. They arise from the mismatch between sample and immersion-medium refractive indices. High-NA objectives are well corrected only just below the cover slip. [anchor: "Depth aberrations are a major source of image"]
- **Two aberration origins (p. 136, Introduction).** Image degradation comes from path-length errors due to the sample/immersion index difference (depth aberration) and from index variations inside the sample (sample-induced aberration). In many samples depth aberration dominates, and the paper concentrates on it. [anchor: "the dominant aberrations are depth aberrations"]
- **Magnitude of the effect (p. 136, Introduction).** Imaging 20 um into a live sample (index 1.36) with an oil-immersion lens lowers the PSF peak intensity about 3-fold and widens the PSF axially about 2-fold (attributed by the authors to Gibson and Lanni 1991). [anchor: "to drop 3-fold"]
- **Index matching or water lenses are not a complete fix (pp. 136-137, Introduction).** Matching indices is often not feasible for live imaging; water immersion only moves the onset of serious aberration from a few um to a few tens of um; a correction collar fixes the PSF for one depth only. (The full sentence wraps across lines in the text file; the anchor below is the nearest single-line phrase.) [anchor: "Water lenses have a correction collar which is"]
- **Hardware (p. 139, Microscope design; Deformable mirror control).** The DM is a Mirao52D (Imagine Optic), 15 mm diameter, 52 actuators on a square grid with 2.5 mm spacing, conjugate to the objective back pupil in both excitation and emission paths. It has a maximum displacement of +-75 um for focus and +-8 um for first-order spherical aberration; it can form Zernike modes to order 4. Camera is a cooled CCD. [anchor: "actuators on a square grid with 2.5 mm spacing"]
- **Cost and complexity (p. 137, Introduction; p. 146, Discussion).** No price or cost statement is made anywhere in the paper (cost: not stated). Related remarks: DMs only recently became small enough for microscopy; dense-actuator DMs typically deform only a few wavelengths, so a two-mirror "woofer-tweeter" design is suggested; DM print-through (periodic actuator-grid structure) produces satellite peaks about 1% of the central peak and a structured out-of-focus blur in widefield images (pp. 140-141). A single few-actuator purpose-built mirror is proposed as a smaller and faster alternative (p. 146). [anchor: "Only recently have DMs become sufficiently small for them"]
- **How the aberration is obtained: open loop, predictive (p. 137, Materials and methods).** The correction is calculated from the depth, NA, and the two refractive indices (Eq. 1), not measured from the sample image; the authors call it an open-loop predictive algorithm. They state that they chose this because most earlier schemes need several images to optimize the correction, which is a problem for weak, bleaching fluorescence. [anchor: "open-loop predictive algorithm similar to the approach"]
- **Drawback of image-based schemes (p. 137, Introduction).** Most proposed AO schemes require several images to optimize the correction. [anchor: "they require several images to be taken to optimize the"]
- **Wavefront sensing in this paper is only for the mirror (p. 138, Microscope design; p. 139, Deformable mirror control).** A HeNe reference beam (632 nm) goes through the same path to a Shack-Hartmann sensor (Haso 32, 32 x 32 lenslets) that monitors DM shape; the DM is controlled by measuring one-actuator influence responses and inverting by SVD (45 singular values kept). The sensor does not look at the sample's fluorescence. [anchor: "wavefront sensor (Haso 32, Imagine Optic,"]
- **Other sensing approaches named by the authors (p. 137, Introduction).** Rueckel et al. use backscattered excitation light for wavefront sensing (two-photon); Booth et al. used a modal wavefront sensor that required extra images. Both are cited, not tested, here. [anchor: "use backscattered excitation light to measure the wavefront"]
- **Bead PSF and phase retrieval (p. 140, Sample preparation; p. 141, Imaging beads).** 200 nm beads give the PSF estimate, and phase retrieval (Hanser et al. 2004) of the bead stack is used to compute the back-pupil wavefront, in which the DM print-through (about 30 nm) is visible. This is characterization of the instrument, not the correction loop. [anchor: "We have used phase-retrieval"]
- **Field dependence (p. 137, Introduction).** The authors state that depth aberrations can be corrected across the entire field of view because the path differences depend only on emission angle and not on field position, so one pupil-plane correction applies to the whole field. [anchor: "readily corrected across the entire field of view"]
- **Depth dependence (p. 139, Three-dimensional image stacks).** The correction does vary with depth: in stacks it was re-set for each depth so the PSF stays corrected throughout (exceptions: Figs 4 and 6 set to the bead depth). [anchor: "the correction was adjusted for"]
- **Sample-induced aberrations are not corrected (p. 137; p. 146).** The correction is incomplete for samples with internal index variations. A future goal is DMs conjugate to several planes in the sample to correct variations over the field of view (citing simulations by Kam et al. 2007). Spatially varying correction is therefore described as future work, not demonstrated. [anchor: "additional DMs conjugate to several planes in the sample itself"]
- **Comparison with software (pp. 136-137, Introduction).** Deconvolution needs an accurate PSF, and a mismatch between true and assumed PSF degrades it. Depth-dependent-PSF deconvolution exists but is computationally intensive, and cannot restore peak intensity as fully, giving sub-optimal SNR; this is said to hold generally for post-acquisition algorithms. [anchor: "a mismatch between the true PSF and that used"]
- **Software cannot fully restore intensity (p. 136-137).** [anchor: "can never as fully restore the peak intensity of the original"]
- **AO and deconvolution are combined, not opposed (p. 145, Discussion; pp. 142-143).** Because AO makes the PSF constant with depth and similar to the cover-slip PSF, fast space-invariant deconvolution can replace depth-dependent deconvolution. Deconvolution of AO-corrected actin images shows less background than deconvolution of the uncorrected data (Fig. 9). Deconvolution is still needed to remove DM print-through structure. [anchor: "the use of fast space-invariant deconvolution algorithms"]
- **Deconvolution runtime (p. 140, Deconvolution).** Their AIDA myopic deconvolution of a 256 x 256 x 64 stack took about 30 min on a Pentium III computer (an old machine; not a general speed statement). [anchor: "approximately 30 min on a Pentium III computer"]
- **Bead improvement (p. 142, Imaging beads).** For a 200 nm bead 67 um deep in a medium of index 1.42, correction raises peak intensity by a factor of about two (measured 2.05, theory 3.75), removes the low-intensity pedestal around the peak, and narrows the axial width. Lateral FWHM is not significantly changed. The factor of 2 is attributed to residual system/sample aberrations and limited DM accuracy (p. 145). [anchor: "of the corrected images is a factor of two larger than the"]
- **Lateral width unchanged (p. 142).** [anchor: "is not significantly changed by the correction"]
- **Biological samples (p. 142-143, Biological imaging).** GFP-TRF1 telomeres in bladder cancer cells 23 um deep: peak 60% brighter after background subtraction. Drosophila centromeres: no intensity gain, axial FWHM 27% smaller. Results are less dramatic than for a bead because tissue scatters and adds other aberrations. [anchor: "brighter by 60% after subtracting the broad autofluorescence"]
- **Centromere result (p. 143).** [anchor: "smaller by 27% in the axial direction"]
- **Biological results weaker than bead (p. 142).** [anchor: "less dramatic than the results on a single bead because the"]
- **Open-loop limitation (p. 145, Discussion).** In closed-loop AO, system aberrations are compensated automatically, which is not possible in this open-loop design. [anchor: "closed loop AO systems, system aberrations are automatically"]
- **Motionless focusing (pp. 143-145, Figs 10-11; Eq. 2).** The same DM can focus by adding the focus phase term; this is shown on beads and on C. elegans, but it adds aberrations because the remote-focus layout is sensitive to errors in components before the DM. Defocus is used here to move the focal plane, not to measure aberrations. (Relevant to G30 only in that the paper does not use through-focus images for aberration estimation beyond bead PSF stacks.)

## Relevance to the thesis

- Supports G24: aberrations from refractive-index mismatch (depth aberration) and from sample index variations degrade high-NA fluorescence imaging; quantified example of the effect (p. 136).
- Supports G26 only partly: AO hardware is used, but the aberration is predicted from known depth and indices (open loop). A Shack-Hartmann sensor appears only as a monitor of the DM using an internal reference laser, not as a sample-aberration sensor. The paper notes that Rueckel et al. sense with backscattered light and Booth et al. needed extra images for a modal wavefront sensor, and that most proposed schemes need several images; it does not say wavefront sensing in microscopy is hard. Check the Ji 2010 caveat separately.
- Supports G25 in a limited way: depth-dependent deconvolution is computationally intensive, needs accurate PSF knowledge, and cannot restore peak intensity as fully (pp. 136-137). It does not say software is artifact-prone or that it amplifies noise; it says it gives sub-optimal SNR.
- Supports G27 in part: the correction is a single pupil-plane correction valid across the field for depth aberration (spatially invariant); sample-induced field-varying correction is future work (pp. 137, 146). Complexity of DM approach is discussed (print-through, small throw of dense mirrors, woofer-tweeter), but cost is not stated.
- Does not support: any claim that DMs are expensive (no cost given); any claim that AO beats deconvolution (they are combined); that this paper measures aberrations with Shack-Hartmann; that spatially varying aberrations were corrected; G30 (no through-focus aberration estimation).

## Differences to state if cited

- The aberration treated is spherical/depth aberration from index mismatch, which is invariant across the field, unlike the thesis's assumption of aberrations appearing as local shifts between views.
- Correction is open loop and uses a model with an assumed sample index (1.34 to 1.42 in different experiments), not a measured wavefront.
- Test samples are beads, fixed cells, and live worms at depths of several to tens of um, widefield with a camera, not a light-field system.
- The paper's own comparison is with depth-dependent deconvolution; deconvolution remains part of its pipeline.

## Still unread

- Figures themselves (only captions read); no supplement referenced.
- Cited sources (Kam et al. 2007, Potsaid 2005, Rueckel 2006, Booth 1998, Gibson and Lanni 1991) were not read; statements about them are the authors' characterizations.

## Safe Wording

Kner et al. corrected depth-induced spherical aberration in a widefield fluorescence microscope with a deformable mirror conjugate to the back pupil, using a calculated (open-loop) correction because the aberration depends on emission angle rather than field position, and showed a roughly two-fold gain in bead peak intensity at 67 um depth (J. Microsc. 237, 136-147, 2010; pp. 137, 142).
