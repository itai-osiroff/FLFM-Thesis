# Eyedrop Result Aggregation Curation Index

> **Status:** candidate
>
> **Reviewed:** 2026-09-24

Observation date: 2026-07-16

Source PDF:
`C:\Users\admin2\Downloads\Results Aggregation - eyedrops.pdf`

Source database:
`C:\Users\admin2\OneDrive - Technion\office computer files\images_output`

This file captures the human-curated eyedrop result shortlist from the PDF.
It is a curation layer only: the PDF and PPTs are interpretation and discovery
material, not final computational provenance. Before any scene becomes a thesis
figure or quantitative claim, trace it to the source dataset, `algo_run` folder,
run metadata, and selected output artifact.

## Linked Presentation Evidence

| Scope | Path | Status |
| --- | --- | --- |
| Root eyedrop aggregate | `C:\Users\admin2\OneDrive - Technion\office computer files\images_output\Results Aggregate - Eyedrop.pptx` | Exists; use for discovery and interpretation only. |
| June 3 date presentation | `C:\Users\admin2\OneDrive - Technion\office computer files\images_output\3_6_26\ppt\ppt.pptx` | Exists; date folder also has `main`, `thorcam`, `validation`, and `algo_run`. |
| June 10 date presentation | `C:\Users\admin2\OneDrive - Technion\office computer files\images_output\10_6_26\ppt\ppt.pptx` | Exists; date folder also has `main`, `thorcam`, `validation`, and `algo_run`. |
| Tentative May 17 presentation | `C:\Users\admin2\OneDrive - Technion\office computer files\images_output\17_5_26\ppt\eyedrops with FLIR.pptx` | Exists; tentatively linked to the PDF's `17.6.26` rows, but that mapping is unverified. |

## PDF-Selected Scenes

| PDF date | Tentative source folder | Main camera model | PDF scene name | Source status | PDF significance | PDF limitation / needs improvement | Thesis-use status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `3.6.26` | `3_6_26` | Flir | `beads_2um_dense4_eyedrop_4kus` | Confirmed flat main-camera file: `3_6_26\main\beads_2um_dense4_eyedrop_4kus.tiff`. | Separate closer beads. | Real beads were not reconstructed well; disentanglement was good. | Candidate close-bead/separation example; provenance unresolved. |
| `3.6.26` | `3_6_26` | flir | `beads_2um_dense6_eyedrop_2d1kus` | Confirmed flat main-camera file: `3_6_26\main\beads_2um_dense6_eyedrop_2d1kus.tiff`. | Local made it better. | Real bead was recovered but too faint compared to other beads. | Candidate local-improvement example; provenance unresolved. |
| `10.6.26` | `10_6_26` | flir | `beads_2um_dense_eyedrop_680us` | Confirmed in sweep dataset folder: `10_6_26\algo_run\power_2\datasets\beads_2um_dense_eyedrop_680us`; `10_6_26\main` is organized by dilution/volume subfolders. | Local made it better. | Blue+red - need to make disentanglement better through local. | Candidate main eyedrop result block; provenance unresolved. |
| `17.6.26` | `17_5_26` tentative | flir | `beads_2um_dense6_eyedrop_0d8ms` listed under PDF ThorCam column | No `17_6_26` source folder was found in the top-level source database scan. Tentative `17_5_26` link is unverified and does not currently match a flat dense6 main-camera file. | Local made it better at the edges of the image; PDF notes this can be seen in ThorCam. | None listed. | Do not use as provenance until the correct date/folder is reconciled. |
| `17.6.26` | `17_5_26` tentative | flir | `beads_2um_dense7_eyedrop_680us` | No `17_6_26` source folder was found in the top-level source database scan. Tentative `17_5_26` link is unverified and does not currently match a flat dense7 main-camera file. | Major disentanglement of close-by out-of-focus beads; global-to-local improvement; local made it better at the edges of the image, visible in ThorCam. | None listed. | Do not use as provenance until the correct date/folder is reconciled. |

## Reconciliation Checklist

- Confirm whether the PDF's `17.6.26` rows are a date typo for `17_5_26`, or
  whether a missing `17_6_26` source folder exists outside the scanned database
  root.
- For each selected scene, trace the result to the exact `algo_run` output:
  `sweep_spec.json`, `experiment_manifest.json`, `leaderboard.json`, and
  per-run `metric_record.json` where available.
- Record the selected output artifact path before copying any figure into
  `finalized-outputs/` or `overleaf/`.
- Preserve the PDF/PPT wording as qualitative interpretation; do not convert it
  into quantitative thesis claims without run metadata and figure provenance.

