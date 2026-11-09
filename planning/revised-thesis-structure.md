# Thesis structure and space budget

> **Status:** active — authoritative structure and budget
>
> **Reviewed:** 2026-11-09
>
> **Decision:** author-approved seven-chapter migration, 2026-11-08

This is the single authority for chapter order, titles, content ownership, and
space budgets. Other guides link here; their proposals cannot silently change
these decisions. The Technion template governs formatting. Hadar remains the
primary comparative thesis reference; the author's budgets govern thesis pacing.

## Chapters and budgets

| Chapter | Title | Prose/equation target | Content ownership |
| --- | --- | --- | --- |
| 1 | Introduction | 1–2 pages | Motivation, problem, objectives, bounded contributions, and roadmap. |
| 2 | Literature Review | About 2 pages | Selective prior work, nearest alternatives, and the gap addressed. |
| 3 | What is a light-field microscope | TBD | LFM/FLFM principles, measured views, necessary model/sampling assumptions, and relevant aberration/scattering context. |
| 4 | Our setup | About 1 page | Instrument and camera roles plus the minimal acquisition/calibration/selection/evaluation summary needed to interpret the results. |
| 5 | Image reconstruction | About 1 page | Essential account of the single global-then-local method; exactly one approximately full-page figure, budgeted separately. |
| 6 | Results | TBD | Qualified observations, comparisons, quantification, uncertainty, and failure/no-change evidence. |
| 7 | Discussion and Conclusions | TBD | Interpretation, literature comparison, limitations, established conclusions, and future work; no new evidence. |

The overall target is approximately **20 pages of prose and equations** across
these seven chapters. Figures, captions, tables, appendices, front/back matter,
and the Hebrew part are excluded. Chapters 3, 6, and 7 have no individual page
allocations yet; together they share approximately 14–15 remaining prose pages.
That remainder is a planning allowance, not three newly assigned quotas.

Use approximate prose/equation page equivalents in the established template,
including headings and the space needed for readable equations. For mixed pages,
estimate the fraction occupied by the chapter text and equations; do not count
the figure/table/caption area or float-only and forced blank pages as prose.
Record visual/table footprint separately. Do not use word counts, smaller fonts,
changed margins, or compressed spacing as substitutes for this page assessment.

## Ownership and reporting detail

- Chapter 2 compares prior work; Chapter 3 explains the microscope and the
  relevant degradation/model limits. There is no separate degradation chapter.
- Chapter 4 owns a minimal acquisition/evaluation summary alongside the instrument.
  Detailed sample/acquisition/extraction/calibration protocols, selection rules,
  metric definitions, configurations, and reproducibility records belong in
  appendices or linked repository provenance. Essential qualifications must stay
  visible beside the result they qualify. Do not turn Results into a protocol chapter.
- Chapter 5 identifies the actual transformation and defining assumptions clearly
  within its budget. The technical worksheet is a completeness check across the
  main account and supporting records, not a list of mandatory main-text sections.
- Chapter 7 unites discussion and conclusions. Preserve the distinction between
  observations in Chapter 6 and interpretation/conclusions in Chapter 7.
- Appendix content must serve the argument; excluded space is not a reason to
  invent supplementary work. Scientific evidence and provenance requirements
  remain in force at every length.

## Departures require an author decision

Before changing a page or figure target, obtain the author's explicit agreement
and enter the decision below. A proposal, assistant judgment, inherited draft
length, or an old chapter plan is not approval. A TBD allocation must also be
agreed explicitly before it becomes a chapter target.

| Date | Chapter/constraint | Original target | Approved departure/allocation | Rationale | Overall budget effect | Author approval record |
| --- | --- | --- | --- | --- | --- | --- |
| — | — | — | None recorded | — | — | — |

At the start of writing, consult this table and the chapter's ownership. At
review, record approximate current/projected prose pages and separate visual
space, flag an overrun, and either plan content migration or seek an explicit
departure. Do not silently enlarge a target or silently cut content to comply.

## Structure-only migration and remaining content work

The November 8 migration changes documentation and structure only. Existing
prose, equations, captions, tables, and figures are preserved. These inherited
states are **migration debt**, not approved permanent departures:

| Area | Current location/state after structural migration | Intended later action |
| --- | --- | --- |
| Existing prose across the thesis | Retained under seven chapters; page compliance is not claimed. | Assess rendered prose/equation equivalents and migrate content chapter by chapter. |
| Our setup | Entire former setup/data/evaluation body and archive table retained in Chapter 4. | Keep the minimal instrument/protocol summary; move detailed reporting to supporting material while meeting the target. |
| Image reconstruction | 2026-11-09 content migration: the full former chapter (prose, equations, pipeline schematic and caption) moved verbatim to Appendix A, "Reconstruction method in detail". Chapter 5 is now a condensed account of about 1 prose page plus one full-page figure, the author-selected alignment-evolution figure (Fig. 5.1; provenance gaps still open). Rendered estimate about 1.1 prose/equation page equivalents (same method as the baseline above, including chapter-title space). | Confirm the page assessment in the author's own build; close the open provenance gaps for the main-body figure. |
| Microscope/degradation | Former Chapter 4 placeholder retained as an “Aberration and scattering” section in Chapter 3. | Integrate and scope its explanation during later content work. |
| Discussion/conclusions | Both former bodies retained as sections within Chapter 7. | Develop a coherent combined argument when results are stable. |

Do not rewrite, shorten, relocate figures, or repair scientific inconsistencies
as part of this structural pass. Record them for the relevant later writing task.

The [dated migration verification record](../docs/superpowers/plans/2026-11-08-seven-chapter-migration.md)
contains the rendered space baseline, conservation checks, and build/visual
verification. Those observations are not revised targets or completion claims
for the unfinished chapters.

## Previous-to-current chapter map

| Previous chapter | Current destination |
| --- | --- |
| 1 — Introduction | 1 — Introduction |
| 2 — Background / Background and Literature | 2 — Literature Review |
| 3 — Light Field Microscopy Model | 3 — What is a light-field microscope |
| 4 — Aberration and Scattering | Section within Chapter 3 |
| 5 — Reconstruction Method | 5 — Image reconstruction |
| 6 — Experimental Setup, Data, and Evaluation Protocol | 4 — Our setup; detailed protocol extraction remains later work |
| 7 — Results | 6 — Results |
| 8 — Discussion; 9 — Conclusion | Sections within 7 — Discussion and Conclusions |

Dated logs and source observations retain their original numbering as history.
Current editorial placement pointers use this map; historical source paths,
revisions, run settings, inspection statements, and evidence status do not change.
