# Trio comparison figure pipeline

Use this MATLAB pipeline to turn **existing reconstruction results and camera
captures** into three comparison columns: ThorCam, the intermediate average
after global alignment, and the final rectified image after local refinement.
The reconstruction images must come from the same global-then-local run.
Saved names such as `local_average` refer to that run's final image.

The pipeline prepares, registers, crops, and renders images. It does not run
the upstream FLFM reconstruction, acquire data, write captions, or qualify a
candidate as scientific evidence.

## Contents

- [Choose an entry point](#choose-an-entry-point)
- [Before you start](#before-you-start)
- [Prepare your data](#prepare-your-data)
- [Recover setup without an experiment manifest](#recover-setup-without-an-experiment-manifest)
- [Create your first figure](#create-your-first-figure)
- [Replay and inspect a saved figure](#replay-and-inspect-a-saved-figure)
- [Understand the outputs](#understand-the-outputs)
- [Use the bundle in LaTeX](#use-the-bundle-in-latex)
- [Customize a figure](#customize-a-figure)
- [Troubleshooting](#troubleshooting)
- [Verification and dense4 provenance](#verification-and-dense4-provenance)

## Choose an entry point

| Your task | Entry point | What it does |
| --- | --- | --- |
| Prepare a new scene and choose display settings | `setup_trio_figure(dataRoot, ...)` | Opens resumable review dialogs; checkpoints choices and generates a version after final review. |
| Regenerate or inspect a saved figure | `replay_trio_figure(recipePath, dataRoot, ...)` | Runs without dialogs, using the recipe and external source data. |
| Use an older command for the June 3 dense4 scene | `run_figure_replay(dataRoot, ...)` | Compatibility wrapper using a fixed dense4 recipe. Use the shared entry points for new figures. |

`+triofig/` is the supporting MATLAB package, not a series of scripts to run.
Add its **parent directory** to the MATLAB path. Its recipe helpers are useful
for [customization](#customize-a-figure).

The four scripts in
[`eyedrop-2026-06-03-dense4/source-snapshots/`](eyedrop-2026-06-03-dense4/source-snapshots/)
are preserved historical sources, not reusable entry points.

## Before you start

You need:

- MATLAB and **Image Processing Toolbox** for image preparation, registration,
  and ROI tools. The environment inspected for this guide is **R2025b**; a
  minimum supported release has not been established.
- **Statistics and Machine Learning Toolbox** for optional point-pair
  calibration (`pdist`). Replay and setup using reviewed scale factors do not
  call that calibration function.
- Interactive graphics for setup: dialogs, figures, mouse selections, and
  sliders. Use the MATLAB Command Window for your first setup. Replay can run
  with `matlab -batch`.
- A JVM-enabled MATLAB session: path handling, hashes, and staging names use
  Java. Do not launch these entry points with `-nojvm`.
- Read access to the external inputs and write access to the output directory.

In the **MATLAB Command Window**, replace the repository path:

```matlab
repoRoot = 'C:\path\to\FLFM-Thesis';  % EDIT: your repository checkout
cd(repoRoot);
addpath(fullfile(repoRoot, 'scripts', 'figure-preparation'));

which setup_trio_figure
which replay_trio_figure
ver
assert(usejava('jvm'), 'This pipeline requires the MATLAB JVM.');
```

`which` should print paths in this checkout; `ver` lists installed toolboxes.
Run `addpath` again in a new session unless you have configured the path
yourself. Subsequent examples assume this setup. Relative MATLAB paths are
resolved from the current folder; `fullfile(repoRoot, ...)` avoids ambiguity.

## Prepare your data

### What must already exist

Finish reconstruction and save a MATLAB workspace for the chosen scene/run
first. The upstream workspace export can produce a `workspace.mat` companion
to `workspace.npz`; confirm the MAT file exists and contains the required
variables. These scripts do not load `.npz`, convert it to `.mat`, or recover
reconstruction arrays from display PNGs.

Choose an external **data root** containing the camera captures and workspace,
and the original experiment manifest when available, separate from this
repository and from the output bundle. An illustrative layout is:

```text
C:\data\my-acquisition\                 <-- dataRoot
├── main\
│   └── my_scene_4kus.tiff
├── thorcam\
│   └── my_scene_11ms.tif
├── validation\
│   └── my_scene_6kus.tiff
└── algo_run\
    └── selected_run\
        ├── experiment_manifest.json
        └── runs\stage1\selected_candidate\my_scene_4kus\
            └── workspace.mat
```

These names are examples, not supplied files. Nested run directories are
supported. Setup can select another layout, but all selected files must remain
**inside `dataRoot`**. Recipes store paths relative to that root; moving the
whole tree preserves those paths.

| Required input | Purpose and expectations |
| --- | --- |
| Main FLFM capture | Original scene image. Checked for readability and hashed for provenance; its pixels do not render the three panels. |
| ThorCam capture | Camera image for the left column, registration, and zooms. |
| Validation capture | Additional camera image for registration and common-field crop selection. Required despite not being exported as a column or zoom. |
| `workspace.mat` | Reconstruction arrays/configuration from the selected run; required variables are listed below. |
| `experiment_manifest.json` (when available) | Run identity. Must have `generation_id`; its text must mention the exact scene ID. Replay checks the generation against the recipe. If unavailable, use the recovery workflow below. |

For normal use, provide readable, single-plane grayscale camera images and
finite numeric 2D reconstruction arrays. Global and final arrays should have
the same shape and represent the same scene/grid. The implementation assumes
these properties; preflight does not exhaustively validate shapes or values.
Camera dimensions/sampling may differ, but their corresponding scene content
must allow registration and cropping.

### Inspect the workspace and manifest

In the shared-workspace mode the workspace must contain:

| Variable | Meaning |
| --- | --- |
| `average_rectified_global_image` | Intermediate global-stage average; registration reference and center panel. |
| `average_rectified_image` | Final average after local refinement; right panel. |
| `config_json` | Saved reconstruction configuration. Required by the default input contract, although rendering does not parse its contents. |

In separate-workspace mode, the global workspace supplies
`average_rectified_global_image` and the local workspace supplies
`average_rectified_image`; each also supplies `config_json` for run recovery.

Replace the paths and scene ID in this preflight example:

```matlab
dataRoot = 'C:\data\my-acquisition';  % EDIT: external data root
workspacePath = fullfile(dataRoot, ...
    'algo_run', 'selected_run', 'runs', 'stage1', ...
    'selected_candidate', 'my_scene_4kus', 'workspace.mat');
manifestPath = fullfile(dataRoot, ...
    'algo_run', 'selected_run', 'experiment_manifest.json');

whos('-file', workspacePath)
workspace = load(workspacePath, 'average_rectified_global_image', ...
    'average_rectified_image', 'config_json');
assert(ismatrix(workspace.average_rectified_global_image));
assert(isequal(size(workspace.average_rectified_global_image), ...
    size(workspace.average_rectified_image)));
if isfile(manifestPath)
    runManifest = jsondecode(fileread(manifestPath));
    disp(runManifest.generation_id);
    assert(contains(fileread(manifestPath), 'my_scene_4kus'));
end
```

A matching manifest generation does not prove that arbitrarily selected files
belong to that run. Review camera/workspace provenance together. If the original
manifest is lost, explicitly record its absence using recovery; supply only
details supported by the remaining records or your stated recollection.

### Scene ID versus figure ID

- **Scene ID** identifies input data and must appear in the original manifest text when used,
  for example `my_scene_4kus`.
- **Figure ID** names the candidate bundle, for example `my_trio_figure`.
  Use a simple directory name with letters, digits, and underscores.

Setup searches `main/`, `thorcam/`, and `validation/` recursively for `.tif`,
`.tiff`, `.png`, `.jpg`, and `.jpeg` images, and `algo_run/` for `workspace.mat`
and `experiment_manifest.json`. Discovery removes the last underscore-separated
part of the scene ID before matching paths, to accommodate different exposure
suffixes; an ID without underscores is used as-is. For manifests, it falls back
to all manifests under `algo_run/` if no stem matches. For camera images and
workspaces, one candidate is selected automatically; several open a selection
list; none open a file picker. Manifest selection always offers recovery if
none of the discovered files belongs to the selected run.

## Recover setup without an experiment manifest

Run the normal `setup_trio_figure(dataRoot, ...)` command. After selecting the
three camera captures and `workspace.mat`, choose **Recover run info** in the
manifest dialog. If several manifests are listed, select **No matching
manifest: recover run info**. If the file exists elsewhere beneath `dataRoot`,
use **Browse** instead when no manifest was discovered.

Setup calls [`recover_trio_run_info.m`](recover_trio_run_info.m). The helper
checks the required workspace variables, inspects `config_json` for explicit
`generation_id`, `stage1_run_id`, or `run_id` fields, and presents the following
fields for review. It does not reconstruct algorithm arrays or run a sweep.

| Field | What to enter |
| --- | --- |
| Generation ID | The recorded ID, or blank/`unknown` if it cannot be established. |
| Evidence for generation ID | A specific file, log entry, notebook page, or a clearly stated recollection. |
| Candidate/run ID | The selected candidate ID (stored as `stageId`), or blank/`unknown`. |
| Evidence for candidate/run ID | The source of that ID; path suggestions require your review. |
| Available run directory | An existing directory relative to `dataRoot` containing the preserved run. |
| Evidence for run directory | How you identified the preserved run location. |
| Recovery note | Missing records, uncertainty, or other relevant limitations. |

For a workspace at `algo_run/selected/runs/stage1/candidate7/scene/workspace.mat`,
the helper suggests `candidate7` and `algo_run/selected`. A path containing
`generations/<id>/` can also suggest a generation ID. These are directory-based
suggestions that you must review; an acquisition date or scene filename is not
used to manufacture a generation ID. Usual workspaces may contain no IDs in
`config_json`, so `unknown` is a valid outcome. If you edit a suggested ID,
update its evidence field too. If the source is left unchanged after an ID edit,
the helper records `User supplied; evidence unknown`; blank evidence remains
explicitly `unknown`.

Review that the global-stage and final arrays are successive outputs of the
same global-then-local run and that the captures correspond to that scene.
Accept the metadata dialog to continue with the ordinary camera, registration,
crop, intensity, and zoom steps. Cancelling returns `cancelled=true` and writes
no recovery file or bundle.

New setup recipes use **schema version 5**. They select one workspace for both
averages by default. **Separate workspaces** is an explicit setup option; it
selects and records each average's workspace path and SHA-256, run manifest or
recovery record, and generation identity independently. Replay checks those
hashes against the selected files. The two arrays must still
match in scene and image grid. Recovery saves an empty
`input.runManifestRelativePath`, `reconstruction.manifestStatus="absent"`, and
a `reconstruction.recovery` record containing the reviewed values, evidence
sources, notes, workspace path, and workspace SHA-256. The generation ID is
also retained in `input.expectedGenerationId`; unavailable IDs use `unknown`.
Each recovery record is included in the generation manifest. No substitute
`experiment_manifest.json` is written.

Replay needs no dialogs or original manifest for a recovery recipe. It still
requires all three captures and the workspace variables, checks the workspace
hash against the file reviewed during recovery, and applies the existing
geometry and rendering checks. If the workspace changes, review its run
information again. A hash identifies the preserved file; it does not prove its
historical provenance or establish a source revision. Recovered metadata and
unknown IDs remain visible limitations when using the figure as evidence.

Existing **schema version 2** recipes retain their manifest requirement. A
recipe that specifies a manifest still fails if that file disappears or its
generation/scene does not match; replay never switches to recovery silently.

## Create your first figure

After setting up the MATLAB path and checking the inputs:

```matlab
dataRoot = 'C:\data\my-acquisition';  % EDIT
result = setup_trio_figure(dataRoot, ...
    'SceneId', 'my_scene_4kus', ...      % EDIT: actual scene ID
    'FigureId', 'my_trio_figure', ...    % EDIT: new candidate name
    'Publish', false);

if ~result.cancelled
    disp(result.generationDirectory);
    imshow(imread(fullfile(result.generationDirectory, 'assets', 'global_average.png')));
end
```

This example uses `Publish=false` to retain an inspection generation without
advancing latest. It still writes a complete attempt and compiles its preview.
Omit the option or use `true` to advance latest after success.

### Follow the review steps

After input selection, six numbered dialogs guide the visual review. **Next**
accepts a step and writes a local checkpoint. **Back** preserves valid edits
and returns to the previous adjustment; it is disabled on the first step.
**Save and Close** saves valid edits without approving the current step.

1. **Camera preparation.** Review rotation, vertical flip, and downsampling
   beside the global-stage reference. Initial rotation is `-90` degrees for
   both cameras; ThorCam initially has vertical flip. Scale starts with an
   image-dimension estimate, capped at `1`; it is not a measured calibration.
   Valid factors are `0 < factor <= 1`. Gaussian filtering still applies at
   factor `1`. **Estimate scale** recomputes the dimension estimate.
   **Match points** opens optional calibration: add at least two complete
   reference/camera pairs, undo a pair if needed, then choose **Use calibration**.
   The scale is the median ratio of pairwise reference to camera distances,
   not a physical pixel size. Cancelling calibration keeps prior settings.
2. **Alignment.** Edit rotation and X/Y translation beside refreshed overlays
   and the common-field mask. X is columns and Y is rows, in pixels after
   camera preparation. Registration rotation is additional to preparation.
   Automatic estimation runs on first entry; **Re-estimate** explicitly reruns
   the `-2` to `2` degree search in `0.25` degree steps and normalized
   cross-correlation translation estimation. Ordinary edits apply saved
   transforms, and accepted transforms are retained for deterministic replay.
3. **Common crop.** Drag any of the three linked rectangles or edit X edge,
   Y edge, width, and height. Red shading marks invalid common-field pixels.
   A crop outside the common bounding limits blocks Next. Invalid corners
   within those limits produce a warning, preserving existing export rules.
4. **Brightness.** Compare all three columns together. The intermediate and
   final images share normalization and a multiplier; ThorCam has separate
   normalization and a multiplier. **Separate intermediate and final
   brightness** opts into independent display multipliers; both start from the
   current shared value. Shared normalization is retained. Re-linking uses the
   current global-stage value for both; enabling separation again initializes
   both from that linked value. ThorCam remains independently controlled.
   Sliders and numeric controls cover
   `0.1` to `5`. Clipping percentages count values outside the display range;
   **Highlight clipping** marks them magenta. Every update starts from the
   unmultiplied normalized images, so reducing brightness restores detail
   rather than rescaling an already clipped preview.
5. **Zoom regions.** Both orange/cyan rectangles remain editable on the middle
   panel. The dialog opens maximized with a compact toolbar, three large main
   images, and one matching zoom row for the active region. Selecting or dragging
   either box switches the preview row without changing the other rectangle.
   X/Y controls use one-based coordinates on the cropped, upsampled exported
   panel. Recipes retain zero-based zoom coordinates. Invalid rectangles block
   Next instead of being silently clamped. Retained regions outside a newly
   reduced crop remain editable so they can be repaired. Double-clicking is not
   required. Final review and export still contain both zoom rows.
6. **Final review.** Inspect the complete set of three main images and six
   zooms alongside the crop and display summary. **Generate** validates the
   recipe and inputs, retains a generation, and compiles its figure-only PDF.
   The result window provides **Open PDF**, **Show Output Folder**, and failure
   diagnostics. The PDF uses the existing LaTeX layout and renderer snapshot.

### Pause, resume, and revise

The local `setup-draft.json` lives in the figure directory beside the working
recipe and is ignored by Git. It stores the partial recipe, reviewed-step
flags, current step, data-root locator, and input paths/hashes. It does not
create a generation, change latest/selected, or qualify scientific evidence.
Checkpoints are replaced through sibling temporary files; failed saves retain
the last checkpoint and let you retry with valid edits still in memory.

Run the same setup command with the same scene/figure IDs and output directory
to **Resume** or **Start Fresh**. With no root argument or environment root,
setup can reuse the draft's stored data root. Missing or changed inputs and
malformed drafts are reported before restoring previews. Restore the original
inputs/draft or choose Start Fresh to select and review inputs again. Cancelling
Start Fresh before new inputs are accepted retains the existing checkpoint.

Closing a review window keeps the last checkpoint. If the current step has
unaccepted edits, choose to save valid edits, discard those edits, or keep
editing. Save and Close does not generate output. Cancellation results include
`cancelled=true` and `draftPath` (empty if figure identification was cancelled).
Check `cancelled` before accessing generation fields. Preflight errors still
throw; incomplete generations retain diagnostics and the setup checkpoint.

Returning to earlier steps preserves later settings but requires review of
settings that depend on a change. Preparation/calibration edits require renewed
alignment and subsequent review; alignment edits require crop and subsequent
review; crop edits require brightness and zoom review. Brightness edits require
final review, and upsampling changes require zoom review. Generation routes you
through any outstanding adjustment reviews before opening the final review.
A completed draft remains available for further revisions. Editing an existing
working recipe without a draft still uses [customization](#customize-a-figure).

### Inspect, replay, and select a generation

Setup and replay now retain separate generations and automatically compile a
figure-only PDF. See the [generation workflow](generation-workflow.md) for the
folder structure, options, failure recovery, preview-only command, Git history,
and explicit selection for LaTeX use.

```matlab
if ~result.cancelled
    disp(result.status);
    disp(result.previewPath);
    disp(result.generationDirectory);
end

% Replay from the exact retained recipe; requires external raw data.
replayed = replay_trio_figure(result.recipePath, dataRoot);

% Preview saved images without raw data; creates a derived generation.
preview = preview_trio_figure(result.generationDirectory);

% Only this explicit command changes the thesis-facing export.
selection = select_trio_figure(result.outputDirectory, result.generationId);
```

The [figure archive](../../candidate-outputs/figures-source/README.md) links to
migrated figure histories. Original wrappers, captioned PDFs, and metadata are
preserved in legacy generations. None is automatically selected.

## Replay and inspect a saved figure

See [Replay and preview](generation-workflow.md#replay-and-preview).

## Understand the outputs

See [Storage and returned paths](generation-workflow.md#storage-and-returned-paths).

## Use the bundle in LaTeX

See [Select a version for LaTeX](generation-workflow.md#select-a-version-for-latex).
Captions remain author-maintained. The shared renderer retains the 3% zoom
image overlap, and each generation saves its own copy of the renderer.

## Customize a figure

### Copy, edit, validate, inspect

Start with a reviewed recipe. `defaultRecipe` alone has placeholder paths,
generation ID, crop, and ROIs that are not ready for a real scene. Keep the
original recipe and candidate intact while evaluating changes:

```matlab
originalRecipePath = recipePath;  % Existing reviewed recipe
recipe = triofig.readRecipe(originalRecipePath);
recipe.figure.mainWidthCm = 4.0;
recipe.figure.zoomWidthCm = 1.9;
recipe.presentation.intensityMultipliers.thorcam = 1.2;
triofig.validateRecipe(recipe);

customDirectory = fullfile(tempdir, 'my_trio_variant');
customRecipePath = fullfile(customDirectory, 'trio-recipe.json');
triofig.writeRecipe(customRecipePath, recipe);
inspection = replay_trio_figure(customRecipePath, dataRoot, ...
    'OutputDirectory', customDirectory, ...
    'ReferenceDirectory', fileparts(originalRecipePath), ...
    'Publish', false);
disp(inspection.stagingDirectory);
disp(struct2table(inspection.candidateComparison));
```

`readRecipe` validates; `writeRecipe` does not, so validate before saving edits.
Replay additionally checks actual inputs and geometry. A separate directory
avoids changing a recipe while leaving its previous images beside it.

For an intentionally new variant, give it its own `figure.id`, recorded
`candidateOutputRelativePath` under `candidate-outputs/figures-source/`, and
`figure.assetDirectoryFromWrapper`. After inspecting, a new candidate can use
`comparison.requireExactCandidateMatchBeforePublish=false` **in its own recipe**;
save and replay to an explicit new output directory. Preserve the original
dense4 recipe's exact-match gate.

### Effective settings

| Group / recipe fields | Meaning and constraints |
| --- | --- |
| `input.*RelativePath`, `input.expectedGenerationId`, `sceneId` | Paths and expected run/scene identity; keep consistent with source records. A new scene should normally use setup. |
| `input.requiredWorkspaceVariables` | Names checked/loaded from the MAT file. Rendering still requires its two named average arrays; this does not rename arrays. Keep the default list for normal use. |
| `cameraPreparation.thorcam`, `.validation` | `rotationDegrees`, `flipVertical`, and `downsampleFactor` applied before registration; `0 < factor <= 1`. |
| `registration.transformSource` | `automatic` estimates transforms; `saved` uses `savedTransforms`. Setup saves accepted transforms. |
| `registration.rotationStartDegrees`, `.rotationStopDegrees`, `.rotationStepDegrees` | Automatic sweep with finite ordered bounds and positive step; ignored with saved transforms. |
| `registration.rotationInterpolation` | Interpolation passed to registration rotation, normally `bilinear`; can affect matching/pixels. |
| `registration.savedTransforms` | Camera rotation in degrees and `TranslationXY=[x,y]` in pixels after camera preparation. X is horizontal; Y vertical. |
| `registration.cropMode`, `.crop`, `.requireExpectedCrop` | `intersection` uses the mask's bounding rectangle, requiring equality to recorded crop if `requireExpectedCrop=true`. `saved` uses recorded crop and checks it fits common bounding limits. |
| `presentation.intensityMultipliers` | Positive `globalLocal`, `thorcam`, `validation` multipliers after normalization. Global/final share range and multiplier; each camera has a separate range. Values above one can clip. Validation has no exported column. |
| `presentation.upsampleFactor` | Positive resize factor, default `4`, before zoom extraction. Review ROI coordinates after changing; this does not add measured resolution. |
| `presentation.zoomRois` | Exactly two ROIs with IDs `1`/`2`, colors `orange`/`cyan`, nonnegative integer X/Y origins, and positive integer dimensions. Must fit every exported panel. |
| `figure.mainWidthCm`, `.zoomWidthCm` | Positive displayed widths in centimeters; aspect ratios retained. These are layout sizes, not sample scales. |
| `figure.assetDirectoryFromWrapper` | Retained legacy path metadata; new generation layouts use their self-contained `../assets` path. |
| `figure.id`, `candidateOutputRelativePath` | Candidate identity/recorded destination. The latter must start with `candidate-outputs/figures-source/`. Use `OutputDirectory` to control replay's actual destination. |
| `comparison.requireExactCandidateMatchBeforePublish` | If true, all nine references must exist and match dimensions/pixels before publication. False for new setup recipes; true for dense4. |
| `comparison.maximumAbsolutePixelDifference` | Nonnegative threshold checked alongside exact equality. Raising it does **not** allow nonzero pixel differences when the match gate is enabled. |

**Coordinates:** Crop `rowStartOneBased`/`columnStartOneBased` are one-based
origins on the full global reference grid before display resizing; crop
`height`/`width` are positive integer pixels. ROI `xZeroBased`/`yZeroBased` are
zero-based top-left origins on the **cropped, upsampled exported panel**. X is
column, Y row. For example, X/Y `0,0`, width `20`, height `10` selects exported
columns 1–20 and rows 1–10. Do not copy crop-grid coordinates directly into ROIs.

### Descriptive fields and fixed behavior

Not every recipe field is a switch. The implementation fixes Gaussian prefilter
sigma to `1 / downsampleFactor / 2`, camera downsampling to bilinear, mask
rotation to nearest-neighbor, translation estimation to `normxcorr2`, the
registration reference to the global average, and display resizing to
nearest-neighbor. Editing `antiAliasSigmaFormula`, `downsampleInterpolation`,
`maskInterpolation`, `translationMethod`, `registration.reference`, or
`upsampleInterpolation` does not change these operations. Keep those recorded
descriptions consistent with the code.

`calibration.*.pointPairs` record feature selections; replay uses the saved
resize factors rather than recalculating from points. `recoveryNote`,
reconstruction run paths, and the optional source-snapshot directory record
provenance; they do not rerun reconstruction or select a different workspace.
Labels are fixed to ThorCam, **After global alignment**, and **After local
refinement (final)**. Another column or a third ROI requires code/template
changes, beyond recipe customization.

## Troubleshooting

| Symptom / error | Likely cause | What to do |
| --- | --- | --- |
| Undefined entry point or `triofig.*` | Wrong path/current folder | Run path setup; add `scripts/figure-preparation`, not `+triofig`. Check `which`. |
| Missing image/ROI functions, `pdist`, or Java errors | Missing toolbox, graphics, or JVM | Check `ver`/`usejava('jvm')`; use interactive MATLAB for setup and the required toolboxes. Use reviewed scale if point calibration is unavailable. |
| `triofig:MissingInput` / `MissingRecipe` | Wrong root/path or absent source | Check `isfolder(dataRoot)`, `isfile(recipePath)`, and paths beneath the root. `.npz` is not a MAT workspace. |
| Several files offered or a file picker | Ambiguous/no discovery matches | Select the correct run; check tree and scene ID. Automatic selection does not verify scientific pairing. |
| `triofig:InvalidInput` | Selected file/directory outside root | Choose a root containing all selected inputs and the available run directory. |
| `triofig:InvalidWorkspace` or missing array fields | Missing variables | Inspect with `whos('-file', path)`; recover the correct run's MAT export, not display PNGs. |
| `triofig:InvalidRunManifest` | Wrong/missing generation or scene text | Select the matching manifest and inspect expected identity in the recipe. |
| `triofig:InvalidRunInfo` | Recovery run directory is missing, or the workspace hash differs from the reviewed file | Check the preserved run location; review recovery information again for a changed workspace. |
| Poor registration / `triofig:NoCommonCrop` | Wrong scale/orientation, poor features, or no overlap | Review preparation/overlays, calibrate scale, and adjust transforms from corresponding features. |
| `triofig:InvalidCrop` / `UnexpectedCrop` | Crop outside bounds or changed automatic bounds | Review transforms/crop. For a variant review new geometry; do not relax dense4 checks simply to force publication. |
| `triofig:FlatImage` | Crop has no intensity range | Inspect arrays, camera alignment, and crop; choose useful intensity variation. |
| `triofig:InvalidRoi` / `InvalidRecipe` | Bounds, grid, schema, or settings wrong | Use schema 3 for new recipes (2 remains supported); keep recovery fields consistent and check ROIs against exported dimensions after crop/resize changes. |
| `triofig:CandidateMismatch` | Missing/different exact references | Inspect with `Publish=false` and `candidateComparison`; check reference directory, inputs, recipe, environment. A larger threshold does not relax exact matching. |
| Bright/saturated panels | Camera normalization or clipping | Review separate camera versus shared global/final ranges and reduce multipliers. PNG brightness is not raw intensity. |
| Missing files / write errors | Unshared history, permissions, interrupted generation | Check the returned status, saved manifest, and local availability of the generation; failed attempts remain for inspection. |
| Preview incomplete | Missing compiler/package or invalid LaTeX | Inspect `build/compiler.log`, fix the compiler/packages, then derive a new preview. |

## Verification and dense4 provenance

From the repository root in PowerShell:

```powershell
matlab -batch "addpath('scripts/figure-preparation'); results=runtests('scripts/figure-preparation/tests'); disp(table(results)); assert(all([results.Passed]));"
```

Tests cover recipe handling, discovery, preflight, interactive helpers,
manifest selection/recovery, synthetic replay without a manifest, v2
compatibility, and dense4 replay/publication. Dense4 tests look for data in the current user's
`OneDrive - Technion/office computer files/images_output/3_6_26` directory. If
absent, those checks become incomplete through assumptions, and `all(Passed)`
fails. Inspect the table to distinguish unavailable data from failures.
`TRIO_FIGURE_DATA_ROOT` does not redirect that fixed test data lookup.

Check dense4 using your own source root without replacing the saved bundle:

```matlab
dense4RecipePath = fullfile(repoRoot, 'candidate-outputs', 'figures-source', ...
    'eyedrop_3_6', 'trio-recipe.json');
dense4 = replay_trio_figure(dense4RecipePath, dataRoot, ...
    'OutputDirectory', fullfile(tempdir, 'dense4_inspection'), ...
    'Publish', false);
disp(struct2table(dense4.candidateComparison));
assert(all([dense4.candidateComparison.samePixels]));
```

Here `dataRoot` must contain actual June 3 files at the locations in that recipe,
not the illustrative scene tree used earlier. For the legacy wrapper:

```matlab
addpath(fullfile(repoRoot, 'scripts', 'figure-preparation', ...
    'eyedrop-2026-06-03-dense4'));
dense4 = run_figure_replay(dataRoot, ...
    'OutputDirectory', fullfile(tempdir, 'dense4_inspection'), 'Publish', false);
```

The wrapper accepts the replay options, uses the fixed dense4 recipe,
and falls back to `EYEDROP_20260603_DATA_ROOT` when root is omitted. This differs
from the shared entry points. Additional return fields `configPath`/`comparison`
alias `recipePath`/`candidateComparison`.

See the [dense4 provenance README](eyedrop-2026-06-03-dense4/README.md),
[saved recipe](../../candidate-outputs/figures-source/eyedrop_3_6/trio-recipe.json),
and [scientific provenance record](../../research-context/result-provenance/fig_eyedrop_3_6.yaml).
The recipe preserves the available `algo_run/regular_run_best` location and
upstream manifest's earlier `algo_run/regular_run` path. Exact replay verifies
configured rendering against the candidate; it does not recover missing
historical source revisions or establish a scientific conclusion. Keep those
provenance gaps distinct from current replay checks.

### Independent brightness recipe compatibility

Schemas 2 through 4 retain linked reconstruction-image display mapping. Schema
5 adds shared-by-default or separate workspace inputs while retaining the
existing single-workspace fields as the global source for compatibility. Opting
into independent brightness adds
`presentation.intensityMode` (`linked` or `separate`) and `global`/`local`
entries in `presentation.intensityMultipliers`. The existing `globalLocal`,
`thorcam`, and `validation` entries remain. Schema 5 records its effective mode
and intermediate/final multipliers in the generation manifest. Older software
rejects schema 5 instead of silently replaying it with the wrong workspace or
brightness behavior. Legacy schema-2 upgrades retain the authentic-manifest
requirement; schema-3 recovery records remain intact. A schema-5 recipe remains
version 5 after re-linking.

Both modes use the original shared intermediate/final normalization range;
independent controls change only the display multipliers. Disclose independent
display mapping and the effective gains in the figure's author-maintained
caption when using that mode. Final review reports those gains.

Repository provenance inspection uses direct `git -C` process arguments and
absolute file paths. Generate does not change MATLAB's current folder or
search path, including when the package is reachable only from the current
folder. A metadata error after generation allocation retains an incomplete
attempt with the cause recorded; latest and selected do not advance.
