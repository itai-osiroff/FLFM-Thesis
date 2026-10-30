# example

Latest successful: `20261030T080855440Z-295b8d87-73c`  
Selected: ``

Generation history is local unless explicitly tracked. A missing folder on another checkout means its history has not been shared.

| Generation | Operation | Status | Storage here | Preview |
| --- | --- | --- | --- | --- |
| `legacy-4fb53480-523` | legacy-import | legacy_imported | present (Git tracking optional) | - |
| `20261030T080855440Z-295b8d87-73c` | preview | complete | present (Git tracking optional) | [PDF](generations/20261030T080855440Z-295b8d87-73c/preview.pdf) |

Use `preview_trio_figure(generationDirectory)` without raw data. Use `select_trio_figure(figureDirectory, generationId)` to export a version; selection is not scientific qualification.

Include the selected PDF with `\includegraphics[width=\linewidth]{path/to/this/figure/selected/preview.pdf}`.

To share a generation: `git add -f path/to/this/figure/generations/<id>` (omit build intermediates). Legacy imports are tracked by default.
