# Hadar Reference Standard Design

## Purpose

Give Hadar's thesis a deliberate, documented role as the primary comparative
reference for this thesis because it shares the same supervisor and scientific
field. Its role is to improve editorial judgment and presentation standards,
not to supply thesis content.

## Reference hierarchy

Hadar's thesis is the primary comparative reference among the examples in
`literature/thesis-examples/`. Other examples remain useful secondary sources
for format-specific or disciplinary comparison. This designation is recorded
once in the reference documentation and provenance record; routine workspace
documents should refer instead to the project writing standard.

## What the standard adopts

The project writing standard derives the following independent expectations:

- Build each chapter around a scientific question and a clear contribution to
  the thesis argument.
- Move from motivation and prior work through model or method, evaluation, and
  limitations; do not mix evidence, interpretation, and future work.
- Use precise, bounded scientific claims that state the tested setting and do
  not generalize beyond the evidence.
- Use figures as an argument: establish setup or model first, then show the
  result and its evaluation; write captions that identify the data, condition,
  comparison, and takeaway without relying on surrounding prose.
- Keep methods reproducible through exact experimental, data, parameter, and
  source-code provenance, consistent with the project's existing controls.
- Maintain a formal, direct tone: define technical terms when introduced,
  make transitions explicit, and state limitations alongside results.

## Boundaries

The standard does not authorize copying Hadar's prose, scientific claims,
equations, figures, bibliography entries, experimental results, or
interpretations. Every claim and asset in the active thesis remains traceable
to the author's own sources and evidence.

Hadar's legacy document class is not adopted for the active thesis. The active
project continues to use the maintained Technion template; the reference's
Hebrew/English organization informs quality expectations only.

## Documentation changes

Create a local reference note alongside Hadar's source snapshot, and create a
single `planning/writing-standard.md` used by chapter planning and drafting.
Update the chapter synthesis map and revised thesis structure to point to this
standard, not repeatedly to Hadar. Update the upstream/provenance documentation
to classify Hadar as the primary comparative reference and record its source
commit and local-build compatibility caveat.

## Verification

Review the updated documents for three conditions: Hadar's special role is
unambiguous; project-wide writing rules are usable without reopening the
reference thesis; and originality/provenance boundaries remain explicit.
