# Introduction LFM Buildup Implementation Plan

> **Status:** historical
>
> **Reviewed:** 2026-09-24

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the opening of the thesis introduction so the biological motivation leads naturally to LFM and then to FLFM, while reserving implementation-specific rectification details for the methods chapters.

**Architecture:** Keep the introduction in one LaTeX chapter file, but separate its opening into short rhetorical units: broad imaging need, optical/fluorescence context, unresolved speed-volume tension, LFM principle, and LFM trade-off. Use the existing bibliography keys for claims about LFM and its reconstruction limits.

**Tech Stack:** LaTeX, BibTeX, existing thesis bibliography.

## Global Constraints

- Modify only `overleaf/chapters/01_introduction.tex` for the prose change; this plan may be updated when its scope no longer matches the thesis.
- Preserve existing unrelated working-tree changes.
- Introduce FLFM at a conceptual level, including its Fourier-plane sampling geometry and its motivation relative to image-plane LFM. Defer implementation-specific rectification details to the methods chapters.
- Do not use absolute claims about optical penetration, cost, or resolution without qualification.

---

### Task 1: Rewrite the introduction opening through LFM

**Files:**
- Modify: `overleaf/chapters/01_introduction.tex`

**Interfaces:**
- Consumes: the approved narrative design and existing bibliography keys.
- Produces: a self-contained introduction opening ending at the motivation for examining the light-field encoding geometry.

- [ ] **Step 1: Replace the current opening prose**

Rewrite the existing block into paragraphs that establish the general imaging
requirements, narrow to optical fluorescence microscopy, introduce LFM, and
then position FLFM as the thesis platform. Remove the inline placeholder note.

- [ ] **Step 2: Check the rhetorical sequence**

Confirm that each paragraph answers one question in order: why imaging is
needed, why established modalities are insufficient for every use case, why
fluorescence is valuable, why fast volumetric capture remains difficult, what
LFM measures, and what LFM costs.

- [ ] **Step 3: Verify the LaTeX source**

Run a targeted search for placeholder text and inspect the edited file for
balanced citation commands and intact chapter syntax.

- [ ] **Step 4: Compile when available**

Run the repository's available LaTeX build command from `overleaf/`. If no
LaTeX executable is available, report that and use the targeted source checks
as the verification evidence.
