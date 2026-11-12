# Chapter 4 plan: Our setup

> **Status:** active — approved outline
>
> **Reviewed:** 2026-11-12
>
> **Target:** [04_our_setup.tex](../overleaf/main/04_our_setup.tex)

## Authority and budget

Use the [authoritative structure and space budget](revised-thesis-structure.md).
Chapter 4 has a target of **about 1 page** of prose and equations. The current
draft is about 3 pages; that overflow is migration debt, not an approved budget.
The author approved this outline on 2026-11-12, together with a new appendix for
acquisition and evaluation records (departure table in the structure file).

Content migration is not deletion. Every paragraph leaving Chapter 4 goes to the
new appendix or to linked repository provenance, with no silent cuts. Essential
qualifications stay beside the results they qualify in Chapter 6.

## Chapter question

What instrument recorded the data, what each camera is for, and what minimum
the reader needs to interpret the Chapter 6 results?

Chapter 3 explains the optical principle (aperture, ray separation, pupil
conjugation). Chapter 4 gives the concrete hardware and acquisition facts and
does not re-explain the principle.

## Approved outline (about 1 page)

| Block | Content | Approx. pages | Source in current draft |
| --- | --- | --- | --- |
| S1 Instrument and light paths | One illumination path (488 nm laser, $40\times$ objective) and the main FLFM collection path: objective, relay ($250\to750$ mm) to the $10\times10$, 3 mm pitch, $f=55$ mm microlens array, relay ($400\to150$ mm) to the main camera. Objective data (N40X-PF: $f=5$ mm, NA 0.75, 7.5 mm pupil). One sentence each for the flip-mirror ThorCam branch and the opposite-side validation path. Keep the explicit missing items (lens part numbers, separations, filters, excitation coupling) short. | 0.4 | "Optical configuration" |
| S2 Camera roles | Main FLFM camera supplies reconstruction data; ThorCam supplies a conventional image for comparison (captured at a different time because of the flip mirror); Validation Camera gives an opposite-side view. Name the camera models. | 0.15 | "Optical configuration" |
| S3 Sample | The June 3, 2026 eyedrop bead specimen (2 µm fluorescent beads, dried, covered with Systane gel), with the unrecorded quantities named in one sentence. | 0.15 | "Samples, acquisitions, and view extraction" ¶1 |
| S4 Acquisition and view extraction | The capture label, cut into an $N\times N$ grid of views $V_{ij}(y,x)$ (notation from Chapter 3, one-based indices); what fixes the grid for a run, in one sentence. Fix the current zero-based index statement to match Chapters 3 and 5. | 0.15 | same section ¶2–3 |
| S5 Evaluation summary | One paragraph: the primary comparison is within one run (intermediate global-stage average versus final rectified image, same region, boundaries excluded); external-camera comparisons need registration and carry sample-change caveats. Point to the appendix for the protocol. | 0.15 | "Evaluation protocol" |
| **Total** | | **about 1** | |

An optional bench photograph (from `research-context/hardware/photos/`) may be
added as a figure; figures are excluded from the count, but the photo needs
cropping, staging in `candidate-outputs/`, and a provenance record first.

## Content moving to the new appendix

Working title: *Acquisition and evaluation records*. The appendix letter and file
are created during the Chapter 4 content pass (after the existing Appendices A–C
unless the author orders otherwise).

- The archive table (`tab:acquisition-run-archive`) and its framing paragraphs.
- The "Reconstruction and selection records" section (traceability, sweeps,
  ranking, selection caveats).
- The detailed "Evaluation protocol" text beyond the S5 summary (masking of
  zero-filled boundaries, resampling and registration records, metric
  definitions once chosen).
- Detailed extraction-reproducibility requirements (grid center, pitch,
  orientation, retained-view set, preprocessing state, dark/gain files,
  exposure fusion).

## Open evidence gaps (unchanged by this plan)

Lens part numbers and separations; filters and excitation coupling; Validation
Camera contrast; per-acquisition exposure, gain and laser power; capture timing
and correspondence for the June 3 files; extraction geometry; evaluation metric.
See `open-questions.md` and the claim tracker.
