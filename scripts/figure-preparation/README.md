# Trio comparison figure pipeline

This MATLAB pipeline prepares candidate figures comparing a ThorCam capture
with the intermediate global-stage average and final rectified image from one
global-then-local reconstruction run. Source artifacts may call the latter
`local_average`. The labels rendered by replay are "After global alignment"
and "After local refinement (final)". The pipeline does not rerun the upstream
FLFM reconstruction algorithm.

## Prepare a new scene interactively

Give the external data root to `setup_trio_figure`. The setup flow discovers
likely main, ThorCam, validation, workspace, and run-manifest inputs; asks for
a selection only when a role is missing or ambiguous; then saves a recipe only
after camera preparation, registration, crop, intensity, and zoom ROI review
are complete.

```powershell
matlab -batch "addpath('scripts/figure-preparation'); setup_trio_figure('C:\path\to\date-folder', 'SceneId', 'beads_2um_dense4_eyedrop_4kus', 'FigureId', 'my_trio_figure');"
```

The optional point-pair calibration step estimates a camera downsampling
factor from two or more selected feature pairs. If a camera scale is already
known, keep the reviewed factor instead.

## Replay a saved scene without dialogs

Each figure bundle contains `trio-recipe.json`. Replay consumes it and the
external data root, writes into a staging directory, and publishes the nine
PNGs, recipe, generated layout, and manifest only after all checks succeed.

```powershell
matlab -batch "addpath('scripts/figure-preparation'); result=replay_trio_figure('candidate-outputs/figures-source/eyedrop_3_6/trio-recipe.json', 'C:\path\to\date-folder'); disp(result.publishedManifestPath);"
```

Use `'Publish', false` to retain the staging directory for inspection. The
dense4 recipe additionally requires a pixel-exact match to its existing
candidate images before publishing.

## Bundle contents and figure wrapper

A published bundle contains three full panels, two aligned crops from each
panel, `trio-recipe.json`, `replay-manifest.json`, and `trio-layout.tex`.
The manifest records input, recipe, and pipeline hashes; registration and
crop; intensity and ROI settings; software environment; and output hashes.

Create or maintain the caption in a figure wrapper outside the bundle. The
wrapper imports `trio-comparison-template` and then the generated layout:

```tex
\input{trio-comparison-template}
...
\begin{figure}
  \centering
  \input{my_trio_figure/trio-layout}
  \caption{Author-maintained caption.}
\end{figure}
```

Candidate assets remain provisional until their scientific evidence and
caption claims have been qualified.

## Dense4 provenance

`eyedrop-2026-06-03-dense4/source-snapshots/` holds the four original external
scripts byte-for-byte. `run_figure_replay` remains as a compatibility wrapper
for that one scene; new figures must use the shared entry points above.

## Tests

```powershell
matlab -batch "addpath('scripts/figure-preparation'); results=runtests('scripts/figure-preparation/tests/test_trio_figure_pipeline.m'); assert(all([results.Passed]));"
```
