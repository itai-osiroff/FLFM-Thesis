# Trio adjustment dialogs implementation record

## Approved goal

Keep the existing MATLAB sequence while adding responsive visual review,
Back/Next navigation, and automatic setup checkpoints. Preserve recipe schemas,
processing rules, scientific provenance, and versioned generation/selection gates.

## Implementation

- `setup_trio_figure` now controls six focused adjustment dialogs and a separate
  input-selection helper. Existing name/value options retain their meanings.
- Geometry previews use the existing preparation functions with bounded caching.
  Brightness starts from unit-multiplier normalization; exported panels and zooms
  use the same rendering and extraction functions as replay.
- Local schema-1 `setup-draft.json` checkpoints retain choices, review flags,
  input identities, and the data-root locator. They use atomic replacement and
  are ignored by Git. Resume verifies hashes and recipe/input consistency.
- Upstream changes invalidate dependent approvals while retaining choices.
  Failed checkpoint writes retain disk state and explicitly preserve the
  unsaved state through subsequent close/save handling.
- Generation retains the existing replay comparison gates and export behavior.
  Every cancellation result has `draftPath`; early identification cancellation
  returns an empty path. Completed drafts remain available for revision.

## Decisions and boundaries

- Reuse the current checkout on branch `codex/trio-dialog-workflow`; no worktree,
  dependency installation, browser editor, or thesis-template changes.
- Keep input discovery and manifest-recovery dialogs. Back is disabled at the
  first visual adjustment. Existing recipes without drafts continue to use the
  documented recipe-customization workflow.
- Retain existing common-field bounding-box crop acceptance, with a warning for
  invalid pixels inside a permitted crop rather than changing scientific rules.
- Missing/changed inputs require restoring the originals or Start Fresh. An
  interrupted fresh setup does not replace an existing checkpoint before input
  selection and metadata review finish.
- Synchronous choice dialogs serve the controller; close/back confirmations use
  asynchronous callbacks so UI callbacks do not nest blocking event loops.

## Verification

- Existing pipeline, generation-history, and manifest-recovery tests passed as
  a baseline before implementation.
- New tests cover checkpoints, malformed drafts, changed/missing inputs,
  recipe/identity mismatches, serialization failure preserving the last file,
  review invalidation, coordinate validation, intensity/clipping mapping,
  all six adjustment dialogs, and pending-checkpoint close/save behavior.
- The end-to-end fixture resumes a draft, saves and closes, reopens it, revisits
  crop via Back, generates a PDF, compares preview/export pixels, and verifies
  that a subsequent compiler failure retains history without advancing latest.
- Native MATLAB crop/brightness screens were inspected; captures of the six
  dialogs use a synthetic test scene, not thesis evidence. Full test results
  are recorded in the implementation handoff.
- Independent review found a stale cancellation helper and a pending-checkpoint
  state bug; both were fixed. Follow-up review reported no remaining actionable
  correctness findings.
- Final verification: all 45 tests in the four-suite run passed, followed by
  the additional calibration-pair acceptance/cancellation test passing (46
  distinct tests). Expected failure-path warnings cover deliberately missing
  compilers, rejected comparisons, and an unwritable README. `git diff --check`
  passed. MATLAB Code Analyzer reported only pre-existing suggestions and one
  unnecessary new suppression, which was removed.
