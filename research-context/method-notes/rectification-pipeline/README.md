# Rectification Pipeline Method Notes

Observed source checkout: `C:\Users\admin2\Documents\git_clones\algo`

Observed branch/commit: `main`, `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`

Observation date: 2026-07-16

These notes summarize the current, non-final implementation of the FLFM/light-field
rectification pipeline for thesis writing. They are not a replacement for the
source code; they are a readable bridge from implementation details to method
description.

## Files

- [implementation-digest.md](implementation-digest.md): thesis-facing overview of
  the pipeline, algorithms, metrics, artifacts, and limitations.
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
