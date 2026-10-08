# Chapter 3 plan: light-field measurement, view formation, and model limits

> **Status:** proposed chapter plan; grounded in the current draft
>
> **Revised:** 2026-10-08
>
> **Target:** [03_light_field_model.tex](../overleaf/main/03_light_field_model.tex)
>
> **Edit scope:** this plan only. Chapter prose, equations, captions, assets, bibliography, and other planning records are unchanged.

## 1. Chapter purpose and scope

**Question:** What does an FLFM elemental view measure, and under which assumptions can the extracted views be treated as corresponding observations of one nominally two-dimensional fluorescent scene?

The chapter should establish a dependable vocabulary and physical interpretation for Chapters 4–6. Its contribution is the connection between pupil selection, intensity image formation, the sampled sensor measurement, and the view array. Chapter 5 already explains how the views are aligned and combined; Chapter 3 supplies the assumptions needed to interpret that operation.

**Keep the current title:** *Light Field Microscopy Model*. The [thesis outline](thesis-outline.md) calls this material *FLFM Forward Model and Sampling Geometry*, which remains a useful description of its scope. A title change is unnecessary for this revision.

**Recommended extent:** about 1,750 words of final body text, including the existing opening, organized into four sections and approximately 13 paragraphs. Use one original conceptual figure and one displayed model block. These are editorial budgets, not quotas. Definitions can remain in prose; a separate thesis notation table is optional only if it improves navigation.

The narrative is: quantities and coordinates already defined → physical meaning of a view → bounded intensity-to-measurement model → correspondence assumptions and handoff. Explain each new physical relationship before its mathematics. Keep the forward model descriptive: the Chapter 5 procedure does not invert it or estimate its response kernel.

### Content ownership across the thesis

The following boundaries follow the inspected drafts, rather than assuming that every planned chapter is already complete.

| Chapter and current state | Content it owns | Chapter 3's contribution or cross-reference |
| --- | --- | --- |
| [1: Introduction](../overleaf/main/01_introduction.tex), substantive prose | Motivation, microscopy trade-offs, snapshot LFM, spatial–angular trade-off, LFM/FLFM contrast, and the thesis's 2D scope. | Begin with the model question. Give only the architecture detail needed to explain a view; omit another modality survey, benefits list, or volumetric application review. |
| [2: Background](../overleaf/main/02_background.tex), placeholder | Broader fluorescence, light-field, statistical-optics, and reconstruction context. | Define terms needed locally without expanding into a general tutorial. The placeholder does not justify duplicating Chapter 1. |
| [4: Aberration and Scattering](../overleaf/main/04_aberration_and_scattering.tex), placeholder | Physical causes of degradation and their interpretation. | Identify model departures and observable inter-view disagreement. Leave tissue mechanisms and optical attribution to Chapter 4. |
| [5: Reconstruction Method](../overleaf/main/05_reconstruction_method.tex), substantive prose | Pipeline diagram, global translation, matching copies, local score/search, references, backward sampling, interpolation/borders, and intermediate/final averages. | Establish shared scene structure and the limits of coordinate alignment. Cross-reference the method once; omit stage-by-stage explanations and repeated equations. |
| [6: Setup, Data, and Evaluation](../overleaf/main/06_experimental_setup_evaluation.tex), substantive prose | Three camera paths, components, sample/acquisition records, extraction calibration, preprocessing, run provenance, selection, and comparison protocol. | Describe only the main path's optical roles and symbolic calibration dependencies. Leave component values, extraction instructions, and camera-comparison details there. |
| [7: Results](../overleaf/main/07_results.tex), [8: Discussion](../overleaf/main/08_discussion.tex), [9: Conclusion](../overleaf/main/09_conclusion.tex), placeholders | Measured outcomes, then interpretation and contributions. | Establish what evidence will be needed to assess the approximation. Introduce no improvement, resolution, fidelity, or tissue-performance result. |
| [Derivations appendix](../overleaf/main/a_derivations.tex), placeholder | Supporting derivations if needed. | Add no derivation merely to fill the appendix. Keep the model understandable without a full propagation calculation. |

Preserve the Technion template. Use [Hadar's comparative standard](../literature/thesis-examples/hadar-reference-standard.md) for pacing, definitions, and the progression from model to evidence. It supplies no scientific claims or assets for this chapter.

## 2. Build on the existing Chapter 3

The current chapter has four substantive opening paragraphs and a final optical-path paragraph. Treat the first four as the foundation of the revision, with focused tightening where needed. The old plan's assumption that Chapter 3 contains only a placeholder is obsolete.

Line locators below refer to the inspected baseline `36508d3653d1830577116e28790e454a676bad6f`, with a clean working tree before this plan edit.

| Existing passage | Later drafting action | Reason |
| --- | --- | --- |
| Lines 3–7: chapter scope, measured sensor frame, computational 2D target, continuous/discrete distinction | Retain as P01. Tighten the roadmap to name what this chapter actually establishes. Mention simulation only if a specific simulation is subsequently described. | The opening already gives the input/output distinction; another introductory paragraph would repeat it. |
| Lines 9–12: fluorescence, detected intensity, digital counts, and calibration gaps | Retain as P02. Keep the intensity premise and the distinction between excitation and emission. Treat the 488 nm value as a Chapter 6 detail; do not use it as the emission wavelength. | The forward-model section will formalize this account rather than reintroduce it. |
| Lines 14–17: specimen coordinates, nominal plane, pupil coordinates, and physical lengths | Retain as P03, with its geometric citation. Use these coordinates throughout. | Replacing them with new generic vectors would create unnecessary notation changes. |
| Lines 19–25: `Y`, `V_ij(y,x)`, one-based indices, `Omega`, `(N,N,H,W)`, extraction, and horizontal-then-vertical view order | Retain as P04. Correct “elemental view” to “elemental views” when drafting. Keep `V = E(Y)` inline. | These definitions are already usable by Chapter 5. Explain their physical meaning next, rather than defining the array twice. |
| Lines 27–30: three capture paths and the two relays | Replace with P05's focused main-path account. Refer to Chapter 6 for the other paths. Correct “Fourier plan” to “Fourier plane”; distinguish pupil conjugation from the plane where elemental images form. | Chapter 6 already explains the branches and instrument. Chapter 3 needs optical roles, not another setup description. |
| Line 31: the measured light field described as a “complex continuous function” | Resolve the ambiguity in P05/P09. Distinguish a complex amplitude used to calculate propagation from the nonnegative intensity response used for incoherent emission and detection. | The current sentence blurs two quantities that the earlier intensity paragraph correctly separates. |

These are instructions for a future chapter edit, not changes made to the `.tex` file in this task.

## 3. Section and paragraph plan

P01–P13 are planning identifiers, not thesis labels. Word allocations include retained prose and sum to approximately 1,750 words. Paragraphs may be combined if their purposes remain clear.

### 3.1 Measurement and coordinates — P01–P04, about 400 words

**Purpose:** preserve the opening's definitions so every later relation has a named object and coordinate system.

- **P01 — Scope and target.** Retain the distinction between the raw measurement and the reconstructed 2D image. End by identifying the physical meaning of an elemental view as the next question.
- **P02 — Measured quantity.** Retain emission → detected intensity → digital counts and the unresolved spectral/detector calibration. Attach Guo's citation to intensity superposition. The later equation should develop this premise without repeating the paragraph.
- **P03 — Continuous coordinates.** Retain `(x_o,y_o)`, `z=0`, and `(u,v)`, including origins, axis choices, and length units. Keep the pupil coordinates distinct from view indices and avoid treating a finite sub-aperture as a single exact ray direction.
- **P04 — Discrete representation.** Retain `Y(r_s,c_s)`, `V_ij(y,x)`, `Omega`, retained `N`, `H,W`, extraction, and index mapping. Give only the representation; Chapter 6 owns how its geometry is obtained for a capture.

**Evidence:** current Chapter 3 opening; S1/S2 and I1 below. **Visual/equation:** existing inline extraction relation; introduce F3-1 by the transition to Section 3.2. No new displayed array equation.

### 3.2 What an elemental view represents — P05–P07, about 400 words

**Purpose:** connect a lenslet's pupil region to an image of the specimen.

- **P05 — Main-path optical roles.** Replace the existing final paragraph with collection by the objective, relay of the pupil to the MLA, formation of elemental images, and relay of that image plane to the sensor. Explain the conjugate planes using F3-1. Describe the intended geometry and recorded relay roles without asserting that ideal alignment has been measured.
- **P06 — Pupil selection and spatial image.** Explain how a finite lenslet aperture selects part of the relayed pupil and forms an elemental image. Use one highlighted lenslet and its corresponding sensor region to distinguish view position `(i,j)` from within-view position `(y,x)`. A view has a finite pupil response, not the resolving power of the full objective merely because it images the same scene.
- **P07 — Finite support and sampling consequences.** Distinguish manufactured lenslets, illuminated pupil support, and computationally retained views. Explain only the consequences needed later: views can differ in throughput/response, finite image windows constrain support, and pixel sampling is distinct from optical resolution. Name effective magnification and pixel pitch as scale dependencies; send their values/calibration to Chapter 6. Do not repeat Chapter 1's general trade-off discussion.

**Evidence:** S2 §§2.1–2.3; S3 §2 for finite aperture and sampling; I2 for the local relay arrangement. **Visual:** F3-1. **Transition:** the view geometry identifies which measurement regions the intensity model must describe.

### 3.3 Bounded intensity image formation and sampling — P08–P10, about 550 words

**Purpose:** state a physical relation between the nominal scene and the sampled measurement, at the depth this thesis uses.

- **P08 — Object and assumptions.** Define an effective nonnegative emission distribution on the already established nominal plane. Declare its normalization and the nominally 2D approximation; geometric thinness alone is insufficient to establish it for every specimen. State the assumption of linear incoherent intensity superposition for the modeled acquisition. Leave axial extent and acquisition-specific validity to Chapter 6 evidence.
- **P09 — Response and superposition.** Introduce E3-1's intensity response to an object point, including pupil selection and the relays. Use a general response that can depend on both source and sensor position. Explain the distinction between an intensity response and the complex amplitude appearing in Guo's propagation calculation. Identify the restriction from Guo's volumetric relation to the nominal plane as an adaptation. Keep the response uncalibrated; introduce convolution only if a specified condition supports spatial invariance.
- **P10 — From intensity to the supplied views.** Complete E3-1 with pixel-area/exposure integration and detector conversion, explicitly locating spectral treatment, background, and a residual if used. Connect the resulting `Y` to the existing extraction relation. Briefly distinguish that raw measurement model from processed/HDR input arrays whose preparation is described in Chapter 6. State the quantities needed to relate pixels to object-plane length without deriving an unverified numerical scale.

**Evidence:** S2 §2.3, especially Eq. (4), for optical superposition; the current opening and I1/I2 identify data and calibration boundaries. Detector conversion is a declared modeling layer whose local factors remain unresolved. **Equation:** E3-1 only. **Transition:** a measurement model describes how views form; corresponding image structure is an additional assumption needed for their alignment.

### 3.4 Correspondence assumptions and the chapter handoff — P11–P13, about 400 words

**Purpose:** give later chapters a bounded interpretation of alignment, without retelling the estimator.

- **P11 — Shared image structure.** State the image-domain approximation: on a common grid, enough structure in different views can correspond after a coordinate mapping, with residual differences in blur, brightness, or visible content. Explain why this is stronger than merely imaging the same specimen. The common image is a reference representation, not automatically a fluorophore-density map, an external-camera ground truth, or an exact full-aperture image. Keep this in prose; introduce no extra latent-image symbol unless it is used later.
- **P12 — Validity and unrepresented differences.** Place limits beside the approximation: axial structure, missing/overlapping features, view-dependent blur or throughput, weak signal, and incomplete common support. Coordinate alignment can represent positional disagreement while other differences remain. Do not diagnose a scattering mechanism from a displacement, or promise preserved geometry, integrated fluorescence, or improved resolution. Refer to Chapter 4 for physical causes and Chapter 5 for the numerical remapping limits.
- **P13 — Established objects and remaining evidence.** Close with the established scene/measurement/view distinction, coordinate convention, finite pupil response, and declared correspondence assumption. Point to Chapter 4's degradation account, Chapter 5's single global-then-local method, and Chapter 6's calibration and evaluation evidence. If naming outputs, call `G` the intermediate global-stage average and `I_rect` the final rectified image. Leave their definitions and comparison to Chapters 5–6.

**Evidence:** A1 is the declared approximation; I1 §§5.6/13 and the current Chapter 5 bound its interpretation. The inspected sources do not validate this approximation for the local acquisitions. **Visual/equation:** none by default. **Endpoint:** the reader knows what the method acts on and which model assumptions its results must be assessed against.

## 4. Necessary mathematics and notation

### E3-1 — One linked image-formation block

**Placement:** Section 3.3, after the object and response are defined.

**Question answered:** How does an effective 2D emission distribution produce a continuous intensity distribution, then the discrete sensor values from which views are extracted?

Use at most two linked lines: intensity superposition over the nominal object plane, followed by pixel/exposure integration and detector conversion. These are equation requirements, not finalized algebra.

Before drafting the block:

1. Reuse `(x_o,y_o)` for object position. Introduce a distinct physical sensor-plane coordinate; `(r_s,c_s)` already denotes integer sensor indices.
2. Define the nonnegative object quantity and response normalization together. Declare units or relative units so integration and conversion yield the stated measurement quantity. Do not imply absolute fluorophore concentration or calibrated photon counts.
3. Use an explicitly named intensity-response kernel, preferably `K`. Guo's `h` is a complex amplitude whose squared modulus enters its intensity relation; silently reusing it as an intensity kernel would obscure the distinction.
4. State whether spectral integration and throughput are explicit or absorbed into an effective response. Exposure, pixel area, gain, and background must appear exactly once in the accounting.
5. Distinguish a predicted mean/ideal count value from the observed `Y`. An additive residual supplies no noise law, independence assumption, or uncertainty estimate.
6. Apply extraction after camera integration. If expressing a per-view response instead, derive it through the defined sensor windows; do not treat the extracted indices as continuous pupil coordinates.
7. Preserve a general source/sensor-dependent response. A common convolution PSF, measured transfer function, or scattering operator needs additional evidence.

**Proposed checks:** dimensions/units; zero-emission limit with the stated background; a point emitter's response; and extraction of one labeled sensor window. Check rendered source-page typography before transcribing any primary equation. These checks have not been performed on a finalized equation in this planning task.

**Omit by default:** another displayed `V = E(Y)` or array-shape equation; a radiance parameterization already explained by the coordinates; lenslet occupancy/resolution formulas; Debye/Fresnel derivations; a volumetric inverse objective; a new displacement equation; and Chapter 5's score, remap, or mean equations. A later equation should be added only to answer an unresolved question that prose and F3-1 cannot answer.

### Shared notation inventory for drafting

This is a planning consistency aid, not a required new thesis table.

| Quantity | Convention to preserve or introduce | Boundary |
| --- | --- | --- |
| Object plane and pupil | Existing `(x_o,y_o)`, `z=0`, `(u,v)` | Continuous length coordinates with stated origins. No automatic pupil-position-to-angle calibration. |
| Raw measurement | Existing `Y(r_s,c_s)` | Discrete sensor row/column indices and the documented intensity-processing state. |
| Views and domains | Existing `V_ij(y,x)`, `Omega`, `N,H,W`, `(N,N,H,W)` | One-based thesis indices; zero-based arrays obtained by subtracting one. The first view index advances horizontally, the second vertically. |
| Emission and response | Candidate `f` and `K`, defined in E3-1 | Nonnegative quantities with jointly declared normalization; physical sensor coordinates distinct from integer indices. |
| Displacements and outputs | Existing Chapter 5 `d^g_ij`, `d^ell_ij`, `V^g_ij`, `V^ell_ij`, `G`, `I_rect` | Chapter 5 owns their defining operations. If mentioned, displacement components are `(dy,dx)` in original-view pixels with its backward-sampling convention. |
| Optical scale variables | Distinct names only when needed | Do not reuse Chapter 5's `p` (search padding) or `q` (upsampling) for lenslet pitch or magnification. |

## 5. One core visual

### F3-1 — A selected pupil region becomes an elemental view

**Scientific question:** How does a finite pupil region become a sensor image, and which coordinates label the view and its pixels?

**Placement:** introduce in Section 3.2 and refer back to it at the sampling/extraction connection in Section 3.3.

Combine the useful content of the former F3-A and F3-B into one original vector schematic:

- **Optical-role strip:** nominal object plane → collection objective → pupil relay → MLA at the relayed pupil → elemental-image plane → image relay → sensor. Mark conjugate planes without specifying unverified distances. Represent the local two-relay architecture using I2, rather than copying a literature setup.
- **Pupil-to-sensor correspondence:** show finite pupil support over an illustrative lenslet grid and highlight a few lenslet regions with matching sensor windows. Separate array extent, illumination support, and selected windows. Avoid assigning a run's `N`.
- **One view inset:** show `(y,x)` inside a selected `V_ij`, alongside an axis key for horizontal `i` and vertical `j`. The expanded image and retained-view labels are sufficient; a separate decorative 4D-array cube is unnecessary.

**Evidence:** S2/S3 for the optical principle; I1 §2 and I2 for the extraction orientation and local relay roles.

**Caption requirements:** original conceptual illustration; not to scale; plane/coordinate meanings; color correspondence; finite sub-aperture selection; sources for the optical concept; and explicit distinction between schematic windows and calibrated acquisition geometry.

**Production checks:** trace one lenslet through its image window to its array indices; verify the image-plane relay rather than implying a sensor placed directly at the MLA; avoid an assumed central lenslet for an even grid; and show no unconfirmed field stop, filter, ray angle, or physical scale. Keep diagram source, export settings, evidence locators, and assumptions in its eventual provenance record.

**No second figure by default.** The former displacement/warp figure would overlap Chapter 5's diagram and equations. If P12's distinction between position and residual appearance remains difficult to read, use a small conceptual inset showing coincident feature centers with different widths. It must answer that specific question and be labeled constructed, without reconstruction stages, sampling arrows, or a performance claim.

A real sensor example is optional only if it replaces a schematic panel and adds needed information. It requires input identity, extraction revision/geometry, preprocessing, orientation, and display provenance using the existing [figure template](../research-context/result-provenance/figure-provenance-template.yaml). Acquisition data are unnecessary for the conceptual figure. Keep numerical setup diagrams in Chapter 6 and result panels/curves in Chapter 7.

## 6. Evidence and citation map

### Primary sources

Use the existing keys in [the active bibliography](../overleaf/back/thesis.bib). Attach citations to the physical statement they support; identify the thesis's model restrictions separately. Reading notes are navigation aids, not substitutes for primary passages.

| ID / key | Passage and inspection status in this revision | Use and limit |
| --- | --- | --- |
| **S1 — `levoy2009recordingControlling4d`** | [Author's article page](https://graphics.stanford.edu/papers/lfillumination/) inspected. The previous plan recorded inspection of pp. 145–146 and Fig. 2 in the [author-hosted PDF](https://graphics.stanford.edu/papers/lfillumination/levoy-lfillumination-jmicr09-lores.pdf); fresh passage retrieval timed out. | Retain the opening's geometric citation. Recheck the coordinate passage before revising its scientific wording. Image-plane LFM is not the FLFM extraction geometry. |
| **S2 — `guo2019fourierLightField`** | Guo et al., DOI [10.1364/OE.27.025573](https://doi.org/10.1364/OE.27.025573). Re-inspected publisher-provided article text [hosted on ResearchGate](https://www.researchgate.net/publication/335415040_Fourier_light-field_microscopy), §§2.1–2.4, Fig. 1 caption, and Eq. (4) with its definitions. | Pupil segmentation and intensity superposition. The nominal-plane restriction is an adaptation; the local response is not established by their PSF validation. Their §2.4 explains a different inversion procedure. |
| **S3 — `galdon2022fourierLightfieldDesignGuide`** | Galdón et al., DOI [10.1364/AO.453723](https://doi.org/10.1364/AO.453723). Re-inspected [article text hosted on ResearchGate](https://www.researchgate.net/publication/358915340_Fourier_lightfield_microscopy_a_practical_design_guide), §2, Fig. 1, and the aperture/magnification/sampling discussion. The [institutional PDF](https://www.uv.es/imaging3/PDFs/2022_AO_61_2558.pdf) could not be retrieved. | Finite pupil support and sampling dependencies. Do not transplant its view-count recommendations or design equations into the relayed local instrument as calibrated values. |

Yun's setup guide is no longer required by the core outline. Detailed conjugation procedures, tolerances, or NA-matching prescriptions belong with a separately inspected setup account in Chapter 6. The other literature remains available to its owning chapters; this plan adds no new reference.

### Internal evidence and declared assumptions

| ID | Inspected source and revision | Permitted use |
| --- | --- | --- |
| **I1** | [Method-note index](../research-context/method-notes/rectification-pipeline/README.md) and [September 25 source account](../research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md), §§2, 5.6, 13; `algo` commit `d0e08634e71ca0ecc4766e46de9e33d2d351d06a`. | Recorded array orientation, sampling interpretation, and method limits. This task inspected the account, not a fresh algorithm checkout or historical run. |
| **I2** | [Physical-system account](../research-context/physical-system-composition.md), scope/evidence and working path map, reviewed 2026-09-27; named script versions/hashes and author clarifications remain in that record. | Local relay roles and intended pupil conjugation. Distinguish recorded architecture from measured alignment and design values from acquisition settings. |
| **I3** | All included chapter files and both appendices at thesis baseline `36508d3653d1830577116e28790e454a676bad6f`; [writing standard](writing-standard.md), [technical guide](technical-writing-guide.md), [stage worksheet](templates/technical-stage.md), and [synthesis map](chapter-synthesis-map.md). | Current coverage, notation, and editorial responsibilities. Draft prose and planning records are not independent experimental evidence. |
| **A1** | Nominally 2D scene and image-domain correspondence, explicitly carried as modeling assumptions consistent with the current thesis scope. | State the approximation and its limits. No evidence packet here demonstrates its validity for every capture. |

The evidence-to-section allocation is: 3.1 uses the retained opening/S1/S2/I1; 3.2 uses S2/S3/I2; 3.3 uses S2 with declared object/detector assumptions; 3.4 uses A1/I1 and the current Chapter 5. None supports a new experimental result.

## 7. Remaining dependencies and completion criteria

The existing [open questions](open-questions.md), method notes, and provenance records remain the factual ledgers. The following are chapter dependencies, not additional record updates in this task.

| Dependency | Default for this chapter plan | Resolve before making a stronger statement |
| --- | --- | --- |
| Chapter 6 uses zero-based view indices while Chapters 3/5 use one-based indices | Preserve the explicit Chapter 3 mapping; flag Chapter 6 for a later consistency edit. | State whether Chapter 6 describes arrays or thesis notation. Do not silently change the sensor-axis order. |
| “Central view” for even `N` | Leave reference selection in Chapter 5. | Define its discrete reference index there instead of assuming a lenslet on the geometric center. |
| Emission band and detector conversion | Keep E3-1 symbolic and its intensity/count distinction explicit. | Emission filters/band, exposure, gain/offset handling, and processing state for the selected acquisition. |
| Pupil conjugation and object-plane sampling | Use the intended geometry and symbolic scale dependencies. | Calibration/alignment evidence, sensor pixel pitch, effective magnification, extraction mapping, and any resampling. |
| Nominally 2D approximation | Declare it with its limitations. | Specimen axial extent, focus, and conditions for interpreting the selected scene as approximately planar. |
| Response and photometry | General uncalibrated intensity response; no statistical noise law. | Evidence for a common PSF/convolution, view brightness calibration, or a detector likelihood if any is later needed. |
| Hardware statements differ in strength between Chapter 6 and I2 | Use no model-specific objective assignment or sample-mount claim in Chapter 3. | Reconcile Chapter 6's two N40X-PF assignments and acquisition-specific mounting with their supporting records in the setup chapter. |
| Measured panel or result interpretation | Original schematic; no local performance conclusion. | Selected acquisition/run, exact revision, calibration, evaluation, and figure provenance. Current source defaults cannot fill an older run's missing revision. |

### Acceptance criteria for a later chapter draft

- The first four existing paragraphs remain the starting point; definitions appear once and retain their current coordinate/index meanings.
- The revised optical-path passage separates complex amplitude, intensity, and digital counts and explains the relayed elemental-image plane.
- Every section contributes a needed definition, physical relationship, assumption, or limit. Introduction, method, and setup material is handled by short cross-references.
- E3-1 has consistent units, declared normalization, explicit sampling/conversion, and a primary-source/adaptation boundary. Extraction still follows camera integration.
- F3-1 answers the pupil-to-view question with consistent planes, indices, and conceptual status. Additional assets require a specific unresolved explanatory need.
- Correspondence is stated as an assumption with residual disagreement and support limits. It is not inferred as a guaranteed consequence of the forward model.
- The close identifies what Chapters 4–6 can rely on and which calibration/validity evidence remains open. It introduces no new result or estimator.
- Check citations against the actual adjacent claims and reconcile cross-chapter notation before finalizing the chapter.

**Workflow and verification boundary:** ARS-Codex 3.22.0 was consulted in `academic-paper` / `outline-only` mode using its Structure Architect and writing-quality guidance, together with the local standards. This is an inline outline revision; `criteria_binding_unavailable` (no formal review-criteria binding supplied). No independent panel, formal citation/retraction audit, optical simulation, experiment replay, finalized equation verification, or thesis compilation was performed. The revised plan is the deliverable; drafting and figure production remain later work.
