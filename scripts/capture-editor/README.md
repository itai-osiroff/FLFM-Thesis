# Native Capture Editor

The Native Capture Editor is an interactive MATLAB utility for making cosmetic,
per-image edits to grayscale ThorCam, validation, global-stage, and final
local-refinement images. It is intended for inspecting and preparing
presentation derivatives—not for reconstructing images, calculating
scientific metrics, or publishing thesis figures.

The editor never modifies its input files. Keep the original data and its
run/revision provenance; edited images are derivatives, not new reconstruction
results.

## Contents

- [Requirements and launch](#requirements-and-launch)
- [Choose and load inputs](#choose-and-load-inputs)
- [Navigate the editor](#navigate-the-editor)
- [Compare and align images](#compare-and-align-images)
- [Edit images](#edit-images)
- [Save a session and export images](#save-a-session-and-export-images)
- [Supported inputs and limitations](#supported-inputs-and-limitations)
- [Run tests](#run-tests)

## Requirements and launch

Use MATLAB R2025b with Image Processing Toolbox. From the repository root:

```matlab
addpath('scripts/capture-editor');
editor = launch_capture_editor('C:\data\my-acquisition');
```

`dataRoot` must be an existing directory. To choose it interactively instead,
omit the argument:

```matlab
editor = launch_capture_editor();
```

For comparison work based on an existing trio recipe, import its geometry and
source paths relative to `dataRoot`:

```matlab
editor = launch_capture_editor('C:\data\my-acquisition', ...
    'RecipePath', 'C:\path\to\trio-recipe.json');
```

To resume a saved editing session, use `SessionPath`:

```matlab
editor = launch_capture_editor('C:\data\my-acquisition', ...
    'SessionPath', 'C:\data\my-acquisition\capture-edit-session.json');
```

If both options are provided, `SessionPath` takes precedence. You can also
launch the app without either option and use **Choose inputs**, **Import trio
recipe**, or **Open session** in the toolbar.

## Choose and load inputs

Each loaded image has a role: `thorcam`, `validation`, `global`, or `local`.
Choose **Choose inputs** to select camera images and a reconstruction
workspace. One workspace supplies both `global` and `local` by default; enable
**Use separate workspaces** to choose a different workspace for each average.
The editor may offer discovered
files as suggestions, but you must select them explicitly. Use **Browse for
another file…** to choose a different file or skip a role when it is not
available. You can load a single image for individual editing; aligned
comparison uses global as reference and supports partial input sets.
Importing a trio recipe preserves its shared or separate workspace mapping.

The left **Native inputs** list selects which image is active for editing.
Its details show the role, width × height, MATLAB numeric class, file format,
and path relative to `dataRoot`. Filters and display-range settings belong to
that selected role only unless you explicitly copy filters.

## Navigate the editor

The persistent **Inputs**, **Alignment**, **Edit**, and **Export** sections keep
the viewer visible while changing controls. Select an image in the navigator or
click its panel to choose the editing target. The highlighted target identifies
which independent filter stack will change. Pair selectors appear only in Pair
mode; the histogram reserves space only while enabled.

**Inputs** stages the role choices together. The shared-workspace checkbox
starts enabled; disabling it activates the separate local-workspace selector.
Check the discovered suggestions,
browse or skip roles, then confirm the set. Invalid or cancelled loading preserves
the current session. **Alignment** opens grouped original-image geometry controls,
including camera selection, translation nudges, overlay opacity/checkerboard,
scale calibration and graphical common crop. Apply commits geometry; Cancel
restores it. These transforms affect comparisons only.

**Edit** groups filters by purpose and provides filter/stack reset and explicit
independent copying. Viewing controls do not change exported values. **Export**
summarizes native formats and selected outputs; optional display TIFFs remain
separate display-mapped derivatives.

| Area or control | What it does |
| --- | --- |
| **Choose inputs** | Choose source images for one or more roles. Replacing inputs starts a new editing session. |
| **Import trio recipe** | Load source paths and comparison geometry from an existing trio recipe. |
| **Open session** / **Save session** | Restore or save filter stacks, comparison settings, view state, and undo/redo history. |
| **Undo** / **Redo** | Step through editing changes. A slider drag is one history entry. |
| **Export chosen images** / **Export all loaded images** | Export the selected role or every loaded role into a new output folder. |
| **Single** / **Trio** / **Pair** | Choose one native image, a ThorCam/global/local comparison, or a pair of selected original/edited images. |
| **Alignment** | Configure orientation, scale, alignment, and common crop for aligned viewing. |
| **Fit** / **1:1** | Fit images to the viewer or show them at one display pixel per image pixel. |
| **Display range** | Set the black and white native-intensity values used to map the selected image for viewing. This does not edit or export the image values. |
| **Show original** | Temporarily view unedited sources; hold **Space** for the same before/after check. |
| **Highlight clipping** | Mark values at the ends of the current display range in magenta. |
| **Show histogram** | Show the selected, edited image's distribution over the fixed display range. |
| **Ordered filter stack** | Select, enable/disable, duplicate, remove, reorder, or copy filters for the selected role. |
| **Status line** | Shows whether the view is approximate or exact, whether it is on the native grid or aligned common field, and any processing or export errors. |

Use the axes' zoom and pan tools to inspect details. While adjusting a slider,
the editor shows an explicitly labeled approximate preview, capped at 1024
pixels on the largest dimension. Releasing the control computes the
native-resolution result. Large images and spatial filters can take longer.
An approximate preview is not the exact exported image.

## Compare and align images

**Single** displays the selected role on its native grid. **Pair** lets you
choose any two loaded `role original` or `role edited` images. **Trio** displays
ThorCam, global, and local images. When geometry is available, comparison
views use the aligned common field; the validation image also contributes to
the common valid area even though it is not one of the three Trio panels.

Aligned comparison requires a global reference and only the camera roles you load.
The common field is the intersection of loaded cameras with the reference grid;
global/local alone share their native grid. Without global, pairs are explicitly
unaligned. Geometry is initialized from the originals. Choose **Alignment** to
inspect or change it:

1. **Prepare:** choose the camera, preparation rotation, vertical flip, and scale.
   Changing orientation clears its saved pairs. Orientation or scale changes
   require alignment review before Apply becomes available.
2. **Match and align:** choose **Align from points**, then **Add pair**. Click a
   global-reference feature and the matching feature in the oriented, full-size
   camera image. Numbered markers and the pair list identify complete pairs;
   **Remove selected pair** deletes a pair, and Escape cancels an unfinished pair.
3. At least two distinct pairs fit uniform scale, rotation, and translation.
   Additional pairs help assess consistency. Inspect the overlay and RMS/maximum
   point error in reference pixels, then choose **Use alignment**. Scale factors
   above one are supported. This is a geometric fit; a low fitting error alone
   does not establish scientific registration accuracy.
4. Alternatively choose **Estimate from images**, or expand **Show manual
   controls** to adjust rotation and X/Y translation. X is columns and Y is rows,
   on the reference grid. After a preparation change, **Use manual alignment**
   explicitly accepts the current manual geometry. Each camera has its own review
   status; switching cameras preserves staged settings.
5. **Crop:** drag the persistent blue rectangle or edit row, column, height, and
   width. Red shading identifies invalid shared pixels. Invalid drags restore the
   previous crop on release; invalid numeric edits block Apply. **Fit valid crop**
   selects the largest fully valid rectangle, preferring the topmost and then
   leftmost when equal areas exist.
6. **Apply** commits the entire staged geometry as one undoable change. **Cancel**
   discards it, including point edits. A fit preserves an existing crop whenever
   all its pixels remain valid; otherwise the workspace fits a valid crop and
   explains the change. Failed alignment with no overlap retains prior geometry.

The shared mask includes all loaded cameras, including validation when it is not
shown in Trio view, and excludes padding introduced by preparation/alignment
rotation. The capture editor's point alignment is independent of the trio figure
setup tool, whose point dialog continues to calibrate scale only.

Version 1/2 sessions and imported trio recipes retain their saved rendering when
loaded. Opening the alignment workspace flags saved crops with invalid pixels;
repair them before applying. New point fits store optional per-camera fit
provenance in version 2 sessions and survive save/load and undo/redo. Saved pairs
alone are not labeled as a fitted alignment.

Comparison geometry affects viewing only: it does not crop, resize, or warp the
native array written by export. Global and local images share the same fixed
display range. Filter changes never re-estimate alignment.

### Processing order and what gets exported

The editor keeps image editing and comparison geometry as separate steps:

1. Each source is loaded on its native pixel grid. Filters are applied in the
   order shown in that role's enabled filter stack. Denoising filters, such as
   bilateral smoothing, therefore operate on the original native-grid image
   before any comparison alignment or crop is displayed.
2. For an aligned comparison view, the editor prepares camera images using the
   selected orientation, scale, alignment transform, and common crop. This
   geometry is used to line up panels for visual comparison; it is not baked
   into the edited image.
3. Export evaluates the filter stack at native resolution and writes that
   result. It does not apply the comparison rotation, scale, translation, or
   crop. Thus the exported image retains the source dimensions and grid, even
   when the viewer shows only a rotated or cropped common field.

An aligned preview shows the filtered image after comparison geometry. The
original/edited switch compares the native source with its filtered version;
the viewing geometry may still be applied to both panels in an aligned
comparison. Changing geometry does not change filter settings, and changing
filters does not trigger a new alignment estimate. If you need a resampled or
cropped image file, perform that as a separate, explicitly recorded step after
export.

## Edit images

Select an image in **Native inputs**, choose a filter from the dropdown, and
select **Add filter**. Each role has its own ordered stack; enabled filters run
in order. Select a stack entry to edit its parameters. **Copy…** copies the
selected filter; **Copy stack…** copies the full stack. For either operation,
choose a destination role and append to or replace its stack. Copies are
independent—later changes do not propagate between images.

Available filters:

| Filter | Effect and parameter notes |
| --- | --- |
| Brightness / contrast | Multiplies normalized intensity by **gain** and adds **offset**. |
| Gamma | Applies a gamma curve to normalized intensity. |
| Intensity window | Maps the normalized **black–white** interval to the full output range. White must exceed black. |
| Threshold | **Cutoff** either zeros values below the threshold or, in **binary** mode, maps pixels to zero or one. |
| Gaussian blur | **Sigma** and **size** control smoothing. Size `0` chooses an automatic kernel size. |
| Mean blur | A box-average filter with an odd kernel **size**. |
| Median filter | A median filter with an odd kernel **size**. |
| Unsharp mask | **Radius**, **amount**, and **threshold** control sharpening. |
| Laplacian sharpening | **Alpha** controls the Laplacian kernel; **amount** controls its strength. |
| Background subtraction | Subtracts a morphological-opening background; default disk radius is 25 native pixels and strength is 1. |
| Local contrast (CLAHE) | Default 8×8 tile grid, clip limit 0.01 and blend amount 1. Images smaller than four pixels on either dimension bypass it. |
| Edge-preserving denoise | Bilateral smoothing; default spatial sigma is 2 native pixels and intensity sigma is 0.05 of the fixed normalized source range. |

Intensity parameters operate on a fixed normalized range derived from the
source intensity range; the editor shows native-value equivalents for relevant
controls. Spatial filter sizes and radii use native image pixels, not screen
pixels. Spatial filters replicate image borders. Enabled operations clip
results to the working range. Integer edits are rounded and saturated when
converted back to the source class; floating-point images are returned to
their original numerical scale.

## Save a session and export images

Save often with **Save session** (or **Ctrl+S**). A session is a JSON file that
records source-relative paths and SHA-256 hashes, intensity/display ranges,
filter stacks, comparison geometry, view settings, and undo/redo history. It
does not contain image pixels. When reopening, sources must still be present
under the selected `dataRoot` and match their saved hashes. You can use a
different data root only if the corresponding relative paths and source hashes
still match. Replacing the source set starts a new editing session.

New sessions use schema version 2 and retain the active workspace section and
viewing options. Existing version 1 sessions remain readable. Unsupported future
versions and unknown filter types are rejected explicitly.

Use **Export chosen images** to export the active role, or **Export all loaded images** to export
every loaded role. Select the desired roles in the Export section and choose a parent directory; the editor creates a uniquely
named new folder inside it and refuses to overwrite an existing destination.
Exports are evaluated at native resolution, independently of the preview.
The editor rechecks each source hash, reads each output back for verification,
and writes a `capture-export.json` manifest with processing settings,
source/output hashes, dimensions, numeric class, and software revision. TIFF
and PNG inputs retain their format, dimensions, and numeric bit depth. MAT
inputs are written as separate MAT files with the original variable name,
dimensions, and numeric class.

The export manifest is the per-export processing record. For each image it
identifies the role, output filename and hash, source-relative path and hash,
MAT variable name when applicable, output class and dimensions, source
intensity range, fixed display range, and the complete ordered filter stack
(including disabled filters and their parameters). It also records the
comparison geometry used in the editor, the UTC export time, MATLAB version,
software revision, and whether the working tree was dirty. Geometry is included
for traceability only; its presence in the manifest does not mean it was
applied to the exported pixels. The manifest records the editor's settings and
inputs, not a separate pixel-by-pixel operation log.

For MAT inputs, you may also request an optional 16-bit display TIFF. This is
a display-mapped derivative using the recorded fixed display range; it is not
a replacement for the native MAT export. With no enabled filters, native
export preserves the source array exactly. Arbitrary proprietary image tags
are not guaranteed to survive export.

Use a saved editing session when you need to reopen and continue editing: it
stores filter stacks, geometry, source hashes, view settings, and undo/redo
history. Use the export manifest to identify and audit a particular set of
written images. Keep both alongside the exported files when you need to
reproduce or review the processing later.

Keep session files and exports outside `overleaf/`, and separate from the
original inputs. Preserve the source revision/run provenance when using an
edited derivative in a scientific context.

## Supported inputs and limitations

- TIFF and PNG: single-plane, grayscale, 8-bit or 16-bit unsigned images
  (`uint8` or `uint16`).
- MAT: finite, real, two-dimensional `single` or `double` arrays for the
  `global` and `local` roles only. The required variables are
  `average_rectified_global_image` and `average_rectified_image`, respectively.
- Every image must be nonempty and two-dimensional. Sources must be inside
  `dataRoot`; sessions and exports should be kept separate from inputs.
- RGB/color images, image stacks, NPZ files, brush editing, and local masked
  edits are not supported.

## Run tests

From MATLAB, at the repository root:

```matlab
addpath('scripts/capture-editor');
r = runtests('scripts/capture-editor/tests');
disp(table(r));
assert(all([r.Passed]));
```

The existing trio-preparation suites remain under
`scripts/figure-preparation/tests`.
