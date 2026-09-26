# Writing Log

> **Status:** active
>
> **Reviewed:** 2026-09-26

| Date | Area | Change | Next Step |
| --- | --- | --- | --- |
| 2026-07-16 | Project structure | Created writing-oriented thesis scaffold | Start filling outline and bibliography |
| 2026-08-17 | Introduction | Defined the LFM-to-FLFM narrative buildup and its wording constraints in a design note and implementation plan. | Keep the introduction focused on imaging trade-offs before introducing the thesis-specific rectification method. |
| 2026-09-03 | Introduction | Rewrote the opening through FLFM: biological-imaging requirements -> modality trade-offs -> fluorescence -> LFM -> spatial-angular sampling -> FLFM scope. | Review the chapter transition into the system/method chapters and add any remaining thesis-specific citations. |
| 2026-09-04 | Results figures | Added source assets and LaTeX for a three-column ThorCam/global/local comparison, including the eyedrop `3_6_26` candidate. | Record exact run/source provenance before treating the candidate as a thesis result. |
| 2026-09-08 | Results figures | Added ThorCam zoom-level assets for the eyedrop comparison. | Check crop correspondence and same-resolution preprocessing against the source run. |
| 2026-09-18 | Results figures | Centralized the trio-comparison renderer and refined the zoom-box styling; regenerated the example and eyedrop PDFs. | Select the final thesis figure only after provenance, caption wording, and quantitative support are complete. |
| 2026-09-24 | Integrity pass | Removed the copied Hadar system figure, moved provisional figure assets to `candidate-outputs/`, and removed the local Hadar clone from Git tracking while retaining it locally. Confirmed the active Technion XeLaTeX template decision. | Qualify candidate figures with exact run provenance, preprocessing, and bounded captions before thesis selection. |
| 2026-09-25 | Computational methods | Added a [detailed end-to-end pipeline explanation](../research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md) from `algo` commit `d0e0863`, covering interactive/API differences, sweep execution, exact scoring, optional branches, and reproducibility limitations. Preserved older observations separately. | Adapt verified run-specific portions into the method/evaluation chapters and supplement; resolve historical code provenance before attributing current options to earlier figures. |
| 2026-09-26 | Reusable writing guidance | Preserved the supplied [microscopy-writing report](../literature/writing-guidance/README.md), added a critical assessment and source register, and integrated a [technical guide](technical-writing-guide.md), stage worksheet, ARS workflow note, and agent entry point. Checked the central QUAREP companion guidance and recorded partial/unresolved exemplar checks. Kept reference PDFs optional and outside Git. | Apply the guide during the next model/method/evaluation edit; resolve run-specific facts and inspect exact primary passages before promoting claims or citations. |
