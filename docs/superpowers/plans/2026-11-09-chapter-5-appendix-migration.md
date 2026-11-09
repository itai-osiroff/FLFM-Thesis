# Chapter 5 to Appendix A migration — 2026-11-09

> **Status:** historical implementation record
>
> **Reviewed:** 2026-11-09

Content migration under the author's direction. It meets the existing Chapter 5
target (about 1 prose page plus one full-page figure) and records no departure
in the [authoritative structure and budget](../../../planning/revised-thesis-structure.md).

## Decisions (author, 2026-11-09)

- The full former Chapter 5 moves to a new Appendix A, "Reconstruction method in
  detail", verbatim except the heading and labels.
- The figure kept in Chapter 5 is the alignment-evolution figure (Figure 5.1). Its
  provenance gaps (capture identity, algorithm revision, acquisition date) stay
  open, so it remains a candidate.
- The pipeline schematic stays with the appendix text (Figure A.1). No figure
  is printed twice.
- Appendix order: A reconstruction method, B derivations, C additional results.

## Changes

- `overleaf/main/a_reconstruction_method.tex` (new): former Chapter 5, label
  `app:reconstruction-method`; short pointer sentence added; alignment-evolution
  figure block removed (now in Chapter 5).
- `overleaf/main/05_image_reconstruction.tex`: condensed account with three
  display equations and the alignment-evolution figure; label
  `ch:image-reconstruction` and `fig:single-view-alignment` unchanged.
- `a_derivations` renamed `b_derivations`, `b_additional_results` renamed
  `c_additional_results`; `overleaf/thesis.tex` updated.
- `scripts/verify-template.ps1` and `scripts/tests/verify-template.tests.ps1`
  updated for the three-appendix list.
- Provenance, claim tracker, structure debt table, writing log and CLAUDE.md
  updated.

## Verification (cloud build, substitute Hebrew font)

- Appendix A differs from the former chapter only by the heading/label/pointer
  lines and the removed alignment figure block (diff checked).
- `latexmk thesis.tex` exit 0. Remaining overfull boxes are the two baseline
  ones; no undefined or multiply defined references.
- List of Figures: 5.1 (alignment evolution), A.1 (pipeline schematic).
- Chapter 5 prose/equation estimate: about 0.8 page on the opening page plus
  about 0.3 on the next, roughly 1.1 equivalents including chapter-title space.
- Not run here: the PowerShell validator and its tests (no PowerShell).
  Run both locally.
