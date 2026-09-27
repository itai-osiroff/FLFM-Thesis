# Rectification Pipeline Source Map

> **Status:** reference
>
> **Reviewed:** 2026-09-24

Observed source checkout: `C:\Users\admin2\Documents\git_clones\algo`

Observed branch/commit: `main`, `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`

Observation date: 2026-07-16

**Thesis-use boundary (2026-09-27):** This map identifies all strategies
present in the observed software. For thesis prose, trace only the two-stage
global-then-local path. Its global-stage average is an intermediate product;
the post-refinement average is the final rectified image. Standalone mode
anchors below document code behavior, not additional thesis methods.

Line ranges below refer to the observed checkout.

## Package and Workflow Map

| Topic | Source anchor | Why it matters |
| --- | --- | --- |
| Package workflow index | `moment_images/README.md:19-35` | Lists the main tools: rectification, sweeps, visualization, metric explorer, validation, trio benchmark, gain calibration, and workspace unpacking. |
| Quick commands | `moment_images/README.md:37-117` | Shows the CLI entry points used by normal workflows. |
| Main concepts | `moment_images/README.md:125-137` | Defines view-grid shape, scripted rectification, sweeps, and post-processing tools. |
| Strategy families | `moment_images/README.md:139-154` | Summarizes `global`, `pixel`, `combined`, and canonical local metric family names. |
| Interactive workflow | `moment_images/RECTIFICATION_GUIDE.md:18-35` | Describes source selection, view extraction, strategy choice, review, and save steps. |
| Strategy descriptions | `moment_images/RECTIFICATION_GUIDE.md:54-82` | Human-readable summary of global, pixel, and combined strategies. |

## Core Rectification Entry Points

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| `RectificationRunConfig` | `moment_images/im_process.py:97-164` | Main scripted config for strategy, windows, displacement limits, smoothing, thresholds, sub-pixel search, combined reference mode, local metric family, and HDR controls. |
| `RectificationResult` | `moment_images/im_process.py:166-183` | Stores final average/stack plus input views and stage-specific global/pixel data. |
| Input normalization and HDR branching | `moment_images/im_process.py:262-296` | Accepts `(N, N, H, W)` or `(E, N, N, H, W)`; HDR requires `hdr_enabled`. |
| Strategy dispatch | `moment_images/im_process.py:304-457` | Implements global, pixel, and combined branches in one scripted entry point. |
| Combined reference choices | `moment_images/im_process.py:408-441` | Uses global average, iterative subtractive-max reference, or center-view behavior before local refinement. |
| Workspace writer | `moment_images/im_process.py:1123-1172` | Saves `.npz` and sibling `.mat`; drops `None` values. |
| Interactive workspace fields | `moment_images/im_process.py:1845-1871` | Captures original/processed images, extracted views, global and pixel outputs, averages, reference index, view metadata, HDR flags, and source paths. |

## Rectification Strategy Internals

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Strategy module contract | `moment_images/rectification_strategy.py:2-9` | Expects view stacks and states that both global and pixel approaches align views to a reference and average results. |
| Supported local metric families | `moment_images/rectification_strategy.py:24-41` | `intensity`, `blurred_gradient_corr`, `blurred_laplacian_corr`, `blurred_composite_corr`, plus legacy aliases. |
| Metric-spec validation | `moment_images/rectification_strategy.py:96-210` | Validates alpha, family, and component weights; intensity requires `alpha=1.0`. |
| Reference selection | `moment_images/rectification_strategy.py:244-266` | Centralizes default center reference and validates custom reference index. |
| Pixelwise result fields | `moment_images/rectification_strategy.py:269-295` | Stores coordinates, scores, displacement maps, blended/component scores, view summaries, and metric-family metadata. |
| Global correlation | `moment_images/rectification_strategy.py:387-437` | Thresholds views, pads one view, computes 2D correlation, records peak offset. |
| Global warp and average | `moment_images/rectification_strategy.py:439-491` | Applies affine translations by `cv.warpAffine` and averages the stack. |
| Pixelwise search API | `moment_images/rectification_strategy.py:542-588` | Defines displacement search, smoothing, threshold, sub-pixel, reference, sigma-pyramid, and metric-family parameters. |
| Sigma-pyramid refinement | `moment_images/rectification_strategy.py:589-653` | Runs initial sigma, then repeatedly halves sigma and constrains refinement around previous displacements. |
| Pixel score construction | `moment_images/rectification_strategy.py:826-895` | Rolls shifted views, computes intensity product, optional gradient/laplacian products, Gaussian smoothing, normalization, and blending. |
| Argmax and displacement fields | `moment_images/rectification_strategy.py:896-933` | Selects best displacement per pixel, preserves zero-displacement behavior for no-signal pixels, optionally smooths displacements, and builds backward coordinates. |
| Sub-pixel downsampling | `moment_images/rectification_strategy.py:935-1007` | Resizes scores and displacements back to original resolution and rescales displacement units. |
| Pixelwise remap | `moment_images/rectification_strategy.py:1040-1100` | Validates maps and prepares backward remapping for each view. |

## Combined Reference Rebuild

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Purpose | `moment_images/iterative_subtractive_max_rebuild.py:1-8` | Builds a reference image from globally aligned views before pixelwise refinement. |
| Rebuild result fields | `moment_images/iterative_subtractive_max_rebuild.py:50-65` | Stores reference image, sparse rebuild, robust base, mean/std, feature/saliency maps, peaks, donor indices, and coverage map. |
| Main parameters | `moment_images/iterative_subtractive_max_rebuild.py:194-248` | Controls metric family, robust base, feature smoothing, saliency, peak selection, donor mode, patch taper, and background blend. |
| Saliency and peak selection | `moment_images/iterative_subtractive_max_rebuild.py:279-317` | Uses mean/std/robust base, feature map, consistency-normalized saliency, smoothing, and greedy NMS. |
| Patch reconstruction | `moment_images/iterative_subtractive_max_rebuild.py:319-394` | Selects donor patches, accumulates tapered weighted patches, blends sparse rebuild with robust base. |
| Feature map semantics | `moment_images/iterative_subtractive_max_rebuild.py:473-499` | Feature map blends normalized intensity, gradient magnitude, and Laplacian magnitude using the same alpha/component semantics. |

## Sweep Specification and Execution

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Sweep module purpose | `moment_images/parameter_sweep.py:1-7` | Drives `rectify_views_from_config` over configurable parameter grids and persists comparable outputs. |
| Dataset spec | `moment_images/parameter_sweep.py:188-232` | Supports saved views, source image, source image directory, view geometry, HDR settings, and `normalize_to_8bit`. |
| Search space fields | `moment_images/parameter_sweep.py:235-283` | Defines window sizes, displacements, sigmas, thresholds, sub-pixel factors, sigma pyramid, zero-fill roll, pad widths, and combined reference fields. |
| Stage spec | `moment_images/parameter_sweep.py:286-368` | Supports `two_stage` or `single_stage`, budget, stage-1 fraction, top-k, workers, and refinement mode. |
| Scoring spec | `moment_images/parameter_sweep.py:371-381` | Holds metric weights, runtime penalty, robustness penalty, missing-dataset penalty, metric scope, and optional profile. |
| Metric formulation spec | `moment_images/parameter_sweep.py:384-479` | Encodes local displacement-score family, alpha values, and component weights. |
| Experimental metric sweep spec | `moment_images/parameter_sweep.py:540-624` | Enables metric-family comparisons with `baseline_shortlist` or `independent_search`. |
| Top-level spec | `moment_images/parameter_sweep.py:627-831` | Combines datasets, search spaces, strategies, stages, scoring, metric experiments, reporting, output, and artifact flags. |
| Stage budgets | `moment_images/parameter_sweep.py:1767-1772` | Splits total budget into stage 1 and stage 2. |
| Stage-2 refinement | `moment_images/parameter_sweep.py:1719-1753` | Generates refined candidates around top stage-1 seeds by neighbor or auto-fine logic. |
| Per-run artifact save | `moment_images/parameter_sweep.py:1792-1868` | Writes preview PNG, rectified stack, workspace `.npz/.mat`, config JSON, and metric record JSON. |
| Run evaluation task | `moment_images/parameter_sweep.py:3416-3462` | Loads views, builds config, runs rectification, builds metric record, saves artifacts, returns run metadata. |
| Candidate ranking | `moment_images/parameter_sweep.py:4199-4336` | Normalizes metrics per dataset, applies weights/runtime penalty, aggregates by mean minus robustness penalty and missing-dataset penalty. |
| Metric experiment variants | `moment_images/parameter_sweep.py:4448-4575` | Expands local metric formulations and independent metric-search candidates. |
| Main sweep flow | `moment_images/parameter_sweep.py:5661-6104` | Prepares datasets, initializes run state/generation, runs stage 1, optional stage 2, optional metric phase, writes manifest, snapshots products, persists run state. |
| Example spec | `moment_images/sweep_experiment_spec_example.json:1-150` | Concrete schema example for strategies, datasets, search spaces, stages, scoring, metric experiments, reporting, and artifact flags. |

## Metrics and Ranking Inputs

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Base image metrics | `moment_images/sweep_analysis.py:76-93` | Computes average intensity, maximum intensity, total variation, squared gradient, Laplacian variance, and Haar level-2 HV energy. |
| Displacement field metrics | `moment_images/sweep_analysis.py:106-123` | Computes mean/std/p95/max displacement magnitude and outlier rate. |
| Inter-view consistency | `moment_images/sweep_analysis.py:126-133` | Computes mean/p95/max per-pixel standard deviation over rectified views. |
| Displacement score diagnostics | `moment_images/sweep_analysis.py:136-165` | Records local metric family, alpha, component weights, blended stats, component stats, and per-view summaries. |
| Metric record payload | `moment_images/sweep_analysis.py:168-197` | Combines config, metric formulation, global-only metrics, final metrics, displacement metrics, consistency metrics, and diagnostics. |
| LoG guide channel | `moment_images/metric_profiles.py:140-144` | Builds absolute Laplacian-of-Gaussian style guide image from normalized average image. |
| Focus/sparsity helpers | `moment_images/metric_profiles.py:158-268` | Implements Tamura coefficient, normalized DCT entropy, Bayes DCT entropy, Gini, Hoyer, and Vollath F4. |
| Extended metrics | `moment_images/metric_profiles.py:271-297` | Computes old metrics plus average-image and guide-channel focus/sparsity metrics. |
| Metric registry | `moment_images/metric_profiles.py:300-370` | Registers saved metrics, old raw-average metrics, new average/guide metrics, and Tamura metrics. |
| Metric explorer guide | `moment_images/SWEEP_METRIC_EXPLORER_GUIDE.md:84-129` | Documents `avg_image`, `guide_log`, old metrics, new metrics, and direct-image vs guide-map comparisons. |

## Outputs and Persistence

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Sweep output layout | `moment_images/PARAMETER_SWEEP_GUIDE.md:202-219` | Lists stage summaries, leaderboards, summaries, run state, manifest, run folders, generation products, and per-run artifacts. |
| Resume/extend/dry run | `moment_images/PARAMETER_SWEEP_GUIDE.md:159-199` | Documents durable `run_state.json`, compatible resume/extend/merge/relocate behavior, and generation dry-run output. |
| Run manifest | `moment_images/parameter_sweep.py:6044-6072` | Writes `experiment_manifest.json` with generation, strategies, baseline displacement mode, metric experiments, datasets, stages, scoring, reporting, and products path. |
| Run state persistence | `moment_images/parameter_sweep.py:6102-6104` | Snapshots generation products and persists `run_state.json`. |

## Validation and External-Camera Evaluation

| Topic | Source anchor | Implementation detail |
| --- | --- | --- |
| Validation options | `moment_images/validate_rectification.py:58-83` | Stores mode, auto-align flag, alignment model, normalization percentiles, and template score threshold. |
| Alignment result fields | `moment_images/validate_rectification.py:110-129` | Stores aligned image, status, scores, warp matrices, ROIs, point-pair metadata, residual ECC, and valid mask. |
| Validation image result fields | `moment_images/validate_rectification.py:153-173` | Stores processed image, options, alignment, scale/intensity/crop/rotation/flip, and point alignment state. |
| Point-guided alignment | `moment_images/validate_rectification.py:774-832` | Estimates point-based similarity transform, optionally composes residual ECC, and saves final warp/diagnostics. |
| Auto-align branching | `moment_images/validate_rectification.py:835-914` | Uses point alignment when points exist, otherwise disabled alignment or translation ECC depending on options. |
| Validation workspace data | `moment_images/validate_rectification.py:2622-2687` | Saves rectified image, processed validation/ThorCam images, options, scale/intensity/crop/geometry/alignment metadata, and final warp matrices. |
| Trio benchmark config | `moment_images/trio_benchmark.py:40-114` | Defines validation score names, registration profiles, defaults, and benchmark configuration fields. |
| Trio run flow | `moment_images/trio_benchmark.py:2429-2707` | Loads references and sweep candidates, chooses/uses registration, computes metrics, ranks candidates, writes CSV/JSON/HTML and diagnostic figures. |
| Validation metric core | `moment_images/trio_benchmark.py:2259-2333` | Computes signal, structure, bead, and sharpness terms; falls back to signal/structure when bead evidence is weak. |
| Trio oracle import fields | `moment_images/trio_oracle_metrics.py:18-31` | Names primary trio cache/profile/score fields, including `validation_hybrid_thorcam_fov_v1`. |
| Trio numeric diagnostics | `moment_images/trio_oracle_metrics.py:113-158` | Lists imported numeric metrics and registration diagnostics exposed to explorer tooling. |

## Current-Checkout Negative Findings

The observed file inventory did not include separate modules named
`precision_rectification.py` or `bead_prior_reconstruction.py`. Do not describe
those as part of this checkout's implemented pipeline unless you intentionally
switch to a branch or later commit that contains them.

