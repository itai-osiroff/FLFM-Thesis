# Native Capture Editor

Interactive MATLAB utility for cosmetic edits to ThorCam, validation,
global-stage, and final local-refinement images. Original files remain untouched.
This tool does not reconstruct images, calculate scientific metrics, or publish
thesis figures.

## Start

Requires MATLAB R2025b and Image Processing Toolbox. From the repository root:

```matlab
addpath('scripts/capture-editor');
editor = launch_capture_editor('C:\data\my-acquisition');
```

Import the source paths and comparison geometry from an existing trio recipe:

```matlab
editor = launch_capture_editor('C:\data\my-acquisition', ...
    'RecipePath', 'C:\path\to\trio-recipe.json');
```

Resume an editor session using `SessionPath` instead of `RecipePath`. A relocated
data root is accepted only when the source hashes match. Select sources before
editing; replacing the source set starts a new editing session.

## Workflow

Select an image on the left, choose single/trio/pair viewing, and add a filter
on the right. Every image has its own ordered stack. Filters can be toggled,
reordered, duplicated, removed, or copied explicitly to another image. Copying
does not create a persistent link, and kernel parameters retain native pixel
units. Undo/redo restores edits; one slider gesture is one history entry.

The filter collection includes gain/offset, gamma, black/white intensity
windowing, background cutoff or binary thresholding, Gaussian/mean/median blur,
unsharp masking, and Laplacian sharpening. Intensity controls use a fixed
normalized range with native-value equivalents. Spatial filters replicate image
borders. Enabled operators clip their output to the working range.

While dragging, the viewer uses an explicitly labeled approximate preview with
maximum dimension 1024 pixels. Releasing the control computes the native result.
Export always uses the native evaluator, independently of the displayed preview.
Large or expensive kernels can take longer to finish; an approximate view must
not be treated as the exact exported image.

Aligned comparison requires all four roles. Geometry is estimated from original
inputs and retained while filters change. Import existing geometry or configure
orientation, scale, alignment, and common crop. Re-estimation is explicit.
Comparison transformations and display-range changes never resize, crop, or
warp the native exported array. Global/local viewing shares a fixed range.

## Saving and export

Editor JSON sessions contain source hashes, source-relative paths, intensity
ranges, filter stacks, geometry, and undo/redo state; they do not embed image
pixels. Keep sessions and exports outside `overleaf/` and separate from inputs.

Export one role or all loaded roles to a new destination. TIFF/PNG sources retain
their source format, dimensions, and numeric bit depth. MAT sources export to
separate MAT files retaining the original variable name, array dimensions, and
numeric class. Optional MAT viewing TIFFs are labeled display derivatives and
use the recorded fixed display mapping. Source hashes are rechecked and outputs
are read back before export is reported complete. A sidecar records processing
settings and source/output hashes. Arbitrary proprietary image tags are not
guaranteed to survive export.

With no enabled filters, native export preserves the original array exactly.
Integer edits are rounded and saturated at conversion; floating-point edits
return to their original numerical scale. Cosmetic outputs are derivatives, not
new reconstruction results; source revision/run provenance remains that of the
original data and must accompany any scientific use.

V1 supports single-plane grayscale TIFF/PNG and finite real 2D reconstruction
arrays in MAT files. RGB, stacks, NPZ, brush editing, and local masked edits are
outside its supported input/editing scope.

## Tests

```matlab
addpath('scripts/capture-editor');
r = runtests('scripts/capture-editor/tests');
disp(table(r));
assert(all([r.Passed]));
```

The existing trio suites remain under `scripts/figure-preparation/tests`.
