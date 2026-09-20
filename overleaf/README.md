# Overleaf Thesis Project

This folder is the self-contained Technion thesis project intended to sync with
Overleaf. Its entry point is `thesis.tex`, using the vendored `iitthesis`
class at the revision recorded in `../planning/upstreams.md`.

Build locally from this directory with:

```text
latexmk thesis
```

Configure the Overleaf compiler as **XeLaTeX**. The template requires XeLaTeX,
the Hebrew font support provided by the upstream template, Biber, and
makeglossaries.

Keep this folder lean:

- Include thesis source files.
- Include the active bibliography.
- Include final figures and tables that are used by the thesis.
- Exclude literature PDFs, rough notes, raw data, active code, and large intermediate outputs.

Recommended sync model:

1. Use Overleaf as the online editor.
2. Pull and push this folder through Overleaf Git or through a GitHub-backed Overleaf project.
3. Keep the broader workspace local as the thesis archive and planning area.

Before a submission build, replace every bracketed placeholder in
`misc/thesis-fields.tex` and complete the English and Hebrew abstracts.

