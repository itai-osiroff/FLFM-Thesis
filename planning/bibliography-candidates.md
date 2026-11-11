# Bibliography Candidates (Phase 2)

> **Status:** draft
>
> **Reviewed:** 2026-11-11

Phase 3 progress: the C2 core list is read (see the status table in the C2
section), and the two further C2 candidates from Wu's reference list (Ji 2010,
Milkie 2011) are read too.
C3 and C1 were read later the same day (see their status tables). C4 (added
2026-11-11; fluorescence-microscopy methods for aberrations, PSF estimation and
deconvolution, ptychography, structured illumination and defocus): C4a and C4b
were read on 2026-11-11 (20 entries added to `thesis.bib`, see the Phase 3 results
under C4b). The C4c-C4e pass reviewed 39 local PDFs and added nine entries to
`thesis.bib` (see the [triage below](#phase-3-results-for-c4c-c4e-2026-11-11)).
Added to `thesis.bib` on 2026-11-10: Ji 2010, Wu 2021
and Platt and Shack 2001 (none is cited in the text yet). Not added: Milkie 2011
(weak fit). Ng and Hanrahan: the entry is an `@inproceedings` for Proc. SPIE 6342,
63421E, DOI `10.1117/12.692290`, confirmed against the SPIE copy
(`literature/ng2007.pdf`). Scharstein and Szeliski 2002 added as
`scharstein2002denseStereoTaxonomy`. Levoy/Hanrahan replaced by the 1996 original.

Candidate sources for the gaps in the [bibliography gap audit](bibliography-gap-audit.md),
for the three author-selected clusters (C1 LFM/FLFM reconstruction, C2 aberration
correction in light-field systems, C3 registration and local displacement).

**Initial check (2026-11-10):** existence and basic metadata (authors, year,
venue, DOI) in the Crossref index, plus a web search for two items Crossref
did not return. The Phase 3 results below record subsequent paper inspections
and bibliography additions. Per the
[source register rules](../literature/writing-guidance/source-register.md), each
entry needs a primary-version check, a locator and a reading note (Phase 3)
before it is cited.

Pick counts are planning suggestions. The Chapter 2 space is about one
paragraph per cluster, so "core" means the likeliest citations and "optional"
means keep in reserve.

## C3: registration and local displacement (Chapter 5, Appendix A)

| Candidate | Gap IDs | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Levoy and Hanrahan, *Light Field Rendering*, SIGGRAPH 1996. DOI `10.1145/237170.237199` | G1 | **Core.** Replaces the 2023 reprint entry (author decision). | An earlier web search surfaced `10.1145/237170.237200` without attributing it to a paper; do not use it. Check the DOI against the ACM page. |
| Zitová and Flusser, *Image registration methods: a survey*, Image and Vision Computing 21(11), 2003. DOI `10.1016/S0262-8856(03)00137-9` | G2, G4 | **Core.** General registration framing; area-based methods and resampling. | Confirm the area-based section supports "translation estimated by correlation". |
| Guizar-Sicairos, Thurman and Fienup, *Efficient subpixel image registration algorithms*, Optics Letters 33(2), 2008. DOI `10.1364/OL.33.000156` | G2, G8 | **Core.** Cross-correlation with sub-pixel precision. | The thesis global stage uses integer shifts; cite for correlation registration and for the sub-pixel step only where the local search is finer than one pixel. |
| Horn and Schunck, *Determining optical flow*, Artificial Intelligence 17, 1981. DOI `10.1016/0004-3702(81)90024-2` | G3 | **Core.** Dense per-pixel displacement field. | The thesis selects each pixel's shift independently with no smoothness prior, unlike Horn-Schunck; word it as the dense-displacement idea only. |
| Scharstein and Szeliski, *A taxonomy and evaluation of dense two-frame stereo correspondence algorithms*, IJCV 47, 2002. DOI `10.1023/A:1014573219977` | G3, G6 | **Core.** Local window matching with winner-take-all selection is a named family here. | Locate the local-aggregation and winner-take-all passages. |
| Avants et al., *Symmetric diffeomorphic image registration with cross-correlation*, Medical Image Analysis 12(1), 2008. DOI `10.1016/j.media.2007.06.004` | G3 | **Core or optional.** Windowed local cross-correlation as a registration score. | The thesis score is a Gaussian-weighted, regularized normalized product; confirm the local-correlation definition really matches before citing as precedent. |
| Bergen, Anandan, Hanna and Hingorani, *Hierarchical model-based motion estimation*, ECCV 1992. DOI `10.1007/3-540-55426-2_27` | G4 | **Optional.** Coarse-to-fine registration precedent. | The thesis is global translation then local refinement, not a multiresolution pyramid. |
| Jeon et al., *Accurate depth map estimation from a lenslet light field camera*, CVPR 2015. DOI `10.1109/CVPR.2015.7298762` | G6 | **Core, one of two.** Disparity from sub-aperture views with sub-pixel shifts. | These are regular-grid light-field cameras, not FLFM; cite as the nearest analogue. |
| Wanner and Goldluecke, *Variational light field analysis for disparity estimation and super-resolution*, IEEE TPAMI 36, 2014. DOI `10.1109/TPAMI.2013.147` | G6 | **Optional alternative** to Jeon. | Same caveat. |
| Tao et al., *Depth from combining defocus and correspondence using light-field cameras*, ICCV 2013. DOI `10.1109/ICCV.2013.89` | G6 | Optional. | Defocus-plus-correspondence; likely more than Chapter 5 needs. |
| Szeliski, *Computer Vision: Algorithms and Applications*, 2nd ed., Springer, 2022. DOI `10.1007/978-3-030-34372-9` | G5 | **Core for resampling.** Standard reference for backward warping and interpolation. | Pick chapter and section locators. |
| Brown, *A survey of image registration techniques*, ACM Computing Surveys 24, 1992. DOI `10.1145/146370.146374` | G2 | Optional alternative to Zitová and Flusser. | Cite one survey, not both, unless space allows. |
| Anuta, *Spatial registration of multispectral and multitemporal digital imagery using fast Fourier transform techniques*, IEEE Trans. Geoscience Electronics, 1970. DOI `10.1109/TGE.1970.271435` | G2 | Optional historical source for correlation registration. | Only if the chapter needs a historical origin. |
| Sotiras, Davatzikos and Paragios, *Deformable medical image registration: a survey*, IEEE TMI 32, 2013. DOI `10.1109/TMI.2013.2265603` | G3, G5 | Optional. Spatially varying warps in registration. | The thesis is not a deformable-registration method; check whether it adds value. |

### Phase 3 status for the C3 core list (2026-11-10)

| Source | Status | Detail |
| --- | --- | --- |
| Levoy and Hanrahan 1996 | **Replaced in `thesis.bib`.** | Entry `levoyHanrahan1996lightFieldRendering` (SIGGRAPH '96, pp. 31-42, DOI `10.1145/237170.237199`) replaces the 2023 reprint; both citing files (Chapter 5, Appendix A) now use the new key. Metadata from Crossref and several citing sources; the 1996 text was not reread, since the reprint has the same content. |
| Scharstein and Szeliski 2002 | **Inspected** (Sections 1-4; evaluation sections not read) ([note](../literature/notes/scharstein-2002-dense-stereo-taxonomy.md)) | Supports naming the thesis's local stage as a local window-based, winner-take-all search. Stereo geometry differs. Added to `thesis.bib` as `scharstein2002denseStereoTaxonomy`. |
| Zitová and Flusser 2003 | **Inspected; added** as `zitova2003imageRegistrationSurvey` ([note](../literature/notes/zitova-2003-image-registration-survey.md)) | Supports area-based correlation registration of translations, local versus global mappings, backward mapping and bilinear interpolation. Delegated reading, one passage re-checked. |
| Horn and Schunck 1981 | **Inspected; added** as `horn1981determiningOpticalFlow` ([note](../literature/notes/horn-schunck-1981-determining-optical-flow.md)) | Cite only for the idea of a dense per-pixel field. It needs a smoothness prior and a small-motion model, which the thesis local stage does not use. |
| Jeon et al. 2015 | **Inspected; added** as `jeon2015lensletDepthEstimation` ([note](../literature/notes/jeon-2015-lenslet-light-field-depth.md)) | Nearest light-field analogue (shift views by sub-pixel amounts, cost volume, per-pixel selection). Displacement is depth, not aberration. Section 3.2 names Ng and Hanrahan as general aberration correction. Core passages re-checked. |
| Avants et al. 2008 | **Inspected; not added** ([note](../literature/notes/avants-2008-symmetric-diffeomorphic-cross-correlation.md)) | Reserve: windowed local normalized correlation as a registration score (box window, no regularizing constant). Scharstein and Szeliski already cover normalized cross-correlation as a support-region cost. |
| Szeliski, *Computer Vision* | **Added** (2nd edition, 2022) as `szeliski2022computerVision`; **locators not yet verified** ([note](../literature/notes/szeliski-computer-vision-draft-warping.md)) | The local file is a September 2009 draft of the first edition with Chapter 3 only. It supports inverse (backward) warping with interpolation, but its section numbers do not carry over to the 2nd edition. Look up the equivalent sections in the 2nd edition before citing a section. |
| Guizar-Sicairos et al. 2008 | **Inspected in full; added** as `guizarsicairos2008efficientSubpixelRegistration` ([note](../literature/notes/guizar-sicairos-2008-efficient-subpixel-registration.md)) | The file was replaced with the Optics Letters 33(2), 156-158 letter and read directly. Supports locating a translation from the cross-correlation peak and doing so to sub-pixel precision efficiently. It is translation-only, and the thesis does not use this algorithm (its sub-pixel search upsamples the images linearly), so cite as background. |
| Bergen et al. 1992 | **Inspected (pp. 237-249); added** as `bergen1992hierarchicalMotionEstimation` ([note](../literature/notes/bergen-1992-hierarchical-model-based-motion.md)) | The file was replaced with the ECCV'92 paper and read directly. Supports, as background, a registration structure with a global model, a local per-pixel component, coarse-to-fine refinement and bilinear warping (Sections 1-2, 3.3). It is gradient-based inside a pyramid and states it is used instead of discrete search; the thesis is neither, so do not say the thesis follows it. Resolves G4 only as background. |

**Not found in Crossref (no DOI via that index; locate through other sources):**
Lucas and Kanade 1981 (IJCAI proceedings); Lewis 1995, *Fast normalized
cross-correlation* (Vision Interface); Kuglin and Hines 1975 (phase
correlation, IEEE conference); Ng et al. 2005, *Light field photography with a
hand-held plenoptic camera* (Stanford tech report). Find open copies or drop
them; they are optional.

## C2: aberration correction in light-field systems (Chapters 1, 2, 3)

| Candidate | Gap IDs | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Ng and Hanrahan, *Digital correction of lens aberrations in light field photography*, International Optical Design Conference 2006. DOI `10.1364/IODC.2006.WB2` (Crossref) | G10, G23 | **Core. Resolves the missing venue** on the existing `@misc` entry, if the local 14-page PDF is the same work. | Compare the Optica/OSA record with the local PDF (title, pages, content). It may be an extended-abstract form of the paper. |
| Wu et al., *Iterative tomography with digital adaptive optics permits hour-long intravital observation of 3D subcellular dynamics at millisecond scale*, Cell 184, 2021. DOI `10.1016/j.cell.2021.04.029` | G21, G16 | **Core.** Digital adaptive optics in a light-field microscope; nearest C2 precedent. | How is the aberration estimated, and does it use view-dependent shifts? It is a scanning light-field system with iterative tomography, not your 2D rectification. |
| Platt and Shack, *History and principles of Shack-Hartmann wavefront sensing*, J. Refractive Surgery 17, 2001. DOI `10.3928/1081-597X-20010901-13` | G9, G22, G23 | **Core.** The wavefront-slope to spot-displacement principle behind the thesis's shift assumption. | Locate the passage relating local wavefront tilt to spot displacement; supports plausibility only. |
| Ko and Davis, *Comparison of the plenoptic sensor and the Shack-Hartmann sensor*, Applied Optics 56, 2017. DOI `10.1364/AO.56.003689` | G9, G23 | **Optional.** Light-field-like sensing compared with Shack-Hartmann. | Check the system is relevant to microscopy; may be atmospheric-turbulence oriented. |
| Rodríguez-Ramos et al., *Wavefront and distance measurement using the CAFADIS camera*, SPIE 2008. DOI `10.1117/12.789380` | G23 | Optional, weak. | Conference paper; use only if Ko and Davis does not cover the idea. |
| Born and Wolf, *Principles of Optics*, Cambridge University Press | G9 | Textbook for aberration as wavefront error. | Crossref returned only a Physics Today review. Choose edition, ISBN and section from the book record, not this index. |
| Mahajan, *Optical Imaging and Aberrations* (SPIE Press) | G9 | Alternative textbook. | Crossref returned front and back matter only. Same book-record check. |

Already in the bibliography and needed here: Levoy 2009 (digital correction
under refractive mismatch, Fig. 17), Booth 2014, Ji 2017 and Zhang 2023 (all
in G9, G16, G22).

### Phase 3 status for the C2 core list (2026-11-10)

Metadata for all three was confirmed in OpenAlex through the reference-lookup
tool. Passage-level checks:

| Source | Status | Detail |
| --- | --- | --- |
| Ng and Hanrahan 2006 | **Inspected.** Ready for a `.bib` update once the venue is decided. | The 14-page PDF was read in full and the note's claims confirmed with locators ([note](../literature/notes/ng-hanrahan-digital-correction-light-field-aberrations.md)). The SPIE copy (`literature/ng2007.pdf`) confirms Proc. SPIE 6342, 63421E, DOI `10.1117/12.692290` and matches the Stanford copy page for page; the Optica WB2 record is a separate conference item and is not used. |
| Wu et al. 2021 (Cell) | **Inspected (main text).** Ready to cite for what the main text states; the derivation is unread. | The version-of-record PDF was read in full (15 pages). It states that aberrations are estimated from disparities between angular views and corrected by digitally shifting the angular images, tile by tile, inside an iterative 3D reconstruction (p. 3319, 3323). The STAR Methods and supplement are online only and were not read ([note](../literature/notes/wu-2021-digital-adaptive-optics-daoslimit.md)). |
| Platt and Shack 2001 | **Inspected.** Ready to cite for the principle only. | All five pages read. States that displacements of lenslet spots measure wavefront tilt (p. S574, Fig. 3) and gives the history. It has no formula and no stated limits, so it cannot support a quantitative relation ([note](../literature/notes/platt-shack-2001-shack-hartmann-history.md)). |

Two further C2 candidates came from the Wu reference list (p. 3331-3332). Both
were read on 2026-11-10 from Janelia-hosted copies of the published papers
(fetched, not stored in the repo):

| Candidate | Gap IDs | Status | Verdict |
| --- | --- | --- | --- |
| Ji, Milkie and Betzig, *Adaptive optics via pupil segmentation for high-resolution imaging in biological tissues*, Nature Methods 7(2), 141-147, 2010. DOI `10.1038/nmeth.1411` | G9, G22, G23 | **Inspected** (main text; Online Methods and supplement not read) ([note](../literature/notes/ji-2010-adaptive-optics-pupil-segmentation.md)) | **Core.** Primary source: image shift through each pupil segment gives the local wavefront tilt; zonal, Shack-Hartmann-like; states it may apply to widefield microscopes. Year: Crossref says 2009 (published online 27 December 2009); the issue is 2010. It is hardware AO in a two-photon excitation path, so describe it as the principle, not as light-field or digital correction. |
| Milkie, Betzig and Ji, *Pupil-segmentation-based adaptive optical microscopy with full-pupil illumination*, Optics Letters 36(21), 4206-4208, 2011. DOI `10.1364/OL.36.004206` | G9, G23 | **Inspected** (full letter) ([note](../literature/notes/milkie-2011-pupil-segmentation-full-pupil.md)) | **Optional, weak fit.** Same zonal idea with a different measurement (scanning one ray against a fixed pupil). Wu cites it for estimating aberrations from disparities between angular measurements, but the letter says nothing about angular views; do not repeat that pairing. Ji 2010 is enough for the principle. |

Schwiegerling and Neal, "Historical development of the Shack-Hartmann wavefront
sensor" (University of Arizona site), is no longer needed for the principle
now that Platt and Shack is read.

## C1: LFM and FLFM variants and reconstruction (Chapters 1, 2)

| Candidate | Gap IDs | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Wang et al., *Real-time volumetric reconstruction of biological dynamics with light-field microscopy and deep learning*, Nature Methods 18, 2021. DOI `10.1038/s41592-021-01058-x` | G14 | **Core.** Learned reconstruction, a family the thesis explicitly is not. | Describe only what the paper does; keep it as a comparison. |
| Lu et al., *Phase-space deconvolution for light field microscopy*, Optics Express 27, 2019. DOI `10.1364/OE.27.018131` | G14 | **Core.** Deconvolution variant beyond Broxton. | Check the sampling and artifact claims against the note on Stefanoiu. |
| Cong et al., *Rapid whole brain imaging of neural activity in freely behaving larval zebrafish (Danio rerio)*, eLife 6, e28158, 2017. DOI `10.7554/eLife.28158` (Crossref, checked 2026-11-10) | G14 | **Core.** Extended field-of-view light-field microscope (XLFM) for whole-brain imaging of freely swimming larval zebrafish; open access. | Confirm the XLFM optical layout (where the lenslets sit, how many views) and how it relates to FLFM; this was not verified, and the fetch tools were blocked by bot challenges. |
| Wagner et al., *Instantaneous isotropic volumetric imaging of fast biological processes*, Nature Methods 16(6), 497-500, 2019. DOI `10.1038/s41592-019-0393-z` (Crossref) | G14 | **Optional.** Two perpendicular light fields with multiview deconvolution ("Iso-LFM"), from preprint and abstract sources. | The earlier DOI search only found the preprint; the journal version is now resolved. Read the published text before citing the method. |
| Lu et al., *Virtual-scanning light-field microscopy for robust snapshot high-resolution volumetric imaging*, Nature Methods 20, 2023. DOI `10.1038/s41592-023-01839-6` | G14 | Optional. | Learned reconstruction; one learned example is probably enough. |
| Yoon et al., *Sparse decomposition light-field microscopy for high speed imaging of neuronal activity*, Optica 7, 2020. DOI `10.1364/OPTICA.392805` | G14 | Optional. | Sparse reconstruction family. |
| Cohen et al., *Enhancing the performance of the light field microscope using wavefront coding*, Optics Express 22, 2014. DOI `10.1364/OE.22.024817` | G14 | Optional. | A hardware modification of image-plane LFM; may suit Chapter 3. |
| Xue et al., *Single-shot 3D wide-field fluorescence imaging with a Computational Miniature Mesoscope*, Science Advances 6, 2020. DOI `10.1126/sciadv.abb7508` | G14 | Optional, probably out of scope. | A different microlens-based single-shot design. |

Already in the bibliography and needed here: Hua 2021, Galdón 2022, Yun 2023
(G15, G20, G12), Zhang 2021 (G14).

### Phase 3 status for the C1 core list (2026-11-10)

Metadata for Cong 2017, Wang 2021, Lu 2019, Wagner 2019 and the optional Cohen
2014 and Lu 2023 papers was confirmed in Crossref. **at this point no C1 source
had been read (superseded: the four PDFs were supplied and read later the same
day, see the results table below)**: the publisher and PMC/eLife pages are behind bot challenges or paywalls for
the fetch tools, and the OpenAlex lookup was rate-limited. Needed from the author:

| Priority | Paper | DOI | Why |
| --- | --- | --- | --- |
| Core | Wang et al., Nature Methods 18(5), 551-556, 2021 | `10.1038/s41592-021-01058-x` | Learned (deep-network) reconstruction, the family the thesis is not. The bioRxiv preprint has a different title; use the published paper. |
| Core | Lu et al., Optics Express 27(13), 18131, 2019 | `10.1364/OE.27.018131` | Phase-space deconvolution, a model that removes the position dependence of the PSF (abstract-level information only so far). |
| Core | Cong et al., eLife 6, e28158, 2017 | `10.7554/eLife.28158` | XLFM layout; open access, so a browser download should work. |
| Optional | Wagner et al., Nature Methods 16(6), 497-500, 2019 | `10.1038/s41592-019-0393-z` | Multiview light-field deconvolution. |

The existing uncited entries (Hua 2021, Galdón 2022, Yun 2023, Zhang 2021) have
reading notes already; PDFs are only needed if those notes should be re-verified
before citing.

**Results (author-supplied PDFs, read 2026-11-10; one delegated reader per file,
and one or two passages of each re-read and matching).** All four added to
`thesis.bib`:

| Source | Key | Verdict |
| --- | --- | --- |
| Wang et al. 2021 ([note](../literature/notes/wang-2021-vcd-lfm-deep-learning.md)) | `wang2021vcdLfm` | Core. Learned reconstruction: a network trained on synthetic light fields (wave-optics model) from high-resolution volumes, video-rate 3D output. Image-plane LFM, not FLFM. Supplement not in the file. |
| Lu et al. 2019 ([note](../literature/notes/lu-2019-phase-space-deconvolution.md)) | `lu2019phaseSpaceDeconvolution` | Core. Phase-space deconvolution: per-angle shift-invariant PSFs and a smoothness prior, about 10 times cheaper than 3D deconvolution; also gives a primary statement of image-plane LFM artifacts near the native plane (G19). |
| Cong et al. 2017 ([note](../literature/notes/cong-2017-xlfm-zebrafish.md)) | `cong2017xlfmZebrafish` | Core. XLFM places the lenslet array at a pupil-conjugate plane for an approximately shift-invariant PSF. It predates Guo et al. 2019 and does not use the word "Fourier". **Check the thesis wording** for any first-or-novel attribution of the pupil-plane arrangement to Guo. |
| Wagner et al. 2019 ([note](../literature/notes/wagner-2019-iso-lfm.md)) | `wagner2019isoLfm` | Optional, added. Two perpendicular light fields registered and fused by multiview deconvolution; states LFM limits (non-uniform resolution, artifacts near the native plane) in its introduction (G14, G17, G19). Drop if space is short. |

Not added: Cohen 2014 (wavefront coding), Yoon 2020, Lu 2023, Xue 2020 (all
optional, not read).

## C4: aberration-correction and 3D-recovery methods in fluorescence microscopy (Chapters 1, 2)

Added 2026-11-11 at the author's request, covering gaps G24-G30 of the
[gap audit](bibliography-gap-audit.md). **Search rule (author):** prefer sources
set in fluorescence microscopy, and fall back to sources outside microscopy only
where no fluorescence source exists for the claim. Each row is tagged **F**
(fluorescence microscopy), **M** (microscopy but not fluorescence-specific, for
example brightfield or general optics), or **O** (outside microscopy, fallback
only).

**What was checked:** existence and metadata (authors, year, venue, volume,
pages, DOI) in Crossref, plus a web search for the six that Crossref did not
return directly. **What was not checked:** nothing was opened. The "role" column
reflects the usual standing of each paper and my knowledge of it, not a
passage-level check, so no claim is supported yet. Nothing here is in
`thesis.bib`. Recommended reading order is under each table.

### C4a: adaptive optics in fluorescence microscopy (G24, G26, G27)

Already in the bibliography, uncited and not re-read this session: Booth 2014
(`10.1038/lsa.2014.46`), Ji 2017, Zhang 2023. Already read: Ji 2010, Platt and
Shack 2001, Wu 2021.

| Candidate | Tag | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Hampson et al., *Adaptive optics for high-resolution imaging*, Nat. Rev. Methods Primers 1, 68, 2021. DOI `10.1038/s43586-021-00066-7` | M | **Core review.** Most recent broad AO primer spanning microscopy, ophthalmology and astronomy. | Crossref lists two records with this title (`...-00066-7`, article 68, with authors; `...-00072-9`, article 67, no authors). Settle which is the primer before adding. Look for cost and complexity statements (G27). |
| Booth, *Adaptive optics in microscopy*, Phil. Trans. R. Soc. A 365, 2829-2843, 2007. DOI `10.1098/rsta.2007.0013` | F | **Core.** Compact review of AO in (mostly confocal and multiphoton) fluorescence microscopy: sources of aberration, wavefront sensing choices. | Whether it distinguishes direct from sensorless AO and comments on cost (G26, G27). |
| Rueckel, Mack-Bucher and Denk, *Adaptive wavefront correction in two-photon microscopy using coherence-gated wavefront sensing*, PNAS 103, 17137-17142, 2006. DOI `10.1073/pnas.0604791103` | F | **Core for direct wavefront sensing** with a Shack-Hartmann sensor inside a microscope (virtual guide star). | The sensor needs a guide star in the specimen; matches the Ji 2010 statement that direct sensing is hard. |
| Tao et al., *Adaptive optics microscopy with direct wavefront sensing using fluorescent protein guide stars*, Opt. Lett. 36, 3389, 2011. DOI `10.1364/ol.36.003389` | F | Alternative to Rueckel: Shack-Hartmann sensing from a fluorescent guide star. | Pick one of Rueckel, Tao and Wang. |
| Wang et al., *Direct wavefront sensing for high-resolution in vivo imaging in scattering tissue*, Nat. Commun. 6, 7276, 2015. DOI `10.1038/ncomms8276` | F | Optional. In vivo direct sensing (Ji group). | Only if a direct-sensing in vivo example is wanted. |
| Débarre, Booth and Wilson, *Image-based adaptive optics for two-photon microscopy*, Opt. Lett. 34, 2495, 2009. DOI `10.1364/ol.34.002495` | F | **Core for sensorless (indirect) AO.** | Confirm the image-quality metric and modal search description. |
| Booth, *Wave front sensor-less adaptive optics: a model-based approach using sphere packings*, Opt. Express 14, 1339, 2006. DOI `10.1364/oe.14.001339` | F | Optional companion for sensorless modal optimisation. | Needed only if Débarre does not explain the principle. |
| Neil, Juškaitis, Booth and Wilson, *Adaptive aberration correction in a two-photon microscope*, J. Microsc. 200, 105-108, 2000. DOI `10.1046/j.1365-2818.2000.00770.x` | F | Optional. Early demonstration of AO in a fluorescence microscope. | Historical use only. |
| Kner, Sedat, Agard and Kam, *High-resolution wide-field microscopy with adaptive optics for spherical aberration correction and motionless focusing*, J. Microsc. 237, 136-147, 2010. DOI `10.1111/j.1365-2818.2009.03315.x` | F | **Core for widefield.** AO in a widefield fluorescence microscope, the closest instrument class to the thesis (a camera, no scanning). | Check how the aberration is measured and whether it is corrected globally. |
| Scrimgeour and Curtis, *Aberration correction in wide-field fluorescence microscopy by segmented-pupil image interferometry*, Opt. Express 20, 14534-14541, 2012. DOI `10.1364/oe.20.014534` | F | **Core, new find.** Splits the emitted wavefront at the pupil plane into beams, reads the image displacement between segments as local wavefront tilt, and corrects. This is the hardware counterpart of the thesis's shift premise in widefield fluorescence. | Read closely: how the displacements are measured, how large the field is, and how it differs from the thesis (SLM at the pupil, correction applied in hardware). |
| Furieri et al., *Aberration measurement and correction on a large field of view in fluorescence microscopy*, Biomed. Opt. Express, 2021. DOI `10.1364/boe.441810` | F | **Core for spatial variation.** Field-dependent aberrations in widefield fluorescence. | Volume and pages not in the Crossref row retrieved; confirm. Supports or sharpens G27 on spatial invariance. |
| Liu et al., *Observing the cell in its native state: imaging subcellular dynamics in multicellular organisms*, Science 360, eaaq1392, 2018. DOI `10.1126/science.aaq1392` | F | Optional. AO combined with lattice light-sheet; demonstrates the benefit and complexity of hardware AO. | Crossref confirmed by DOI (direct title search did not return it). |
| Rodríguez and Ji, *Adaptive optical microscopy for neurobiology*, Curr. Opin. Neurobiol. 50, 83-91, 2018. DOI `10.1016/j.conb.2018.01.011` | F | Optional short review. | |
| Marsh, Burns and Girkin, *Practical implementation of adaptive optics in multiphoton microscopy*, Opt. Express 11, 1123, 2003. DOI `10.1364/oe.11.001123` | F | Optional; possible cost and engineering source. | |
| Azucena et al., *Wavefront aberration measurements and corrections through thick tissue using fluorescent microsphere reference beacons*, Opt. Express 18, 17521, 2010. DOI `10.1364/oe.18.017521` | F | Optional. | |

**Suggested order:** the reviews first (Booth 2014, Ji 2017, Zhang 2023 are
already in the bibliography; add Hampson 2021 and Booth 2007 only if the three
do not settle G24, G26 and G27). Then Scrimgeour and Curtis 2012, Kner 2010 and
Furieri 2021, which are the widefield and spatial-variation sources.

### C4b: PSF estimation and deconvolution in fluorescence microscopy (G25)

Already read: Broxton 2013, Stefanoiu 2019, Lu 2019 (all light-field).

| Candidate | Tag | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Sibarita, *Deconvolution microscopy*, Adv. Biochem. Eng. Biotechnol. 95, 201-243, 2005. DOI `10.1007/b102215` | F | **Core review.** Image formation, PSF, algorithm families, and their costs and artefacts in fluorescence microscopy. | Volume 95 is my recollection; Crossref row gave pages only. Check noise-amplification and PSF-dependence statements (G25). |
| McNally, Karpova, Cooper and Conchello, *Three-dimensional imaging by deconvolution microscopy*, Methods 19, 373-385, 1999. DOI `10.1006/meth.1999.0873` | F | **Core.** Compares deconvolution algorithms (inverse filters, constrained iterative) in widefield fluorescence. | Locate statements on noise amplification and on the need for an accurate PSF. |
| Sarder and Nehorai, *Deconvolution methods for 3-D fluorescence microscopy images*, IEEE Signal Process. Mag. 23(3), 32-45, 2006. DOI `10.1109/msp.2006.1628876` | F | **Core review**, signal-processing view; spatially varying PSF and blind methods. | |
| Wallace, Schaefer and Swedlow, *A working person's guide to deconvolution in light microscopy*, BioTechniques 31, 1076-1097, 2001. DOI `10.2144/01315bi01` | F | Optional practical guide. | |
| Agard, *Optical sectioning microscopy: cellular architecture in three dimensions*, Annu. Rev. Biophys. Bioeng. 13, 191-219, 1984. DOI `10.1146/annurev.bb.13.060184.001203` | F | Optional historical source for out-of-focus blur and the 3D PSF. | Crossref has two DOIs for it (`...biophys.13.1.191` and `...bb.13.060184.001203`); pick one. |
| Gibson and Lanni, *Diffraction by a circular aperture as a model for three-dimensional optical microscopy*, JOSA A 6, 1357, 1989. DOI `10.1364/josaa.6.001357`; and *Experimental test of an analytical model of aberration in an oil-immersion objective lens used in three-dimensional light microscopy*, JOSA A 8, 1601, 1991. DOI `10.1364/josaa.8.001601` | F | **Core for the PSF model.** The standard analytical PSF with refractive-index mismatch and defocus aberration terms. | Crossref also returned a 1992 JOSA A 9, 154 record for the 1991 title (probably the erratum); use the 1991 article. |
| Hanser, Gustafsson, Agard and Sedat, *Phase-retrieved pupil functions in wide-field fluorescence microscopy*, J. Microsc. 216, 32-48, 2004. DOI `10.1111/j.0022-2720.2004.01393.x` | F | **Core for PSF estimation.** Measures the PSF from a bead and retrieves the pupil function, including aberrations, from through-focus images. | Also supports C4e (defocus as a measurement). Companion: *Phase retrieval for high-numerical-aperture optical systems*, Opt. Lett. 28, 801, 2003, DOI `10.1364/ol.28.000801` (optional). |
| Kam, Hanser, Gustafsson, Agard and Sedat, *Computational adaptive optics for live three-dimensional biological imaging*, PNAS 98, 3790-3795, 2001. DOI `10.1073/pnas.071275698` | F | **Core, resolves the G25 lead.** Software (computational) correction of aberrations in widefield fluorescence, based on a measured aberrated PSF. | Check what is measured (bead PSF versus specimen) and whether the correction is spatially invariant. |
| Kirshner, Aguet, Sage and Unser, *3-D PSF fitting for fluorescence microscopy: implementation and localization application*, J. Microsc. 249(1), 13-25, 2013. DOI `10.1111/j.1365-2818.2012.03675.x` | F | Optional. Fitting a PSF model to bead data. | Crossref issue year 2012 (online) versus 2013 (volume). |
| Dey, Blanc-Féraud, Zimmer, Roux et al., *Richardson-Lucy algorithm with total variation regularization for 3D confocal microscope deconvolution*, Microsc. Res. Tech. 69, 260-266, 2006. DOI `10.1002/jemt.20294` | F | Optional. Regularisation against Richardson-Lucy noise amplification. | |
| Kenig, Kam and Feuer, *Blind image deconvolution using machine learning for three-dimensional microscopy*, IEEE TPAMI 32, 2191-2204, 2010. DOI `10.1109/tpami.2010.45` | F | Optional. Blind deconvolution when the PSF is unknown, in 3D microscopy. | |
| Kim and Naemura, *Blind depth-variant deconvolution of 3D data in wide-field fluorescence microscopy*, Sci. Rep. 5, 9894, 2015. DOI `10.1038/srep09894` | F | Optional. Depth-variant blind deconvolution. | Volume and article number are my recollection; Crossref row gave the DOI only. |
| Preza and Conchello, *Depth-variant maximum-likelihood restoration for three-dimensional fluorescence microscopy*, JOSA A 21, 1593, 2004. DOI `10.1364/josaa.21.001593` | F | Optional. Space-variant PSF in deconvolution. | Alternative: Shaevitz and Fletcher, JOSA A 24, 2622, 2007, DOI `10.1364/josaa.24.002622`. |
| Sage et al., *DeconvolutionLab2: an open-source software for deconvolution microscopy*, Methods 115, 28-41, 2017. DOI `10.1016/j.ymeth.2016.12.015` | F | Optional. Standard software; compares algorithms. | |
| Guo et al., *Rapid image deconvolution and multiview fusion for optical microscopy*, Nat. Biotechnol. 38, 1337-1346, 2020. DOI `10.1038/s41587-020-0560-x` | F | Optional. Fast deconvolution with matched back-projectors; also multiview fusion. | Overlaps with the Preibisch and Swoger multiview notes. |
| Weigert et al., *Content-aware image restoration: pushing the limits of fluorescence microscopy*, Nat. Methods 15, 1090-1097, 2018. DOI `10.1038/s41592-018-0216-7` | F | Optional representative of learned restoration. | One learned example is enough. |
| Richardson, *Bayesian-based iterative method of image restoration*, JOSA 62, 55-59, 1972. DOI `10.1364/josa.62.000055`; Lucy, *An iterative technique for the rectification of observed distributions*, Astron. J. 79, 745, 1974. DOI `10.1086/111605` | O | **Origin of the Richardson-Lucy algorithm.** Cite only if the text names the algorithm. | Not fluorescence-specific, but the standard attribution; McNally and Sibarita review its use in fluorescence. |
| Holmes, *Blind deconvolution of quantum-limited incoherent imagery: maximum-likelihood approach*, JOSA A 9, 1052, 1992. DOI `10.1364/josaa.9.001052` | M | Optional, for blind deconvolution with Poisson noise. | |
| Levin, Weiss, Durand and Freeman, *Understanding and evaluating blind deconvolution algorithms*, CVPR 2009. DOI `10.1109/cvpr.2009.5206815` | O | **Fallback** for general limits of blind deconvolution. | Use only if the microscopy blind-deconvolution sources do not cover it. |

Not found in Crossref: Krishnan and Fergus 2009 (NIPS), dropped.

**Suggested order:** Sibarita 2005 and McNally 1999 for the review-level
statements, then Kam 2001 and Hanser 2004 for PSF measurement and
computational correction, then Gibson and Lanni for the PSF model.

### Phase 3 results for C4a and C4b (2026-11-11)

All 35 PDFs the author supplied (`literature/C4a/`, `literature/C4b/`) were
checked to be the intended papers and read from their extracted text, one reader
per paper or small group. For every note, each verbatim anchor phrase was
machine-checked against the extracted text (0 missing across 35 notes and 752
anchors). I also re-read the surrounding passage for the claims that matter
most for Chapter 1 (Hampson on physical correction and isoplanatic patch size,
Dey on noise amplification, Liu on the isoplanatic patch, Wang on the guide
star), and searched all 14 AO papers for any statement that correctors are
expensive (none says so; see the gap audit). An anchor match shows the phrase is
in the paper, not that the paraphrase is right, so treat the notes as reader
output with those spot-checks. Not read: supplementary material, online methods
and figure images (captions only). Notes sit in `literature/notes/`; the claim-by-claim result is in
the [gap audit](bibliography-gap-audit.md).

**Added to `thesis.bib` (20, none cited in the text yet):**

| Key | Source | Verdict |
| --- | --- | --- |
| `booth2007adaptiveOpticsMicroscopy` | Booth 2007 | Core review (G24, G26) |
| `hampson2021adaptiveOpticsPrimer` | Hampson et al. 2021 | Core review (G24, G26, G27); article number 68 from Crossref, the manuscript prints none |
| `debarre2009imageBasedAdaptiveOptics` | Débarre et al. 2009 | Core for sensorless AO |
| `wang2015directWavefrontSensing` | Wang et al. 2015 | Core for direct sensing and its limits |
| `azucena2010microsphereReferenceBeacons` | Azucena et al. 2010 | Core for direct sensing with beacons; internally inconsistent corrected-area numbers |
| `kner2010wideFieldAdaptiveOptics` | Kner et al. 2010 | Core for widefield AO |
| `furieri2022aberrationLargeField` | Furieri et al. 2022 | Core for field-dependent aberration; the year is 2022, not 2021 |
| `liu2018nativeStateAdaptiveOptics` | Liu et al. 2018 | Core for isoplanatic patch and tiling |
| `scrimgeour2012segmentedPupilInterferometry` | Scrimgeour and Curtis 2012 | Optional: downgraded from "core" after reading (system aberration only, one static correction, nothing on field dependence); kept as the widefield hardware precedent for the shift principle |
| `sibarita2005deconvolutionMicroscopy` | Sibarita 2005 | Core review (G25); volume 95, editor Rietdorf from the Crossref volume record |
| `mcnally1999deconvolutionMicroscopy3d` | McNally et al. 1999 | Core review (G25) |
| `sarder2006deconvolutionMethods` | Sarder and Nehorai 2006 | Core review (G25) |
| `kam2001computationalAdaptiveOptics` | Kam et al. 2001 | Core for computational AO; proof of principle on beads, aberration predicted from a refractive-index map |
| `hanser2004phaseRetrievedPupil` | Hanser et al. 2004 | Core for PSF estimation from a defocus series (G25, G30) |
| `dey2006richardsonLucyTv` | Dey et al. 2006 | Core for the noise-amplification statement |
| `preza2004depthVariantRestoration` | Preza and Conchello 2004 | Core for shift-invariance failure |
| `kenig2010blindDeconvolutionLearning` | Kenig et al. 2010 | Core for blind deconvolution limits |
| `gibson1991aberrationModel` | Gibson and Lanni 1991 | Core for the aberration model (pp. 1601-1613 confirmed on the paper) |
| `wallace2001deconvolutionGuide` | Wallace et al. 2001 | Core for practical PSF and artefact statements |
| `agard1984opticalSectioning` | Agard 1984 | Core for defocus series as the basis of 3D reconstruction (G30) |

**Read but not added (15):** Rodríguez and Ji 2018, Rueckel 2006, Tao 2011, Marsh
2003, Neil 2000, Booth 2006 (all optional AO papers whose points Hampson, Booth
2007, Wang and Azucena already cover); Richardson 1972 (an origin citation that
only makes sense with Lucy 1974, which we do not have), Holmes 1992, Kim and
Naemura 2015, Kirshner 2013 (leaning drop), Sage 2017, Guo 2020, Weigert 2018,
Levin 2009 (outside microscopy, fallback), Gibson and Lanni 1989. Their notes stay
in `literature/notes/` so the decision is on record. Any of them can be added
later without further reading.

### C4c: ptychography and Fourier ptychography (G28)

Conventional angle-scanned FPM reconstructs a complex transmitted field from
measurements modeled with spatially coherent illumination for each angle
(Zheng 2013; see Konda 2020 for partial coherence). Chung 2016 estimates the
pupil in brightfield and transfers it to fluorescence deconvolution. Dong 2014
uses patterned excitation and an incoherent fluorescence transfer function.

| Candidate | Tag | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Zheng, Horstmeyer and Yang, *Wide-field, high-resolution Fourier ptychographic microscopy*, Nat. Photon. 7, 739-745, 2013. DOI `10.1038/nphoton.2013.187` | M | **Core.** Founding paper of Fourier ptychographic microscopy (FPM): angled-LED captures stitched in Fourier space. | Brightfield, coherent. |
| Ou, Zheng and Yang, *Embedded pupil function recovery for Fourier ptychographic microscopy*, Opt. Express 22, 4960, 2014. DOI `10.1364/oe.22.004960` | M | **Core for aberrations.** Recovers the pupil function (aberrations) jointly with the sample. | Check the aberration model (a pupil function, not per-view shifts). |
| Chung et al., *Wide field-of-view fluorescence image deconvolution with aberration-estimation from Fourier ptychography*, Biomed. Opt. Express 7, 352, 2016. DOI `10.1364/boe.7.000352` | F | **Core, bridges to fluorescence.** Estimates aberrations from a Fourier-ptychography brightfield acquisition and uses them to deconvolve the fluorescence image. | Needs the same optical path for both modes; compare with the thesis (no second modality). |
| Dong et al., *High-resolution fluorescence imaging via pattern-illuminated Fourier ptychography*, Opt. Express 22, 20856, 2014. DOI `10.1364/oe.22.020856` | F | Optional. Patterned illumination applied to fluorescence. | |
| Konda et al., *Fourier ptychography: current applications and future promises*, Opt. Express 28, 9603, 2020. DOI `10.1364/oe.386168` | M | **Core review.** | Check for the coherence and fluorescence discussion. |
| Zheng et al., *Concept, implementations and applications of Fourier ptychography*, Nat. Rev. Phys. 3, 207-223, 2021. DOI `10.1038/s42254-021-00280-y` | M | Alternative review. | Choose Konda or Zheng. |
| Tian and Waller, *3D intensity and phase imaging from light field measurements in an LED array microscope*, Optica 2, 104, 2015. DOI `10.1364/optica.2.000104` | M | **Optional, link to light-field imaging.** Light-field style measurements in an LED-array microscope. | |
| Horstmeyer et al., *Overlapped Fourier coding for optical aberration removal*, Opt. Express 22, 24062, 2014. DOI `10.1364/oe.22.024062` | M | Optional aberration-specific companion. | |
| Chung et al., *Computational aberration compensation by coded-aperture-based correction of aberration obtained from optical Fourier coding and blur estimation*, Optica 6, 647, 2019. DOI `10.1364/optica.6.000647` | M | Optional. | |
| Bian, Dong and Zheng, *Adaptive system correction for robust Fourier ptychographic imaging*, Opt. Express 21, 32400, 2013. DOI `10.1364/oe.21.032400` | M | Optional. | |
| Rodenburg and Faulkner, *A phase retrieval algorithm for shifting illumination*, Appl. Phys. Lett. 85, 4795-4797, 2004. DOI `10.1063/1.1823034` | O | Optional origin of ptychography; with Faulkner and Rodenburg, PRL 93, 023903, 2004, DOI `10.1103/physrevlett.93.023903`. | Only if the text traces the technique to its source. |
| Maiden and Rodenburg, *An improved ptychographical phase retrieval algorithm for diffractive imaging*, Ultramicroscopy 109, 1256-1262, 2009. DOI `10.1016/j.ultramic.2009.05.012`; Thibault et al., Science 321, 379-382, 2008. DOI `10.1126/science.1158573` | O | Optional, outside microscopy. | Skip unless the text discusses the algorithm family. |

**Suggested order:** Zheng 2013, Ou 2014 and Chung 2016 first, then one review
(Konda 2020). Tian and Waller 2015 only if the text wants a light-field link.

### C4d: structured illumination microscopy (G29)

| Candidate | Tag | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Gustafsson, *Surpassing the lateral resolution limit by a factor of two using structured illumination microscopy*, J. Microsc. 198, 82-87, 2000. DOI `10.1046/j.1365-2818.2000.00710.x` | F | **Core.** Founding paper of resolution-doubling SIM. | |
| Neil, Juškaitis and Wilson, *Method of obtaining optical sectioning by using structured light in a conventional microscope*, Opt. Lett. 22, 1905, 1997. DOI `10.1364/ol.22.001905` | F | **Core for optical sectioning** with structured illumination (out-of-focus rejection). | |
| Gustafsson et al., *Three-dimensional resolution doubling in wide-field fluorescence microscopy by structured illumination*, Biophys. J. 94, 4957-4970, 2008. DOI `10.1529/biophysj.107.120345` | F | **Core for 3D-SIM.** | |
| Wu and Shroff, *Faster, sharper, and deeper: structured illumination microscopy for biological imaging*, Nat. Methods 15, 1011-1019, 2018. DOI `10.1038/s41592-018-0211-z` | F | **Core review.** | |
| Débarre, Botcherby, Booth and Wilson, *Adaptive optics for structured illumination microscopy*, Opt. Express 16, 9290, 2008. DOI `10.1364/oe.16.009290` | F | **Core, links SIM and aberrations.** Shows aberrations degrade SIM and adaptive optics restores it. | |
| Thomas et al., *Enhanced resolution through thick tissue with structured illumination and adaptive optics*, J. Biomed. Opt. 20, 026006, 2015. DOI `10.1117/1.jbo.20.2.026006` | F | Optional companion for thick tissue. | PDF confirms article 026006. |
| Ayuk et al., *Structured illumination fluorescence microscopy with distorted excitations using a filtered blind-SIM algorithm*, Opt. Lett. 38, 4723, 2013. DOI `10.1364/ol.38.004723`; Mudry et al., *Structured illumination microscopy using unknown speckle patterns*, Nat. Photon. 6, 312-315, 2012. DOI `10.1038/nphoton.2012.83` | F | Optional. SIM that tolerates distorted or unknown illumination patterns. | |
| Gustafsson, *Nonlinear structured-illumination microscopy*, PNAS 102, 13081-13086, 2005. DOI `10.1073/pnas.0406877102` | F | Optional. | |
| Demmerle et al., *Strategic and practical guidelines for successful structured illumination microscopy*, Nat. Protoc. 12, 988-1010, 2017. DOI `10.1038/nprot.2017.019` | F | Optional. Artefact sources in practice. | |
| Wilson, *Optical sectioning in fluorescence microscopy*, J. Microsc. 242, 111-116, 2011. DOI `10.1111/j.1365-2818.2010.03457.x` | F | Optional. PDF confirms the 2011 issue year. | |
| Heintzmann and Cremer, *Laterally modulated excitation microscopy*, Proc. SPIE 3568, 185-196, 1999. DOI `10.1117/12.336833` | F | Optional priority attribution. | |
| Chen et al., *Lattice light-sheet microscopy: imaging molecules to embryos at high spatiotemporal resolution*, Science 346, 1257998, 2014. DOI `10.1126/science.1257998` | F | Optional. Related, not SIM proper (lattice light sheet with a structured-illumination mode). | Crossref confirmed by DOI. |

**Suggested order:** Gustafsson 2000, Neil 1997 and Wu and Shroff 2018 (one
paragraph); Débarre 2008 if the text mentions aberrations in SIM.

### C4e: defocus, phase diversity and phase retrieval for aberration estimation and 3D (G30)

| Candidate | Tag | Role | Check in Phase 3 |
| --- | --- | --- | --- |
| Hanser et al. 2004 and Kam et al. 2001 (see C4b) | F | **Core for distinct roles.** Hanser retrieves the pupil from through-focus bead images. Kam predicts aberration by ray tracing through a DIC-derived refractive-index map and uses bead stacks for comparison. | |
| Agard 1984 (see C4b) | F | Defocus blur as the basis of optical sectioning and 3D reconstruction by deconvolution. | |
| Kao and Verkman, *Tracking of single fluorescent particles in three dimensions: use of cylindrical optics to encode particle position*, Biophys. J. 67, 1291-1300, 1994. DOI `10.1016/s0006-3495(94)80601-0` | F | **Core for PSF engineering.** Astigmatism encodes depth. | |
| Huang, Wang, Bates and Zhuang, *Three-dimensional super-resolution imaging by stochastic optical reconstruction microscopy*, Science 319, 810-813, 2008. DOI `10.1126/science.1153529` | F | Optional. Astigmatic depth encoding in localisation microscopy. | |
| Pavani et al., *Three-dimensional, single-molecule fluorescence imaging beyond the diffraction limit by using a double-helix point spread function*, PNAS 106, 2995-2999, 2009. DOI `10.1073/pnas.0900245106` | F | Optional. Engineered PSF for depth. | |
| Möckl, Petrov and Moerner, *Accurate phase retrieval of complex 3D point spread functions with deep residual neural networks*, Appl. Phys. Lett. 115, 251106, 2019. DOI `10.1063/1.5125252` | F | Optional. Learned PSF phase retrieval for single-molecule microscopy. | PDF cover confirms article 251106. |
| Paxman, Schulz and Fienup, *Joint estimation of object and aberrations by using phase diversity*, JOSA A 9, 1072, 1992. DOI `10.1364/josaa.9.001072` | O | **Core origin of phase diversity** (a known defocus as a diversity measurement); with Gonsalves, *Phase retrieval and diversity in adaptive optics*, Opt. Eng. 21, 829-832, 1982, DOI `10.1117/12.7972989`. | Astronomy and general optics; use only if no microscopy source for the idea is found (Hanser covers through-focus pupil retrieval from a known bead). |
| Fienup, *Phase retrieval algorithms: a comparison*, Appl. Opt. 21, 2758, 1982. DOI `10.1364/ao.21.002758` | O | Optional. | |
| Teague, *Deterministic phase retrieval: a Green's function solution*, JOSA 73, 1434, 1983. DOI `10.1364/josa.73.001434`; Waller, Tian and Barbastathis, Opt. Express 18, 12552, 2010. DOI `10.1364/oe.18.012552` | M | Optional. Transport of intensity: phase from defocused intensity images. | Quantitative phase, not fluorescence. |
| Dowski and Cathey, *Extended depth of field through wave-front coding*, Appl. Opt. 34, 1859, 1995. DOI `10.1364/ao.34.001859` | O | Optional. Related light-field item: Cohen 2014 in C1. | |
| Paine and Fienup, Opt. Lett. 43, 1235, 2018. DOI `10.1364/ol.43.001235`; Nishizaki et al., Opt. Express 27, 240, 2019. DOI `10.1364/oe.27.000240` | O | Optional. Learned image-based wavefront sensing. | |
| Pentland, *A new sense for depth of field*, IEEE TPAMI PAMI-9, 523-531, 1987. DOI `10.1109/tpami.1987.4767940`; Subbarao and Surya, IJCV 13, 271-294, 1994. DOI `10.1007/bf02028349`; Nayar and Nakagawa, *Shape from focus*, IEEE TPAMI 16, 824-831, 1994. DOI `10.1109/34.308479` | O | **Fallback** for depth from defocus and shape from focus in computer vision. | Use only if a fluorescence-microscopy source is not found for the 3D-from-defocus claim. A web search found no fluorescence review of depth from defocus; the nearest are depth-variant deconvolution papers (Kim and Naemura 2015, Preza and Conchello 2004). |
| Tao et al., *Depth from combining defocus and correspondence using light-field cameras*, ICCV 2013. DOI `10.1109/iccv.2013.89` | O | Optional; combines defocus with correspondence in a light field. Already listed in C3. | |

**Suggested order:** Hanser for pupil estimation and Agard for focal-stack
reconstruction, then Kao and Verkman if explaining engineered depth encoding.
Huang and Pavani are reserve examples for a single-molecule comparison.

### Phase 3 results for C4c-C4e (2026-11-11)

All 39 supplied PDFs have one linked research note apiece (12 C4c, 13 C4d,
14 C4e). The review used extracted main-text passages and checked two
search locators per note. Figure images and separate supplements were outside
the review. The bibliography now has nine new entries for use when the
corresponding claims are drafted. Chapter 2 has about two prose pages total,
so the bibliography is a source pool. Use the primary experiment for each
claim and a review only where an overview earns its space. Keep microscope
principles and model limits in Chapter 3 within the shared allowance for
Chapters 3, 6 and 7.

C4e also reuses three earlier notes and entries. [Hanser 2004](../literature/notes/hanser-2004-phase-retrieved-pupil-functions.md)
covers bead-based pupil estimation, [Agard 1984](../literature/notes/agard-1984-optical-sectioning-microscopy.md)
covers focal-stack reconstruction, and [Kam 2001](../literature/notes/kam-2001-computational-adaptive-optics.md)
covers index-map-based computational correction.

Four optional candidates have no supplied PDF and were outside the full-text
review. Faulkner and Rodenburg's *Physical Review Letters* paper and Thibault
et al. are in C4c. Gonsalves and Nishizaki et al. are in C4e. The supplied
Rodenburg and Faulkner *Applied Physics Letters* paper is a distinct work.

#### Author decisions

1. **Direct fluorescence FP adaptation.** Add Dong 2014 if the comparison names
   patterned fluorescence FP as a separate approach. For aberration correction
   by transfer from brightfield, Chung 2016 is the relevant source.
2. **How far to take SIM.** Add Gustafsson 2008 if stating axial as well as
   lateral resolution doubling. Add Thomas 2015 if the comparison needs
   super-resolution SIM through a biological aberrator, or Ayuk 2013 if the
   contrast is computational recovery with distorted excitation patterns.
3. **Which use of defocus belongs in the comparison.** Add Paxman 1992 if
   discussing joint object and aberration estimation with known phase diversity.
   Add Tao 2013 if explicitly comparing light-field depth from defocus and
   correspondence. Hanser, Agard and Kao/Verkman cover the narrower fluorescence
   points.

#### Full-read addendum (2026-11-11)

The 39 shorter notes from the first pass were replaced with full-read notes (same
filenames and links; the first-pass "Thesis use" line is kept at the end of each
note under "Triage from the first C4c-C4e pass"). Each note carries page locators
and a verbatim anchor phrase per claim; the anchors were machine-checked against
the extracted text (6 of about 580 did not match because of column interleaving
or hyphenation in the extraction; the facts were confirmed by hand). Not read:
supplements, online methods, figure images. Further entries were added to
`thesis.bib` (none cited yet): `chung2019cacaoFb`, `zheng2021fourierPtychographyReview`,
`dong2014patternIlluminatedFluorescence`, `maiden2009extendedPie`,
and `gustafsson2008threeDimSim`; `paxman1992phaseDiversity` was added and then dropped on the author's decision (see below). The dispositions in
the inventory below are the first-pass ones; where a source is now also in the
bibliography it is listed here. The "Author decision" items are settled (below).

What the full reads changed:
- Zheng 2013 states Fourier ptychographic microscopy is not a fluorescence
  technique; Maiden 2009 states high coherence is required. Konda 2020 and Zheng
  2021 show fluorescence variants (patterned illumination, deconvolution with an
  FP-recovered pupil), 4 to 137 images, and single-shot variants. Write "basic
  LED-array FP needs coherent illumination and sequential captures".
- Chung 2019 says severe aberration changes the local PSF shape, not just its
  shift (p. 657), which bears on the shift premise.
- FP aberration correction is one pupil per tile, with tiles treated as
  space-invariant (Ou 2014, Chung 2016, Bian 2013); Bian uses three Zernike modes.
- Dong 2014, Chung 2016 and Chung 2019 are the fluorescence-related sources; none
  is single-shot.
- Débarre 2008 explains why aberrations hurt SIM; Thomas 2015 corrects one
  field-wide aberration and notes the isoplanatic patch.
- Kao, Huang and Pavani decode depth from calibrated images of sparse emitters
  (not dense scenes); Paxman 1992 has no experiments; depth from defocus and shape
  from focus are fallbacks outside microscopy.

**Author decisions settled (2026-11-11):**

1. Direct fluorescence FP adaptation: add both Dong 2014 and Chung 2016.
2. SIM: add Gustafsson 2008 and Thomas 2015; do not add Ayuk 2013.
3. Defocus: drop Paxman 1992; add Tao 2013 together with Hanser 2004, Agard 1984
   and Kao and Verkman 1994 (the last three were already added).

Huang 2008 and Pavani 2009 stay in reserve. Phase diversity is therefore not in
the bibliography.

#### PDF-to-note inventory

| Group | Paper and research note | Disposition |
| --- | --- | --- |
| C4c | [Bian, Dong and Zheng (2013)](../literature/notes/bian-2013-adaptive-fourier-ptychography.md) | Reserve |
| C4c | [Chung et al. (2019)](../literature/notes/chung-2019-cacao-fb.md) | Reserve |
| C4c | [Chung et al. (2016)](../literature/notes/chung-2016-fpm-fluorescence-deconvolution.md) | Added as `chung2016fpmFluorescenceDeconvolution` |
| C4c | [Dong et al. (2014)](../literature/notes/dong-2014-pattern-illuminated-fluorescence.md) | Added as `dong2014patternIlluminatedFluorescence` (author decision 2026-11-11) |
| C4c | [Horstmeyer et al. (2014)](../literature/notes/horstmeyer-2014-overlapped-fourier-coding.md) | Reserve |
| C4c | [Konda et al. (2020)](../literature/notes/konda-2020-fourier-ptychography-review.md) | Added as `konda2020fourierPtychographyReview` |
| C4c | [Maiden and Rodenburg (2009)](../literature/notes/maiden-rodenburg-2009-extended-pie.md) | Reserve |
| C4c | [Ou, Zheng and Yang (2014)](../literature/notes/ou-2014-embedded-pupil-recovery.md) | Added as `ou2014embeddedPupilRecovery` |
| C4c | [Rodenburg and Faulkner (2004)](../literature/notes/rodenburg-faulkner-2004-shifting-illumination.md) | Reserve |
| C4c | [Tian and Waller (2015)](../literature/notes/tian-waller-2015-led-array-light-field.md) | Reserve |
| C4c | [Zheng et al. (2021)](../literature/notes/zheng-2021-fourier-ptychography-review.md) | Reserve |
| C4c | [Zheng, Horstmeyer and Yang (2013)](../literature/notes/zheng-2013-fourier-ptychographic-microscopy.md) | Added as `zheng2013fourierPtychographicMicroscopy` |
| C4d | [Chen et al. (2014)](../literature/notes/chen-2014-lattice-light-sheet.md) | Reserve |
| C4d | [Débarre et al. (2008)](../literature/notes/debarre-2008-adaptive-optics-sim.md) | Added as `debarre2008adaptiveOpticsSim` |
| C4d | [Demmerle et al. (2017)](../literature/notes/demmerle-2017-sim-guidelines.md) | Reserve |
| C4d | [Gustafsson et al. (2008)](../literature/notes/gustafsson-2008-3d-sim.md) | Added as `gustafsson2008threeDimSim` (author decision 2026-11-11) |
| C4d | [Gustafsson (2005)](../literature/notes/gustafsson-2005-nonlinear-sim.md) | Reserve |
| C4d | [Gustafsson (2000)](../literature/notes/gustafsson-2000-lateral-sim.md) | Added as `gustafsson2000lateralSim` |
| C4d | [Heintzmann and Cremer (1999)](../literature/notes/heintzmann-cremer-1999-modulated-excitation.md) | Reserve |
| C4d | [Wilson (2011)](../literature/notes/wilson-2011-fluorescence-sectioning.md) | Reserve |
| C4d | [Mudry et al. (2012)](../literature/notes/mudry-2012-unknown-speckle-sim.md) | Reserve |
| C4d | [Neil, Juškaitis and Wilson (1997)](../literature/notes/neil-1997-structured-light-sectioning.md) | Added as `neil1997structuredLightSectioning` |
| C4d | [Ayuk et al. (2013)](../literature/notes/ayuk-2013-filtered-blind-sim.md) | Not added (author decision 2026-11-11) |
| C4d | [Thomas et al. (2015)](../literature/notes/thomas-2015-sim-ao-thick-tissue.md) | Added as `thomas2015simAdaptiveOpticsThickTissue` (author decision 2026-11-11) |
| C4d | [Wu and Shroff (2018)](../literature/notes/wu-shroff-2018-sim-perspective.md) | Added as `wuShroff2018simPerspective` |
| C4e | [Dowski and Cathey (1995)](../literature/notes/dowski-cathey-1995-wavefront-coding.md) | Reserve |
| C4e | [Fienup (1982)](../literature/notes/fienup-1982-phase-retrieval.md) | Reserve |
| C4e | [Huang et al. (2008)](../literature/notes/huang-2008-astigmatic-3d-storm.md) | Reserve |
| C4e | [Kao and Verkman (1994)](../literature/notes/kao-verkman-1994-astigmatic-particle-tracking.md) | Added as `kaoVerkman1994astigmaticTracking` |
| C4e | [Möckl, Petrov and Moerner (2019)](../literature/notes/mockl-2019-learned-psf-phase-retrieval.md) | Reserve |
| C4e | [Nayar and Nakagawa (1994)](../literature/notes/nayar-nakagawa-1994-shape-from-focus.md) | Reserve |
| C4e | [Paine and Fienup (2018)](../literature/notes/paine-fienup-2018-learned-wavefront-initialization.md) | Reserve |
| C4e | [Pavani et al. (2009)](../literature/notes/pavani-2009-double-helix-psf.md) | Reserve |
| C4e | [Paxman, Schulz and Fienup (1992)](../literature/notes/paxman-1992-joint-phase-diversity.md) | Dropped (author decision 2026-11-11) |
| C4e | [Pentland (1987)](../literature/notes/pentland-1987-depth-from-defocus.md) | Reserve |
| C4e | [Subbarao and Surya (1994)](../literature/notes/subbarao-surya-1994-depth-from-defocus.md) | Reserve |
| C4e | [Tao et al. (2013)](../literature/notes/tao-2013-light-field-depth.md) | Added as `tao2013defocusCorrespondence` (author decision 2026-11-11) |
| C4e | [Teague (1983)](../literature/notes/teague-1983-transport-of-intensity.md) | Reserve |
| C4e | [Waller, Tian and Barbastathis (2010)](../literature/notes/waller-2010-transport-of-intensity.md) | Reserve |

### Not found by Crossref or not located

- Gerchberg and Saxton, *Optik* 35, 237, 1972 (no DOI in the index).
- Hampson et al. 2021: two records, see C4a.

## Suggested first additions

If the aim is the smallest set that closes the largest gaps without crowding
Chapter 2: Levoy/Hanrahan 1996 (replacement), Zitová and Flusser, Guizar-Sicairos,
Horn and Schunck, Scharstein and Szeliski, Jeon et al., Szeliski (C3); Platt and
Shack, Wu et al., and the resolved Ng/Hanrahan venue (C2); Wang et al., Lu 2019,
Cong et al. (C1). That is about 12 new or changed entries; the audit's
planning estimate was 11-18.

## Search constraints

- The two `research-desk` lookup servers failed to connect again this session
  (one closed, one rate-limited). Reconnects are queued; if they succeed the
  metadata can be cross-checked there. This list used Crossref and general
  web search instead.
- Crossref confirms that a record exists and what it says. It cannot confirm that
  a paper says what the thesis would attribute to it.
