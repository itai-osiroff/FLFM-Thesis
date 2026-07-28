# Hadar Reference Standard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Hadar's thesis the documented primary comparative reference while keeping the thesis's writing standards independent, original, and evidence-led.

**Architecture:** A local reference note explains Hadar's privileged role once. `planning/writing-standard.md` supplies reusable editorial rules; chapter-planning documents link to that standard rather than to Hadar repeatedly.

**Tech Stack:** Markdown and Git.

## Global Constraints

- Do not copy prose, scientific claims, equations, figures, data, or bibliography entries from Hadar's thesis.
- Maintain the active thesis's evidence and provenance requirements.
- Keep Hadar's legacy LaTeX class separate from the active Technion template.
- Do not add the nested `.git` directory or generated PDF from Hadar's source folder to this repository.

---

### Task 1: Add the reference and writing standards

**Files:**
- Create: `literature/thesis-examples/hadar-reference-standard.md`
- Create: `planning/writing-standard.md`

- [ ] Describe Hadar's same-supervisor/same-field role and its permitted uses: rhetorical pacing, chapter logic, figure sequence, caption completeness, and bilingual submission expectations.
- [ ] Convert those uses into project-owned rules for chapter questions, evidence-bounded claims, reproducible methods, standalone captions, and limitations.
- [ ] State the originality boundary and the legacy-template boundary in both documents.
- [ ] Verify both files name a concrete drafting action for each standard rather than referring readers back to Hadar's source tree.
- [ ] Commit the two documents with `git commit -m "docs: add Hadar-informed writing standard"`.

### Task 2: Connect the standard to chapter planning

**Files:**
- Modify: `planning/revised-thesis-structure.md`
- Modify: `planning/chapter-synthesis-map.md`

- [ ] Replace the “tone only” treatment of thesis examples with a link to `writing-standard.md`.
- [ ] Add the writing standard as a planning input for every chapter without adding Hadar-specific requirements to chapter evidence controls.
- [ ] Verify the chapter order, scientific scope, and provenance rules remain unchanged.
- [ ] Commit the planning integration with `git commit -m "docs: apply thesis writing standard to planning"`.

### Task 3: Record reference provenance and repository boundaries

**Files:**
- Create: `planning/upstreams.md`
- Modify: `.gitignore`
- Modify: `README.md`

- [ ] Record the official template and Hadar source revisions, their distinct roles, and Hadar's current local-build compatibility caveat.
- [ ] Add narrow ignores for Hadar-generated build outputs while allowing source figure PDFs to remain trackable.
- [ ] Document that Hadar's nested `.git` directory must not be committed as a gitlink and that its source snapshot is reference material, not active thesis source.
- [ ] Verify `git check-ignore` ignores generated Hadar outputs but does not ignore a PDF under its `figs/` directory.
- [ ] Commit the provenance and hygiene changes with `git commit -m "docs: document thesis reference provenance"`.

### Task 4: Review standards coverage

**Files:**
- Test: documentation review and Git status

- [ ] Confirm the reference hierarchy is stated once, the reusable rules are in `planning/writing-standard.md`, and chapter documents point only to that standard.
- [ ] Confirm every active-thesis claim and figure remains governed by existing evidence/provenance documents.
- [ ] Run `git diff --check` and `git status --short`; ensure the user-owned Hadar source folder and `triage_system_components_deck.py` are not staged accidentally.
- [ ] Commit only if this review requires a tracked correction.
