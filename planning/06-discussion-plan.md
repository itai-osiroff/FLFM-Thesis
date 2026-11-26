# Chapter 6 plan: Discussion and Conclusions

> **Status:** active — section plan approved by the author (2026-11-26); supervisor review on 2026-11-29
>
> **Reviewed:** 2026-11-26
>
> **Target:** [06_discussion_and_conclusions.tex](../overleaf/main/06_discussion_and_conclusions.tex) (still the template placeholder)
>
> **Budget:** about 4 pages of prose (approved 2026-11-12; [authoritative structure](revised-thesis-structure.md)). No departure recorded.

## Job

Chapter 5 reports what the images show. This chapter says what those
observations mean, where the method stands among the Chapter 2 approaches, what
bounds it, and what the thesis has established. It introduces no new evidence:
no new figures, runs or numbers beyond those in Chapters 3–5
([structure](revised-thesis-structure.md), ownership rules). The method's
boundary stays explicit: one global-then-local alignment of 2D views and their
average, not deconvolution, learned reconstruction or scattering inversion.

## Section plan

Yardstick: about 450 words a page, so the 4-page budget is about 1,800 words.

| Section | Content | Sources it draws on | Cap (words) |
| --- | --- | --- | --- |
| Opening | The question: what do the four scenes show about correcting aberrations from the views of one FLFM capture? One sentence on the order of the chapter. | — | 60 |
| 6.1 What the two stages correct | The gel and the tissue as two kinds of aberration. Under the gel, one smooth surface bends the light for the whole field much the same way, so one shift per view (the global stage) does most of the work. In tissue, light from neighboring emitters crosses different structures, so each has its own piecewise-linear fit (fig:aberration-segments) and the local stage brings the clearest changes. That matches the account in Chapter 4: the split between the stages follows how much the aberration varies across the field. Resolution: the result is at $\Delta x_{LF}=N\Delta x_o$; the method removes aberration blur larger than that, and does not recover detail below it. | Ch. 4 aberrations as shifts; Ch. 5 summary; Ch. 3 eq. lateral-lf | 400 |
| 6.2 Relation to prior approaches | Back to the Chapter 2 axes. No PSF to model, measure or estimate (vs. 2.1). No sensor or corrector, and a correction that varies across the field from one capture (vs. 2.2; the local stage plays the role of tiled corrections). One exposure with incoherent emission (vs. 2.3). Nearest work: digital AO in scanning LFM (Wu 2021: 3D, scanning, iterative); zonal sensorless AO from image shifts (Hampson) as the same principle in hardware. What is given up in exchange: lateral resolution by a factor of $N$, and a correction limited to shifts. | Ch. 2 sources only (no new citations unless Ch. 2 adds them) | 400 |
| 6.3 Assumptions and scope | The conditions the results rest on, stated as scope rather than failures: a flat scene; aberrations to first order as shifts (a strong aberration also changes the shape of each view's blur; Chung 2019); scattering is not inverted; corresponding structure visible in enough views, shifts within the search bounds, the central view as reference (Ch. 4); vignetting in the outer views (App. D); bead samples; evaluation by eye on four scenes chosen visually, with parameters chosen per run. | Ch. 4 assumptions sentence; App. D; claim tracker | 450 |
| 6.4 Future work | Bounded next steps, each tied to an assumption in 6.3: quantitative evaluation (line profiles, a metric, ground truth); a model beyond pure shifts for strong aberrations; scenes with depth (combining the correction with FLFM refocusing); biological samples beyond beads; reconstruction at better than $\Delta x_{LF}$ after the correction (for example deconvolution of the rectified image). | 6.3 | 250 |
| 6.5 Conclusions | What the thesis established, one claim per sentence, each traceable to a chapter: the FLFM design account in factors of $N$ (Ch. 3); aberrations as view shifts and the two-stage removal (Ch. 4); recovery of bead scenes under gel and in tissue from a single capture, with local refinement adding most where the aberration varies across the field (Ch. 5). | Claim tracker rows marked supported | 240 |
| **Total** | | | **about 1,800** |

Headings: the template's two sections (Discussion, Conclusions) become the five
above; 6.1–6.4 are the discussion and 6.5 the conclusions. If the author prefers
two sections, 6.1–6.4 become subsections of Discussion with no change of content.

## Rules for drafting

- Every claim in 6.1 and 6.5 must match a claim-tracker row marked supported.
  Local refinement is "supported visually for these four scenes"; write it as
  such, not as a general result.
- No separability claim (the tracker marks it not safe until line profiles exist).
- No speed or runtime claim: no thesis experiment measured runtime
  (`research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md`,
  line 1246). "Single capture" is the supported statement.
- No failure examples (author, 2026-11-26). Limitations are written as
  assumptions and scope, tied to the model, not to cases shown or withheld.
- No parameter sweeps or sweep scores (author, 2026-11-26).
- Apply the [writing standard](writing-standard.md) and the
  [prose and figure standard](prose-and-figure-standard.md).

## Decisions (author, 2026-11-26)

1. **Limitations under the no-failure-cases rule.** Accepted: 6.3 states
   assumptions and scope, with no failure examples and no statement that
   failures were left out.
2. **"High-Speed" in the title.** Kept unless decided otherwise later. The
   speed the thesis supports is acquisition (one exposure, no scanning); no
   runtime claim.
3. **Line profiles.** In progress, for review with the supervisor on
   2026-11-29. If accepted, they go in Chapter 5, and 6.1 and 6.4 change
   accordingly; until then 6.4 lists quantitative evaluation as future work.
4. **Five sections.** Accepted by the author; the supervisor confirms on
   2026-11-29.
5. **Order of writing.** Accepted: 6.1, 6.3 and 6.5 first, then 6.2 once
   Chapter 2 is complete, then 6.4.
