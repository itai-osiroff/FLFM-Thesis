# Broad Dataset and Run Map

Observation date: 2026-07-16

Source database:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output`

This is a broad first-pass map of candidate evidence. It is not a ranking and
does not decide final thesis figures. Use it to decide what deserves closer
inspection.

## Top-Level Database Shape

- Approximate database size from scan: `234,273` files, `405.92 GB`.
- Dominant file types: `.jpg`, `.npy`, `.json`, `.png`, `.npz`, `.mat`, `.tif`,
  `.tiff`, `.raw`.
- Repeated output structure: `figures/original_views`,
  `figures/rectified_views`, `figures/pixel_maps`, `figures/overlays`,
  `figures/averages`, `figures/global_maps`, `figures/global_rectified_views`.
- Common experiment folder structure: `main`, `thorcam`, `validation` or `val`,
  `algo_run`, sometimes `validate_rectification` and `ppt`.

## Broad Eyedrop Candidate Families

| Bucket | Paths | Why it matters | Current status |
| --- | --- | --- | --- |
| PDF-selected eyedrop scenes | [experiment-summaries/eyedrop-result-aggregation.md](experiment-summaries/eyedrop-result-aggregation.md) | Curation index from `Results Aggregation - eyedrops.pdf` identifying five human-selected scenes and their qualitative significance. | Use as the eyedrop shortlist discovery layer only; final provenance remains unresolved. |
| Dense eyedrop, June 10 acquisition | `10_6_26\main`, `10_6_26\thorcam`, `10_6_26\validation`, `10_6_26\algo_run\power_2` | Modern single-stage combined sweep over seven dense eyedrop datasets. Has `sweep_spec.json`, `experiment_manifest.json`, `run_state.json`, `stage1_summary.json`, `leaderboard.json`, and per-run metric records. | Strong candidate pool for a main eyedrop result block, but final scene not selected. |
| Dense eyedrop variants, June 3 acquisition | `3_6_26\algo_run\regular_run`, `3_6_26\algo_run\power_2`, `3_6_26\algo_run\power_3`, `3_6_26\algo_run\sigma_40`, `3_6_26\algo_run\confidencegating` | Multiple modern combined runs on seven dense eyedrop datasets, with power/sigma/confidence variants. | Good comparison pool for appendix or metric sensitivity. |
| Sparse eyedrop, May 17-28 experiments | `17_5_26\algo_run\full_res*`, `25_5_26\algo_run\sparse*`, `25_5_26\algo_run\eyedrop_saprse_3_4_5*` | Sparse and full-resolution eyedrop sweeps; may contain close-bead or separability examples. The PDF's two `17.6.26` rows are tentatively mapped to `17_5_26` as a suspected date typo, but this is unverified. | Broad candidate pool; names suggest typo `saprse` in folder names, preserve paths as-is. Do not use the tentative `17.6.26 -> 17_5_26` mapping as provenance until reconciled. |
| Mixed eyedrop/chicken, May 29-June 2 | `29_5_26\algo_run\regular_run`, `power_2`, `power_3`, `power_6` | Combined sweeps include both eyedrop and chicken datasets; useful for cross-condition comparison. | Possible bridge between eyedrop and chicken result blocks. |
| Aggregate presentation material | `Results Aggregate - Eyedrop.pptx`, `3_6_26\ppt\ppt.pptx`, `10_6_26\ppt\ppt.pptx`, `17_5_26\ppt\eyedrops with FLIR.pptx`, `25_5_26\ppt\Presentation1.pptx` | Existing curated human-facing material may reveal which examples were previously considered important. | Use for inspection and figure discovery only; do not treat as provenance by itself. |

## Broad Chicken Candidate Families

| Bucket | Paths | Why it matters | Current status |
| --- | --- | --- | --- |
| Dense chicken, June 21-24 | `21_6_26\algo_run\power_2`, `21_6_26\algo_run\only_5x5` | Modern single-stage combined sweeps over ten dense/densish chicken datasets. Has modern metadata and generation products. | Strong candidate pool for main chicken result block. |
| Sparse/dense chicken with validation, July 7-13 | `7_7_26`, `9_7_26`, `12_7_26`, `13_7_26` | These folders include `main`, `thorcam`, `validation`, `algo_run`, and `validate_rectification`. July folders have saved validation workspaces and overlay/difference figures. | Strong pool for validation/ThorCam comparison, especially Chapter 5/6. |
| Recent dense chicken, July 15 | `15_7_26\main`, `15_7_26\thorcam`, `15_7_26\validation`, `15_7_26\algo_run` | Latest observed folder, with dense chicken-looking run names. | Worth later inspection; too recent to judge from broad scan. |
| Mixed eyedrop/chicken, May 29-June 2 | `29_5_26\algo_run\regular_run`, `power_2`, `power_3`, `power_6` | Contains both chicken and eyedrop datasets under comparable sweep families. | Useful if thesis needs a controlled cross-media comparison. |
| Pixel-threshold and dark-subtracted chicken sweep | `20_4_26\algo_run\pixel_threshold_sweep` | Two-stage combined sweep over 13 datasets including dense/sparse chicken dark-subtracted datasets. | Good appendix or method-sensitivity candidate. |
| Early chicken method history | `21_1_26`, `22_1_26`, `23_1_26`, `24_2_26`, `28_2_26`, `5_3_26` | Early global/local/debug/method-comparison material. | Mainly method development and appendix context unless a figure is uniquely useful. |

## Validation and ThorCam Candidate Pools

| Bucket | Paths | Evidence type | Notes |
| --- | --- | --- | --- |
| July dense chicken validation | `13_7_26\validate_rectification\beads_2um_dense*_chicken_*` | `validation_workspace.npz`, reference images, registered ThorCam images, validation overlays, difference images. | Strong downstream validation source for dense chicken. |
| July sparse chicken validation | `12_7_26\validate_rectification\beads_2um_sparse*_chicken_*`, `9_7_26\validate_rectification\beads_2um_sparse*_chicken_*`, `7_7_26\validate_rectification\beads_2um_sparse*_chicken_*` | Same validation workspace and overlay/difference evidence. | Strong downstream validation source for sparse chicken and close-bead examples. |
| March dense comparison workspaces | `23_3_26\comps`, `24_3_26\comps` | Earlier `validation_workspace.npz` files and main-vs-ThorCam comparison material. | Useful for history, appendix, or validation protocol development. |
| Early global validation comparisons | `9_2_26\algo_run\*_valthor_comp`, `22_1_26\algo_run\3000_us_only_global_valthor_comp` | Saved validation workspaces for early global-only comparisons. | Mostly baseline/method history. |

## Method and Sweep Development Buckets

| Bucket | Paths | Thesis role |
| --- | --- | --- |
| Current implementation digest | `method-notes\rectification-pipeline\implementation-digest.md` | Main Chapter 4 method source. |
| Source map | `method-notes\rectification-pipeline\source-map.md` | Evidence trail from thesis wording back to source code. |
| Thesis wording guidance | `method-notes\rectification-pipeline\thesis-writing-translation.md` | Safe terminology and caveats. |
| Sobel / guide / method experiments | `24_2_26\algo_run\sobel_exp`, `26_2_26\sobel_exp`, `28_2_26\different_rectification_methods*` | Appendix and method-development narrative. |
| Local rectification sweep windows | `5_3_26\localrectexp_maxdisp5_sweepwindwosize` | Appendix candidate for local-window sensitivity. |
| Dark subtraction and gain correction | `new_darksub_gain_algo_runs`, root `dark_frame_subtraction.m`, `gain_im_process.m`, `camera_gain_calc.m`, `main_dark_frame.tiff`, `main_thorcam_gain.xlsx` | Chapter 3 calibration/preprocessing support. |

## Metadata Files Worth Mining Later

When narrowing final results, inspect these first before browsing image folders:

- `experiment_manifest.json`: generation, dataset list, strategy, scoring,
  stage config.
- `sweep_spec.json`: intended search space and dataset inputs.
- `run_state.json`: run identity, generation identity, resume/merge history.
- `stage1_summary.json` and `stage2_summary.json`: run counts, failed runs,
  rankings.
- `leaderboard.json` / `leaderboard.csv`: candidate-level rankings.
- `metric_record.json`: per-dataset config, metric formulation, metrics, and
  artifact paths.
- `validation_workspace.npz`: saved validation/ThorCam preprocessing and
  alignment state.

## Non-Selection Notes

- This broad map intentionally includes too much. Final thesis figures should
  be selected from a much smaller shortlist.
- A folder being listed here means it is relevant-looking, not good.
- Existing PPTs are useful as discovery surfaces, but provenance should come
  from the underlying run folders and metadata.
