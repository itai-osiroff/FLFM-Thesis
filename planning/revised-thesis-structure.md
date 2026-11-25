# Thesis structure and space budget

> **Status:** active — authoritative structure and budget
>
> **Reviewed:** 2026-11-25 (Chapter 5 about 1.92 pages from the slack, total about 19.52); 2026-11-25 (Chapter 5 about 1.85 pages, total about 19.45; second Chapter 5 figure); 2026-11-24 (second supervisor meeting: Chapter 4 dissolved; its 1.6 pages allocated as B1 0.5 in Chapter 3, view extraction 0.1 in Chapter 5, 1.0 slack, total about 19.3; Chapter 5 aberration story replaced by the piecewise-linear account); 2026-11-24 (A4 third display line approved); 2026-11-23 (supervisor meeting: aberrations as shifts moved from Chapter 3 to Chapter 5, Chapter 5 raised to about 1.6 pages, total about 20.3 pages; a third Chapter 3 figure); 2026-11-21 (Chapter 3 figure count: two figures; 2026-11-19, Chapters 3 and 4 redivided as 3.7 and 1.6 pages)
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
| 3 | What is a light-field microscope | About 4.2 pages: Part A about 3.7 (4 approved 2026-11-12; 4.3 approved 2026-11-19; 3.7 approved 2026-11-19 when the instrument design moved to Chapter 4) plus B1 about 0.5 (approved 2026-11-24, when Chapter 4 was dissolved) | LFM/FLFM principles and the design and performance of an FLFM: resolution, depth of field, field of view and sampling, closing with the design of our instrument (B1). Since 2026-11-23 (supervisor meeting) no aberration, shift or refocusing material; that is Chapter 5's. |
| 4 | ~~Our setup~~ (dissolved 2026-11-24) | None. Its former 1.6 pages: 0.5 to B1 (Chapter 3), 0.1 to view extraction (Chapter 5), 1.0 unallocated slack (departure table, 2026-11-24) | No chapter. The design of our instrument (Part B, B1) closes Chapter 3; what the reader needs to interpret the results opens Chapter 6; every other implementation detail of the system goes to an appendix. Chapter numbers and file names stay as they are until the mechanical migration (renumbering, retiring `04_our_setup.tex`) is done. |
| 5 | Image reconstruction | About 1.92 pages (1 approved 2026-11-08; 1.6 approved 2026-11-23; 1.7 approved 2026-11-24 for view extraction; 1.85 approved 2026-11-25 for a gentler two-paragraph opening that ties $K$ to $N$; 1.92 approved 2026-11-25 for the Fig. 5.2 walk-through) | How the sensor frame is cut into views (at most about 40 words, since 2026-11-24, when Chapter 4 was dissolved; details in the appendix). Why aligning views corrects aberration (moved from Chapter 3 on 2026-11-23; since 2026-11-24 told as the supervisor's piecewise-linear account: the lenslets split the Fourier plane into segments, each approximates the wavefront by its mean tilt, so each view shifts; two emitters give two different approximations, hence the local stage), then the essential account of the single global-then-local method; one approximately full-page figure plus, since 2026-11-25, a two-emitter schematic for the aberration section, both budgeted separately. The Shack–Hartmann analogy is retired (legacy record in `supporting-material/drafts/ch05-shack-hartmann-legacy-2026-11-24.md`). |
| 6 | Results | About 6 pages (approved 2026-11-12) | Opens with a short preface section, inside the 6 pages, holding only what is needed to read the results (since 2026-11-24): the regular and light-field cameras and how they share the light path, and the 488 nm excitation matched to the absorption of the beads, named by product (Thermo Fisher FluoSpheres yellow-green; spectrum in the references and the appendix). The Validation Camera is not used in the body and appears only in the appendix. Each sample subsection (chicken-breast tissue, eyedrop gel) opens with what the sample is and where its aberration comes from. Evaluation is explained through the results themselves, with no separate protocol section. Then qualified observations, comparisons, quantification, uncertainty, and failure/no-change evidence. |
| 7 | Discussion and Conclusions | About 4 pages (approved 2026-11-12) | Interpretation, literature comparison, limitations, established conclusions, and future work; no new evidence. |

The overall target is approximately **20 pages of prose and equations** across
these seven chapters. Figures, captions, tables, appendices, front/back matter,
and the Hebrew part are excluded. Chapters 3, 6, and 7 share the approximately
14–15 pages left after Chapters 1, 2, 4, and 5. On 2026-11-12 the author
allocated them about 4, 6, and 4 pages; on 2026-11-19 Chapter 3 was raised to about 4.3, leaving about 0.2 page of slack.
Later on 2026-11-19 the 5.3 pages of Chapters 3 and 4 were redivided as about 3.7 and 1.6,
with the slack unchanged (see the departure table below). On 2026-11-23 the aberration section moved from Chapter 3 to Chapter 5, which rose to about 1.6 pages; Chapter 3 kept 3.7 pages by tripling its sampling section. The total was then about 20.3 pages with no slack (author decision, departure table). On 2026-11-24 Chapter 4 was dissolved (author decision after the supervisor meeting). Its 1.6 pages went 0.5 to B1 at the end of Chapter 3, 0.1 to a view-extraction sentence in Chapter 5, and 1.0 to unallocated slack; the Chapter 6 preface fits inside Chapter 6's 6 pages. The total was then about 19.3 pages. On 2026-11-25 Chapter 5 rose to about 1.85 pages for its opening, taken from the slack: the total is now about 19.45 pages, about 0.55 page under the 20-page target, with about 0.85 page of slack. On 2026-11-25 Chapter 5 took about 0.07 page more (about 30 words, the rewritten Fig. 5.2 walk-through), again from the slack: the total is now about 19.52 pages, with about 0.78 page of slack.

Use approximate prose/equation page equivalents in the established template,
including headings and the space needed for readable equations. For mixed pages,
estimate the fraction occupied by the chapter text and equations; do not count
the figure/table/caption area or float-only and forced blank pages as prose.
Record visual/table footprint separately. Do not use word counts, smaller fonts,
changed margins, or compressed spacing as substitutes for this page assessment.

## Ownership and reporting detail

- Chapter 2 compares prior work; Chapter 3 explains the microscope and the
  relevant degradation/model limits. There is no separate degradation chapter.
- Since 2026-11-24 there is no Chapter 4. The minimum needed to interpret the
  results (cameras, excitation, samples) opens Chapter 6 and its sample subsections;
  instrument implementation details (laser, beam expanders, lenses, filters,
  part numbers) go to an appendix.
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

| 2026-11-23 | Chapters 3 and 5; overall total | Chapter 3 about 3.7 pages; Chapter 5 about 1 page; total about 20 pages with about 0.2 page of slack | Chapter 5 about 1.6 pages: it receives the former Chapter 3 section "Aberrations as shifts" (302 words, kept to at most 270). Chapter 3 stays at about 3.7 pages: that section's space goes to the field-of-view and sampling section (A4), whose cap triples from 167 to about 500 words. | Supervisor meeting of 2026-11-23: Chapter 3 is about the design and performance of an FLFM only, and the sampling story needs more room. | Uses the 0.2 page of slack and adds about 0.3 page: total about 20.3 pages. | Author approved in chat, 2026-11-23 ("Ch5 1.6, total ~20.3"). |
| 2026-11-23 | Chapter 3 figures (Part A) | Two figures (approved 2026-11-21) | Three: two versions of the light path plus the axial figure. Amended 2026-11-24 from the meeting recording: Figure 3.1 becomes the idealized path (array in the back pupil, sensor behind it, no relays; `figures/ch03/flfm-simple-path.tex`), and the full path with both relays (`fig:flfm-full-path`, `figures/ch03/flfm-full-path.tex`) closes Part A; this replaces the first pass's camera-side figure | Shows how the camera's pixels connect to the field of view and the sampling, and why relays are used (supervisor meeting, 2026-11-23: "two versions of the drawing", the second in the chapter's last paragraph). | None (figures and captions excluded from the prose count). | Author request in chat, 2026-11-23. |
| 2026-11-24 | Chapter 4 (dissolved); Chapters 3 and 6 ownership; overall total | Chapter 4 "Our setup" about 1.6 pages (approved 2026-11-19); total about 20.3 pages | No Chapter 4. B1 (design of our instrument) closes Chapter 3 (the supervisor asked for about half a page, against B1's 0.8-page cap); the facts needed to read the results become a short preface section of Chapter 6 (two cameras and how they share the path, 488 nm excitation matched to the beads' absorption) plus one opening paragraph per sample subsection; all other system details, including the camera filters and the excitation coupling, go to an appendix (the acquisition-and-evaluation records appendix approved 2026-11-12, still to be created). Evaluation is explained through Chapter 6 itself, with no separate section anywhere. | Supervisor meeting of 2026-11-24: most of the system description belongs in an appendix, and what the reader needs is "two lines" at the start of Results. | Approved targets sum to about 18.7 pages; the freed 1.6 pages are unallocated. Allocating them (B1 in Chapter 3, the Chapter 6 preface, slack) needs a separate author decision. | Author approved in chat, 2026-11-24 ("there will be no chapter 4"). |
| 2026-11-24 | Allocation of the former Chapter 4 pages; Chapters 3 and 5; overall total | 1.6 pages unallocated (Chapter 4 dissolved, same day); Chapter 3 about 3.7 pages; Chapter 5 about 1.6 pages | Chapter 3 about 4.2 pages (B1 about 0.5 page, about 225 words, down from its 0.8-page cap). Chapter 5 about 1.7 pages: a view-extraction sentence of at most about 40 words, which had no home once Chapter 4 went (Chapter 5 only pointed to Chapter 4 for it). The Chapter 6 preface fits inside Chapter 6's 6 pages. The remaining 1.0 page is unallocated slack. | Supervisor meeting of 2026-11-24 (B1: "half a page"); view extraction must be stated where the views are first used. | Total about 19.3 pages, about 0.7 page under the 20-page target. | Author approved in chat, 2026-11-24 ("I agree with your allocation"; view extraction: "fit view extraction into the reconstruction algorithm's chapter. Acknowledge that regarding prose budget"). |
| 2026-11-25 | Chapter 5 "Aberrations as shifts" word cap | At most 270 words (2026-11-23) | At most 300 words, for the redrafted piecewise-linear account (phase ramps per segment, defocus vs. general shifts, the resolution price, a heterogeneous sample); raised again the same day to about 316 words, when field-varying aberration became its own short paragraph (P5), separate from the resolution cost | Author review of the first P2-P4 draft asked for clearer wording in each paragraph. | None on the page target: the bridge at the start of "Global and local alignment" shrank by about 28 words; Chapter 5 stays about 1.85 pages. | Author approved in chat, 2026-11-25 ("you may increase the prose budget to 300 words"; then "approve 316 words"). About +0.04 page on Chapter 5, absorbed in the slack. |
| 2026-11-25 | Chapter 5 page allocation; overall total | About 1.7 pages (approved 2026-11-24) | About 1.85 pages: the chapter opening becomes two paragraphs, a plain-language orientation (what the views are, why they no longer line up, what the chapter does) and the views with their notation, including one sentence tying the extracted grid size $K$ to the design quantity $N$ ($K=N=7$ in our acquisitions); the assumptions sentence moves to the end of the two stages. | Author, 2026-11-25: the reader should not be "attacked" where the chapter starts, and $K$ and $N$ must not be confused. | +0.15 page (about 9% of the chapter), from the slack: total about 19.45 pages, slack about 0.85 page. | Author approved in chat, 2026-11-25 ("You're allowed to change the prose budget by 5-10% to accommodate these"). |
| 2026-11-25 | Chapter 5 page allocation; overall total | About 1.85 pages (approved 2026-11-25) | About 1.92 pages: the about 30 words by which the drafted chapter exceeds 1.85 (the Fig. 5.2 walk-through rewritten to lead with "one shift per view is not enough") are kept rather than trimmed. | Author decision after the walk-through rewrite. | +0.07 page from the slack: total about 19.52 pages, slack about 0.78 page. | Author approved in chat, 2026-11-25 ("Take the extra 30 words from the slack"). |
| 2026-11-25 | Chapter 5 figures | Exactly one approximately full-page figure (the alignment-evolution figure, `fig:single-view-alignment`) | Two: the alignment-evolution figure plus a schematic two-emitter figure for "Aberrations as shifts" (TikZ, `figures/ch05/`): (a) one emitter in tissue, its ideal and aberrated wavefronts at the Fourier plane, the lenslet segments and the piecewise-linear fit; (b) a second emitter with a different fit, which motivates the local stage | The supervisor's piecewise-linear account (meeting 2026-11-24) is told through this drawing; she drew it with two emitters. | None (figures and captions excluded from the prose count). | Author approved in chat, 2026-11-25 ("approved, record this"). |
| 2026-11-24 | Chapter 3 A4 display lines | About 500 words + 2 display lines (2026-11-23) | About 500 words + 3 display lines: the pupil-image diameter $D_{proj}$ (Eq. `eq:d-proj`, A4 P4) is displayed rather than inline | Keeps the A4 prose concise, with only the simplest relations inline (author review of A4 P4). | About +35 word-equivalents, inside the about 90 words of Part A slack; Chapter 3 stays about 3.7 pages. | Author, in conversation, 2026-11-24 ("I approve the extra equations"). |

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
| Our setup | Entire former setup/data/evaluation body and archive table retained in `04_our_setup.tex`, still built as Chapter 4. Chapter 4 was dissolved on 2026-11-24. | Move the essentials into the Chapter 6 preface and sample paragraphs and everything else into the records appendix; then drop `04_our_setup.tex` from `thesis.tex`, renumber Chapters 5–7, repoint `ch:experimental-setup` references, and update `verify-template.ps1` and its tests. |
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
| 6 — Experimental Setup, Data, and Evaluation Protocol | 4 — Our setup (2026-11-08); dissolved 2026-11-24: design to Chapter 3 (B1), essentials to the Chapter 6 preface, the rest to an appendix |
| 7 — Results | 6 — Results |
| 8 — Discussion; 9 — Conclusion | Sections within 7 — Discussion and Conclusions |

Dated logs and source observations retain their original numbering as history.
Current editorial placement pointers use this map; historical source paths,
revisions, run settings, inspection statements, and evidence status do not change.
