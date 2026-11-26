# Chapter 2 writing plan: Literature Review

> **Status:** draft — section plan updated, awaiting author and supervisor review
>
> **Reviewed:** 2026-11-26 (Ng and Hanrahan venue marked resolved; section plan and status table added for the 2026-11-29 meeting; chapter numbers current); 2026-11-12
>
> **Target:** [02_literature_review.tex](../overleaf/main/02_literature_review.tex)
>
> **Budget:** about 2.3 pages of prose and equations ([authoritative structure](revised-thesis-structure.md); 2 pages until the 2026-11-26 departure).
>
> **Numbering:** Sections 1–7 below were written on 2026-11-12 for the seven-chapter structure. Their "Chapter 5" is now Chapter 4 (reconstruction), and their "Chapter 3 owns the principle" still holds. The section plan directly below is current.

## Section plan (2026-11-26)

Yardstick: about 450 words a page, so the 2-page budget is about 900 words.

| Section | Content | Cap (words) | State |
| --- | --- | --- | --- |
| Opening | The chapter question; the five requirement axes (known or estimated PSF, added hardware, added captures, coherent light, one correction per field); the order of the sections | 75 | Drafted (77) |
| 2.1 PSF-based computational correction | Deconvolution needs a PSF; the routes (model, measurement, blind) and their limits; artifacts from a wrong PSF; noise and computation; a spatially varying aberration needs a PSF per region (Kam) | 250 (raised from 135, author, 2026-11-26) | Drafted; trimmed from 300 to 257 (2026-11-26) |
| 2.2 Hardware adaptive optics | P1 sensing (direct with a guide star, or indirect from trial images) and a corrector; P2 one correction holds over an isoplanatic patch, so a large field needs tiled corrections (Furieri) | 180 | Not written |
| 2.3 Methods that add acquisitions | Fourier ptychography (coherent, several captures; fluorescence variants add acquisitions) and structured illumination (patterned exposures that aberrations distort) | 135 | Not written; kept (author, 2026-11-26); the supervisor decides whether it stays |
| 2.4 Light-field data and aberrations | P1 what LFM/FLFM reconstruction assumes (calibrated, aberration-free PSF; Lu, Broxton, Guo); P2 correction from angular data: digital AO in scanning LFM (Wu 2021, 3D, iterative), Ng and Hanrahan, pupil segmentation (Ji 2010), zonal sensorless AO from image shifts (Hampson), and the limit of a pure shift (Chung 2019) | 315 | A 176-word LFM paragraph exists as section 2 (out of order, older style, no aberration content); rewrite |
| Closing | The gap against the axes: no single-capture, post-processing correction of a spatially varying aberration in a 2D fluorescent scene from FLFM views; Chapter 3 explains the microscope, Chapter 4 the shifts and their removal | 90 | Not written |
| **Total** | | **about 1,045** | 510 drafted; about 535 still to write |

**Budget (2026-11-26).** With 2.1 at 250 and 2.3 kept, the section caps
total about 1,045 words. The author approved Chapter 2 at about 2.3 pages,
taken from the slack ([departure table](revised-thesis-structure.md), 2026-11-26).

### Decisions

1. **2.1 overrun.** Resolved 2026-11-26 (author): 2.1 cap raised to 250 words
   and the section trimmed to that; 2.3 is not dropped, and the supervisor
   decides on it. The chapter is about 2.3 pages (departure approved the same day).
2. **Overlap with Chapter 1.** Chapter 1, paragraph 3, already summarizes
   deconvolution and AO with the G25–G27 wording. Keep it and make 2.1–2.2 the
   detailed version, or reduce Chapter 1 to a pointer (Section 6, item 5).
3. **Comparison table** (method family against the five axes, outside the prose
   count). It would replace the repeated "requires…" sentences.
4. **Ng and Hanrahan venue** (Section 1): resolved, 2006 SPIE (Proc. SPIE 6342,
   63421E); 2.4 can cite `ngHanrahan2006digitalCorrection` as it stands.
5. Settled by the draft: the fluorescence-modality survey is gone, and the
   chapter uses numbered section headings.

## 1. Why a rebuild

The current chapter (two sections, about 0.6 rendered pages) is an early,
partly migrated draft. It surveys fluorescence modalities and restates
LFM-versus-FLFM principles that Chapters 1 and 3 already cover. It does not
compare aberration-correction approaches, so it does not establish the gap. It
cites 7 of the 71 entries in `thesis.bib`. Treat it as source material only.

Specific problems to fix during the rebuild:

- **Overlap with Chapter 3.** The LFM/FLFM sampling and PSF paragraph duplicates
  the second and third paragraphs of Chapter 3. Chapter 3 owns the principle;
  Chapter 2 mentions LFM only for what its reconstruction assumes about
  aberrations and for how light-field data have been used to correct them.
- **Overlap with Chapter 1.** Chapter 1 paragraph 4 already sketches software and
  hardware aberration correction, with wording the gap audit flags (G25–G27:
  "expensive" deformable mirrors, "usually only spatially invariant"). Chapter 2
  should own that comparison; Chapter 1 should shrink to one or two sentences
  that point here (Chapter 1 pass 2).
- **Possible citation misuse.** Swoger 2007 and Preibisch 2010 are cited for the
  claim that light-sheet geometry needs side access or rotation. Their notes
  support multiview registration and fusion, not that statement. Recheck or drop.
- **FLFM origin.** Cong 2017 placed lenslets in a pupil-conjugate plane before
  Guo 2019. Cite Guo for FLFM, but do not write that the idea originated there.
- **Ng and Hanrahan venue.** Resolved (checked 2026-11-10, recorded in the
  reading note): the paper is International Optical Design Conference 2006, Proc.
  SPIE 6342, 63421E, DOI `10.1117/12.692290`. The "2007" is only the local
  filename (`ng2007.pdf`). `thesis.bib` already has this entry; the Optica `WB2`
  record is a separate conference item and is not used.

## 2. The question the chapter answers

**Which approaches already recover a sharp fluorescence image through optical
aberrations, what does each one require (a known or estimated PSF, extra
hardware, extra captures, coherent illumination, one correction per field), and
where does single-shot digital correction from FLFM views fit?**

The chapter ends on the gap in the thesis's own terms: no inspected source
corrects spatially varying aberrations of a 2D fluorescent scene from a single
FLFM capture by registering the views, without a wavefront sensor, a corrector,
scanning or deconvolution. Keep the word "first" out unless the author decides
otherwise; the claim is a positioning, not a priority claim.

**Framing rules.**

- **Requirements, not failures.** The other families solve a wider problem (3D,
  deep tissue, high resolution). Write "requires X, which our setting avoids",
  never "falls short". Our method is 2D, first-order shift, and does not handle
  scattering; the review should be fair to that difference.
- **Progression, not chronology.** The order follows where the correction
  happens: after capture with a PSF, at the optics, with extra captures, from the
  light-field views. Dates interleave (Ng and Hanrahan 2006 is the same year as
  Levoy 2006; Cong 2017 precedes Guo 2019), so do not promise chronological order
  in the text.
- **Establish the gap; do not pre-argue the solution.** Chapters 3 and 5 deliver
  the answer.
- **The shift premise** (aberrations appear, to first order, as view shifts) is
  the thesis's own modelling assumption (author decision, 2026-11-10). Sources
  that use the same principle in hardware are cited as support for plausibility,
  never as its origin.

## 3. Organization and space

| Part | Content | Prose (pages) |
| --- | --- | --- |
| Opening | Chapter question; the requirement axes used throughout | 0.1 |
| 2.1 PSF-based computational correction | Deconvolution with a measured, modelled or blind PSF | 0.3 |
| 2.2 Hardware adaptive optics | Direct and indirect sensing, correctors, isoplanatic patch | 0.4 |
| 2.3 Methods that add acquisitions | Fourier ptychography, structured illumination | 0.3 |
| 2.4 Light-field imaging and aberrations | Paragraph 1: what LFM/FLFM reconstruction assumes. Paragraph 2: digital correction from angular data and the shift principle | 0.7 |
| Closing | The gap, and what Chapters 3–5 take from here | 0.2 |
| **Total** | | **about 2.0** |

The split is a drafting guide, not a set of quotas. If space gets tight, cut 2.3
first, then compress 2.1.

**Optional comparison table (author decision).** One table, method family ×
{extra hardware, captures per correction, PSF required, coherent light,
spatially varying correction}. Tables sit outside the prose count, and this one
would let 2.1–2.3 drop repeated "requires…" sentences. It is a new visual, so it
needs the author's agreement before drafting.

## 4. Section plans with references

Keys are `thesis.bib` keys. Each list is in descending order of importance for
that part. **Core** items should be cited; **optional** items only if space
allows. Wording limits come from the [gap audit](bibliography-gap-audit.md) and
the reading notes; follow them exactly.

### Opening (0.1 p)

One paragraph: state the chapter question and name the requirement axes. No
citations needed. Drop the current fluorescence-modality survey; Chapter 1
covers the motivation. If one sentence is kept, `helmchen2005deepTissueTwoPhoton`
supports the two-photon part only.

### 2.1 PSF-based computational correction (0.3 p, 1 paragraph)

Point: deconvolution needs a PSF. A wrong PSF produces artifacts, direct
inversion amplifies noise, and iterative or blind methods are computationally
heavy. Most methods assume a shift-invariant PSF.

Core, in order: `sibarita2005deconvolutionMicroscopy`,
`mcnally1999deconvolutionMicroscopy3d`, `sarder2006deconvolutionMethods`,
`kam2001computationalAdaptiveOptics`, `hanser2004phaseRetrievedPupil`,
`preza2004depthVariantRestoration`, `kenig2010blindDeconvolutionLearning`,
`dey2006richardsonLucyTv`. Optional: `wallace2001deconvolutionGuide`,
`agard1984opticalSectioning`, `gibson1991aberrationModel` (only if Chapter 3
does not use it).

Required wording (G25): name the class ("estimate or assume a PSF and
deconvolve"). "Slow" applies only to iterative and blind methods; "costly" means
computation, not money. Maximum-likelihood methods are described as noise-robust,
so do not claim all software methods amplify noise. Kam 2001 is computational AO
but predicts the aberration from a refractive-index map, is "intractable" in full
3D, and was shown on beads only.

### 2.2 Hardware adaptive optics (0.4 p, 2 paragraphs)

Point: AO corrects physically and very well, but needs a sensor or many trial
images plus a corrector, and one correction holds only inside an isoplanatic
patch.

- P1, sensing and correction. Direct versus indirect sensing; indirect dominates
  microscopy (Booth 2007, pp. 2834–2835); guide star needed for direct sensing in
  tissue.
- P2, spatial variation. Isoplanatic patch from hundreds to a few micrometres;
  tiled corrections; 3.7 and 8.6 percent of a widefield field well corrected
  after one correction (Furieri).

Core, in order: `hampson2021adaptiveOpticsPrimer`, `booth2007adaptiveOpticsMicroscopy`,
`wang2015directWavefrontSensing`, `debarre2009imageBasedAdaptiveOptics`,
`liu2018nativeStateAdaptiveOptics`, `furieri2022aberrationLargeField`,
`kner2010wideFieldAdaptiveOptics`, `platt2001shackHartmannHistory`. Optional:
`azucena2010microsphereReferenceBeacons`, `booth2014adaptiveOpticalMicroscopy`,
`ji2017adaptiveOpticalFluorescence`, `zhang2023adaptiveOpticsMicroscopy` (the
three reviews' locators were not re-checked, G24).

Required wording: sensing is direct *or* indirect (G26). No "expensive"; write
"adds cost and complexity" for multiconjugate AO only (Hampson). Never "usually
spatially invariant" as a universal (G27).

### 2.3 Methods that add acquisitions (0.3 p, 1 paragraph)

Point: these recover the pupil or extend resolution, but need many captures,
coherent light, or a pattern that aberrations themselves distort.

Core, in order: `zheng2013fourierPtychographicMicroscopy` (FP),
`ou2014embeddedPupilRecovery` (FP), `chung2016fpmFluorescenceDeconvolution` (FP),
`debarre2008adaptiveOpticsSim` (SIM), `gustafsson2000lateralSim` (SIM),
`chung2019cacaoFb` (FP, incoherent), `zheng2021fourierPtychographyReview` (FP),
`neil1997structuredLightSectioning` (SIM), `thomas2015simAdaptiveOpticsThickTissue`
(SIM). Optional: `konda2020fourierPtychographyReview`, `dong2014patternIlluminatedFluorescence`,
`maiden2009extendedPie`, `wuShroff2018simPerspective`, `gustafsson2008threeDimSim`,
`kaoVerkman1994astigmaticTracking` (sparse emitters only; one clause).

Required wording (G28, G29): the original FP method does not apply to incoherent
emission and variants add acquisitions; do not write "cannot be used for
fluorescence" or "hundreds of images" (range 4–137). SIM needs several patterned
exposures, and aberrations in the pattern or PSF degrade it.

### 2.4 Light-field imaging and aberrations (0.7 p, 2 paragraphs)

Point: LFM reconstruction assumes a calibrated, aberration-free PSF; the few
works that correct aberration from light-field data are camera-scale, scanning and
3D, or hardware. None is single-shot digital correction of a 2D scene from FLFM
views.

**Paragraph 1, what reconstruction assumes** (keep to the aberration-relevant
point; Chapter 3 owns the principle). Core, in order: `lu2019phaseSpaceDeconvolution`
(p. 18131: models not robust to aberrations and background), `guo2019fourierLightField`,
`broxton2013waveOpticsLfm` (no-scattering assumption), `levoy2009recordingControlling4d`,
`stefanoiu2019artifactFreeDeconvolution`, `cong2017xlfmZebrafish` (do not call it
FLFM), `levoy2006lightFieldMicroscopy`, `hua2021highResolutionFourierLightField`,
`prevedel2014wholeAnimalLfm`. One clause each: `zhang2021computationalOpticalSectioning`
(scattering-aware), `wang2021vcdLfm` (learned). Optional: `wagner2019isoLfm`.

**Paragraph 2, correction from angular data and the shift principle.** Core, in
order: `wu2021digitalAdaptiveOpticsDaoslimit` (nearest neighbour; scanning, 3D,
iterative, tiled; never "2D" or "single-shot"), `ngHanrahan2006digitalCorrection`,
`ji2010adaptiveOpticsPupilSegmentation`, `scrimgeour2012segmentedPupilInterferometry`
(widefield, system aberration, one static correction), `levoy2009recordingControlling4d`
(limited correction), `chung2019cacaoFb` (p. 657: severe aberration changes PSF
shape, not only shift; state the approximation), `hampson2021adaptiveOpticsPrimer`
(PDF p. 11: zonal sensorless AO from image shifts). Optional, one clause:
`swoger2007multiviewFusion`, `preibisch2010beadRegistration`,
`preibisch2014bayesianMultiview` (multiview registration analogy);
`tao2013defocusCorrespondence`, `jeon2015lensletDepthEstimation` (light-field
vision analogue; default home is Chapter 5).

### Closing (0.2 p)

State the gap (Section 2) against the requirement axes, then say what each later
chapter takes up: Chapter 3, why views shift under aberration; Chapter 5, how
they are registered. Back-references only: `wu2021digitalAdaptiveOpticsDaoslimit`,
`lu2019phaseSpaceDeconvolution`, `guo2019fourierLightField`.

## 5. Bibliography entries that belong elsewhere

| Keys | Home |
| --- | --- |
| `goodman2015statisticalOptics`, `jacques2013opticalPropertiesTissues`, `galdon2022fourierLightfieldDesignGuide`, `yun2023flfmSetupGuide` | Chapter 3 (and 4 for the design guides) |
| `levoyHanrahan1996lightFieldRendering`, `zitova2003imageRegistrationSurvey`, `bergen1992hierarchicalMotionEstimation`, `horn1981determiningOpticalFlow`, `guizarsicairos2008efficientSubpixelRegistration`, `scharstein2002denseStereoTaxonomy`, `szeliski2022computerVision`, `shum1998construction` | Chapter 5 and Appendix A (registration) |
| `jeon2015lensletDepthEstimation`, `tao2013defocusCorrespondence` | Chapter 5 by default; optional clause in 2.4 |
| `helmchen2005deepTissueTwoPhoton` | Optional (see Opening) |

`shum1998construction` has no reading note yet; write one before it is cited.

## 6. Author decisions needed before drafting

Settled (2026-11-12): section order is deconvolution, AO, added acquisitions,
then light field; LFM background merges into the final section.

Open:

1. Drop the fluorescence-modality survey (recommended) or keep one sentence.
2. Use subsection headings 2.1–2.4 (recommended for a review) or plain
   paragraphs, as decided for Chapter 3.
3. Add the comparison table (outside the prose count) or not.
4. Check Booth 2014, Ji 2017 and Zhang 2023 locators, or cite only Booth 2007
   and Hampson 2021 for the AO overview.
5. Move the aberration-correction detail from Chapter 1 paragraph 4 into
   Chapter 2 and reduce Chapter 1 to a pointer.

## 7. Drafting order and checks

1. Write the closing gap paragraph first, so each section is selected to lead to it.
2. Draft 2.4 and 2.2 (closest and strongest comparisons), then 2.1 and 2.3.
3. Write the opening last.
4. Before citing each claim, open the reading note and use its locator and
   "Safe wording". The gap audit G24–G30 rows give the required wording.
5. Apply the [prose and figure standard](prose-and-figure-standard.md) and the
   [writing standard](writing-standard.md) (open with the question, close with
   what is established).
6. Build with `latexmk thesis` and assess rendered prose pages. Record the
   estimate in the writing log; flag any overrun instead of trimming
   qualifications.
7. Update the [claim tracker](claim-tracker.md) rows for Chapter 2 once the
   claims are in the text.
