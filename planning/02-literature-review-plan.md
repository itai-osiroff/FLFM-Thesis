# Chapter 2 writing plan: Literature Review

> **Status:** draft — rebuild plan awaiting author decisions
>
> **Reviewed:** 2026-11-11
>
> **Target:** [02_literature_review.tex](../overleaf/main/02_literature_review.tex)
>
> **Budget:** about 2 pages of prose and equations ([authoritative structure](revised-thesis-structure.md)). No departure recorded.

## 1. Why a rebuild

The current chapter (two sections, about 0.6 rendered pages) is an early,
partly migrated draft. It surveys fluorescence modalities and restates
LFM-versus-FLFM principles that Chapters 1 and 3 already cover. It does not
compare aberration-correction approaches, so it does not establish the gap. It
cites 7 of the 71 entries in `thesis.bib`. Treat it as source material only.

Specific problems to fix during the rebuild:

- **Overlap with Chapter 3.** The LFM/FLFM sampling and PSF paragraph duplicates
  the second and third paragraphs of Chapter 3. Chapter 3 owns the principle;
  Chapter 2 should only compare reconstruction approaches and their assumptions.
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

## 2. The question the chapter answers

**Which approaches already recover a sharp fluorescence image through optical
aberrations, what does each one require (extra hardware, extra captures, a known
or estimated PSF, coherent illumination, a single correction per field), and
where does single-shot digital correction from FLFM views fit?**

The chapter must end with the gap stated in the thesis's own terms: no
inspected source corrects spatially varying aberrations of a 2D fluorescent
scene from a single FLFM capture by registering the views, without a wavefront
sensor, a corrector, scanning or deconvolution. Keep the word "first" out unless
the author decides otherwise; the claim is a positioning, not a priority claim.

The shift premise (aberrations appear, to first order, as view shifts) is the
thesis's own modelling assumption (author decision, 2026-11-10). Chapter 2 cites
sources that use the same physical principle in hardware; it never attributes
the thesis assumption to them.

## 3. Organization and space

Organize by **what each family needs**, not chronologically. That makes every
paragraph a step toward the gap. Five short sections plus an opening and a
closing paragraph:

| Part | Content | Prose (pages) |
| --- | --- | --- |
| Opening | Chapter question; four requirement axes used throughout | 0.1 |
| 2.1 Light-field reconstruction | What LFM/FLFM reconstruction assumes about the PSF and aberrations | 0.45 |
| 2.2 Hardware adaptive optics | Direct and indirect sensing, correctors, isoplanatic patch | 0.4 |
| 2.3 PSF-based computational correction | Deconvolution with a measured, modelled or blind PSF | 0.3 |
| 2.4 Methods that add acquisitions | Fourier ptychography, structured illumination, through-focus and engineered PSFs | 0.35 |
| 2.5 Digital correction from angular data | Closest prior work and the shift principle | 0.3 |
| Closing | The gap, and what Chapters 3–5 take from here | 0.1 |
| **Total** | | **about 2.0** |

The split is a drafting guide, not a set of quotas. If one section runs long,
take the space from 2.4 first (it is the most remote family), then 2.3.

**Optional comparison table (author decision).** One table, method family ×
{extra hardware, captures per correction, PSF required, coherent light,
spatially varying correction}. Tables sit outside the prose count, and this one
would let 2.2–2.4 drop repeated "requires…" sentences. It is a new visual, so it
needs the author's agreement before drafting.

## 4. Section plans with references

Keys are `thesis.bib` keys. **Core** = cite; **optional** = cite if space allows.
The wording limits come from the [gap audit](bibliography-gap-audit.md) and the
reading notes; follow them exactly.

### Opening (0.1 p)

One paragraph: state the chapter question and name the requirement axes. No
citations needed. Drop the current fluorescence-modality survey (widefield,
confocal, two-photon, light-sheet). It does not bear on the gap, and Chapter 1
covers the fluorescence motivation. If the author wants to keep one sentence on
depth-versus-speed trade-offs, `helmchen2005deepTissueTwoPhoton` supports the
two-photon part only.

### 2.1 Light-field reconstruction and its assumptions (0.45 p, 2 paragraphs)

Point: the LFM literature reconstructs 3D volumes by inverting a known or
modelled PSF. It treats the optics as aberration-free or calibrated, so
uncorrected aberrations break the model.

- P1, LFM and its inverse problem. Snapshot spatio-angular capture
  (`levoy2006lightFieldMicroscopy`, `levoy2009recordingControlling4d`);
  biological motivation (`prevedel2014wholeAnimalLfm`); wave-optics model and 3D
  deconvolution, with its no-scattering assumption (`broxton2013waveOpticsLfm`);
  native-plane artifacts and their fixes (`stefanoiu2019artifactFreeDeconvolution`,
  `lu2019phaseSpaceDeconvolution`). Lu 2019 p. 18131: high-precision LFM models
  are not robust to aberrations and background. This is the key sentence for the
  gap. Learned reconstruction (`wang2021vcdLfm`) and scattering-aware modelling
  (`zhang2021computationalOpticalSectioning`) are core, one clause each; both
  still rely on a forward model or training data.
- P2, pupil-plane designs. Pupil-conjugate lenslets (`cong2017xlfmZebrafish`, do
  not call it FLFM); FLFM (`guo2019fourierLightField`) and its high-resolution
  extension (`hua2021highResolutionFourierLightField`). Point to Chapter 3 for the
  principle in one clause. Optional: dual-view LFM with registration
  (`wagner2019isoLfm`).
- Not here: `galdon2022fourierLightfieldDesignGuide`, `yun2023flfmSetupGuide`
  (Chapters 3–4).

### 2.2 Hardware adaptive optics (0.4 p, 2 paragraphs)

Point: AO corrects physically and very well, but needs a sensor or many
trial images plus a corrector. One correction holds only in an isoplanatic patch.

- P1, sensing and correction. Aberration sources in one sentence, pointing to
  Chapter 3 (`booth2007adaptiveOpticsMicroscopy`, `hampson2021adaptiveOpticsPrimer`).
  Direct sensing: Shack-Hartmann principle (`platt2001shackHartmannHistory`),
  which needs a guide star in tissue (`wang2015directWavefrontSensing`; optional
  `azucena2010microsphereReferenceBeacons`). Indirect, image-based AO
  (`debarre2009imageBasedAdaptiveOptics`); widefield fluorescence AO
  (`kner2010wideFieldAdaptiveOptics`). Required wording (G26): sensing is direct
  *or* indirect, and indirect dominates microscopy (Booth 2007 pp. 2834–2835).
- P2, spatial variation. Isoplanatic patch from hundreds to a few micrometres
  (`hampson2021adaptiveOpticsPrimer`); tiled corrections
  (`liu2018nativeStateAdaptiveOptics`); 3.7 and 8.6 percent of a widefield field
  well corrected after one correction (`furieri2022aberrationLargeField`).
  Required wording (G27): no "expensive". Write "adds cost and complexity" for
  multiconjugate AO only (Hampson), and never "usually spatially invariant" as a
  universal.
- Reviews `booth2014adaptiveOpticalMicroscopy`, `ji2017adaptiveOpticalFluorescence`,
  `zhang2023adaptiveOpticsMicroscopy`: optional; their locators were not
  re-checked (G24). Cite only after checking, or rely on Booth 2007 and Hampson.
- Hold the pupil-segmentation sources (`ji2010adaptiveOpticsPupilSegmentation`,
  `scrimgeour2012segmentedPupilInterferometry`) for 2.5, where they carry the
  shift principle.

### 2.3 PSF-based computational correction (0.3 p, 1 paragraph)

Point: deconvolution needs a PSF. A wrong PSF produces artifacts, direct
inversion amplifies noise, and iterative or blind methods are computationally
heavy. Most methods assume a shift-invariant PSF.

- Foundations and reviews: `agard1984opticalSectioning`,
  `mcnally1999deconvolutionMicroscopy3d`, `sarder2006deconvolutionMethods`,
  `sibarita2005deconvolutionMicroscopy`, `wallace2001deconvolutionGuide`.
- Where the PSF comes from: model (`gibson1991aberrationModel`, optional here
  if Chapter 3 uses it), bead through-focus phase retrieval
  (`hanser2004phaseRetrievedPupil`), refractive-index prediction with
  space-variant deconvolution (`kam2001computationalAdaptiveOptics`, "intractable"
  in full 3D, beads only), blind estimation (`kenig2010blindDeconvolutionLearning`).
- Limits: noise in Richardson-Lucy (`dey2006richardsonLucyTv`); depth-variant
  PSFs in thick specimens (`preza2004depthVariantRestoration`).
- Required wording (G25): name the class ("estimate or assume a PSF and
  deconvolve"). "Slow" applies only to iterative and blind methods; "costly"
  means computation, not money. Maximum-likelihood methods are described as
  noise-robust, so do not claim all software methods amplify noise.

### 2.4 Methods that add acquisitions or coherence (0.35 p, 1–2 paragraphs)

Point: these recover the pupil or extend resolution, but need many captures,
coherent light or a pattern that aberrations themselves distort.

- Fourier ptychography: founding paper (`zheng2013fourierPtychographicMicroscopy`,
  not a fluorescence technique, p. 744); joint pupil recovery per tile
  (`ou2014embeddedPupilRecovery`); coherence and overlap needs
  (`maiden2009extendedPie`); reviews (`konda2020fourierPtychographyReview`,
  `zheng2021fourierPtychographyReview`). Fluorescence routes:
  `dong2014patternIlluminatedFluorescence`, `chung2016fpmFluorescenceDeconvolution`,
  `chung2019cacaoFb`. Required wording (G28): the original method does not apply
  to incoherent emission and variants add acquisitions. Do not write "cannot be
  used for fluorescence" or "hundreds of images" (range 4–137).
- Structured illumination: `neil1997structuredLightSectioning`,
  `gustafsson2000lateralSim`, `gustafsson2008threeDimSim`, `wuShroff2018simPerspective`;
  aberration sensitivity and AO with one correction per field
  (`debarre2008adaptiveOpticsSim`, `thomas2015simAdaptiveOpticsThickTissue`).
- Engineered PSFs: `kaoVerkman1994astigmaticTracking` (sparse emitters only),
  one clause at most.

### 2.5 Digital correction from angular data (0.3 p, 1 paragraph)

Point: the closest work. Light-field data have been used to correct aberration
digitally, and pupil-segment image shifts are an established reading of local
wavefront tilt. Existing methods are either camera-scale, scanning and 3D, or
hardware.

- Ray-space rectification in a light-field camera (`ngHanrahan2006digitalCorrection`);
  limited correction precedent in a light-field microscope
  (`levoy2009recordingControlling4d`).
- Digital AO from view disparities in a scanning light-field microscope
  (`wu2021digitalAdaptiveOpticsDaoslimit`). The nearest neighbour: describe it as
  scanning, 3D, iterative and tiled. Do not describe it as 2D or single-shot.
- Shift as local tilt in hardware: `ji2010adaptiveOpticsPupilSegmentation`,
  `scrimgeour2012segmentedPupilInterferometry` (widefield fluorescence, system
  aberration, one static correction); zonal sensorless AO from image shifts
  (Hampson PDF p. 11).
- State the approximation: severe aberration changes PSF shape, not only shift
  (`chung2019cacaoFb`, p. 657).
- Optional analogy, one clause: multiview registration and fusion in light-sheet
  microscopy (`swoger2007multiviewFusion`, `preibisch2010beadRegistration`,
  `preibisch2014bayesianMultiview`).

### Closing (0.1 p)

State the gap (Section 2 above) against the requirement axes, then say what each
later chapter takes up: Chapter 3, why views shift under aberration; Chapter 5,
how they are registered.

## 5. Bibliography entries that belong elsewhere

Do not spend Chapter 2 space on these; they serve other chapters.

| Keys | Home |
| --- | --- |
| `goodman2015statisticalOptics`, `jacques2013opticalPropertiesTissues`, `galdon2022fourierLightfieldDesignGuide`, `yun2023flfmSetupGuide` | Chapter 3 (and 4 for the design guides) |
| `levoyHanrahan1996lightFieldRendering`, `zitova2003imageRegistrationSurvey`, `bergen1992hierarchicalMotionEstimation`, `horn1981determiningOpticalFlow`, `guizarsicairos2008efficientSubpixelRegistration`, `scharstein2002denseStereoTaxonomy`, `szeliski2022computerVision`, `shum1998construction` | Chapter 5 and Appendix A (registration) |
| `jeon2015lensletDepthEstimation`, `tao2013defocusCorrespondence` | Chapter 5 by default (view disparity is depth there, not aberration); one optional clause in 2.5 if the author wants the light-field-vision link |
| `helmchen2005deepTissueTwoPhoton` | Optional (see Opening) |

`shum1998construction` has no reading note yet; write one before it is cited
anywhere.

## 6. Author decisions needed before drafting

1. Drop the fluorescence-modality survey (recommended) or keep one sentence.
2. Use subsection headings 2.1–2.5 (recommended for a review) or plain
   paragraphs, as decided for Chapter 3.
3. Add the comparison table (outside the prose count) or not.
4. Check Booth 2014, Ji 2017 and Zhang 2023 locators, or cite only Booth 2007
   and Hampson 2021 for the AO overview.
5. Move the aberration-correction detail from Chapter 1 paragraph 4 into
   Chapter 2 and reduce Chapter 1 to a pointer.

## 7. Drafting order and checks

1. Write the closing gap paragraph first, so each section is selected to lead to it.
2. Draft 2.5 and 2.2 (closest and strongest comparisons), then 2.1, 2.3, 2.4.
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
