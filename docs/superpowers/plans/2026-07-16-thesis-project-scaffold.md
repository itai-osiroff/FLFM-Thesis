# Thesis Project Scaffold Implementation Plan

> **Status:** historical
>
> **Reviewed:** 2026-09-24

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a writing-oriented thesis workspace with an Overleaf-ready LaTeX project and lightweight provenance records for computational outputs.

**Architecture:** The workspace is divided into editorial source, external literature, author-created supporting material, finalized outputs, computational provenance, and planning documents. Only `overleaf/` is intended to sync with Overleaf.

**Tech Stack:** LaTeX, BibTeX/Biber-compatible bibliography files, Markdown planning notes, YAML provenance records, local filesystem organization.

## Global Constraints

- Keep the thesis workspace focused on writing, citations, finalized outputs, and provenance.
- Do not move active research code, raw datasets, or large intermediate results into this workspace.
- Preserve existing external-versus-internal resource meaning during triage.
- Keep `overleaf/` lean enough to compile reliably in Overleaf.

---

### Task 1: Create Directory Structure

**Files:**
- Create: `overleaf/`
- Create: `literature/`
- Create: `research-context/`
- Create: `finalized-outputs/`
- Create: `supporting-material/`
- Create: `planning/`
- Create: `docs/superpowers/`

**Interfaces:**
- Consumes: Existing resource folders.
- Produces: Stable top-level structure for thesis work.

- [x] **Step 1: Create the top-level and nested directories**

Run: `New-Item -ItemType Directory -Force` for the planned folder tree.

Expected: The workspace contains `overleaf`, `literature`, `research-context`,
`finalized-outputs`, `supporting-material`, `planning`, and `docs`.

- [x] **Step 2: Move existing external resources**

Move existing articles, books, thesis examples, and external-resource notes into
`literature/`.

Expected: External PDFs are grouped by type under `literature/`.

- [x] **Step 3: Move existing internal resources**

Move author-created support files into `supporting-material/internal/`.

Expected: Internal resources are separated from external references.

### Task 2: Add Documentation Skeleton

**Files:**
- Create: `README.md`
- Create: `literature/README.md`
- Create: `research-context/README.md`
- Create: `finalized-outputs/README.md`
- Create: `supporting-material/README.md`
- Create: `overleaf/README.md`

**Interfaces:**
- Consumes: Directory structure from Task 1.
- Produces: Human-readable rules for where work belongs.

- [x] **Step 1: Add workspace README**

Create a README that states the workspace boundary: thesis writing and
provenance, not active computational research.

- [x] **Step 2: Add area READMEs**

Create a README in each major area describing what belongs there.

### Task 3: Add LaTeX Skeleton

**Files:**
- Create: `overleaf/main.tex`
- Create: `overleaf/frontmatter/abstract.tex`
- Create: `overleaf/frontmatter/acknowledgements.tex`
- Create: `overleaf/chapters/*.tex`
- Create: `overleaf/styles/macros.tex`
- Create: `overleaf/refs/thesis.bib`
- Create: `overleaf/latexmkrc`

**Interfaces:**
- Consumes: Overleaf folder from Task 1.
- Produces: A minimal compileable thesis skeleton.

- [x] **Step 1: Add `main.tex`**

Create a root LaTeX entrypoint with frontmatter, chapters, appendices, and
bibliography wired together.

- [x] **Step 2: Add chapter files**

Create chapter files matching the expected thesis argument.

- [x] **Step 3: Add bibliography and style files**

Create `refs/thesis.bib`, `styles/macros.tex`, and `latexmkrc`.

### Task 4: Add Provenance and Planning Templates

**Files:**
- Create: `research-context/result-provenance/figure-provenance-template.yaml`
- Create: `research-context/result-provenance/table-provenance-template.yaml`
- Create: `research-context/code-repositories.md`
- Create: `research-context/dataset-index.md`
- Create: `planning/thesis-outline.md`
- Create: `planning/writing-log.md`
- Create: `planning/supervisor-meetings.md`
- Create: `planning/open-questions.md`
- Create: `planning/claim-tracker.md`

**Interfaces:**
- Consumes: Thesis structure and result provenance rule.
- Produces: Editorial management and traceability templates.

- [x] **Step 1: Add provenance templates**

Create YAML templates for figures and tables.

- [x] **Step 2: Add research context indexes**

Create Markdown files for code repositories and datasets.

- [x] **Step 3: Add planning files**

Create outline, writing log, meeting notes, open questions, and claim tracker.

