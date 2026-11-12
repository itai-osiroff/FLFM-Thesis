# System photographs

> **Status:** reference
>
> **Reviewed:** 2026-11-12

Real-world photographs of the optical bench. They are stored as evidence of
what the physical system looks like. **None of them is used in the thesis
yet.** Nothing here is in `overleaf/`, and no photo has a figure slot, caption,
or provenance record.

## What these are

- Ten JPEG photos, about 2.3 MB in total, committed as received.
- Source: the author's archive `system images.zip` (from `Downloads`), received
  through WhatsApp. WhatsApp recompressed them (1600x1200 or 1200x1600) and the
  files carry no useful EXIF, so the capture date is not recorded in the files.
- The original file names contain `2026-10-29 at 15.09.41` to `15.09.43`. That
  is the WhatsApp send time. The author confirmed on 2026-11-12 that the
  capture date implied by it (2026-10-29) is accurate.
- Author statement, 2026-11-12: this bench state is the state of the system
  when the results presented in the thesis were captured. This is an
  author-attested record, not run-specific provenance. Individual results still
  need their own run, acquisition-date, and settings records.
- Photographer is not recorded.

## Index

"Original name" is the WhatsApp file name inside the zip.

| File | View | Original name |
| --- | --- | --- |
| `system-01-top-down-overview.jpg` | Top-down view of the whole bench: raised breadboard in the middle, lower-level optics, laser head and red-bodied camera at left. | `...15.09.42 (3).jpeg` |
| `system-02-oblique-overview-laser-side.jpg` | Oblique overview from the laser side: laser head with a CAUTION label, rail-mounted cage assembly with green-taped light shielding and a red camera, raised breadboard behind. | `...15.09.42 (2).jpeg` |
| `system-03-side-overview-laser-side.jpg` | Low side overview from the laser side: laser head with beam-block panels, lens tube on a post, raised breadboard and the black curtain behind. | `...15.09.43.jpeg` |
| `system-04-portrait-overview-raised-board.jpg` | Portrait overview of the raised breadboard and the lower-level cage-rail path beneath and beside it. | `...15.09.42 (1).jpeg` |
| `system-05-lower-level-rails-side-view.jpg` | Side view of the lower-level cage-rail and cube-mount assemblies, with a green-taped camera tube at right and the raised board at left. | `...15.09.42.jpeg` |
| `system-06-raised-board-optics-from-stage-side.jpg` | Raised-breadboard optics seen from the stage side: mirrors, lens and filter mounts, with the sample stage and Z912B actuator in the foreground. | `...15.09.41 (2).jpeg` |
| `system-07-raised-board-optics-closeup.jpg` | Close-up oblique view of the raised-breadboard optics: dichroic or filter mount (blue/yellow reflection), labelled lens mount, flat optic on a kinematic mount. | `...15.09.43 (2).jpeg` |
| `system-08-sample-stage-and-motor-controllers.jpg` | Sample region: stacked Thorlabs translation stage with Z912B actuators, upper `Plan Fluor 40x/0.75` objective, and four Thorlabs K-Cube brushed motor controllers at right. | `...15.09.41.jpeg` |
| `system-09-objective-pair-side-view.jpg` | Side view of the objective pair facing each other across the sample holder; the upper objective is marked Nikon `Plan Fluor 40x/0.75`, infinity/0.17. The lower objective's markings are not legible. | `...15.09.41 (1).jpeg` |
| `system-10-objectives-and-validation-camera-low-angle.jpg` | Low-angle view under the raised board: objective pair, a camera labelled FLIR with a lens tube, and the laser head in the background. | `...15.09.43 (1).jpeg` |

## Limits on what these photos show

- They are overview and context photos. They do not by themselves establish the
  as-built layout, lens focal lengths, spacings, filters, the microlens array
  model, or the laser wavelength. Component identities above are only what is
  legible in the images.
- They show one bench state on one day (2026-10-29), which the author attests
  matches the thesis results. They are not linked to any specific dataset or
  run in the repo, so a caption may say "the system as used for the results"
  on the author's authority, but a claim about one particular run's settings
  still needs that run's provenance record.
- Handwritten lab notes are visible on the bench in several photos (for example
  `system-01`, `system-04`). Crop them out before any thesis use.
- Compare with the [physical system composition](../../physical-system-composition.md)
  account (two `40x` objectives, Amus microlens array, ThorCam, FLIR Blackfly S
  validation camera) before using a photo to support a Chapter 4 statement. That
  account's open questions about the as-built layout are not closed by these
  photos. The photos are consistent with it at the level of "two `40x`
  objectives and a FLIR camera are present", nothing more.

## Before any thesis use

1. Pick the photo, then crop or annotate. Put the edited figure in
   `candidate-outputs/` first, and the unedited original stays here.
2. Record origin and processing in `research-context/result-provenance/`.
3. Check that no person is recognizable and no lab notes or screens are legible.
4. Only then place it in `overleaf/figures/ch04/` (the Chapter 4 page budget is
   already over; see `planning/revised-thesis-structure.md`).
