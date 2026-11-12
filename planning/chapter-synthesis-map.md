# Chapter Synthesis Map

> **Status:** active
>
> **Reviewed:** 2026-11-11

Use the [authoritative structure and budget](revised-thesis-structure.md) for
chapter titles, ownership, allowances, and departures. This map allocates writing
work and evidence, not additional space. Apply the writing, prose/figure, and
technical standards. Source-note labels below are retained from the existing
index; this structural update performs no new scientific verification.

## Source Note Index

| Source note | Source type | Primary thesis role | Reliability label |
| --- | --- | --- | --- |
| `literature/notes/levoy-2009-recording-controlling-4d-light-field.md` | Primary article | LFM background, 4D light-field geometry, spatial-angular tradeoff, limited aberration correction precedent. | Citable. |
| `literature/notes/fourier-light-field-microscopy-local-note.md` | Local secondary note | FLFM theory checklist and reading queue for primary papers. | Do not cite directly unless provenance is confirmed. |
| `literature/notes/guo-2019-fourier-light-field-microscopy.md` | Primary article | Core FLFM citation, Fourier-domain framing, system/model lineage. | Citable. |
| `literature/notes/hua-2021-high-resolution-flfm.md` | Primary article | Modern HR-FLFM application and volumetric live-cell context. | Citable; use for context, not local performance. |
| `literature/notes/galdon-yun-2022-2023-flfm-design-guides.md` | Primary articles | FLFM design/setup constraints, conjugation, NA matching, practical optical path. | Citable. |
| `literature/notes/broxton-2013-wave-optics-lfm-deconvolution.md` | Primary article | Wave-optics LFM model, inverse-problem framing, deconvolution contrast. | Citable; no-scattering assumption is important. |
| `literature/notes/stefanoiu-2019-artifact-free-lfm-deconvolution.md` | Primary article | LFM sampling artifacts and deconvolution limits. | Citable; comparison only. |
| `literature/notes/prevedel-2014-whole-animal-lfm.md` | Primary article | Biological motivation for high-speed volumetric LFM. | Citable; not result evidence for this thesis. |
| `literature/notes/zhang-2021-computational-optical-sectioning-lfm.md` | Primary article | Scattering-aware LFM comparison and degradation context. | Citable; not implemented here. |
| `literature/notes/jacques-2013-optical-properties-biological-tissues.md` | Review article | Tissue optical properties, scattering, anisotropy, reduced scattering, refractive index. | Citable. |
| `literature/notes/zhang-2023-adaptive-optics-optical-microscopy.md` | Review articles | Adaptive optics, sample-induced aberration, deep-tissue fluorescence context. | Citable; comparison only. |
| `literature/notes/preibisch-swoger-2007-2014-multiview-microscopy.md` | Primary articles | Adjacent view registration, fusion, and multiview deconvolution precedent. | Citable as analogy only. |
| `literature/notes/targeted-literature-gap-fill-2026-07-17.md` | Synthesis note | Cluster-level map of new literature support and safe boundaries. | Internal planning note; do not cite. |
| `literature/notes/ng-hanrahan-digital-correction-light-field-aberrations.md` | Article or paper-like local PDF | Digital light-field aberration correction and ray-space rectification precedent. | Provisional local citation only; verify venue before final bibliography. |
| `literature/notes/wu-2021-digital-adaptive-optics-daoslimit.md` | Primary article (main text read; STAR Methods not) | Digital aberration correction in a scanning light-field microscope; sub-aperture shift model and tiled correction as precedent. | Citable for the main-text claims; scanning, 3D, iterative method, so comparison only. |
| `literature/notes/wang-2021-vcd-lfm-deep-learning.md` | Primary article (delegated reading, intro and Fig. 1 re-checked) | Learned LFM reconstruction family; contrast with the thesis's non-learned method. | Citable for the family; image-plane LFM, supplement unread. |
| `literature/notes/lu-2019-phase-space-deconvolution.md` | Primary article (delegated reading, intro re-checked) | Phase-space deconvolution; LFM non-uniform PSF and native-plane artifacts. | Citable; image-plane LFM only. |
| `literature/notes/cong-2017-xlfm-zebrafish.md` | Primary article (delegated reading, Results start re-checked) | Pupil-conjugate light-field layout (XLFM) predating Guo 2019. | Citable; does not use "Fourier"; check thesis wording on FLFM origin. |
| `literature/notes/wagner-2019-iso-lfm.md` | Primary brief communication (delegated reading, intro and Fig. 1 re-checked) | Dual-view LFM with volume registration and multiview deconvolution; stated LFM limits. | Optional; supplement unread. |
| `literature/notes/bergen-1992-hierarchical-model-based-motion.md` | Conference paper (pp. 237-249 read) | Global model plus local per-pixel component, coarse-to-fine refinement, bilinear warping. | Citable as background only; gradient-based pyramid method, not discrete search. |
| `literature/notes/guizar-sicairos-2008-efficient-subpixel-registration.md` | Primary letter (read in full) | Cross-correlation peak gives a translation; efficient sub-pixel refinement. | Citable as background only; translation-only and not the thesis method. |
| `literature/notes/zitova-2003-image-registration-survey.md` | Survey article (delegated reading, one passage re-checked) | Area-based correlation registration, local versus global mappings, backward mapping and interpolation. | Citable for those general statements; not for the global-then-local scheme. |
| `literature/notes/horn-schunck-1981-determining-optical-flow.md` | Primary article (delegated reading, abstract re-checked) | Dense per-pixel displacement field idea. | Citable for the idea only; smoothness prior, small motion. |
| `literature/notes/jeon-2015-lenslet-light-field-depth.md` | Conference paper (delegated reading, core passages re-checked) | Light-field analogue: shifted sub-aperture views, cost volume, per-pixel selection. | Citable as analogue; displacement is depth, not aberration. |
| `literature/notes/avants-2008-symmetric-diffeomorphic-cross-correlation.md` | Primary article (reserve, not in bib) | Windowed local normalized correlation as a registration score. | Reserve; redundant with Scharstein. |
| `literature/notes/szeliski-computer-vision-draft-warping.md` | Textbook draft (Chapter 3 only, not in bib) | Inverse warping and interpolation. | Edition and section numbers to settle before citing. |
| `literature/notes/scharstein-2002-dense-stereo-taxonomy.md` | Survey and taxonomy article (Sections 1-4 read) | Local window-based correspondence with winner-take-all selection; vocabulary for the Chapter 5 local stage. | Citable for the family and vocabulary only; rectified stereo geometry. |
| `literature/notes/ji-2010-adaptive-optics-pupil-segmentation.md` | Primary article (main text read) | Pupil-segment image shift as local wavefront tilt (zonal AO); principle behind the shift premise. | Citable for the principle; hardware AO in a two-photon path, not light-field or digital. |
| `literature/notes/milkie-2011-pupil-segmentation-full-pupil.md` | Primary letter | Full-pupil-illumination variant of pupil-segmentation AO. | Optional, weak fit; do not pair with "angular disparities". |
| `literature/notes/platt-shack-2001-shack-hartmann-history.md` | Historical review article | Lenslet spot displacement as wavefront tilt; background for the shift premise. | Citable for the principle only; no formula or limits in the paper. |
| `literature/notes/booth-2007-adaptive-optics-in-microscopy.md` | Review article (main text read) | Aberration sources in microscopy; direct sensing needs a point-like reference, so indirect methods dominate; DM selection and field variation (G24, G26, G27). | Citable. No statement that correctors are expensive (it calls them affordable); no G25. |
| `literature/notes/hampson-2021-adaptive-optics-primer.md` | Review article (author manuscript, microscopy parts read) | Single review citation for aberration sources, direct versus indirect sensing, isoplanatic patch size, cost and complexity of AO (G24, G26, G27). | Citable; locators are PDF page numbers of the author manuscript. Cost is stated only for multiconjugate and ophthalmic AO. |
| `literature/notes/kner-2010-widefield-adaptive-optics-spherical-aberration.md` | Primary article (read in full) | Widefield fluorescence AO with a deformable mirror; depth aberration is the same across the field; open-loop correction (G24, G27). | Citable; no cost statement, no sensing on the sample. |
| `literature/notes/furieri-2022-aberration-large-field-of-view.md` | Primary article (main text read; supplement not) | Field-dependent aberration in widefield fluorescence: one correction leaves only 3.7 and 8.6 percent of the field well corrected (G27). | Citable; year is 2022 (online 2021). |
| `literature/notes/liu-2018-lattice-light-sheet-adaptive-optics.md` | Primary article (main text read; supplement not) | Isoplanatic patch of 30-60 micrometres in zebrafish embryos; tiled corrections; multiconjugate AO adds cost and complexity (G27). | Citable for spatial variation; hardware AO in a light-sheet system. |
| `literature/notes/scrimgeour-2012-segmented-pupil-image-interferometry.md` | Primary article (read in full) | Hardware precedent in widefield fluorescence: image shift between pupil segments read as local tilt, one shift per segment by cross-correlation. | Citable for the shift principle only; system aberration only, one static correction for the field. |
| `literature/notes/debarre-2009-image-based-adaptive-optics-two-photon.md` | Primary letter (read in full) | Sensorless (image-based) AO: metric, number of images, benefit; one correction for the whole image (G26, G27). | Citable; two-photon scanning. |
| `literature/notes/wang-2015-direct-wavefront-sensing-in-vivo.md` | Primary article (main text read; supplement not) | Shack-Hartmann sensing on a two-photon guide star; why a guide star is needed; indirect AO as the fallback (G26). | Citable; no cost statement. |
| `literature/notes/azucena-2010-microsphere-reference-beacons.md` | Primary article (read in full) | Shack-Hartmann sensing with fluorescent microsphere beacons; isoplanatic field of about 38 micrometres (G26, G27). | Citable with care: its corrected-area figures are internally inconsistent (see note). |
| `literature/notes/rueckel-2006-coherence-gated-wavefront-sensing.md` | Primary article (read in full) | Direct sensing with a virtual Shack-Hartmann sensor from coherence-gated backscatter. | Optional; not added to the bibliography. |
| `literature/notes/tao-2011-fluorescent-protein-guide-stars.md` | Primary letter (read in full) | Direct sensing with fluorescent-protein guide stars; indirect methods bleach. | Optional; not added to the bibliography. |
| `literature/notes/rodriguez-2018-adaptive-optics-neurobiology.md` | Review article (read in full) | Direct versus indirect classification; spatial extent of one correction. | Optional secondary review; not added (Hampson and Booth 2007 cover the points). |
| `literature/notes/marsh-2003-adaptive-optics-multiphoton.md` | Primary article (read in full) | Aberration sources and deformable-mirror limits in a multiphoton system. | Optional; not added. |
| `literature/notes/neil-2000-adaptive-aberration-correction-two-photon.md` | Primary letter (read in full) | Early AO in a two-photon microscope; modal sensing from image brightness. | Optional; not added. |
| `literature/notes/booth-2006-sensorless-adaptive-optics-sphere-packings.md` | Theory article (read in full) | Definition and theory of sensorless AO (N+1 measurements for N modes). | Optional; not added. |
| `literature/notes/sibarita-2005-deconvolution-microscopy.md` | Review chapter (read in full) | PSF requirement, noise amplification in direct inversion, cost of iterative and blind methods, shift-invariance assumption (G25, G24, G27). | Citable; note it also says deconvolution runs on inexpensive computers and MLE is noise-robust. |
| `literature/notes/mcnally-1999-deconvolution-microscopy-3d-imaging.md` | Review article (read in full) | Widefield 3D deconvolution: PSF need, algorithm classes, noise in linear methods, processing time of seconds to hours, artefacts (G25). | Citable; cost is time, not money. |
| `literature/notes/sarder-2006-deconvolution-methods-3d-fluorescence.md` | Overview article (read in full) | Inverse filtering amplifies noise; PSF errors cause ringing; blind methods; most algorithms assume a shift-invariant PSF (G25). | Citable; no wavefront sensing or AO content. |
| `literature/notes/kam-2001-computational-adaptive-optics.md` | Primary article (read in full) | Computational AO: predict a space-variant PSF from a refractive-index map and deconvolve piecemeal; full space-variant deconvolution intractable (G25, G24). | Citable; proof of principle on beads only; aberration is predicted, not measured. |
| `literature/notes/hanser-2004-phase-retrieved-pupil-functions.md` | Primary article (read in full) | Pupil function retrieved from a bead defocus series; an accurate PSF matters for deconvolution (G25, G30). | Citable; widefield fluorescence, not light-field. |
| `literature/notes/dey-2006-richardson-lucy-total-variation.md` | Primary article (read in full) | States Richardson-Lucy tends to amplify noise and needs regularization (G25). | Citable for that statement; 3D confocal. |
| `literature/notes/preza-2004-depth-variant-ml-restoration.md` | Primary article (read in full) | Shift-invariant models fail in thick specimens because of depth-dependent aberration (G24, G27). | Citable; axial variation only, synthetic tests. |
| `literature/notes/kenig-2010-blind-deconvolution-machine-learning.md` | Primary article (read in full) | Blind deconvolution is ill-posed; the sample alters the PSF so it cannot be known in advance; about 2 h for a 128-cubed volume (G25). | Citable; does not claim noise amplification. |
| `literature/notes/gibson-lanni-1991-analytical-aberration-model-oil-immersion.md` | Primary article (read in full) | Analytical model of aberration from index mismatch and depth in an oil-immersion objective (G24). | Citable; no deconvolution content. |
| `literature/notes/gibson-lanni-1989-diffraction-circular-aperture-model.md` | Primary article (read in full) | Scalar PSF model of an aberration-free aperture. | Background only; not added. |
| `literature/notes/wallace-2001-working-persons-guide-deconvolution.md` | Practical guide (read in full) | Wrong PSF gives artefacts; iterative methods amplify noise; software assumes a spatially invariant PSF (G25, G27). | Citable; it does not call deconvolution prohibitively slow. |
| `literature/notes/zheng-2013-fourier-ptychographic-microscopy.md` | Primary article (main text read; supplement not) | Founding Fourier ptychographic microscopy (FPM) paper: 137 coherent LED captures, about 3 min; states FPM is not a fluorescence technique (G28). | Citable; resolution is half-pitch (2015 corrigendum uses full pitch); main text recovers defocus only. |
| `literature/notes/ou-2014-embedded-pupil-recovery.md` | Primary article (read in full) | Joint recovery of sample and full pupil in FPM; 225 sequential images; tiling for field variation (G28). | Citable for pupil recovery; silent on fluorescence and coherence. |
| `literature/notes/chung-2016-fpm-fluorescence-deconvolution.md` | Primary article (read in full) | Pupil estimated from brightfield FP then used to deconvolve fluorescence per tile; thin samples, long exposures (G28, G30). | Citable; needs a shared optical path. |
| `literature/notes/chung-2019-cacao-fb.md` | Primary article (read in full; supplement not) | Per-tile aberration estimation for incoherent imaging (CACAO-FB); not single-shot; says severe aberration changes the PSF shape, not only its shift (G28). | Citable; fluorescence only a prospect. |
| `literature/notes/dong-2014-pattern-illuminated-fluorescence.md` | Primary article (read in full) | Why original FP fails for fluorescence and the patterned-illumination fix; no aberration treatment (G28). | Citable for the fluorescence point. |
| `literature/notes/konda-2020-fourier-ptychography-review.md` | Review article (main text read) | FP review: partially or substantially coherent light, at least 2N sequential measurements, shift-variant aberration only partly handled (G28). | Citable; does not say FP cannot do fluorescence. |
| `literature/notes/zheng-2021-fourier-ptychography-review.md` | Review article (read in full) | FP review: partial coherence, pupil recovery with space-invariant tiles, fluorescence by deconvolution or speckle, 4 to 137 images, single-shot variants (G28). | Citable; avoid 'hundreds of images'. |
| `literature/notes/tian-waller-2015-led-array-light-field.md` | Primary article (read in full) | Light-field-style data in an LED-array microscope with multislice FP; 225 sequential images (G28, G30). | Reserve; label-free, no fluorescence. |
| `literature/notes/bian-2013-adaptive-fourier-ptychography.md` | Primary article (read in full) | FP correction of pupil aberration with three Zernike modes (one global pupil), LED drift and defocus. | Reserve. |
| `literature/notes/horstmeyer-2014-overlapped-fourier-coding.md` | Primary article (read in full) | Overlapped Fourier coding: 81 images, coherent laser, one global aberration map. | Reserve. |
| `literature/notes/rodenburg-faulkner-2004-shifting-illumination.md` | Primary letter (read in full) | Origin of ptychography; simulation only. | Reserve (origin). |
| `literature/notes/maiden-rodenburg-2009-extended-pie.md` | Primary article (read in full) | ePIE: states high coherence and 60-70 percent overlap are required (G28). | Citable for the coherence and overlap statements. |
| `literature/notes/gustafsson-2000-lateral-sim.md` | Primary letter (read in full) | Founding SIM paper: resolution doubling from shifted and rotated patterns (G29). | Citable. |
| `literature/notes/neil-1997-structured-light-sectioning.md` | Primary letter (read in full) | Optical sectioning from structured light in a conventional microscope (G29). | Citable. |
| `literature/notes/gustafsson-2008-3d-sim.md` | Primary article (read in full) | 3D SIM: raw image count, effect of index mismatch on the pattern, artefacts, calibration (G29). | Citable. |
| `literature/notes/wu-shroff-2018-sim-perspective.md` | Perspective article (read in full) | SIM review: speed, artefacts, aberration and scattering in thick samples, adaptive optics (G29). | Citable. |
| `literature/notes/debarre-2008-adaptive-optics-sim.md` | Primary article (read in full) | Why aberrations degrade SIM (grid versus non-grid modes); sensorless AO with 2N+1 measurements; correction averaged over the frame (G29, G26). | Citable; optical-sectioning SIM. |
| `literature/notes/thomas-2015-sim-ao-thick-tissue.md` | Primary article (read in full) | SIM with AO: one correction for the whole field; isoplanatic patch under 1 to about 10 micrometres in simulation (G29, G27). | Added (author decision 2026-11-11); bead-based correction under a fixed worm. |
| `literature/notes/gustafsson-2005-nonlinear-sim.md` | Primary article (read in full) | Saturated (nonlinear) SIM. | Reserve. |
| `literature/notes/demmerle-2017-sim-guidelines.md` | Protocol article (read in full) | Practical SIM artefact sources. | Reserve. |
| `literature/notes/heintzmann-cremer-1999-modulated-excitation.md` | Conference paper (read in full) | Early patterned-excitation resolution improvement. | Reserve. |
| `literature/notes/ayuk-2013-filtered-blind-sim.md` | Primary letter (read in full) | SIM tolerating distorted illumination via blind reconstruction. | Not added (author decision 2026-11-11). |
| `literature/notes/mudry-2012-unknown-speckle-sim.md` | Primary letter (read in full) | SIM with unknown speckle illumination. | Reserve. |
| `literature/notes/wilson-2011-fluorescence-sectioning.md` | Review article (read in full) | Comparison of optical-sectioning methods. | Reserve. |
| `literature/notes/chen-2014-lattice-light-sheet.md` | Primary article (main text read; supplement not) | Lattice light-sheet microscopy with a SIM mode; off-topic. | Drop. |
| `literature/notes/kao-verkman-1994-astigmatic-particle-tracking.md` | Primary article (read in full) | Astigmatic PSF encodes axial position of single particles via calibration (G30). | Citable; sparse emitters only. |
| `literature/notes/huang-2008-astigmatic-3d-storm.md` | Primary article (main text read; supplement not) | Astigmatic 3D localization in STORM (G30). | Reserve; sparse emitters only. |
| `literature/notes/pavani-2009-double-helix-psf.md` | Primary article (read in full) | Double-helix engineered PSF for depth (G30). | Reserve; sparse emitters only. |
| `literature/notes/paxman-1992-joint-phase-diversity.md` | Primary article (read in full) | Phase diversity: a known added aberration as a second measurement; extended incoherent objects (G30). | Dropped (author decision 2026-11-11); not in the bibliography. |
| `literature/notes/subbarao-surya-1994-depth-from-defocus.md` | Primary article (read in full) | Depth from defocus from two images with different camera parameters (G30). | Fallback outside microscopy. |
| `literature/notes/nayar-nakagawa-1994-shape-from-focus.md` | Primary article (read in full) | Shape from focus on a microscope z-stack of opaque reflective samples (G30). | Fallback; needs a mechanical scan. |
| `literature/notes/mockl-2019-learned-psf-phase-retrieval.md` | Primary article (read in full) | Neural-network phase retrieval of 3D PSFs for single emitters. | Reserve. |
| `literature/notes/paine-fienup-2018-learned-wavefront-initialization.md` | Primary letter (read in full) | Machine learning to initialise image-based wavefront estimation (telescopes). | Reserve. |
| `literature/notes/dowski-cathey-1995-wavefront-coding.md` | Primary article (read in full) | Cubic phase mask plus digital restoration for extended depth of field. | Reserve. |
| `literature/notes/pentland-1987-depth-from-defocus.md` | Primary article (read in full) | Defocus as a depth cue. | Reserve. |
| `literature/notes/teague-1983-transport-of-intensity.md` | Primary article (read in full) | Transport-of-intensity phase retrieval from defocused images. | Reserve (historical). |
| `literature/notes/waller-2010-transport-of-intensity.md` | Primary article (read in full) | TIE with higher-order derivatives; partially coherent. | Reserve. |
| `literature/notes/tao-2013-light-field-depth.md` | Conference paper (read in full; supplement not) | Depth from defocus and correspondence from one light-field capture. | Added (author decision 2026-11-11); light-field analogue, macro scenes. |
| `literature/notes/fienup-1982-phase-retrieval.md` | Primary article (read in full) | Comparison of phase-retrieval algorithms. | Reserve. |
| `literature/notes/agard-1984-optical-sectioning-microscopy.md` | Review chapter (read in full) | Series of images at different focal planes as the basis of 3D reconstruction; PSF needed to reverse the convolution (G30, G25). | Citable for G30; no aberration discussion. |
| `literature/notes/richardson-1972-bayesian-iterative-restoration.md` | Primary article (read in full) | Origin of the iteration later called Richardson-Lucy. | Cite only together with Lucy 1974 (not in hand); not added. |
| `literature/notes/holmes-1992-blind-deconvolution-quantum-limited.md` | Primary article (read in full) | Maximum-likelihood blind deconvolution with Poisson noise; simulation only. | Optional; not added. |
| `literature/notes/kim-2015-blind-depth-variant-deconvolution.md` | Primary article (read in full) | Blind depth-variant deconvolution; 27.5 hours for the depth-variant run. | Optional; not added. |
| `literature/notes/kirshner-2013-3d-psf-fitting.md` | Primary article (read in full) | PSF-model fitting for localization; Gibson-Lanni model. | Leaning drop; not added. |
| `literature/notes/sage-2017-deconvolutionlab2.md` | Software article (read in full) | Timings of direct versus iterative methods; noise amplification as a tuning problem. | Optional; not added. |
| `literature/notes/guo-2020-rapid-deconvolution-multiview-fusion.md` | Primary article (read in full) | Cost of conventional Richardson-Lucy and the proposed fix. | Optional; not added. |
| `literature/notes/weigert-2018-content-aware-restoration.md` | Primary article (read in full) | Representative learned restoration; needs training data, specific to the setup. | Optional; not added (Wang 2021 already covers learned reconstruction). |
| `literature/notes/levin-2009-understanding-blind-deconvolution.md` | Conference paper (read in full) | General limits of blind deconvolution outside microscopy. | Fallback only; not added. |
| `literature/notes/goodman-2015-statistical-optics.md` | Book | Statistical optics, coherence, random phase screens, speckle, noise, and random-media limits. | Citable. |
| `literature/notes/thesis-example-saiko-2023-material-acquisition.md` | Thesis example | Compact MSc structure, appendix placement, cautious discussion. | Structure reference only. |
| `literature/notes/thesis-example-monin-2026-shaping-light.md` | Thesis example | Contribution framing, notation/front matter, optical setup appendices. | Structure reference only. |
| `planning/writing-standard.md` | Project editorial standard | Chapter logic, evidence-bounded tone, figure/caption quality, and limitations. | Apply to all chapters; not a citable scientific source. |
| `research-context/internal-evidence-digest.md` | Internal context digest | Method/result evidence controls and chapter placement. | Internal provenance; refresh if source repos change. |

## Chapter 1: Introduction

**Job:** motivate the problem, define objectives and bounded contributions, and
orient the reader to the seven-chapter argument.

**Evidence:** thesis narrative map, claim tracker, relevant inspected literature,
and qualified results when available. The current opening is retained; its
completion and shortening are later content work. Avoid duplicating the review
or microscope explanation.

## Chapter 2: Literature Review

**Job:** select and compare the prior approaches needed to establish the gap.
Rebuild plan: [02-literature-review-plan.md](02-literature-review-plan.md) (draft, 2026-11-11).

**Evidence:** Levoy, Guo, Hua, Broxton, Stefanoiu, Prevedel, Ng/Hanrahan,
scattering-aware LFM, adaptive optics, and multiview notes where relevant.
These are source pools, not a requirement to cover every paper. Reserve the
local physical explanation for Chapter 3 and the actual pipeline for Chapter 5.

## Chapter 3: What is a light-field microscope

**Job:** explain measured sensor data, elemental views, relevant sampling/model
assumptions, and degradation context needed to understand reconstruction limits.

**Evidence:** Guo, Galdón/Yun, Levoy; Goodman/Jacques and the existing degradation
source notes as needed; method terminology and the physical-system account.
The [Chapter 3 specification](03-light-field-model-plan.md) retains an optional
evidence-backed drafting backlog, not a fixed-length or mandatory-section plan.
The former degradation placeholder is now plain text in this chapter (its section heading was removed on 2026-11-09). Keep setup values and
calibration protocols in Chapter 4/supporting records. No new model or scientific
wording is introduced by this structural migration.

## Chapter 4: Our setup

**Job:** identify the instrument/camera paths and give the minimal acquisition,
calibration, selection, and evaluation summary needed to interpret the evidence.

**Evidence:** physical-system account, dataset/run maps, selected acquisition
records, and result provenance. The whole old setup/data/evaluation draft stays
here temporarily. Later move detailed protocols, exhaustive inventories,
configurations, metric definitions, and registration records to appendices or
linked provenance. Keep essential comparison qualifications visible in Results.

## Chapter 5: Image reconstruction

**Job:** explain the single global-then-local transformation from extracted views
to the final image, identifying the intermediate global-stage average.

**Evidence:** start at the rectification method-note index; use the pinned source
account and run-specific records. The technical worksheet supports a complete
account across main and supplemental material. Do not infer historical settings
from current code defaults. Current equations, prose, and both figures remain;
later reduction and the choice of the single retained figure are pending.

## Chapter 6: Results

**Job:** support bounded claims with the smallest adequate set of qualified,
traceable comparisons, quantification, and failure/no-change evidence.

**Evidence:** eyedrop/chicken aggregation notes, selected run metadata,
same-run intermediate/final outputs, and qualified ThorCam/Validation records.
Candidate pools are not a fixed list of mandatory result blocks. Close-bead or
fidelity claims need their own support. No candidate is promoted by renumbering.

## Chapter 7: Discussion and Conclusions

**Job:** interpret the established findings, compare with prior work, state
limitations, summarize supported contributions, and identify bounded future work.

**Evidence:** final selected results and provenance, claim tracker, method and
evaluation caveats, and inspected comparison literature. Keep the method's 2D
registration/aggregation boundary explicit. Introduce no new evidence. The old
discussion and conclusion bodies are retained as sections for later development.

## Appendices and supporting records

Place only necessary detailed derivations, protocols, component/configuration
inventories, supplementary results, and reproducibility records here. Preserve
the existing appendices during the structural pass; do not manufacture content
or relocate manuscript material until a later content task is authorized.
