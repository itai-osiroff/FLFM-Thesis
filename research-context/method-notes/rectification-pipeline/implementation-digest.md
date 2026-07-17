# Current Rectification Pipeline Implementation Digest

Observed source checkout: `C:\Users\admin2\Documents\git_clones\algo`

Observed branch/commit: `main`, `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`

Observation date: 2026-07-16

## Executive Summary

The current implementation is a view-grid rectification system for light-field
captures. It accepts either a precomputed view grid shaped `(N, N, H, W)`, or an
HDR exposure stack shaped `(E, N, N, H, W)`. The core output is an aligned stack
of rectified views and their average image. The implementation supports three
rectification strategies:

- `global`: one translation per view, estimated by image correlation, then
  affine translation and averaging.
- `pixel`: a dense per-pixel displacement field per view, estimated by local
  displacement search, then `cv.remap` and averaging.
- `combined`: global translation first, followed by pixelwise refinement on the
  globally rectified stack.

The main scripted entry point is `rectify_views_from_config(views, config)`.
Interactive use goes through `python -m moment_images.im_process`, while large
method comparisons go through `python -m moment_images.parameter_sweep --spec ...`.

## Runtime Data Model

The central configuration object is `RectificationRunConfig`. Its most important
fields are:

- `strategy`: `global`, `pixel`, or `combined`.
- `similarity_window_size` and `refinement_window_size`: local patch window size
  for pixel or combined refinement.
- `correlation_pad_width`: padding used for global correlation.
- `max_displacement`: local pixel search radius.
- `gauss_sigma` / `gauss_size`: smoothing used while scoring local displacement
  candidates.
- `disp_gauss_sigma` / `disp_gauss_size`: optional smoothing of selected
  displacement fields.
- `global_threshold` and `pixel_threshold`: relative intensity thresholds.
- `pixel_sigma_pyramid`: whether to run a coarse-to-finer sigma refinement path.
- `sub_pix_factor`: image upscaling factor used for sub-pixel displacement
  search.
- `zero_fill_roll`: whether shifted candidate views are zero-filled rather than
  circularly wrapped.
- `combined_reference_mode`: `global_average`, `center_view`, or
  `iterative_subtractive_max_rebuild`.
- `displacement_metric_family`, `displacement_alpha`, and
  `displacement_component_weights`: local scoring family and blend controls.
- HDR controls: `hdr_enabled`, `hdr_exposure_times`, and `normalize_to_8bit`.

The main result object is `RectificationResult`. It stores the final average
image and rectified stack, plus stage-specific data such as global similarity,
global rectified views, global average image, and pixel similarity outputs.

## Core Codepath

The scripted pipeline first normalizes the input view array and chooses the
center view as the default reference. It then dispatches by strategy:

```text
view grid -> resolve center reference -> strategy branch

global:
  cross-correlate views against reference -> translate each view -> average

pixel:
  local displacement search against reference -> backward remap each view -> average

combined:
  global translate -> choose pixel reference -> local displacement search
  -> backward remap globally aligned views -> average
```

When HDR input is provided, the implementation estimates alignment from the
first exposure view grid, applies the same alignment to each exposure, and then
assembles HDR output from the rectified exposure stack.

## Global Rectification

The global strategy estimates a `(dy, dx)` offset for view pairs. It optionally
thresholds each view by a fraction of that view's maximum intensity, pads one
view, computes 2D correlation, and records the correlation peak as the shift.

The similarity matrix has shape `(N, N, N, N, 2)`. During rectification, each
non-reference view is warped by an affine translation matrix:

```text
[[1, 0, dx],
 [0, 1, dy]]
```

The final global output is the mean over the translated view stack.

Thesis wording: this is a translation-only global initializer. It does not model
rotation, scale, affine shear, or nonrigid deformation.

## Pixelwise Rectification

The pixelwise strategy estimates a dense displacement field for every view. For
each candidate displacement `(s_y, s_x)`, it shifts the moving view, multiplies
it with the reference representation, smooths the product by a Gaussian, and
selects the best displacement per pixel.

The implementation supports these local score families:

- `intensity`: intensity product score. This is the default.
- `blurred_gradient_corr`: intensity blended with a blurred gradient-product
  score.
- `blurred_laplacian_corr`: intensity blended with a blurred Laplacian-product
  score.
- `blurred_composite_corr`: intensity blended with weighted gradient and
  Laplacian components.

The `alpha` parameter is the intensity weight. For non-intensity families, the
effective score is:

```text
alpha * intensity + (1 - alpha) * auxiliary
```

For the composite family, `component_weights` distribute the non-intensity part
between `gradient` and `laplacian`.

Important implementation caveat: the pixelwise code describes these as blurred
correlation-like metrics, not true local NCC/ZNCC normalization.

After the best displacement is selected, the code builds backward-remap
coordinates:

```text
map_y = base_y - disps_y
map_x = base_x - disps_x
```

Then it uses `cv.remap` to sample each view into the reference coordinate frame.
The final image is again a simple mean over the rectified stack.

## Sigma Pyramid

When `pixel_sigma_pyramid=True`, pixelwise search starts with a broader Gaussian
score smoothing scale, then halves the sigma repeatedly. Each refinement pass is
constrained to remain within two pixels of the previous displacement field. This
is a local refinement mechanism around a coarse displacement estimate; it is not
a multiresolution image pyramid over downsampled images.

## Combined Rectification

Combined mode is the most thesis-relevant current path. It first applies global
translation rectification, then computes a pixelwise refinement on the globally
rectified views. The pixelwise reference may be:

- the global average image,
- the center view, or
- an external reference generated by `iterative_subtractive_max_rebuild`.

The final product is still the pixelwise-remapped view stack and its average.
The global average is a matching target or intermediate diagnostic, not the final
image when the pixel stage is active.

## Iterative Subtractive-Max Reference Rebuild

`iterative_subtractive_max_rebuild.py` is an optional combined-mode reference
builder. It operates after global alignment and before pixelwise refinement. Its
purpose is to build a more informative external reference image for local
matching.

The rebuild works roughly as follows:

1. Flatten the globally rectified view grid to a `(V, H, W)` stack.
2. Compute the mean image, standard deviation image, and a robust base image
   using either median or trimmed mean.
3. Build a normalized feature map from intensity, gradient magnitude, Laplacian
   magnitude, or a configured blend of these components.
4. Convert the feature map into a saliency map by dividing by normalized
   cross-view standard deviation, then optionally smoothing.
5. Select salient peaks by greedy non-maximum suppression.
6. For each selected peak, paste a tapered donor patch into a sparse rebuild.
   The donor can come from the robust base or the best-scoring view.
7. Blend the sparse rebuild with the robust base image to produce the external
   reference.

This is not a learning stage and not a final reconstruction stage. It is a
reference-construction helper for the downstream pixelwise matcher.

## Parameter Sweep Layer

`parameter_sweep.py` automates the rectifier over datasets and candidate
parameter grids. A sweep spec includes datasets, strategy search spaces, stage
configuration, scoring configuration, optional metric experiments, reporting
controls, and output settings.

Candidate search has two main modes:

- `single_stage`: evaluate one candidate set.
- `two_stage`: evaluate a coarse stage, rank candidates, then generate refined
  stage-2 candidates around the top stage-1 configurations.

The stage-2 refinement method defaults to `auto_fine`, which inserts local
midpoint/bounded candidates around top seeds. The older `neighbor` method uses
neighboring values from the configured search grid.

Each successful run writes:

- `avg_rectified.png`
- `rectified_views.npy`
- `workspace.npz`
- `workspace.mat`
- `config.json`
- `metric_record.json`
- optional figure folders

The sweep root writes stage summaries, leaderboards, `best_configs.json`,
`summary.json`, optional analysis artifacts, `run_state.json`,
`experiment_manifest.json`, and generation-scoped products.

## Scoring and Metrics

There are two different scoring concepts that should not be conflated:

1. In-loop displacement scoring: used inside pixelwise rectification to choose a
   local displacement. This is controlled by `displacement_metric_family`,
   `displacement_alpha`, and optional component weights.
2. Post-run sweep ranking: used after a rectified output exists. This is based
   on image metrics from the final average image or guide-derived channels.

The sweep metrics include the older image statistics:

- `average_intensity`
- `maximum_intensity`
- `total_variation`
- `sum_squared_gradient`
- `laplacian_variance`
- `dwt_level2_hv_energy`

The shared metric profile layer also computes newer focus and sparsity metrics
on both normalized average images and an absolute LoG-style guide channel:

- `ndct_shannon_avg`, `ndct_shannon_guide`
- `ndct_bayes_avg`, `ndct_bayes_guide`
- `gini_avg`, `gini_guide`
- `hoyer_avg`, `hoyer_guide`
- `vollath_f4_avg`, `vollath_f4_guide`
- `tamura_gradient_avg`, `tamura_guide`

Sweep ranking normalizes each metric per dataset, forms a weighted score,
optionally subtracts a normalized runtime penalty, then aggregates across
datasets by:

```text
robust_score = mean_dataset_score
               - robustness_lambda * std_dataset_score
               - missing_dataset_penalty * missing_dataset_count
```

This makes sweep rankings relative to the candidate set and dataset set in a
given experiment.

## Experimental Metric Sweeps

`experimental_metric_sweep` evaluates alternative local displacement-score
families. It has two candidate-source modes:

- `baseline_shortlist`: take top baseline candidates, strip metric axes, and
  rerun them under requested metric formulations.
- `independent_search`: run a separate candidate search per metric formulation
  and alpha lane. This costs more but lets each local scoring family prefer
  different rectification parameters.

This is the code path to use when comparing whether gradient/Laplacian-assisted
local matching changes the best rectification settings.

## Validation and Oracle Evaluation

`validate_rectification.py` is an interactive validation workspace tool. It
loads a rectified output, a Validation Camera image, and a ThorCam image. For
each external image it can apply geometry edits, intensity windowing, scaling,
optional crop, point-based similarity alignment, and optional residual ECC.

It can save `validation_workspace.npz`, which includes processed validation and
ThorCam images, alignment options, crop/intensity/scale metadata, point pairs,
final warp matrices, output shapes, and alignment status fields.

`trio_benchmark.py` is the headless evaluator that ranks completed sweep
candidates against validation/ThorCam references. It is downstream of the sweep,
not part of the blind rectification algorithm. It can use:

- `bead_geometric_v2` registration, the default;
- `bead_similarity_v1`;
- `centered_ecc_legacy`;
- `manual_similarity_v1`; or
- `validate_workspace_transform_v1`, which reuses saved validation-workspace
  transforms.

The primary current oracle score is `validation_hybrid_thorcam_fov_v1`. It
combines signal similarity, structure similarity, bead-center agreement, and
local sharpness when enough bead evidence exists; otherwise it falls back to a
signal/structure blend and emits low-confidence warnings.

## Current Limitations and Thesis Caveats

- The default final reconstruction is still warp-and-average over rectified
  views. It is not a learned reconstruction, deconvolution, or fusion model.
- The global model is translation-only.
- Pixelwise local scoring is correlation-like and Gaussian-smoothed; the code
  explicitly does not implement true local NCC/ZNCC.
- Guide-map metrics are available for ranking and exploration, but the core
  rectifier does not yet fully implement a guide-map-centered optimization loop.
- External-camera validation is downstream evaluation/oracle tooling. It should
  not be described as information used by the blind rectification optimizer
  unless a specific validation-guided workflow is being discussed.
- The implementation is experiment-oriented. `parameter_sweep.py` contains
  resume, merge, dry-run, and report-generation machinery because the project is
  actively comparing method families, not just running one fixed production
  pipeline.
- This checkout does not contain separate `precision_rectification.py` or
  `bead_prior_reconstruction.py` modules. Those should not be described as part
  of the current implementation unless another branch or later commit is being
  used.

## Suggested Thesis-Level Method Description

One compact description:

> The implemented rectification pipeline represents each FLFM acquisition as a
> square grid of elemental view images. It supports a translation-only global
> alignment stage, a dense local refinement stage based on per-pixel displacement
> search, and a combined mode that uses the global result as initialization for
> local correction. Candidate local displacements are selected by Gaussian-smoothed
> similarity scores over a bounded displacement window, optionally blending raw
> intensity with gradient or Laplacian-based components. The aligned elemental
> views are resampled into a common reference coordinate system and averaged to
> produce the rectified image. Parameter sweeps evaluate many configurations and
> rank outputs using image-quality, focus, sparsity, and optional external-camera
> validation metrics.

