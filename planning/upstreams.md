# Thesis Template and Reference Provenance

## Active template

- Repository: `https://github.com/eyalroz/technion-iit-thesis.git`
- Branch and pin: `master` at `93638a90dc02823f9715402f238c3bfce9424b69`
- Role: vendored, active Technion formatting/template foundation for
  `overleaf/`; provides the modern XeLaTeX Hebrew/English workflow.
- Imported files: `overleaf/thesis.tex`, `overleaf/.latexmkrc`, and the
  maintained class/support files in `overleaf/misc/`. Author-owned chapters,
  front matter, bibliography, and macros are adapted into the template layout.

Update selectively: fetch `technion-template`, review changes since the
recorded pin, apply class/style/build changes without overwriting author-owned
chapters or assets, rebuild with `latexmk thesis`, and record the new pin in
the same commit.

## Primary comparative reference

- Repository: `https://github.com/Hadar-lab/Thesis_final_version.git`
- Local snapshot: `literature/thesis-examples/Hadar's Thesis/`
- Current local commit: `84d527209314980d96689d6a59c895e6600c0167`
- Role: primary comparative reference because it shares the supervisor and
  field. It informs the independent project writing standard, not active thesis
  content or formatting code.

The local folder is an upstream clone with its own `.git` directory. Do not add
that nested repository as a gitlink or merge its source into `overleaf/`.
Refresh it deliberately, inspect the new commit, and update this record plus
the reference note when its role or contents change.

Its legacy Babel/David CLM stack does not complete PDF conversion in the current
MiKTeX/XeLaTeX environment. A modern active thesis must use the maintained
Technion template instead. The reference may be built in an environment
compatible with its legacy font pipeline; its source remains available for
inspection regardless.

## Asset and originality rules

The reference's source figures, including PDF figure assets, are retained for
study. Generated `Main.pdf` and LaTeX build outputs are ignored. Do not copy
reference prose, figures, data, equations, bibliography entries, or claims into
the active thesis; use the project's own evidence and provenance records.
