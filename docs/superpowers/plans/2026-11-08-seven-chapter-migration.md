# Seven-chapter Thesis Migration Implementation Plan

> **Status:** historical — migration completed and verified
>
> **Reviewed:** 2026-11-08
>
> **For agentic workers:** use `superpowers:executing-plans` for the authorized
> inline implementation; check off tasks after verification.

**Goal:** align active documentation and the LaTeX structure with the author's
seven-chapter compact-thesis decision while preserving all manuscript content.

**Architecture:** documentation first, then structural wrappers and navigation.
The [authoritative structure and budget](../../../planning/revised-thesis-structure.md)
owns titles, placement, targets, exceptions, and inherited migration debt.

**Tech stack:** Markdown, PowerShell structural checks, Technion XeLaTeX/latexmk.

**Spec:** author-approved plan in this chat, 2026-11-08, and the authoritative
structure document. No new scientific verification or content revision is authorized.

## Constraints and review focus

- Preserve prose, equations, captions, tables, citations, figure assets,
  historical evidence, template, bibliography, and Hebrew/front/back matter.
- Retain setup overflow and both method figures as debt; do not change targets
  without an explicit recorded author decision.
- Distinguish active editorial pointers from historical paths within provenance.
- Preserve body order in each merge; repair chapter references mechanically.
- Require exactly seven ordered main chapters before the existing appendices;
  reject hidden extra chapter boundaries and obsolete source files.

## Tasks

- [x] Capture source/hash baseline at `e2b20ec2558f67dc10e95fcae900c40fca9d6f11`;
  run the existing validator and capture the baseline build/log/TOC.
- [x] Establish authoritative structure, space accounting, approval ledger, debt,
  and current-to-target ownership; update entry points and standards.
- [x] Revise active chapter specs/maps/trackers and current literature placements;
  preserve the November 3 assessment and source facts as historical records.
- [x] Add positive and negative fixture checks for the structural validator;
  watch the old validator reject the new structure and accept the old structure.
- [x] Move and merge chapter bodies, rename sources, update includes/titles/labels
  and mechanical chapter references, and repair current pointers.
- [x] Update the validator and run all structural regression cases.
- [x] Verify exact normalized body conservation and protected-file hashes;
  inspect active documentation links and obsolete placements.
- [x] Build and visually inspect TOC, chapter openings, merged sections, setup
  table, figures, and numbering; compare baseline warnings.
- [x] Obtain independent final review, address substantive findings, and record
  verified outcomes below and in the writing log.

## Verification record

Baseline: working tree clean; existing validator passed; `latexmk` reported the
existing thesis PDF up to date with exit 0. Baseline source copies, hashes, log,
TOC, and command output are kept in ignored `work/seven-chapter-migration/`.

Execution uses the existing checkout, as requested. No commits, pushes, online
sync, target departures, or content editing are implied by this migration.

### Final verification — 2026-11-08

- Live structural validator passed. Regression suite: **15/15** cases passed,
  including old nine-chapter layout, ordering, extra/duplicate inputs, titles,
  appendix boundaries, leftover legacy files, nested chapter/appendix inputs,
  cycles, and legitimate editable figure inputs.
- Red/green evidence: before the update, the validator rejected the valid new
  structure and accepted the old nine-chapter structure. Independent review then
  reproduced a nested-input boundary bypass. Three added regression cases failed
  before recursive input traversal/cycle protection and passed after the fix.
- All **nine original chapter bodies** match after removing only the added
  structural wrappers and normalizing mechanical chapter references. Both
  figure environments/captions, the table, five equation/align environments,
  and twelve citation groups match exactly. **Seventeen protected files**,
  including all figure assets, template/configuration, bibliography, front/back
  matter, and appendices, are byte-identical to baseline.
- `latexmk -interaction=nonstopmode -halt-on-error thesis.tex` passed. The full
  PDF has 45 pages, including matter excluded from the prose budget. Its only
  LaTeX warnings are the same baseline template class-name warning and two
  overfull boxes (5.2979 pt and 0.78401 pt); source line numbers changed. No new
  unresolved or multiply defined references appeared.
- Rendered and inspected PDF pages 5, 13, 17, 19–31, and 33: contents, all seven
  chapter openings, merged sections, moved setup table, both method figures,
  and equation/reference numbering. No migration-induced clipping or overlap
  was observed. Existing template hyperlink boxes were preserved.
- Changed Markdown local link targets exist. Stale chapter destinations in
  active guidance were checked; retained old paths/numbers are explicitly
  historical observations, source-book chapter numbers, or negative test cases.

### Rendered space baseline, not a new target

These rough editorial page equivalents use vertical occupancy within the normal
template text frame (approximately 70–744 pt), including chapter-opening title
space and prose spacing. Footer/forced blank pages are excluded, as are both
whole figure/caption pages and the setup table/caption region. Values are rounded
to a tenth; this is a dated planning estimate, not automatic page certification.

| Chapter | Approximate current prose/equation page equivalents |
| --- | --- |
| 1 | 2.2 |
| 2 | 0.3 |
| 3 | 1.7 |
| 4 | 3.2 |
| 5 | 3.6 |
| 6 | 0.3 |
| 7 | 0.5 |

The incomplete draft occupies roughly 11.8 prose/equation page equivalents by
this estimate; several chapters remain placeholders. This does not establish
that a completed thesis fits the budget. The introduction is near/above its
range, and setup/method reduction remains necessary. Visual footprint is
separate: two method figure/caption pages and one partial-page setup table.
No per-chapter TBD allocation or target departure was approved by this migration.

### Independent review disposition

The reviewer found no consequential manuscript/documentation mapping defect.
Its validator finding was fixed and verified by the failing-then-passing nested
input tests. Deliberately deferred under the author's scope: content overflow,
the extra method figure, scientific inconsistencies, and placeholders. Historical
chapter numbers/source paths remain history rather than current guidance. Plan
checkboxes and final records are now closed. No unresolved review finding remains.

Local baseline copies, preservation/hash report, warning comparison, space
estimate, and rendered QA pages remain under ignored
`work/seven-chapter-migration/`. This is a completed structural migration record;
future content work follows the authoritative structure and evidence standards.
