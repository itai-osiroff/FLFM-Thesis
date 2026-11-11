# Bibliography Gap Audit

> **Status:** draft
>
> **Reviewed:** 2026-11-11

Phase 1 of the bibliography expansion: where the manuscript lacks source
support, and which gaps the existing `overleaf/back/thesis.bib` can already
close. This audit lists gaps and leads only. It adds no bibliography entry,
verifies no source, and changes no prose or scientific claim.

## Scope

Three clusters, chosen by the author on 2026-11-10:

| Cluster | Covers |
| --- | --- |
| **C1** LFM/FLFM variants and reconstruction | LFM and FLFM designs, sampling trade-offs, deconvolution, learned and other reconstruction families. |
| **C2** Aberration correction in light-field systems | Digital and optical aberration correction, how aberrations appear in light-field views, field-dependent aberrations. |
| **C3** Registration and local displacement | Cross-correlation registration, dense local displacement and correspondence, light-field disparity, warping, view fusion. |

Out of scope by the author's decision: image-quality metrics, image-reporting
checklists (QUAREP, W01), and the lab's earlier work.

Placement follows [revised-thesis-structure.md](revised-thesis-structure.md).
Chapter 2 is budgeted at about 2 pages, so each cluster gets roughly one short
paragraph there. The bibliography does not count toward pages, but the prose
that cites it does.

## Current state

21 entries in `thesis.bib`; 11 are cited in `overleaf/main/`.

| Cited | Uncited (in the bib, no `\cite` anywhere) |
| --- | --- |
| Guo 2019 (7 uses), Levoy 2009 (3), Broxton 2013 (3), Levoy/Hanrahan (2), Levoy 2006, Prevedel 2014, Stefanoiu 2019, Jacques 2013, Helmchen/Denk 2005, Swoger 2007, Preibisch 2010 | Hua 2021, Galdón 2022, Yun 2023, Zhang 2021, Ng/Hanrahan 2006, Booth 2014, Ji 2017, Zhang 2023, Goodman 2015, Preibisch 2014 |

Chapters 4, 6 and 7 contain no citations. Chapter 5 and Appendix A cite only
Levoy/Hanrahan and Guo.

## Gap register

Tier **A** means existing bib entries can carry the claim once the prose cites
them (reread the note's inspected passage first). Tier **B** needs a new source.
Chapter numbers are the current ones.

### Chapter 5 and Appendix A (C3, first handoff candidate)

| ID | Claim in the text | Tier | Existing support | What is missing |
| --- | --- | --- | --- | --- |
| G1 | Combining aligned views by averaging "as in classical light-field rendering" | A/B | Levoy/Hanrahan (2023 reprint entry) | Decided: cite the 1996 original (replace the reprint entry); a source for shift-and-add refocusing or synthesis from sub-aperture views. |
| G2 | Global stage: one translation per view from bounded cross-correlation over integer shifts | B | none | Foundational source on correlation-based image registration. |
| G3 | Local stage: per-pixel bounded displacement search by a Gaussian-weighted, normalized, correlation-like score | B | none | Sources for dense local displacement (optical flow, block matching, stereo correspondence) and for windowed normalized cross-correlation. |
| G4 | Global-then-local sequence (coarse translation, then spatially varying refinement) | B | none | Coarse-to-fine or hierarchical registration precedent. |
| G5 | Displacement field warped by linear interpolation with backward sampling | B | none | A textbook or survey reference for resampling and backward warping. |
| G6 | Local shifts between sub-aperture views as a measure of scene or aberration structure | B | none | Light-field disparity estimation from sub-aperture views, as the nearest analogue to the local displacement field. |
| G7 | Registration and fusion of multiple views as adjacent precedent | A | Swoger 2007, Preibisch 2010, Preibisch 2014 (analogy only, per the gap-fill note) | Prose that uses them; Preibisch 2014 is still uncited. |
| G8 | Sub-pixel (upsampled) displacement search | B | none | Sub-pixel registration source. |

### Chapter 3 (C2 basics, then C1)

| ID | Claim in the text | Tier | Existing support | What is missing |
| --- | --- | --- | --- | --- |
| G9 | The chapter opening promises "optical degradation mechanisms and their effect on scene recovery", but only tissue absorption and scattering (Jacques) are covered. No source explains aberrations as wavefront error, system-induced versus sample-induced aberration, or how an aberration shows up in a light-field view. | A/B | Booth 2014, Ji 2017, Zhang 2023, Goodman 2015 (all uncited) | A primary or textbook source linking wavefront error to ray or view displacement. |
| G10 | Digital aberration correction in light-field imaging as ray-space remapping | A | Ng/Hanrahan 2006; Levoy 2009 (Fig. 17 digital correction under refractive mismatch, currently cited only for geometry) | Ng/Hanrahan venue metadata; any microscope-specific digital-correction source. |
| G11 | Spatial-angular sampling trade-off ("allocating more samples to angular diversity...") | A | Levoy 2009 (note states it), Guo 2019 | Cite it. |
| G12 | Views as sub-aperture images, one per microlens; NA matching and conjugation of the 4F relay | A | Guo 2019, Galdón 2022, Yun 2023 | Cite them. |

### Chapter 2 (C1, C2, C3 together)

| ID | Claim or planned content | Tier | Existing support | What is missing |
| --- | --- | --- | --- | --- |
| G13 | The scope sentence promises statistical optics, aberrations, scattering and reconstruction methods; the chapter has none of the latter three | B | see G9, G10, G14 | Plan one short paragraph per cluster within the 2-page budget. |
| G14 | LFM reconstruction families: wave-optics deconvolution is covered, but nothing else (other deconvolution variants, learned reconstruction, other FLFM-family layouts) | B | Broxton, Stefanoiu, Hua 2021, Zhang 2021 | A few well-chosen representatives of the other families. |
| G15 | FLFM lineage and practicalities | A | Hua 2021, Galdón 2022, Yun 2023 | Cite them. |
| G16 | Aberration correction in microscopy | A | Booth 2014, Ji 2017, Zhang 2023 | Cite them; add digital-AO precedent in light-field microscopes (see leads). |
| G17 | View alignment and fusion precedent | A | G7 sources | Cite them; add light-field disparity work if the chapter needs it. |

### Chapter 1 (late; the new Chapter 1 is still to be written)

| ID | Claim in the text | Tier | Existing support | What is missing |
| --- | --- | --- | --- | --- |
| G18 | Sequential depth scanning costs temporal resolution and exposure | A | Levoy 2006, Prevedel 2014 | Cite them. |
| G19 | Early LFM: uneven sampling and heavy estimation and deconvolution cost | A | Broxton, Stefanoiu, Guo | Cite them. |
| G20 | FLFM trades spatial resolution for angular views; larger and fewer lenslets favour spatial resolution | A | Guo, Levoy 2009, Galdón 2022 | Cite them. |
| G21 | Software aberration correction needs PSF estimation and deconvolution and is costly, artifact-prone and noise-amplifying | A/B | Broxton and Stefanoiu (artifacts in deconvolution) | A source specific to PSF-estimation-based correction and noise amplification. |
| G22 | Hardware AO: Shack-Hartmann sensing, deformable mirrors, spatially invariant correction usually insufficient for biological samples | A/B | Booth, Ji, Zhang 2023 | Check that they support the isoplanatic-patch and field-dependent statement; add a source if not. |
| G23 | The thesis premise that aberrations appear as simple view shifts estimable from the angular data | A/B | Ng/Hanrahan (conceptually) | Decided: the thesis's own assumption. Needs background sources for plausibility (see G9, G10) and wording that does not attribute it to a source. |

### Later (Chapters 4, 6, 7)

- Chapter 4: view extraction and NA matching may cite Galdón 2022 and Yun 2023
  (tier A). Other setup content is outside the three clusters.
- Chapter 7 will compare against deconvolution, digital AO and scattering-aware
  LFM. Decide the comparison set after the results are stable; do not
  pre-search it.

## Existing sources that are not yet used

| Source | Gap IDs it can carry |
| --- | --- |
| Hua 2021 | G14, G15 |
| Galdón 2022, Yun 2023 | G12, G15, G20 |
| Zhang 2021 | G14 (scattering-aware LFM as comparison only) |
| Ng/Hanrahan 2006 | G10, G23 |
| Booth 2014, Ji 2017, Zhang 2023 | G9, G16, G22 |
| Goodman 2015 | G9 |
| Preibisch 2014 | G7, G17 |

Roughly 14 of the 23 gaps are tier A or A/B, so a first pass of Phase 4 can
reduce the uncited list before any new source is read.

## Bibliography hygiene to resolve in Phase 3

- `ngHanrahan2006digitalCorrection` has no verified venue (`@misc` with a
  Stanford URL). Resolve the published form before citing it.
- `levoyHanrahanLightFieldRendering2023` is a 2023 ACM reprint. Decided: cite
  the 1996 original instead (see Author decisions).
- The bib header says to add only sources that are cited or likely to be
  cited. Ten uncited entries are currently "likely"; cite or remove them
  before submission.

## Leads for Phase 2 (unverified)

Phase 2 results are in [bibliography-candidates.md](bibliography-candidates.md)
(existence and metadata checked only). The list below is the original lead set,
kept for the record. These are search directions written from memory, not
citations. Confirm
existence, metadata and the passage that supports the claim in Phase 3
([source-register.md](../literature/writing-guidance/source-register.md) rules
apply).

| Cluster | Leads |
| --- | --- |
| C1 | XLFM (extended-view light-field microscopy); phase-space deconvolution for LFM; scanning or virtual-scanning LFM; deep-learning LFM reconstruction; wavefront coding for LFM. |
| C2 | Digital adaptive optics in a light-field microscope (Wu et al., Cell, 2021); plenoptic and light-field wavefront sensing versus Shack-Hartmann; a wavefront-to-ray-displacement reference in an optics textbook (Born and Wolf; Mahajan on aberrations); plenoptic refocusing (Ng et al. 2005). |
| C3 | Registration surveys (Brown 1992; Zitová and Flusser 2003); phase correlation (Kuglin and Hines 1975); sub-pixel registration (Guizar-Sicairos et al. 2008); optical flow (Lucas-Kanade 1981; Horn-Schunck 1981); dense stereo correspondence taxonomy (Scharstein and Szeliski 2002); local-correlation registration (Avants et al. 2008); fast normalized cross-correlation (Lewis 1995); light-field disparity estimation (Wanner and Goldluecke; Jeon et al. 2015; Tao et al. 2013); hierarchical motion estimation (Bergen et al. 1992); a computer-vision textbook for resampling (Szeliski). |

## Proposed order

1. **Chapter 5 and Appendix A (C3):** this is the first handoff candidate, and
   G2-G6 and G8 have no support at all. Tier B search starts here.
2. **Chapter 3 (C2, G9-G12):** mostly tier A plus one source for the
   wavefront-to-displacement link.
3. **Chapter 2 (G13-G17):** write once the sources above are settled.
4. **Chapter 1 (G18-G23):** with the new Chapter 1; G23 needs an author
   decision on whether the premise is cited or stated as the thesis's own.

Indicative size of the additions (planning estimate, not a target to hit):
C1 3-5 new entries, C2 3-5, C3 5-8.

## Author decisions (2026-11-10)

- **G23:** "aberrations appear as simple shifts" is the thesis's **own modelling
  assumption**, not a sourced premise. Chapter 1 states it as an assumption.
  Sources (Ng/Hanrahan ray-space remapping, the Shack-Hartmann principle,
  Levoy 2009 Fig. 17) support the background and the plausibility of the
  assumption, not the assumption itself; keep that distinction in the wording.
  Do not search for a source that "proves" it.
- **G1:** cite the **1996 Levoy/Hanrahan original**. Replace
  `levoyHanrahanLightFieldRendering2023` with the original entry in Phase 3
  and update its two uses (Chapter 5, Appendix A). Verify the 1996 metadata
  against the primary source first.
- **Chapter 2 priority:** if the paragraphs compete for space, **C2
  (aberration correction in light-field systems)** gets the most room, then
  C3 and C1. This is a priority for the cluster-level search effort, not a
  change to the 2-page budget.

## Added 2026-11-10: aberration-correction methods in fluorescence microscopy (C4)

The three original clusters covered aberration correction in **light-field**
systems (C2). The Chapter 1 paragraph on existing aberration solutions, and the
Chapter 2 section the author is writing, also describe correction methods for
fluorescence microscopy in general. Status of the claims in the current
Chapter 1 text:

| ID | Claim | Support so far | Gap |
| --- | --- | --- | --- |
| G24 | Aberrations stem from the sample, its environment or the optics, and degrade high-NA fluorescence imaging | Wu 2021 (Cell version, p. 3318: tissue refractive-index nonuniformity causes severe aberrations, citing Booth 2014 and Ji 2017); Ji 2010 introduction. Booth 2014, Ji 2017 and Zhang 2023 are in the bib but were not re-read this session. | Verify the three reviews; they are the natural sources for the overview. |
| G25 | Software solutions need PSF estimation and deconvolution, and are costly, slow, artifact-prone and noise-amplifying | Only partial: Lu 2019 (p. 18131) says high-precision LFM deconvolution models are not robust to aberrations and background and produce periodic artifacts. Nothing on PSF estimation or noise amplification in general. | A source for computational aberration correction and its costs (lead: Kam et al. 2001, "Computational adaptive optics for live three-dimensional biological imaging", PNAS, from Ji 2010's reference list; plus a deconvolution review for noise amplification). Unverified. |
| G26 | Hardware solutions use Shack-Hartmann wavefront sensors and adaptive optics | Platt and Shack 2001 for the sensing principle. **Ji 2010 (p. 1) says direct wavefront sensing is hard in microscopy because a sensor can rarely be placed inside the specimen, and that image-based (indirect) methods are used instead.** The Chapter 1 sentence may overstate the Shack-Hartmann route. | Reword to distinguish direct (wavefront sensor, guide star) from indirect (image-based, sensorless) AO; check Booth 2014 and Ji 2017 for the classification. |
| G27 | Deformable mirrors are expensive, and corrections are usually spatially invariant | Spatial variation: Ji 2010 Discussion (p. 6: a single wavefront averages over a region; local measurements needed) and Wu 2021 (p. 3319: tiling AO correction restricts speed over a large volume). **No source for the cost claim.** | Source or drop the cost claim; soften "usually only spatially invariant" to what the sources say (tiling and local measurements are possible at a cost in speed). |

### C4 broadened (2026-11-11)

Author decision: C4 covers PSF estimation and deconvolution and adaptive optics
thoroughly, and also other solutions: ptychography, structured illumination, and
defocus used to combat aberrations and build 3D scenes. **Source rule:** use
fluorescence-microscopy sources first, and sources outside microscopy only where
no fluorescence source exists for the claim.

| ID | Claim or topic | Candidate sources | Status |
| --- | --- | --- | --- |
| G24, G26, G27 | AO: aberration origins, direct versus sensorless AO, widefield and spatially varying correction, cost | Hampson 2021, Booth 2007, Rueckel 2006, Débarre 2009, Kner 2010, Scrimgeour and Curtis 2012, Furieri 2021 (plus the three reviews already in the bib) | Candidates listed (C4a in [candidates](bibliography-candidates.md)); none read |
| G25 | PSF estimation, deconvolution and computational correction: cost, artefacts, noise amplification | Sibarita 2005, McNally 1999, Sarder 2006, Kam 2001, Hanser 2004, Gibson and Lanni | Candidates listed (C4b); none read |
| G28 | Coherent Fourier ptychography, pupil recovery and transfer to fluorescence deconvolution | Zheng 2013, Ou 2014, Chung 2016 (fluorescence), Konda 2020 | 12 PDFs reviewed. See [C4c–C4e triage](bibliography-candidates.md#phase-3-results-for-c4c-c4e-2026-11-11). |
| G29 | Structured illumination for resolution, sectioning and aberration sensitivity | Gustafsson 2000, Neil 1997, Wu and Shroff 2018, Débarre 2008 | 13 PDFs reviewed. Gustafsson 2000, Neil 1997, Débarre 2008 and Wu and Shroff 2018 added. |
| G30 | Defocus, through-focus and phase-diversity measurements for aberration estimation and 3D | Hanser 2004 for bead pupil estimation, Agard 1984 for focal-stack reconstruction, Kao and Verkman 1994 for engineered depth encoding | 14 PDFs reviewed. Kao and Verkman added. Joint phase diversity and light-field depth remain author decisions. |

A web search found no fluorescence-microscopy review of depth from defocus; the
nearest are depth-variant deconvolution papers.

### C4a and C4b findings against the Chapter 1 claims (2026-11-11)

Read: the 14 AO papers and 20 deconvolution/PSF papers in `literature/C4a/` and
`literature/C4b/` (notes in `literature/notes/`; locators are printed journal
pages, or PDF pages for the Hampson author manuscript). The author decides the
wording; the right-hand column states what the sources support.

| ID | Chapter 1 claim | What the sources support | Suggested wording and sources |
| --- | --- | --- | --- |
| G24 | Aberrations from sample, environment or optics degrade fluorescence imaging | Specimen refractive-index variation is the main source, and index mismatch gives depth-growing spherical aberration; not all aberrations come from the specimen (Booth 2007, pp. 2831-2832). Same split in Hampson 2021 (PDF p. 20, Table 1). Mismatch with depth in widefield: Kner 2010 (p. 136), Gibson and Lanni 1991 (p. 1601). Neither Booth 2007 nor Hampson ties the effect to NA explicitly (Hampson says "especially" for high-resolution imaging); Sibarita says theory fails especially for high-NA oil objectives (pp. 207-208). | Cite Booth 2007 and Hampson 2021 (already supported by Wu 2021 p. 3318 via Booth 2014 and Ji 2017). Do not attach "high NA" to a review that does not say it. |
| G25 | Software solutions need PSF estimation and deconvolution, and are costly, slow, artifact-prone, noise-amplifying | **Needs a PSF:** Sibarita p. 210, McNally pp. 374 and 376, Wallace, Sarder pp. 39-40. **Wrong PSF gives artefacts:** Sibarita p. 210, Wallace p. 1088, Sarder pp. 37-38 (ringing), Hanser p. 46, Preza p. 1594. **Amplifies noise:** direct inversion (Sibarita pp. 224-225, Sarder p. 37, McNally p. 378) and Richardson-Lucy (Dey p. 260, Wallace p. 1082). **Slow:** iterative, statistical and blind methods only (McNally pp. 373 and 379: seconds to hours; Sibarita p. 230: 50-1000 iterations; Sarder pp. 38-39 and 44; Kenig p. 2200: about 2 h; Kim 2015: 27.5 h). **Caveats:** cost is computing time, not money; statistical (maximum-likelihood) methods model noise and are described as robust (Sibarita pp. 230 and 237; McNally p. 379); Sibarita (p. 203) says deconvolution runs on inexpensive computers and Sage 2017 (p. 29, not added to the bib) reports a 512 x 512 x 64 volume in under a couple of minutes on a consumer PC; Wallace does not call it prohibitively slow. Kam 2001 (computational AO): aberration is predicted from a refractive-index map and corrected by space-variant deconvolution; the full point-by-point version is "computationally intractable" for 3D (p. 3794); demonstrated on beads only. Hampson (PDF p. 29): physical correction is preferred over deconvolution because the extra measurement gains photons and signal-to-noise. | Name the algorithm class: "estimate or assume a PSF and deconvolve; an inaccurate PSF produces artefacts, direct inversion amplifies noise, and iterative or blind methods are computationally heavy" [Sibarita 2005; McNally 1999; Sarder 2006; Dey 2006; Kenig 2010]. Drop "costly" or read it as computation. Do not claim all software methods amplify noise. |
| G26 | Hardware solutions use Shack-Hartmann sensors and AO | Direct sensing (Shack-Hartmann or interferometric) needs a point-like reference, which a thick specimen lacks, so indirect (image-based, sensorless) methods predominate in microscopy (Booth 2007, pp. 2834-2835). Hampson (PDF pp. 8 and 20): both are common; indirect suits microscopy because aberrations are mostly static. Direct sensing in tissue needs a guide star and falls back to indirect AO beyond its limits (Wang 2015, p. 2 and p. 6; Azucena 2010, p. 17522). Wavefront sensing with Shack-Hartmann is thus one route, not the default. Débarre 2009 treats a sensor and indirect measurement as two options. The classification is not clean across papers (Neil 2000 calls an image-based scheme a "modal wavefront sensor"). | "Hardware solutions measure the wavefront, either directly (a wavefront sensor such as Shack-Hartmann, usually with a guide star) or indirectly from image quality, and correct it with a deformable mirror or spatial light modulator" [Booth 2007; Hampson 2021; Wang 2015; Débarre 2009; Platt and Shack 2001 for the sensor principle]. |
| G27a | Deformable mirrors are expensive | **No source says so.** Searched all 14 AO papers: Booth 2007 calls correction devices "practical, affordable" (p. 2835). Closest statements are about complexity: multiconjugate AO "adds significant cost and complexity" (Hampson, PDF p. 6; Liu 2018 pp. 11-12 on multiconjugate AO); "high cost and complexity" of AO in ophthalmic imaging (Hampson); wider microscope adoption "relies on making systems more compact, less expensive and easier to use" (Hampson, PDF p. 28). Booth 2007 on devices: selection is non-trivial (p. 2836); deformable mirrors are limited to a few kilohertz (p. 2837). Wallace p. 1091 prices a water-immersion correction-collar lens at about 10,000 dollars, which is not a deformable mirror. | Drop "expensive" or reword to "add cost and complexity" and cite Hampson 2021 for that. |
| G27b | Corrections are usually spatially invariant | One corrector covers only the isoplanatic patch: hundreds of micrometres in mouse brain down to a few micrometres in zebrafish larvae or C. elegans (Hampson, PDF p. 6); 30-60 micrometres in zebrafish embryos, handled by tiled corrections, and a correction applied outside its patch can be worse than none (Liu 2018 p. 6); after one correction only 3.7 and 8.6 percent of a widefield field is well corrected (Furieri 2022, p. 264, Table 1); about 38 micrometres (Azucena 2010, abstract; its text also gives a 10 micrometre radius). Depth aberration in widefield is the same across the field by construction (Kner 2010 p. 137), so a single correction is natural there. Wallace p. 1090 and Sibarita p. 236: deconvolution software assumes a spatially (or axially) shift-invariant PSF. | "A single correction is valid only inside an isoplanatic patch whose size varies from hundreds of micrometres to a few micrometres, so large fields need tiled or multiconjugate correction at a cost in speed and complexity" [Hampson 2021; Liu 2018; Furieri 2022; Wu 2021 p. 3319]. Do not write "usually only spatially invariant" as a universal. |
| G30 | Defocus or through-focus images measure aberrations or give 3D | Through-focus bead measurements support pupil and PSF recovery (Hanser 2004, p. 35). A focal series supports optical-sectioning reconstruction (Agard 1984, p. 191). Kam 2001 predicts aberration from a DIC-derived index map (pp. 3790, 3792) and compares with measured bead PSFs. Kao and Verkman use calibrated astigmatism to estimate axial position of isolated fluorescent particles (p. 1291). | Use Hanser for pupil estimation, Agard for focal-stack reconstruction and Kao and Verkman if discussing engineered depth encoding. |

**Support for the shift premise (G23), found while reading:** Hampson 2021 (PDF
p. 7: tip/tilt is an image shift; PDF p. 11: zonal sensorless AO finds each pupil
zone's tilt from image shifts), Rodríguez and Ji 2018 (p. 86, lateral image shifts
between pupil subregions), Scrimgeour and Curtis 2012 (shift of each segment image
read as local pupil tilt; one correlation shift per segment, system aberration
only) and Furieri 2022 (the SPAM device reconstructs the wavefront from relative
shifts between images through pupil sub-apertures). These support plausibility of
the assumption and the hardware principle, not the thesis method, and remain the
author's own modelling assumption (author decision of 2026-11-10).

**Still open:** the Chapter 1 wording is the author's to change; the C4c-C4e
clusters (ptychography, structured illumination, defocus and phase diversity)
have not been read.

### C4c to C4e findings (2026-11-11)

Full reads of the 39 PDFs in `literature/C4c/`, `C4d/` and `C4e/`; notes in
`literature/notes/`. Locators are printed pages unless stated.

| ID | Claim | What the sources support | Suggested wording and sources |
| --- | --- | --- | --- |
| G28 | Ptychography combats aberration but needs coherent light and many captures, so is not applicable to fluorescence emission | Basic FP uses spatially coherent LED illumination and many sequential captures (Zheng 2013 p. 744: 137 LEDs, about 3 min; Konda 2020 pp. 9607 and 9611: at least 2N measurements, partially or substantially coherent). Zheng 2013 p. 744 states it is not a fluorescence technique; Dong 2014 p. 20859 explains why (fluorophores ignore the excitation phase). Maiden 2009 p. 1257 states high coherence and 60-70 percent overlap are required. Pupil recovery: full pupil jointly with the sample (Ou 2014), tiles treated as space-invariant (Ou 2014 p. 4968; Chung 2016 p. 356); three Zernike modes in one global pupil (Bian 2013). Fluorescence routes exist: pupil from brightfield FP used to deconvolve fluorescence (Chung 2016; thin samples, 2 to 21 min exposures), patterned illumination (Dong 2014), incoherent per-tile estimation (Chung 2019, 45 s sequence, fluorescence only a prospect). Zheng 2021 and Konda 2020: 4 to 137 images, single-shot variants trade field of view. | "Fourier ptychography recovers the pupil from many angle-diverse images taken under coherent illumination; fluorescence emission is incoherent, so the original method does not apply, and variants need extra acquisitions" [Zheng 2013; Dong 2014; Chung 2016; Zheng 2021]. Do not say it cannot be used with fluorescence, or that it needs hundreds of images. |
| G29 | SIM gives sectioning or resolution but needs several images and is aberration-sensitive | 2D SIM needs nine raw images (Thomas 2015 p. 026006-3); Neil 1997 and Gustafsson 2000 give the principle; Gustafsson 2008 covers 3D. Aberrations split into grid modes (affect the pattern, hence sectioning) and non-grid modes (Débarre 2008 p. 9293); one correction is averaged over the frame (Débarre 2008 p. 9302; Thomas 2015 p. 026006-7). | "SIM needs several patterned exposures and a reconstruction, and aberrations in the pattern or PSF degrade it; adaptive optics restores it with one correction per field" [Gustafsson 2000; Neil 1997; Wu and Shroff 2018; Débarre 2008; Thomas 2015]. |
| G30 | Defocus measures aberrations and gives 3D | Bead through-focus images give the pupil (Hanser 2004, p. 35) and a focal series is the basis of sectioning (Agard 1984). Phase diversity (Paxman 1992 p. 1072): a known added aberration as a second measurement for extended incoherent objects; no experiments, space-invariant model, not microscopy. Engineered PSFs encode depth of sparse emitters through a calibration curve (Kao 1994; Huang 2008; Pavani 2009). Depth from defocus and shape from focus are computer-vision fallbacks (Subbarao 1994; Nayar 1994, which needs a z-scan). Tao 2013 gets defocus and correspondence from one light-field capture (macro scenes). | Cite Hanser and Agard for fluorescence; Kao and Verkman for sparse single-emitter depth encoding; Tao 2013 for the light-field defocus-plus-correspondence analogue. Paxman 1992 was dropped by the author (2026-11-11), so phase diversity is not cited. |

**Relevance to the shift premise (G23):** Chung 2019 (p. 657) says severe
aberration changes the local PSF shape, not only its shift, so the shift model is
an approximation; Chung 2016 (p. 367) excludes tilts because they "merely produce
lateral shifts". Neither contradicts the thesis assumption (own modelling
assumption, author decision of 2026-11-10), but state the approximation.

**Author decisions settled (2026-11-11):** Dong 2014, Chung 2016, Gustafsson 2008 and Thomas 2015 added; Ayuk 2013 not added; Paxman 1992 dropped; Tao 2013 added alongside Hanser 2004, Agard 1984 and Kao and Verkman 1994. G28-G30 now have their source sets; the remaining step is the author's wording.
