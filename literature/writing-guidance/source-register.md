# Writing-exemplar source register

> **Status:** reference
>
> **Reviewed:** 2026-09-26

These works come from the [supplied report](deep-research-report-original.md).
They are writing aids, not automatically evidence for FLFM claims. All checks
below occurred on 2026-09-26. No source is marked as read by the thesis author.
No new local PDF copies or active thesis bibliography entries were created.

**Status meanings:** `content inspected` means the specified sections were
read; `record checked` means identity/metadata or abstract only; `limited`
means only the described partial source access; `unresolved` means the supplied
record could not be confirmed in this pass. None means full-paper scientific
validation, retraction screening, or verification of quoted wording.

## Core reporting reference

**W01 — Christopher Schmied et al., *Community-developed checklists for
publishing images and image analyses*. Nature Methods 21, 170–181 (2024).**
[Publisher / DOI](https://www.nature.com/articles/s41592-023-01987-9).
Publisher bibliographic record checked; subscription preview is not full-text
access. The [companion](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/intro.html)
provides the recommended citation and explains its minimal/recommended/ideal
levels. It is a living resource, distinct from the fixed journal article.

Companion content inspected:

- [New workflows](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/2_new_workflows.html): sequence, settings, example data/code, ROIs, scope, and limits.
- [Established workflows](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/1_established_workflows.html): versions, application state, and environments.
- [Image annotation](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/image_publishing/3_image_annotation.html): scale, labels, and processing disclosure.
- [Machine learning workflows](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/analysis_workflows/3_machine_learning_workflows.html): method identity, model and validation-data access; use only for an actual learned stage.

Use W01 for reporting completeness. The choice to put essential method details
in the main thesis text is our editorial policy, not an assertion that every
QUAREP item requires that placement. The publisher also links a
[printable checklist archive](https://doi.org/10.5281/zenodo.7642559);
its files/version were not inspected here.

## Physics and calibration exemplars

| ID / work | Primary link and checked version | Status and useful next reading |
| --- | --- | --- |
| W02 — Michael Kellman, *Physics-based Learning for Large-scale Computational Imaging* | [Berkeley EECS-2020-167](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2020/EECS-2020-167.html), August 14, 2020 | Record and abstract checked. Candidate for connecting acquisition and reconstruction. Dissertation chapters/equations not inspected; locate the relevant passage before claiming a specific exposition pattern. |
| W03 — Regina Eckert, *Robust 3D Quantitative Phase Imaging* | [Berkeley EECS-2022-29](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2022/EECS-2022-29.html), May 1, 2022 | Record and abstract checked, including self-calibration and measurement-diversity framing. Use this record's 2022 date; the supplied report's associated 2021 dissertation date remains unconfirmed here. |
| W04 — Li-Hao Yeh, *Computational fluorescence and phase super-resolution microscopy* (2019, as supplied) | [eScholarship record supplied by the report](https://escholarship.org/uc/item/02p6h805) | Unresolved: page yielded no usable bibliographic content. Retain as a lead; verify title/author/date and the exact dissertation before citation or close-reading claims. |
| W05 — Michael Kellman et al., *Memory-efficient Learning for Large-scale Computational Imaging* | [arXiv:2003.05551v1](https://arxiv.org/abs/2003.05551v1), March 11, 2020; [IEEE record supplied in report](https://ieeexplore.ieee.org/document/9204455) | Preprint record/abstract checked. It lists Kellman, Zhang, Tamir, Bostan, Lustig, Waller. The report's journal listing also includes Eric Markley; journal metadata and the full equations/pseudocode were not checked. Do not combine journal authorship with this preprint version. |

W02/W03 are supplemental technical-writing models. They do not replace
[Hadar's comparative role](../thesis-examples/hadar-reference-standard.md),
and their phase-imaging models are not automatically suitable for FLFM
fluorescence rectification.

## Task, representation, and QC exemplars

The suggested writing uses below come from the supplied report and are reading
targets; except where specified, their detailed figure/equation assessments
have not been independently confirmed.

| ID / work | Primary link | Check scope and intended use |
| --- | --- | --- |
| W06 — Martin Weigert et al., *Content-aware image restoration: pushing the limits of fluorescence microscopy* (2018) | [Nature Methods](https://www.nature.com/articles/s41592-018-0216-7) | Publisher record accessed; full-paper appraisal not performed. Candidate for input/output task presentation. |
| W07 — Alexander Krull, Tim-Oliver Buchholz, Florian Jug, *Noise2Void—Learning Denoising from Single Noisy Images* (CVPR 2019) | [CVF Open Access](https://openaccess.thecvf.com/content_CVPR_2019/html/Krull_Noise2Void_-_Learning_Denoising_From_Single_Noisy_Images_CVPR_2019_paper.html) | Limited: direct retrieval failed; W01's publisher reference list corroborates title, authors and venue/year. Assumption-driven writing is a close-reading target, not a verified quotation here. |
| W08 — Carsen Stringer, Tim Wang, Michalis Michaelos, Marius Pachitariu, *Cellpose: a generalist algorithm for cellular segmentation* (2021) | [Nature Methods](https://www.nature.com/articles/s41592-020-01018-x) | Publisher record accessed; full-paper appraisal not performed. Use for method/software-version distinction. No present software version or weights were checked. |
| W09 — Uwe Schmidt, Martin Weigert, Coleman Broaddus, Gene Myers, *Cell Detection with Star-Convex Polygons* (2018) | [arXiv:1806.03535](https://arxiv.org/abs/1806.03535); [MICCAI chapter](https://link.springer.com/chapter/10.1007/978-3-030-00934-2_30) | arXiv record accessed; Springer/full text not inspected. Candidate for explaining an estimated geometric representation before architecture. Pin an arXiv version or the chapter for close reading. |
| W10 — Elias Nehme, Lucien E. Weiss, Tomer Michaeli, Yoav Shechtman, *Deep-STORM: super-resolution single-molecule microscopy by deep learning* (2018) | [arXiv:1801.09631](https://arxiv.org/abs/1801.09631); [Optica](https://opg.optica.org/abstract.cfm?uri=optica-5-4-458) | arXiv record accessed; publisher/full text not inspected. Candidate for training-source and reconstruction presentation. Do not generalize “parameter-free” into an absence of methodological choices. |
| W11 — Lucas von Chamier et al., *Democratising deep learning for microscopy with ZeroCostDL4Mic*, Nature Communications 12, 2276 (2021) | [Publisher / DOI](https://www.nature.com/articles/s41467-021-22518-0) | Limited: direct open failed; publisher search result confirmed citation and April 15, 2021 publication. Inspect workflow/QC figures and parameter supplements before relying on the report's detailed visual appraisal. |

## Citation repair and promotion

The report's session markers cannot be uniquely mapped to passages from this
export. This register replaces them as discovery pointers, not as reconstructed
citation evidence. The unnamed IEEE reproducibility/artifact-review pages and
software documentation behind other markers remain unresolved. No quotes were
promoted into the digest.

Before citing a source in the thesis:

1. Open the exact primary version and inspect the passage that supports the claim.
2. Record a page/section/equation/figure locator, what it supports, and its limits
   in a [reading note](../notes/reading-note-template.md).
3. Verify bibliographic fields against that version and add an entry to
   `overleaf/back/thesis.bib` only when the manuscript actually cites it.
4. Keep a method citation, software version, dataset source, and local experiment
   evidence distinct. A writing exemplar alone cannot support local performance.

For a later local download, append: source ID; exact version; retrieval date;
source URL; optional local path; SHA-256; inspected locators; content-check
status. Keep human-read declarations separate and author-supplied.
