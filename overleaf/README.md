# Overleaf Thesis Project

> **Status:** active
>
> **Reviewed:** 2026-11-08

The seven main chapters follow the [authoritative structure and space
budget](../planning/revised-thesis-structure.md). The structure-only migration
retains existing prose and visuals; the compiled draft is not yet a claim of
page/figure compliance. Keep policy and migration notes outside this folder.

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

From the repository root, validate the migrated project structure with:

```text
powershell -ExecutionPolicy Bypass -File scripts/verify-template.ps1
```

The validator checks the seven ordered chapter titles, appendix boundaries, and
reachable literal source inputs. Run its regression cases from the repository
root with `powershell -ExecutionPolicy Bypass -File scripts/tests/verify-template.tests.ps1`.
These checks validate structure, not page compliance or scientific completeness.

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
