# Thesis Project Structure Design

## Purpose

This workspace supports writing a LaTeX thesis on light field microscopy for
high-speed, high-fidelity recovery of aberrated 2D fluorescent scenes through
diffusive biological tissues.

The project is primarily editorial. It stores thesis text, external sources,
author-created supporting material, finalized figures and tables, and compact
provenance records for computational results. It does not attempt to store or
reproduce the full computational research pipeline.

## Boundaries

This repository should contain:

- Compileable LaTeX thesis source.
- Literature PDFs and reading notes.
- Thesis examples used for structure, tone, and wording.
- Finalized figures and tables used in the thesis.
- Small provenance records linking results to code, data, parameters, and dates.
- Planning records for outlines, supervisor meetings, writing status, and open questions.

This repository should not contain:

- Full raw datasets.
- Active research code as a primary development target.
- Large intermediate experiment outputs.
- Uncurated paper dumps without notes or indexing.

## Directory Structure

```text
Thesis/
  overleaf/
  literature/
  research-context/
  finalized-outputs/
  supporting-material/
  planning/
  docs/superpowers/
```

`overleaf/` is the LaTeX project that can be synced with Overleaf. It contains
only the files needed to compile the thesis: `main.tex`, chapters, frontmatter,
appendices, styles, bibliography, figures, and tables.

`literature/` stores external material, including articles, books, thesis
examples, and reading notes.

`research-context/` stores lightweight pointers to the computational work:
code repositories, dataset indexes, experiment summaries, method notes, and
figure/table provenance records.

`finalized-outputs/` stores polished outputs that may be copied into
`overleaf/figures/` or `overleaf/tables/` once selected for the thesis.

`supporting-material/` stores author-created text, diagrams, draft resources,
and other thesis-supporting material that is not part of the compileable LaTeX
project.

`planning/` stores thesis-level editorial management files.

## Overleaf Workflow

The recommended workflow is to sync only `overleaf/` with Overleaf, while the
broader workspace remains local. Overleaf should remain lean and compileable.

Two practical sync options are supported:

1. Treat Overleaf as a Git remote for the `overleaf/` project.
2. Use a GitHub repository as the canonical source and connect Overleaf to it.

The first option is simplest if Overleaf is the main editor. The second is
better if GitHub branches, issues, and pull requests become important.

## Provenance Rule

Each finalized figure or table used in the thesis should have a provenance
record under `research-context/result-provenance/`. The record should identify
the source code repository, commit, dataset, script or notebook, parameter file,
generation date, copied output path, and thesis location.

## Existing Resource Triage

Existing external resources were mapped into `literature/`:

- Articles moved to `literature/articles/`.
- Books moved to `literature/books/`.
- Thesis examples moved to `literature/thesis-examples/`.

Existing author-created supporting material was mapped into
`supporting-material/internal/`.

## Success Criteria

- The thesis LaTeX source has a clear Overleaf-ready home.
- External and internal supporting resources are separated.
- Computational context is traceable without making this workspace the main
  code or data repository.
- A future reader can understand what belongs where from the README files.

