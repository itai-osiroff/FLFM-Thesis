# Style profile: two earlier MSc theses in the Levin group

> **Status:** reference
>
> **Reviewed:** 2026-11-12

Sources: Hadar Cohen's MSc thesis (2026, LaTeX sources in
`literature/thesis-examples/Hadar's Thesis/`) and Evgeniia Saiko's MSc thesis
(2023, PDF supplied by the author). Measured on 2026-11-12 from the body text,
excluding Hebrew, front matter, and bibliography. Fragments are under 15 words
and are illustrations of a pattern, never text to reuse.

**Main finding.** Hadar writes in two registers. Her Framework, Conclusion,
Appendix and most of Related Work use the plain voice of the group's papers.
Her Introduction and Evaluation use a hype register: all of her em dashes and
almost all of her hype words sit in those two files. The plain register matches
Saiko closely. Treat that plain register as the house style; avoid the other.

Where this thesis differs by author decision (see
`planning/revised-thesis-structure.md`): it has a combined Chapter 7
Discussion and Conclusions instead of discussion inside the results chapter,
and the introduction has no roadmap. Those decisions win over the examples.

## 1. Numbers

| Measure | Hadar | Saiko | House band |
|---|---|---|---|
| Mean / median sentence length | 21.8 / 20 | 18.7 / 17 | 17–22 words |
| Sentences over 40 words | 5% | 3% | rare |
| Sentences under 12 words | 13% | 22% | short sentences are normal |
| Paragraph length (median) | ≈70 words | ≈69 words | 3–5 sentences |
| we/our/us per 1000 words | 16 | 32 | "we" throughout |
| "I" / "my" | 0 | 0 | never |
| Passives per sentence | 0.20 | 0.22 | passive for procedures |
| Em dashes | 14 (Intro/Eval only) | 0 | none |
| Semicolons per 1000 words | 0.8 | 0.3 | rare |
| Parentheses per 1000 words | 11.5 | 18.6 | frequent: symbols, abbreviations, panels |
| Contractions | 0 | 4 (slips) | none |

Hedges are light and mostly attached to interpretation: "suggests", "may",
"often", "typically", "We hypothesize", "we believe".

## 2. Thesis shape

- Introduction about 3 pages; final chapter 1–2 pages; long appendix.
- No "The rest of this thesis is organized as follows" paragraph. Signposting
  is local: "In the next section we describe…", "In the previous chapter, we
  showed that…".
- Chapters open with a definition, a taxonomy ("Attempts to overcome
  scattering generally fall into two classes"), what the analysis relies on, or
  a purpose clause ("To systematically evaluate…").
- Chapters close on a limitation or a forward pointer, or simply stop at the
  last technical point. No wrap-up paragraph.

## 3. Abstract moves

Task → prior approaches and their cost → key idea (often framed against
conventional wisdom: speckle "is generally considered as noise… However… we
argue") → what was built and tested, with numbers → what worked → what did not,
stated plainly. Saiko's abstract is the better model: concrete, and it admits a
negative result ("While we did not succeed in applying…").

## 4. Introduction moves

1. Define the phenomenon and the task.
2. Prior work in two or three classes, each with its limitation.
3. "The goal of this thesis is…".
4. The physical property exploited.
5. The approach in "We…" sentences with concrete numbers ("narrow cone of 8°").
6. Scope limits ("Our approaches apply mostly to viscous or solid materials").

Contributions are stated in running prose, not a bulleted list. A numbered
list is acceptable for a set of compared methods.

## 5. Theory exposition

- A "Math Notations" list in the front matter, and symbols redefined locally
  anyway with "where X denotes…".
- Equations introduced by a clause ("can be written as", "we define … as:"),
  followed by a plain-language reading and the validity regime ("applies only
  to relatively thin samples").
- Full derivations in the appendix ("See Appendix 6.1 for a full derivation"),
  with run-in step labels there. Borrowed results stated as attributed claims
  with the proof deferred to the source.
- The group's earlier results are credited by name as the foundation.

## 6. Setup and methods

- Body: functional description of the optics in prose ("We use a 4f system
  consisting of two lenses…"), with a schematic panel.
- Appendix: component inventory with vendor and model, plus run-in labelled
  practical notes ("Registering speckle images.", "Ballistic problems.").
- Key parameters inline where they matter ("we used 100 × 100 pixel windows").

## 7. Results

- Each experiment opens with its goal and design ("To validate our approach we
  generated…") and names its ground truth.
- Figure references are in the sentence and panel-specific ("In Fig. 4.2(b)…").
- Comparisons carry numbers ("a large gain (+0.121) while … only marginally
  (+0.012)").
- Failures are reported in the first person with candidate causes ("We can
  think about two possible reasons").
- Limitations as run-in labelled paragraphs ("Angular range.", "Tissue."), each
  with cause and what would remove it.

## 8. Captions

Median about 70 words, self-contained. Bold title phrase, one sentence on what
is compared, then "(a)… (b)…", disclosed conditions (sample, parameters,
colour-bar range), and often a one-sentence takeaway. Borrowed panels credited
in the caption.

## 9. Final chapter

Opens with "We presented…" or "In this work…", restates each contribution with
its status (validated, or not solved), and lists concrete future directions,
each with what it would require. Self-assessment in plain words: "simple and
elegant but it is not able to retrieve…".

## 10. Vocabulary

Sentence-initial transitions, Hadar / Saiko: As 5/22, However 13/12, While
12/8, Thus 2/7, In practice 1/6, As a result 2/5, In contrast 4/4, Despite 1/4,
Finally 2/4, Consequently 4/0, For simplicity 1/3, Therefore 1/2, Hence 0/2,
Note that 0/5. Furthermore / Moreover / Additionally: at most one each.

Words from the anti-AI list that do appear: "framework" (8, mostly vague),
"significant(ly)" (13, never statistical), "novel" (3, self-praise),
"robust" (3, technical, robustness to noise), "utilize" (2), "leverage" (1),
"serves as" (2). Hadar's hype register adds fundamental, rigorous, formidable,
critical, powerful, massive, drastically, stark.

## 11. Flaws not to imitate

- Paper leftovers: "In this paper", "the main paper", a placeholder URL.
- Grammar slips: "succeed to", "a local minima", doubled words, "successively"
  for successfully, "Note, that", contractions.
- Hype adjectives and em-dash asides; slogan labels in quotes.
- Inconsistent counts and names across chapters (five vs six approaches;
  two spellings of one method name; optical density vs optical depth).
- A results discussion that contradicts the conclusion.
- Vague claims: "several key insights", "significantly" with no test.
- Verbatim-duplicated captions, sentence fragments, numbering gaps.
