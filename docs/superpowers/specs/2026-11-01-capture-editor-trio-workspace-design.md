# Capture editor trio workspace export

## Intent

Let a capture-editor export from a shared reconstruction workspace load in the
trio-comparison setup workflow without manual MAT-file reconstruction. Keep the
individual edited image files and the capture-export manifest that records
editing provenance.

## Goals and boundaries

- When both global and local MAT roles are exported from the same source
  workspace, also write `workspace.mat` containing
  `average_rectified_global_image`, `average_rectified_image`, and
  `config_json`.
- Put the edited arrays in the combined workspace and carry forward the source
  `config_json` when present. If it is absent, use an empty JSON object so the
  trio setup can still request run identity through its existing recovery flow.
- Verify the combined workspace can be loaded and that both arrays round-trip
  exactly before publishing the export directory.
- Record the combined file and source workspace provenance in
  `capture-export.json`.
- Preserve existing individual native-resolution exports and optional display
  TIFF behavior.
- Do not combine global/local arrays that came from different source
  workspaces; their run metadata cannot be represented by one `config_json`.
- Do not create or imply an experiment manifest, or bake comparison geometry
  into image pixels.

## Approaches considered

1. **Add a combined workspace export (chosen).** The capture editor emits the
   trio's existing shared-workspace contract while retaining its individual
   outputs. This keeps the trio loader's input contract stable and leaves edit
   provenance in the editor manifest.
2. **Teach the trio loader to import editor output folders.** This centralizes
   compatibility in the consumer, but requires the trio setup to understand a
   second export format and its manifest.

## Implementation choices

The combined workspace is emitted only when both MAT roles are selected and
their source paths are identical. It contains the two exact trio variable names
and source `config_json` if available; absent configuration is recorded as
unknown in the capture manifest while the MAT variable contains `{}` for the
trio tool's required input contract. Raster-role exports and separate-source
exports remain individual files.

## Review and evidence

The code change is limited to capture-editor MAT export construction, its
export manifest, and the capture-editor README. The export itself will verify
the combined workspace by reading it back and comparing both arrays and
`config_json`. No thesis scientific claim or result provenance is changed.
