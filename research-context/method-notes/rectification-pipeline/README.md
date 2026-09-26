# Rectification Pipeline Method Notes

> **Status:** reference
>
> **Reviewed:** 2026-09-26

Observed source checkout: `C:\Users\admin2\Documents\git_clones\algo`

Latest source account: [end-to-end-pipeline-explanation.md](end-to-end-pipeline-explanation.md),
observed on 2026-09-25 at `main`,
`d0e08634e71ca0ecc4766e46de9e33d2d351d06a`. It explains interactive and
sweep execution, exact matching/aggregation behavior, optional branches,
metrics, reproducibility limits, and adaptation into main-text and supplemental
methods. Its source map and file hashes belong to that observation.

Earlier notes' branch/commit: `main`, `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`

Earlier observation date: 2026-07-16

The three earlier notes below summarize the implementation observed on 2026-07-16 for
thesis writing. They are not a replacement for the source code; use them as a
readable bridge from that checkout to a method description. Refresh the source
map and implementation digest if the research checkout changes before drafting
implementation claims.

## Files

When adapting these observations into thesis prose, apply the
[technical writing guide](../../../planning/technical-writing-guide.md) and
[stage worksheet](../../../planning/templates/technical-stage.md). They supply
editorial checks; the observation revisions and run records supply the facts.

- [end-to-end-pipeline-explanation.md](end-to-end-pipeline-explanation.md):
  detailed September 25 source-based explanation and thesis drafting base;
  distinguishes current code from historical result provenance.
- [implementation-digest.md](implementation-digest.md): thesis-facing overview of
  the July 16 pipeline, algorithms, metrics, artifacts, and limitations.
- [source-map.md](source-map.md): line-anchored evidence map back to the source
  checkout.
- [thesis-writing-translation.md](thesis-writing-translation.md): suggested
  terminology, thesis-ready claims, and cautionary wording.

## High-Level Shape

The implementation has four layers:

1. Core rectification: `im_process.py` and `rectification_strategy.py`.
2. Optional combined-mode reference rebuilding: `iterative_subtractive_max_rebuild.py`.
3. Parameter sweeps, scoring, artifacts, and reports: `parameter_sweep.py`,
   `sweep_analysis.py`, `metric_profiles.py`, `sweep_visualization.py`, and
   `sweep_metric_explorer.py`.
4. External-camera evaluation: `validate_rectification.py`,
   `trio_benchmark.py`, and `trio_oracle_metrics.py`.

Important boundary: in this checkout, guide-map metrics are mainly post-run
scoring/exploration tools. The default rectifier still produces output by
warping views and averaging the rectified raw view stack.
