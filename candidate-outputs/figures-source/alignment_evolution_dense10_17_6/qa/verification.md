# Dense10 combined figure verification

Verified 2026-11-07. Final result: passed.

## Numerical and regression checks

- Migration verified the recorded workspace and local parent bundle hashes.
- Parent/workspace aligned and refined stacks, averages and reference index agree exactly; effective configurations agree.
- All 49 global translations reproduce saved aligned views exactly, including zero-filled edges.
- All 49 local remaps pass the existing OpenCV linear interpolation check (rtol=1e-6, atol=1e-6).
- `numerical-checks.json` records mean checks, the marked pixel's source/output intensities, preserved legacy PDF hashes and selected/thesis hash agreement.
- Nine unittest cases pass, covering asymmetric coordinates, boundaries, invalid recipes, altered hashes, migration mismatch/configuration rejection, offline snapshot replay, same-directory snapshot isolation, selection rollback, and legacy single-view raster equivalence.
- Selected recipe replay succeeds using only its local bundle and renderer; the recipe does not require reconstruction archives during replay.

## Wizard evidence

The actual Tk wizard was opened with dense10. Generate preview and Use this figure produced a selected export. Clicking a different marker invalidated selection. Restore selected returned the marker to [262,167]. The final wizard was reopened directly from the selected recipe; edits target the root draft, preserving the frozen export. Screenshots: `wizard-restored.jpg`, `wizard-final.jpg`.

## Visual inspection and thesis

The first candidate had overlapping legend/headings and sampling labels; a subsequent renderer revision separated them. The final figure uses reference-image context for both maps, a visible 8-pixel key and actual source/output patches. The source symbol is p_src because q already denotes upsampling in Chapter 5. Specimen structure remains visible; labels and markers do not overlap. Shared intensity limits and the illustrative crop are retained from the old dense10 figure.

The final compiled figure and shortened caption fit on thesis page 20 (PDF page 28), with clear separation from the page number. Neighboring method and Chapter 6 pages were inspected. `final-thesis-28.png` records the final placement; `combined.png` records the figure view before the caption adjustment. Chapter-local ragged-bottom spacing resolves the introduced underfull page without changing the Technion template.

`verify-template.ps1` passes. `latexmk thesis`, run from overleaf/, completes successfully. No undefined references or Chapter 5 layout warnings remain. Two pre-existing bibliography overfull hbox warnings remain. One intermediate build invoked latexmk from the repository root without loading the local configuration; rerunning from overleaf/ with its XeLaTeX configuration succeeded.

## Provenance limits

Historical algorithm revision, acquisition date and capture-identity verification remain unresolved. Original views retain their recovered-geometry provenance. G includes the selected view. This is an illustrative method figure, not independent validation of correspondence or reconstruction accuracy. Local generations remain Git-ignored and need explicit backup/transfer for offline replay on another checkout.

## Label regeneration, 2026-11-09

Panel text was reworded to match the chapter's warping vocabulary and regenerated with `single_view_figure.py render --use-current-renderer`, then selected with `select_export`. Data, crop, view, sample pixel, display limits and arrow settings are unchanged. Previous selection: preview `509283fa...`, PDF SHA-256 `40b31d00...`. New selection: preview `c3ce45786ba9472e95c8cf4b4d84a995`, PDF SHA-256 `49b512494e3d3ff0d9dd77426229e9fa26a2f47f1e443ddf61ecba31e79ed755`. Rendered in a cloud environment with matplotlib 3.11.2 (original: 3.10.7); the layout was compared with the previous PDF and no text overlaps were found. The thesis copy was replaced with the selected PDF. Not rerun here: the full figure-preparation test suite (one test needs Git history); run it locally. Provenance limits above are unchanged.
