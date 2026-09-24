# June 3 dense4 provenance

The reusable pipeline now lives one directory up. The candidate recipe is
[`candidate-outputs/figures-source/eyedrop_3_6/trio-recipe.json`](../../../candidate-outputs/figures-source/eyedrop_3_6/trio-recipe.json), and the shared
commands are documented in [`scripts/figure-preparation/README.md`](../README.md).
`run_figure_replay` remains as a compatibility wrapper for existing commands;
new figures use `replay_trio_figure` and their own recipe.

This directory retains only `source-snapshots/`: byte-for-byte copies of the
four external MATLAB scripts that informed the dense4 reconstruction. They are
historical provenance, not reusable implementation templates. `.gitattributes`
keeps their original line endings in version control. Their source SHA-256
values are:

| Source file | SHA-256 |
| --- | --- |
| `downsample_point_match.m` | `a3abd32d46ffd405653aa2fa3186c9a1471209bec15c8539d1df1c24ffa92a37` |
| `downsample_align_crop.m` | `b198d8bed3bc214c9555105603b77e9b92d1c8de55c95216eb047b6c209986c0` |
| `zoom_and_save.m` | `37f180b55e780237590bbb9c92bb4b5e913510f0af0c84a1aaada6810f3c0e0e` |
| `temp.m` | `57c978570ff6e382a23f147a9a40bcf3f81a76cf83602c019040e9d1bbdbff10` |

The archived run still available on disk is `algo_run/regular_run_best`, while
its upstream manifest records the earlier `algo_run/regular_run` path. The
scene recipe and replay manifest retain both facts.
