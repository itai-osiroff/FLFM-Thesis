# Technion XeLaTeX Migration Implementation Plan

> **Status:** active
>
> **Reviewed:** 2026-09-24

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the generic `overleaf/` scaffold with the pinned Technion
`iitthesis` XeLaTeX project while preserving all authored thesis text and
bibliographic sources.

**Architecture:** Vendor the complete pinned upstream template into
`overleaf/`, then replace only its sample content with adapted copies of the
active chapters, front matter, bibliography, and local macros. The new entry
point owns Technion-required metadata and page ordering; authored material
remains in clearly separated `main/`, `front/`, `back/`, and `misc/` files.

**Tech Stack:** XeLaTeX, latexmk, Biber, makeglossaries, the pinned
`eyalroz/technion-iit-thesis` commit `93638a90dc02823f9715402f238c3bfce9424b69`.

**Spec:** `docs/superpowers/specs/2026-07-28-technion-thesis-upstreams-design.md`

## Global Constraints

- Vendor the pinned upstream template; do not depend on a network fetch at build time.
- Retain all authored chapters, appendices, bibliography, and macros; do not import reference-thesis prose, figures, or bibliography.
- Configure `latexmk thesis` and Overleaf for XeLaTeX.
- Preserve Technion English/Hebrew front- and back-matter handling.
- Do not commit generated LaTeX artifacts or PDFs.
- Record provenance and add the fetch-only `technion-template` remote.

## Review Focus

- A build run uses XeLaTeX rather than pdfLaTeX and completes Biber and glossary steps.
- Every chapter and appendix from the current generic entry point is included exactly once in the migrated entry point.
- The source bibliography is reachable by `biblatex`/Biber and contains no broken citations during compilation.
- Required English and Hebrew metadata fields are present, with clear author-completion placeholders where personal data is unavailable.
- The generated PDF contains the Technion front matter, English thesis body, bibliography, and Hebrew back matter in the template’s prescribed ordering.

---

### Task 1: Establish an isolated migration baseline

**Files:**
- Modify: `.gitignore` only if a project-local worktree directory is absent from ignore rules
- Create: no project file
- Test: `overleaf/` baseline compile log (untracked/temporary)

**Interfaces:**
- Consumes: the current `main.tex`, all authored `.tex` inputs, and the upstream pin.
- Produces: a clean isolated worktree and a recorded baseline failure/success state.

- [ ] **Step 1: Create or select an isolated worktree**

Run the worktree detection workflow. If the current checkout is not already a
linked worktree, create a `codex/technion-xelatex-migration` worktree using the
platform worktree facility; do not copy uncommitted changes.

- [ ] **Step 2: Verify the source baseline**

Run: `git status --short` and `rg -n "^\\\\input|^\\\\bibliography|^\\\\documentclass" overleaf/main.tex`

Expected: a clean baseline and an inventory of every source file that must be
preserved.

- [ ] **Step 3: Run the pre-migration build probe**

Run: `Set-Location overleaf; latexmk -pdf main.tex`

Expected: either a successful generic-PDF build or an environment-specific
failure recorded before migration. This is a configuration migration, so the
build probe is the test-first evidence instead of a unit test.

- [ ] **Step 4: Commit only an ignore-rule change if one was required**

Run: `git add .gitignore; git commit -m "chore: ignore local worktrees"`

Expected: no commit if `.gitignore` was already sufficient.

### Task 2: Vendor the pinned Technion template and preserve provenance

**Files:**
- Create: `overleaf/thesis.tex`, `overleaf/front/`, `overleaf/main/`, `overleaf/back/`, `overleaf/graphics/`, `overleaf/misc/`, `overleaf/.latexmkrc`, `scripts/verify-template.ps1`
- Modify: `planning/upstreams.md`, `overleaf/README.md`
- Delete: obsolete generic scaffold files only after their authored contents have been migrated
- Test: upstream pin, file inventory, and a template-only XeLaTeX build

**Interfaces:**
- Consumes: the exact GitHub commit listed in the spec.
- Produces: a self-contained copy of the maintained `iitthesis` class and its support files.

- [ ] **Step 1: Verify that the pin resolves before copying files**

Run: `git ls-remote https://github.com/eyalroz/technion-iit-thesis.git` and
fetch the commit into a temporary clone outside the repository.

Expected: `93638a90dc02823f9715402f238c3bfce9424b69` is available locally before
any template file is copied.

- [ ] **Step 2: Copy the upstream template verbatim into `overleaf/`**

Copy `thesis.tex`, `.latexmkrc`, and the upstream `front/`, `main/`, `back/`,
`graphics/`, and `misc/` directories. Preserve the source file names and
contents until Task 3 replaces example text with authored material.

- [ ] **Step 3: Add a failing structural migration check**

Create `scripts/verify-template.ps1` that exits nonzero unless all of the
following exist: `thesis.tex`, `misc/iitthesis.cls`, `misc/iitthesis-extra.sty`,
`misc/thesis-fields.tex`, and `.latexmkrc`; it must also require that
`.latexmkrc` invokes `xelatex` and `thesis.tex` uses `misc/iitthesis`.

- [ ] **Step 4: Run the structural check and confirm it initially identifies missing migration edits if applicable**

Run: `powershell -ExecutionPolicy Bypass -File scripts/verify-template.ps1`

Expected: PASS after the upstream template has been copied; if any required
item is missing, correct the copied template before proceeding.

- [ ] **Step 5: Record the vendored revision and remote**

Add the fetch-only remote `technion-template` pointing to
`https://github.com/eyalroz/technion-iit-thesis.git`, then update
`planning/upstreams.md` to say that the active project vendors the exact pin.
Update `overleaf/README.md` to name `thesis.tex` as the compile target and
XeLaTeX as the required Overleaf compiler.

- [ ] **Step 6: Commit the vendored template foundation**

Run: `git add overleaf planning/upstreams.md; git commit -m "build: vendor Technion XeLaTeX thesis template"`

Expected: the commit contains no generated auxiliary or PDF files.

### Task 3: Migrate authored content into the Technion structure

**Files:**
- Create: `overleaf/main/01_introduction.tex`, `overleaf/main/02_background.tex`, `overleaf/main/03_light_field_model.tex`, `overleaf/main/04_aberration_and_scattering.tex`, `overleaf/main/05_reconstruction_method.tex`, `overleaf/main/06_experimental_setup_evaluation.tex`, `overleaf/main/06_results.tex`, `overleaf/main/07_discussion.tex`, `overleaf/main/08_conclusion.tex`, `overleaf/main/a_derivations.tex`, `overleaf/main/b_additional_results.tex`, `overleaf/back/thesis.bib`, `overleaf/misc/my-thesis-specific.tex`
- Modify: `overleaf/thesis.tex`, `overleaf/misc/thesis-fields.tex`, `overleaf/front/abstract.tex`, `overleaf/front/personal-acks.tex`, `overleaf/misc/my-general.tex`
- Delete: `overleaf/main.tex`, `overleaf/chapters/`, `overleaf/appendices/`, `overleaf/refs/`, `overleaf/frontmatter/`, `overleaf/styles/`, once migration checks pass
- Test: migrated include inventory and XeLaTeX compile

**Interfaces:**
- Consumes: all source files included by the current `overleaf/main.tex`.
- Produces: a Technion entry point that includes each authored source exactly once.

- [ ] **Step 1: Write the failing include-inventory check**

Extend `scripts/verify-template.ps1` to require every migrated authored file
listed above and to parse `thesis.tex` for one `\\include{main/...}` reference
per chapter and appendix. Require `\\addbibresource{back/thesis.bib}` to appear
in `misc/thesis-fields.tex` or the appropriate upstream metadata file.

- [ ] **Step 2: Run the check before migration edits**

Run: `powershell -ExecutionPolicy Bypass -File scripts/verify-template.ps1`

Expected: FAIL because the generic structure has not yet been mapped to the
Technion layout.

- [ ] **Step 3: Copy authored content without semantic changes**

Move/copy the nine chapter files and two appendices into `overleaf/main/`.
Copy `refs/thesis.bib` to `back/thesis.bib`. Transfer reusable macros from
`styles/macros.tex` into `misc/my-thesis-specific.tex`; leave general template
macros in `misc/my-general.tex`.

- [ ] **Step 4: Replace sample includes and configure metadata**

Replace sample main-chapter `\\include` statements in `thesis.tex` with the
migrated authored sequence. Set the actual degree option only if the repository
contains it; otherwise use the intended degree confirmed by the author. Replace
`Author Name` and date placeholders only with verified author data. Populate
all mandatory Hebrew and English metadata fields in `misc/thesis-fields.tex`
with explicit author-completion placeholders where verified translations or
supervisor information are unavailable. Replace the generic manual front matter
with `\\makefrontmatter` and `\\makebackmatter`.

- [ ] **Step 5: Make source-path adjustments**

Update every `\\includegraphics`, `\\input`, and bibliography-related path so
it resolves relative to the new `overleaf/` structure. Retain only final thesis
assets in `overleaf/graphics/`; reference no paths outside `overleaf/`.

- [ ] **Step 6: Run the include-inventory check and inspect its output**

Run: `powershell -ExecutionPolicy Bypass -File scripts/verify-template.ps1`

Expected: PASS, reporting each chapter, appendix, and bibliography as present
once and the XeLaTeX class/build prerequisites as present.

- [ ] **Step 7: Remove superseded generic scaffold paths**

Only after a passing structural check, remove the legacy source directories and
`main.tex` listed above. Do not remove figures until their migrated references
compile.

- [ ] **Step 8: Commit the content migration**

Run: `git add overleaf; git commit -m "build: migrate thesis content to Technion template"`

Expected: the diff preserves authored prose and bibliography entries except for
path and entry-point integration changes.

### Task 4: Compile, inspect, and document the usable thesis project

**Files:**
- Modify: `overleaf/README.md`, `research-context/technion-template-audit-2026-09-20.md`
- Test: `latexmk thesis`, structural verifier, PDF page inspection

**Interfaces:**
- Consumes: the self-contained template and migrated content.
- Produces: a verified XeLaTeX project with reproducible build instructions.

- [ ] **Step 1: Run the full build**

Run: `Set-Location overleaf; latexmk -C; latexmk thesis`

Expected: exit code 0. Resolve compilation errors caused by the migration;
record unavoidable missing local-font/package failures verbatim if the TeX
installation cannot satisfy the upstream requirements.

- [ ] **Step 2: Run the final structural verifier**

Run: `powershell -ExecutionPolicy Bypass -File scripts/verify-template.ps1`

Expected: exit code 0 with all class, engine, include, and bibliography checks
passing.

- [ ] **Step 3: Inspect the generated PDF**

Render the first English-front-matter pages, first body page, bibliography
pages, and final Hebrew pages. Confirm ordering, binding margins, directions,
metadata placeholder visibility, and the absence of missing figures or broken
cross-references.

- [ ] **Step 4: Update build documentation and audit conclusion**

Document `latexmk thesis` from `overleaf/`, state that Overleaf must use
XeLaTeX, and revise the audit from “not migrated” to the verified actual state.

- [ ] **Step 5: Remove generated artifacts and verify repository state**

Run: `Set-Location overleaf; latexmk -C`; then run `git status --short` from
the repository root.

Expected: no generated build products staged or untracked; only intended source
and documentation changes remain.

- [ ] **Step 6: Commit verification and documentation**

Run: `git add overleaf/README.md research-context/technion-template-audit-2026-09-20.md scripts/verify-template.ps1; git commit -m "docs: document Technion XeLaTeX thesis build"`

Expected: all prior commits are followed by a clean working tree.

