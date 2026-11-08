# Thesis Narrative Map

> **Status:** candidate
>
> **Reviewed:** 2026-11-08

Observation date: 2026-07-16

Source database:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output`

This file is the broad writing spine for converting the experiment database into
thesis material. It is intentionally not a final result selection. The goal is
to keep the thesis narrative in control, while preserving paths back to possible
evidence.

Current chapter destinations follow the [authoritative structure and space
budget](../planning/revised-thesis-structure.md). Chapter 4 owns the minimal
acquisition/evaluation summary; detailed records belong in appendices/provenance.
Existing manuscript detail remains intact pending later content migration.

## Current Thesis Driver

Keep the thesis compact and proof-driven:

1. Explain the system and data well enough that the experiments are reproducible.
2. Explain the FLFM view-grid model and the rectification method.
3. Use a small number of result blocks to support the central claims.
4. Push extra sweeps, maps, and implementation details into appendices.

The current working thesis claim should stay no broader than the evidence:

> FLFM plus rectification recovers useful 2D fluorescent bead scenes under the
> tested aberrating/scattering media, with the local stage assessed against the
> intermediate global-stage average from the same run and with ThorCam and
> Validation Camera comparisons used as downstream evaluation.

Use `planning/revised-thesis-structure.md` for chapter placement. Here,
"global" and "local" outputs mean the intermediate and final averages of one
global-then-local run, pending confirmation of run identity for each candidate.

## Chapter-to-Evidence Map

| Thesis area | Job in thesis | Database evidence to collect broadly | Candidate source buckets |
| --- | --- | --- | --- |
| Chapter 4: Our setup | Identify the instrument and summarize the protocol; keep detailed reproducibility records in appendices/provenance. | `main`, `thorcam`, `validation`/`val`, calibration files, dark/gain artifacts, component notes, acquisition settings encoded in filenames. | Date folders with all three paths present: `10_6_26`, `12_7_26`, `13_7_26`, `15_7_26`, `21_6_26`, `24_6_26`, `25_5_26`, `29_5_26`, `3_6_26`, `7_7_26`, `9_7_26`. |
| Chapters 3 and 5: Model and Rectification Method | Connect the FLFM view-grid approximation to the two-stage algorithm. | Method notes, configs, sweep specs, `metric_record.json`, `run_state.json`, stage summaries, source-code map. | Existing `method-notes/rectification-pipeline/*`, plus modern sweep roots with `sweep_spec.json` and `experiment_manifest.json`. |
| Results (current Chapter 6) | Prove the central claims with comparable blocks. | Intermediate global-stage average, final rectified image, their difference/overlay, displacement maps, validation/ThorCam overlays, ranking tables. | Broad eyedrop, chicken, and validation buckets in `datasets-and-runs-broad.md`. |
| Discussion and Conclusions (current Chapter 7) | Interpret evidence and state limits. | Within-run stage-output comparisons, validation diagnostics, failed/weak cases, metric caveats, result variability across datasets. | Sweep summaries, validation workspaces, aggregate PPTs, and appendix sweep inventory. |
| Appendices | Preserve complete evidence without cluttering the main text. | Full parameter sweeps, extra displacement maps, visual reports, calibration notes, raw dataset inventory, implementation digests. | `database-inventory-notes.md`, `appendix` candidates in `datasets-and-runs-broad.md`, existing provenance templates. |

## Claim Ledger

| Claim family | Broad thesis wording | Evidence needed | Candidate evidence pools | Notes and risk |
| --- | --- | --- | --- | --- |
| Core claim | FLFM plus rectification recovers useful 2D fluorescent bead scenes under tested media. | One eyedrop block, one chicken-breast block, and a clear method boundary. | Eyedrop candidates from May-June 2026; chicken candidates from June-July 2026; validation overlays from July 2026. | Do not overclaim beyond beads and tested media. |
| Local-stage claim | Pixelwise refinement adds value after global alignment in selected scenes. | Paired intermediate and final outputs from the same run, local displacement maps, compactness/separation or validation metric support. | Per-run `figures/averages`, `figures/global_maps`, `figures/pixel_maps`, `metric_record.json`. | Verify common run identity and select examples where changes are visible and not just metric noise. |
| ThorCam comparison | Local LF output can be compared with ThorCam under a defined same-resolution protocol. | Registered ThorCam panels, same-resolution preprocessing, metric table, caveat wording. | `validate_rectification` folders; `validation_workspace.npz`; March and July validation comparisons. | Needs a stable protocol before making performance claims. |
| Validation comparison | Local LF output resembles the validation reference under saved registration workflow. | Validation workspace provenance, overlays/differences, score components, registration diagnostics. | `7_7_26`, `9_7_26`, `12_7_26`, `13_7_26` validation folders. | Treat as downstream evaluation, not training or blind optimization input. |
| Close-bead/support claim | Local rectification can improve bead support compactness or close-bead separability in selected scenes. | Crops, line profiles, compactness/separation metric, before/after panels. | Sparse eyedrop and sparse chicken candidates; July validation folders. | Must respect optical/diffraction limits and avoid visual-only proof. |
| Method boundary | The current method is two-stage rectification and warp-and-average, not learned reconstruction or full scattering inversion. | Chapter 5 wording, implementation digest, artifact contract. | `method-notes/rectification-pipeline/*`, configs, workspaces. | Keep this explicit in methods and discussion. |

## Result Block Template

Use this template for each possible flagship result. At this stage, fill it
broadly and leave final figure choices open.

1. **Condition:** sample type, medium, acquisition date, exposure or power hint,
   run family, preprocessing.
2. **Inputs:** representative raw FLFM image or extracted view grid; optional
   ThorCam and Validation Camera inputs.
3. **Outputs:** intermediate global-stage average, final rectified image after
   local refinement, and their within-run visual difference.
4. **Displacement evidence:** global translation maps and local displacement or
   magnitude maps only when they explain the change.
5. **Baselines:** registered ThorCam and Validation Camera comparisons, with the
   preprocessing and transform provenance recorded.
6. **Quantification:** 2-4 primary metrics, likely from compactness/separation,
   validation similarity, and sweep ranking.
7. **Takeaway:** one paragraph linking the evidence to exactly one claim.

## Broad Selection Rules

- Prefer result families that include `main`, `thorcam`, `validation`, and
  `algo_run`.
- Prefer modern sweep roots with `experiment_manifest.json`, `sweep_spec.json`,
  `metric_record.json`, and `run_state.json`.
- Prefer validation examples with `validation_workspace.npz` and saved overlay
  or difference images.
- Keep early exploratory sweeps for method history and appendices unless they
  directly support a main claim.
- Do not copy images into thesis folders until the final result set is chosen.
