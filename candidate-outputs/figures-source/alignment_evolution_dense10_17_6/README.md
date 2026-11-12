# Combined dense10 alignment figure

Selected recipe and PDF are in `selected/`. Editable settings: `recipe.json`.
Offline replay also needs the referenced local `generations/` bundle.
Old dense10/dense7 selections remain in their original folders.
See `qa/verification.md` for numerical, wizard and thesis checks.

The recipe uses layout 2 (two regions, forward arrows); `recipe.layout1.json` is the
previous single-crop recipe. Regions: R1 `[130, 228, 214, 295]` (the former crop), R2 `[184, 49, 316, 155]` (132x106 px; the earlier automatic proposal `[224, 80, 308, 147]` plus its pre-shift source and margin). Panel G shows both regions in the globally aligned view, cropped to `context_crop` `[82, 33, 362, 313]`. `local_reference_display_limits` `[0, 4193.4]` sets the display of the blue reference G in panels D-F. Selected preview `a86199763e5e4896805e616243335a32` was replaced on 2026-11-11 by the preview recorded in `selected/figure.recipe.json`; see `research-context/result-provenance/fig_alignment_evolution.yaml`.

Arrow settings (2026-11-12): `global_arrow_spacing` 32, `local_arrow_spacing` 28, `arrow_magnification` 1 (global arrows) and the optional `local_arrow_magnification` 4 (defaults to `arrow_magnification` when absent). Panel G is centred at 0.54 of the figure width (`G_CENTER_X` in the renderer) and the in-figure arrow note was removed; the thesis caption explains the arrows. Selected preview `de3264b5d3264c7187e5137be74ca530`.
