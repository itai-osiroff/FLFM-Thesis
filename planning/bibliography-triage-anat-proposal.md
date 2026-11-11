# Bibliography Triage: `proposal.bib` and `biblio_anat.bib`

> **Status:** draft
>
> **Reviewed:** 2026-11-11

Soft, title-only triage of two external `.bib` files against
`overleaf/back/thesis.bib` (65 entries) and
[bibliography-candidates.md](bibliography-candidates.md). **No paper was opened,
no metadata was checked, and nothing was added to `thesis.bib` or to the
candidates list.** Judgements are based on titles and on what I know of the
papers; treat "drop" as "not looked at", not as "irrelevant".

## What the two files are

| File | Entries | What it is | Verdict |
| --- | --- | --- | --- |
| `proposal.bib` | 341 | A rendering / light-transport / scattering / non-line-of-sight / time-of-flight reference list (Monte Carlo rendering, BRDFs, translucency, transient imaging, deep inverse graphics). | Almost entirely off-topic. 1 duplicate, about 4 marginal hits. |
| `biblio_anat.bib` | 1,186 | A broad, long-accumulated group bibliography: computer vision (optical flow, stereo, motion perception, denoising, graphical models), computational photography, holographic displays, scattering media / memory effect, diffuse optics, plus a recent adaptive-optics and wavefront-shaping block. | Roughly 90 percent of the entries are off-topic. The adaptive-optics, memory-effect and a few light-field items are worth a look. |

Entries with no title (web links, software) were skipped. Duplicate keys for the
same paper are shown together in one row.

## How the cross-reference was done

1. Exact match of DOI and normalised title against `thesis.bib` and against every
   DOI and italic title in `bibliography-candidates.md` (automatic).
2. Keyword filter on titles (microscopy, fluorescence, aberration, adaptive
   optics, wavefront, light field, plenoptic, PSF, deconvolution, ptychography,
   scattering / memory effect, registration, optical flow, defocus, and so on),
   then reading each hit by hand (my judgement).
3. Hand correction of two false matches (listed in the tables below).

Limits: the DOI field is present for only 15 entries in `proposal.bib` and 126 in
`biblio_anat.bib`, so most matching was by title. A paper listed under a very
different title would be missed (for example a short form or a translation).

## 1. Already in `thesis.bib`: discard as duplicates

| Src | Key | Year | Title | Why it might matter / caveat |
| --- | --- | --- | --- | --- |
| anat | `Ji2010` | 2010 | Adaptive optics via pupil segmentation for high-resolution imaging in biological tissues | In `thesis.bib` (`ji2010adaptiveOpticsPupilSegmentation`). |
| anat | `Ji2017review` | 2017 | Adaptive optical fluorescence microscopy | In `thesis.bib` (`ji2017adaptiveOpticalFluorescence`). |
| anat | `Booth2014` | 2014 | Adaptive optical microscopy: The ongoing quest for a perfect image | In `thesis.bib` (`booth2014adaptiveOpticalMicroscopy`). |
| anat | `HampsonBooth21review` | 2021 | Adaptive optics for high-resolution imaging | In `thesis.bib` (`hampson2021adaptiveOpticsPrimer`). |
| anat | `Zheng2013` | 2016 | Wide-field, high-resolution Fourier ptychographic microscopy. | In `thesis.bib` (`zheng2013fourierPtychographicMicroscopy`). |
| anat | `Horn-Schunck81` | 1981 | Determining Optical Flow | In `thesis.bib` (`horn1981determiningOpticalFlow`). |
| anat | `ScharsteinSzeliski02` | 2002 | A Taxonomy and Evaluation of Dense Two-Frame Stereo Correspondence Algorithms | In `thesis.bib` (`scharstein2002denseStereoTaxonomy`). |
| anat | `Levoy:1996:LFR` | 1996 | Light Field Rendering | In `thesis.bib` (`levoyHanrahan1996lightFieldRendering`). |
| anat | `Bergen-Anandan-etal92` | 1992 | Hierarchial Model-Based Motion Estimation | In `thesis.bib` (`bergen1992hierarchicalMotionEstimation`); title misspelled in this source. |
| anat | `GoodmanStat` | 2000 | Statistical Optics | In `thesis.bib` (`goodman2015statisticalOptics`). |
| prop | `GoodmanStat` | 2000 | Statistical Optics | Same book; in `thesis.bib`. |

Also already in `thesis.bib`: `Liu2018` (Liu et al. 2018, `liu2018nativeStateAdaptiveOptics`),
matched automatically.

## 2. Already on the candidates list: nothing new to decide

These match a candidate that was read and not added, or that the list marks as
optional or not located. Nothing to do unless you want them promoted.

| Src | Key | Year | Title | Why it might matter / caveat |
| --- | --- | --- | --- | --- |
| anat | `Rueckel06` | 2006 | Adaptive wavefront correction in two-photon microscopy using coherence-gated wavefront sensing | C4a: read 2026-11-11, **not added** (optional AO paper that Hampson and Booth 2007 already cover). Reserve. |
| anat | `Fienup:82` | 1982 | Phase retrieval algorithms: a comparison | C4e: Fienup 1982, read, **reserve**. |
| anat | `Pentland:1987:DOF` | 1987 | A new sense for depth of field | C4e: Pentland 1987, read, **reserve**. |
| anat | `LevinDeconv09`, `DeconvTechReport` | 2009 | Understanding and evaluating blind deconvolution algorithms | C4b: Levin 2009, read, **reserve** (outside microscopy; two keys are the paper and its tech report). |
| anat | `wavefrontcoding95b` | 1995 | Extended Depth of Field Through Wavefront Coding | C4e: Dowski and Cathey 1995, read, **reserve**. |
| anat | `Lucy74`, `Richardson72` | 1974 | Bayesian-based iterative method of image restoration | C4b: Richardson 1972 (read, not added) and Lucy 1974 (no PDF). Both keys carry Richardson title in this source, so the `Lucy74` entry is mis-titled; the Lucy paper is *An iterative technique for the rectification of observed distributions*. |
| anat | `Lucas-Kanade81` | 1981 | An Iterative Image Registration Technique with an Application to Stereo Vision | Lucas and Kanade 1981: C3 says "not found in Crossref", optional. **A bib entry now exists here.** |
| anat | `Ng2005` | 2005 | Light Field Photography with a Hand-Held Plenoptic Camera | Ng et al. 2005: C3 says "not found in Crossref", optional. **A bib entry now exists here.** |
| anat | `GerchbergSaxton` | 1972 | A practical algorithm for the determination of the phase from image and diffraction plane pictures | Gerchberg and Saxton 1972: listed under "Not found by Crossref". **A bib entry now exists here** (two keys). |

## 3. New, probably worth a closer look (soft keep)

Ordered by the thesis gap each one might serve. None is verified.

| Src | Key | Year | Title | Why it might matter / caveat |
| --- | --- | --- | --- | --- |
| anat | `Commere:24` | 2024 | Experimental characterization of an isoplanatic patch in mouse cortex using adaptive optics | Measured isoplanatic patch in vivo (G27, spatial variation of aberration). Top candidate. |
| anat | `Fried:82` | 1982 | Anisoplanatism in adaptive optics | Classic source behind "isoplanatic patch". |
| anat | `Mertz:15` | 2015 | Field of view advantage of conjugate adaptive optics in microscopy applications | Field-of-view limit of pupil-plane AO versus conjugate AO. |
| anat | `Li:15` | 2015 | Conjugate adaptive optics in widefield microscopy with an extended-source wavefront sensor | Widefield AO; field dependence. |
| anat | `Park2017` | 2017 | Large-field-of-view imaging by Multi-Pupil Adaptive Optics | Multi-pupil AO over a large field; close to the per-view idea of FLFM. |
| anat | `kang2023coordinatebased` | 2023 | Coordinate-based neural representations for computational adaptive optics in widefield microscopy | Computational AO in widefield microscopy; nearest to our software-only correction. Check whether it is learned (ours is not). |
| anat | `Wang20142PAdaptive` | 2014 | Multiplexed aberration measurement for deep tissue imaging in vivo | Ji group; in vivo aberration measurement; pairs with Wang 2015. |
| anat | `Booth2002` | 2002 | Adaptive aberration correction in a confocal microscope | Early AO in confocal; optional next to Booth 2007. |
| anat | `Antonello:20` | 2020 | Multi-scale sensorless adaptive optics: application to stimulated emission depletion microscopy | Sensorless AO (STED); optional next to Debarre 2009. |
| anat | `PanJi2023` | 2023 | Frequency-multiplexed aberration measurement and correction for confocal microscopy (Conference Presentation) | Ji group, confocal; optional. |
| anat | `MUGNIER20061` | 2006 | Phase Diversity: A Technique for Wave-Front Sensing and for Diffraction-Limited Imaging | Phase-diversity review; could serve C4e instead of the astronomy-only Paxman 1992 (an open author decision). |
| anat | `Shack71` | 1971 | Production and use of a lecticular Hartmann screen | Primary Shack-Hartmann source (1971); complements Platt and Shack 2001 (G22). |
| anat | `SEIFERT` | 2005 | Wavefront reconstruction with the adaptive Shack?Hartmann sensor | Shack-Hartmann reconstruction; background. |
| anat | `WISH2019` | 2019 | WISH: Wavefront imaging sensor with high resolution | Different wavefront-sensing principle; background. |
| anat | `Abrahamsson06` | 2006 | A new approach to extended focus for high-speed, high-resolution biological microscopy | Fluorescence microscopy, PSF engineering; fits C4e. |
| anat | `ZhangLevoyICCP09` | 2009 | Wigner distributions and how they relate to the light field | Phase-space description of the light field (Levoy group); Chapter 3 if the model is phase-space based. |
| anat | `mertz2019introduction`, `MertzBook` | 2019 | Introduction to optical microscopy | Mertz textbook (keys for two editions). General reference for Chapter 3. |
| anat | `Goodman` | 1968 | Introduction to Fourier Optics | Goodman textbook; pupil and Fourier-plane arguments in Chapter 3. |
| prop | `Goodman` | 1968 | Introduction to Fourier Optics | Same book as the anat entry. |
| anat | `ShumSzeliski98` | 1998 | Construction and refinement of panoramic mosaics with global and local alignment | Global then local alignment is our reconstruction order (C3, G4); the strongest registration find. |
| anat | `PlenopticSampling` | 2000 | Plenoptic Sampling | Light-field sampling theory; background for Chapters 2 and 3. |
| anat | `Ng:2005:FSP` | 2005 | Fourier slice photography | Fourier-domain view of light-field refocusing; Chapter 3 background. |
| anat | `Adelson:1992:Plenoptic` | 1992 | Single Lens Stereo with a Plenoptic Camera | Plenoptic camera origin; background. |
| prop | `adelson1992single` | 1992 | Single lens stereo with a plenoptic camera | Same paper as the anat entry. |
| anat | `Tian:15` | 2015 | Computational illumination for high-speed in vitro Fourier ptychographic microscopy | FPM follow-up (Tian 2015). **Not** the Tian and Waller 2015 light-field paper in C4c; check which was wanted. |

Strongest finds, in my opinion: the isoplanatic-patch measurement (Commere 2024)
and Fried 1982 for G27; the computational widefield AO paper (Kang 2023) as the
closest neighbour to a software-only correction; Shum and Szeliski 1998 for the
global-then-local order; the Shack 1971 original for G22.

## 4. New, maybe (soft reserve)

Plausibly useful as background or fallbacks, mostly for the Chapter 3 scattering
and aberration section or for the "O" (outside microscopy) fallbacks in C4e. Do
not read them yet.

| Src | Key | Year | Title | Why it might matter / caveat |
| --- | --- | --- | --- | --- |
| anat | `RevModPhys.89.015005` | 2017 | Light fields in complex media: Mesoscopic scattering meets wave control | Wave control in scattering media; Chapter 3 scattering section. |
| anat | `Gigan22` | 2021 | Roadmap on Wavefront Shaping and deep imaging in complex media | Scattering context. |
| anat | `YU2015632` | 2015 | Recent advances in wavefront shaping techniques for biomedical applications | Wavefront shaping review. |
| anat | `Mosk2012` | 2012 | Controlling waves in space and time for imaging and focusing in complex media | Wavefront shaping review. |
| anat | `Horstmeyer15` | 2015 | Guidestar-assisted wavefront-shaping methods for focusing light into biological tissue | Guide-star review; pairs with the Wang 2015 and Azucena 2010 points. |
| anat | `Vellekoop:10` | 2010 | Scattered light fluorescence microscopy: imaging through turbid layers | Fluorescence behind turbid layers. |
| anat | `Vellekoop2012` | 2012 | Digital optical phase conjugation of fluorescence in turbid tissue | Fluorescence; wavefront correction in tissue. |
| anat | `Dror22` | 2022 | Fluorescent wavefront shaping using incoherent iterative phase conjugation | Fluorescence; incoherent feedback. |
| anat | `Bertolotti2012` | 2012 | Non-invasive imaging through opaque scattering layers | Memory-effect imaging. |
| prop | `bertolotti2012non` | 2012 | Non-invasive imaging through opaque scattering layers | Same paper. |
| anat | `Katz2014` | 2014 | Non-invasive single-shot imaging through scattering layers and around corners via speckle correlation | Katz 2014, speckle correlation. |
| anat | `Schott:15` | 2015 | Characterization of the angular memory effect of scattered light in biological tissues | Memory-effect range in tissue; bears on field-of-view claims under scattering. |
| anat | `Judkewitz14` | 2014 | Translation correlations in anisotropically scattering media | Memory-effect theory. |
| anat | `osnabrugge2017generalized` | 2017 | Generalized optical memory effect | Memory-effect theory. |
| anat | `PhysRevLett.61.2328`, `Freund1988` | 1988 | Memory Effects in Propagation of Optical Waves through Disordered Media | Original memory-effect source (two keys). |
| anat | `Hofer:18` | 2018 | Wide field fluorescence epi-microscopy behind a scattering medium enabled by speckle correlations | Widefield fluorescence plus scattering; close to our setting. |
| anat | `Chang2018` | 2018 | Single-shot speckle correlation fluorescence microscopy in thick scattering tissue with image reconstruction priors | Fluorescence plus scattering. |
| anat | `Giuliano16`, `Edrei2016` | 2016 | Memory-effect based deconvolution microscopy for super-resolution imaging through scattering media | Deconvolution under the memory effect (two keys). |
| anat | `Gardner:19` | 2019 | Ptychographic imaging of incoherently illuminated extended objects using speckle correlations | Ptychography with incoherent light; C4c adjacent. |
| anat | `Li:B:2019:Ptycho` | 2019 | Imaging Correlography Using Ptychography | Ptychography plus scattering. |
| anat | `Hollowaye1602564` | 2017 | SAVI: Synthetic apertures for long-range, subdiffraction-limited visible imaging using Fourier ptychography | Fourier ptychography at long range; C4c adjacent. |
| anat | `Holloway2016` | 2016 | Toward Long Distance, Sub-diffraction Imaging Using Coherent Camera Arrays. | Same group as SAVI. |
| anat | `Cheong90` | 1990 | A review of the optical properties of biological tissues | Cheong 1990; the thesis already has Jacques 2013 for this role. |
| anat | `TysonAdaptiveOpticsBook`, `tyson2022principles` | 2015 | Principles Of Adaptive Optics | Tyson textbook (two keys); AO textbook candidate. |
| anat | `hardy1998adaptive` | 1998 | Adaptive optics for astronomical telescopes | Hardy textbook; AO textbook candidate. |
| anat | `Madec2012` | 2012 | Overview of deformable mirror technologies for adaptive optics and astronomy | Might bear on the corrector-complexity statement (G27); no source says it so far. |
| anat | `hardy1974real` | 1974 | Real time phase correction of optical imaging systems | Early AO; historical. |
| anat | `confocal` | 2006 | Confocal microscopy and multiphoton excitation microscopy: the genesis of live cell imaging | Microscopy background. |
| anat | `Xu2024` | 2024 | Multiphoton fluorescence microscopy for in vivo imaging | Microscopy background. |
| anat | `Webb1996` | 1996 | Confocal optical microscopy | Microscopy background. |
| anat | `papoulis74` | 1974 | Ambiguity function in Fourier optics | Phase-space tool for Chapter 3; possibly unnecessary. |
| anat | `AdelsonPlenopticFunc91` | 1991 | The Plenoptic Function and the Elements of Early Vision | Background; graphics oriented. |
| anat | `Todor2.0` | 2009 | The Focused Plenoptic Camera | Plenoptic 2.0; background. |
| anat | `lightfieldsTR`, `lightfields` | 2008 | Understanding camera trade-offs through a Bayesian analysis of light field projections | Levin et al.; background (two keys). |
| anat | `Bishop09Light` | 2009 | Light Field Superresolution | Background. |
| anat | `Levoy05` | 2005 | High Performance Imaging Using Large Camera Arrays | Camera-array light field; background. |
| anat | `Kundur96` | 1996 | Blind image deconvolution | Kundur and Hatzinakos 1996. **Not** the Kenig 2010 paper in the thesis bib (an earlier automatic title match was wrong). |
| anat | `LevinEtAl07` | 2007 | Image and Depth from a Conventional Camera with a Coded Aperture | PSF engineering for depth; photography, fallback (O). |
| anat | `Chaudhuri99` | 1999 | Depth from defocus: A real aperture imaging approach | C4e fallback (computer vision). |
| anat | `Favaro03` | 2003 | Observing Shape from Defocused Images | C4e fallback. |
| anat | `Grossmann:87` | 1987 | Depth from Focus | C4e fallback. |
| anat | `Darrell88` | 1988 | Pyramid based depth from focus | C4e fallback. |
| anat | `SchechnerIJCV` | 2000 | Depth from defocus vs. stereo: How different really are they | Defocus versus correspondence; C4e fallback. |
| anat | `BarronFleet94` | 1994 | Performance of optical flow techniques | C3 background. |
| anat | `OtteNagel94` | 1994 | Optical Flow Estimation: advances and comparisons | C3 background. |
| anat | `WeberMalik95` | 1995 | Robust computation of optical flow in a multi-scale differential framework | C3 background. |
| anat | `Quam84` | 1984 | Hierarchial Warp Stereo | Coarse-to-fine; optional beside Bergen 1992. |
| anat | `Joshi08` | 2008 | PSF Estimation using Sharp Edge Prediction | Photography; fallback (O). |
| anat | `Bardsley06` | 2006 | Blind iterative restoration of images with spatially-varying blur | Space-variant blur; could serve G25 beside Preza 2004. |
| anat | `GoodmanSpeckle` | 2007 | Speckle Phenomena in Optics: Theory and Applications | Goodman speckle book. |
| anat | `Verstraete:17` | 2017 | Wavefront sensorless adaptive optics OCT with the DONE algorithm for in vivo human retinal imaging | Sensorless AO in OCT (not fluorescence); tag M. |
| anat | `Verstraete:15` | 2015 | Model-based sensor-less wavefront aberration correction in optical coherence tomography | Sensorless AO in OCT; tag M. |
| anat | `Bonora:13` | 2013 | Wavefront sensorless modal deformable mirror correction in adaptive optics: optical coherence tomography | Sensorless modal AO in OCT; tag M. |
| anat | `Liu:18` | 2018 | Aberration-diverse optical coherence tomography for suppression of multiple scattering and speckle | Computational aberration handling in OCT; tag M. |
| anat | `Burns2019` | 2019 | Adaptive optics imaging of the human retina. | Retinal AO review. |
| prop | `cossairt2014` | 2014 | Digital refocusing with incoherent holography | Incoherent holography, a light-field-adjacent 3D method; the one close hit in `proposal.bib`. |

## 5. Soft drop: off-topic by title

Not listed individually. Rough groups (counts are approximate, from the keyword
pass):

- **`proposal.bib`, about 335 entries:** physically based and differentiable
  rendering, light transport and inverse rendering, BRDF and appearance
  acquisition, translucency perception, non-line-of-sight and transient
  (time-of-flight) imaging, diffuse and tissue optics for rendering, deep
  generative models for graphics, 3D printing, optimisers and ML libraries.
  The scattering-microphysics entries are not relevant to our thesis (we do not
  model scattering; Chapter 3 only needs a short physical statement).
- **`biblio_anat.bib`, about 1,080 entries:** human motion perception and
  stereokinesis, graphical models and belief propagation, Bayesian image
  priors and natural-image statistics, denoising, motion deblurring,
  super-resolution, holographic and near-eye displays, computer-generated
  holography, photon-mapping and radiative-transfer rendering, light-field
  *rendering* and image-based modelling in graphics (morphing, compression,
  face recognition), diffuse optical tomography, laser speckle flowmetry,
  OCT clinical reviews, time-of-flight and structured-light range sensing,
  photometric stereo, neuroscience and medical imaging outside optics, optimisers
  and generic ML.

Borderline items I dropped on title alone, in case you disagree: Lucas-Kanade
style motion estimation beyond the entries above, `Stockham75` and
`miskin00ensemble` (blind deconvolution, signal-processing era), several
phase-retrieval papers (Candes 2013, PhasePack, vectorial phase retrieval),
computational holography, and the OCT clinical reviews.

## Suggested next step

Before anything is read: decide whether Section 3 (25 rows) should become a new
candidate group (for example C5, "isoplanatic patch and field-dependent AO", plus
extra Chapter 3 background), and whether the two false-match corrections should
be recorded in the candidates list (Kundur 1996 is a new candidate, not Kenig
2010). The two `.bib` files themselves do not need to enter the repo.
