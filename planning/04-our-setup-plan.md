# Chapter 4 plan: Our setup

> **Status:** active — approved outline
>
> **Reviewed:** 2026-11-12 (design-values table added)
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
| S1 Instrument and light paths | One illumination path (488 nm laser, $40\times$ objective) and the main FLFM collection path: objective, relay ($250\to750$ mm) to the $10\times10$, 3 mm pitch, $f=55$ mm microlens array, relay ($400\to150$ mm) to the main camera. Objective data (N40X-PF: $f=5$ mm, NA 0.75, 7.5 mm pupil). One sentence each for the flip-mirror ThorCam branch and the opposite-side validation path. Keep the explicit missing items (lens part numbers, separations, filters, excitation coupling) short. Add one sentence pointing to the design-values table (see [below](#design-values-table-added-2026-11-12)); the table carries the numbers for the Chapter 3 design relations. | 0.4 | "Optical configuration" |
| S2 Camera roles | Main FLFM camera supplies reconstruction data; ThorCam supplies a conventional image for comparison (captured at a different time because of the flip mirror); Validation Camera gives an opposite-side view. Name the camera models. | 0.15 | "Optical configuration" |
| S3 Sample | The June 3, 2026 eyedrop bead specimen (2 µm fluorescent beads, dried, covered with Systane gel), with the unrecorded quantities named in one sentence. | 0.15 | "Samples, acquisitions, and view extraction" ¶1 |
| S4 Acquisition and view extraction | The capture label, cut into an $N\times N$ grid of views $V_{ij}(y,x)$ (notation from Chapter 3, one-based indices); what fixes the grid for a run, in one sentence. Fix the current zero-based index statement to match Chapters 3 and 5. | 0.15 | same section ¶2–3 |
| S5 Evaluation summary | One paragraph: the primary comparison is within one run (intermediate global-stage average versus final rectified image, same region, boundaries excluded); external-camera comparisons need registration and carry sample-change caveats. Point to the appendix for the protocol. | 0.15 | "Evaluation protocol" |
| **Total** | | **about 1** | |

## Design-values table (added 2026-11-12)

**Why.** The design relations (per-view resolution, axial resolution, FLFM depth
of field, pixel sampling and Nyquist, and fitting the views on the sensor
without overlap) are explained in [Chapter 3, B4](03-light-field-model-plan.md#b4-content-design-relations-added-2026-11-12),
with derivations in Appendix B. Chapter 4 gives the local instrument's numbers
and does not re-explain the principle. One table carries them, so the chapter
stays at about 1 page of prose (tables are excluded from the count, and the
author chose this route on 2026-11-12).

**Table: "Design values and derived quantities".** Label every derived row
"design value, not a measurement". Rows, with the relation each uses:

| Quantity | Relation (Chapter 3) | Value from design inputs |
| --- | --- | --- |
| Pupil at the array, $D'_{\mathrm{pupil}}$ | $7.5\,\mathrm{mm}\times(750/250)$ | $22.5\,\mathrm{mm}$ |
| Pupil-to-pitch ratio $\rho$ | $D'_{\mathrm{pupil}}/d$ | $7.5$ |
| Per-view NA | $\mathrm{NA}/\rho$ | $\approx 0.1$ |
| Per-view lateral resolution | $\rho\lambda/(2\mathrm{NA})$ | $5\lambda$; [MISSING: emission band, hence $\lambda$] |
| Total magnification $M_T$ | $(f_{\mathrm{MLA}}/f_{\mathrm{obj}})\cdot(1/3)\cdot(150/400)$ | $1.375$ |
| Object-space pixel | $P/M_T$ | [MISSING: pixel pitch $P$ of the BFS-PGE-244S8M] |
| Sampling rate $S_r$ and Nyquist verdict | $(\lambda/2\mathrm{NA}_{\mathrm{ML}})/P$ | [MISSING: $P$, $\lambda$] |
| Per-view footprint on the sensor | $d\times(150/400)$ | $1.125\,\mathrm{mm}$ |
| Maximum no-overlap field of view | $d\,f_{\mathrm{obj}}\,r/f_{\mathrm{MLA}}$, $r=3$ | $0.82\,\mathrm{mm}$ |
| Pupil span on the sensor | $22.5\,\mathrm{mm}\times 0.375$ | $8.44\,\mathrm{mm}$; compare with [MISSING: sensor size] |
| Axial resolution $R_z$ | $R_{xy}^{\mathrm{view}}/\tan\theta_{\max}$ | [MISSING: $\theta_{\max}$ from the outermost lenslet that is retained; depends on $\lambda$ and the retained-view set] |
| FLFM depth of field | smaller of the diffraction and cross-talk limits (Guo App. E) | [MISSING: $\lambda$, $P$] |

Arithmetic recomputed on 2026-11-12 from the design focal lengths in
[the physical-system account](../research-context/physical-system-composition.md);
the focal lengths are script values, so the same caveat applies: these are
design values, and the lens spacings and sensor positions are unmeasured.

**Inputs the table needs and the repo does not yet record.** Each becomes a
row in `open-questions.md` (added 2026-11-12):

- Pixel pitch and sensor size of the main camera (Blackfly S BFS-PGE-244S8M):
  from the manufacturer data sheet; cite it as the source and do not read it
  from memory.
- Emission band and detection filters, for $\lambda$ (an existing open item).
- Whether a field stop or iris sits at the intermediate image (between the two
  relay lenses before the array), which would enforce the no-overlap condition.
  If none, the chapter must say that the field is limited by the specimen and
  illumination footprint and the no-overlap check is only a design condition.
- Retained-view set (which lenslets are used), for $\theta_{\max}$.
- The objective's field number, for an upper bound on the usable field of view.

If the table shows that the local design does not satisfy a condition (for
example, undersampled views or a field larger than the no-overlap limit), say
so in the chapter and flag it for Chapter 7; do not adjust a value to fit.

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
and correspondence for the June 3 files; extraction geometry; evaluation metric;
and, for the design-values table, the main camera's pixel pitch and sensor size,
the emission band, any field stop or iris at the intermediate image, the retained
view set, and the objective's field number.
See `open-questions.md` and the claim tracker.
