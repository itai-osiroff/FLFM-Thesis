#!/usr/bin/env python3
"""Mechanical style scan for thesis prose (LaTeX or plain text).

Usage:
    python .claude/skills/thesis-prose/scripts/lint_prose.py FILE [FILE ...]
    python .claude/skills/thesis-prose/scripts/lint_prose.py --stats-only FILE

It reports, with line numbers:
  * AI-default vocabulary and phrases (adapted to scientific writing),
  * dash punctuation (em dashes, spaced en dashes),
  * stacked formulaic transitions at sentence start,
  * overclaiming words that need quantitative support,
  * sentence-length statistics compared with the supervisor's papers.

The scan is a first pass. A flag is a prompt to look, not a verdict: a word
can be a precise technical term (e.g. "robust to noise" with a measured noise
level). The judgement belongs to the writer; see SKILL.md.
"""
from __future__ import annotations

import re
import statistics
import sys
from pathlib import Path

# Words that are filler in this register. Each maps to a suggested direction.
BANNED_WORDS = {
    r"delves?|delving": "cut; say what is examined",
    r"leverag(?:e|es|ed|ing)": "use / exploit / rely on",
    r"utili[sz](?:e|es|ed|ing|ation)": "use",
    r"facilitat(?:e|es|ed|ing)": "allow / make possible / simplify",
    r"harness(?:es|ed|ing)?": "use",
    r"showcas(?:e|es|ed|ing)": "show",
    r"underscor(?:e|es|ed|ing)": "show / indicate",
    r"highlight(?:s|ed|ing)?": "show / point out (fine for a literal image highlight)",
    r"pivotal|paramount|crucial": "important, or say why it matters",
    r"seamless(?:ly)?": "cut or quantify",
    r"comprehensive(?:ly)?": "full / complete, or state the extent",
    r"holistic": "cut",
    r"groundbreaking|revolutionary|transformative|game-changer": "cut; state the measured gain",
    r"cutting-edge|state-of-the-art": "name the method being compared against",
    r"landscape|realm|tapestry|ecosystem": "field / area, or cut",
    r"intricate|intricacies|multifaceted": "complex, or describe the structure",
    r"meticulous(?:ly)?": "careful, or describe the procedure",
    r"noteworthy|commendable": "cut",
    r"vibrant|captivating": "cut",
    r"foster(?:s|ed|ing)?|empower(?:s|ed|ing)?": "cut",
    r"streamlin(?:e|es|ed|ing)": "simplify",
    r"unlock(?:s|ed|ing)?|unleash(?:es|ed|ing)?": "allow / make possible",
    r"navigat(?:e|es|ed|ing)": "only for literal navigation",
    r"embark(?:s|ed|ing)?": "begin, or cut",
    r"bolster(?:s|ed|ing)?": "support / strengthen",
    r"garner(?:s|ed|ing)?": "obtain / receive",
    r"interplay": "interaction / coupling",
    r"testament": "cut",
    r"synerg(?:y|ies|istic)": "cut",
    r"endeavou?r": "attempt / work",
    r"novel": "say what is new instead (absent from the supervisor's papers)",
    r"robust(?:ly|ness)?": "keep only with what it is robust to and the evidence (e.g. 'robust to shot noise at X photons')",
    r"key (?:insights?|ideas?|factors?|roles?|challenges?|components?|contributions?|findings?)": "name the insight itself",
    r"fundamental(?:ly)?|rigorous(?:ly)?|formidable|powerful|massive(?:ly)?|drastic(?:ally)?|stark": "hype register; state the size of the effect",
}

BANNED_PHRASES = {
    r"it is (?:worth|important to) not(?:e|ing) that": "cut the frame; state the fact (a plain 'Note that' is fine)",
    r"it should be noted that": "cut the frame",
    r"needless to say|it goes without saying": "cut",
    r"in today'?s": "cut the opener",
    r"in recent years": "give the period or cite the work",
    r"plays? an? (?:key|crucial|pivotal|vital|important) role": "say what it does",
    r"serves? as an?": "use the direct verb",
    r"acts? as an?": "use the direct verb (fine for a physical role, e.g. 'acts as a pupil stop')",
    r"pave[sd]? the way": "cut",
    r"at the forefront": "cut",
    r"push(?:es|ed)? the boundar(?:y|ies)": "cut",
    r"bridg(?:e|es|ing) the gap": "say what is connected",
    r"in conclusion|to sum up|in summary|all in all": "end on the established result instead",
    r"not only\b[^.]{0,80}\bbut also": "check whether this is emphasis filler",
    r"a wide range of|a variety of|a plethora of": "name the range or the items",
}

TRANSITIONS = r"(?:Furthermore|Additionally|Subsequently|Accordingly|As previously mentioned|As noted above|With that in mind)"
# Allowed sparingly in the supervisor's papers; counted, not flagged one by one.
SPARING = r"(?:Moreover|In addition)"

OVERCLAIM = r"\b(?:dramatic(?:ally)?|perfect(?:ly)?|always|never|prove[sdn]?|guarantee[sd]?|completely|fully|optimal(?:ly)?|unprecedented|remarkabl[ey])\b"

# Reference values measured from the supervisor's papers and the two theses
# (see references/levin-style-profile.md). Used only for orientation.
REF_MEAN_SENTENCE = (17, 24)


def strip_latex(text: str) -> list[str]:
    """Return lines with comments, math and most commands blanked (line count preserved)."""
    out = []
    in_env = False
    env_re = re.compile(r"\\begin\{(equation|align|gather|multline|eqnarray|figure|table|tikzpicture)\*?\}")
    end_re = re.compile(r"\\end\{(equation|align|gather|multline|eqnarray|figure|table|tikzpicture)\*?\}")
    for line in text.splitlines():
        line = re.sub(r"(?<!\\)%.*", "", line)
        if env_re.search(line):
            in_env = True
        if in_env:
            if end_re.search(line):
                in_env = False
            out.append("")
            continue
        line = re.sub(r"\$[^$]*\$", " X ", line)
        line = re.sub(r"\\\(.*?\\\)", " X ", line)
        line = re.sub(r"~?\\(?:cite|ref|eqref|label|autoref|cref|Cref|url|href)\*?(?:\[[^\]]*\])?\{[^}]*\}", "", line)
        line = re.sub(r"\\(?:emph|textit|textbf|gls|glspl|acrshort|acrlong|acrfull)\{([^}]*)\}", r"\1", line)
        line = re.sub(r"\\[A-Za-z]+\*?(?:\[[^\]]*\])?(?:\{[^}]*\})?", " ", line)
        line = line.replace("~", " ")
        out.append(line)
    return out


def sentences(lines: list[str]) -> list[str]:
    body = " ".join(l.strip() for l in lines if l.strip())
    body = re.sub(r"\b(?:e\.g|i\.e|et al|Fig|Figs|Eq|Eqs|Sec|Ch|cf|vs|approx)\.", lambda m: m.group(0).replace(".", ""), body)
    parts = re.split(r"(?<=[.!?])\s+(?=[A-Z])", body)
    return [p for p in parts if len(p.split()) >= 3]


def scan(path: Path, stats_only: bool) -> int:
    raw = path.read_text(encoding="utf-8", errors="replace")
    is_tex = path.suffix == ".tex"
    lines = strip_latex(raw) if is_tex else raw.splitlines()
    raw_lines = raw.splitlines()
    findings: list[tuple[int, str, str]] = []

    if not stats_only:
        for i, line in enumerate(lines, 1):
            for pat, hint in BANNED_WORDS.items():
                for m in re.finditer(rf"\b(?:{pat})\b", line, re.I):
                    findings.append((i, f"word '{m.group(0)}'", hint))
            for pat, hint in BANNED_PHRASES.items():
                for m in re.finditer(pat, line, re.I):
                    findings.append((i, f"phrase '{m.group(0)}'", hint))
            for m in re.finditer(rf"(?:^|[.!?]\s+){TRANSITIONS}\b", line):
                findings.append((i, f"transition '{m.group(0).strip(' .')}'", "connect by content, or use However/Thus/In contrast where the logic needs it"))
            for m in re.finditer(r"\bsignificant(?:ly)?\b", line, re.I):
                findings.append((i, f"degree word '{m.group(0)}'", "allowed in the plain degree sense if the magnitude is shown nearby; never implies a statistical test"))
            for m in re.finditer(OVERCLAIM, line, re.I):
                findings.append((i, f"claim word '{m.group(0)}'", "back with a number, a test, or a bounded scope; otherwise soften"))
        for i, line in enumerate(raw_lines, 1):
            code = re.sub(r"(?<!\\)%.*", "", line) if is_tex else line
            if "\u2014" in code or re.search(r"(?<!-)---(?!-)", code):
                findings.append((i, "em dash", "use a period, colon, comma or parentheses"))
            if "\u2013" in code and re.search(r"\s\u2013\s", code) or re.search(r"\s--\s", code):
                findings.append((i, "spaced en dash", "use a period, colon, comma or parentheses ('--' in ranges and paired names is fine)"))

    sents = sentences(lines)
    sparing = sum(len(re.findall(rf"(?:^|[.!?]\s+){SPARING}\b", l)) for l in lines)
    lens = [len(s.split()) for s in sents]
    print(f"== {path}")
    if lens:
        long_ = [s for s in sents if len(s.split()) > 40]
        we = sum(len(re.findall(r"\b[Ww]e\b|\b[Oo]ur\b", s)) for s in sents)
        print(f"   sentences: {len(lens)}  mean {statistics.mean(lens):.1f}  median {statistics.median(lens):.0f}  "
              f"max {max(lens)}  >40 words: {len(long_)}  we/our: {we}  Moreover/In addition: {sparing}")
        if sparing > max(1, len(lens) // 40):
            print("   note: Moreover/In addition used more than about once per 40 sentences; connect by content instead")
        lo, hi = REF_MEAN_SENTENCE
        m = statistics.mean(lens)
        if m > hi:
            print(f"   note: mean sentence length is above the reference band {lo}-{hi}; split the longest sentences")
        for s in long_[:5]:
            print(f"   long ({len(s.split())}w): {s[:110]}...")
    for ln, what, hint in sorted(findings):
        print(f"   L{ln}: {what} -> {hint}")
    if not stats_only:
        print(f"   {len(findings)} flag(s)")
    return len(findings)


def main(argv: list[str]) -> int:
    stats_only = "--stats-only" in argv
    files = [Path(a) for a in argv if not a.startswith("--")]
    if not files:
        print(__doc__)
        return 2
    total = sum(scan(f, stats_only) for f in files)
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
