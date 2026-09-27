# Technical writing guide: models, algorithms, and evaluation

> **Status:** active
>
> **Reviewed:** 2026-09-26

Use this alongside the [writing standard](writing-standard.md) when drafting
technical sections. It digests the supplied microscopy-writing report and adapts
it to this thesis. It is a project editorial standard, not evidence for a
scientific claim. The [assessment and source register](../literature/writing-guidance/README.md)
record its provenance and verification limits.

## Start a writing session

1. Identify the chapter's question and the exact section being written in the
   [chapter synthesis map](chapter-synthesis-map.md).
2. Select the relevant primary literature and implementation observation from
   the [method notes](../research-context/method-notes/rectification-pipeline/README.md).
   For an experimental statement, open its actual saved configuration and
   result-provenance record too.
3. Fill the relevant fields in the [stage worksheet](templates/technical-stage.md).
   Store a completed method worksheet beside its method notes, or experiment
   details beside the corresponding provenance record. Link to existing records
   instead of creating competing copies of parameter values.
4. Write connected prose from the worksheet. Use the checklist below to find
   omissions; eight worksheet fields need not become eight thesis headings.
5. Record consequential evidence gaps in [open questions](open-questions.md),
   supported claims in the [claim tracker](claim-tracker.md), and completed work
   in the [writing log](writing-log.md).

## Explain the whole transformation before its stages

Begin with the measured data, the scientific output, and the sequence connecting
them. Put a compact overview figure near this explanation. Label important
arrows with data objects; show calibration, references, optional branches, and
manual choices where they actually enter. Show only operations used in the
described path. A generic acquisition-to-segmentation diagram is not a
description of the FLFM rectifier.

For the thesis's two-stage path, organize the account around view extraction, global
translation, the selected local reference, local displacement estimation,
backward remapping, and averaging. Describe extraction/HDR only for the relevant
entry point. Place sweep ranking and external-camera comparison in a distinct
evaluation branch. A feedback arrow from evaluation to tuning requires explicit
disclosure of that selection procedure.

Treat the global-stage average as an intermediate product of that path and the
post-refinement average as its final rectified image. A comparison between them
can assess the added local stage if both images come from the same documented
run. Do not outline standalone global or pixelwise software modes as thesis
methods. Historical source notes may describe those available modes as code
behavior, but they do not establish that the thesis used them.

This follows the sequence-reporting principle in
[QUAREP-LiMi's new-workflow checklist](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/2_new_workflows.html).
The particular FLFM organization is this project's adaptation.

## Give every substantive stage a complete description

| Element | Questions to answer |
| --- | --- |
| Purpose and assumptions | What problem does the stage address? Under what physical, statistical, or numerical conditions is it meaningful? |
| Input | What is measured or derived? Give axes, shape, datatype, units, spatial sampling, and preprocessing state when relevant. |
| Operation | What is computed, and in what order? Separate estimation copies from the intensities eventually reconstructed. |
| Mathematics or algorithm | Define the transformation, score, or objective precisely. Explain each symbol and its relationship to the implementation. |
| Parameters | Give effective values, units, scope, and how values were selected. Link the table/configuration. |
| Implementation | Identify the entry point, revision, dependencies, interpolation, boundary handling, precision, and branching that affect the result. |
| Output | Name its meaning, shape, units, changed sampling, and consumer in the next stage. |
| Checks and limits | State actual diagnostics, failure criteria, and available evidence. Separate a proposed check from one performed. |

Give the reason for a consequential choice, but do not invent an experimental
justification. "Chosen empirically; selection record unavailable" is preferable
to claiming a validation study that was never recorded.

## Build mathematics from the physical question to the implemented operation

Distinguish four different statements:

- A physical image-formation model describes how a specimen produces data.
- A simplifying model states which effects are retained or neglected.
- An estimator specifies how unknown quantities are inferred from data.
- A numerical procedure describes how that estimator is evaluated in code.

For a physical model, state the measured quantity (intensity, counts, field,
etc.), object domain, coordinate systems, optical assumptions, sampling, and
calibration dependencies before the derivation. Explain approximations and the
regime in which they are intended to hold. Define continuous-to-discrete
conversion and any scale factors used to compare physical units with pixels.
An incoherent fluorescence intensity model must not inherit a complex-field
interpretation merely because a phase-imaging example uses one.

Use a noise distribution only when justified; writing an additive noise term
does not establish independent, Gaussian, or signal-independent noise. A
displacement model does not establish recovery of a wavefront, scattering
operator, or three-dimensional object. Mark conceptual models separately from
code-derived equations and measured conclusions.

For this rectifier, describe the actual bounded displacement search and
aggregation. Do not insert a generic regularized inverse objective, proximal
solver, or learned model to make the method look more formal. If later work
does use one, specify its likelihood/objective, constraints, initialization,
update, stopping rule, and evidence for convergence or optimality as applicable.

For every equation, check:

- Each symbol has one meaning, with domain, dimensions, units, and index range.
  Distinguish view indices, pixel coordinates, candidate shifts, and iterations.
- Coordinate origin, row/column versus x/y order, and displacement sign agree
  with the sampling implementation. Distinguish forward motion from backward
  sampling; name the grid on which displacement units are defined.
- Sums/means state their support, masks, weights, and denominator. Explain
  interpolation and out-of-bounds contributions.
- Normalization states its exact formula and behavior at zero or near-zero
  denominators. Thresholds identify both their scale and the image used to
  compute that scale.
- Terms added in an objective have compatible units; a regularization weight
  is not automatically dimensionless. An abstract operator has input/output
  units even when it has no single scalar unit.
- Any local argmax specifies its candidate set and tie behavior. An argmax
  over a finite set does not establish global optimality of image recovery.
- The scientific source or code revision supporting the equation is identified.
  Important expressions have an intuitive explanation and a stage association.

Reuse existing chapter notation before introducing new conventions. The report's
theta/phi/omega assignments are examples, not a mandate. Keep one shared notation
table for recurring quantities; a small one-use variable can be defined inline.

## Preserve the thesis's implementation boundaries

The following guardrails come from the
[September 25 source account](../research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md)
at `algo` commit `d0e08634e71ca0ecc4766e46de9e33d2d351d06a`.
They are not a fresh code audit or proof of historical experiment settings.

| Topic | Writing constraint and evidence location |
| --- | --- |
| Global alignment | One translation per view, not rotation/scale/general affine correction; source account section 4. |
| Matching versus reconstruction | Thresholded matching copies and reconstructed intensities have distinct roles; sections 4–5. |
| Local score | Use the exact intensity-product normalization, not an unsupported NCC/ZNCC label; section 5.3. |
| Smoothness | Gaussian averaging of score evidence does not impose a smooth displacement field; optional field smoothing is separate; sections 5.3 and 5.5. |
| Reference choice | Center, global average, and optional rebuilt references must be tied to the selected path/configuration; section 6. |
| Remap and mean | Describe backward sampling, interpolation, boundaries, and the arithmetic mean, including edge contributions; sections 4.2 and 5.6. |
| Defaults | Interactive, API, direct-class, and sweep behavior may differ; requested settings can be transformed into effective values; section 12.1. |
| Scoring | Separate the in-loop displacement score, completed-image ranking, and external-reference evaluation; section 10. |
| Optional behavior | HDR, auxiliary scores, reference rebuilding, and power/blend modes belong only to experiments that used them; sections 6–9. |
| Scientific scope | Registration and aggregation of a nominally 2D scene do not establish full scattering inversion or volumetric reconstruction; section 13. |

The June 3 eyedrop candidate still lacks a historical source commit in its
[provenance](../research-context/result-provenance/fig_eyedrop_3_6.yaml).
Do not fill that gap using the September checkout. Likewise, an external-camera
image used to select the best candidate is not an independent held-out test of
that selected candidate. State whether the reported comparison is exploratory,
oracle-selected, or evaluated on data excluded from selection.

## Record parameters and reproducibility without burying the method

Classify acquisition/calibration, algorithmic, numerical, evaluation, and
display settings separately. If a learned stage is actually introduced, keep
weights separate from training hyperparameters and inference settings.

For each outcome-sensitive parameter record its symbol/config key, requested
and effective value, units/grid, fixed or per-image scope, selection rule,
selection dataset, tested range, and evidence locator. Use `unknown` for absent
records and `not applicable` with a reason. Never substitute current defaults
for an experiment configuration.

Connect a representative figure to input identifiers, calibration/ROI files,
code revision, command/entry point, effective configuration, environment,
generated output, evaluation, and display export. Reuse the existing
[figure](../research-context/result-provenance/figure-provenance-template.yaml)
and [table](../research-context/result-provenance/table-provenance-template.yaml)
provenance templates; put additional relevant detail in the linked worksheet
or run record. Distinguish reproducibility documentation from an actually
successful replay. Note seeds and hardware only where consequential.

## Figures and where details belong

Use an overview for sequence, a model schematic for physical assumptions, an
intermediate-image comparison for a stage's effect, and diagnostics for its
limitations. A sensitivity plot or ablation supports only the tested range and
protocol; do not imply one exists because the template asks about it.

Captions identify the sample/condition, panels, matched field of view, physical
scale, annotations, display mapping, and supported conclusion. Keep analysis
operations distinct from visualization. Declare unequal display limits and
resampling when they affect comparison. This use of scale, annotations, and
processing disclosure is consistent with
[QUAREP-LiMi's annotation guidance](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/image_publishing/3_image_annotation.html).

| Destination | Content |
| --- | --- |
| Model/degradation chapters | Image formation, assumptions, physical interpretation, sampling, validity limits. |
| Method chapter | Actual transformations, defining equations, essential score normalization, references, remapping/aggregation, principal settings and limitations. |
| Setup/evaluation chapter | Acquisition/calibration, datasets, selection protocol, metric definitions, comparison registration, exclusions. |
| Results/discussion | Observations with provenance, uncertainty and failure cases, then bounded interpretation. |
| Appendix/repository | Longer derivations, exhaustive configurations, environments, secondary branches and sensitivity results. Keep anything needed to identify the method in the main account. |

## Review before promoting a draft

- [ ] Prose, diagram, equations, configuration, and provenance describe the same path.
- [ ] Models/assumptions are distinguished from implementation and measured evidence.
- [ ] Inputs, outputs, units, coordinates, score definitions, and boundary behavior are clear.
- [ ] Parameters include effective values and selection provenance; missing facts are visible.
- [ ] Candidate selection and evaluation data roles are explicit; no unsupported held-out claim.
- [ ] Captions disclose scale, comparison geometry, processing, and display choices.
- [ ] Failure conditions and unperformed checks are honestly labeled.
- [ ] Citations support the adjacent claims and identify the exact source version.

This is an editorial review, not certification of correctness or reproducibility.
