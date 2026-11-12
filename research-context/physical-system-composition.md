# Physical system composition: working source-based account

> **Status:** working description, not an as-built parts list
> **Reviewed:** 2026-11-12
> **Intended use:** evidence and questions for the Chapter 4 system summary and detailed supporting records and a later system schematic

Current editorial placement follows the [authoritative structure and budget](../planning/revised-thesis-structure.md).
Only placement pointers are updated here; source observations, values, and author
clarifications retain their original scope.

## Scope and evidence

This note combines the author's clarifications of 2026-09-27, a partial
hardware slide deck, and three one-dimensional, paraxial ray-tracing scripts.
The deck identifies some actual hardware, while the scripts supply the modeled
path order and lens values. The author's clarifications identify which major
branches are installed. Exact component positions and configurations for
particular acquisitions are not yet documented. Those clarifications take
precedence over legacy alternatives in the scripts:

- The main light-field path uses the **Amus Optics microlens array**.
- A **flip-mounted mirror** selects the main light-field path or the ThorCam
  bright-field path. These two captures are **not simultaneous**.
- The modeled `f2`/`f3` pupil-imaging relay and `f5`/`f6` relay after the
  microlens array are **physically installed**. Only the optional `f7`/`f8`
  extra relay is absent.
- The same `40×` objective focuses illumination onto the sample and collects
  light for the main and ThorCam paths. A second `40×` objective on the
  opposite side of the sample serves the validation path.
- A pair of coverslips physically contains the thin sample.

The source files were inspected on 2026-09-27 at:

`G:/Other computers/My PC/Technion/Msc/project/optical system design/`

| Source | Role | Last modified (UTC) | SHA-256 |
| --- | --- | --- | --- |
| `testLFdesign.m` | Main light-field path | 2026-05-12 14:27:51 | `43A8375BFE5326C8A63D2A5D10197A8C8DEC3DA318558AA8DB7CC2EDC303B6F8` |
| `testLFdesign_thorcam.m` | ThorCam alternative path | 2025-12-03 14:50:21 | `8BAA0C1C6F83F1B57D9FA0FB068ABDF842649D391F9398D321C2375C02C00C70` |
| `testLFdesign_illumination_validation.m` | Illumination and validation path | 2026-05-06 07:27:54 | `9BD7DCFA73A08E5E0FD885C117B3B65ABEA795C8BC511198AF45328AECA14023` |

The partial deck, `C:/Users/admin2/Downloads/System Components and makeup.pptx`,
was inspected on 2026-09-27. Its last modified time is 2026-07-16 11:25:38 UTC;
SHA-256 is
`0420D5E00676FAC588372A213DB28399684709EA73AF2F495D35CEFB45B5CC01`.
References to deck slides below are one-based. Slide 7 is blank. The embedded
microlens drawing on slide 6 is part of the deck; its source document and
revision are not identified there.

Script line references below refer to the exact file versions listed above.
They identify model evidence, not independent measurements of the assembled
instrument. Deck entries are reported hardware information, not independent
inspection of installed parts or run-specific settings.

## Working physical path map

1. **Main light-field capture:** sample light returns through the same `40×`
   objective that focuses illumination. Installed lenses `f2`/`f3` image the
   objective's Fourier/pupil plane onto the Amus microlens array. Installed
   lenses `f5`/`f6` carry the lenslet output to the main Teledyne-FLIR Blackfly
   S `BFS-PGE-244S8M` camera (`testLFdesign.m`, lines 20–27, 224–330; deck
   slide 2; author clarification).
2. **ThorCam bright-field capture:** a flip-mounted mirror before the
   microlens array diverts light through a regular focusing lens instead of
   the array, then to the Thorlabs `CS2100M-USB` ThorCam. The objective and
   `f2`/`f3` optics before the array are shared with the main path. The two
   paths have separate optics after the branch and are captured sequentially.
   The ThorCam script models the final lens as `f4 = 300 mm`
   (`testLFdesign_thorcam.m`, lines 145–154, 215–297; deck slide 2; author
   clarification). The scripts omit the mirror itself, so its precise
   mechanical position is not recorded.
3. **Illumination and validation:** the third script sends a collimated laser
   beam through an expanding lens and the first `40×` objective to a thin
   sample between two coverslips. Light continuing through the sample reaches
   the opposite `40×` objective, then a focusing lens and the Teledyne-FLIR
   Blackfly S `BFS-U3-122S6M` validation camera. The script's lower-objective
   `20×` comment is superseded by the author's description of the installed
   second `40×` objective (`testLFdesign_illumination_validation.m`, lines
   3–6, 85–210; deck slide 2). How illumination joins the main collection
   path, the filters, and the validation contrast mechanism remain open.

In compact form, the working layout is:

```text
laser → expanding lens → [illumination coupling unresolved]
      → shared 40× objective → coverslip / thin sample / coverslip

sample → shared 40× objective → f2/f3 relay → flip-mirror branch
      → Amus array (curved input side; flat output side) → f5/f6 relay → main camera
                                        ↘ regular focusing lens → ThorCam

sample → opposite 40× objective → focusing lens → validation camera
```

The main and ThorCam branches are alternatives, not simultaneous exposures.
The sketch names the shared optics and branch order; it does not set distances
or locate filters and beam-combining optics.

## Hardware identified in the partial deck

| Component or property | Deck account | What it establishes and what remains open |
| --- | --- | --- |
| Main FLFM camera | Teledyne-FLIR Blackfly S `BFS-PGE-244S8M` (slide 2) | Identifies the reported main camera model; sensor position, settings, and use in each dataset remain to be checked. |
| Validation camera | Teledyne-FLIR Blackfly S `BFS-U3-122S6M` (slide 2) | Identifies the reported validation camera model; its contrast mechanism and acquisition timing remain open. |
| ThorCam | Thorlabs `CS2100M-USB`, labeled “traditional microscope” (slide 2) | Identifies the reported camera model for the alternative bright-field path. |
| Laser | Coherent `SAPPHIRE 488-200 CDRH`; `488 nm`; “most used power setting” `20 mW` (slide 3) | Identifies the reported source and common setting. The deck does not give power at the sample or a value for any particular acquisition. |
| Objective listed in deck | `N40X-PF`, `40×`, `f = 5 mm`, `NA = 0.75`, working distance `0.66 mm`, entry pupil `7.5 mm` (slide 4) | Matches the `5 mm` focal length and `7.5 mm` pupil diameter used by the main script. The author confirms two installed `40×` objectives, one for illumination/main/ThorCam and one for validation; the deck does not say whether both have this exact model and NA. |
| Other optics | Slide 4 says “regular double convex lenses – all SM2” and “silver coated mirrors”; its manufacturer field reads “Thorcam” | Reports lens and mirror types, but does not list lens part numbers, focal lengths, mounts, coatings beyond the mirrors, or the flip mirror's position. The manufacturer wording may be a typo; preserve it as written until checked. |
| Microlens array | Advanced Microoptics Systems GmbH (Amus), `APO-Q-P3000-R23.5`; slide 5 describes a `10 × 10` square fused-silica array of `3 mm × 3 mm` microlenses, curvature radius `23.5 mm`, and a `1 mm` thick substrate flat on one side | Identifies the installed array and resolves the lenslet count that the one-dimensional script could not establish. The author confirms the script's `55 mm` focal length as the working physical value and says the flat side faces away from the incoming collimated light. |

The drawing embedded on slide 6 labels a `30 ± 0.05` square outline,
`P = 3.0 ± 0.001` pitch, `1 ± 0.05` thickness, and `R23.5` curvature.
The deck's text gives millimetres for the corresponding nominal dimensions;
the drawing itself does not state its units. Its “controlling grid 29×29” label
is a drawing annotation, not evidence of a 29×29 microlens count. The deck does
not show a complete optical layout or a component placement diagram.

## Components and script-derived design values

The author confirms which relay groups are installed and the `55 mm` microlens
focal length. The scripts provide the lens focal lengths below in millimetres.
These are working design values; part numbers, measured spacings, and the
configuration of each dataset still need separate records.

| Path | Element in script order | Nominal value or role | Evidence and limit |
| --- | --- | --- | --- |
| Main | Shared illumination/collection objective `f1` | `40×`; script `f = 5 mm`, aperture radius `3.75 mm` | `testLFdesign.m`, lines 56–57, 220–238; author confirms its dual role. The deck's `N40X-PF` values agree, but model assignment to this exact objective remains open. |
| Main and ThorCam, shared | Installed lenses `f2`, `f3` | Script `250 mm`, `750 mm`; model relays objective Fourier/pupil plane toward array | `testLFdesign.m`, lines 20–23, 144–155, 277–293; `testLFdesign_thorcam.m`, lines 145–154, 272–286; author confirms this pair is physically installed. |
| Main | Amus microlens array `f4` | `f = 55 mm`; `3 mm` pitch; `10 × 10` array | Script lines 87–97, 144–150, 288–308; deck slides 5–6; author confirms focal length and flat side facing away from the incoming collimated light. Its placement at the relayed objective Fourier/pupil plane is the script's design. |
| Main, after array | Installed lenses `f5`, `f6` | Script `400 mm`, `150 mm` before main camera | `testLFdesign.m`, lines 145–155, 310–332; author confirms this pair is physically installed and exclusive to the main branch. |
| ThorCam, after mirror | Regular focusing lens, called `f4` in its script | Script `300 mm` before ThorCam | `testLFdesign_thorcam.m`, lines 145–154, 283–297; author identifies this as the alternative to the microlens array. Its part number and spacing remain unrecorded. |
| Illumination | Collimated beam, expanding lens `f1`, shared-side objective `f2` | Script `250 mm`, `5 mm`; objective physically `40×` | `testLFdesign_illumination_validation.m`, lines 3–6, 45–65, 85–151; author confirms the first `40×` objective also collects main and ThorCam light. |
| Validation | Opposite-side objective `f3`, focusing lens `f4`, validation sensor | Script `5 mm`, `100 mm`; objective physically `40×` | Lines 3–6, 57–66, 153–210; author corrects the script's legacy `20×` comment. Exact objective model/NA and focusing-lens part number remain open. |

The third script can optionally model objective NA limits of `0.75` and `0.5`.
Its coverslip branch propagates through a `0.15 mm`, index `1.52` glass segment
before the sample and another after it
(`testLFdesign_illumination_validation.m`, lines 23–43, 124–180). The author
confirms that the *physical* sample is held between two coverslips and reports
that adding their effects to the simple simulation did not materially change
its conclusions. The actual coverslip thicknesses and refractive indices have
not been confirmed, and no quantitative sensitivity result has been supplied.
The modeled `0.5` NA also should not be assigned to the second physical `40×`
objective without its specification.

## Legacy or modeling details to exclude from a physical inventory

- The main and ThorCam scripts allow an *additional* `f7`/`f8` relay between
  the objective and `f2`; the author confirms this pair is absent. Keep the
  installed `f2`/`f3` and `f5`/`f6` groups in the layout
  (`testLFdesign.m`, lines 159–172, 245–275;
  `testLFdesign_thorcam.m`, lines 157–170, 240–270).
- The main script offers Thorlabs, Edmund, and Amus array parameter branches.
  The first two are alternatives explored in the model, not the current array
  (`testLFdesign.m`, lines 38–47, 87–97, 124–156).
- The ThorCam script retains the same array-choice prompt and array parameters,
  but its traced ThorCam path never encounters a lenslet (`testLFdesign_thorcam.m`,
  lines 38–48, 88–99, 283–297). These settings should not be read as a
  ThorCam microlens array.
- The illumination/validation script comments that its lower objective is
  `20×` and optionally models `NA = 0.5`; the author confirms an installed
  `40×` objective on that side. Treat the comment and NA setting as model
  alternatives pending the objective's actual specification.
- Plot aperture markers, angular sampling, field-of-view ranges, focus offsets,
  and optional coverslip/NA switches are simulation controls. They are not
  measured performance or a definitive mechanical layout. The scripts trace
  one transverse dimension. The deck supplies the `10 × 10` physical array
  description; the script's `k = 10` setting alone would not have established
  that layout or the usable view count in an acquisition.

## Working descriptive paragraph for later Chapter 4 drafting

The system uses a `40×` objective to focus illumination onto a thin sample
held between two coverslips and to collect light for either main Fourier
light-field or ThorCam capture. The collection paths share this objective and
the `f2`/`f3` relay. A flip-mounted mirror before the microlens array selects
the ThorCam branch, where a regular lens focuses onto the Thorlabs camera.
With the mirror set for light-field capture, light instead reaches the
Advanced Microoptics Systems GmbH `10 × 10` array, then the installed
`f5`/`f6` relay and a Teledyne-FLIR Blackfly S main camera. The two modes are
captured sequentially. Across the sample, a second `40×` objective directs
light through a focusing lens to the Teledyne-FLIR validation camera. The
reported illumination source is a Coherent `488 nm` laser. The optical
coupling of illumination to the shared objective, filtering, camera contrast,
and acquisition-specific settings remain to be documented.

This paragraph is a working description, not yet thesis-ready evidence for
specific optical performance or as-built dimensions.

## Questions to resolve from the physical setup

1. How is the reported `488 nm` laser beam coupled to the shared `40×`
   objective, conditioned, and filtered, and what
   power reaches the sample in each acquisition? Does the validation camera
   record transmitted illumination, fluorescence, or another contrast path?
2. Are both installed `40×` objectives the deck's `N40X-PF` model? What is the
   second objective's actual NA and working distance?
3. What are the exact lens part numbers, mechanical spacings, and camera
   sensor positions? The script supplies a design sequence and focal lengths,
   but no measured assembled layout.
4. For selected acquisitions, which array lenslets produced usable views,
   what calibration identified the pupil/lenslet geometry, and what camera
   settings were used?
5. What are the coverslip thicknesses and sample/medium configuration for
   each selected dataset? The physical pair is established; run-specific
   geometry is not.

Overview photos of the bench now exist in [hardware/photos](hardware/photos/README.md)
(added 2026-11-12; capture date 2026-10-29 and match to the thesis results confirmed by the author). They give context only and do not
yet resolve the layout questions above.

The next source should be a current optical bench photo or annotated layout
showing the illumination coupling and camera paths, followed by
acquisition-specific records. Reconcile those with this account before moving
the description into `overleaf/`.
