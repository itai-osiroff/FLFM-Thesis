# Chapter 3 specification and optional evidence-backed backlog

> **Status:** active specification; approved outline (2026-11-12) plus optional drafting backlog
>
> **Reviewed:** 2026-11-12 (design-math coverage added to B2–B5 within the approved 4 pages); evidence observations retained from 2026-10-08
>
> **Target:** [03_light_field_microscope.tex](../overleaf/main/03_light_field_microscope.tex)
>
> **Migration scope:** documentation and structural wrappers only; scientific prose, equations, captions, and assets are preserved.

## Current authority and use

Use the [authoritative structure and space budget](revised-thesis-structure.md).
The chapter is **What is a light-field microscope** and includes relevant
aberration/scattering context from the former Chapter 4. Its page allocation is
**about 4 pages** (author approval, 2026-11-12), with one conceptual figure; the
[approved outline](#approved-outline-2026-11-12) below governs drafting. No former word count,
paragraph count, section count, equation block, or figure proposal is a binding
quota. Select only necessary explanations when later content work is authorized.
The source passages and locators below retain their historical inspection scope;
updating editorial destinations performs no new scientific verification.

## Approved outline (2026-11-12)

Approved by the author in chat on 2026-11-12, together with the page allocation
recorded in the [structure file](revised-thesis-structure.md). The 2026-11-09
decision of no subsections in Chapter 3 still holds: the blocks below are
unheaded stretches of prose, not sections. Page figures are prose/equation
equivalents; the figure is excluded from the count.

### Supervisor request this outline answers

The supervisor (Anat) asked the chapter to make four connected points:

1. Shrinking the aperture enlarges the depth of field (the beam becomes a
   narrow, nearly collimated pencil instead of a cone), but a point from one
   plane and a point from another plane then fall on the same image location.
2. That loss of plane discrimination is what a conventional (non-light-field)
   system gives: capturing a single beam mixes depths together.
3. Light-field capture separates rays, so different planes can be told apart;
   this is what produces depth (defocus) resolution, and the chapter needs a
   formula and its explanation.
4. Hence a larger depth of field alone is not sufficient; ray separation is the
   ingredient that keeps depths apart.

These points also carry the thesis premise: the parallax that separates depths
is the same per-view shift that defocus and aberration produce, which Chapter 5
estimates. The depth argument therefore leads into the aberration block rather
than standing apart from it.

### Blocks

| Block | Content | Approx. pages | Backlog items reused |
| --- | --- | --- | --- |
| B1 Scope | Tighten the existing opening: raw sensor frame versus the reconstructed 2D image; what the chapter establishes. | 0.25 | P01 |
| B2 Conventional imaging and the aperture trade-off | Supervisor points 1–2. Geometric defocus blur grows with distance from focus and aperture angle, $b(z)\approx 2\lvert z\rvert\tan\theta_{\max}$. Narrowing the aperture shrinks the cone and extends the depth of field, but the camera still records one projection, roughly $I(x)\approx\int f(x,z)\,dz$ (with depth-dependent blur): depths superpose at the same pixel. It also costs collected light and lateral resolution. **Design math covered here:** conventional lateral resolution (incoherent cutoff, $\lambda/2\mathrm{NA}$; Goodman 2017 §7.3, p. 197) and conventional depth of field (the depth at which geometric defocus blur equals the diffraction spot; Goodman §8.1.1–8.1.2, pp. 231–233). Tightened by 0.1 page to fund B4 (rebalance 2026-11-12). | 0.5 | new |
| B3 Separating rays gives depth discrimination | Supervisor points 3–4. A view through the pupil region at position $u$ sees a point at depth $z$ displaced by about $\Delta x_u(z)\approx M z\,u/f_{\mathrm{obj}}$ (sine-condition small-angle form; final symbols to match the existing coordinates). Each view behaves as a small aperture (sharp over a large depth of field); across views the displacement differs, which encodes depth. Give the depth-resolution relation from a primary source: $R_z\approx R_{xy}^{\mathrm{view}}/\tan\theta_{\max}$, per-view lateral resolution divided by the tangent of the largest view angle (Cong 2017, PDF p. 14, $d_z\approx d_{xy}/\tan\theta_{\max}$; Guo 2019 App. C, p. 25586, and App. H item 7, p. 25593). Close on point 4. **Design math covered here:** axial resolution. Its derivation goes to Appendix B. | 0.8 | new; links P03 coordinates |
| B4 Fourier light-field microscopy and its design relations | MLA conjugate to the objective back pupil, so each lenslet is one sub-aperture and one view; existing coordinates and $V_{ij}(y,x)$ notation; main-path optical roles without setup detail. Then the design relations, in the order of [B4 content](#b4-content-design-relations-added-2026-11-12) below: per-view resolution, the spatial-angular trade-off (the sentence removed from Chapter 1 on 2026-11-12 lands here, now quantitative), FLFM depth of field, pixel sampling and Nyquist, and fitting the views on the sensor without overlap. Each is a result plus one sentence of meaning; derivations go to Appendix B and numbers to the Chapter 4 design-values table. Worked example from design values: 7.5 mm entrance pupil relayed $\times 3$ ($250\to 750$ mm) spans about 22.5 mm at the array, about 7.5 lenslets of 3 mm pitch across, so per-view NA about 0.1. These are design values, not measurements. | 1.1 | P02–P07 |
| B5 Image formation for a nominally 2D scene | The one bounded image-formation block (E3-1). A flat scene on the nominal plane gives views that correspond up to known geometry; off the plane, each view shifts in proportion to $u$ (from B3). State the correspondence assumption and its limits. Add one sentence tying both to the FLFM depth of field from B4: the nominally 2D assumption and the shift $\propto u$ hold inside it, and beyond its cross-talk limit a view spills into its neighbour's window. Tightened by 0.15 page to fund B4. | 0.45 | P08–P12, E3-1 |
| B6 Aberration and scattering | Aberration as pupil phase error $W(u)$; over a small sub-aperture its local slope shifts that view, $\propto\nabla W(u_{ij})$, as in a Shack–Hartmann sensor (Ng and Hanrahan; Wu 2021; Platt and Shack). Defocus is the special case $W\propto z\,u^2$, recovering B3. Field-dependent aberration makes the shift vary within a view, which motivates Chapter 5's local stage. Scattering is not representable as a shift: state it as a limit (existing tissue paragraph). Close with the handoff to Chapters 4–5. | 0.9 | P13; existing closing paragraph |
| **Total** | | **about 4** | |

**Figure F3-A (approved, excluded from count):** three panels: (a) wide-aperture
cone with blur growing away from focus; (b) narrowed aperture where points at
two depths coincide on the sensor; (c) sub-apertures (lenslets) that send the two
depths to different positions in different views. Placed with B2-B3. It
supersedes F3-1 as the chapter's default visual unless the author adds F3-1
explicitly.

### B4 content: design relations (added 2026-11-12)

**Why added.** An audit on 2026-11-12 found that the system-design math (lateral
and axial resolution, both depths of field, spatial versus angular resolution,
pixel sampling and Nyquist, and fitting the views on the sensor without overlap)
was only partly planned: B2, B3 and B4 touched it, pixel sampling and the
no-overlap condition were absent, and E3-1 listed "lenslet occupancy/resolution
formulas" as default-omit. The author chose to rebalance within the approved
4 pages (B2 0.6→0.5, B4 0.8→1.1, B5 0.6→0.45; total unchanged) rather than
enlarge the chapter, to put derivations in Appendix B, and to put numbers in a
Chapter 4 table. No departure-table entry is needed.

Each item is a result with one sentence of physical meaning. Formulas are the
form to check against the rendered source pages before transcription (text
extraction garbles Guo's equations). All numbers in the chapter are labeled
design values until Chapter 4's open items close.

1. **Views and per-view resolution.** The MLA is conjugate to the pupil. With
   $\rho = D'_{\mathrm{pupil}}/d$ the ratio of the relayed pupil diameter at the
   array to the lenslet pitch $d$, the per-view aperture is
   $\mathrm{NA}_{\mathrm{view}}\approx\mathrm{NA}/\rho$ and the per-view lateral
   resolution is $R_{xy}^{\mathrm{view}}\approx\rho\,\lambda/(2\,\mathrm{NA})$,
   that is $\lambda/(2\,\mathrm{NA}_{\mathrm{view}})$ (Guo 2019 App. B, p. 25585;
   App. H items 2–3, p. 25592–25593). Worked example: $\rho = 22.5/3 = 7.5$,
   $\mathrm{NA}_{\mathrm{view}}\approx 0.1$, so each view resolves $7.5\times$
   more coarsely than the full objective aperture ($5\lambda$ against
   $0.67\lambda$ from $\lambda/2\mathrm{NA}$, emission band not yet recorded).
2. **Spatial versus angular resolution.** The pupil and the sensor are shared
   between the number of views (about $\rho$ per axis) and the resolution of
   each view. More views give a larger outermost view angle and better axial
   resolution (B3) but a coarser $R_{xy}^{\mathrm{view}}$; fewer views give the
   reverse. A larger sensor or a larger pupil-to-pitch ratio does not remove the
   exchange, because diffraction sets a space-angle bandwidth bound (Levoy 2009,
   locator still to record; Guo 2019 §5, pp. 25582–25583). This is the sentence
   removed from Chapter 1, now with its quantitative form.
3. **FLFM depth of field.** Two limits, and the smaller binds (Guo 2019 App. E,
   pp. 25589–25590): (i) diffraction, the axial extent over which the
   per-lenslet PSF stays above a detection threshold, which grows with the
   reduced per-view NA (roughly as $\rho^2$ relative to the full aperture); and
   (ii) cross-talk, the depth beyond which an emitter's light-field pattern
   spreads wider than one lenslet pitch and enters the neighbouring window.
   Guo's value for the diffraction limit is the full axial PSF width
   (twice the FWHM), a convention that follows from their deconvolution; state
   the convention used, and do not carry it over unchanged to a 2D
   registration-and-averaging method. For this thesis the depth of field is the
   range within which the nominally 2D assumption and the shift $\propto u$
   (B3, B5) can be trusted.
4. **Pixel sampling and Nyquist.** An object-space pixel is $P/M_T$, with $P$
   the camera pixel pitch and $M_T$ the total magnification from object to
   sensor. Guo defines the sampling rate as the ratio of the lenslet diffraction
   spot to the pixel, $S_r = (\lambda/2\mathrm{NA}_{\mathrm{ML}})/P$, with
   $\mathrm{NA}_{\mathrm{ML}}$ the lenslet's own NA (App. H item 4, p. 25592).
   Nyquist (Goodman 2017 §2.4.1, p. 29) requires at least two pixels per
   resolvable spot. Optical resolution and pixel sampling are two separate
   limits, and the coarser of the two sets the per-view detail. State which
   limit binds for the design values (Chapter 4 table), and what aliasing would
   mean for per-view alignment (Chapter 5 estimates shifts at sub-pixel scale).
5. **Fitting the views on the sensor without overlap.** Each lenslet's
   elemental image must stay inside its own window. The object-space field of
   view is set by the lenslet pitch, $\mathrm{FOV}\approx d\,f_{\mathrm{obj}}\,r/f_{\mathrm{MLA}}$
   with $r$ the pupil-relay magnification (Guo App. D, p. 25588, in Guo's
   symbols $d_{\mathrm{MLA}}\,f_{\mathrm{FL}}/(f_{\mathrm{MLA}}M)$), and a field
   stop at an intermediate image plane enforces it (Guo p. 25575, iris "to avoid
   overlapping light-field signals"). Each view then occupies the lenslet pitch
   times the sensor-relay magnification on the sensor, and the illuminated pupil
   span times that magnification must fit the sensor (Guo App. H item 1,
   $D_{\mathrm{pupil}} = D_{\mathrm{cam}}$ in their design rule). Principle and
   symbols here; the numbers for the local instrument go to the Chapter 4
   design-values table. Do not claim the local instrument has a field stop until
   Chapter 4 resolves it.

**Preliminary design-value arithmetic** (from the Chapter 4 relay values;
recomputed 2026-11-12, not measurements): $\rho = 7.5$; $\mathrm{NA}_{\mathrm{view}} = 0.1$;
$M_T = (55/5)(1/3)(150/400) = 1.375$ (front-end $11\times$, pupil relay
$1/3$ on the angles, sensor relay $0.375$); view footprint on the sensor
$3\,\mathrm{mm}\times 0.375 = 1.125\,\mathrm{mm}$; maximum no-overlap field of view
$3/(11/3) = 0.82\,\mathrm{mm}$; pupil span on the sensor $22.5\times 0.375 = 8.44\,\mathrm{mm}$
(the full $30\,\mathrm{mm}$ array would be $11.25\,\mathrm{mm}$). Comparing these
with the sensor size and pixel pitch needs the camera data sheet (open item).

**Appendix B receives:** the derivations of per-view resolution, axial
resolution, both depth-of-field limits, $M_T$, and the no-overlap condition,
each as a short derivation from the geometry of the main path with the paraxial
assumptions stated. The main text keeps results and intuition.

### Evidence to close before drafting B2, B3, B4 and B6

- Depth-resolution, lateral-resolution, field-of-view, sampling and FLFM
  depth-of-field formulas: Guo 2019 design-principle section (§5, Table 1,
  pp. 25582–25583) and Appendices B–E and H (pp. 25585–25593), now located; the
  earlier note's inspection covered only pp. 25573–25576. Transcribe from
  rendered pages. Cross-check against Galdón 2022 (not yet read in full) and
  Cong 2017 (PDF p. 14, $d_z \approx d_{xy}/\tan\theta_{\max}$).
- Conventional depth of field and the $\lambda/2\mathrm{NA}$ resolution limit,
  and the sampling theorem: Goodman 2017 (`goodman2017fourierOptics`, already
  in `thesis.bib`), §7.3 (p. 197), §8.1.1–8.1.2 (pp. 231–233), §2.4.1 (p. 29).
  The earlier statement that no textbook was in `thesis.bib` is superseded.
- Spatial-angular bandwidth bound: Levoy 2009 locator still to record (the note
  states the claim without a page); the PDF is not in `literature/`.
- Sub-aperture shift from local wavefront slope: existing notes for Ng and
  Hanrahan; Wu 2021 (preprint-based note, caveats apply); Platt and Shack (not
  read, publisher blocked).
- The B4 worked example uses design focal lengths and the objective data sheet;
  label it as design values (Chapter 4 records the missing measurements).

## 1. Chapter purpose and scope

**Question:** What does an FLFM elemental view measure, and under which assumptions can the extracted views be treated as corresponding observations of one nominally two-dimensional fluorescent scene?

The chapter should establish a dependable vocabulary and physical interpretation for Chapters 4–5 and the results. Its contribution is the connection between pupil selection, intensity image formation, the sampled sensor measurement, and the view array. Chapter 5 already explains how the views are aligned and combined; Chapter 3 supplies the assumptions needed to interpret that operation.

**Title and ownership:** *What is a light-field microscope*. Explain the physical meaning of the measured views and relevant degradation limits; Chapter 2 owns prior-work comparison and Chapter 4 owns the instrument/protocol summary.

**Extent:** about 4 pages (approved 2026-11-12) under the authoritative budget. The former 1,750-word/13-paragraph prescription is superseded. P01–P13, E3-1, and F3-1 below are optional candidates, not mandatory scope or new visual allowances.

The narrative is: quantities and coordinates already defined → physical meaning of a view → bounded intensity-to-measurement model → correspondence assumptions and handoff. Explain each new physical relationship before its mathematics. Keep the forward model descriptive: the Chapter 5 procedure does not invert it or estimate its response kernel.

### Content ownership across the thesis

The following boundaries follow the inspected drafts, rather than assuming that every planned chapter is already complete.

| Current owner | Boundary for this chapter |
| --- | --- |
| [1: Introduction](../overleaf/main/01_introduction.tex) | Motivation and contribution framing; avoid another general modality survey. |
| [2: Literature Review](../overleaf/main/02_literature_review.tex) | Prior approaches and the research gap. |
| [3: Microscope](../overleaf/main/03_light_field_microscope.tex) | Measurement/view interpretation, necessary model assumptions, and the former degradation context. |
| [4: Our setup](../overleaf/main/04_our_setup.tex) | Instrument and minimal acquisition/evaluation summary; detailed calibration/protocol records in supporting material. The full inherited draft remains temporarily. |
| [5: Image reconstruction](../overleaf/main/05_image_reconstruction.tex) | Essential two-stage estimator and its numerical scope; detailed reporting in supporting material as needed. |
| [6: Results](../overleaf/main/06_results.tex), [7: Discussion and Conclusions](../overleaf/main/07_discussion_and_conclusions.tex) | Observations, then interpretation/conclusions. This chapter introduces no performance result. |
| [Derivations appendix](../overleaf/main/a_derivations.tex) | Supporting derivations only when needed by the final explanation. |

Preserve the Technion template. Use [Hadar's comparative standard](../literature/thesis-examples/hadar-reference-standard.md) for pacing, definitions, and the progression from model to evidence. It supplies no scientific claims or assets for this chapter.

## 2. Build on the existing Chapter 3

The current chapter has four substantive opening paragraphs and a final optical-path paragraph. Treat the first four as the foundation of the revision, with focused tightening where needed. The old plan's assumption that Chapter 3 contains only a placeholder is obsolete.

Line locators below refer to the inspected baseline `36508d3653d1830577116e28790e454a676bad6f`, with a clean working tree before this plan edit.

| Existing passage | Later drafting action | Reason |
| --- | --- | --- |
| Lines 3–7: chapter scope, measured sensor frame, computational 2D target, continuous/discrete distinction | Retain as P01. Tighten the roadmap to name what this chapter actually establishes. Mention simulation only if a specific simulation is subsequently described. | The opening already gives the input/output distinction; another introductory paragraph would repeat it. |
| Lines 9–12: fluorescence, detected intensity, digital counts, and calibration gaps | Retain as P02. Keep the intensity premise and the distinction between excitation and emission. Treat the 488 nm value as a Chapter 4 detail; do not use it as the emission wavelength. | The forward-model section will formalize this account rather than reintroduce it. |
| Lines 14–17: specimen coordinates, nominal plane, pupil coordinates, and physical lengths | Retain as P03, with its geometric citation. Use these coordinates throughout. | Replacing them with new generic vectors would create unnecessary notation changes. |
| Lines 19–25: `Y`, `V_ij(y,x)`, one-based indices, `Omega`, `(N,N,H,W)`, extraction, and horizontal-then-vertical view order | Retain as P04. Correct “elemental view” to “elemental views” when drafting. Keep `V = E(Y)` inline. | These definitions are already usable by Chapter 5. Explain their physical meaning next, rather than defining the array twice. |
| Lines 27–30: three capture paths and the two relays | Replace with P05's focused main-path account. Refer to Chapter 4 for the other paths. Correct “Fourier plan” to “Fourier plane”; distinguish pupil conjugation from the plane where elemental images form. | Chapter 4 already explains the branches and instrument. Chapter 3 needs optical roles, not another setup description. |
| Line 31: the measured light field described as a “complex continuous function” | Resolve the ambiguity in P05/P09. Distinguish a complex amplitude used to calculate propagation from the nonnegative intensity response used for incoherent emission and detection. | The current sentence blurs two quantities that the earlier intensity paragraph correctly separates. |

These are instructions for a future chapter edit, not changes made to the `.tex` file in this task.

## 3. Optional section and paragraph backlog

P01–P13 are retained planning identifiers, not required paragraphs or thesis labels. Choose, combine, shorten, or omit candidate material during later content work within the author-agreed budget. The section numbers below identify backlog topics, not mandatory thesis sections.

### 3.1 Measurement and coordinates — P01–P04

**Purpose:** preserve the opening's definitions so every later relation has a named object and coordinate system.

- **P01 — Scope and target.** Retain the distinction between the raw measurement and the reconstructed 2D image. End by identifying the physical meaning of an elemental view as the next question.
- **P02 — Measured quantity.** Retain emission → detected intensity → digital counts and the unresolved spectral/detector calibration. Attach Guo's citation to intensity superposition. The later equation should develop this premise without repeating the paragraph.
- **P03 — Continuous coordinates.** Retain `(x_o,y_o)`, `z=0`, and `(u,v)`, including origins, axis choices, and length units. Keep the pupil coordinates distinct from view indices and avoid treating a finite sub-aperture as a single exact ray direction.
- **P04 — Discrete representation.** Retain `Y(r_s,c_s)`, `V_ij(y,x)`, `Omega`, retained `N`, `H,W`, extraction, and index mapping. Give only the representation; Chapter 4 owns how its geometry is obtained for a capture.

**Evidence:** current Chapter 3 opening; S1/S2 and I1 below. **Visual/equation:** existing inline extraction relation; introduce F3-1 by the transition to Section 3.2. No new displayed array equation.

### 3.2 What an elemental view represents — P05–P07

**Purpose:** connect a lenslet's pupil region to an image of the specimen.

- **P05 — Main-path optical roles.** Replace the existing final paragraph with collection by the objective, relay of the pupil to the MLA, formation of elemental images, and relay of that image plane to the sensor. Explain the conjugate planes using F3-1. Describe the intended geometry and recorded relay roles without asserting that ideal alignment has been measured.
- **P06 — Pupil selection and spatial image.** Explain how a finite lenslet aperture selects part of the relayed pupil and forms an elemental image. Use one highlighted lenslet and its corresponding sensor region to distinguish view position `(i,j)` from within-view position `(y,x)`. A view has a finite pupil response, not the resolving power of the full objective merely because it images the same scene.
- **P07 — Finite support and sampling consequences.** Distinguish manufactured lenslets, illuminated pupil support, and computationally retained views. Explain only the consequences needed later: views can differ in throughput/response, finite image windows constrain support, and pixel sampling is distinct from optical resolution. The relations for pixel sampling, Nyquist, and fitting views on the sensor without overlap now live in B4 items 4–5 (see [B4 content](#b4-content-design-relations-added-2026-11-12)); point there rather than restating them, and send the values and calibration to Chapter 4. Do not repeat Chapter 1's general trade-off discussion.

**Evidence:** S2 §§2.1–2.3; S3 §2 for finite aperture and sampling; I2 for the local relay arrangement. **Visual:** F3-1. **Transition:** the view geometry identifies which measurement regions the intensity model must describe.

### 3.3 Bounded intensity image formation and sampling — P08–P10

**Purpose:** state a physical relation between the nominal scene and the sampled measurement, at the depth this thesis uses.

- **P08 — Object and assumptions.** Define an effective nonnegative emission distribution on the already established nominal plane. Declare its normalization and the nominally 2D approximation; geometric thinness alone is insufficient to establish it for every specimen. State the assumption of linear incoherent intensity superposition for the modeled acquisition. Leave axial extent and acquisition-specific validity to Chapter 4 evidence.
- **P09 — Response and superposition.** Introduce E3-1's intensity response to an object point, including pupil selection and the relays. Use a general response that can depend on both source and sensor position. Explain the distinction between an intensity response and the complex amplitude appearing in Guo's propagation calculation. Identify the restriction from Guo's volumetric relation to the nominal plane as an adaptation. Keep the response uncalibrated; introduce convolution only if a specified condition supports spatial invariance.
- **P10 — From intensity to the supplied views.** Complete E3-1 with pixel-area/exposure integration and detector conversion, explicitly locating spectral treatment, background, and a residual if used. Connect the resulting `Y` to the existing extraction relation. Briefly distinguish that raw measurement model from processed/HDR input arrays whose preparation is described in Chapter 4. State the quantities needed to relate pixels to object-plane length without deriving an unverified numerical scale.

**Evidence:** S2 §2.3, especially Eq. (4), for optical superposition; the current opening and I1/I2 identify data and calibration boundaries. Detector conversion is a declared modeling layer whose local factors remain unresolved. **Equation:** E3-1 only. **Transition:** a measurement model describes how views form; corresponding image structure is an additional assumption needed for their alignment.

### 3.4 Correspondence assumptions and the chapter handoff — P11–P13

**Purpose:** give later chapters a bounded interpretation of alignment, without retelling the estimator.

- **P11 — Shared image structure.** State the image-domain approximation: on a common grid, enough structure in different views can correspond after a coordinate mapping, with residual differences in blur, brightness, or visible content. Explain why this is stronger than merely imaging the same specimen. The common image is a reference representation, not automatically a fluorophore-density map, an external-camera ground truth, or an exact full-aperture image. Keep this in prose; introduce no extra latent-image symbol unless it is used later.
- **P12 — Validity and unrepresented differences.** Place limits beside the approximation: axial structure, missing/overlapping features, view-dependent blur or throughput, weak signal, and incomplete common support. Coordinate alignment can represent positional disagreement while other differences remain. Do not diagnose a scattering mechanism from a displacement, or promise preserved geometry, integrated fluorescence, or improved resolution. Explain the relevant physical causes within this chapter and Chapter 5 for the numerical remapping limits.
- **P13 — Established objects and remaining evidence.** Close with the established scene/measurement/view distinction, coordinate convention, finite pupil response, and declared correspondence assumption. Connect to this chapter’s degradation account, Chapter 5's single global-then-local method, and Chapter 4's calibration and evaluation evidence. If naming outputs, call `G` the intermediate global-stage average and `I_rect` the final rectified image. Leave their definitions and comparison to Chapters 4–5.

**Evidence:** A1 is the declared approximation; I1 §§5.6/13 and the current Chapter 5 bound its interpretation. The inspected sources do not validate this approximation for the local acquisitions. **Visual/equation:** none by default. **Endpoint:** the reader knows what the method acts on and which model assumptions its results must be assessed against.

## 4. Candidate mathematics and notation

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

**Omit by default:** another displayed `V = E(Y)` or array-shape equation; a radiance parameterization already explained by the coordinates; Debye/Fresnel derivations (the lenslet occupancy and resolution relations are no longer omitted: B4 owns them, with derivations in Appendix B); a volumetric inverse objective; a new displacement equation; and Chapter 5's score, remap, or mean equations. A later equation should be added only to answer an unresolved question that prose and F3-1 cannot answer.

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
| Design relations (B4) | `d` lenslet pitch; `\rho` pupil-to-pitch ratio $D'_{\mathrm{pupil}}/d$; $\mathrm{NA}_{\mathrm{view}}$; $R_{xy}^{\mathrm{view}}$, $R_z$; $M_T$ total magnification; `P` camera pixel pitch; $S_r$ sampling rate | Guo's occupancy ratio is called `N`; this thesis already uses `N` for retained views, so use `\rho` for the ratio and say that it need not be an integer or equal `N`. Use capital `P` for pixel pitch only if Chapter 5's lowercase `p` is never nearby; otherwise rename. |

## 5. Candidate conceptual visual

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

A real sensor example is optional only if it replaces a schematic panel and adds needed information. It requires input identity, extraction revision/geometry, preprocessing, orientation, and display provenance using the existing [figure template](../research-context/result-provenance/figure-provenance-template.yaml). Acquisition data are unnecessary for the conceptual figure. Place numerical setup detail in Chapter 4/supporting records and result panels/curves in Chapter 6, subject to the authoritative budget.

## 6. Evidence and citation map

### Primary sources

Use the existing keys in [the active bibliography](../overleaf/back/thesis.bib). Attach citations to the physical statement they support; identify the thesis's model restrictions separately. Reading notes are navigation aids, not substitutes for primary passages.

| ID / key | Passage and inspection status in this revision | Use and limit |
| --- | --- | --- |
| **S1 — `levoy2009recordingControlling4d`** | [Author's article page](https://graphics.stanford.edu/papers/lfillumination/) inspected. The previous plan recorded inspection of pp. 145–146 and Fig. 2 in the [author-hosted PDF](https://graphics.stanford.edu/papers/lfillumination/levoy-lfillumination-jmicr09-lores.pdf); fresh passage retrieval timed out. | Retain the opening's geometric citation. Recheck the coordinate passage before revising its scientific wording. Image-plane LFM is not the FLFM extraction geometry. |
| **S2 — `guo2019fourierLightField`** | Guo et al., DOI [10.1364/OE.27.025573](https://doi.org/10.1364/OE.27.025573). Re-inspected publisher-provided article text [hosted on ResearchGate](https://www.researchgate.net/publication/335415040_Fourier_light-field_microscopy), §§2.1–2.4, Fig. 1 caption, and Eq. (4) with its definitions. | Pupil segmentation and intensity superposition. The nominal-plane restriction is an adaptation; the local response is not established by their PSF validation. Their §2.4 explains a different inversion procedure. |
| **S3 — `galdon2022fourierLightfieldDesignGuide`** | Galdón et al., DOI [10.1364/AO.453723](https://doi.org/10.1364/AO.453723). Re-inspected [article text hosted on ResearchGate](https://www.researchgate.net/publication/358915340_Fourier_lightfield_microscopy_a_practical_design_guide), §2, Fig. 1, and the aperture/magnification/sampling discussion. The [institutional PDF](https://www.uv.es/imaging3/PDFs/2022_AO_61_2558.pdf) could not be retrieved. | Finite pupil support and sampling dependencies. Do not transplant its view-count recommendations or design equations into the relayed local instrument as calibrated values. |

Yun's setup guide is no longer required by the core outline. Detailed conjugation procedures, tolerances, or NA-matching prescriptions belong with a separately inspected setup account in Chapter 4. The other literature remains available to its owning chapters; this plan adds no new bibliography entry. The design relations in B2–B4 cite `goodman2017fourierOptics` and `cong2017xlfmZebrafish`, both already in `thesis.bib`, and use Guo (S2) beyond the passages inspected for the earlier plan: its design-principle section and Appendices B–E and H (pp. 25582–25593) were read in the local PDF on 2026-11-12, with equation typography still to be checked on rendered pages.

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
| Chapter 4 uses zero-based view indices while Chapters 3/5 use one-based indices | Preserve the explicit Chapter 3 mapping; flag Chapter 4 for a later consistency edit. | State whether Chapter 4 describes arrays or thesis notation. Do not silently change the sensor-axis order. |
| “Central view” for even `N` | Leave reference selection in Chapter 5. | Define its discrete reference index there instead of assuming a lenslet on the geometric center. |
| Emission band and detector conversion | Keep E3-1 symbolic and its intensity/count distinction explicit. | Emission filters/band, exposure, gain/offset handling, and processing state for the selected acquisition. |
| Pupil conjugation and object-plane sampling | Use the intended geometry and symbolic scale dependencies. | Calibration/alignment evidence, sensor pixel pitch, effective magnification, extraction mapping, and any resampling. |
| Nominally 2D approximation | Declare it with its limitations. | Specimen axial extent, focus, and conditions for interpreting the selected scene as approximately planar. |
| Response and photometry | General uncalibrated intensity response; no statistical noise law. | Evidence for a common PSF/convolution, view brightness calibration, or a detector likelihood if any is later needed. |
| Hardware statements differ in strength between Chapter 4 and I2 | Use no model-specific objective assignment or sample-mount claim in Chapter 3. | Reconcile Chapter 4's two N40X-PF assignments and acquisition-specific mounting with their supporting records in the setup chapter. |
| Measured panel or result interpretation | Original schematic; no local performance conclusion. | Selected acquisition/run, exact revision, calibration, evaluation, and figure provenance. Current source defaults cannot fill an older run's missing revision. |

### Checks for candidate material retained in a later draft

- The first four existing paragraphs remain the starting point; definitions appear once and retain their current coordinate/index meanings.
- The revised optical-path passage separates complex amplitude, intensity, and digital counts and explains the relayed elemental-image plane.
- Every section contributes a needed definition, physical relationship, assumption, or limit. Introduction, method, and setup material is handled by short cross-references.
- E3-1 has consistent units, declared normalization, explicit sampling/conversion, and a primary-source/adaptation boundary. Extraction still follows camera integration.
- F3-1 answers the pupil-to-view question with consistent planes, indices, and conceptual status. Additional assets require a specific unresolved explanatory need.
- Correspondence is stated as an assumption with residual disagreement and support limits. It is not inferred as a guaranteed consequence of the forward model.
- The close identifies what Chapters 4–5 and the results can rely on and which calibration/validity evidence remains open. It introduces no new result or estimator.
- Check citations against the actual adjacent claims and reconcile cross-chapter notation before finalizing the chapter.

**Historical outline workflow and verification boundary (2026-10-08):** ARS-Codex 3.22.0 was consulted in `academic-paper` / `outline-only` mode using its Structure Architect and writing-quality guidance, together with the local standards. This is an inline outline revision; `criteria_binding_unavailable` (no formal review-criteria binding supplied). No independent panel, formal citation/retraction audit, optical simulation, experiment replay, finalized equation verification, or thesis compilation was performed. The revised plan is the deliverable; drafting and figure production remain later work.
