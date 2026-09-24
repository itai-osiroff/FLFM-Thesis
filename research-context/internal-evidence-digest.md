# Internal Evidence Digest

> **Status:** reference
>
> **Reviewed:** 2026-09-24

Observation date: 2026-07-17

This file organizes author-generated research context for thesis writing. It is
not final result provenance. Use it to decide which claims are currently safe,
which claims need more evidence, and where internal notes belong in the revised
chapter structure.

## Method Evidence

| Source | Thesis use | Safe claims | Caution |
| --- | --- | --- | --- |
| `method-notes/rectification-pipeline/implementation-digest.md` | Main source for Chapter 5 method description. | The implementation represents an acquisition as an elemental-view grid, applies translation-only global alignment, optionally applies dense pixelwise displacement refinement, and averages remapped views. | Do not describe the method as learned reconstruction, full deconvolution, full scattering inversion, or true local NCC/ZNCC. |
| `method-notes/rectification-pipeline/source-map.md` | Trace thesis wording back to code anchors. | Configuration, strategy dispatch, local score families, sweep persistence, metrics, and validation tools have source-level anchors. | The map refers to an observed checkout; re-check if the algorithm repository changes. |
| `method-notes/rectification-pipeline/thesis-writing-translation.md` | Terminology and wording guardrails. | Use `elemental view`, `view grid`, `global rectification`, `pixelwise refinement`, `combined rectification`, and `validation oracle` consistently. | Keep validation/ThorCam as downstream evaluation unless a specific validation-guided workflow is documented. |

## Dataset And Result Evidence

| Source | Thesis use | Strongest current support | Open work |
| --- | --- | --- | --- |
| `datasets-and-runs-broad.md` | Chapter 6 dataset/evaluation inventory and result-search guide. | Identifies eyedrop, chicken, validation, ThorCam, method-sweep, and appendix candidate pools. | Convert broad pools into selected result blocks only after exact run provenance is traced. |
| `experiment-summaries/eyedrop-result-aggregation.md` | Discovery layer for eyedrop flagship candidates. | June 3 and June 10 dense eyedrop scenes are plausible local-improvement or close-bead examples. | Reconcile the tentative `17.6.26` rows before using them; trace all candidates to `algo_run` artifacts. |
| `experiment-summaries/chicken-result-aggregation.md` | Discovery layer for chicken-breast flagship candidates. | `2_7_26` sparse2 and `13_7_26` dense are leading candidates for local-stage and dense chicken evidence. | Do not use deck screenshots as provenance; recover exact selected runs, configs, metrics, and validation workspaces. |
| `figure-and-table-backlog.md` | Chapter 6-8 figure/table planning. | Defines candidate slots for system schematic, view-grid model, pipeline, eyedrop/chicken results, validation, and appendix sweeps. | Keep assets out of `overleaf/` until final selections and provenance records exist. |

## Chapter Placement

| Revised chapter | Internal material to use |
| --- | --- |
| Chapter 1: Introduction | Central thesis claim from `thesis-narrative-map.md`; figure backlog overview figure; claim tracker. |
| Chapter 3: FLFM Forward Model and Sampling Geometry | View-grid terminology from method translation notes; system-level view-grid concept from implementation digest. |
| Chapter 5: Rectification-Based Reconstruction Method | Implementation digest, source map, and safe method wording. |
| Chapter 6: Experimental Setup, Data, and Evaluation Protocol | Dataset/run map, database inventory, validation workspace guidance, figure/table backlog. |
| Chapter 7: Results | Eyedrop and chicken aggregation notes after exact run provenance is traced. |
| Chapter 8: Discussion | Method caveats, validation caveats, no-change chicken examples, unresolved provenance questions, metric limitations. |

## Claim Controls

- Core claim should remain bounded to useful recovery of 2D fluorescent bead
  scenes under tested eyedrop and chicken-breast media.
- Local-refinement claims need paired global/local evidence and preferably
  crops, line profiles, or metrics.
- ThorCam and Validation Camera comparisons are downstream evaluation evidence,
  not training or tuning evidence for the blind rectifier.
- Close-bead/support claims require crop-level support, not only full-panel
  visual comparisons.
- Implementation claims should cite the observed source checkout or refreshed
  source map, not memory of older branches.
