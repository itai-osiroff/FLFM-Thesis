# Chapter 5 (Results) plan

> **Status:** active (caps approved 2026-11-26: Results about 4.4 pages, four trio figures)
>
> **Reviewed:** 2026-11-26

Plan for drafting the Results chapter (`overleaf/main/05_results.tex`), from the
2026-11-24 supervisor meeting and the author decisions of 2026-11-25 and
2026-11-26. The structure authority remains
[revised-thesis-structure.md](revised-thesis-structure.md).

## Decisions (author)

- Exactly four scenes, all in the body, each shown as a trio figure: regular
  camera, global-stage average $G$, final rectified image, with zoom insets.
- Eyedrop gel first, then chicken-breast tissue.
- Evaluation is visual (2026-11-25): no metrics and no evaluation protocol in
  the thesis.
- No failure or no-change cases anywhere in the thesis, appendix included
  (2026-11-26).
- No results outside this chapter (author, 2026-11-26): the additional-results
  appendix was removed, so the four scenes here are the only results in the
  thesis. The body keeps one sentence saying the scenes were chosen
  visually.
- Parameters: say only that they were chosen for each run separately; do not
  claim they are optimal; no mention of sweeps, sweep scores or their criteria
  (2026-11-26).
- Line profiles are fully separate from the trio tooling and figures. Updated
  2026-11-26 (author): make the line-profile figures before the next supervisor
  meeting (Sunday 2026-11-29), once the chapter draft and bookkeeping are done,
  and show them to Anat as finished figures. Whether they enter the thesis is
  her call; until then nothing in the thesis references them.

## The four figures (selected 2026-11-26, latest generation of each)

| Figure file (`overleaf/figures/ch05/`) | Scene | Acquired | `algo` main commit | Provenance |
| --- | --- | --- | --- | --- |
| `trio-eyedrop-dense6.pdf` | Beads under eyedrop gel, dense6 | 2026-06-17 | `8cb681b` | [record](../research-context/result-provenance/fig_trio_eyedrop_dense6.yaml) |
| `trio-eyedrop-dense7.pdf` | Beads under eyedrop gel, dense7 | 2026-06-17 | `8cb681b` | [record](../research-context/result-provenance/fig_trio_eyedrop_dense7.yaml) |
| `trio-chicken-sparse.pdf` | Beads with chicken-breast tissue, sparse | 2026-07-02 | `4e2618a` | [record](../research-context/result-provenance/fig_trio_chicken_sparse.yaml) |
| `trio-chicken-dense.pdf` | Beads with chicken-breast tissue, dense | 2026-07-13 | `a2646c2` | [record](../research-context/result-provenance/fig_trio_chicken_dense.yaml) |

Commits follow the author's rule (the run used `main`): the first-parent `main`
tip just before each run's output timestamp. The working-tree state at run time
is unknown, and each record says so.

Figure title fix (author, 2026-11-26): the supervisor asked for "regular
camera" (meeting 2026-11-24), so the trio renderer (`replay_trio_figure.m`) now
titles the first column "Regular camera" instead of "ThorCam", and each figure is
re-rendered from its recipe and reselected.

## Outline and word caps (proposal)

Yardstick: about 450 words a page; figures and captions excluded.

| Section | Content | Cap (words) |
| --- | --- | --- |
| Opening | The question the chapter answers; what each figure compares (regular image, $G$, rectified image from the same run); four scenes chosen visually; parameters chosen per run | 70 |
| 5.1 Imaging setup | Drafted: cameras, flip mirror, 488 nm, F8827 beads | 125 (done) |
| 5.2 Beads under eyedrop gel | Sample and aberration source; dense6 trio; dense7 trio; what local refinement adds over $G$ | about 800 |
| 5.3 Beads in chicken-breast tissue | Sample and aberration source; sparse trio; dense trio; what local refinement adds over $G$ | about 850 |
| Closing | What was established, as observations; interpretation belongs to Chapter 6 | 120 |

That totals about 1,965 words, about 4.4 pages, about 1.6 pages under the
approved 6 pages. Figure target: four trio figures.

## Prose rules from author review (2026-11-26)

- Say what the chapter shows; do not state what it does not do (no "we do not
  measure", no disclaimers about absent metrics).
- No acquisition dates in the prose or captions; say what each sample is and
  what it demonstrates. Dates stay in the provenance records.
- Describe what changes between the images, not what stays the same (the
  background is ignored unless contrast is the point).
- Avoid absolute descriptions ("no bead appears as a spot"); keep observations
  proportionate.
- Tell each section as a progression: what the regular camera records, what one
  shift per view recovers, what local refinement adds.
