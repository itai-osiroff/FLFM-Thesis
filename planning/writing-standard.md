# Thesis Writing Standard

> **Status:** active
>
> **Reviewed:** 2026-09-26

Use this standard while outlining, drafting, revising, and selecting figures.
It reflects the project's primary comparative reference while remaining an
independent, evidence-led standard for this thesis.

For algorithmic, mathematical, physical-model, and evaluation sections, use the
[technical writing guide](technical-writing-guide.md) and its
[stage worksheet](templates/technical-stage.md). They adapt the
[microscopy-writing report](../literature/writing-guidance/README.md) into
project-specific checks. Use the [ARS workflow note](ars-writing-workflow.md)
for the broader evidence-to-draft process. These aids do not replace source
evidence, institutional requirements, or Hadar's comparative role.

## Argument and chapter flow

- Start every chapter with the question it answers and end it by stating what
  has been established and what remains unresolved.
- Keep the narrative order visible: motivation and prior work, model or method,
  experimental/evaluation evidence, then interpretation and limitations.
- Do not introduce new evidence in the discussion or conclusion; use those
  chapters to interpret results already shown.

## Claims and tone

- Present global alignment followed by local pixelwise refinement as one
  two-stage reconstruction method. Describe its stages separately only to
  explain their operations. The global-stage average is an intermediate image
  from that run; the final rectified image is the average after local
  refinement. Saved names such as `local_average` refer to this final image.
- A comparison of those two images tests the contribution of local refinement
  within the same run, not two independently selected reconstruction methods.
- Define technical terms at first use and use the project terminology
  consistently.
- State the sample, medium, acquisition, metric, and comparison boundary that
  supports every result claim.
- Prefer direct, precise sentences over promotional language. Separate an
  observed result, its interpretation, and a future-work hypothesis.
- State failure modes, no-change cases, and protocol limitations next to the
  evidence they qualify.

## Figures, tables, and captions

- Each figure or table must answer one declared scientific question and support
  a specific claim tracked in the project.
- Sequence visuals from system/model or setup, through method, to result and
  evaluation; do not use a result panel without enough context to interpret it.
- Make captions standalone: identify the data or sample, condition/parameters,
  comparison, panel meanings, and the supported takeaway.
- Use only finalized assets with a completed provenance record; do not treat a
  deck screenshot or exploratory output as final evidence.

## Reproducibility and originality

- Keep methods traceable to the exact code, data, parameters, and evaluation
  protocol described by existing provenance records.
- Use thesis references to learn organization and communication, never as a
  source to copy. The active thesis remains original in text, evidence, figures,
  and scientific claims.
