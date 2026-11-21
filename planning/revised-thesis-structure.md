# Thesis structure and space budget

> **Status:** active — authoritative structure and budget
>
> **Reviewed:** 2026-11-21 (Chapter 3 figure count: two figures; 2026-11-19, Chapters 3 and 4 redivided as 3.7 and 1.6 pages)
>
> **Decision:** author-approved seven-chapter migration, 2026-11-08; Chapter 3/6/7 allocations approved 2026-11-12

This is the single authority for chapter order, titles, content ownership, and
space budgets. Other guides link here; their proposals cannot silently change
these decisions. The Technion template governs formatting. Hadar remains the
primary comparative thesis reference; the author's budgets govern thesis pacing.

## Chapters and budgets

| Chapter | Title | Prose/equation target | Content ownership |
| --- | --- | --- | --- |
| 1 | Introduction | 1–2 pages | Motivation, problem, objectives, and bounded contributions; may allude to results. No chapter-by-chapter roadmap (author decision, 2026-11-12). |
| 2 | Literature Review | About 2 pages | Selective prior work, nearest alternatives, and the gap addressed. |
| 3 | What is a light-field microscope | About 3.7 pages (4 approved 2026-11-12; 4.3 approved 2026-11-19; 3.7 approved 2026-11-19 when the instrument design moved to Chapter 4) | LFM/FLFM principles, measured views, necessary model/sampling assumptions, and relevant aberration/scattering context. |
| 4 | Our setup | About 1.6 pages (1 approved 2026-11-12; 1.6 approved 2026-11-19) | Design of our instrument (the decision sequence and the design-values table), instrument and camera roles plus the minimal acquisition/calibration/selection/evaluation summary needed to interpret the results. |
| 5 | Image reconstruction | About 1 page | Essential account of the single global-then-local method; exactly one approximately full-page figure, budgeted separately. |
| 6 | Results | About 6 pages (approved 2026-11-12) | Qualified observations, comparisons, quantification, uncertainty, and failure/no-change evidence. |
| 7 | Discussion and Conclusions | About 4 pages (approved 2026-11-12) | Interpretation, literature comparison, limitations, established conclusions, and future work; no new evidence. |

The overall target is approximately **20 pages of prose and equations** across
these seven chapters. Figures, captions, tables, appendices, front/back matter,
and the Hebrew part are excluded. Chapters 3, 6, and 7 share the approximately
14–15 pages left after Chapters 1, 2, 4, and 5. On 2026-11-12 the author
allocated them about 4, 6, and 4 pages; on 2026-11-19 Chapter 3 was raised to about 4.3, leaving about 0.2 page of slack.
Later on 2026-11-19 the 5.3 pages of Chapters 3 and 4 were redivided as about 3.7 and 1.6,
with the slack unchanged (see the departure table below).

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
| 2026-11-12 | Chapters 3, 6, 7 page allocations | TBD (shared allowance of about 14–15 pages) | Chapter 3 about 4 pages; Chapter 6 about 6 pages; Chapter 7 about 4 pages | Chapter 3 must carry the depth-discrimination argument requested by the supervisor, FLFM image formation, and the aberration/scattering section; Chapter 6 is the core evidence. | 14 of about 14–15 pages allocated; about 0.5 page slack. | Author approved in chat, 2026-11-12 ("Approve and record"), on the proposal in the [Chapter 3 plan](03-light-field-model-plan.md#approved-outline-2026-11-12). |
| 2026-11-19 | Chapter 3 page allocation | About 4 pages (approved 2026-11-12) | About 4.3 pages, with per-section word caps in the chapter draft notes and in `03-light-field-model-plan.md` | The restructured design-first chapter (system design, resolution, axial, depth of field, sampling) measured about 4.6 pages with sections unwritten; capped sections bring it to 4.3 with derivations moved to Appendix B and hardware detail to Chapter 4. | Uses 0.3 of the about 0.5 page of slack; about 0.2 page remains. | Author approved in chat, 2026-11-19 ("Accept 4.3 pages"), on the proposal in the [Chapter 3 plan](03-light-field-model-plan.md#section-page-budget-2026-11-19-proposal). |
| 2026-11-19 | Chapters 3 and 4 page allocation | Chapter 3 about 4.3 pages, Chapter 4 about 1 page (both approved) | Chapter 3 about 3.7 pages (Part A: FLFM in general), Chapter 4 about 1.6 pages (Part B: design of our instrument, light paths and cameras, sample, data and evaluation summary); per-section word caps in the chapter draft notes and in `03-light-field-model-plan.md` | The 4.3-page budget was carrying the instrument design story (Chapter 4 material) while Chapter 4 kept its own page; the caps also left out displayed equations (about 4.9 pages by the chapter's own yardstick). Both chapters are drafted together in `03_light_field_microscope.tex`, with a split line between Part A and Part B; the split itself is still to be decided. | None: 5.3 pages before and after; about 0.2 page of slack remains. | Author approved in chat, 2026-11-19 ("I agree to the proposal"), on the two-part layout proposal of the same session. |
| 2026-11-12 | Chapter 3 figure | No figure target | One conceptual three-panel figure (wide-aperture cone; narrowed aperture with two depths coinciding; sub-apertures separating them) | Shows the supervisor's point that depth of field without ray separation loses plane discrimination. | None (figures excluded from the prose count). | Same approval as above. |
| 2026-11-12 | Appendices (structure) | Appendices A–C | Add an appendix for acquisition and evaluation records, receiving Chapter 4's archive table, reconstruction/selection records, and detailed evaluation protocol | Brings Chapter 4 from about 3 pages to its 1-page target without silently cutting content. | None (appendices excluded). | Same approval as above; the appendix letter and file are created during the Chapter 4 content pass. |
| 2026-11-21 | Chapter 3 figures (Part A) | One conceptual three-panel figure (approved 2026-11-12) | Two figures, in place of the conceptual figure: the light-path figure (`fig:flfm-path`, `figures/ch03/flfm-path.tex`) and the lens-free axial-parallax figure (`fig:axial-parallax`, `figures/ch03/axial-parallax.tex`) | The restructured chapter defines the symbols of the resolution relations on the light path, and the supervisor asked for the two-emitter parallax figure without lenses (workplan D9, 2026-11-17 meeting). | None (figures and captions excluded from the prose count). | Author approved in chat, 2026-11-21 ("record the departure from the number of figures budget"), after reviewing the rendered axial figure. |

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
| Introduction | 2026-11-09 content migration pass 1: the former chapter was split sentence by sentence and moved verbatim. Literature content went to Chapter 2, LFM/FLFM principles and tissue scattering to Chapter 3, and the medical-imaging motivation to `supporting-material/drafts/introduction-parked-text-2026-11-09.md` (with the full former text). Chapter 1 now holds a short skeleton. A same-day wording pass (author-authorized small edits in Chapters 1 and 2, Chapter 3 subsection removed) smoothed the joins; remaining open items are in the parked-text file. | Pass 2: write Chapter 1 to its 1–2 page target (problem, objectives, bounded contributions; no roadmap, author decision 2026-11-12); repair the moved text's seams in Chapters 2 and 3. |
| Image reconstruction | 2026-11-09 content migration: the full former chapter (prose, equations, pipeline schematic and caption) moved verbatim to Appendix A, "Reconstruction method in detail". Chapter 5 is now a condensed account of about 1 prose page plus one full-page figure, the author-selected alignment-evolution figure (Fig. 5.1; provenance gaps still open). Rendered estimate about 1.1 prose/equation page equivalents (same method as the baseline above, including chapter-title space). | Confirm the page assessment in the author's own build; close the open provenance gaps for the main-body figure. |
| Microscope/degradation | Former Chapter 4 placeholder folded into Chapter 3 without a section heading (author decision, 2026-11-09: no subsections in Chapter 3). One scope sentence sits in the chapter opening and one tissue absorption/scattering paragraph closes the chapter. | Integrate and scope the degradation explanation during later content work. |
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
| 4 — Aberration and Scattering | Folded into Chapter 3 (no separate section heading since 2026-11-09) |
| 5 — Reconstruction Method | 5 — Image reconstruction |
| 6 — Experimental Setup, Data, and Evaluation Protocol | 4 — Our setup; detailed protocol extraction remains later work |
| 7 — Results | 6 — Results |
| 8 — Discussion; 9 — Conclusion | Sections within 7 — Discussion and Conclusions |

Dated logs and source observations retain their original numbering as history.
Current editorial placement pointers use this map; historical source paths,
revisions, run settings, inspection statements, and evidence status do not change.
