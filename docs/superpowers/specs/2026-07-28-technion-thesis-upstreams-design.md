# Technion Thesis Upstreams: Integration Design

## Purpose

Replace the generic `overleaf/` LaTeX scaffold with an active, compilable
Technion thesis project that supports Hebrew from the outset, while retaining
Hadar's completed thesis as a navigable, versioned example.  The active project
must be maintainable independently of both upstream repositories.

## Sources and pinned revisions

| Role | Repository | Pinned revision |
| --- | --- | --- |
| Active formatting/template foundation | `https://github.com/eyalroz/technion-iit-thesis.git` | `93638a90dc02823f9715402f238c3bfce9424b69` (`master`, 2026-07-13) |
| Complete reference thesis | `https://github.com/Hadar-lab/Thesis_final_version.git` | `0e487db457fb5edea550ff337839aa8a2b14a804` (`main`, 2026-07-28) |

The first source is the live upstream for the Technion document class.  The
second is a reference only; it is not a source dependency of the active thesis.

## Repository layout

```text
overleaf/                         active, self-contained compileable thesis
  thesis.tex                      official-template entry point
  front/ main/ back/ graphics/    Technion template structure and authored content
  misc/                           vendored class, template support, metadata, own macros
supporting-material/
  thesis-examples/
    hadar-thesis/                 pinned source-only reference snapshot
planning/
  upstreams.md                    provenance and update runbook
```

`overleaf/` is deliberately self-contained so it can be synchronized to
Overleaf without Git submodules, external paths, or a build-time network
dependency.  Its source will be based on the official template's layout, with
the current workspace chapters and bibliography migrated into the equivalent
locations.  Generated LaTeX artifacts remain ignored.

## Hebrew and build behavior

The active project uses the official template's XeLaTeX-oriented configuration,
including its Hebrew/front-matter machinery.  The default compile path is
`latexmk thesis` from `overleaf/`; the repository will document that Overleaf
must be configured for XeLaTeX.  No separate Hebrew project or ad hoc page
ordering will be introduced.

Hadar's `Main.tex`, `hebrewPart.tex`, scientific chapter/source files,
bibliography files, and figures are retained together as a complete reference
snapshot. They will not be imported as active source because that project
vendors an older `misc/iitcsthesis` family whereas the current official template
uses the maintained `iitthesis` class structure. Generated PDFs and LaTeX build
artifacts from that snapshot are excluded.

## Provenance and update strategy

The root Git repository will have a fetch-only remote named
`technion-template` pointing to the official repository.  The exact imported
upstream commit is recorded in `planning/upstreams.md`, alongside the Hadar
snapshot commit and file-level provenance.

Future template updates are selective, not blind merges:

1. Fetch `technion-template` and review commits and diffs since the recorded
   pin, prioritizing `misc/iitthesis.cls`, `misc/iitthesis-extra.sty`,
   `.latexmkrc`, and required build files.
2. Apply relevant upstream changes to the active project while preserving
   author-owned chapters, metadata, figures, bibliography, and macros.
3. Compile locally with XeLaTeX/`latexmk`, verify Hebrew and English front
   matter ordering, and commit the new pin with a concise update note.

Hadar's reference snapshot is refreshed only intentionally.  A refresh is a
new documented snapshot, not a merge into the active thesis.

## Failure handling and verification

If the official template does not compile in the installed TeX distribution,
the integration pauses before replacing the current scaffold.  Missing Hebrew
fonts/packages, incompatible TeX engines, or changed upstream layout commands
are treated as explicit build failures and recorded with the reproduction
command.  Completion requires a successful `latexmk thesis` build (or a clear,
environment-specific explanation if the local TeX installation is absent), plus
an inspection of the generated PDF's English and Hebrew front matter.

## Scope boundaries

This work does not import Hadar's scientific text, figures, or bibliography
into the authored thesis; they remain available only in the reference snapshot.
It excludes Hadar's generated PDF and LaTeX build artifacts. It also does not
alter the thesis argument, chapter content, research artifacts, or Overleaf
remote setup.
