# Figure and Table Backlog

> **Status:** candidate
>
> **Reviewed:** 2026-11-08

Observation date: 2026-09-20

This backlog follows the thesis structure, not the database chronology. Rows are
candidate slots for future thesis figures and tables. Source assets now exist for
one qualitative reconstruction comparison, but no result has been promoted to a
thesis-final figure because exact run provenance and quantitative support are
still being checked.

Every proposed global/local comparison is a comparison of the intermediate
global-stage average with the final rectified image after local refinement in
one two-stage run. Verify that pairing in the selected run record.

## Current placement and space policy

The [authoritative structure and budget](../planning/revised-thesis-structure.md)
governs these candidates. The IDs below are backlog identifiers, not promised
printed figure/table numbers or a requirement to include every candidate.
Figures, captions, and tables have separate footprint from prose/equation space.

| Existing item or pool | Current manuscript location | Intended role / later decision |
| --- | --- | --- |
| Reconstruction sequence schematic | Chapter 5, Figure 5.1 | Candidate for the single method-figure slot; no selection made by this migration. |
| Image evolution / backward sampling | Chapter 5, Figure 5.2 | Also retained intact; the two current figures exceed the eventual single slot. Selection/relocation remains pending. |
| Acquisition/run archive table and full protocol text | Chapter 4, moved intact with the setup body | Keep a minimal summary in Our setup; detailed reporting will be assigned to appendices/provenance in later content work. |
| System schematic and components | Backlog; no new manuscript asset | Chapter 4 instrument explanation; detailed components in supporting material. |
| Pupil/view model schematic | Backlog | Chapter 3 explanatory candidate, not a new fixed figure quota. |
| Eyedrop/chicken and diagnostic pools | Candidate records outside the manuscript | Chapter 6 if qualified; supplementary material otherwise. Chapter 7 interprets already presented evidence. |

The method has one future approximately full-page figure allowance. Keeping two
figures now is inherited migration debt, not an approved departure. No new figure
is selected, produced, removed, or relocated in this structural pass.

## Earlier preparation notes (retained discovery context)

- The introduction now has a complete LFM-to-FLFM motivation and explicitly
  limits the thesis scope to 2D fluorescent scenes and elemental-view
  rectification rather than full volumetric deconvolution.
- A reusable LaTeX trio-comparison template now renders ThorCam, global, and
  local panels with paired zoom crops.
- The `eyedrop_3_6` source bundle contains full-field and zoom PNGs for the
  ThorCam/global/local comparison, and a regenerated PDF is available for
  inspection. Its preparation is replayable through
  `scripts/figure-preparation/`, using its saved `trio-recipe.json`. It remains a
  candidate result, not final thesis evidence.

## Figure Candidates

| ID | Candidate item | Thesis purpose | Chapter | Broad evidence sources | Selection status |
| --- | --- | --- | --- | --- | --- |
| Fig. 1 | Problem and thesis overview | Show conventional fluorescence path, FLFM path, rectification, and validation comparison. | Chapter 1 (candidate; space check required) | Could be drawn from system schematic plus one representative output. | Conceptual; no database asset selected. |
| Fig. 2 | System schematic | Show illumination path, FLFM main path, ThorCam path, and Validation Camera path. | Chapter 4 / supporting records | `main`, `thorcam`, `validation` folder structure; component notes still needed. | Needs manual system detail gathering. |
| Fig. 3 | View grid and displacement model | Explain elemental views, reference view, global translation, local displacement, and backward remap. | Chapters 3/5 (candidate; check ownership) | Method notes and representative `figures/original_views`, `global_maps`, `pixel_maps`. | Use generated diagram plus optional real example later. |
| Fig. 4 | Rectification pipeline | Show view extraction -> global alignment -> pixelwise refinement -> averaged output -> downstream validation. | Chapters 3/5 (candidate; check ownership) | `method-notes/rectification-pipeline/*`, modern run artifacts. | Diagram first; examples later. |
| Fig. 5 | Eyedrop flagship result | Compare the two stage outputs from one run and, if available, add ThorCam/Validation context. | Chapter 6 | Shortlist source: [experiment-summaries/eyedrop-result-aggregation.md](experiment-summaries/eyedrop-result-aggregation.md). Current scene: `beads_2um_dense4_eyedrop_4kus`, `3_6_26\algo_run\regular_run_best`; candidate provenance: [fig_eyedrop_3_6.yaml](result-provenance/fig_eyedrop_3_6.yaml). Current visual candidate: `candidate-outputs/figures-source/eyedrop_3_6/`. | Dataset, two-stage run config, and algorithm artifacts are identified. Candidate only: exact source-code revision and some comparison-processing history remain unresolved; see provenance record. |
| Fig. 6 | Chicken-breast flagship result | Same panel logic as eyedrop, with scattering/aberrating tissue condition. | Chapter 6 | Shortlist discovery layer: [experiment-summaries/chicken-result-aggregation.md](experiment-summaries/chicken-result-aggregation.md). Broad candidates: `21_6_26\algo_run\power_2`, `21_6_26\algo_run\only_5x5`, `12_7_26`, `13_7_26`, `15_7_26`. | Not selected; curation shortlist only. |
| Fig. 7 | Validation/ThorCam comparison | Demonstrate downstream comparison workflow and registration caveats. | Chapter 6; interpretation in Chapter 7 | `7_7_26`, `9_7_26`, `12_7_26`, `13_7_26` `validate_rectification` folders; March comparison workspaces. | Not selected. |
| Fig. 8 | Close-bead or support example | Support compactness/separability claim with crops and line profiles. | Chapter 6; interpretation in Chapter 7 | Sparse eyedrop/chicken candidates from May-July; validation workspaces and output crops to be chosen. | Requires metric/protocol decision. |
| Appendix Fig. A | Sweep lifecycle and metric behavior | Preserve parameter-sweep and metric-explorer evidence without cluttering main text. | Appendix | `20_4_26\algo_run\pixel_threshold_sweep`, `24_2_26\algo_run\sobel_exp`, `28_2_26\different_rectification_methods*`, `5_3_26\localrectexp*`. | Appendix pool. |

## Table Candidates

| ID | Candidate item | Thesis purpose | Chapter | Broad evidence sources | Selection status |
| --- | --- | --- | --- | --- | --- |
| Table 1 | Component specifications | Reproducible optical/electronic setup. | Chapter 4 summary / Appendix | Lab notes, component specs, root calibration files; not fully represented in scan. | Needs manual filling. |
| Table 2 | Dataset/acquisition overview | Summarize sample type, medium, acquisition date, FLFM/ThorCam/Validation availability. | Chapter 4 / supporting records | Date folders with `main`, `thorcam`, `validation`, `algo_run`; `datasets-and-runs-broad.md`. | Can be drafted broad now, refined later. |
| Table 3 | Hyperparameters | Explain `max_displacement`, smoothing sigmas, thresholds, score family, alpha/weights, sweep settings. | Chapter 5 essentials / Appendix | `sweep_spec.json`, `config.json`, `method-notes/rectification-pipeline/implementation-digest.md`. | Should use chosen result runs once selected. |
| Table 4 | Quantitative result summary | Compare intermediate and final metrics within each two-stage run, with ThorCam/Validation context where justified. | Chapter 6 | `metric_record.json`, `leaderboard.json`, validation/trio outputs if available. | Wait until flagship results selected. |
| Appendix Table A | Sweep inventory | Preserve broader experiment history and sensitivity scans. | Appendix | `experiment_manifest.json`, `stage1_summary.json`, `stage2_summary.json`, `run_state.json`. | Broad inventory candidate. |

## Provenance Fields To Fill Later

For every selected figure or table, create or fill a provenance record under
`result-provenance` using the existing templates. Minimum fields:

- Thesis chapter and intended location.
- Source repository, branch, commit, and script when applicable.
- Source database path and selected run folder.
- Dataset ID and acquisition/preprocessing notes.
- Exact original output path.
- Caption draft and claim supported.
- Known limitations and registration caveats.

## Current Policy

- Keep provisional assets under `candidate-outputs/figures-source/` until the
  result is qualified and selected. Move selected assets into
  `finalized-outputs/` before adding them to `overleaf/`.
- Do not treat PPTs as final provenance.
- Do not finalize quantitative claims until the same-resolution ThorCam and
  Validation Camera protocols are fixed.
- Treat the current `eyedrop_3_6` PDF as qualitative inspection evidence only;
  it does not by itself establish that local rectification improves the result.
