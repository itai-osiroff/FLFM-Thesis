# Trio Generate, brightness, and zoom fixes

## Approved changes

- Remove working-folder dependence from repository provenance recording.
- Add opt-in independent intermediate/final display multipliers while retaining
  shared normalization, default linked behavior, and historical recipe support.
- Enlarge zoom selection with a maximized window, compact toolbar, large main
  trio, and one active-region preview row. Preserve both rectangles and both
  exported zoom rows.

## Implementation decisions

- Git runs directly through `ProcessBuilder` with separate `-C` arguments;
  repository paths containing spaces or shell metacharacters are literal.
  Current folder and MATLAB search path are never changed by provenance lookup.
- Replay and preview collect repository metadata inside their protected
  generation blocks. Recipe snapshot copy failures are protected too. Failed
  attempts retain their cause and cannot advance latest or selected.
- Schema 4 adds `presentation.intensityMode` and independent `global`/`local`
  gains. Schema 2/3 linked rendering stays unchanged. Opt-in upgrades schema 2
  with its existing authentic-manifest requirement; schema 3 recovery survives.
- `resolveIntensity` is shared by preparation/export and interactive previews.
  Geometry caching uses unit gains even for schema 4. Re-linking uses the global
  value; re-enabling independence initializes both from the linked value.
- Drafts and generation manifests preserve mode/gains; final review reports the
  effective values. Independent display mapping requires caption disclosure.
- Zoom selection updates six existing image objects, with main/preview rows
  allocated 70/30 of the image area. Both rectangles stay editable. Invalid
  retained rectangles after crop reduction open in the editor for repair.

## Evidence and verification

- The original failure was reproduced from the figure-preparation current
  directory without adding its parent to MATLAB's path. That regression now
  passes, with the folder and path unchanged.
- Tests cover repository paths with spaces, forced metadata failures, recipe
  snapshot failure after generation allocation, legacy/schema-4 mapping,
  re-linking, clipping, draft persistence, preview/export pixel agreement,
  schema-2 upgrade, and schema-4 absent-manifest recovery.
- UI tests cover independent controls, active zoom switching without replacing
  image handles, resizing without changing coordinates, and repairing both
  retained zooms after shrinking the crop.
- Brightness and zoom screens were captured and inspected using the actual
  `dense6` input arrays at 1280×860 and 1920×1080. The active environment reports
  96 screen DPI; other Windows scaling settings were not changed or claimed.
- Independent review found the invalid-retained-ROI initialization and uncovered
  recipe-snapshot error boundary; regression tests reproduced both, fixes
  passed, and follow-up review reported no remaining actionable findings.

## dense6 retry

The saved draft was resumed directly at final review from the figure-preparation
current folder, without adding that folder to MATLAB's search path. Generate
completed as `20261030T131136149Z-328bbda0-398` and produced its PDF. Draft recipe
choices, current folder, and search path were unchanged. The successful attempt
advanced latest; no selected export was changed. Both files in the original
failed generation `20261030T124801013Z-6609c667-c82` were verified byte-for-byte
unchanged by SHA-256. The draft checkpoint timestamp was updated normally.

Final verification: all 53 tests in the four MATLAB suites passed. Deliberately
forced failures emit expected diagnostics; no tests failed or were skipped.
`git diff --check` passed. Changes remain uncommitted on
`codex/trio-dialog-workflow`.
