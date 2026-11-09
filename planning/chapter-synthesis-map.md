# Chapter Synthesis Map

> **Status:** active
>
> **Reviewed:** 2026-11-09

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
