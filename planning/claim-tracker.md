# Claim Tracker

> **Status:** active
>
> **Reviewed:** 2026-11-09

Use this file to connect thesis claims to literature support, internal
implementation evidence, and result provenance. Keep claims conservative until
the exact thesis figure/table evidence is selected.

Use the [authoritative structure and budget](revised-thesis-structure.md) for
current ownership and space. Renumbering does not qualify evidence or change a
claim status. Acquisition/evaluation summaries belong in Chapter 4, with detailed
protocols in supporting records.

## Claim Ledger

| Claim | Thesis location | Evidence type | Current evidence | Status |
| --- | --- | --- | --- | --- |
| Light-field microscopy captures spatial and angular information in one camera exposure, enabling post-capture viewpoint/refocus or computational reconstruction at the cost of a spatial-angular sampling tradeoff. | Chapter 2 | Literature | Levoy 2006; Levoy 2009; Broxton 2013; Prevedel 2014 for biological snapshot motivation. | Literature citation base ready. |
| Fourier light-field microscopy is relevant to this thesis because pupil/Fourier-plane sampling produces elemental views that can be modeled as a view grid. | Chapters 2-3 | Literature and model framing | Guo 2019 FLFM; Galdon 2022 and Yun 2023 design/setup guides; Hua 2021 as modern HR-FLFM context; internal view-grid terminology. The LFM-to-FLFM motivation is now drafted in `overleaf/main/01_introduction.tex`. | Literature citation base ready; introduction draft now establishes the claim. |
| Biological tissue or tissue-like media introduce aberration, scattering, blur, contrast loss, and view-dependent degradation that make direct recovery difficult. | Chapter 3 | Literature and result context | Goodman 2015; Jacques 2013; Ji 2017/Booth 2014/Zhang 2023 adaptive-optics reviews; Zhang 2021 computational optical sectioning; chicken/eyedrop result caveats. | Literature citation base ready; exact sections still needed during prose drafting. |
| The thesis method is one two-stage rectification and warp-and-average pipeline over elemental views, not learned reconstruction, deconvolution, or full scattering inversion. | Chapters 5 and 7 | Implementation evidence and authorial scope | `research-context/method-notes/rectification-pipeline/implementation-digest.md`; `source-map.md`; `thesis-writing-translation.md`; thesis-use boundary in the method-note index. | Safe with observed checkout caveat. |
| In the first stage of that pipeline, correlation estimates one translation per elemental view and translation-only warps produce an intermediate global-stage average. | Chapter 5 (summary); Appendix A (detail) | Implementation evidence | Implementation digest and source map anchors for global correlation/warp. | Safe with observed checkout caveat. |
| In the second stage, bounded dense displacement search and backward remapping refine the globally aligned views; their average is the final rectified image. | Chapter 5 (summary); Appendix A (detail) | Implementation evidence | Implementation digest and source map anchors for pixelwise search, scoring, and remap. | Safe with observed checkout caveat. |
| FLFM plus rectification recovers useful 2D fluorescent bead scenes under tested eyedrop and chicken-breast media. | Chapters 6–7 | Result evidence | June 3 dense4 scene and two-stage algorithm run are indexed in `research-context/result-provenance/fig_eyedrop_3_6.yaml`; a candidate figure compares the intermediate and final stage outputs with ThorCam. | Still candidate evidence. Comparison-processing history and source-code revision remain incomplete; no final claim until result is qualified. |
| Local refinement can improve selected scenes relative to the intermediate global-stage average from the same two-stage run. | Chapters 6–7 | Result evidence | The June 3 dense4 candidate records intermediate and final metrics for one combined run; chicken `2_7_26` sparse2 and `13_7_26` dense remain candidates. | Candidate evidence only. Confirm paired run identity and figure processing; aggregate metrics alone do not establish a visually meaningful improvement. |
| ThorCam and Validation Camera comparisons provide downstream evaluation context for completed rectification outputs. | Chapters 4, 6, and 7 | Protocol and result evidence | A reusable trio-comparison renderer and candidate ThorCam/intermediate/final PDFs exist; validation workspace notes, dataset/run map, and trio benchmark method notes remain the protocol basis. | Visual comparison assembled, but needs stable same-resolution protocol before strong performance claims. |
| Close-bead separability or compactness can improve in selected cases. | Chapters 6–7 | Result evidence | Sparse eyedrop/chicken candidates only. | Not safe until supported by crops, line profiles, or compactness/separation metrics. |

## Claim Status Rules

- `Literature citation base ready`: primary or authoritative sources are
  selected and in `overleaf/back/thesis.bib`; final prose should still cite the
  exact source sections, figures, or equations used.
- `Safe with observed checkout caveat`: can be written now if the observed code
  checkout and date are cited in prose or provenance notes.
- `Needs exact selected runs`: do not draft as a final result claim until the
  selected artifact, config, metric record, and provenance record are recorded.
- `Not safe`: keep as an open research/writing target, not a thesis claim.
