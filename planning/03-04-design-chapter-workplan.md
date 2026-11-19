# Workplan: rebuilding Chapter 3 around the system design (Chapters 3 and 4 content)

> **Status:** draft (proposed, awaiting author approval)
>
> **Reviewed:** 2026-11-19
>
> **Inputs:** supervisor meeting with Anat Levin, 2026-11-17 (Zoom transcript,
> Hebrew, about 83 min; timestamps below are `mm:ss` into it); the author's
> meeting notes of the same date; current
> [03_light_field_microscope.tex](../overleaf/main/03_light_field_microscope.tex);
> [Chapter 3 plan](03-light-field-model-plan.md); [Chapter 4 plan](04-our-setup-plan.md).
>
> **Scope agreed with the author:** this pass writes the content of Chapters 3
> and 4 together, ignoring the page budget. Separating it into the two chapters
> and condensing it to budget is a later, explicit step (Phase 6). Every block below
> is tagged with its planned home: **[3]** Chapter 3, **[4]** Chapter 4,
> **[B]** Appendix B (derivations).

## 0. Status (2026-11-17, end of day)

- **Division of work:** the author drafts the chapter text (Phases 3–6). Claude
  edits `.tex` files only for the $N$ notation change. Everything else in the
  phases below is guidance for the author's drafting.
- **Done:** Phase 1 conventions and constants (Section 5a). Q1–Q3 answered.
- **Done, $N$ notation:** Guo's ratio ρ is now $N$ in
  `03_light_field_microscope.tex` and in the figures `flfm-path.tex` and
  `dof-geometry.tex`. The retained view grid is now $K\times K$ in Chapter 3
  (measurement paragraph), Chapter 4 (extraction paragraph, zero-based
  indices), Chapter 5, and Appendix A. Nothing else in those files changed.
  The build passes and the template validator passes.
- **Done, scaffolding (2026-11-17, after the author's go-ahead to edit `.tex`):**
  the former Chapter 3 now lives whole in Appendix D
  (`overleaf/main/d_chapter3_backup.tex`, label `app:ch3-backup`, temporary,
  delete before submission), with small fixes listed in its header comment.
  Chapter 3 is a skeleton following blocks S0–S10: section headings, boxed
  `\draftnote` guidance (macro in `misc/my-thesis-specific.tex`), the key
  equations in the new notation, the design-parameter table, and the
  non-abbreviated paragraphs carried over verbatim into S0, S2, S9, S10.
- **Done by the author:** the sensor-size inequality in Phase 2 now carries
  $M_{cam}$ on its right-hand side.
- **Watch when drafting:**
  - the abbreviated section still says "$R_{uv}\equiv N$";
  - its depth-of-field numbers use Guo's FWHM convention, which differs by a
    factor 2 from Section 5a;
  - `axial-parallax.tex` still draws the lenses (Phase 4).

## 1. What the meeting changed

Anat reviewed the abbreviated calculation section, through the cheat sheet. She
accepted the physics. She rejected the presentation: it is a chain of
calculations through focal lengths. She wants a design story told in
NA and N. Her points, with where they were made:

| # | Decision or request | Where |
| --- | --- | --- |
| D1 | Resolution is set by the NA of each view, nothing else. A view is equivalent to a mask in the Fourier plane that passes $1/N$ of the pupil, so $\mathrm{NA}_{view}=\mathrm{NA}/N$. Do not propagate a lenslet spot back through magnifications in the main text. | 05:11–08:33, 36:10–36:50, 60:26 |
| D2 | $N$ is the number of lenslets across the pupil (Fourier-plane width divided by lenslet width). Both agreed this is Guo's occupancy ratio, used per axis. | 11:37–12:37, 33:02–33:13 |
| D3 | Start the chapter with the **design parameters**, then the calculations. The design choices are the number of lenslets $N$, the field of view, and the number of sensor pixels. Pixel *size* is matched afterwards by the camera relay magnification. | 17:49–18:41, 30:27–31:02, 42:53–43:03, 79:00–79:21 |
| D4 | Choosing $N$ is choosing the resolution: "the first design parameter is the resolution, which sets the number of lenslets". | 40:00–40:39 |
| D5 | The field of view sets the lenslet focal length $f_{MLA}$: the views must not overlap, and a larger field packs more detail into one view, so it needs more pixels. | 13:24–16:02, 28:13–30:11, 37:01–37:06, 41:01–42:26 |
| D6 | Sensor pixel count: a conventional microscope needs about $\mathrm{FOV}/\Delta x_o$ pixels across. Light field keeps the same count: $N$ images, each $N$ times coarser. For Nyquist sampling, halve the field (or double the pixels). | 31:19–32:22, 41:34–41:52, 47:14–48:14 |
| D7 | Depth of field is a property of the NA: dividing the NA by $N$ multiplies the depth of field by $N^2$. Do not derive it through the $f$'s. | 49:01–51:04 |
| D8 | Circle of confusion (pixel term in the DOF): "assuming normal sampling it is negligible, I would ignore it". | 52:27–52:46 |
| D9 | Axial resolution: keep only the two-emitter parallax part of the figure (no lenses). The extreme ray is set by the objective NA. Separation $\approx\Delta z\cdot\mathrm{NA}$, resolved when it reaches $\Delta x_{LF}$. Hence $\Delta z_{LF}\approx\lambda N/\mathrm{NA}^2$ "up to a factor 2". | 67:18–68:12, 69:09–69:30, 71:35–74:29 |
| D10 | Conclusion to state: axial resolution is $N$ times worse, depth of field $N^2$ times larger, so a light-field capture separates about $N$ depth planes in one shot. In a conventional microscope axial resolution and DOF are the same quantity. | 75:00–76:21, 79:36–79:48 |
| D11 | Order of presentation: (1) reminders for a conventional microscope with exact constants, small-angle approximation ($\tan\theta\approx\sin\theta$); (2) the light-field results as factors of $N$ and $N^2$; (3) the exact calculations, some of them in the appendix. | 76:34–78:35 |
| D12 | Final formulas must be functions of NA and $N$ only. Where possible, write them as multiples of the conventional values. | 80:14–80:39 |
| D13 | Notation: replace $R_{NIP}$ etc. with $\Delta x_o$, $\Delta x_{LF}=N\,\Delta x_o$, $\Delta z_o=\lambda/\mathrm{NA}_o^2$, $\Delta z_{LF}=N\,\Delta z_o$, $\mathrm{Range}_{z,o}$ and $\mathrm{Range}_{z,LF}=N^2\,\mathrm{Range}_{z,o}$. Here $o$ is the conventional microscope and $LF$ the light field. | 80:52–82:58 |
| D14 | Leave the camera relay out of the resolution story ("no need to complicate the calculation"). | 02:36–02:51 |
| D15 | It is fine to show afterwards that the NA/N formula agrees with the focal-length calculation, as a consistency check. | 38:30–38:50 |

Anat thinks Guo et al. 2019 over-complicate the design (35:48–35:54, 50:18–50:42).
Guo stays the citation for the FLFM-specific relations, but the thesis
derivation follows the NA/N route.

## 2. The target result set (in the new notation)

These are the formulas the rebuilt chapter should land on. The constants are
**not final** (see Phase 1). Values use the cheat-sheet design inputs:
λ = 0.53 µm back-solved, NA = 0.75, N = 7.5, M = 50, 4600 px of 2.74 µm. They
are design values, not measurements.

| Quantity | Conventional ($o$) | Light field ($LF$) | Design value ($LF$) |
| --- | --- | --- | --- |
| Lateral resolution | $\Delta x_o=\lambda/(2\mathrm{NA})$ | $\Delta x_{LF}=N\,\Delta x_o$ | 2.65 µm (0.35 µm conventional) |
| Axial resolution | $\Delta z_o\approx\lambda/\mathrm{NA}^2$ | $\Delta z_{LF}=\Delta x_{LF}/\tan\theta_{max}\approx\frac{N}{2}\,\Delta z_o$ | 3.5 µm |
| Depth of field | $\mathrm{Range}_{z,o}\approx\lambda/\mathrm{NA}^2$ ($=\Delta z_o$) | $\mathrm{Range}_{z,LF}=N^2\,\mathrm{Range}_{z,o}$ | 53 µm (73 µm with the pixel term) |
| Separable depth planes | about 1 | $\mathrm{Range}_{z,LF}/\Delta z_{LF}\approx N$ (2N with these constants) | about 15 |
| Sensor pixels across | $\mathrm{FOV}/\Delta x_o$ (×2 for Nyquist) | same: $N$ views × $\mathrm{FOV}/\Delta x_{LF}$ | FOV ≈ 0.81 mm at Nyquist |

Three things about this table need to be said in the plan, because they
change what the chapter can claim.

1. **The factor 2 in axial resolution** (Anat noted it, 74:19). With
   $\Delta x_o=\lambda/2\mathrm{NA}$ and $\Delta z_o=\lambda/\mathrm{NA}^2$ the
   parallax argument gives $\Delta z_{LF}=(N/2)\Delta z_o$, and the plane count
   comes out $2N$, not $N$. Phase 1 fixes one convention (Rayleigh or FWHM for
   both axes, same criterion in both columns). The headline "about $N$ planes"
   holds only up to that constant. The chapter must state which.
2. **$\theta_{max}$ comes from the outermost view used, not the full NA.** The
   centre of the outermost lenslet sits inside the pupil edge,
   $\tan\theta_{max}\approx\mathrm{NA}(1-1/N)$ for an integer grid. This sits
   behind "≈" in the main text and goes into Appendix B with the retained-view
   set (Chapter 4 open item).
3. **The camera relay question has a likely answer.** *(Derived here, not in the
   meeting; verify.)* With the pupil filling the sensor, the Nyquist field
   $\mathrm{FOV}=N_{px}\,\Delta x_o/2=4600\times0.353/2\approx 812$ µm. This matches the
   no-overlap field the lenslets give, $d f_{FL}/(f_{MLA}M)=818$ µm. The relay
   that makes the pupil fill the sensor is $M_{cam}=12.6/22.5=0.56$. At that relay
   $S_r=1.99$. So the design point is exactly Anat's rule (D6) at
   $M_{cam}=0.56$. The installed 0.375 relay leaves the sensor a third empty and
   samples at $S_r=1.33$.

   One hypothesis for 0.375: it fits the whole 30 mm array on the sensor
   (11.25 mm < 12.6 mm). Ask whoever built the relay. Until then the chapter
   reports the trade-off and does not invent the reason. This answers notes
   item "Sampling ratio vs. camera magnification" and note TODO 1's "what if
   I'm asked about it".

## 3. Target structure (merged content, before separation)

Order follows D3, D11 and the author's note TODO 1 ("design parameters → what
they decide → calculations"). The "unheaded stretches" rule of the 2026-11-09
decision is suspended for the merged draft. Subsection headings are used while
drafting, and the decision on keeping them is taken at Phase 6.

| Block | Content | Tag | Replaces / reuses |
| --- | --- | --- | --- |
| **S0 Scope** | What the chapter does: the measured sensor frame versus the reconstructed 2D image; the chapter explains how the instrument is designed and what that design implies for resolution and depth. | [3] | Non-abbreviated ¶1 (lines 136–141); B1 |
| **S1 Conventional microscope reminders** | $\Delta x_o$, $\Delta z_o$, $\mathrm{Range}_{z,o}$, with cited constants; the statement that conventionally axial resolution and depth of field coincide (D10); small-angle convention. Then the aperture argument from the 2026-11-12 meeting: shrinking the aperture deepens the focus but superposes depths. | [3] | New; folds in old B2 (aperture trade-off) |
| **S2 From a microscope to a Fourier light-field microscope** | The MLA in the pupil-conjugate plane. Each lenslet passes $1/N$ of the pupil (the Fourier-mask picture, D1) and forms one view. Definition of $N$ (D2): lenslets across the pupil diameter, need not be an integer, the total view count is about $N^2$ ($\pi N^2/4$ for a round pupil on a square grid). Coordinates and view notation $V_{ij}(y,x)$. Light-path figure. | [3] | Old B4 first half; non-abbreviated lines 143–163 (coordinates, extraction); `flfm-path` figure |
| **S3 Design parameters and what each one sets** | The design table (Section 4 of this plan): $N$ → resolution, $d_{MLA}$; FOV and sensor pixel count → $f_{MLA}$; pixel pitch and sensor size → camera relay $M_{cam}$; the Fourier-lens relay $f_{FL}/M$ sets the pupil size on the array so that $N$ lenslets of the available pitch cover it. Sampling ratio is a consequence, not a choice (author note TODO 1). | [3] concept; [4] our numbers | New; replaces "Magnifications, camera spec" opening |
| **S4 The light field in factors of N (gist)** | The four results in one display: $\Delta x_{LF}=N\Delta x_o$, $\Delta z_{LF}\approx N\Delta z_o$, $\mathrm{Range}_{z,LF}=N^2\mathrm{Range}_{z,o}$, hence about $N$ separable planes in one capture. One paragraph of meaning. This is the chapter's main message. | [3] | New (D10, D11, D13) |
| **S5 Lateral resolution and the spatial–angular trade-off** | Derivation via $\mathrm{NA}/N$ (D1). One sentence that the focal-length route gives the same number (D15), with the full chain in [B]. Trade-off: larger $N$ = more views and better depth discrimination, coarser views. | [3], chain in [B] | Old subsection 1 (lines 8–44) |
| **S6 Axial resolution** | The two-emitter parallax argument with the lens-free figure (D9). Result in NA and $N$. Remark that it degrades away from focus (Guo's simulation) if kept. | [3], $d_{max}$ version in [B] | Old subsection 2 (lines 46–69); `axial-parallax` figure to redraw |
| **S7 Depth of field** | $\mathrm{NA}/N$ ⇒ $N^2$ (D7). Pixel/circle-of-confusion term dropped from the main text under a stated sampling assumption (D8, but see decision Q4). Cross-talk limit: a sentence saying it is set by the no-overlap choice of $f_{MLA}$ in S3 and does not bind here (about 4 mm against 53 µm). | [3], both full limits in [B] | Old subsection 3 (lines 71–99); `dof-geometry` figure: panel (a) moves to S3 or [B], panel (b) simplified |
| **S8 Field of view, sensor and sampling** | No-overlap condition and $f_{MLA}$; pixels per view $=N_{px}/N$; Nyquist field (D6). Our numbers: pupil on sensor, $M_{cam}$, $S_r=1.33$, the 0.375 vs 0.56 trade-off and what it costs (pixel-limited lateral resolution about 4 µm). | concept [3]; numbers and table [4] | Old subsection 4 (lines 101–133); Chapter 4 design-values table |
| **S9 Image formation for a nominally 2D scene** | Unchanged from the existing plan (B5): a flat scene gives views that correspond up to known geometry; the 2D assumption holds inside $\mathrm{Range}_{z,LF}$. | [3] | Old B5; non-abbreviated lines 147–150, 165–169 |
| **S10 Aberration and scattering** | Unchanged from the existing plan (B6): pupil phase error shifts each view by its local slope; defocus is the special case that S6 already showed; scattering as a limit. Handoff to Chapter 5. | [3] | Old B6; non-abbreviated line 171 |
| **S11 Our instrument** | Light paths, camera roles, sample, acquisition and extraction, evaluation summary, per the Chapter 4 plan S1–S5, with the design-values table rewritten in the new notation. | [4] | `04_our_setup.tex`; Chapter 4 plan |
| **Appendix B** | Focal-length chain for $\Delta x_{LF}$; axial resolution with $d_{max}$ and the outermost-view caveat; both DOF limits with the pixel term; $M_T$, $p$, $S_r$; sensor-fit inequality (fixed, see Phase 2). | [B] | Current abbreviated derivations, mostly verbatim |

## 4. The design-parameter table (core of S3)

To be built in Phase 3 from the meeting (D3–D6). Draft:

**Superseded on 2026-11-18 by the table in Section 5b** (author decisions:
the objective and camera are given; $N$ and the field of view are the two
design choices; all hardware follows from them). The original draft is kept
below for the record.

| You choose | Constrained by | It sets | Relation (NA/N form) |
| --- | --- | --- | --- |
| Objective NA, $M$ | specimen, working distance | $\Delta x_o$, $\Delta z_o$; pupil size | $D_{pupil}=2\,\mathrm{NA}\,f_{obj}$ |
| Number of lenslets across the pupil $N$ | required lateral resolution vs. number of depth planes | $\Delta x_{LF}$, $\Delta z_{LF}$, $\mathrm{Range}_{z,LF}$ | factors $N$, $N$, $N^2$ |
| Fourier-lens relay $f_{FL}$ (given the available pitch $d_{MLA}$) | $N$ and the lenslet pitch on the market | pupil size on the array | $D_{proj}=2\mathrm{NA}f_{FL}/M=N\,d_{MLA}$ |
| Field of view | sensor pixel count, sampling | lenslet focal length $f_{MLA}$ (no overlap) | $\mathrm{FOV}=d_{MLA}f_{FL}/(f_{MLA}M)$; at Nyquist $\mathrm{FOV}\le N_{px}\Delta x_o/2$ |
| Camera relay $M_{cam}$ | pixel pitch $P$, sensor size | fit and sampling ratio | $M_{cam}\le D_{cam}/D_{proj}$; $S_r=\Delta x_{LF}\,M_T/P$ |

Two facts the table must make visible. First, the camera was given and the
design adapts to it (author note TODO 2). Second, the history matters: which of
$d_{MLA}=3$ mm and $f_{MLA}=55$ mm were chosen from a catalogue and which were
designed (author note TODO 4, "review recording"). If the lenslets were bought
off the shelf, the chapter says the relations *explain* the choice and does not
claim it was derived from them.

## 5. Work phases

Each phase ends with something the author can check. Phases 1–2 are short and
unblock the rest.

### Phase 1: settle conventions and constants (blocks everything)

- [ ] Pick the lateral criterion (Abbe $\lambda/2\mathrm{NA}$, used so far, or Rayleigh $0.61\lambda/\mathrm{NA}$) and the matching axial one ($\lambda n/\mathrm{NA}^2$ or $2\lambda n/\mathrm{NA}^2$). Anat: "the chat will bring the exact constants" (76:46). Source them from Goodman 2017 (already in `thesis.bib`; §7.3 p. 197, §8.1 pp. 231–233) or another inspected text, not from memory, and record page locators in this file.
- [ ] Decide what "resolvable planes" means numerically ($N$ or $2N$), consistent with the above.
- [ ] Decide the symbol question (Q1 below) and update the notation row in the Chapter 3 plan.
- [ ] Fix λ: the emission band is still an open item. Until it closes, the chapter keeps symbolic results and labels the λ = 0.53 µm numbers as back-solved.

**Done when:** a one-screen notation and constants block exists in this file
and the author has approved it.

### Phase 2: repair what is wrong in the current text (small, independent)

- [ ] Sensor-size inequality (`03_light_field_microscope.tex` line 107): the right-hand side equals $D_{proj}$, not $M_{cam}D_{proj}$. Fix before the text moves to Appendix B.
- [ ] Line 10, "allow ourselves to ignore the magnification system": keep the meaning (D14), in plain words.
- [ ] Chapter 3 plan, notation row: currently says "use ρ, not N". Superseded by Q1 once decided.

### Phase 3: write the design story (S1–S4)

- [ ] S1: conventional reminders with sourced constants; the aperture/superposition paragraph from the 2026-11-12 supervisor points (Chapter 3 plan, "Supervisor request").
- [ ] S2: the Fourier-mask explanation of a view; $N$ defined once; view count $\approx N^2$.
- [ ] S3: the design table (Section 4), in prose plus table; order resolution → $N$ → $d_{MLA}$ and $f_{FL}$; FOV + pixels → $f_{MLA}$; pixel pitch → $M_{cam}$.
- [ ] S4: the gist display and the "about $N$ planes in one capture" message.
- [ ] Get the historical design reasoning from the author (Q2) before finalising S3's wording.

**Done when:** S1–S4 compile and every formula there uses only NA, $N$, λ (and
$N_{px}$, FOV in S3).

### Phase 4: rewrite the calculations (S5–S8) and move the long forms to Appendix B

- [ ] S5 lateral: NA/N derivation (three lines); one sentence that the focal-length chain agrees; chain moved to [B] unchanged except for notation.
- [ ] S6 axial: redraw `axial-parallax.tex` without the lenses (D9, author note 10). The new figure has two emitters, the extreme ray at $\theta_{max}$ (objective NA), the focal plane, and the separation $\Delta z\tan\theta_{max}$ compared with $\Delta x_{LF}$. The $d_{max}/f_{FL}$ version goes to [B] with the outermost-view caveat.
- [ ] S7 DOF: two-line NA/N argument. State the sampling assumption under which the pixel term is dropped. Full expression and cross-talk limit to [B]; `dof-geometry.tex` panel (a) to [B] or S8.
- [ ] S8 FOV and sampling: concept in [3]; our numbers in the Chapter 4 table; the 0.375 vs 0.56 trade-off stated as a fact with its cost, reason pending (Q3).
- [ ] Rename throughout: $R_{xy}\to\Delta x_{LF}$, $R_{NIP}$ removed, $R_z\to\Delta z_{LF}$, $DOF\to\mathrm{Range}_{z,LF}$ (D13; author note 13).

**Done when:** no displayed formula in the main text contains $f_{FL}$, $f_{MLA}$, $d_{max}$ or $M_{cam}$
except in S3/S8 where they are the design knobs; Appendix B holds every
removed derivation; the build passes.

### Phase 5: integrate the rest of Chapter 3 and the Chapter 4 content

- [ ] S9 and S10 per the existing Chapter 3 plan (B5, B6), now pointing back to S6 (defocus as parallax) and S7 (the 2D assumption holds inside $\mathrm{Range}_{z,LF}$).
- [ ] S11 per the Chapter 4 plan, with the design-values table rewritten in the new notation and rows for $\Delta z_{LF}$, $\mathrm{Range}_{z,LF}$, planes, Nyquist FOV, $M_{cam}$ ideal vs installed.
- [ ] Reconcile with Chapter 5 notation (see Q1).

### Phase 6: separate, then condense to budget

- [ ] Split S0–S10 → Chapter 3, S11 + numbers → Chapter 4, derivations → Appendix B.
- [ ] Measure against the approved budgets (Chapter 3 about 4 pages, Chapter 4 about 1). Any overrun goes to the author as a departure-table proposal, not a silent cut or silent enlargement (CLAUDE.md rule).
- [ ] Figure count: Chapter 3 now has three figures against one approved conceptual figure (already flagged 2026-11-16). Record the decision in the departure table.
- [ ] Prose pass with the `thesis-prose` skill; strict review against both standards.
- [ ] Update the cheat sheet (`supporting-material/talks/`) to the new notation if it will be reused.

## 5a. Phase 1 outcome: conventions and constants (2026-11-17)

**Author answers (2026-11-17, chat):** Q1: use Anat's $N$ and rename downstream
(the retained view grid becomes $K\times K$ in Chapters 3–5 and Appendix A).
Q2: $d_{MLA}$ and $f_{MLA}$ were designed for this instrument's needs (roughly).
Q3: the camera relay was designed so that the back pupil fits inside the
sensor; the camera is off the shelf and had to be accommodated.

**Criterion: Goodman's geometric-plus-diffraction rule, square pupil.** One
criterion for every quantity, taken from Goodman 2017 (OCR of the local PDF,
book pages from the running heads):

- Lateral: two-point resolution of a square pupil of width $w$ is $\lambda F_\#$,
  that is $\lambda/(2\mathrm{NA})$ (§7.5.2, Eq. 7-50 and the square-pupil remark
  after it, pp. 217–218; the circular pupil carries the Rayleigh factor 1.22).
  A lenslet's sub-aperture is square, so the square form is the exact one for a
  view.
- Depth: the one-sided depth of focus is the defocus at which the geometric
  blur equals the diffraction resolution, $\Delta z_i=\lambda F_\#^2$
  (§8.1.1, Eqs. 8-1 to 8-3, pp. 231–232), mapped to object space by $1/M^2$
  (§8.1.2, Eq. 8-5, p. 233). In object-space NA the two-sided range is
  $\lambda/(2\mathrm{NA}^2)$.

| Quantity | Conventional | Light field |
| --- | --- | --- |
| Lateral resolution | $\Delta x_o=\lambda/(2\mathrm{NA})$ | $\Delta x_{LF}=N\Delta x_o$ |
| Depth of field (two-sided) | $\mathrm{Range}_{z,o}=\lambda/(2\mathrm{NA}^2)$ | $\mathrm{Range}_{z,LF}=N^2\mathrm{Range}_{z,o}$ |
| Axial resolution | $\Delta z_o=\mathrm{Range}_{z,o}$ | $\Delta z_{LF}=\Delta x_{LF}/\mathrm{NA}=N\Delta z_o$ |
| Separable planes | 1 | $N$ |

This removes the factor-2 issue of Section 2 item 1: with Goodman's two-sided
range the parallax argument gives exactly $N\Delta z_o$ and $N$ planes. It
changes the design-value depth of field. With λ = 0.53 µm, the new values are
$\mathrm{Range}_{z,LF}=26.5$ µm and $\Delta z_{LF}=3.5$ µm. The 2026-11-16 text
gave 53 µm, or 73 µm with the pixel term, because Guo's diffraction term uses
the axial FWHM, which is twice Goodman's. Appendix B states both conventions.

Small-angle simplification (D11): $\tan\theta_{max}\approx\sin\theta_{max}=\mathrm{NA}$.
At NA 0.75 the true tangent is 1.13. The text says so once, as a "Note that"
sentence.

**Derived sampling relation (new, in NA/N form).** Let the pupil image cover a
fraction $\eta=M_{cam}D_{proj}/D_{cam}$ of the sensor width. The sampling ratio
is then $S_r=\Delta x_{LF}/p=\eta\,N_{px}\Delta x_o/\mathrm{FOV}$. It does not
depend on $N$. For our design, $\eta=0.67$ gives $S_r=1.33$, and $\eta=1$ would
give 1.99.

## 5b. The design story: decisions, limits and trade-offs (2026-11-18)

Author decisions and the analysis built on them in the 2026-11-18 session. The
S3 draft note and Table `tab:design-parameters` follow this section. All
relations are paraxial and all numbers are design values (N = 7.5, NA = 0.75,
λ = 0.53 µm back-solved, $N_{px}=4600$, $D_{cam}\approx12.6$ mm). Relations
marked *derived* were worked out in the session, not taken from a source.

### Step 0: what we could not change

- **Objective:** NA = 0.75, $f_{obj}=5$ mm, pupil $D_{pupil}=7.5$ mm.
- **Tube lens (author):** $f_{TL}=250$ mm is a constraint of the bench. The
  layout needed more space between the objective and the tube lens than the
  objective's nominal 200 mm tube lens allows, so the closest longer
  off-the-shelf lens was used. This sets $M=f_{TL}/f_{obj}=50$.
- **Camera:** off the shelf; pixel pitch $P$, sensor width $D_{cam}$,
  $N_{px}=D_{cam}/P$ (data-sheet values still open).
- **Emission wavelength** (band still open).
- **Practical limits (author):** all optics are 2-inch ($D_{opt}=50.8$ mm),
  and the bench cannot hold a light path longer than about 3 m. Thorlabs
  specifies the clear aperture of its 2-inch achromats and N-BK7 bi-convex
  lenses as ">90% of Diameter", so at least 45.7 mm (a minimum, not the
  typical value; checked on thorlabs.com 2026-11-18, family pages for
  ACT508/AC508 doublets and N-BK7 bi-convex lenses). All installed lenses are
  achromats (author, 2026-11-19). Known part numbers: AC508-150-A before the
  main camera (the 150 mm lens of the camera relay) and ACT508-300-A before
  the ThorCam; the 750 mm Fourier lens is ACT508-750-A-ML (the mounted
  version of ACT508-750-A). The other relay lenses are not recorded. The >90 %
  clear-aperture minimum applies to both AC508 and ACT508 families; whether the
  ML mount's retaining ring narrows it further is not checked.
- **Relays (author):** true 4f systems.

### Step 1: choose N

$N$ sets the resolution and nothing else: $\Delta x_{LF}=N\Delta x_o$,
$\Delta z_{LF}=N\Delta z_o$, $\mathrm{Range}_{z,LF}=N^2\mathrm{Range}_{z,o}$.
Trade-off: lateral resolution against the number of separable depth planes.

### Step 2: choose the field of view (about 550 µm)

**The field is a design choice (author):** we wanted a field of about 550 µm
from the start. The illumination was designed for this field, not the other
way around.

**Pixel budget (derived):** for Nyquist sampling,
$\mathrm{FOV}\le\eta\kappa N_{px}\Delta x_o/2$, independent of $N$. An ideal
build ($\eta=\kappa=1$) samples a 550 µm field at $S_r\approx2.95$.

**Illumination matched to the field.** Only the illuminated region fluoresces,
so lighting exactly the chosen field keeps emission from outside it out of the
views. Ray trace of `testLFdesign_illumination_validation.m` (SHA-256 matches
the record in `research-context/physical-system-composition.md`): a collimated
beam of about 25 mm (author: it fills the 1-inch expanding lens; the code's
±12.5 mm is right and its "1 cm" comment is outdated), an expanding lens
$f_{exp}=250$ mm placed 200 mm before the objective, and the 5 mm objective.
At the nominal focal plane a ray's height depends only on its angle into the
objective, so the illuminated diameter is
$D_{beam}f_{obj}/f_{exp}=25\times5/250=500$ µm, or **552 µm** with the
script's coverslip (0.15 mm, n = 1.52). Caveats: a Gaussian beam has a soft
edge; the 1-inch lens's guaranteed clear aperture (>90 %, at least 22.9 mm)
may trim it slightly; and the beam focuses about 0.45 mm before the sample
plane, so the illuminated size is sensitive to axial spacing.

**The 2-inch stop at the native image plane (author)** passes
$D_{opt}/M=1.02$ mm of object field. It does not bind, and because it is
larger than the lenslet cell it cannot by itself prevent view overlap.

### Step 3: the one free parameter is the lenslet pitch

With $N$ and the field fixed, one degree of freedom is left. The pupil image on
the array is $N d_{MLA}=D_{pupil}f_{FL}/f_{TL}$, so
$f_{FL}=f_{TL}N d_{MLA}/D_{pupil}=250\,d_{MLA}$ (mm). The paraxial performance
($\Delta x$, $\Delta z$, Range, FOV, $S_r$) does not depend on $d_{MLA}$;
aberrations and size do.

| $d_{MLA}$ | $f_{FL}$ | matched $f_{MLA}$ | lenslet F/# | field angle | lenslet astig. (waves) | FL footprint $Nd+M\cdot\mathrm{FOV}$ | path* | 10×10 diagonal |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1.0 mm | 250 mm | 9 mm | F/9 | 3.2° | 0.08 | 35 mm | 2.1 m | 14 mm |
| 2.0 | 500 | 36 | F/18 | 1.6° | 0.02 | 43 mm | 2.6 m | 28 mm |
| 2.5 | 625 | 57 | F/23 | 1.3° | 0.01 | 46 mm | 2.9 m | 35 mm |
| **3.0** | **750** | **82** | F/27 | 1.1° | 0.01 | **50.0 mm** | **3.2 m** | 42 mm |
| 3.5 | 875 | 111 | F/32 | 0.9° | 0.01 | 54 mm ✗ | 3.5 m ✗ | 50 mm |

\*Unfolded 4f spacing, $2(f_{TL}+f_{FL})+f_{MLA}$ plus the 1.1 m camera relay
(400 → 150 mm). FOV = 550 µm throughout.

**Trade-off (derived, thin-lens Seidel scaling at fixed N and FOV; the author
decided on 2026-11-19 that this estimate suffices and no ray trace is planned):** lenslet aberrations in waves fall as $1/d_{MLA}^2$, and
the lenslet F-number equals $1/(2\theta)$, where θ is the field half-angle at
the array. The Fourier lens works at a fixed F-number
$f_{TL}/D_{pupil}\approx33$; its spherical aberration grows as $d_{MLA}$ and
its field terms fall. So aberrations favor a large pitch; bench length and
optic size favor a small one. With a 550 µm field the fast-lenslet concern
does not bind (below 0.08 waves even at 1 mm).

**Limits:**

1. **Fourier-lens aperture (derived; holds because the relay is true 4f):**
   the pupil image and the field pass through the same lens,
   $N d_{MLA}+M\,\mathrm{FOV}\le D_{opt}$. With a 550 µm field,
   $d_{MLA}\le3.1$ mm. At 3 mm the footprint is 50.0 mm of 50.8. This is the
   coupling between the field and the pupil image. The fit is tight: 50.0 mm
   exceeds the guaranteed clear aperture (45.7 mm), which alone would pass
   $(45.7-22.5)/50\approx460$ µm unvignetted. If the real clear aperture is
   near the minimum, the field edge is partly vignetted at the Fourier lens;
   in a Fourier configuration this clips the edge of the pupil for edge field
   points, so the outer views lose the field edge first (to check on the
   extracted views).
2. **Bench length (author):** about 3 m, reached near $d_{MLA}=3$ mm.
3. **Array in a 2-inch mount:** a 10×10 array needs $d_{MLA}\le3.6$ mm.

**Reconstruction of the 3 mm choice (author, 2026-11-18: the 2-inch, bench
and aberration limits are real; the exact reasons wait for the supervisor):**
a 3 mm pitch with a stock 2-inch $f_{FL}=750$ mm fits the 550 µm field. It is
the largest pitch, and so the slowest, least-aberrated lenslets, that both the
Fourier-lens aperture and the bench allow.

### Step 4: the lenslet focal length and the guard band

Views must not overlap: $f_{MLA}\le N d_{MLA}^2/(2\,\mathrm{NA}\,\mathrm{FOV})$
(*derived* by substituting the Fourier-lens relation into the no-overlap
condition), about 82 mm for a 550 µm field. The installed lenslets have
$f_{MLA}=55$ mm, measured in the lab (author); the paraxial estimate from
R = 23.5 mm in fused silica, about 51 mm, is superseded by the measurement.
This makes 818 µm cells, which the field fills only to
$\kappa=\mathrm{FOV}/\mathrm{FOV}_{cell}\approx0.67$. **Why 55 mm and not
82 mm (author, 2026-11-19): a limitation of Amus Optics.** The lenslets offered
at a 3 mm pitch did not include a focal length near 82 mm. The part number
`APO-Q-P3000-R23.5` fits this: a catalogue family by pitch (3000 µm) and
radius, and an 82 mm lenslet would need R ≈ 38 mm. The chapter states it as a
supplier limitation whose price is the guard band and the lower $S_r$. A side
benefit, not a reason: the guard band keeps the soft edge of the Gaussian
illumination out of the neighboring view.

### Step 5: the array and the camera relay

- **Array size (author: keep the constraint):** $N d_{MLA}\le D_{MLA}\le D_{opt}$.
  Ours is 10×10 lenslets, 30 mm, about $\pi N^2/4\approx44$ inside the pupil.
- **Camera relay (author):** assembled from off-the-shelf lenses
  (400 → 150 mm, ×0.375), heavily under-optimized. The ideal relay fills the
  sensor, $M_{cam}=D_{cam}/(N d_{MLA})=\times0.56$. Ours fills
  $\eta\approx0.67$ of the sensor width. This answers Q3 and replaces the
  "whole 30 mm array" hypothesis of Section 2 item 3.

### Consequence: sampling, and the conflict with D8

$S_r=\eta\kappa N_{px}\Delta x_o/\mathrm{FOV}=\eta N_{px}\Delta x_o/\mathrm{FOV}_{cell}$
(*derived*). Ideal build: about 2.95. As built: $2.95\times0.67\times0.67=1.33$.

D8 drops the pixel term from the depth of field "assuming normal sampling". That
assumption holds for the design concept and fails for the instrument as built:
at $S_r=1.33$ the pixel term is about 27 % of the depth of field, and pixel
sampling may limit the lateral resolution (about 4 µm against
$\Delta x_{LF}=2.65$ µm). A boxed "Discuss with Anat" note sits under S7 in the
chapter and in its TODO list. See Q4.

### Open checks from this section

Resolved by the author on 2026-11-18: beam diameter (about 25 mm, fills the
1-inch expanding lens); relays are true 4f; $f_{MLA}=55$ mm is a lab
measurement. Clear aperture: Thorlabs guarantees >90 % of the diameter.

Resolved on 2026-11-19: all lenses are achromats (AC508-150-A before the main
camera, ACT508-300-A before the ThorCam); $f_{MLA}=55$ mm rather than about
82 mm is an Amus Optics limitation; the thin-lens aberration estimate suffices
and no ray trace is planned.

Still open:

- Part numbers of the other relay lenses (the Fourier lens is ACT508-750-A-ML),
  and the clear aperture of the Fourier lens in its mount.
- Whether the field edge is vignetted at the Fourier lens (outer views dimmer
  at the field edge in the extracted data).
- Real total path length, and whether the path is folded.
- Whether the 3 mm pitch was chosen for the reasons reconstructed above
  (waiting for the supervisor).

## 6. Decisions the author needs to make

Q1–Q3 answered on 2026-11-17 (Section 5a). Q4 and Q5 follow the recommendation
in the draft; Q6 stays open until Phase 6.

| # | Question | Recommendation |
| --- | --- | --- |
| Q1 | $N$ now means two things. Anat's $N$ = lenslets across the pupil (7.5 here, not an integer); Chapter 5 uses $N$ for the retained $N\times N$ grid of views (`05_image_reconstruction.tex` lines 9, 15, 21). The 2026-11-16 edit chose ρ to avoid this. | Use $N$ in Chapter 3 as Anat asked (the formulas read far better). Rename the retained grid in Chapter 5 and Appendix A to $K\times K$, or define it as "the $N\times N$ views that lie fully inside the pupil" if the counts agree. Check which grid the reconstruction actually used before choosing. |
| Q2 | How were $d_{MLA}$, $f_{MLA}$, $f_{FL}$ actually chosen (author note TODO 4)? | Ask; record the answer in `research-context/physical-system-composition.md`. Write S3 as "the relations that govern the choice" either way. |
| Q3 | Why $M_{cam}=0.375$ rather than 0.56? | **Answered 2026-11-18 (Section 5b):** built from off-the-shelf lenses, heavily under-optimized. Report the cost: together with the lenslet guard band it brings $S_r$ from about 3 to 1.33. |
| Q4 | Drop the pixel term from the DOF entirely (D8)? With our numbers it is 27 % of the DOF, and about 20 % even at exact Nyquist ($S_r=2$), so "negligible" is generous. | **Open, to discuss with Anat (2026-11-18):** the author treats this as a real conflict: the guard band and the under-filled relay make our sampling below Nyquist, although the design concept samples at about 3 (Section 5b). Until then, the earlier recommendation stands as the default: drop it from the main-text formula, give its size in one clause, keep the full term in Appendix B. |
| Q5 | Keep Guo's remark that axial resolution degrades away from focus? | Keep as one sentence in S6, cited; it matters for S9's 2D assumption. |
| Q6 | Keep subsection headings in the final Chapter 3 (the 2026-11-09 decision said no)? | Decide at Phase 6; the design-first order may justify three or four headings. |

## 7. Evidence still needed

- Constants for $\Delta x_o$, $\Delta z_o$, $\mathrm{Range}_{z,o}$ with page locators (Phase 1).
- Emission band (λ), main camera pixel pitch and sensor size from the data sheet (the cheat-sheet defaults are 2.74 µm and 4600 px, from `research-context`; confirm against the data sheet), retained-view set. All are already in `open-questions.md`.
- Guo 2019 equations checked on rendered pages before any is transcribed (open since 2026-11-12).
- Design history of the lenslets and relay (Q2, Q3).

## 8. Traceability: author's notes → this plan

| Note | Where handled |
| --- | --- |
| Discuss 1 (lateral, axial, DOF, sensor/pixel) | S5–S8 |
| Discuss 2 (sampling ratio vs camera magnification) | Section 2 item 3; S8; Q3 |
| TODO 1 (design parameters and their order; sampling ratio as a consequence) | S3, Section 4 |
| TODO 2 (camera is given) | Section 4 |
| TODO 3 (start with conventional reminders) | S1 |
| TODO 4 (how $f_{MLA}$, $d_{MLA}$ were chosen) | Q2 |
| TODO 5 (design vs performance parameters) | Section 4 (choose / sets columns) |
| TODO 6a–b (λ/2NA × single factor; $d_{MLA}$ central) | S5, D1; $d_{MLA}=D_{proj}/N$ |
| TODO 7a–b (f_MLA sets FOV; FOV vs pixels trade-off) | S3, S8, D5–D6 |
| TODO 8a–c (lenslets ↔ resolution, FOV, pixels; pixels = FOV/Δx; check $N$ against Guo) | Section 4; D2 settles the Guo check: same per-axis ratio |
| TODO 9 (is the circle of confusion negligible?) | Q4 |
| TODO 10 (figure without lenses, parallax of two emitters) | Phase 4, S6. The note says "DOF figure"; the meeting (67:18) discussed the axial-parallax figure. Assumed to mean that one. |
| TODO 11 (axial res = DOF conventionally; $N^2$; $N$ planes in one capture) | S1, S4 |
| TODO 12 (last 5 minutes: design parameters, what decides what, structure) | Sections 3–4 (from 78:57–83:00) |
| TODO 13 (Δx notation with $o$ and $LF$) | D13, Phase 4 rename |

## 9. Relation to existing plans

This workplan, once approved, supersedes the **order and derivation style** of
blocks B2–B4 in the [Chapter 3 plan](03-light-field-model-plan.md) and its
notation row choosing ρ. It keeps B1, B5, B6, the evidence map, and the
[Chapter 4 plan](04-our-setup-plan.md) content, whose design-values table is
rewritten in the new notation. The page allocations in
[revised-thesis-structure.md](revised-thesis-structure.md) are unchanged; this
draft knowingly ignores them until Phase 6.
