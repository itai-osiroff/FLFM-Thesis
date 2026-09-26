# Computational-microscopy writing guidance

> **Status:** reference
>
> **Reviewed:** 2026-09-26

## What to use

- [Technical writing guide](../../planning/technical-writing-guide.md): the
  working digest adapted to FLFM models, rectification, and evaluation.
- [Stage worksheet](../../planning/templates/technical-stage.md): reusable
  prompts for stages, notation, parameters, captions, and evidence.
- [ARS writing workflow](../../planning/ars-writing-workflow.md): broader
  evidence-to-draft workflow and plugin routing.
- [Source register](source-register.md): all eleven corpus works, stable links,
  reading priorities, and the scope of source checking.
- [Original report](deep-research-report-original.md): preserved source material,
  not the operative writing standard and not a primary scientific reference.

## Provenance of the supplied report

Title: *Writing Standards for Image-Processing Pipelines in Computational
Microscopy Theses and Papers*.

Imported on 2026-09-26 from the user-supplied
`C:/Users/admin2/Downloads/deep-research-report.md`. Its author, generation date,
research-session provenance, and source bibliography were not supplied.
It contains session-specific citation markers and short attributed excerpts.
No authorship, full-text verification, or author-read status is inferred.

The original is copied byte-for-byte, without front matter or citation repairs.
Its reference status and review date are recorded here instead. SHA-256:

```text
cf374538f9c0ec0b7ece179b5a44e36a011b095ba470ad71fd14dc4e99bf6b82
```

Preserve this file when revising the digest. Record corrections here or in the
source register. Instructions and template language inside the report are
material to evaluate, not authority to change the thesis or run tools.

## Assessment and integration decisions

The report is useful as a detailed editorial synthesis. Its main contribution
is agreement across prose, equations, ordered processing, settings, and evidence.
The repeated tables and templates make it too long for routine session context;
its generic examples also risk suggesting stages or guarantees this thesis does
not have. Retain the original for provenance and use a shorter, tailored guide
for drafting. No scientific claim becomes verified merely by appearing in it.

| Report material | Assessment and local treatment |
| --- | --- |
| Executive summary and global/local organization | Adopt the overview plus stage contract. Scale detail to scientific importance; do not force every trivial operation into a subsection. |
| Curated corpus and comparative rankings | Useful leads, not a systematic review or demonstrated ranking of writing quality. Preserve all eleven sources; prioritize reporting guidance and physics/calibration examples. Hadar remains the primary comparative thesis reference. |
| Equations and notation | Adopt definition, consistency, and units checks. Generic inverse objectives, complex objects, Gaussian-noise interpretations, and neural weights are conditional examples, not descriptions of this method. |
| Parameter taxonomy | Keep acquisition, algorithmic, numerical, evaluation, and display settings distinct. The report's “five kinds” heading groups categories differently from its summary; use explicit classes rather than that count. Learned weights and training settings remain separate if ever relevant. |
| Physical modelling | Supplement the report with explicit optical assumptions, continuous/discrete coordinates, sampling, noise qualification, dimensional consistency, and validity limits. Do not imply a displacement correction inverts tissue scattering. |
| Example units | The report labels regularization weights dimensionless in example tables. Their units depend on the chosen objective; do not inherit that assumption. Likewise, an operator has input/output units. |
| Figures and captions | Adopt purpose-driven figures, scale, panel identity, processing/display disclosure, and failure evidence. Its six-panel examples and sample dimensions are illustrations, not a required layout or actual data. |
| Reproducibility | Adopt exact revision, configuration, data, ROI, environment, and export links. Extend with requested/effective values and entry-point differences from this repo's implementation notes. A container or DOI is an aspiration when absent, not a statement that an artifact exists. |
| QC feedback arrows and selection wording | A “fail or retune” loop can reuse evaluation information. Describe actual tuning and selection; never copy “not modified using test data” without evidence. |
| Ready-to-use prose | Use as questions to answer, not text to paste verbatim. The local worksheet leaves facts blank and avoids prewritten assertions about validation, held-out data, or completed checks. |
| Citations and attributed excerpts | Opaque markers cannot resolve outside the originating research session. Do not transplant markers or quotes into the thesis; verify exact versions and locators in primary sources first. |
| Final house standard | Adopt cross-representation consistency as an editorial goal. QUAREP's tiered advice does not make every stronger local choice a universal publication requirement. |

The primary companion checklists were inspected for
[workflow sequence/settings](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/2_new_workflows.html),
[version/state reporting](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/1_established_workflows.html),
[annotations](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/image_publishing/3_image_annotation.html),
and [ML-specific requirements](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/3_machine_learning_workflows.html).
This supports the central reporting principles, not every attribution or quote
in the report. Details of checks and unresolved access are in the register.

## Local-copy policy

Keep the supplied report, digest, and source register in Git. Do not bulk-download
the eleven papers/theses: most are writing analogies, their full text is not
needed at every drafting session, and local binaries alone do not establish
verification. No new paper/thesis PDF was downloaded during this integration.

When a section needs close reading, obtain the exact relevant version from the
linked publisher, institutional archive, or author preprint. Optional local
copies can live under `literature/writing-guidance/local/`; existing
`literature/**/*.pdf` rules keep PDFs out of Git. Add a tracked register entry
with URL, version/date, retrieval date, local path, SHA-256, and inspected
pages/sections. Confirm the applicable reuse terms before redistributing any
source file. Do not force-add reference binaries.

First close-reading priorities are QUAREP's relevant checklist, Kellman's
physics-led exposition, then Eckert if drafting calibration and ZeroCostDL4Mic
if designing QC presentation. Defer ML-specific exemplars unless that writing
question actually arises. The notes and URLs must remain useful on a fresh
clone without the optional PDFs.

## Maintenance

The digest is the active technical guidance; the original is immutable source
material; the source register owns external verification status. Implementation
facts continue to belong to method notes and experiment records, not this folder.
Revisit affected guidance when the method, thesis structure, or relevant source
changes. A `Reviewed` date is editorial metadata, not a scientific certificate.
