# Intentional capture-editor range handling

Approved implementation scope: preserve floating-point headroom in new sessions;
keep legacy sessions reproducible; make clipping explicit and export losses
reviewable. Source images remain immutable. No new sharpening or tone-mapping
algorithms are introduced.

## Work and acceptance

- Processing: optional preservation policy, double intermediates, explicit Clip
  range node, affine intensity window, bounded-filter domain errors, strict
  excursion and actual clipping diagnostics, exact disabled-stack identity.
- Sessions: schema 3 policy; versions 1/2 and old history snapshots retain
  legacy clamping. Policy changes are visible and undoable.
- Export: frozen preflight arrays, low/high clipping and precision statistics,
  explicit native clipping authorization or floating MAT alternative, source
  hash checks, manifest 2, existing combined workspace and round-trip guarantees.
- Viewing: strict outside-range overlay, native stage diagnostics, unclamped
  histogram, geometric support masks, stale-preview/export protection, policy
  aware caches, approximate-preview labeling.
- Verify gain/inverse identity, sharpening headroom, explicit clipping counts,
  bounded-domain errors, native/floating exports, session/history compatibility,
  cache and geometry behavior. Run complete capture-editor and relevant
  figure-preparation integration suites.

## Integration rulings

Existing programmatic evaluator/export callers default to legacy behavior;
the editor explicitly passes its session policy. Floating MAT uses established
global/local variable names and `image` for camera roles. A floating export
alternative converts the frozen preflight plan rather than reevaluating the
editor. Counts from successive stages are not unique-pixel totals.

Implementation uses the existing checkout; unrelated figure-output changes
are outside this task. No commit, push, or publication is implied.

## Verification outcome

- Final capture-editor suite: 70 passed, 0 failed, 9 desktop-only assumptions
  skipped in MATLAB R2025b batch mode (79 total).
- Broader capture/trio run before the final additional support-mask regression:
  123 passed, 1 failed, 9 desktop-only skips (133 total; the failing test is also
  marked incomplete by MATLAB).
- The trio failure is
  `test_trio_generation_history/testReplayRetainsHistoryAndComparisonFailure`:
  `triofig:InvalidRecipe`, shared-workspace metadata mismatch. Reproduced with
  scripts and required figure fixtures exported from untouched HEAD in a
  temporary directory. No figure-preparation code was changed.
- Read-only review prompted stricter geometric support propagation across
  Gaussian and interpolation footprints; its new regression passes in the final
  capture-editor suite. `git diff --check` passes.
