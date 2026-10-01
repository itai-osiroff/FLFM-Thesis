# Chapter 3 plan: FLFM forward model and sampling geometry

> **Status:** proposed plan for author review; not chapter prose
>
> **Prepared:** 2026-10-01
>
> **Target:** [03_light_field_model.tex](../overleaf/main/03_light_field_model.tex)
>
> **Scope:** paragraph purposes, citation placement, equation requirements, and figure specifications only. No finalized paragraphs, captions, equations, or figure assets are supplied.

## 1. Chapter contract

**Question to answer:** How does the FLFM measurement become an indexed collection of elemental views, and which physical and geometric assumptions permit treating those views as observations of one nominally two-dimensional fluorescent scene?

**Recommended working title:** *FLFM Forward Model and Sampling Geometry*, following the [thesis outline](thesis-outline.md). The current `.tex` title is *Light Field Microscopy Model*; changing it is a later editorial action.

**Intended endpoint:** a reader can distinguish the object, optical measurement, extracted view array, and reference image grid; understand what the displacement approximation retains; and recognize which information the rectification method does not estimate.

**Recommended depth:** approximately 2,600 words of eventual body text, 24 paragraphs, three original conceptual figures, and one compact notation table. The word allocations below are pacing guides, not fixed paragraph lengths. Keep the optical model explicit enough to justify the data representation without reproducing a complete volumetric deconvolution derivation.

**Organizing distinction:** physical image formation → sampled measurement → thesis modeling approximation → interface to the method. The forward model explains the observations; it is not an objective function that the Chapter 5 implementation solves.

### Boundaries with adjacent chapters

| Destination | Keep there; use only a short cross-reference here |
| --- | --- |
| Chapter 2 | Imaging-modality survey, LFM history, broad reconstruction literature, and biological motivation. |
| Chapter 4 | Tissue-specific aberration and scattering mechanisms, their physical interpretation, and stronger correction models. |
| Chapter 5 | Global correlation, thresholding, local score, candidate search, reference construction, interpolation, boundary handling, and the two sequential means. |
| Chapter 6 | Installed component values, measured geometry, camera settings, sample preparation, extraction calibration, dataset-specific preprocessing, and evaluation protocol. |
| Chapter 7 | Actual improvement, bead separability, resolution, or camera-comparison claims. |
| Appendix | A longer optical derivation only if later needed to support a main-text equation. |

The existing [Chapter 5](../overleaf/main/05_reconstruction_method.tex) already provides the pipeline figure and estimator equations. Chapter 3 should establish their input and interpretation, not repeat that explanation. Preserve the Technion template. Apply [Hadar's comparative role](../literature/thesis-examples/hadar-reference-standard.md) to pacing and completeness; do not import scientific content or figures from that thesis.

## 2. Evidence packet and citation plan

### Reading status and provenance

Repository baseline inspected: `FLFM-Thesis` commit `08e3298251d1a7aa850dd5180faf9e9af8d0004a`; working tree initially clean. The chapter contains a title and a short placeholder. Chapters 1, 5, and 6, the relevant planning records, literature notes, and method-note index were inspected for scope and notation.

ARS-Codex 3.22.0 was used through its `academic-paper` outline workflow and Structure Architect guidance, adapted to this bounded thesis-planning request. This is an inline planning exercise, not a formal Material Passport, independent review, retraction audit, or submission assessment. `criteria_binding_unavailable`: no institution-specific ARS review-criteria binding was supplied. The local writing standard and technical-stage worksheet guide completeness.

The literature entries below distinguish passages inspected in this session from material still to inspect. No assertion is made about the author's reading history. Publisher/author article text is the evidence; repository reading notes are navigation aids.

### Citation register

All five keys below exist in [the active bibliography](../overleaf/back/thesis.bib). Some older planning notes still point to `overleaf/refs/thesis.bib`; use `overleaf/back/thesis.bib` when drafting.

| ID / existing BibTeX key | Inspected primary passage and access | Assigned use and boundary |
| --- | --- | --- |
| **S1** — `levoy2009recordingControlling4d` | Levoy, Zhang & McDowall (2009), *Recording and controlling the 4D light field in a microscope using microlens arrays*, DOI [10.1111/j.1365-2818.2009.03195.x](https://doi.org/10.1111/j.1365-2818.2009.03195.x). Inspected indexed primary-PDF text, pp. 145–146, “The four-dimensional light field,” Fig. 2 and adjacent orthographic-view discussion. [Author-hosted PDF](https://graphics.stanford.edu/papers/lfillumination/levoy-lfillumination-jmicr09-lores.pdf). | Geometric coordinates and view interpretation, P03. Its image-plane LFM geometry must not become the FLFM extraction rule. The radiance argument concerns appropriate propagation regions, not propagation through the thesis's scattering medium. |
| **S2** — `guo2019fourierLightField` | Guo et al. (2019), *Fourier light-field microscopy*, DOI [10.1364/OE.27.025573](https://doi.org/10.1364/OE.27.025573). Inspected publisher-provided article text: §§2.1–2.2 and Fig. 1 caption; §2.4; parameter definitions in §4. [Inspected publisher text hosted on ResearchGate](https://www.researchgate.net/publication/335415040_Fourier_light-field_microscopy). | Pupil-conjugate encoding, P05–P06; forward-model/reconstruction distinction, P16. Their unified PSF and deconvolution describe their optical model and procedure, not established properties of this instrument under tissue degradation. |
| **S3** — `galdon2022fourierLightfieldDesignGuide` | Galdón et al. (2022), *Fourier lightfield microscopy: a practical design guide*, DOI [10.1364/AO.453723](https://doi.org/10.1364/AO.453723). Inspected author-uploaded article text: §2, Fig. 1 caption, Eq. (1), and the effective-aperture and resolution discussion through Eqs. (5)–(6). [Inspected author copy](https://www.researchgate.net/publication/358915340_Fourier_lightfield_microscopy_a_practical_design_guide); [institutional PDF](https://www.uv.es/imaging3/PDFs/2022_AO_61_2558.pdf). | Pupil occupancy, field-stop purpose, and sampling tradeoffs, P07/P09–P10/P12. Transfer of numerical formulas to the local relay arrangement remains conditional. Do not import their recommended view count as a requirement for this thesis. |
| **S4** — `yun2023flfmSetupGuide` | Yun et al. (2023), *Practical guide for setting up a Fourier light-field microscope*, DOI [10.1364/AO.491369](https://doi.org/10.1364/AO.491369). Inspected [publisher abstract and metadata](https://opg.optica.org/ao/abstract.cfm?origin=search&uri=ao-62-16-4228). **Abstract only**; detailed setup procedure and figures not inspected. | P08: broad requirement for double optical conjugation and NA matching. No detailed alignment steps, tolerances, equation numbers, or figure reuse until full-text inspection. |
| **S5** — `broxton2013waveOpticsLfm` | Broxton et al. (2013), *Wave optics theory and 3-D deconvolution for the light field microscope*, DOI [10.1364/OE.21.025418](https://doi.org/10.1364/OE.21.025418). Inspected primary text in §3.1 around Eq. (2), including incoherent intensity addition and stated monochromatic/non-scattering assumptions; §3.2 discretization opening; §3 inverse-problem framing. [Inspected publisher text](https://www.researchgate.net/publication/258036313_Wave_optics_theory_and_3-D_deconvolution_for_the_light_field_microscope). | Intensity-model foundation and discretization, P02/P13–P15. This is conventional LFM; its full PSF and scattering assumptions are not evidence of the local FLFM system's transfer function. |

Access limitation: several DOI/PMC opens failed, and the institutional Galdón PDF exceeded the browsing tool's size limit. The inspected alternative copies are identified above. Equation typography should be checked against a rendered primary page before any later transcription; none is transcribed into this plan.

### Internal evidence and authorial assumptions

| ID | Authoritative pointer | Permitted role |
| --- | --- | --- |
| **I1** | [Method-note index](../research-context/method-notes/rectification-pipeline/README.md), including the thesis-use boundary dated 2026-09-27. | Establish the chosen global-then-local scope, intermediate global-stage mean, and final rectified mean. |
| **I2** | [September 25 source account](../research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md), §§2–3, 5.6, 6, 13 and 15; `algo` commit `d0e08634e71ca0ecc4766e46de9e33d2d351d06a`. | Recorded array axes, extraction orientation, backward sampling, and limitations at that observation. This session inspected the account, not a fresh algorithm checkout. No attribution to a historical experiment without its run record. |
| **I3** | [Physical-system account](../research-context/physical-system-composition.md), author clarifications and source records dated 2026-09-27. | Relayed-pupil architecture and distinction between installed array and usable views. Design values and recorded author statements retain their evidence status. |
| **I4** | [Claim tracker](claim-tracker.md), [synthesis map](chapter-synthesis-map.md), and current Chapters 5–6. | Chapter responsibilities and consistency checks. Draft prose is not independent proof of instrument performance. |
| **A1** | Proposed chapter assumption, consistent with the current thesis scope. | Nominally 2D scene and an image-domain correspondence approximation. Must be declared as an approximation, not represented as a literature-validated result for every acquisition. |

**Citation placement rule:** attach each citation to the physical statement it supports. Cite a primary source before introducing an adapted relation; identify the adaptation separately. Use internal provenance for implementation statements and an explicit assumption label for A1. A citation cluster cannot validate the whole chain from ideal optics through tissue to successful reconstruction.

**Sources intentionally not added:** Hua 2021, Goodman, Jacques, adaptive-optics reviews, and scattering-aware LFM remain available for adjacent chapters. They are unnecessary for this chapter's core argument unless its scope changes. The unidentified local FLFM survey and unverified writing report are not thesis references. Hadar remains a comparative writing reference.

## 3. Paragraph-by-paragraph plan

Each row is an instruction for a later drafting pass, not a proposed topic sentence. S/I/A identifiers refer to the explicit evidence register above. Equation and figure IDs are planning labels, not assigned thesis numbers.

### 3.1 Measured quantity and coordinate systems — P01–P04, about 400 words

**Purpose:** establish the objects being modeled before introducing an optical transformation.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P01** | Open with the chapter question and a map of specimen → sensor frame → extracted views. Identify the eventual 2D output as the computational target. Separate that target from what the camera directly measures. | I1/I4 and A1; no external citation needed for the chapter's own scope. | Orient the reader toward F3-A and F3-B; next define the measured quantity. |
| **P02** | Define fluorescence emission, detected intensity, and camera values as distinct quantities. Specify which quantity the model uses. Reserve exposure, gain, offsets, and spectral integration for explicit factors or clearly stated simplifications. | S5 §3.1 at the intensity-superposition premise; I3 for unresolved local filtering. | Prepare E3-C. Do not substitute the reported 488 nm excitation wavelength for an emission wavelength. |
| **P03** | Introduce two spatial and two directional/pupil coordinates as geometric bookkeeping. Name the two planes or equivalent position-direction convention. Explain the microscope-view interpretation without repeating the Chapter 2 tutorial. | S1 pp. 145–146 immediately after the coordinate interpretation. | T3-N; optional small coordinate inset in F3-A. Next distinguish continuous coordinates from indices. |
| **P04** | Define view indices, within-view row/column coordinates, the image domain, and stack shape. Identify sensor coordinates separately. State the selected indexing convention and where the array-axis mapping will be documented. | I2 §2 and current Chapter 5; mark the cross-chapter discrepancy in §7 below. | E3-A and T3-N. Next explain what physically generates a view. |

### 3.2 Pupil sampling and elemental-view formation — P05–P08, about 450 words

**Purpose:** connect the optical layout to the meaning of a view without turning the section into a component inventory.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P05** | Contrast the microlens-plane locations only as needed to explain this architecture. Trace collection, pupil relay, microlens array, and sensor-conjugate image plane. Distinguish a Fourier-plane field description from the camera's intensity measurement. | S2 §§2.1–2.2; I3 for the project's relay-group roles. Keep literature geometry and local layout explicitly distinguishable. | F3-A optical-path panel. Do not insert unverified local field stops or filters. |
| **P06** | Define one elemental view through its selected pupil region and corresponding sensor image. Explain why the view index and a pixel index encode different coordinates. | S2 §2.2 and Fig. 1 caption, attached to the encoding statement. | F3-A pupil-to-view correspondence. Next qualify how finite pupil support affects sampling. |
| **P07** | Explain finite sub-aperture support and the resulting limitation on each view. Distinguish lenslets manufactured, lenslets illuminated, and views retained computationally. | S3 §2; I3 for the installed-array versus usable-view distinction. | F3-A pupil inset. Do not infer the acquisition's N from the physical 10×10 array. |
| **P08** | Name the conjugation and aperture-matching conditions that the ideal layout requires. Separate these assumptions from a measured calibration of the present instrument. | S4 abstract supports the broad requirements only. I3 and the Chapter 6 open questions identify local gaps. | Close F3-A. Lead into the consequences for spatial and angular sampling. |

### 3.3 Sampling, calibration, and the extracted view grid — P09–P12, about 450 words

**Purpose:** connect the ideal optical picture to the finite array supplied to reconstruction.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P09** | Explain the spatial-angular allocation for a fixed design. Keep array dimensions, optical resolving power, and reconstructed-image appearance separate. Avoid a universal formula equating view count with achieved resolution. | S3 §2 at the optical tradeoff; E3-A for array bookkeeping. | F3-A/F3-B; next define spatial scale. |
| **P10** | List the quantities needed to convert sensor sampling into an object-plane distance: pixel pitch, effective magnification, relay mapping, and extraction/resampling scale. Identify the necessary emission-band information for any optical-resolution estimate. | S3 §2, especially the magnification and sampling relations; local values require Chapter 6 evidence. | E3-B, conditional. No numerical resolution or micrometre scale without calibration. |
| **P11** | Describe raw-frame extraction as a calibrated coordinate operation. Specify center, patch geometry, orientation, and retained indices. Explain the output axes without describing the interactive user interface or HDR algorithm. | I2 §§2–3 at the extraction description. Record the cited revision in the planning provenance. | F3-B and E3-A. Avoid treating extraction as a reshape unless the actual operation supports that claim. |
| **P12** | Identify overlap, clipping, incomplete illumination, and calibration mismatch as conditions to check when interpreting the grid. Distinguish literature design constraints from documented failures in local data. | S3 §2 for field-stop/overlap purpose; I2/I3 for local requirements. Actual failures need a selected acquisition. | F3-B boundary markers. Lead from discrete sampling to a physical intensity model. |

### 3.4 A bounded fluorescence forward model — P13–P16, about 500 words

**Purpose:** state how an object produces measurements while keeping the thesis's estimator separate.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P13** | Define the nonnegative object quantity on a reference plane and declare the nominally 2D approximation. Explain what must be negligible or unresolved for that reduction to be useful. Do not equate physical thickness with exact planarity. | A1 and current thesis scope; S5 supplies general image-formation context, not evidence that this specimen satisfies A1. | T3-N; inputs for E3-C. Axial extent and validity evidence remain open. |
| **P14** | Introduce an intensity response kernel and an integral/sum connecting the object to each measurement. State its domain and whether it includes throughput and pixel integration. Keep it spatially varying unless a stronger reduction is justified. | S5 §3.1 for the general superposition form. Identify restriction to a plane and elemental-view indexing as the thesis's adaptation. | E3-C. Do not present the kernel as calibrated or estimated by this project. |
| **P15** | Explain conversion to pixels, detector background, and a residual/noise term. Separate uncertainty in the optical model from detector noise. Specify units and avoid assigning Gaussian, independent, or Poisson statistics by default. | S5 §3.2 supports discretization; actual detector corrections/distribution require acquisition evidence. | E3-C definitions; optional discrete shorthand only if it helps. Next distinguish this descriptive model from inversion. |
| **P16** | Briefly locate volumetric PSF inversion in the literature, then identify exactly which model objects the current method does not recover. Explain why a common convolution kernel is an additional assumption. | S2 §2.4 for its reconstruction formulation; I1/I2 for local method scope. | No Richardson–Lucy update or generic inverse objective. Transition to the simpler correspondence approximation. |

### 3.5 Image correspondence and the displacement approximation — P17–P22, about 600 words

**Purpose:** make the physical-to-computational simplification explicit and bounded.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P17** | Introduce a latent common image on a chosen reference grid. Distinguish it from fluorophore density, an external-camera image, and an already measured ground truth. List the structural correspondence the approximation requires. | A1; I2 §13 for implementation interpretation. Do not cite a paper as validation of the local approximation. | Prepare E3-D and F3-C. |
| **P18** | Describe the approximate correspondence after mapping each view into the reference grid, with a residual for unmatched content. Identify brightness comparability as an assumption. Do not imply the method estimates gain/background maps just because a richer physical model can include them. | A1 and I2 §§5.6/13. | E3-D. Residual must not be called detector noise alone. |
| **P19** | Fix forward feature motion versus backward lookup, axis order, and the pixel grid carrying displacement units. Include one simple conceptual sign check in the drafting specification. | I2 §§2/5.6; match current Chapter 5. | F3-C sampling inset and E3-D. Do not infer an inverse map by merely changing a sign. |
| **P20** | Explain, at the model level, why a uniform offset and a spatially varying residual call for different alignment stages. State their sequential relationship. | I1 and Chapter 5. | F3-C. Do not insert the estimator, or represent composed spatial maps as an unqualified sum of two fields. |
| **P21** | Explain why combining corresponding intensities is the chosen output operation. Identify the global mean as intermediate and the post-refinement mean as final; point to Chapter 5 for exact definitions. | I1/I2; Chapter 5 already contains both means. | Conceptual endpoint only. No claim of full-aperture recovery, unbiased estimation, or a guaranteed noise reduction. |
| **P22** | State validity limits close to the approximation: missing correspondence, residual blur, unequal appearances, axial structure, and unsupported source-coordinate regions. Separate an observed displacement from a diagnosis of its optical cause. | A1 and I2 §13. Physical attribution belongs to Chapter 4 with its own sources. | F3-C residual panel. Local behavior in actual tissue remains an experimental question. |

### 3.6 Model boundary and handoff — P23–P24, about 200 words

**Purpose:** close the chapter with an explicit account of what is defined and what remains to establish.

| Paragraph | Job and required content | Citation placement / evidence | Equation or visual; transition |
| --- | --- | --- | --- |
| **P23** | Recap the defined data objects, assumptions, and calibration dependencies. Identify the unverified parts of the physical and correspondence models without introducing new mechanisms or results. | Cross-refer to P02/P08/P13/P22 and Chapter 6; no new citation needed. | T3-N and the model assumptions; no new equation. |
| **P24** | Bridge first to Chapter 4's degradation mechanisms, then to Chapter 5's estimator. State the remaining experimental question: when the approximation is useful under the documented conditions. | I4 and the thesis chapter map. | No performance claim or evidence introduced in the closing paragraph. |

## 4. Equation and notation plan

These are equation specifications. Their algebra is deliberately left for a later, separately authorized drafting step.

| Planning ID | Where | What the eventual equation must express | Preconditions and checks |
| --- | --- | --- | --- |
| **E3-A — measurement-to-view representation** | P04, revisited P11 | Define the raw sensor frame, extraction operator, view indices, within-view domain, and four-axis stack. Separate a function's domain/codomain from a list of array dimensions. | Use actual extraction conventions from I2. Define any transpose, crop, rotation, or interpolation instead of hiding it inside an unexplained reshape. |
| **E3-B — physical sampling conversion** | P10; conditional | Relate sensor pixel pitch to object-plane sampling through effective magnification, with any extraction resampling explicit. Optionally define a pupil-occupancy ratio separately from retained view count. | Confirm applicable relay geometry, units, and coordinate orientation. Recheck the printed S3 relations. Keep measured calibration separate from a design prediction. No numbers are required to complete the plan. |
| **E3-C — intensity forward relation** | P14–P15 | A general nonnegative intensity-response relation for the nominal 2D object, followed by pixel integration/sampling, background, and a residual/noise term. | Define the normalization and units of object and kernel together. State which factors are absorbed into the kernel. Do not assume convolution, a measured PSF, or an identified scattering operator. Cite S5 for the foundation and mark the adaptation. |
| **E3-D — correspondence approximation** | P18–P19 | A backward coordinate map that samples an elemental view on the chosen reference grid, approximately matching a latent common image up to a residual. | Define support, sign, units, and map direction. The relation is an image-domain approximation, not an algebraic consequence of E3-C. Estimation and numerical boundary rules remain in Chapter 5. |

**Equation budget:** three core displayed relations (E3-A/C/D), plus E3-B if it resolves a real sampling question. A separate two-plane formula is optional; notation and F3-A may suffice. Omit a full Debye/Fresnel derivation, volumetric solver, new regularizer, and repeated Chapter 5 equations.

### T3-N — proposed shared notation table

Use this as the chapter's notation inventory and reconcile it with Chapters 5–6 before drafting. Symbols below are candidates, not new established conventions.

| Quantity | Recommended notation policy | Domain, units, and evidence to define |
| --- | --- | --- |
| Raw sensor measurement | Introduce a distinct symbol, e.g. `Y`; do not reuse `G`. | Two sensor coordinates; digital counts unless a different calibrated quantity is documented. |
| Continuous object position | Use a separate vector, e.g. `r_o`. | Two physical coordinates on the chosen object plane; define origin and length unit. |
| Pupil coordinate | Use a separate vector, e.g. `rho`. | Physical or explicitly normalized pupil coordinate, never silently an integer view index. |
| Elemental view | Preserve `V_ij(y,x)`. | Row/column pixel coordinates within a view; intensity state after documented preprocessing. |
| View count and shape | Preserve `N`, `H`, `W` for the retained square grid and per-view shape. | Dimensionless integer counts. Reserve another symbol for a continuous pupil-occupancy ratio. |
| Object emission quantity | Introduce `f` only after defining its physical meaning. | Nonnegative object quantity; normalization and units must match E3-C. Avoid an unsupported absolute concentration interpretation. |
| Intensity-response kernel | Use `h_ij` only if explicitly defined as an intensity kernel. | Nonnegative response with input/output units; distinguish it from a complex amplitude response in a cited derivation. |
| Latent common image | A distinct symbol such as `I_star`. | Image on the reference grid; not automatically the object emission map or an external reference. |
| Displacements | Preserve `d^g_ij`, `d^ell_ij` in the Chapter 5 handoff; use a separately named map for E3-D. | `(dy,dx)`, original-view pixels unless a different grid is explicitly stated. |
| Stage outputs | Preserve `V^g_ij`, `G`, `V^ell_ij`, `I_rect`. | Existing Chapter 5 meanings. Only name them here; leave their defining operations there. |
| Optical quantities | Distinct names for emission wavelength, lenslet pitch, pupil-relay magnification, and total image magnification. | Do not reuse Chapter 5's `p` (search padding) or `q` (upsampling) for optical quantities. |

The correspondence relation must survive three drafting checks: identity displacement; one known integer feature shift with the correct backward lookup; and a location whose lookup falls outside the view. These are planned algebra/diagram checks, not experiments already performed.

## 5. Figure plan

**Common production rule:** original vector schematics, consistent symbols and color assignments, readable at thesis page size. Figures are planned only. Captions are specified by required content, not drafted here. Do not copy a literature or Hadar figure; cite conceptual sources and verify any later adaptation permissions if reuse is chosen instead.

### F3-A — From pupil regions to elemental views

**Priority / placement:** core; introduce at P05 and finish explaining by P08.

**Scientific question:** What connects a selected pupil region to an elemental image and its view index?

**Panel specification:**

1. Simplified collection path: nominal scene plane → objective → pupil-imaging relay → MLA → imaging relay → sensor. Mark conjugate planes; distinguish the local architecture from an unmodified literature schematic.
2. Pupil inset: finite pupil support on a lenslet grid, highlighting three sub-apertures. Show physical array extent separately from illuminated support; use an illustrative grid without assigning an acquisition's retained N.
3. Sensor inset: three corresponding elemental images with matching highlights and distinct within-view spatial axes. Label the geometry as conceptual and not to scale.

**Evidence:** S2 §§2.1–2.2 and S3 §2 for the optical concept; I3 for local relay-group roles. This figure elaborates the model part of the existing [figure backlog](../research-context/figure-and-table-backlog.md), not its full multi-camera setup figure.

**Caption requirements:** conceptual status; plane and panel definitions; meaning of colors; finite sub-aperture selection; source citations; absence of calibrated scale. If a field stop is shown as a design requirement, visually distinguish it from confirmed installed hardware.

**Validation before production:** reconcile conjugate-plane labels and relay orientation with I3; check that lenslet index maps to a view, rather than borrowing image-plane LFM pixel rearrangement. No unsupported optical distance, ray angle, spot size, or resolution value.

**Provenance needed later:** diagram source file, export command/version, evidence locators, and any design assumptions. No acquisition identifier is needed for a purely conceptual schematic.

### F3-B — From a sensor frame to the view array

**Priority / placement:** core; P11, with reference back to P04.

**Scientific question:** What do the four array axes mean, and how do extracted views relate to sensor regions?

**Panel specification:**

1. Schematic sensor mosaic with selected extraction windows and an explicitly illustrative center/pitch.
2. One expanded window with within-view `(y,x)` directions.
3. An array diagram naming the two view axes and two image axes. Show the retained set separately from the physical array; include an orientation key tied to I2.

**Evidence:** I2 §§2–3. The first view axis in the recorded extraction implementation advances the sensor's horizontal coordinate, the second its vertical coordinate. Do not draw a conventional row/column grid that silently reverses that mapping.

**Caption requirements:** schematic versus measured status; axis order; view selection; extraction versus reconstruction; meaning of boundary markers. No micrometre scale for a symbolic diagram.

**Optional measured replacement:** only after selecting a raw frame and its exact extraction record. Record dataset/input identity, calibration/ROI geometry, extraction revision, intensity processing, exclusions, orientation, display range, and calibrated scale if available. A real example is not required for the chapter's logical completeness.

**Validation before production:** trace one labeled sensor window to its actual array indices. If an even grid is illustrated, do not draw a nonexistent geometrically central lenslet. Avoid claiming unused/excluded lenslets were present in a particular run without evidence.

**Provenance needed later:** conceptual diagram source, or the existing [figure-provenance template](../research-context/result-provenance/figure-provenance-template.yaml) for a measured panel. Keep provisional data assets in `candidate-outputs/` until qualified.

### F3-C — Correspondence, backward sampling, and residual mismatch

**Priority / placement:** core if the displacement relation is retained; P18–P22. Keep smaller than the existing Chapter 5 pipeline figure.

**Scientific question:** Which component of view disagreement can the correspondence model represent, and what remains after coordinate alignment?

**Panel specification:**

1. A few schematic features on a reference lattice and in a displaced view; use distinguishable feature shapes to make correspondences unambiguous.
2. A constant displacement versus a spatially varying displacement, with arrows explicitly labeled by direction and grid. Include a backward-lookup inset from one output pixel to its input sampling point.
3. A schematic residual example in which position can coincide while width/intensity or missing content still differs. Label it as a constructed illustration, not a recovered experimental result.

**Evidence:** A1 and I2 §§5.6/13 for the approximation and map convention. This is not evidence of a specific tissue mechanism or measured improvement.

**Caption requirements:** all panels synthetic/conceptual; definition of reference and moving images; arrow convention; residual meaning; no performance conclusion. If simulated pixels are used instead of vector features, disclose generation and interpolation.

**Validation before production:** verify the one-shift sign example against Chapter 5; keep physical ray arrows visually distinct from sampling arrows; do not imply an invertible deformation or exact intensity preservation. Do not draw a recovered wavefront or label a displacement as a measured scattering path.

**Provenance needed later:** source drawing or generating script, chosen illustrative transforms, rendering parameters, and export version. No result-run identifier for a schematic.

### Figure scope and fallback

Do not add a global/intermediate/final result comparison, a resolution curve, or a tissue-performance panel here. Those need Chapter 7 evidence. If page space is tight, combine F3-A's sensor inset with F3-B while retaining the distinct scientific questions. Omit measured examples before compromising their provenance.

## 6. Assumption and validity checklist for later drafting

| Item | State explicitly | Evidence still needed for a stronger statement |
| --- | --- | --- |
| Fluorescence detection | Intensity response, not direct complex-field measurement. | Emission filtering/band and actual camera intensity-processing state. |
| Nominally 2D scene | A modeling choice with a validity range. | Axial extent, focus/geometry, and an appropriate argument or measurement for selected samples. |
| Pupil conjugation | Intended design and recorded relay arrangement. | Measured conjugation/alignment or calibration if claiming achieved ideal geometry. |
| Common scale and orientation | A specified calibrated coordinate convention. | Pixel scale, axis mapping, extraction geometry, and any resampling. |
| Spatial invariance | An optional restricted idealization. | Evidence supporting a convolution approximation over the specified field and condition. |
| Brightness comparability | A correspondence assumption, not an implemented photometric correction. | Calibration/preprocessing and view-to-view variation if a quantitative claim requires it. |
| Displacement interpretation | Image correspondence on a named grid. | Independent physical evidence before attributing shifts to a unique optical mechanism. |
| Noise | A residual term with no default probability law. | Detector characterization and acquisition context for any likelihood or uncertainty calculation. |
| Performance | Not established by a model diagram or equation. | Selected run, comparison protocol, and result provenance in Chapters 6–7. |

## 7. Decisions and evidence gaps

These are planning dependencies, not reasons to delay this document. Resolve them before the affected text or asset is finalized. Existing [open questions](open-questions.md) and source records remain the authoritative factual ledger; the table below identifies where this chapter depends on them.

| Decision / gap | Proposed default or needed action | Affected items |
| --- | --- | --- |
| Chapter depth and title | Adopt the existing outline title and the bounded theory-to-correspondence structure above. A full wave-optics derivation would require a separate scope decision. | Whole chapter |
| One-based versus zero-based view indices | Prefer one-based thesis notation to match Chapter 5, with an explicit mapping to zero-based arrays. Reconcile Chapter 6 in a later authorized edit. | P04/P11, E3-A, T3-N, F3-B |
| Shape notation | Distinguish array shape `(N,N,H,W)` from a mathematically typed mapping. Chapter 5 currently expresses its mapping as a product of dimension labels; note for later consistency editing. | E3-A and Chapter 5 interface |
| View-axis orientation | Preserve I2's observed horizontal-then-vertical extraction order, or define an explicit presentation transpose. Verify against the revision used for any real figure. | P04/P11/P19, F3-B/C |
| Center for an even grid | State the chosen reference index rather than imply a unique central lenslet. If matching I2's zero-based floor-division choice, its one-based index is `floor(N/2)+1` on each axis. | F3-B and Chapter 5 handoff |
| Optical occupancy versus retained N | Use distinct symbols. Do not round a pupil-diameter/pitch ratio into a run's retained grid without a selection record. | P07/P09/P10, E3-B |
| Spectral and spatial calibration | Obtain the emission band, effective sampling, and extraction geometry; leave them symbolic meanwhile. The excitation wavelength alone cannot fill this gap. | P02/P10/P15, E3-B/C |
| Object-plane approximation | Document selected specimen axial extent or retain an explicit nominally 2D assumption with limitations. Do not invent a thinness threshold. | P13/P17/P22 |
| Physical-source reconciliation | Current Chapter 6 assigns N40X-PF to both objectives, while I3 still leaves that model assignment open. Identify the later author/source confirmation before relying on the stronger statement. No numerical model here depends on resolving it. | Any future numerical optical example |
| Convolution and exact PSF | Default to a general intensity kernel; no calibrated local PSF or spatial-invariance validation has been supplied for this plan. | P14/P16, E3-C |
| Detailed Yun setup claims | Obtain and inspect full text only if detailed conjugation procedures or tolerances are included. Its abstract suffices for P08's broad role. | P08, F3-A |
| Real sensor/view illustration | Default to an original schematic. Select a raw acquisition and calibration before replacing any panel with data. | F3-B |

## 8. Later drafting sequence and acceptance criteria

This sequence is a future work specification. It does not authorize or perform chapter drafting in this task.

1. Settle the notation/index mapping and choose the physical quantity for E3-C; resolve only the calibration questions needed for the chosen model depth.
2. Check primary-page equation typography and source assumptions for any relation to be adapted. Keep S4's full-text limitation visible unless new inspection resolves it.
3. Prepare F3-A/B/C as original schematics with their source records; inspect their axes, map signs, conjugate planes, and scale labels.
4. Draft P01–P16 around the measured data and bounded optical model, then P17–P24 around the explicit correspondence approximation and limits.
5. Reconcile Chapter 3 notation with Chapters 5–6 without changing their scientific scope or historical provenance.
6. Check claim–citation adjacency, dimensions/units, model-versus-estimator language, figure captions, and unresolved assumptions before any promotion to finalized thesis content.

**Planning-deliverable checks completed:** all 24 paragraphs have an assigned purpose, evidence category, and transition; all five proposed external citation keys exist in the active bibliography; all three figures have a question, placement, evidence, caption requirements, and production checks; model assumptions and missing calibration are explicit. No primary equations were transcribed, optical model numerically validated, experiment replayed, or chapter compilation performed. The target `.tex`, bibliography, template, and existing figure assets are outside this task's edit scope.
