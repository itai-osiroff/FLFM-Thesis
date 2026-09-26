# Evidence-to-draft workflow with ARS-Codex

> **Status:** active
>
> **Reviewed:** 2026-09-26

This note adapts ARS-Codex as a broader writing aid for this repository. The
microscopy report supplies technical-reporting questions; ARS contributes the
sequence from evidence to argument, drafting, citation checks, and revision.
The [writing standard](writing-standard.md) and
[technical guide](technical-writing-guide.md) remain the local entry points.

## Context consulted

ARS-Codex **3.22.0**, `academic-research-suite`, was consulted through its router,
`ars/academic-paper/WORKFLOW.md`, and
`ars/academic-paper/references/writing_quality_check.md`. These are installed
plugin resources, not files vendored into this repository. Find the current
`ars-codex:academic-research-suite` skill through the available-skills catalog
when using the plugin; do not depend on one computer's cache path.

This integration used ARS as advisory workflow context. It did not run a full
paper pipeline, independent review panel, Material Passport verification,
retraction check, or submission-readiness assessment. No plugin configuration,
hooks, model routing, or external manuscript upload was configured. The local
process below also works when ARS is unavailable.

## Use the workflow for the actual task

| Writing need | ARS route, when invoked | Local starting material and output |
| --- | --- | --- |
| A genuinely unresolved research question | `deep-research`, Socratic scoping | [Open questions](open-questions.md); narrow the unresolved question with the author. Do not restart scoping for an already defined thesis section. |
| Find or check literature | `deep-research`, literature review / source verification | [Literature notes](../literature/notes/README.md), then primary passages and evidence notes. |
| Outline a section or chapter | `academic-paper`, outline/plan | [Outline](thesis-outline.md), [synthesis map](chapter-synthesis-map.md), claims and method evidence. |
| Draft technical prose | `academic-paper`, appropriate writing phase | [Stage worksheet](templates/technical-stage.md), exact implementation observation, and run provenance; produce a scoped draft. |
| Check references | `academic-paper`, citation-check | Actual cited passages and bibliography; distinguish existence, metadata, version, and claim support. |
| Review or revise a draft | `academic-paper-reviewer` for review; `academic-paper` for revision | Named draft and scope; actionable evidence-based findings, then authorized edits. |
| Full research-to-paper work | `academic-pipeline` only when that broader workflow is requested | Existing repository records as inputs; use the current plugin contracts if a formal pipeline is run. |

These routes describe intent, not a script that must run in full every session.
Load the current router and only the relevant workflow/references. Keep author,
institution, and thesis-template requirements ahead of generic journal defaults.
Do not automatically add journal declarations, change bibliography style, impose
a bilingual abstract pair, or change the thesis's research question based on
generic examples in a workflow.

## A practical session loop

1. **Bound the task.** Name the section, its scientific question, intended
   contribution, and allowed edit scope. Read existing prose before rewriting.
2. **Build the evidence packet.** Use selected primary-source passages, the
   applicable method-note revision, actual experiment records, and relevant
   claim-tracker entries. Record missing facts rather than filling them by analogy.
3. **Map the argument.** Connect each substantive claim to a source or result,
   its limitation, and its intended figure/equation. Distinguish observation,
   interpretation, model assumption, and future work. A novelty/absence claim
   needs a documented search scope and nearest relevant work, not just a citation.
4. **Draft.** Explain the scientific point before detail. Use the stage worksheet
   for completeness and discipline-specific terminology for clarity. An example
   thesis informs organization; write original prose from this project's evidence.
5. **Review evidence and presentation separately.** First check claim support,
   mathematical/code agreement, experiment selection, and figures. Then inspect
   paragraph logic, ambiguous terms, repetition, and sentence clarity. Style
   diagnostics are prompts for judgment, not word bans or fixed paragraph shapes.
6. **Record the outcome.** Update existing claims, open questions, provenance,
   and writing log as appropriate. State which checks were performed and what
   remains unresolved. Do not label an advisory pass as formal ARS verification.

Keep disagreements visible: identify the claim, evidence, and proposed action.
Use findings such as `supported`, `needs evidence`, or `outside scope`, rather
than an invented numerical writing-quality score. Do not equate metadata
verification with full-text reading or infer that the author read a source.

## Reusable prompts

**Draft a bounded technical section:**

> Draft [section] using planning/writing-standard.md and
> planning/technical-writing-guide.md. Use [method observation] and [run/source
> records] as the evidence packet. Preserve their version boundaries. Identify
> missing facts, define the necessary mathematics, and link claims to evidence.
> Apply the relevant ARS-Codex writing guidance if available.

**Review a technical draft:**

> Review [section] against the technical writing guide and [evidence packet].
> Check physical assumptions, notation/units, equations versus implementation,
> effective parameters, selection versus evaluation, and caption/provenance
> consistency. Return specific issues with locators and proposed corrections;
> distinguish unsupported claims from stylistic suggestions.

**Verify a citation:**

> Check whether [exact source/version and passage] supports [exact claim].
> Record the inspected locator, bibliographic identity, supported scope, and
> access limitations. Do not treat a secondary report's citation marker as evidence.

## Existing records remain authoritative

Use the claim tracker for claims, open questions for unresolved decisions,
method notes for implementation observations, and result-provenance files for
experiments/figures. This note is not a parallel scientific ledger or a custom
ARS schema. Only a later explicit formal ARS workflow should create its own
required artifacts, with links back to these records and honest verification
status. Keep private drafts local unless an authorized task requires sharing.
