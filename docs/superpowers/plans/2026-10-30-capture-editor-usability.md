# Capture editor usability implementation

Approved conversational plan: persistent MATLAB Inputs / Alignment / Edit / Export workspace; staged role selection; partial aligned sets with global reference; clearer native versus viewing-only effects; reset and bulk copy; background subtraction, CLAHE and bilateral filters; version 2 sessions reading version 1; native verified export unchanged.

## Execution ledger

- Work in current feature checkout to preserve the existing local geometry and documentation fixes. Do not commit unrelated changes or publish.
- UI owner: Editor and UI helpers; geometry owner: resolver, comparison panels and geometry dialog; filter owner: catalog and evaluator; integration owner: sessions, documentation and full verification.
- Existing launch and evaluator signatures remain compatible. No reconstruction, metrics, exported spatial transforms, masked edits or batch automation.
- Acceptance: editor and trio tests, source identity and native export checks, live desktop inspection at supported sizes.

## Verification record

- MATLAB R2025b desktop: all 37 capture-editor tests passed, including staged UI,
  partial sets, Dense4 correspondence, new filters, export selection, and dialog
  Apply/Cancel/close lifecycle. Log: `tmp/usability-final-desktop.log`.
- All 53 trio regression tests passed in `tmp/usability-final-batch.log`.
  That combined batch invocation exits nonzero because desktop-only editor tests
  are assumption-filtered; those tests subsequently passed in the desktop run.
- Live Dense4 comparison inspected at 1280×800 and expanded 1920-pixel width.
  Corrected nested-grid padding to prevent footer and reset-row clipping.
- Inputs and Alignment use focused dialogs launched from persistent sections;
  the comparison viewer remains in the main workspace.
- Changes remain uncommitted in the current feature checkout, alongside the
  preexisting local changes. Original input files and native export contract are
  preserved. Full screen-reader certification was not performed.
