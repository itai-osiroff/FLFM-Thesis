# Prose and Figure Standard

> **Status:** active
>
> **Reviewed:** 2026-11-08

Use this guide for sentences, paragraphs, figures, and captions. Use the
[thesis writing standard](writing-standard.md) for chapter pacing, placement of
evidence, and the reference hierarchy. Use the [technical writing
guide](technical-writing-guide.md) for model, algorithm, evaluation, and
provenance checks.

## Space check

Check the [authoritative structure and budget](revised-thesis-structure.md) before
editing a passage, adding a visual, or expanding a caption. Count prose/equation
space separately from figure/caption/table space. A suggested diagnostic or
illustration is not an automatic extra figure allowance. Preserve disclosures
needed to interpret the evidence, using linked supporting detail when appropriate.
Record an overrun for later migration or obtain explicit author approval to
change a target; the existing draft does not set the target.

## Prose

- Name the concrete problem or constraint before introducing the operation or
  equation that addresses it. Define technical terms at first use and use them
  consistently.
- Connect equations to what is measured or computed. Explain what the relation
  predicts or changes and give the assumptions that govern its use.
- Use direct, precise wording. State the sample, medium, acquisition, metric,
  and scope of the comparison as needed to bound each result. Distinguish
  observation, interpretation, and future work. Put failures, no-change cases,
  and protocol qualifications next to the evidence they qualify.

## Figures and captions

- Give each row and column a stable role across a comparison. Label conditions,
  panel meanings, physical scale where applicable, and display choices that
  affect interpretation. Use shared display limits for direct intensity
  comparisons. Disclose separate scaling and normalization when showing
  structure.
- Pair images with a diagnostic or reference when appearance alone cannot
  support the claim. For a stage comparison, pair the global-stage average
  with the final rectified image from the same run. State whether any reference
  informed selection, was used for evaluation, or served both roles.
- Make the caption understandable on its own. Give it a short descriptive
  opening. Identify the sample,
  conditions, comparison, and relevant settings. Orient the reader by panel,
  row, or column and state the observation the figure supports. Include
  relevant scale, comparison geometry, and display or processing disclosures.

## Editorial examples

These coauthored papers supply examples of communication. Ground thesis claims
in inspected primary sources or project code and data, and use original prose
and figures with project provenance.

| Paper | Example to consult |
| --- | --- |
| *Fluorescent wavefront shaping using incoherent iterative phase conjugation* ([DOI](https://doi.org/10.1364/OPTICA.458454)) | §2A connects the model and convergence equations to the optical process. Fig. 3 discloses normalization to each image's own maximum. |
| *Non-invasive and noise-robust light focusing using confocal wavefront shaping* ([DOI](https://doi.org/10.1038/s41467-024-49697-w)) | The score discussion explains why variance is unreliable for weak fluorescence before introducing the confocal score. Fig. 2 labels display ranges and identifies the pair with matched exposure and excitation power. |
| *Rapid wavefront shaping using an optical gradient acquisition* ([DOI](https://doi.org/10.1038/s41467-025-68259-2)) | Optical gradient acquisition starts from a measurement constraint. Fig. 4 uses fixed camera rows to show when a sharp main-camera spot fails to establish target-plane focusing. |
| *Understanding multi-layered transmission matrices* ([DOI](https://doi.org/10.1109/CVPR52734.2025.02157)) | Fig. 4 pairs reconstructed slices with fitting-error curves so readers can assess structural fidelity and fit separately. |
