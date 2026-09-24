# Thesis Workspace

> **Status:** active
>
> **Reviewed:** 2026-09-24

This repository supports writing a thesis on light-field microscopy through
writing materials, research context, literature, and provenance records. It is
not the main computational research repository: keep active code, raw data, and
large experiment outputs in their own repositories or storage locations.

## Start Here

- [Planning guide](planning/README.md): thesis structure, writing workflow, and
  open decisions.
- [Research context guide](research-context/README.md): evidence maps, datasets,
  experiments, methods, and result provenance.
- [Literature guide](literature/README.md): external sources and reading notes.
- [Overleaf project guide](overleaf/README.md): active LaTeX source and sync
  boundary.
- [Candidate outputs guide](candidate-outputs/README.md): provisional figures
  and tables awaiting evidence checks and selection.
- [Finalized outputs guide](finalized-outputs/README.md): figure and table
  assets selected for thesis use.
- [Supporting material guide](supporting-material/README.md): author-created
  material outside the LaTeX project.
- [Documentation archive guide](docs/superpowers/README.md): dated design and
  implementation records.

## Workspace Boundaries

Keep `overleaf/` focused on thesis source, its active bibliography, and assets
used by the thesis. Keep external references, drafts, research evidence, and
provenance notes in their corresponding areas. Keep provisional assets in
`candidate-outputs/`. After selection, preserve their source and export in
`finalized-outputs/` and record their origin under
`research-context/result-provenance/`.

Hadar's thesis is the primary comparative thesis reference because it shares
the supervisor and field. Use it to inform scholarly presentation, not as a
source of thesis content. The [reference note](literature/thesis-examples/hadar-reference-standard.md)
and [writing standard](planning/writing-standard.md) describe that boundary.

## Document Status Labels

- **active**: current working guide, index, or tracker.
- **draft**: incomplete authored material.
- **candidate**: provisional evidence or outputs awaiting selection or checks.
- **reference**: retained background or research notes.
- **historical**: completed or superseded plan, spec, or audit record.
- **template**: reusable blank structure.

Each Markdown document also has a `Reviewed` date for editorial review. It does
not certify that scientific claims or source data were revalidated on that date.
