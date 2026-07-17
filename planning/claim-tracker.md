# Claim Tracker

Use this file to connect thesis claims to literature support, internal
implementation evidence, and result provenance. Keep claims conservative until
the exact thesis figure/table evidence is selected.

## Claim Ledger

| Claim | Thesis location | Evidence type | Current evidence | Status |
| --- | --- | --- | --- | --- |
| Light-field microscopy captures spatial and angular information in one camera exposure, enabling post-capture viewpoint/refocus or computational reconstruction at the cost of a spatial-angular sampling tradeoff. | Chapter 2 | Literature | Levoy 2009; Ren Ng thesis; FLFM notes. | Needs finalized citations. |
| Fourier light-field microscopy is relevant to this thesis because pupil/Fourier-plane sampling produces elemental views that can be modeled as a view grid. | Chapters 2-3 | Literature and model framing | FLFM notes; Levoy LFM background; internal view-grid terminology. | Needs finalized FLFM citation. |
| Biological tissue or tissue-like media introduce aberration, scattering, blur, contrast loss, and view-dependent degradation that make direct recovery difficult. | Chapter 4 | Literature and result context | Goodman statistical optics; Ren Ng aberration correction context; chicken/eyedrop result caveats. | Needs exact sections and citations. |
| The implemented method is rectification and warp-and-average over elemental views, not learned reconstruction, deconvolution, or full scattering inversion. | Chapters 5 and 8 | Implementation evidence | `research-context/method-notes/rectification-pipeline/implementation-digest.md`; `source-map.md`; `thesis-writing-translation.md`. | Safe with observed checkout caveat. |
| The global rectification stage estimates one translation per elemental view using correlation and applies translation-only warps. | Chapter 5 | Implementation evidence | Implementation digest and source map anchors for global correlation/warp. | Safe with observed checkout caveat. |
| The pixelwise refinement stage estimates dense local displacement fields through bounded displacement search and backward remapping. | Chapter 5 | Implementation evidence | Implementation digest and source map anchors for pixelwise search, scoring, and remap. | Safe with observed checkout caveat. |
| Combined rectification uses global alignment as initialization for local pixelwise refinement, and averages the remapped elemental views to form the output. | Chapter 5 | Implementation evidence | Implementation digest, source map, thesis-writing translation notes. | Safe with observed checkout caveat. |
| FLFM plus rectification recovers useful 2D fluorescent bead scenes under tested eyedrop and chicken-breast media. | Chapters 7-8 | Result evidence | Candidate pools in eyedrop and chicken aggregation notes. | Needs exact selected runs, figures, metrics, and provenance. |
| Local/pixelwise refinement can improve selected scenes relative to global-only alignment. | Chapters 7-8 | Result evidence | Chicken `2_7_26` sparse2 and `13_7_26` dense are leading candidates; eyedrop June 3/10 candidates. | Needs crop/metric/provenance support. |
| ThorCam and Validation Camera comparisons provide downstream evaluation context for completed rectification outputs. | Chapters 6-8 | Protocol and result evidence | Validation workspace notes, dataset/run map, trio benchmark method notes. | Needs stable same-resolution protocol before strong performance claims. |
| Close-bead separability or compactness can improve in selected cases. | Chapters 7-8 | Result evidence | Sparse eyedrop/chicken candidates only. | Not safe until supported by crops, line profiles, or compactness/separation metrics. |

## Claim Status Rules

- `Safe with observed checkout caveat`: can be written now if the observed code
  checkout and date are cited in prose or provenance notes.
- `Needs finalized citations`: concept is likely safe, but exact source and
  bibliographic record still need cleanup.
- `Needs exact selected runs`: do not draft as a final result claim until the
  selected artifact, config, metric record, and provenance record are recorded.
- `Not safe`: keep as an open research/writing target, not a thesis claim.
