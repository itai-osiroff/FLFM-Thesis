# Claim Tracker

Use this file to connect thesis claims to literature support, internal
implementation evidence, and result provenance. Keep claims conservative until
the exact thesis figure/table evidence is selected.

## Claim Ledger

| Claim | Thesis location | Evidence type | Current evidence | Status |
| --- | --- | --- | --- | --- |
| Light-field microscopy captures spatial and angular information in one camera exposure, enabling post-capture viewpoint/refocus or computational reconstruction at the cost of a spatial-angular sampling tradeoff. | Chapter 2 | Literature | Levoy 2006; Levoy 2009; Broxton 2013; Prevedel 2014 for biological snapshot motivation. | Literature citation base ready. |
| Fourier light-field microscopy is relevant to this thesis because pupil/Fourier-plane sampling produces elemental views that can be modeled as a view grid. | Chapters 2-3 | Literature and model framing | Guo 2019 FLFM; Galdon 2022 and Yun 2023 design/setup guides; Hua 2021 as modern HR-FLFM context; internal view-grid terminology. The LFM-to-FLFM motivation is now drafted in `overleaf/chapters/01_introduction.tex`. | Literature citation base ready; introduction draft now establishes the claim. |
| Biological tissue or tissue-like media introduce aberration, scattering, blur, contrast loss, and view-dependent degradation that make direct recovery difficult. | Chapter 4 | Literature and result context | Goodman 2015; Jacques 2013; Ji 2017/Booth 2014/Zhang 2023 adaptive-optics reviews; Zhang 2021 computational optical sectioning; chicken/eyedrop result caveats. | Literature citation base ready; exact sections still needed during prose drafting. |
| The implemented method is rectification and warp-and-average over elemental views, not learned reconstruction, deconvolution, or full scattering inversion. | Chapters 5 and 8 | Implementation evidence | `research-context/method-notes/rectification-pipeline/implementation-digest.md`; `source-map.md`; `thesis-writing-translation.md`. | Safe with observed checkout caveat. |
| The global rectification stage estimates one translation per elemental view using correlation and applies translation-only warps. | Chapter 5 | Implementation evidence | Implementation digest and source map anchors for global correlation/warp. | Safe with observed checkout caveat. |
| The pixelwise refinement stage estimates dense local displacement fields through bounded displacement search and backward remapping. | Chapter 5 | Implementation evidence | Implementation digest and source map anchors for pixelwise search, scoring, and remap. | Safe with observed checkout caveat. |
| Combined rectification uses global alignment as initialization for local pixelwise refinement, and averages the remapped elemental views to form the output. | Chapter 5 | Implementation evidence | Implementation digest, source map, thesis-writing translation notes. | Safe with observed checkout caveat. |
| FLFM plus rectification recovers useful 2D fluorescent bead scenes under tested eyedrop and chicken-breast media. | Chapters 7-8 | Result evidence | Candidate pools in eyedrop and chicken aggregation notes; a qualitative ThorCam/global/local source figure is now assembled for `eyedrop_3_6`. Literature supports only the FLFM/tissue context, not this result claim. | Still needs exact selected runs, figures, metrics, and provenance. |
| Local/pixelwise refinement can improve selected scenes relative to global-only alignment. | Chapters 7-8 | Result evidence | The `eyedrop_3_6` source figure now provides a visual global/local comparison; chicken `2_7_26` sparse2 and `13_7_26` dense remain leading candidates. | Candidate evidence only; needs crop/metric/provenance support before drafting as a result claim. |
| ThorCam and Validation Camera comparisons provide downstream evaluation context for completed rectification outputs. | Chapters 6-8 | Protocol and result evidence | A reusable trio-comparison renderer and ThorCam/global/local PDFs now exist; validation workspace notes, dataset/run map, and trio benchmark method notes remain the protocol basis. | Visual comparison assembled, but needs stable same-resolution protocol before strong performance claims. |
| Close-bead separability or compactness can improve in selected cases. | Chapters 7-8 | Result evidence | Sparse eyedrop/chicken candidates only. | Not safe until supported by crops, line profiles, or compactness/separation metrics. |

## Claim Status Rules

- `Literature citation base ready`: primary or authoritative sources are
  selected and in `overleaf/refs/thesis.bib`; final prose should still cite the
  exact source sections, figures, or equations used.
- `Safe with observed checkout caveat`: can be written now if the observed code
  checkout and date are cited in prose or provenance notes.
- `Needs exact selected runs`: do not draft as a final result claim until the
  selected artifact, config, metric record, and provenance record are recorded.
- `Not safe`: keep as an open research/writing target, not a thesis claim.
