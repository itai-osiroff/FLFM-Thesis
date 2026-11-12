---
name: thesis-prose
description: Draft, revise, or audit prose for the FLFM MSc thesis so that it reads like the supervisor's (Prof. Anat Levin's) group papers and the earlier MSc theses by her students, with no AI-default voice, and stays within the project's writing standard, chapter budgets, and evidence rules. Use this whenever the user asks to write, draft, rewrite, tighten, polish, condense, review, or "fix the style" of any thesis text in this repository (a chapter, section, paragraph, abstract, figure caption, or Hebrew-part English source), even if they don't mention style, the supervisor, or AI tells. Also use it for "does this sound like Anat?", "make this less AI", "strict review of chapter N", or when turning notes, evidence records, or worksheets into thesis prose.
---

# Thesis prose in the Levin-group voice

This skill writes and edits English prose for the thesis *Light Field
Microscopy for High-Speed High-Fidelity Recovery of Aberrated 2D Fluorescent
Scenes*. It merges four sources of guidance into one working method:

1. The project's own rules: `planning/writing-standard.md`,
   `planning/prose-and-figure-standard.md`, `planning/technical-writing-guide.md`
   (which digests `literature/writing-guidance/`), and the structure and budget
   in `planning/revised-thesis-structure.md`.
2. The supervisor's voice, measured from four of her group's papers:
   `references/levin-style-profile.md`.
3. The house style of two earlier MSc theses in the group, and their flaws:
   `references/student-thesis-profile.md`.
4. The anti-AI-writing rules, adapted to scientific prose:
   `references/anti-ai-scientific.md`.

**Order of authority when they disagree:** project structure, budget, and
evidence rules first; then the writing standard; then the supervisor's measured
usage; then the earlier theses; then the generic anti-AI rules. For example,
the supervisor writes "Note that" and uses "significantly" in a plain degree
sense, so those stay even though the generic anti-AI list bans them; and the
author decided the introduction has no roadmap, which overrides papers that
have one.

Good style cannot rescue an unsupported claim, so the evidence checks below
are part of the method, not an extra.

## Choose the mode

- **Draft**: the user wants new prose from notes, a plan, a worksheet, or
  evidence records.
- **Revise**: the user has text (in `overleaf/main/*.tex` or pasted) and wants
  it improved, condensed, or made to sound like the group.
- **Audit** ("strict review", "does this pass", "score this", "check chapter
  N"): report findings, do not rewrite unless asked afterwards. See "Audit
  output" below.

## Before writing a word

1. Read `planning/revised-thesis-structure.md`. Identify the chapter, what it
   owns, and its page budget. Read the chapter plan if one exists
   (`planning/0N-*-plan.md`). Prose that belongs to another chapter goes there,
   or is flagged, not written here.
2. For any result or factual claim, check `planning/claim-tracker.md` and
   `planning/open-questions.md`, and the relevant record in
   `research-context/` (method notes, result provenance). For literature
   claims, use only sources in `overleaf/back/` that have been inspected.
3. For models, algorithms, equations, or evaluation, also apply
   `planning/technical-writing-guide.md` and the fields of
   `planning/templates/technical-stage.md`.
4. Read the surrounding text of the chapter (and neighbouring chapters if
   you will refer back) so terminology, notation, and macros (`\lfm`, `\psf`,
   glossary entries) match what is already there.

Never fill a gap with a plausible fact. Where evidence is missing, write
`[MISSING: what is needed; which record would resolve it]` in the draft and
tell the user. Do not attribute a current code observation to an older result.

## The voice in brief

Read `references/levin-style-profile.md` before the first draft in a session;
it has the measured numbers and patterns. The working summary:

**Sentences and paragraphs**
- Mean about 20 words per sentence (supervisor 21, theses 19–22), median
  about 19. Mix 30–40 word explanatory sentences with short consequence
  sentences ("Thus, the result is imperfect."). Over 40 words is rare: split.
- Paragraphs of about four sentences, one job each. Open with a topic claim
  about the subject ("The main limitation of X is that…", "An important
  assumption underlying X is that…") or a purpose clause ("To estimate the
  local shift, we…"). Close on a consequence, not a restatement.
- Chain sentences with "This…", "These…", "Such…" referring to the previous
  idea.

**Voice and stance**
- First-person plural "we", active, in roughly half the sentences. Never "I".
  Passive for procedures where the agent does not matter. Refer to the work as
  "this thesis" or "this work", never "this paper".
- Claim verbs: show, derive, demonstrate, use, visualize, observe, estimate.
- Bound claims by naming the condition, the sample, or the current
  implementation ("Our current results apply only to nominally 2D scenes"),
  not with stacked hedges. Hedge interpretation, not measurement. No "might",
  no "may potentially".
- Credit prior work before naming its limit, and frame the limit as an
  assumption or regime: "…led to impressive results, but it assumes…",
  "…was only demonstrated when…". Never disparage.

**Transitions** (by the supervisor's frequency): However (default contrast),
As / Since / While (setup clauses), Thus / Hence / As a result /
Consequently (consequence), To this end / For that (means), In contrast, In
practice, Note that / We note that (caveat), For simplicity (assumption),
First… Second… Finally (enumeration). Moreover and In addition sparingly. Not
Furthermore, Additionally, Subsequently.

**Technical exposition**
- Name the concrete problem before the operation or equation that addresses it.
- Set up with "Consider…" and "We denote by…". Lead into an equation with a
  verbal predicate that the equation completes ("…can be expressed as",
  "…is modeled as", "…are related as", "…reduces to").
- After the equation: "where X denotes…" for every new symbol, then what the
  relation means or predicts ("Equation~\eqref{…} implies that…", "That is,…").
- State simplifications up front and call them that ("For simplicity, we
  neglect…", "Note that this model assumes…"), with the regime where they hold.
- Mark intuition ("Intuitively, this is because…"). A short inline numerical
  example is welcome when it makes a scale concrete.
- Keep the claim, assumptions, and intuition in the main text; move the
  derivation to Appendix B ("see Appendix~\ref{…} for the derivation").

**Results**
- Open each experiment with its purpose, sample, reference, and condition.
- Make the figure the subject or frame it: "In Fig.~\ref{…} we compare…",
  "Figure~\ref{…}(b) shows…". Walk through panels in the text.
- Give comparisons as numbers against a named baseline (a ratio, a difference,
  an order of magnitude). Compare the global-stage average with the final
  rectified image from the same run.
- State explicitly what the validation camera or reference was and was not
  used for ("We emphasize that the validation image is not used by the
  reconstruction"), and whether it informed selection.
- Report failures and no-change cases next to the result they qualify, then
  give candidate causes ("This is because…", "We see two possible reasons…").

**Captions** (60–100 words typical): a short title phrase ending in a period;
one or two sentences on what is shown and compared; a panel or column guide
"(a)… (b)…"; the observation the figure supports; disclosures (sample,
condition, scale bar, display range, normalization, matched exposure, what the
reference was used for). The caption must stand alone. Details in
`planning/prose-and-figure-standard.md`.

**Chapter shape**
- Start each chapter with the question it answers. End by stating what was
  established and what remains open, concretely, without an epilogue
  paragraph. Link chapters with one sentence ("Chapter~\ref{…} showed that…"),
  not roadmaps.
- Introduction ladder (no roadmap, no bulleted contributions): physical
  problem → consequence → promising approach and how it works → practical
  obstacle → existing approaches, each with one limitation → the gap as an
  assumption that fails → "The goal of this thesis is…" → what we do, as "We…"
  sentences with scope and, where available, a number.
- Discussion and Conclusions: open with a one-sentence summary of what was
  done ("We recovered…"), explain the mechanism behind the main finding, give
  each limitation its own paragraph with cause and possible remedy, then
  concrete future directions, each with what it would require. End on a
  concrete implication. No new evidence in Chapter 7.

## What to keep out

The full list with rulings is in `references/anti-ai-scientific.md`. The
short version:

- AI-default vocabulary: delve, leverage, utilize, harness, showcase, crucial,
  pivotal, seamless, comprehensive, landscape, novel, notably, "key insight",
  and the hype register (massive, formidable, powerful, stark, rigorous).
- Inflated frames: "It is worth noting that", "It is important to note that",
  "plays a crucial role in", "serves as a", "In recent years", "In conclusion".
- Em dashes and spaced en dashes (en dashes for ranges and paired names only).
  Technical compound hyphens ("light-field", "pupil-conjugate") are fine.
- Bulleted bold-title lists in prose; reflexive triplets; contractions;
  rhetorical questions; moralizing last sentences; epilogue paragraphs.
- Earlier-thesis flaws: paper leftovers ("this paper"), inconsistent names and
  counts across chapters, "significantly" implying an untested statistic,
  vague "several insights", a discussion that contradicts the results.
- Copying: the papers and theses are models of how to communicate. Never
  reuse their sentences, equations, figures, or claims. Short fragments in the
  reference files show patterns only.

## Thesis-specific scientific wording

These come from the project rules and are easy to get wrong in fluent prose:

- The reconstruction is **one two-stage method**: global alignment (one
  translation per view) followed by local pixelwise refinement. The
  global-stage average is an intermediate image; the final rectified image is
  the average after local refinement (saved as `local_average`). Do not
  present global and local as two competing methods.
- It is registration and averaging of views of a nominally 2D scene. It is not
  learned reconstruction, deconvolution, wavefront recovery, scattering
  inversion, or volumetric reconstruction. Do not describe it with a generic
  inverse-problem objective it does not have.
- Use the exact score normalization from the method notes, not an unsupported
  "NCC" label. An argmax over a finite candidate set is not a guarantee of
  optimal recovery.
- A reference image used to choose a candidate is not an independent held-out
  test. Say which role it had.

## Workflow

### Draft

1. Do the "Before writing" checks. Write a one-line statement of the
   paragraph's or section's job and the claim it supports.
2. Draft in LaTeX that matches the chapter's conventions (`\cite{}`, `~\ref`,
   `\eqref`, project macros). Write connected prose, not worksheet headings.
3. Run the mechanical scan on the result (see below) and fix what it flags.
4. Reread against the voice summary: topic sentences, consequences at
   paragraph ends, "where" after equations, numbers in comparisons, failures
   beside results, no epilogue.
5. Check the budget: estimate the page-equivalent of the new prose and say
   whether the chapter is now over its target. Do not shrink fonts, margins, or
   scientific qualifications to fit; flag the overrun.

### Revise

1. Read the passage in full once for meaning before changing anything.
2. Run the scan and read the flags as prompts, not verdicts.
3. Edit at both levels: words and punctuation first (subtraction before
   addition), then paragraph and section shape.
4. Preserve every scientific qualification, citation, and number. If a cut
   would remove a qualification, keep it and flag the length problem instead.
5. Apply the source test: any number, limitation, or citation you add must
   trace to the draft, the bibliography, a provenance record, or the claim
   tracker.
6. Edit the `.tex` file in place when the user asked for changes there;
   otherwise return the rewrite.

Output for a revision: the rewritten text (or the applied edit), then a short
"Changes" list of the 3–6 most important edits (original → new, one line of
why), then any `[MISSING: …]` gaps and budget notes. Skip the list for a
one-sentence fix.

### Audit output

First line: a verdict (Ready / Needs minor edits / Needs revision) for the
passage. Then findings, most serious first, each with the quoted text (short),
its location (`file:line`), the rule it breaks (project standard, supervisor
voice, thesis house style, or anti-AI), and the fix. Group scientific problems
(unsupported claim, wrong method description, missing disclosure) above style
problems. End with one line on what the passage would lose if every finding
were applied mechanically, so the author can judge the trade-off.

## Mechanical scan

`scripts/lint_prose.py` strips LaTeX math, citations and commands, then reports
AI-default words, inflated phrases, dash misuse, banned transitions, overclaim
words, and sentence-length statistics against the group's band:

```bash
python -I .claude/skills/thesis-prose/scripts/lint_prose.py overleaf/main/03_light_field_microscope.tex
```

Run it from the repository root. It accepts several files and `--stats-only`.
A flag means "look again": "significantly" with a number beside it is fine;
"robust" with the noise level it tolerates is fine. The scan cannot judge
paragraph shape, claim support, or the discourse habits, so it never replaces
the reread.

## After substantive work

Update the `Reviewed` date (and `Status` if it changed) on any Markdown
document you edited, and add a row to `planning/writing-log.md` (date, area,
change, next step). Record new evidence gaps in `planning/open-questions.md`.
Do not commit unless the user asks.
