# Introduction LFM Buildup Design

## Goal

Restructure the opening of the thesis introduction so that it motivates light-
field microscopy from the biological imaging requirements before introducing
FLFM or the thesis rectification method.

## Narrative design

The introduction will move through this sequence:

1. Biological imaging requires a combination of spatial resolution, volume,
   temporal resolution, and acceptable exposure or invasiveness.
2. Established modalities satisfy these requirements through different
   trade-offs.
3. Optical microscopy is attractive because it avoids ionizing radiation and
   can provide high spatial resolution, but tissue depth and optical-system
   constraints remain important.
4. Fluorescence adds molecular specificity, while confocal, two-photon, and
   light-sheet approaches trade optical sectioning, volume, speed, and
   illumination burden.
5. Dynamic three-dimensional fluorescence creates a need for an acquisition
   strategy that captures more scene information in a single exposure.
6. LFM records spatial and angular information together and enables
   computational viewpoint, refocusing, or volumetric reconstruction.
7. LFM has a real spatial-angular sampling cost, so the optical encoding,
   calibration, and reconstruction model matter.

The section will end with a forward-looking statement about examining the
optical encoding of the light field. It will not yet explain FLFM or the
rectification pipeline.

## Scope and wording constraints

- Preserve the user's existing broad medical-imaging motivation while reducing
  unsupported or overly absolute claims.
- Avoid treating low penetration as a universal property of all optical
  modalities; describe absorption, scattering, and modality-dependent depth
  limits instead.
- Avoid claiming that LFM provides higher resolution for free. State the
  spatial-angular trade-off explicitly.
- Use citations already present in `overleaf/refs/thesis.bib` for the LFM
  principle, biological motivation, and reconstruction limits.
- Do not introduce the thesis-specific rectification method in this edit.

## Verification

- Inspect the edited LaTeX for balanced paragraph structure and removal of the
  placeholder note.
- Search the edited file for `TODO`, `TBD`, and the old placeholder text.
- Compile the thesis if the local LaTeX toolchain is available; otherwise run a
  syntax-oriented inspection and report the limitation.
