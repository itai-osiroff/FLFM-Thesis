# Thesis Writing Standard

> **Status:** active
>
> **Reviewed:** 2026-11-08

Use this standard for the thesis argument, chapter organization, and placement
of evidence. The Technion template governs formatting.
[Hadar's thesis](../literature/thesis-examples/hadar-reference-standard.md)
is the primary comparative reference for structure, pacing, and completeness.
Use the [prose and figure standard](prose-and-figure-standard.md) for local
editorial choices. It draws examples from four Levin-group papers.

For algorithmic, mathematical, physical-model, and evaluation sections, use the
[technical writing guide](technical-writing-guide.md) and its
[stage worksheet](templates/technical-stage.md). They adapt the
[microscopy-writing report](../literature/writing-guidance/README.md) into
project-specific checks. Use the [ARS workflow note](ars-writing-workflow.md)
for the broader evidence-to-draft process. These aids do not replace source
evidence, institutional requirements, or Hadar's comparative role.

## Structure, space, and reporting depth

Use the [authoritative structure and budget](revised-thesis-structure.md) before
outlining, drafting, or reviewing. Its author-approved targets take precedence
over comparative thesis lengths or older chapter plans. Flag current/projected
overruns at the affected passage or visual; record inherited migration debt
separately from explicitly approved departures.

Give each chapter only the explanation it owns. Keep the main argument
understandable within its allowance and place detailed technical reporting in
appendices or linked evidence records as assigned by the structure. Completeness
of evidence does not require exhaustive main-text prose or a new figure for each
stage. Do not reduce scientific qualifications to make the page count fit.

## Argument and chapter flow

- Start every chapter with the question it answers and end it by stating what
  has been established and what remains unresolved.
- Keep the narrative order visible: motivation and prior work, model or method,
  experimental/evaluation evidence, then interpretation and limitations.
- Do not introduce new evidence in Discussion and Conclusions; use that
  combined chapter to interpret results already shown.

## Scope of the reconstruction method

- Present global alignment followed by local pixelwise refinement as one
  two-stage reconstruction method. Describe its stages separately only to
  explain their operations. The global-stage average is an intermediate image
  from that run; the final rectified image is the average after local
  refinement. Saved names such as `local_average` refer to this final image.
- A comparison of those two images tests the contribution of local refinement
  within the same run, not two independently selected reconstruction methods.

## Placement of evidence and visuals

- Each figure or table must answer one declared scientific question and support
  a specific claim tracked in the project.
- Sequence visuals from system/model or setup, through method, to result and
  evaluation; do not use a result panel without enough context to interpret it.
- Present failure modes, no-change cases, and protocol limits alongside the
  relevant results. Use the discussion to interpret their implications.
- Use only finalized assets with a completed provenance record; do not treat a
  deck screenshot or exploratory output as final evidence.

## Reproducibility and originality

- Keep methods traceable to the exact code, data, parameters, and evaluation
  protocol described by existing provenance records.
- Use thesis references to learn organization and communication, never as a
  source to copy. The active thesis remains original in text, evidence, figures,
  and scientific claims.
