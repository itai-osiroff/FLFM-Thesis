# Style profile: Prof. Anat Levin's group papers

> **Status:** reference
>
> **Reviewed:** 2026-11-12

Measured on 2026-11-12 from about 20,300 words of main text (947 sentences) in
four papers. The PDFs live outside Git at
`G:/Other computers/My PC/Technion/Msc/research material/papers/anat reference papers/`.

| ID | Paper |
|---|---|
| P1 | *Fluorescent wavefront shaping using incoherent iterative phase conjugation*, Optica 2022 |
| P2 | *Non-invasive and noise-robust light focusing using confocal wavefront shaping*, Nat. Commun. 2024 |
| P3 | *Rapid wavefront shaping using an optical gradient acquisition*, Nat. Commun. 2026 |
| P4 | *Understanding multi-layered transmission matrices*, CVPR 2025 |

P3 (a different first author) is a vocabulary outlier: it holds nearly all the
words that the anti-AI list flags (showcase, utilize, leverage, crucial,
framework, Additionally). P1, P2 and P4 agree with each other and are the safer
model of the supervisor's voice. Fragments below are under 15 words and
illustrate a pattern. Never reuse them as thesis text.

## 1. Numbers

| Measure | Value (all four) | Spread |
|---|---|---|
| Mean / median sentence length | 21.4 / 19 words | P3 19.3 to P4 23.8 |
| Sentences over 35 words | about 8% | |
| Sentences under 10 words | about 7% | |
| Sentences per paragraph | median 4 (80–110 words) | |
| "we" per 1000 words | about 21 | |
| Sentences containing we/our/us | about 45% | |
| Sentences with a passive | about 23% | higher in methods text |
| Semicolons per 1000 words | under 1 | |
| Parentheses per 1000 words | about 10 | abbreviations, panels, equation numbers |
| Em dashes in prose | 2 in 20,000 words | effectively none |
| En dashes | ranges only ("10–30 images", "Fig. 3(c–d)") | |
| Contractions, exclamation marks | 0 | |
| Questions | 3, all in one research-question list (P4) | |

Hedging is light and attached to a quantity or condition: "can" (capability)
dominates, then "usually", "typically", "in practice", "about" with numbers.
"may" appears 2–3 times per paper; "might" and "roughly" never.

## 2. Voice and stance

- Plural "we", active and direct. Claim verbs by frequency: show, use,
  visualize, start, demonstrate, derive. "We show that, surprisingly, …" (P1).
- Claims are bounded by naming the condition, not by vague hedges: "Our current
  results apply only on a sparse set of fluorescent particles" (P1); "limited
  due to computational constraints" (P4).
- Limitations come with a cause and often a remedy: "Another drawback of the
  approach is that…" (P2); "To alleviate this problem, we could…" (P1).
- Prior work is credited before its limit is named, and the limit is framed as
  an assumption or regime: "has led to impressive results, but it is ultimately
  limited by…" (P3); "were only demonstrated when…" (P2). The group's own work
  is placed as "orthogonal" or complementary where that is true.
- Sparse evaluative words: "surprisingly", "nicely focused", "rather
  challenging", one colloquial aside per paper at most.

## 3. Paragraphs

- Open with a topic claim about the subject: "The main limitation of X is
  that…", "An important assumption underlying X is that…", or a purpose clause:
  "To study the incoherent case, we need to adjust the model above in two ways."
  In results, open with the figure: "In Fig. 3 we visualize…".
- Close on a consequence: "This greatly limits its applicability to thin or
  sparse volumes." Not on a restatement.
- Chain sentences with demonstratives ("This…", "These techniques…", "Such
  systems…"). "This" opens 56 sentences.
- Sequence: problem, why it is hard, idea, how, evidence. Signposts are short:
  "We start by… We then… Finally, we demonstrate…".

## 4. Introduction ladder

1. Broad physical problem.
2. Consequence for applications ("In turn, this precludes…").
3. The promising approach, defined mechanically, with a short history.
4. The practical obstacle.
5. Existing approaches as a ladder, each with one limitation in one or two
   sentences, linked by "However", "As a result", "Even if".
6. The gap as a violated assumption ("An important assumption underlying… is").
7. The goal: "Our goal in this work is to…".
8. The response as enumerated findings: "report two findings: First, we show…
   Second, we show that…".
9. A headline number against the baseline ("10–30 images, compared to
   thousands").

No bulleted contribution list; contributions are "we show/derive/demonstrate"
sentences. (This thesis: no roadmap paragraph, by author decision.)

## 5. Technical exposition

- Set up a model with "Consider…" and "We denote by…".
- Lead into equations with a verbal predicate ending at the equation: "are
  related as", "can be expressed as", "is modeled as … :", "reduces to".
- Follow with "where X denotes…", then interpret: "Equation (4) implies
  that…", "That is,…", "Therefore, when focusing is achieved, Eq. (5) reduces
  to Eq. (2)".
- State simplifications up front and name them as such: "For simplicity, the
  following derivation considers…"; "Note that Eq. (1) offers a simplistic
  description…, assuming…".
- Mark intuition explicitly: "Intuitively, this is because…", "To gain
  intuition, consider Fig. 6(b)." Add an inline numerical example when it helps.
- Decompose expressions term by term ("a product of three terms. The first…").
- Keep the claim in the main text and send the derivation to the supplement or
  appendix ("we review the derivation in Supplement 1").

## 6. Results

- The figure is the grammatical subject or framed as "In Fig. X we
  visualize/show…". A bare "(Fig. 3)" is rare.
- Walk through panels in the text: "Figure 3(a) shows… As can be observed,…
  In Fig. 3(b), we visualize…".
- Gains as multipliers or orders of magnitude against a named baseline: "about
  20× higher", "orders of magnitude smaller than…".
- Independence of validation data stated outright: "We emphasize that
  measurements from this camera are not used by our algorithm" (P1, repeated in
  P2 and P3).
- Anomalies explained causally ("This is because…"); partial failures reported
  ("are either not recovered or strongly aberrated").

## 7. Captions

1. Short title phrase ending in a colon or period ("Algorithm convergence.").
2. One or two "We visualize/show…" sentences on what is shown.
3. Panel or column guide: "(a)… (b)…", "Columns 1–2: …".
4. Often one interpretive sentence ("As predicted by theory, …").
5. Disclosures: sample and thickness, acquisition parity ("equal exposure and
   equal excitation power"), normalization ("normalized to its own maximum"),
   how a number was computed, scale bars, reference caveats ("the validation
   camera cannot always capture an aberration-free image").

Typical length 60–100 words.

## 8. Vocabulary

Sentence-initial transitions across the four papers: However 34, As (causal)
26, While 15, Since 15, Thus 10, In this work 9, Note that 8, Even 8, We note
that 7, Despite 7, Moreover 6, In contrast 6, Finally 6, In practice 6, To this
end 5, Consequently 5, Hence 5, As a result 4, For that 4, For simplicity 4,
Therefore 3, In addition 3, Alternatively 3, Similarly 3, That is 3, Additionally
1 (P3), Furthermore 0.

Other habits: "rather than" (18), "the fact that" (15), "in practice", "one
can / one needs" as a generic subject, "simply", "not straightforward",
"e.g." mostly inside parentheses, run-in paragraph heads ("Compact support:"),
emphasis by words ("We emphasize that…", "Importantly,") not typography.

### Conflicts with the generic anti-AI list

| Word | Her use | Ruling for this thesis |
|---|---|---|
| Note that / We note that | Core signature, adds a caveat or assumption | Allowed. Only the inflated frames ("It is worth noting", "It is important to note") are cut. |
| significant(ly) | Frequent, plain degree sense, never statistical | Allowed for degree when the magnitude is shown nearby; never implies a statistical test. Prefer the number. |
| Moreover / In addition | Sparing additive transitions | Allowed sparingly, not as paragraph glue. |
| robust | "noise-robust", "robustness to noise" | Allowed only with the thing it is robust to and evidence. |
| facilitate, framework | Narrow technical senses | Tolerated in that sense only; otherwise rewrite. |
| demonstrate, visualize | Standard verbs | Allowed. |
| hyphenated compounds | Standard technical terms ("noise-robust", "one-hot", "light-field") | Allowed; the anti-AI hyphen ban does not apply to technical compounds. |
| utilize, leverage, showcase, crucial, Additionally, enable-as-hype, novel, key (adj.), comprehensive, Furthermore | Absent from P1, P2, P4 | Banned. |
