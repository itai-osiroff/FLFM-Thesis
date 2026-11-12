# Anti-AI rules, adapted to this thesis

> **Status:** reference
>
> **Reviewed:** 2026-11-12

This file adapts the `anti-ai-writing` skill (v2.1.0) to a scientific thesis in
the Levin group. That skill was written for emails, posts and marketing copy;
several of its rules would damage technical prose. Every ruling below was
checked against what the supervisor and the two earlier theses actually do
(`levin-style-profile.md`, `student-thesis-profile.md`). When the supervisor's
real usage and a generic rule disagree, her usage wins.

## Layer 1: words, phrases, punctuation

### Banned outright (absent from the supervisor's own papers)

delve, leverage, utilize, harness, showcase, underscore, pivotal, paramount,
crucial, seamless, comprehensive, holistic, groundbreaking, revolutionary,
transformative, cutting-edge, landscape, realm, tapestry, ecosystem, intricate,
multifaceted, meticulous, noteworthy, commendable, vibrant, foster, empower,
streamline, unlock, unleash, embark, bolster, garner, interplay, testament,
synergy, endeavour, novel, notably, Furthermore, Additionally, Subsequently,
"key" as an adjective ("key insight"), "enable" used as hype.

Also the hype register from one earlier thesis: massive, formidable, stark,
drastically, powerful, rigorous (as praise), critical (as praise), slogan
labels in quotation marks.

Replacement direction: use the plain verb (use, show, allow, help, obtain) or
state the measured effect. If deleting the word loses nothing, delete it.

### Allowed because the supervisor uses them

| Item | Condition |
|---|---|
| "Note that…", "We note that…" | Adds a caveat, an assumption, or an acquisition-parity condition. The inflated frames "It is worth noting", "It is important to note", "It should be noted" are cut. |
| significant(ly) | Plain degree sense with the magnitude nearby. Never suggests a statistical test that was not run. Prefer the number. |
| Moreover, In addition | Sparingly (about once per 40 sentences), never as paragraph glue. |
| robust | Only with the thing it is robust to and evidence ("robust to shot noise down to X photons per pixel"). |
| facilitate, framework | Narrow technical sense only. "framework" for this thesis's method is banned: call it the reconstruction method. |
| demonstrate, visualize, fundamental (physics sense), essentially, promising (intro framing) | Allowed in their literal sense. |
| acts as | Physical role only ("the lenslet array acts as a Shack–Hartmann sensor"). "serves as" is rewritten. |

### Punctuation and structure

- **Em dashes: none.** The supervisor has two in 20,000 words. Use a period, a
  colon, a comma pair, or parentheses. In LaTeX, `---` is an em dash.
- **En dashes: ranges and paired names only.** `10--30`, `Fig.~3(c--d)`,
  `Shack--Hartmann`. Never a spaced `--` as an aside.
- **Hyphens: technical compounds stay.** "light-field", "pupil-conjugate",
  "global-then-local", "noise-robust", "one-hot" are standard terms. The generic
  rule against compound hyphens does not apply. Do cut decorative compounds
  ("game-changing", "best-in-class").
- **Semicolons: rare** (under 1 per 1000 words). Build long sentences with
  "While…", "Since…", "As…" clauses instead.
- **No contractions, exclamation marks, or rhetorical questions.** A question
  is acceptable only as an explicit research question.
- **No bulleted lists with bold titles in prose.** Contributions and findings
  are sentences, enumerated at most with "First…, Second…" or "(i)… (ii)…".
  Run-in paragraph heads ("Angular range.", "Compact support:") are group style
  for limitation lists, setup notes, and appendix steps; do not run a whole
  chapter on them.
- **Rule of three by reflex.** Lists of exactly three interchangeable items are
  a tell. Give the real count of things: two, four, or one.
- **Weak verb frames.** "plays a role in", "serves as a", "is designed to", "is
  positioned to": replace with the direct verb.
- **Vague quantity phrases.** "a wide range of", "a variety of", "several key":
  name the range or the items.

## Layer 2: discourse habits, translated to thesis register

The anti-AI skill's discourse layer was measured on fiction and applied to
short-form business writing. A thesis is a technical register where
explicitness and closure are partly required. Apply the habits below; ignore
the reader-address, emotion, and time-jump signals, which do not belong in a
thesis.

1. **Moralizing summary sentence.** A paragraph that ends "This highlights the
   importance of accurate alignment" is the tell. End instead on the concrete
   consequence ("This limits the correction to shifts smaller than the search
   window."). A chapter close that states what was established and what remains
   open is required by `planning/writing-standard.md`; it must name the
   specific result and the specific open item, not recap in general words.
2. **Single clean track.** Every result reading as a success is a tell and a
   scientific problem. Put the failure, no-change case, or protocol limit
   beside the result it qualifies.
3. **Manufactured closure.** If a question is unresolved (a provenance gap, an
   untested regime), say so and stop. Do not resolve it with an assumption.
4. **Atmospheric opener.** "Microscopy has long fascinated scientists" or
   "In recent years, there has been growing interest in…". Open on the
   physical problem or the claim, as the supervisor does.
5. **Vague allusion.** "Prior work has shown", "studies suggest", "it is well
   known". Name the work and cite it, or name the measurement. If nothing can
   be named, the claim is not ready to write.
6. **Front-loaded re-explanation.** Do not rebuild in Chapter 6 what Chapter 3
   defined. Refer back ("the sub-aperture views defined in
   Chapter~\ref{…}") and move on.
7. **Uniform volume.** Every sentence at the same weight. Let the main finding
   carry a number and stand in a short sentence of its own.
8. **Epilogue paragraph.** A final paragraph that restates the section adds
   nothing. Cut it and check that nothing was lost.

**The source test.** Every addition made while editing (a number, a
limitation, a citation) must trace to something real: the draft, a source in
the bibliography, a provenance record, or the claim tracker. If it cannot be
traced, do not add it; record the gap instead.
