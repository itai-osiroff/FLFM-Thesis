# Revised Thesis Structure

> **Status:** active
>
> **Reviewed:** 2026-09-24

Observation date: 2026-07-17

This structure is theory-first. It keeps the optical and computational model in
front of the experiments, while adding a dedicated experimental setup and
evaluation chapter before the results.

## Working Chapter Order

| Chapter | Working title | Purpose | Main source pools |
| --- | --- | --- | --- |
| 1 | Introduction | State the problem, central claim, tested media, and contribution boundaries. | Thesis narrative map, claim tracker, flagship result candidates. |
| 2 | Background and Literature | Establish fluorescence microscopy, light fields, LFM/FLFM lineage, aberration correction context, and competing imaging tradeoffs. | Levoy 2006/2009, Guo 2019, Broxton 2013, Prevedel 2014, Goodman/Jacques, adaptive-optics and deep-tissue microscopy reviews; apply the project writing standard. |
| 3 | FLFM Forward Model and Sampling Geometry | Explain the measured view grid, pupil/Fourier-plane intuition, spatial-angular tradeoff, elemental views, and the 2D-scene model used by this thesis. | Guo 2019, Galdon 2022, Yun 2023, Levoy 2009, Broxton 2013 for contrast, internal method terminology notes. |
| 4 | Aberration and Scattering in Biological Tissue | Describe the degradation mechanisms relevant to eyedrop and chicken-breast media, and define what the thesis does and does not attempt to invert. | Goodman 2015, Jacques 2013, Ji/Booth/Zhang adaptive-optics reviews, Zhang 2021 computational optical sectioning, result caveats. |
| 5 | Rectification-Based Reconstruction Method | Present the implemented global, pixelwise, and combined rectification pipeline and its safe mathematical/algorithmic boundaries. | Rectification implementation digest, source map, thesis-writing translation notes. |
| 6 | Experimental Setup, Data, and Evaluation Protocol | Make the system, samples, datasets, cameras, sweeps, metrics, and validation/ThorCam protocol reproducible. | Dataset/run map, database inventory, figure/table backlog, validation workspace notes. |
| 7 | Results | Show the smallest set of result blocks needed to support the thesis claims. | Eyedrop and chicken aggregation notes, selected run provenance, metric records, validation artifacts. |
| 8 | Discussion | Interpret what the results support, explain failure modes and metric caveats, and avoid overclaiming beyond tested bead scenes and media. | Claim ledger, result caveats, validation limitations, method limitations. |
| 9 | Conclusion | Summarize contributions, limitations, and future work. | Final claim tracker and discussion synthesis. |

## Structural Rationale

- The theory-first order lets the reader learn what light-field/FLFM data are
  before encountering the custom rectification method.
- A separate setup/evaluation chapter prevents Chapter 3 from mixing optical
  theory with dataset inventory and camera protocol details.
- Discussion is reserved for interpretation, caveats, and limits rather than
  introducing new evidence.

## Open Structure Questions

| Question | Current default | Decision trigger |
| --- | --- | --- |
| Should Chapter 6 be split into setup and evaluation? | Keep one chapter for now. | Split only if dataset/protocol prose becomes too large or interrupts results. |
| Should aberration/scattering stay separate from the FLFM model? | Keep separate. | Merge only if the theory chapter becomes short and mostly qualitative. |
| How should thesis references influence drafting? | Apply `writing-standard.md` for structure, tone, captions, and completeness. | Never let a reference thesis override the evidence-driven structure or supply active-thesis content. |
