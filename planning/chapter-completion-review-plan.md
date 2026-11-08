# Chapter completion and supervisor review

> **Status:** active guide with preserved historical assessment
>
> **Reviewed:** 2026-11-08

## Current completion framework

The [authoritative seven-chapter structure and budget](revised-thesis-structure.md)
supersedes the nine-chapter order, separate degradation/discussion/conclusion
handoffs, paragraph/word quotas, and schedule/effort estimates in the November 3
assessment preserved below. Those estimates are historical, not a current promise
or an estimate for the compact thesis. Re-estimate after content scope is settled.

The supervisor's reported constraint still applies: **completed chapters only**
(author report, 2026-11-03). Structural migration alone does not complete a chapter.
Retain the assessment's substantive evidence checks and complete-chapter handoff
requirements, applying them to the current ownership and budgets. Detailed
reporting may live in linked appendices/provenance; scientific qualifications
cannot disappear to satisfy a page target.

| Current chapter | Inherited material | Remaining content work |
| --- | --- | --- |
| 1 — Introduction | Existing opening | Complete framing/roadmap and fit its agreed allowance. |
| 2 — Literature Review | Background placeholder and reading notes | Develop a selective comparison and gap. |
| 3 — What is a light-field microscope | Model draft plus degradation placeholder | Choose the necessary explanation from the optional backlog; integrate degradation and reconcile scientific issues in later writing. |
| 4 — Our setup | Entire old setup/data/evaluation draft | Resolve essential facts, retain a minimal summary, and extract supporting detail later. |
| 5 — Image reconstruction | Existing technical draft and two figures | Reconcile method evidence, then reduce prose and choose the single figure later. |
| 6 — Results | Existing placeholder and candidate pools | Qualify retained runs/comparisons before drafting claims and figures. |
| 7 — Discussion and Conclusions | Both old placeholders | Interpret stable results and close the contribution account in one chapter. |

A later writing sequence can prioritize the method/model and evidence recovery
for early substantive feedback, then setup/results, the review, and the combined
ending/introduction. It does not require seven sequential handoffs in reading
order. Confirm supervisor cadence rather than assuming concurrent review slots.

For every handoff, record source revision, rendered prose/equation estimate,
separate visual space, any approved departure, evidence checks, PDF inspection,
and unresolved review questions. Existing overflow and the additional method
figure remain migration debt. No chapter has been newly certified, sent, or
scientifically verified by this migration.

## Historical assessment — November 3, 2026

The remainder is the original assessment and proposed execution schedule.
Its chapter numbers, manuscript states, time estimates, and dated observations
describe the recorded baseline, not the current structure. Use the authoritative
old-to-new map for navigation; do not execute its superseded schedule.

---

# Chapter completion and parallel supervisor review

> **Assessed:** 2026-11-03
>
> **Baseline:** thesis repository `4bef3802d95c4318539d431315b8c781db011860`; clean working tree before this assessment.
>
> **Constraint:** the supervisor reviews completed chapters only (author report, 2026-11-03).
>
> **Status:** proposed execution plan; no chapters submitted or scientific results newly verified.

## Recommendation

Finish Chapter 5 first and Chapter 3 second. Use their review periods to qualify the evidence and finish Chapters 6 and 7. Keep Chapters 2 and 4 as productive work when evidence recovery is waiting on external information. Finish Discussion, Introduction, and Conclusion once the result claims are stable. Preserve the existing nine-chapter reading order; writing and review need not follow it.

The fastest route is to reduce the time between **complete, coherent chapter handoffs**, while attacking the result-evidence bottleneck immediately. Writing every chapter a little at a time would leave the supervisor unable to help. Writing Chapters 1–9 sequentially would postpone feedback on the central method and risk rewriting the opening after the results change. Finishing results first would address the bottleneck but leave the supervisor idle during uncertain recovery work. The proposed sequence combines an early substantive handoff with early evidence triage.

This assessment uses the active `.tex` files, planning records, method-note index, result provenance, and current figure indexes/selected recipes. It is a manuscript and dependency assessment, not a fresh code audit, experiment replay, primary-literature citation audit, or PDF layout review. It applies the local writing standards and ARS academic-paper planning guidance as advisory aids, without running a formal ARS review pipeline. Hadar remains the primary comparative thesis reference; the Technion template remains unchanged.

## Current state across the whole thesis

**No chapter is demonstrably ready for complete-chapter review yet.** Two chapters have substantial drafts, two have partial drafts, and five remain placeholders. This is a count of manuscript states, not a percentage of the research completed. Considerable reusable work exists outside the manuscript.

| Chapter | Inspected state | What prevents a complete handoff | Next completion action |
| --- | --- | --- | --- |
| **1 — Introduction** | Eight substantive paragraphs develop imaging trade-offs through FLFM and state the 2D scope. | Stops before a thesis-specific problem statement, explicit research question/objectives, bounded contribution account, and chapter roadmap. Some broad claims still need source support. | Retain the useful buildup; complete the thesis-specific ending after the evidence boundary is stable. Do not repeatedly polish the opening now. |
| **2 — Background** | Chapter title and one scope sentence. Source notes and a synthesis map exist. | No literature argument, comparison of relevant approaches, or established gap. | Write a bounded chapter around the concepts and nearest approaches needed by Chapters 3–5; inspect primary passages for its actual claims. Avoid repeating Chapter 1's modality survey or Chapter 4's degradation treatment. |
| **3 — Model** | Five substantive paragraphs establish measurement, coordinates, array representation, and an optical-path sketch. A detailed October 8 completion plan exists. | No completed intensity-to-measurement model, conceptual figure, sampling account, or closed assumptions/validity argument. The final “complex continuous function” wording conflicts with the preceding intensity account. | Execute the existing [Chapter 3 plan](03-light-field-model-plan.md), including its original schematic and bounded model. Resolve notation with Chapters 5–6. |
| **4 — Aberration/scattering** | Chapter title and one scope sentence. Source map exists. | Entire explanatory argument is unwritten. | Explain the degradation mechanisms relevant to the chosen scope and what coordinate rectification can and cannot address. Distinguish tissue from tissue-like eyedrop media; do not assign measured optical properties without evidence. |
| **5 — Method** | Most developed technical account: pipeline diagram, global correlation, local score, search, resampling, means, and limitations. | Early parameter paragraph claims settings reproduce thesis results before those runs are qualified. It also gives simplified truncation/non-finite handling statements that need reconciliation with the later equations and versioned source account. Algorithm parameters and execution branches need one consistent specification. | Freeze the method path and documented revision, reconcile equations/settings/edge cases, organize the narrative, check citations, and close with a summary and limits. First handoff candidate. |
| **6 — Setup/data/evaluation** | Four substantial sections, an archive table, hardware account, June 3 preparation, and careful evaluation caveats. | Much of the evaluation is a list of information still required, rather than the protocol actually used. No complete as-built schematic or selected-dataset acquisition/parameter table. Camera correspondence, extraction, metrics, support, and selection remain open. | Close the records for the selected evidence set and write the actual protocol. Reconcile hardware statements with author records; do not keep June 3 as the sole worked example automatically if newer scenes are selected. |
| **7 — Results** | Chapter title and one sentence. Recent candidate figures exist outside `overleaf/`. | No qualified result blocks, final quantitative table, or evidence-led narrative in the chapter. | Qualify the smallest adequate evidence set, build its figures/table from numerical products, then write observations and limitations. |
| **8 — Discussion** | Chapter title and one sentence. Caveats are available in method and result notes. | Needs the actual Chapter 7 findings and their limits. | Interpret the frozen findings, compare with relevant literature, address failure/no-change cases and selection limits, and distinguish future work. |
| **9 — Conclusion** | Chapter title and one sentence. | Contributions and conclusions cannot yet be closed. | Summarize only established findings; add bounded future directions after Chapters 7–8. |
| **Appendices A/B** | Both are placeholders. | No selected supporting derivations or supplementary results. | Include only material needed by the final argument; remove unused placeholders at integration. Do not manufacture appendix work. |
| **Abstracts/front matter** | English abstract is a short opening plus completion instruction; Hebrew abstract is a completion instruction. Metadata includes bracketed fields. | English/Hebrew abstracts, Hebrew title, dates, publication/contribution statement, and final front-matter checks remain. | Complete after conclusions stabilize, allowing time for author checking of Hebrew and institutional requirements. |

Source files: [active chapter directory](../overleaf/main/), [abstracts](../overleaf/front/abstract.tex), [metadata](../overleaf/misc/thesis-fields.tex), [chapter synthesis map](chapter-synthesis-map.md).

### Progress hidden by the old planning records

The September figure backlog understates recent preparation. The current figure indexes include November 1–2 generations for June 17 eyedrop and July 13 chicken scenes and their variants. **All ten inspected indexes have empty `selected` fields.** A successful replay, `comparisonApproved`, or `published` flag is workflow state, not scientific qualification or supervisor approval.

The [June 17 dense7 recipe](../candidate-outputs/figures-source/17_6_dense7_eyedrop/trio-recipe.json) and [July 13 chicken recipe](../candidate-outputs/figures-source/13_7_dense_chicken/trio-recipe.json) record workspace identities and preparation information, but still report absent manifests and unknown generation/stage identifiers. The chicken recipe points to a `power_compare/power_2` workspace. Verify the saved configuration before deciding whether its scoring matches Chapter 5's ordinary intensity formulation. A directory name alone does not establish the algorithm used.

The [June 3 provenance](../research-context/result-provenance/fig_eyedrop_3_6.yaml) is more extensively recorded but still lacks a historical source commit and parts of comparison preparation. Its age and previous figure work are not reasons to make it the flagship. Compare candidate readiness before committing more time.

Planning records also contain stale details: the claim tracker points to an obsolete `overleaf/chapters/` path; the model/method use one-based view indices while Chapter 6 uses zero-based indices; Chapter 6 states both objective models while the system account still asks for confirmation. Reconcile these as part of the relevant chapter closures, using actual source authority rather than choosing whichever statement is more convenient.

## What “completed chapter” means here

A completed chapter is a full version for substantive review, with its entire argument, evidence, figures, citations, and ending present. It can need supervisor revision. It cannot depend on a missing section, unfinished analysis, promised figure, or unresolved fact central to its conclusion.

Before each handoff:

1. Every planned section answers its assigned question; the opening and closing are written.
2. All included equations, figures, tables, captions, and citations are complete and checked against their evidence. No placeholder citations or provisional result images.
3. The scientific scope is explicit. Essential unknowns are resolved, or the dependent claim/comparison is removed. Irrecoverable nonessential information can remain an explicit limitation if the chapter's argument is still defensible; “unknown” is not a universal completion waiver.
4. Notation, method version, input/output meanings, and forward references agree with the thesis. A reference to another chapter is acceptable; relying on that unwritten chapter to define the present chapter's central terms is not.
5. Build the thesis using `latexmk thesis` in `overleaf/`, resolve chapter-relevant references/build problems, and visually inspect the chapter PDF. Preserve the established template.
6. Freeze a dated PDF and source revision. Accompany it with at most three focused review questions and, where useful, a short context note. The chapter itself must stand alone; a note cannot substitute for missing content.

This is a proposed operational definition, not an assertion that the supervisor has accepted it. Her reported restriction is complete chapters; turnaround, preferred order, and whether she will queue multiple completed chapters are still unknown.

## Execution sequence and overlap

Use **six-hour focused workdays** below as effort units, not calendar promises. Estimates are planning judgments, uncalibrated against the author's writing pace. They assume access to the existing records and no new acquisition campaign. The author owns scientific choices, factual confirmations, and handoffs; drafting, source checks, record assembly, and builds can be assisted. Supervisor time is review time, not part of the author's effort budget.

| Stage | Author's principal deliverable | Effort allowance | Supervisor can review | Exit condition |
| --- | --- | --- | --- | --- |
| **A: start now** | Evidence shortlist and method scope, then complete **Ch. 5** | 4–6 days, including 1–2 days of initial evidence triage | Nothing until the full chapter passes the gate | Complete method chapter; candidate paths reconciled enough to avoid describing the wrong method |
| **B** | Complete **Ch. 3**; pursue outstanding record requests in a short scheduled daily slot | 3–5 days | Ch. 5 | Complete model chapter using the existing scoped plan |
| **C** | Close the selected evidence records and complete **Ch. 6** | 4–7 days | Ch. 3 and any remaining Ch. 5 review | Actual acquisition, extraction, selection, and evaluation protocol documented for the retained results |
| **D** | Complete **Ch. 7**, including figures, quantitative summary, and limitations | 5–8 days | Ch. 6 | All retained result blocks qualified; claims and figure set frozen for downstream writing |
| **E** | Complete **Ch. 2**, then **Ch. 4**, as separate handoffs | 5–8 days combined | Ch. 7, then Ch. 2 | Focused literature/degradation chapters with inspected source support |
| **F** | Complete **Ch. 8**, then **Ch. 1**, then **Ch. 9**, as separate handoffs | 4–6 days combined | Previously handed-off chapters; then each newly completed chapter | Discussion, contribution framing, and conclusions agree with the final evidence |
| **G** | Incorporate remaining feedback, complete abstracts/front matter and necessary appendices, check the full thesis | 5–8 days | Latest completed chapters and the integrated thesis if she requests it | All substantive feedback resolved or explicitly discussed; final build and visual checks pass |

**Total initial planning envelope: 30–48 focused days (180–288 hours)**, including the listed revision/integration allowance. At 30 focused hours/week this is roughly 6–10 working weeks, plus any supervisor-review tail or external delays. At 15 hours/week it is roughly 12–20 weeks. This is not a submission-date commitment. Re-estimate after the first chapter and the evidence triage; major scientific revisions or new experiments exceed this envelope.

Stages E and F are not rigid calendar slots. If Stage C is waiting on hardware/acquisition facts, move Chapter 2 or 4 forward immediately. If Chapter 7 finishes with stable claims while Chapter 2 is still pending, draft Discussion next while the results are fresh. Prioritize the next **finishable complete chapter**, without losing the small daily effort on the evidence bottleneck.

Do not wait for Chapter 5 feedback before writing Chapter 3. Do avoid committing result analyses to a contested method interpretation until substantive feedback is addressed. Read incoming comments promptly: propagate a correction that changes the model, protocol, or claims immediately; batch wording and presentation edits into planned revision sessions.

## First two workdays: remove the expensive uncertainties

### Day 1: bound the evidence and method

Compare the recent June 17 eyedrop and July 13 chicken workspaces with the June 3 candidate. Add one no-change/weak-outcome candidate from the existing curation if its records can be recovered. For each, record only the decision-critical fields in the existing provenance system: raw input, specimen/medium, paired stage outputs, exact algorithm/configuration, revision evidence, extraction/calibration, comparison registration, evaluation support, selection history, and remaining gaps.

Choose by traceability and relevance to the thesis, not by the most striking display. The initial target is one qualified eyedrop example, one qualified chicken example, and a bounded account of failure/no-change behavior. This is an initial writing package, not a claim that three scenes establish general performance or automatically satisfy thesis requirements. Report the actual independent acquisition/sample counts; crops and parameter candidates are not independent samples.

Check whether all retained runs implement the intended two-stage path. If a powered score or other optional branch is essential, describe that exact branch in Chapter 5 before its handoff. Otherwise choose a compatible run or perform a clearly identified new run. Do not silently present a different scoring formula as the existing method.

### Day 2: settle recovery choices and finish the Chapter 5 checklist

Produce one consolidated author/lab fact list for the selected acquisitions: illumination coupling/filtering, validation contrast, objective identity, specimen geometry, exposure/gain, retained views, extraction geometry, and calibration. Separate essential facts from details that only limit a secondary claim. Keep the missing-fact records in [open questions](open-questions.md), not scattered across new planning documents.

Decide for each candidate: **recover**, **rerun**, **replace**, or **omit**. Then finish Chapter 5 against the versioned [method-note entry point](../research-context/method-notes/rectification-pipeline/README.md) and its underlying code when needed. Recorded June 3 settings are candidate-specific settings, not proof of universal thesis defaults. Check the global-average reference, threshold rules, Gaussian support/scaling, candidate stride/ties, near-zero and non-finite behavior, interpolation, boundaries, and means as one consistent account.

## Keep evidence recovery from becoming an indefinite project

Time-box the initial candidate audit to two focused days overall. Give an individual stalled candidate at most one additional focused recovery day before deciding on another route. These are decision deadlines, not permission to bypass missing evidence.

- If raw views and calibration survive but historical code provenance does not, assess a new run with a frozen, recorded revision and effective configuration. Label it as new processing of the historical acquisition; do not assign the new revision to the old image. This repairs computational provenance only, not missing acquisition information.
- If external-camera registration cannot be qualified, remove the unsupported cross-camera quantitative claim. A within-run stage comparison may still be usable under a fully stated protocol, but cannot on its own establish fidelity to the specimen. Narrow the title/claims if that broader evidence is unavailable.
- If a specimen's essential acquisition or sample identity cannot be recovered, replace or omit that example. If no tissue evidence survives, the author must explicitly revisit the biological-tissue scope; this is not a cosmetic caption change.
- New experiments are justified only by a named central claim that cannot be supported or responsibly narrowed using existing evidence. State the needed experiment and its schedule impact before starting another broad sweep.

Freeze a minimum evaluation protocol before final candidate ranking: what is being compared, metric and direction, valid common support, registration, intensity treatment, selection rule, and limitations. Audit previous selection honestly; fixing a protocol today does not turn already-inspected data into held-out validation. Broad quantitative or fidelity claims remain blocked until their required comparison protocol is qualified.

Measure from the appropriate numerical products. Record display filtering and clipping separately from analysis, especially for the recent capture-editor exports. Further editor/renderer development should stop unless a specific defect blocks an essential figure. The thesis now needs scientifically closed outputs more than additional tooling options.

## Keep supervisor review useful without creating another queue

Maintain one main chapter in active drafting, one small evidence-resolution task, and one chapter actively prioritized for supervisor review. Additional completed chapters may wait in a dated local queue; do not assume she accepts several simultaneous assignments. If her review is slower than chapter production, continue finishing chapters and keep the queue visible rather than repeatedly reopening finished prose.

At the first handoff, propose a review window of approximately one working week and ask her preferred cadence/order. This is a scheduling proposal, not an assumed commitment. Prefer early review of Chapter 5's scientific description and Chapter 3's model because corrections there affect much of the thesis. If she requires reading order, prepare Chapter 2 as the next handoff and continue the method/evidence work internally; the initial choice of Chapter 5 is conditional on her accepting out-of-order complete chapters.

For each returned chapter, record comments in [supervisor meetings](supervisor-meetings.md) or a linked response record with: exact issue, affected chapters, decision, and closure evidence. Reserve roughly one focused day per week for revisions within the total effort allowance; move that time to drafting when no comments are pending. A scientific blocker takes priority over this allocation. Supply a revised complete chapter plus a concise change summary when another review is needed.

Track these dates rather than a subjective percentage complete: **full draft → evidence checked → PDF checked → sent → feedback received → revision closed**. Until the first handoff, every chapter remains “not sent.” The useful weekly test is: which complete chapter left the writing queue, and which critical evidence gap was closed?

## Finish without a long integration tail

After Chapter 7 stabilizes, freeze the claims in the existing [claim tracker](claim-tracker.md). Check specifically whether “high-speed” and “high-fidelity” in the working title are supported as thesis findings or only motivations. Do not infer measured speed from snapshot acquisition, or fidelity from sharper-looking images. Adjust the scope/title through the author's decision if necessary.

In the final integration pass, check the model/method/setup index conventions; acquisition versus processing dates; historical versus new code revisions; selection versus evaluation; scene counts; all cross-references and bibliography entries; captions and physical scales; English/Hebrew consistency; and remaining placeholder appendices/front matter. Verify the maintained Technion template and use Hadar for communication/completeness comparison, without copying content.

**Replanning triggers:** no qualified candidate after the recovery decision window; Chapter 5 requires a different algorithm account; supervisor turnaround substantially exceeds the proposed cadence; or a central claim needs new acquisition. Each trigger requires a concrete scope/schedule decision, not another open-ended polishing cycle.

The submission deadline, available focused hours per week, and normal supervisor turnaround were requested during this assessment and are not yet known. Those three inputs should convert this work-block plan into dated milestones; they do not change the immediate priorities of evidence triage and a complete Chapter 5 handoff.
