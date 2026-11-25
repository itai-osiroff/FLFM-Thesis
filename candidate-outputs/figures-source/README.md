# Trio figure archive

> **Status:** active
>
> **Reviewed:** 2026-11-26 (index rebuilt: four thesis figures selected; stale July 12 entries removed)

Each figure folder has its own history table, preview links, working recipe
where available, and independently selected export.

## In the thesis (Chapter 5, Results)

Selected on 2026-11-26 (latest generation, re-rendered with the first column
titled "Regular camera"). Provenance records are in
`research-context/result-provenance/fig_trio_*.yaml`.

| Figure | Folder | Thesis file |
| --- | --- | --- |
| Eyedrop gel, dense6 | [17_6_dense6_eyedrop](17_6_dense6_eyedrop/README.md) | `overleaf/figures/ch05/trio-eyedrop-dense6.pdf` |
| Eyedrop gel, dense7 | [17_6_dense7_eyedrop](17_6_dense7_eyedrop/README.md) | `overleaf/figures/ch05/trio-eyedrop-dense7.pdf` |
| Chicken breast, sparse | [2_7_sparse_chicken](2_7_sparse_chicken/README.md) | `overleaf/figures/ch05/trio-chicken-sparse.pdf` |
| Chicken breast, dense | [13_7_dense_chicken](13_7_dense_chicken/README.md) | `overleaf/figures/ch05/trio-chicken-dense.pdf` |

## Not used in the thesis

| Figure | Folder |
| --- | --- |
| June 3 dense eyedrop (legacy import) | [eyedrop_3_6](eyedrop_3_6/README.md) |
| June 3 dense4 eyedrop | [3_6_dense4_eyedrop](3_6_dense4_eyedrop/README.md) |
| June 3 dense6 eyedrop | [dense6](dense6/README.md) |
| Eyedrop dense10 | [17_6_dense10_eyedrop](17_6_dense10_eyedrop/README.md) |
| July 23 dense1 chicken | [23_7_dense1_chicken](23_7_dense1_chicken/README.md) |
| Illustrative layout only | [example](example/README.md) |

The single-view, alignment-evolution and displacement folders belong to the
Python figure pipeline (`scripts/figure-preparation/single_view_figure.py`);
Fig. 4.2 comes from `alignment_evolution_dense10_17_6`.

Read the [generation workflow](../../scripts/figure-preparation/generation-workflow.md)
for replay, preview-only generation, selection, and Git storage instructions.

Legacy generations preserve original files and metadata. Import dates are not
historical render dates. New previews contain no caption.

[Unassociated files](legacy-unassociated/) include the copied PDF and orphan
compiler files. [The migration report](migration-report.json) inventories those
files and the empty `beads_2um_sparse1_chicken` directory. Scientific provenance
and claims remain in `research-context/`, outside this artifact archive.
