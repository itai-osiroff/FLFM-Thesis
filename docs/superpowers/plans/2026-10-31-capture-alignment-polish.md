# Capture alignment and crop polish

Approved scope: the native MATLAB capture editor's alignment/crop workflow;
the trio scale-calibration dialog, input/filter/export flows, and native arrays
remain unchanged. Source base: PR #3, `694b01f` (2026-10-31).

## Required behavior

- One guided Prepare / Match and align / Crop workspace with persistent previews,
  expandable manual controls, per-camera review state, and all shared-field
  participants identified.
- Axis-checked, numbered complete point pairs; remove individual pairs; Escape
  discards a half-pair. Fit orientation-preserving uniform scale, rotation, and
  translation by least squares using every complete pair; allow positive scales
  above one, reject degeneracy, and show RMS/maximum error in reference pixels.
- Convert the fit into existing preparation scale and saved transforms using
  actual resize pixel-center and cropped-rotation conventions. Keep optional
  preparation/pair/parameter provenance under each camera's calibration.
- Preserve a fully valid custom crop. Otherwise select the maximum-area valid
  rectangle with a histogram stack; ties prefer top, then left. Every newly
  applied crop must contain only shared valid pixels, including preparation
  rotation support. Invalid drags restore the last crop; invalid numeric edits
  block Apply and offer Fit valid crop.
- Preparation orientation changes clear that camera's pairs. Orientation/scale
  changes require review via points, image estimation, or explicit manual
  acceptance. No-overlap failures retain the previous staged geometry.
- Camera switches retain staged settings. Apply is one undoable transaction;
  Cancel restores original geometry and pairs. Legacy rendering stays unchanged
  on import; opening this workspace flags legacy invalid crops for repair.
- Retain session schema 2 and support older sessions; fit metadata survives
  JSON, history, and relocation. Do not attribute stored scale-only pairs to a
  full geometric fit.

## Implementation boundaries

Pure `fitPointAlignment`, `isValidCrop`, and `validCrop` helpers support the
capture-specific point controller and transactional `applyPointAlignment`.
Existing transform fields remain authoritative. The optional registration flag
`requireValidPixels` opts new geometry into propagation of original camera support
through preparation; absent flags retain legacy comparison behavior.

## Verification

Test similarity recovery and actual rendered coordinates (translation, rotation,
up/downsampling, fractional resize, non-square images, flip/preparation), noisy
extra pairs, degeneracy, valid crop preservation, strict support, empty overlap,
disconnected/thin masks, deterministic ties, and exhaustive small-mask oracles.
Exercise session/history round trips, axis checking, incomplete-pair cancellation,
per-camera review, legacy crop repair, repeated crop edits/reset, and Apply/Cancel
through desktop callbacks. Run capture-editor and trio suites. Review native
window screenshots and actual crop drags at 1200x820; report any unavailable
125% display-scaling check explicitly rather than modifying system DPI settings.
