# Figure and Table Backlog

> **Status:** candidate
>
> **Reviewed:** 2026-09-24

Observation date: 2026-09-20

This backlog follows the thesis structure, not the database chronology. Rows are
candidate slots for future thesis figures and tables. Source assets now exist for
one qualitative reconstruction comparison, but no result has been promoted to a
thesis-final figure because exact run provenance and quantitative support are
still being checked.

## Recent progress

- The introduction now has a complete LFM-to-FLFM motivation and explicitly
  limits the thesis scope to 2D fluorescent scenes and elemental-view
  rectification rather than full volumetric deconvolution.
- A reusable LaTeX trio-comparison template now renders ThorCam, global, and
  local panels with paired zoom crops.
- The `eyedrop_3_6` source bundle contains full-field and zoom PNGs for the
  ThorCam/global/local comparison, and a regenerated PDF is available for
  inspection. It remains a candidate result, not final thesis evidence.

## Figure Candidates

| ID | Candidate item | Thesis purpose | Chapter | Broad evidence sources | Selection status |
| --- | --- | --- | --- | --- | --- |
| Fig. 1 | Problem and thesis overview | Show conventional fluorescence path, FLFM path, rectification, and validation comparison. | Introduction | Could be drawn from system schematic plus one representative output. | Conceptual; no database asset selected. |
| Fig. 2 | System schematic | Show illumination path, FLFM main path, ThorCam path, and Validation Camera path. | System | `main`, `thorcam`, `validation` folder structure; component notes still needed. | Needs manual system detail gathering. |
| Fig. 3 | View grid and displacement model | Explain elemental views, reference view, global translation, local displacement, and backward remap. | Model/Method | Method notes and representative `figures/original_views`, `global_maps`, `pixel_maps`. | Use generated diagram plus optional real example later. |
| Fig. 4 | Rectification pipeline | Show view extraction -> global alignment -> pixelwise refinement -> averaged output -> downstream validation. | Model/Method | `method-notes/rectification-pipeline/*`, modern run artifacts. | Diagram first; examples later. |
| Fig. 5 | Eyedrop flagship result | Compare global vs local rectification and, if available, ThorCam/Validation comparison. | Results | Shortlist source: [experiment-summaries/eyedrop-result-aggregation.md](experiment-summaries/eyedrop-result-aggregation.md). Current scene: `beads_2um_dense4_eyedrop_4kus`, `3_6_26\algo_run\regular_run_best`; candidate provenance: [fig_eyedrop_3_6.yaml](result-provenance/fig_eyedrop_3_6.yaml). Current visual candidate: `candidate-outputs/figures-source/eyedrop_3_6/`. | Dataset, combined run config, and algorithm artifacts are identified. Candidate only: exact source-code revision and interactive MATLAB matching/alignment/zoom settings are not recorded; see provenance record. |
| Fig. 6 | Chicken-breast flagship result | Same panel logic as eyedrop, with scattering/aberrating tissue condition. | Results | Shortlist discovery layer: [experiment-summaries/chicken-result-aggregation.md](experiment-summaries/chicken-result-aggregation.md). Broad candidates: `21_6_26\algo_run\power_2`, `21_6_26\algo_run\only_5x5`, `12_7_26`, `13_7_26`, `15_7_26`. | Not selected; curation shortlist only. |
| Fig. 7 | Validation/ThorCam comparison | Demonstrate downstream comparison workflow and registration caveats. | Results/Discussion | `7_7_26`, `9_7_26`, `12_7_26`, `13_7_26` `validate_rectification` folders; March comparison workspaces. | Not selected. |
| Fig. 8 | Close-bead or support example | Support compactness/separability claim with crops and line profiles. | Results/Discussion | Sparse eyedrop/chicken candidates from May-July; validation workspaces and output crops to be chosen. | Requires metric/protocol decision. |
| Appendix Fig. A | Sweep lifecycle and metric behavior | Preserve parameter-sweep and metric-explorer evidence without cluttering main text. | Appendix | `20_4_26\algo_run\pixel_threshold_sweep`, `24_2_26\algo_run\sobel_exp`, `28_2_26\different_rectification_methods*`, `5_3_26\localrectexp*`. | Appendix pool. |

## Table Candidates

| ID | Candidate item | Thesis purpose | Chapter | Broad evidence sources | Selection status |
| --- | --- | --- | --- | --- | --- |
| Table 1 | Component specifications | Reproducible optical/electronic setup. | System or Appendix | Lab notes, component specs, root calibration files; not fully represented in scan. | Needs manual filling. |
| Table 2 | Dataset/acquisition overview | Summarize sample type, medium, acquisition date, FLFM/ThorCam/Validation availability. | System | Date folders with `main`, `thorcam`, `validation`, `algo_run`; `datasets-and-runs-broad.md`. | Can be drafted broad now, refined later. |
| Table 3 | Hyperparameters | Explain `max_displacement`, smoothing sigmas, thresholds, score family, alpha/weights, sweep settings. | Method | `sweep_spec.json`, `config.json`, `method-notes/rectification-pipeline/implementation-digest.md`. | Should use chosen result runs once selected. |
| Table 4 | Quantitative result summary | Compare global/local/ThorCam/Validation metrics per condition. | Results | `metric_record.json`, `leaderboard.json`, validation/trio outputs if available. | Wait until flagship results selected. |
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
