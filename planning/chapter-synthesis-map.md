# Chapter Synthesis Map

Observation date: 2026-07-17

This map turns literature notes and internal research context into thesis
chapter work packages. It should be updated after each deep reading note.

## Source Note Index

| Source note | Source type | Primary thesis role | Reliability label |
| --- | --- | --- | --- |
| `literature/notes/levoy-2009-recording-controlling-4d-light-field.md` | Primary article | LFM background, 4D light-field geometry, spatial-angular tradeoff, limited aberration correction precedent. | Citable after BibTeX cleanup. |
| `literature/notes/fourier-light-field-microscopy-local-note.md` | Local secondary note | FLFM theory checklist and reading queue for primary papers. | Do not cite directly unless provenance is confirmed. |
| `literature/notes/ng-hanrahan-digital-correction-light-field-aberrations.md` | Article or paper-like local PDF | Digital light-field aberration correction and ray-space rectification precedent. | Citable only after venue metadata is verified. |
| `literature/notes/goodman-2015-statistical-optics.md` | Book | Statistical optics, coherence, random phase screens, speckle, noise, and random-media limits. | Citable. |
| `literature/notes/thesis-example-saiko-2023-material-acquisition.md` | Thesis example | Compact MSc structure, appendix placement, cautious discussion. | Structure reference only. |
| `literature/notes/thesis-example-monin-2026-shaping-light.md` | Thesis example | Contribution framing, notation/front matter, optical setup appendices. | Structure reference only. |
| `research-context/internal-evidence-digest.md` | Internal context digest | Method/result evidence controls and chapter placement. | Internal provenance; refresh if source repos change. |

## Chapter 2: Background and Literature

**Job:** Establish the scientific and technical context before introducing this
thesis' model and method.

**Material to synthesize:**

- Fluorescence microscopy trades acquisition speed, optical sectioning, dose,
  and resolution across widefield, confocal, two-photon, light-sheet, LFM, and
  FLFM approaches.
- Light-field microscopy captures spatial and angular information in a single
  snapshot, with a spatial-angular tradeoff set by finite aperture and sensor
  sampling.
- FLFM is the most relevant light-field variant because it places the microlens
  array in a Fourier/pupil-conjugate plane and produces elemental views suited
  to this thesis' view-grid rectification language.
- Aberration correction and statistical optics provide context for why
  tissue-induced degradation is difficult and why the thesis should avoid
  claiming full scattering inversion.

**Source notes to use:** Levoy 2009, Fourier Light Field Microscopy, Ren Ng
thesis, Goodman statistical optics.

## Chapter 3: FLFM Forward Model and Sampling Geometry

**Job:** Define what is measured and what simplifying model the thesis uses.

**Material to synthesize:**

- The acquisition is represented as a square grid of elemental views.
- Each elemental view can be discussed as a reduced-aperture view of the same
  2D fluorescent scene under a viewpoint-dependent displacement/degradation.
- The thesis model should emphasize the practical view-grid representation used
  by the rectification software, not a full volumetric deconvolution model.
- Relevant equations should include only the minimum needed to relate rays,
  angular sampling, pupil partitioning, view formation, displacement, warping,
  and averaging.

**Source notes to use:** FLFM source, Levoy 2009, internal method terminology.

## Chapter 4: Aberration and Scattering in Biological Tissue

**Job:** Explain the degradation mechanisms and the boundaries of the thesis.

**Material to synthesize:**

- Tissue or tissue-like media introduce aberration, scattering, blur, contrast
  loss, and view-dependent distortions.
- The thesis' rectification method should be framed as compensating observable
  inter-view misalignment and local displacement effects, not as estimating the
  full optical transfer of a scattering medium.
- Discussion hooks should include why some scenes improve dramatically, some
  improve modestly, and some remain dominated by residual blur or weak
  validation correspondence.

**Source notes to use:** Goodman statistical optics, Ren Ng aberration
correction sections, chicken/eyedrop caveats.

## Chapter 5: Rectification-Based Reconstruction Method

**Job:** Present the actual implemented method with precise boundaries.

**Material to synthesize:**

- Input contract: extracted view grid or HDR exposure stack.
- Global stage: one translation per view, estimated by correlation and applied
  as affine translation.
- Pixelwise stage: bounded dense local displacement search and backward remap.
- Combined stage: global alignment initializes local refinement.
- Output: average of remapped elemental views, plus saved stacks and metadata.
- Sweep layer: parameterized comparison of strategies, scoring families, and
  post-run metrics.

**Source notes to use:** implementation digest, source map, thesis-writing
translation notes.

## Chapter 6: Experimental Setup, Data, and Evaluation Protocol

**Job:** Make the evidence reproducible before the results chapter.

**Material to synthesize:**

- System and camera paths: FLFM main image, ThorCam, Validation Camera.
- Dataset organization by acquisition date and sample/medium.
- Result provenance protocol: source dataset, code commit, sweep spec, run
  state, metric record, selected artifact, and validation workspace.
- Evaluation protocol: global/local comparison, metric records, ThorCam and
  validation comparisons as downstream checks.

**Source notes to use:** dataset/run map, database inventory, figure/table
backlog, validation notes.

## Chapter 7: Results

**Job:** Support the central thesis claims with a small number of traceable
result blocks.

**Material to synthesize:**

- Eyedrop result block: likely June 10 or June 3 dense scenes after provenance
  reconciliation.
- Chicken result block: likely `2_7_26` sparse2 for local-stage evidence and
  `13_7_26` dense for a dense chicken example.
- Validation/ThorCam result block: only after same-resolution registration and
  workspace provenance are confirmed.
- Close-bead/support block: only if crop-level line profiles or compactness
  metrics support the claim.

**Source notes to use:** eyedrop/chicken aggregation notes, selected run
metadata, result provenance templates.

## Chapter 8: Discussion

**Job:** Interpret the results and state limits.

**Material to synthesize:**

- The method recovers useful bead-scene structure under tested media, but the
  evidence is not a general proof for arbitrary tissue, arbitrary samples, or
  3D volumetric recovery.
- Local refinement is scene- and parameter-dependent; use no-change and modest
  improvement examples honestly.
- Validation and ThorCam are valuable but protocol-sensitive.
- Current method boundaries: translation-only global stage, correlation-like
  local scores, warp-and-average output, no learned reconstruction, no full
  scattering inversion.

**Source notes to use:** claim tracker, method caveats, result caveats, final
selected figure provenance.
