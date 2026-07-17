# Database Inventory Notes

Observation date: 2026-07-16

Source database:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output`

This file records what the first broad scan found. It is meant to support
navigation and later extraction, not to replace the database.

## Size and File-Type Profile

Approximate scan result:

| Measure | Value |
| --- | ---: |
| Total files | 234,273 |
| Total size | 405.92 GB |

Dominant extensions:

| Extension | Count | Interpretation |
| --- | ---: | --- |
| `.jpg` | 221,650 | Generated visual reports, view panels, maps, overlays, averages. |
| `.npy` | 3,138 | Saved generated or rectified view stacks. |
| `.json` | 2,544 | Configs, metric records, manifests, run states, summaries. |
| `.png` | 1,843 | Preview images, figures, reports, helper outputs. |
| `.npz` | 1,318 | Saved workspaces and validation workspaces. |
| `.mat` | 1,240 | MATLAB workspaces and converted data. |
| `.tif` / `.tiff` | 1,830 | Raw or converted camera acquisitions and calibration images. |
| `.raw` | 241 | Raw FLFM data. |
| `.csv` | 108 | Analysis and leaderboard tables. |
| `.pptx` | 29 | Human-curated result decks and comparison decks. |
| `.m` | 14 | Root MATLAB helpers and ad hoc analysis scripts. |

## Recurring Directory Roles

| Directory name | Observed role |
| --- | --- |
| `main` | FLFM/main camera acquisitions or converted source images. |
| `thorcam` | ThorCam comparison acquisitions. |
| `validation` / `val` | Validation Camera acquisitions or validation references. |
| `algo_run` | Rectification runs, sweeps, generated workspaces, metric records, visual outputs. |
| `validate_rectification` | Saved validation/ThorCam alignment workspaces and overlay/difference images. |
| `ppt` | Curated presentation decks, usually downstream of analysis. |
| `figures` | Per-run generated visual report root. |
| `original_views` | Extracted elemental views before rectification. |
| `global_rectified_views` | Elemental views after global translation alignment. |
| `rectified_views` | Elemental views after final local/pixelwise or combined rectification. |
| `global_maps` | Global translation similarity maps. |
| `pixel_maps` | Pixelwise/local displacement maps. |
| `overlays` | View overlays and comparison images. |
| `averages` | Global/local/final averaged outputs. |

## Metadata File Roles

| File name | Count from scan | Why it matters |
| --- | ---: | --- |
| `config.json` | 1,166 | Per-run rectification hyperparameters. |
| `metric_record.json` | 744 | Per-run metrics, configuration, signatures, and artifact paths. |
| `run_state.json` | 104 | Sweep state, generations, runs, compatibility, merge history. |
| `analysis.json` / `summary.json` | 53 each | Sweep-level metric summaries and result summaries. |
| `best_configs.json`, `leaderboard.json`, `stage1_summary.json` | 41 each | Ranking and stage-level summary artifacts. |
| `experiment_manifest.json` | 37 | Dataset list, strategy, generation, scoring, reporting, products path. |
| `sweep_spec.json` | 15 | Original sweep intent: datasets, search spaces, stages, scoring. |
| `stage2_summary.json` | 7 | Two-stage refinement outcomes. |
| `validation_workspace.npz` | many, not globally counted here | Saved validation/ThorCam preprocessing and alignment state. |

## Root-Level Helper Files

| File | Broad role |
| --- | --- |
| `blind_deconvolution.m` | Ad hoc ThorCam/microscope blind deconvolution experiment with anti-ringing settings. |
| `compare_workspaces.m` | MATLAB workspace comparison helper. |
| `convert_raw_tiff.m` | Raw/TIFF conversion helper. |
| `dark_frame_subtraction.m` | Dark-frame subtraction helper. |
| `gain_im_process.m`, `camera_gain_calc.m`, `main_thorcam_gain.xlsx` | Gain calibration and processing support. |
| `max_align.m` | Manual max-alignment/reconstruction experiment helper. |
| `temp.m` | Ad hoc figure generation and comparison script. |
| `open_figure_save_x4NN*.m` | MATLAB figure export helpers. |

## Largest/High-Value Date Buckets

| Date folder | Approximate role from broad scan |
| --- | --- |
| `24_3_26` | Very large March result pool with main/thorcam/val/comps/algo runs; likely important historical comparison and validation material. |
| `20_4_26` | Large two-stage pixel-threshold sweep and regular run material. |
| `29_5_26` | Mixed eyedrop/chicken combined sweeps with several power variants. |
| `3_6_26` | Dense eyedrop modern runs with power/sigma/confidence variants. |
| `10_6_26` | Dense eyedrop modern run family with complete main/thorcam/validation/ppt structure. |
| `21_6_26` | Dense chicken modern run family with power and 5x5 variants. |
| `7_7_26`, `9_7_26`, `12_7_26`, `13_7_26` | July chicken runs with saved validation/ThorCam workspaces. |
| `15_7_26` | Latest dense chicken-looking acquisition and algo runs. |

## Broad Next Extraction Pass

When moving from broad map to shortlist, extract for each candidate run root:

1. `experiment_manifest.json` summary: generated date, datasets, strategy,
   scoring, generation ID.
2. `sweep_spec.json` summary: search spaces and stage settings.
3. `leaderboard.json` and `stage*_summary.json`: number of runs, failures,
   top candidates.
4. Per-dataset `metric_record.json`: artifact paths and metrics.
5. Any `validation_workspace.npz`: alignment status and transform provenance.
6. Existing PPT or visual-report paths as discovery aids only.

