# Versioned trio figure workflow

Every setup, replay, or preview retains a separate generation. A successful
published generation advances **latest**. Only an explicit selection changes
the stable **selected** export; selection is not scientific qualification.

Setup supports Back/Next navigation and automatic checkpoints. See the
[adjustment and resume guide](README.md#follow-the-review-steps). A draft is
separate from generation history and never advances latest or selected.

## Replay and preview

Add `scripts/figure-preparation` to the MATLAB path. For an existing figure:

```matlab
figureDirectory = fullfile(repoRoot, 'candidate-outputs', 'figures-source', 'eyedrop_3_6');
recipePath = fullfile(figureDirectory, 'trio-recipe.json');
result = replay_trio_figure(recipePath, dataRoot);
assert(strcmp(result.status, 'complete'), result.error.message);
disp(result.previewPath);
```

Replay needs the external captures and reconstruction workspace. To use saved
images without raw data, take a generation directory from the figure's README:

```matlab
preview = preview_trio_figure(result.generationDirectory);
% Explicitly adopt today's shared renderer, rather than the saved snapshot:
variant = preview_trio_figure(result.generationDirectory, 'UseCurrentTemplate', true);
```

Preview derivations preserve their parent ID and inherited scientific provenance.
They do not assert a new reconstruction or rerun registration. Both create new
generations and leave their sources unchanged. A recipe-less legacy example
can be previewed but cannot be replayed from reconstruction data.

Setup, replay and preview accept these name/value options:

| Option | Default | Meaning |
| --- | --- | --- |
| `OutputDirectory` | Figure root | Root for generation history, not a flat bundle destination |
| `Publish` | `true` | Advance latest after success; `false` retains an inspection attempt without changing pointers |
| `CompilerExecutable` | `pdflatex` | Compiler name on PATH or absolute executable path, including paths with spaces |

Setup also accepts `SceneId` and `FigureId`. Replay additionally accepts
`ReferenceDirectory`: a legacy asset folder, generation, or `assets/` directory.
Default references are the recipe's generation assets, or the figure root's
latest successful assets. A missing local reference does not relax a required
exact-match gate. Preview additionally accepts `UseCurrentTemplate` (false).

Recipes inside `metadata/` resolve back to their figure root. Legacy flat
recipes resolve to their containing directory. Root working recipes are editable;
`result.recipePath` always names an exact retained snapshot, including after setup.
New layouts resolve assets internally; `figure.assetDirectoryFromWrapper` remains
legacy recipe metadata and is not used to locate a generation's images.

`TRIO_FIGURE_DATA_ROOT` remains available for setup/replay; pass an empty root
argument to replay when combining the environment fallback with name/value options.
Existing recipe schemas 2 and 3 remain supported with linked brightness.
Schema 4 adds opt-in independent intermediate/final display multipliers while
retaining shared normalization and all manifest/recovery requirements. Schema 5
adds shared or separate reconstruction workspaces. Schema 6 adds
`presentation.display`: explicit black/white windows, optional display-only
processing (off by default), and per-region zoom windows. Schemas 2 to 5 replay
with their original pixels; drafts and manifests preserve the mode, gains,
windows and processing, and final review discloses them. A generation also
writes `latex/display-caption.txt`.

To improve an existing figure's display, seed a new setup from it with
`setup_trio_figure(dataRoot, 'StartFrom', <figure root, generation or recipe>)`.
The source stays untouched; the new generation joins the source figure's
history unless `FigureId` forks it. See the
[start-from guide](README.md#start-from-an-existing-figure).

## Storage and returned paths

```text
<figure-id>/
  README.md                         Human-readable history and preview links
  figure-index.json                 Latest/selected IDs and attempt summaries
  trio-recipe.json                  Editable working recipe, when available
  setup-draft.json                  Git-ignored resumable setup checkpoint
  generations/<UTC-time>-<unique-id>/
    assets/                         Three main PNGs and six zoom PNGs
    metadata/trio-recipe.json        Exact recipe snapshot, when available
    metadata/generation-manifest.json
    latex/trio-layout.tex
    latex/trio-comparison-template.tex
    latex/preview.tex                Standalone figure-only document
    preview.pdf                     Present when compilation succeeds
    build/                          Compiler logs and intermediate files
  selected/                         Explicitly exported version
```

The manifest distinguishes figure generation IDs from upstream reconstruction
generation IDs. It retains input hashes, effective processing and comparison
results, calibration, provenance gaps, output hashes, repository revision and
working-file hashes, renderer snapshot, and compiler version/status. Original
legacy files are preserved under `legacy-*/legacy-original/`; import time is
not asserted to be their historical generation time.

| Result field | Meaning |
| --- | --- |
| `generationId`, `generationDirectory` | Retained attempt ID and folder |
| `status`, `error` | Complete/incomplete status and diagnostics |
| `previewPath`, `manifestPath` | Actual saved paths; unavailable preview is empty |
| `recipePath` | Replay's retained recipe; setup no longer returns a deleted temporary path |
| `outputDirectory` | Figure root |
| `publishedManifestPath` | Complete published generation's manifest; otherwise empty |
| `stagingDirectory` | Compatibility alias for the retained generation directory; never deleted after publication |
| `assetNames`, `outputs` | Replay PNG names and hashes; images live under `assets/` |
| `crop`, `candidateComparison` | Effective replay crop and pixel comparisons |

History is Git-ignored by default; the index and selected export are trackable.
To share a generation, use `git add -f <figure>/generations/<id>` while excluding
`build/` intermediates. Legacy imports are trackable by default so migration
does not silently lose existing evidence. An index entry alone does not mean
the history exists on another checkout. Back up local history; nothing prunes it.

## Select a version for LaTeX

```matlab
selection = select_trio_figure(figureDirectory, result.generationId);
```

Only complete generations passing their configured comparison gate can be
selected. The command verifies artifact hashes and exports assets, metadata,
LaTeX sources, and the PDF to `selected/`. New generations do not change this
export. Include the selected PDF in an author-maintained figure environment:

```tex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=\linewidth]{path/to/figure/selected/preview.pdf}
  \caption{Author-maintained scientific caption.}
  \label{fig:my-trio}
\end{figure}
```

Alternatively, define `\TrioFigureDirectory` as that selected directory relative
to the thesis compile folder and input `selected/figure.tex`. The selected
bundle can be copied elsewhere; compile its sources from `selected/latex/`.

The PDF is tightly cropped, with column titles but no caption. The shared
renderer retains the 3% zoom overlap. Each generation snapshots its renderer;
later template edits cannot silently alter earlier previews. The Technion
template and files under `overleaf/` are unchanged.

## Failures and migration

Install `pdflatex`, `standalone`, `graphicx`, and TikZ before generating previews.
Compiler runs disable shell escape and time out after 120 seconds.
Preflight recipe/input errors retain their existing error identifiers and create
no generation. Errors after generation begins return `status='incomplete'` and
retain available artifacts. Batch scripts must check status explicitly.

Missing compiler/build errors retain `build/compiler.log`; comparison failures
retain their results. Neither advances latest or selected. After fixing the
compiler, derive a new preview from the failed generation if its images/layout
exist. A preview cannot bypass a rejected comparison; fix and replay the recipe.

A `.figure-lock` rejects concurrent writers. After a crash, verify no writer is
running before removing a stale lock. A `.selected-backup` flags an interrupted
selection; preserve it and inspect the index/export before retrying.

`migrate_trio_figures()` imports existing flat bundles, hashes every original
and copy, builds a derived preview, then removes only verified loose files.
It leaves the working recipe in place. Successful imports are skipped on repeat
invocations; failed previews retain originals and can be retried. Legacy imports
retain their original recipes, manifests, wrapper text, and captioned PDFs.
No generation is selected automatically. The July 12 caption mismatch is flagged
without rewriting historical text. The copied PDF and orphan build files are
archived as unassociated artifacts; empty directories are inventoried.
