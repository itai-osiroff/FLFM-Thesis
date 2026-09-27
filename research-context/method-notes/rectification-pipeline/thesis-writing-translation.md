# Thesis Writing Translation Notes

> **Status:** reference
>
> **Reviewed:** 2026-09-24

Observed source checkout: `C:\Users\admin2\Documents\git_clones\algo`

Observed branch/commit: `main`, `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`

Observation date: 2026-07-16

**Thesis-use boundary (2026-09-27):** Write about one two-stage method: global
alignment followed by local pixelwise refinement. The global-stage average
is an intermediate image; the average after local refinement is the final
rectified image, including where an artifact calls it `local_average`. The
software can expose other modes, but they are not separate thesis methods.

## Good Thesis Terminology

Use these terms consistently:

- `Elemental view` or `sub-view`: one `(H, W)` image in the `(N, N, H, W)` view
  grid.
- `View grid`: the square array of elemental views.
- `Reference view`: the view or image to which local/global matching is
  anchored. By default this is the grid center, but combined mode can use the
  global average or a rebuilt external reference for pixelwise refinement.
- `Global rectification`: translation-only alignment of each elemental view.
- `Pixelwise refinement`: dense local displacement search followed by backward
  remapping.
- `Two-stage rectification` (`combined` in software): global alignment followed
  by pixelwise refinement; the stages are explained separately for clarity.
- `Global-stage average`: intermediate mean of globally aligned views in the
  same two-stage run.
- `Final rectified image`: mean after local refinement; saved as
  `local_average` in some artifacts.
- `Local displacement score`: the in-loop score used to pick a displacement per
  pixel.
- `Post-run metric`: a metric computed after a candidate output exists, used for
  ranking or analysis.
- `Validation oracle`: downstream external-camera comparison used to evaluate
  completed candidates, not information used by the ordinary blind rectifier.

## Thesis-Ready Claims

These are safe claims for the observed checkout:

- The implemented pipeline represents a light-field acquisition as a square grid
  of elemental views and aligns those views into a shared reference frame before
  averaging them.
- The global stage estimates one translation per view using correlation and
  applies affine translation warps.
- The pixelwise stage estimates dense per-view displacement fields by searching a
  bounded local displacement grid and selecting the best per-pixel score.
- The thesis's two-stage run uses global alignment as an initialization for
  local refinement.
- Local displacement scoring can use raw intensity alone, or blend intensity with
  blurred gradient/Laplacian correlation-like components.
- The final image from the core rectifier is an average of warped elemental
  views.
- Parameter sweeps can vary settings, local score families, and ranking metrics
  for the two-stage thesis path. The software's strategy inventory is a
  historical implementation fact, not a thesis-method comparison.
- External validation against Validation Camera and ThorCam images is supported
  by downstream tools that preserve row identity, registration diagnostics, and
  validation scores.

## Claims That Need Careful Wording

Avoid saying the current implementation "optimizes a guide map" as a blanket
statement. The code has guide-channel metrics and optional gradient/Laplacian
local scoring, but the default rectifier is still primarily an intensity
warp-and-average pipeline.

Avoid saying the global model corrects affine or rotational distortion. The
current global rectifier is translation-only. Rotation, scale, and similarity
registration appear in validation/trio evaluation tooling, not the core global
rectifier.

Avoid saying validation images train or tune the ordinary sweep unless you are
discussing a validation-guided workflow explicitly. In the normal workflow,
trio validation ranks completed candidates after the fact.

Avoid saying the pixel score is true normalized cross-correlation. The code
comments explicitly describe the local score families as blurred
correlation-like metrics rather than true local NCC/ZNCC.

Avoid describing a precision stage or bead-prior residual reconstruction as part
of this observed checkout. Those files were not present in the current file
inventory.

## Suggested Methods Paragraph

The following paragraph is intentionally concise and can be adapted into the
methods chapter:

> The rectification software first represents each FLFM acquisition as a square
> grid of elemental view images. A translation-only global alignment stage can
> estimate one displacement per view by correlation with a reference view and
> warp the elemental views into a common frame. A second, local stage can refine
> this alignment by evaluating a bounded grid of candidate displacements at each
> pixel and selecting the displacement with the highest Gaussian-smoothed local
> similarity score. The local score can be based on intensity alone or on a
> blend of intensity with gradient and Laplacian-derived components. In the
> two-stage path used in this thesis, global alignment initializes the
> local search, after which all elemental views are backward-remapped and
> averaged to form the rectified image.

## Suggested Sweep Paragraph

> Candidate rectification settings were evaluated using a specification-driven
> parameter sweep. Each candidate configuration was applied to one or more view
> grids, and the resulting average image, rectified view stack, workspace arrays,
> configuration, and metric record were saved as durable run artifacts. Candidates
> were ranked by normalized image-quality metrics, optionally aggregated across
> datasets with penalties for variability, runtime, or missing results. Additional
> metric-phase sweeps can compare alternative local displacement-score families,
> including gradient and Laplacian-assisted formulations.

## Suggested Validation Paragraph

> External-camera validation was handled as a downstream evaluation step. A
> validation workspace records the preprocessing and registration of Validation
> Camera and ThorCam images against a rectified LF output, including geometry,
> intensity, scale, point-pair, and warp metadata. A headless trio benchmark then
> compares completed LF sweep candidates with the validation reference and a
> ThorCam baseline. Its primary score combines signal similarity, structural
> similarity, bead correspondence, and local sharpness when sufficient bead
> evidence exists, while retaining registration diagnostics and rankability
> flags for later inspection.

## Figure Ideas

- Pipeline block diagram: source image or saved views -> view extraction ->
  global alignment -> optional reference rebuild -> pixelwise local refinement
  -> averaged rectified output.
- Algorithm/detail diagram: for one elemental view, show displacement grid search
  at a pixel, score map, selected displacement, backward remap.
- Sweep lifecycle diagram: spec -> candidates -> stage 1 -> ranking -> stage 2
  -> artifacts -> metric explorer/reporting.
- Validation diagram: sweep candidates -> validation/ThorCam registration ->
  hybrid validation score -> oracle ranking.

## Useful Distinctions for the Thesis

Core algorithm versus experiment harness:

- Core algorithm: `RectificationRunConfig`, `rectify_views_from_config`,
  `GlobalTranslationRectificationStrategy`, `PixelwisePatchRectificationStrategy`.
- Experiment harness: `parameter_sweep.py`, scoring profiles, metric explorer,
  run-state persistence, report generation.

In-loop metric versus output metric:

- In-loop metric chooses displacement fields.
- Output metric ranks completed average images or validation-aligned candidates.

Blind rectification versus validation-guided comparison:

- Blind rectification sees only the LF view grid.
- Validation-guided comparison uses external-camera images after candidate
  outputs already exist.

Current implementation versus research direction:

- Current implementation: translation global alignment, dense pixelwise local
  remap, optional combined reference rebuild, sweep-based evaluation.
- Research direction: stronger guide-map-centered objectives, stricter
  confidence gating, richer validation metrics, and potentially more expressive
  transformation models.
