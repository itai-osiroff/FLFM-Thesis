# Native Capture Editor implementation record

## Approved design

Standalone MATLAB R2025b editor with Image Processing Toolbox. Each source has
an independent reversible filter stack evaluated on the native image. Comparison
geometry and viewing intensity ranges are separate from exported pixels.
Native TIFF/PNG exports retain format, dimensions and bit depth; MAT exports
retain the source variable name and numeric class. Optional display TIFFs are
explicit derivatives. Sources are immutable and verified by SHA-256.

The user selected original-image editing, MATLAB desktop, separate MAT exports
with optional TIFF, single/trio/pair comparisons, recipe import or new geometry
setup, the nine core filters, fast approximate dragging followed by exact native
updates, and independent stacks with explicit copying.

## Work units

1. Native source loading, intensity mappings, deterministic filter catalog and
   evaluator, staged native export with readback and provenance.
2. Atomic versioned sessions, source verification and relocation, global history,
   fixed original-derived comparison geometry, setup and calibration controls.
3. Persistent MATLAB interface, ordered stack manipulation, numeric/slider
   controls, gesture history, linked inspection, original/edited comparisons,
   histogram/clipping, session and export actions.
4. Synthetic correctness tests, dense4 performance/integration checks, existing
   trio regressions and native UI inspection.

## Implementation rulings

- Reuse the current checkout and preserve concurrent changes to the trio tools.
  New editor code lives separately under `scripts/capture-editor`.
- Keep editor geometry helpers separate from the actively changing trio helper
  implementation. Follow its geometric operations and test correspondence;
  do not route edited arrays through its normalization or 8-bit rendering.
- Source selection establishes fixed normalization ranges. Replacing the source
  set starts a fresh session after save/discard handling, avoiding reinterpretation
  of existing stacks.
- Aligned comparisons require four sources. Partial source sets support native
  editing and inspection. Global/local represent the same scene/grid.
- Native export follows source container, including raster global/local inputs.
- Only grayscale single-plane uint8/uint16 TIFF/PNG and finite real 2D single/
  double MAT reconstruction arrays are supported initially.
- Camera reconstruction and scientific metrics, RGB/stacks, NPZ, brush editing,
  spatial masks, figure generation and LaTeX changes remain outside this utility.

See the editor README for launch commands, operational behavior and test commands.
