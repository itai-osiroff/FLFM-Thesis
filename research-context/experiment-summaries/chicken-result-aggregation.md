# Chicken Result Aggregation Curation Index

Observation date: 2026-07-17

Source PPT:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output\Results Aggregate - Chicken.pptx`

Source database:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output`

This file captures a first digestion of the chicken-breast aggregate deck. It is
not a final thesis shortlist. The PPT is a discovery and interpretation layer:
before any scene becomes a thesis figure or quantitative claim, trace it to the
source dataset, `algo_run` output, selected candidate, run metadata, and any
validation workspace.

The deck does not annotate exactly what is good or bad in each scene. The
assessment below therefore compares the displayed LF, global average, local
average, ThorCam, and validation panels against the current thesis claims:

- core claim: FLFM plus rectification recovers useful 2D bead scenes under
  tested chicken-breast scattering/aberration conditions;
- local-stage claim: pixelwise/local refinement should be visibly or
  quantitatively justified beyond global translation;
- validation/ThorCam claim: external cameras are downstream comparison
  references, not training or tuning inputs for the ordinary blind rectifier;
- close-bead/support claim: local rectification can improve compactness or
  separability only when crops/line profiles or metrics support that claim;
- method boundary: the result is rectification and warp-and-average, not learned
  reconstruction or full scattering inversion.

Generated inspection artifacts:
`G:\Other computers\My PC\Technion\Msc\Thesis\work\chicken-ppt-digestion`

## Deck Structure

| Slide range | Date | Scene label in deck | Displayed parameters | Matched PPT source folder | Notes |
| --- | --- | --- | --- | --- | --- |
| 4-9 | `2/7/26` | `Sparse - LF` | max displacement `8`, smoothing sigma `15` | `2_7_26\ppt\beads_2um_sparse_chicken_24kus` | Clear sparse scene with multiple beads and visible local/global difference. |
| 10-15 | `2/7/26` | `Sparse2 - LF` | max displacement `8`, smoothing sigma `15` | `2_7_26\ppt\beads_2um_sparse2_chicken_48kus` | Strongest sparse local-improvement candidate in this deck. |
| 18-23 | `12/7/26` | `Sparse1 - LF` | max displacement `7`, smoothing sigma `40` | `12_7_26\ppt\beads_2um_sparse1_chicken_47kus` | Useful as a cautionary sparse case; local is not clearly better. |
| 26-31 | `13/7/26` | `dense - LF` | max displacement `8`, smoothing sigma `10` | `13_7_26\ppt\beads_2um_dense_chicken_24kus` | Good dense candidate; same content is repeated on slides 32-37. |
| 32-37 | `13/7/26` | `dense1 - LF` | max displacement `8`, smoothing sigma `10` | `13_7_26\ppt\beads_2um_dense_chicken_24kus` | Duplicate of the previous block, not a separate scene in the aggregate deck. |
| 40-45 | `15/7/26` | `dense1 - LF` | max displacement `8`, smoothing sigma `30` | `15_7_26\ppt\beads_2um_dense1_chicken_47kus` | Solid dense scene, but local improvement is modest. |
| 46-51 | `15/7/26` | `dense2 - LF` | max displacement `10`, smoothing sigma `40` | `15_7_26\ppt\beads_2um_dense2_chicken_38kus` | Local may reduce support, but sharpness is not clearly improved. |
| 52-57 | `15/7/26` | `dense3 - LF` | max displacement `8`, smoothing sigma `40` | `15_7_26\ppt\beads_2um_dense3_chicken_24kus` | Local and global are essentially unchanged; use only as limitation/control unless metadata says otherwise. |

## Triage Summary

| Tier | Scene | Why it belongs there |
| --- | --- | --- |
| Likely shortlist candidate | `2_7_26\ppt\beads_2um_sparse2_chicken_48kus` | Local average is visibly cleaner and more bead-like than global, with a large rough edge-sharpness increase from the embedded panels. Good candidate for the local-stage claim, but the local output also expands bright support, so compactness needs a real metric before claiming support reduction. |
| Likely shortlist candidate | `13_7_26\ppt\beads_2um_dense_chicken_24kus` | Best balanced dense example in the PPT: dense LF scene, ThorCam/validation context, and local output that modestly cleans/compacts the average without changing the scene identity. Use only one of the duplicate slide blocks. |
| Secondary candidate | `2_7_26\ppt\beads_2um_sparse_chicken_24kus` | Strong visual local/global difference and useful sparse chicken case. The local output may sharpen some bead centers, but it also appears to increase halo/bright support, so it should be framed as recovery/separation evidence rather than compactness until quantified. |
| Secondary candidate | `15_7_26\ppt\beads_2um_dense1_chicken_47kus` | Dense result is readable and local is slightly cleaner, but the improvement is subtle. Good if the final thesis needs a July 15 dense condition, less strong as the main local-refinement proof. |
| Caveat / limitation | `12_7_26\ppt\beads_2um_sparse1_chicken_47kus` | Global and local are visually similar, and rough panel metrics do not favor local. Useful for showing that local refinement is not automatically better under every parameter/scene combination. |
| Caveat / limitation | `15_7_26\ppt\beads_2um_dense2_chicken_38kus` | Local seems to reduce bright support but does not clearly improve sharpness. Could support a cautious compactness discussion if validated by line profiles; not a clean flagship example. |
| Exclude from main proof unless needed | `15_7_26\ppt\beads_2um_dense3_chicken_24kus` | Local and global are nearly identical in the PPT. It is valuable as a no-change/control example, not as evidence that local refinement matters. |

## Scene Notes

| Scene | Good evidence | Weakness / risk | Best thesis use |
| --- | --- | --- | --- |
| `2_7_26\ppt\beads_2um_sparse_chicken_24kus` | LF views show the same bead cluster through chicken tissue; local average brightens and separates several bead-like peaks relative to global. Rough embedded-panel check: local edge sharpness about `+8.6%` vs global. | Local also increases bright support by about `+41.8%` in the rough panel check, which may mean stronger halo/background rather than compactness. Validation panel contains sparse point references but should not be overread without registration/protocol metadata. | Candidate sparse chicken local-refinement example, especially with crops and a support/line-profile metric. |
| `2_7_26\ppt\beads_2um_sparse2_chicken_48kus` | Strongest visual local improvement among sparse scenes; local average produces a clearer multi-bead pattern than global. Rough embedded-panel check: local edge sharpness about `+17.1%` vs global. | Bright support also increases about `+28.5%`; this may reflect recovered dim signal or extra halo. Need real output metrics and validation alignment before claiming better fidelity. | High-priority candidate for the local-stage claim. Pair with global/local crop and validation/ThorCam as downstream context. |
| `12_7_26\ppt\beads_2um_sparse1_chicken_47kus` | Has the full comparison set: LF views, ThorCam, global, local, validation. The scene includes bright bead structure and broad faint bead distribution. | Local is not visibly better than global. Rough embedded-panel check shows local edge sharpness about `-3.4%` and bright support about `-10.1%` vs global. Validation/ThorCam show fewer dominant structures than LF output, so comparison may be difficult. | Use as a limitation or appendix example: local refinement can be conservative or neutral, and parameter choice matters. |
| `13_7_26\ppt\beads_2um_dense_chicken_24kus` | Dense scene is readable across LF views; global/local outputs preserve a dense bead constellation; validation panel provides downstream external-camera context. Rough embedded-panel check shows local edge sharpness about `+3.6%` and bright support about `-7.9%`. | Improvement is modest rather than dramatic. The aggregate deck repeats the same source as two blocks, so avoid treating slides 26-31 and 32-37 as independent evidence. | High-priority dense chicken flagship candidate if the final figure needs a representative dense result under chicken tissue. |
| `15_7_26\ppt\beads_2um_dense1_chicken_47kus` | Readable dense scene with several bead groups; local looks slightly cleaner while preserving global scene geometry. Rough embedded-panel check shows local edge sharpness about `+3.8%` and support about `-4.3%`. | Local improvement is subtle; it may need crops or metrics to be persuasive. | Secondary dense candidate or robustness example if July 15 acquisition is important. |
| `15_7_26\ppt\beads_2um_dense2_chicken_38kus` | Local output appears somewhat more compact in support than global, and the scene has a clear bead arrangement. Rough embedded-panel check shows support about `-10.9%` vs global. | Rough sharpness decreases about `-1.6%`; local may be suppressing support without improving bead definition. | Possible compactness/support discussion only after line-profile and same-resolution validation checks. |
| `15_7_26\ppt\beads_2um_dense3_chicken_24kus` | Shows a difficult dense/elongated field where the method does not visibly alter the output. | Rough embedded-panel check is effectively unchanged between global and local. This does not support the local-stage claim. | Limitation/control example: some scenes are dominated by global alignment or by residual blur that this local setting does not fix. |

## Claim Aggregation

### Core Chicken-Breast Claim

The deck supports the broad claim that FLFM plus rectification can recover
recognizable 2D fluorescent bead patterns through chicken-breast media. The
strongest support comes from `2_7_26` sparse/sparse2 and `13_7_26` dense, where
the LF averages show structured bead constellations rather than uninformative
blur.

Keep the wording bounded: these are bead-scene recoveries under tested
conditions, not general tissue imaging, volumetric reconstruction, or scattering
inversion.

### Local-Stage Claim

Use `2_7_26\ppt\beads_2um_sparse2_chicken_48kus` as the leading local-stage
candidate. It has the clearest global-to-local visual improvement. Use
`2_7_26\ppt\beads_2um_sparse_chicken_24kus` as a second sparse example if crops
confirm that the extra bright support is useful signal rather than halo.

Use `13_7_26\ppt\beads_2um_dense_chicken_24kus` as the dense counterpart, but
write it as a modest improvement/compaction case rather than a dramatic
disentanglement case.

Do not use `15_7_26\ppt\beads_2um_dense3_chicken_24kus` to support the
local-stage claim; it is a useful no-change example.

### Validation And ThorCam Comparison

The PPT includes ThorCam and validation panels for every scene, but the current
deck does not document registration state, same-resolution protocol, crop, scale,
or score components. Treat these panels as downstream comparison context only.
Do not claim that validation/ThorCam guided the blind rectifier from this deck
alone.

Before using any validation comparison in the thesis, inspect the corresponding
`validate_rectification` folder if present, especially `validation_workspace.npz`
and saved overlay/difference images. The `15_7_26` folder did not show a
top-level `validate_rectification` folder in the quick scan, so validation
provenance for those deck panels needs extra checking.

### Close-Bead / Support Claim

The sparse `2_7_26` scenes are the most promising for a close-bead or support
discussion, but they need crops, line profiles, and a compactness/separation
metric. The rough embedded-panel checks are not enough: local increases bright
support in both sparse scenes, which can be good signal recovery or unwanted
halo depending on the selected crop and reference.

## Reconciliation Checklist

- For shortlist candidates, trace the selected PPT image back to the exact
  `algo_run` candidate, not only the date-level `ppt` image export.
- Recover or record the selected run's `config.json`, `metric_record.json`,
  sweep spec, leaderboard row, and generation identity where available.
- For `2_7_26` candidates, confirm whether the scene should be paired with the
  date folder's validation/ThorCam inputs or a saved validation workspace outside
  the quick scan.
- For `13_7_26`, remove the duplicate block from any final shortlist accounting.
- For `15_7_26`, verify validation provenance before using the validation panels
  as evidence, because the quick folder scan found `main`, `thorcam`,
  `validation`, and `algo_run`, but not `validate_rectification`.
- Build thesis figures from original output files or run artifacts, not from
  screenshots or PowerPoint-rendered panels.
- Add compactness/separation crops for any scene used to support the
  close-bead/support claim.
