# Thesis Workspace

This workspace is organized as a thesis-writing project with provenance hooks.
It is not intended to be the main computational research repository.

The project should answer:

- What is the thesis argument?
- Which sources support each claim?
- Which finalized figures, tables, and outputs are used in the thesis?
- Where did each result come from?

The heavier research code, raw data, and active experiments should live in their
own research repositories or storage locations, with pointers recorded here.

## Main Areas

- `overleaf/`: LaTeX thesis project intended to sync with Overleaf.
- `literature/`: External papers, books, thesis examples, and reading notes.
- `research-context/`: Pointers to code, datasets, experiment summaries, and result provenance.
- `finalized-outputs/`: Final figures, source figure files, and final tables before inclusion.
- `supporting-material/`: Material created by the author that may support the thesis.
- `planning/`: Thesis outline, writing log, supervisor meetings, open questions, and claim tracking.
- `docs/superpowers/`: Project design and implementation planning documents.

Hadar's thesis is the primary comparative thesis reference because it shares
the supervisor and field; its documented role and the resulting independent
writing standard are in `literature/thesis-examples/hadar-reference-standard.md`
and `planning/writing-standard.md`.

## Working Rule

Overleaf should contain the compileable thesis and nearby assets only. Keep
reference PDFs, rough notes, full datasets, and active code outside Overleaf.
