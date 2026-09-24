# June 3 Dense4 Eyedrop Figure Replay

This directory makes the candidate `eyedrop_3_6` figure reproducible from
the saved June 3 reconstruction workspace and its matching camera captures.
It does not rerun the upstream FLFM reconstruction algorithm.

## Run

The first argument is the local `3_6_26` data root. It is deliberately kept
outside Git.

```powershell
matlab -batch "addpath('scripts/figure-preparation/eyedrop-2026-06-03-dense4'); result=run_figure_replay('C:\Users\admin2\OneDrive - Technion\office computer files\images_output\3_6_26'); disp(result.publishedManifestPath);"
```

The runner uses a staging directory inside the candidate asset folder. It
publishes the nine PNGs and `replay-manifest.json` only after every input,
crop, ROI, and candidate-image comparison succeeds. Use `Publish`, `false`
to retain a staging directory for inspection:

```matlab
result = run_figure_replay(dataRoot, 'OutputDirectory', tempname, 'Publish', false);
```

The MATLAB test suite runs a replay, validates its assets, rejects a missing
data root, and compares two independent replay hashes:

```powershell
matlab -batch "addpath('scripts/figure-preparation/eyedrop-2026-06-03-dense4'); results=runtests('scripts/figure-preparation/eyedrop-2026-06-03-dense4/tests/test_figure_replay.m'); assert(all([results.Passed]));"
```

## Inputs and processing

`replay_config.json` is the canonical record for input filenames, the
expected generation ID, camera orientation, downsampling factors,
registration sweep, crop, display scaling, and zoom ROIs. ROI coordinates
are zero-based pixels with a top-left origin in the 4× exported panel.
Its ThorCam multiplier of `1.4867` was re-established by an exact pixel match
to the checked-in candidate because the old GUI value was never saved.

The runner validates all three raw captures, then uses the saved workspace's
`average_rectified_global_image` and `average_rectified_image` arrays. The
main-camera capture identifies the scene; the ThorCam and validation images
are downsampled, registered to the global average, and used to derive the
common crop. The candidate asset set contains the ThorCam, global, and local
panels plus two aligned crops from each panel.

The archived run available on disk is `algo_run/regular_run_best`, but its
upstream `experiment_manifest.json` still records the former
`algo_run/regular_run` path. The replay manifest preserves both paths rather
than treating the old path as available.

The runner requires MATLAB with Image Processing Toolbox and Statistics and
Machine Learning Toolbox. It has been exercised with MATLAB R2025b.

## Script copies

`source-snapshots/` contains byte-for-byte source copies from the external
`images_output` directory. `.gitattributes` keeps their original line endings
in version control. Their source SHA-256 values are:

| Source file | SHA-256 |
| --- | --- |
| `downsample_point_match.m` | `a3abd32d46ffd405653aa2fa3186c9a1471209bec15c8539d1df1c24ffa92a37` |
| `downsample_align_crop.m` | `b198d8bed3bc214c9555105603b77e9b92d1c8de55c95216eb047b6c209986c0` |
| `zoom_and_save.m` | `37f180b55e780237590bbb9c92bb4b5e913510f0af0c84a1aaada6810f3c0e0e` |
| `temp.m` | `57c978570ff6e382a23f147a9a40bcf3f81a76cf83602c019040e9d1bbdbff10` |

The same four names in this directory are working copies. `downsample_align_crop.m`
and `zoom_and_save.m` are deterministic functions used by the runner.
`downsample_point_match.m` accepts saved point pairs as an optional calibration
helper. `temp.m` is an opt-in diagnostic with no hardcoded path and is never
called by the canonical replay.

## Provenance boundary

The replay manifest records exact input and output hashes, registration
results, crop bounds, intensity settings, ROIs, source-snapshot hashes, and
the MATLAB version. It establishes how these candidate assets were prepared;
it does not qualify the figure for final thesis use or establish the scientific
claims in its caption.
