# Technion XeLaTeX Template Audit

Date: 2026-09-20

## Result

The active `overleaf/` project now uses the pinned Technion `iitthesis`
XeLaTeX template at upstream commit
`93638a90dc02823f9715402f238c3bfce9424b69`.

## Verified migration points

- `overleaf/thesis.tex` declares `misc/iitthesis` with the `MSc` option and
  uses the template's `\makefrontmatter` and `\makebackmatter` workflow.
- `overleaf/misc/iitthesis.cls` and `overleaf/misc/iitthesis-extra.sty` are
  vendored from the pinned upstream source.
- `overleaf/.latexmkrc` invokes XeLaTeX; its upstream auxiliary-directory
  settings were removed because the installed Windows MiKTeX latexmk rejects
  them. The XeLaTeX, Biber, and glossary rules remain.
- The existing nine chapters, two appendices, bibliography, and author macros
  are included from the template's `main/`, `back/`, and `misc/` layout.
- `overleaf/verify-template.ps1` checks the template class, XeLaTeX build
  configuration, every migrated include, and the BibLaTeX bibliography path.
- `latexmk thesis` completed successfully on the local MiKTeX/XeLaTeX setup.

## Required author completion

`overleaf/misc/thesis-fields.tex` deliberately retains bracketed placeholders
for personal and submission metadata not available in the repository. The
English and Hebrew abstracts likewise require completion before submission.
