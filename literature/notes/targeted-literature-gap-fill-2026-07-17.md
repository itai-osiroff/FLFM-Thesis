# Targeted Literature Gap Fill - 2026-07-17

> **Status:** reference
>
> **Reviewed:** 2026-09-24

## Purpose

This note records the targeted literature expansion used to strengthen the
thesis' similar-work and supporting-literature base. It complements the
individual reading notes and identifies how the new sources should be used
without overclaiming.

## Selected Clusters

| Cluster | Sources | Thesis role |
| --- | --- | --- |
| FLFM foundation | Guo 2019; Hua 2021; Galdon 2022; Yun 2023 | Primary FLFM lineage, Fourier/pupil-plane framing, and setup constraints. |
| LFM reconstruction | Levoy 2006/2009; Broxton 2013; Stefanoiu 2019 | Snapshot light-field capture, spatial-angular tradeoff, wave-optics inverse modeling, and deconvolution limits. |
| Biological and scattering-aware LFM | Prevedel 2014; Zhang 2021 computational optical sectioning | Biological motivation and comparison to scattering-aware LFM reconstruction. |
| Tissue and aberration support | Goodman 2015; Jacques 2013; Ji 2017; Booth 2014; Zhang 2023 AO review; Helmchen and Denk 2005 | Tissue optical properties, statistical optics, sample-induced aberration correction, and deep-tissue fluorescence context. |
| Multiview analogy | Swoger 2007; Preibisch 2010; Preibisch 2014 | Adjacent precedent for view registration, fusion, and deconvolution. |

## Citation Decisions

- Cite Guo 2019 as the primary source for FLFM. Keep the local
  `fourier-light-field-microscopy-local-note.md` as an internal checklist only.
- Cite Broxton 2013 for wave-optics LFM and deconvolution context, but also use
  its no-scattering assumption as a boundary.
- Cite Zhang 2021 computational optical sectioning to show that
  scattering-aware LFM methods exist and are more physically ambitious than the
  thesis method.
- Cite Jacques 2013 with Goodman 2015 for Chapter 4 tissue/media degradation
  language; cite Ji/Booth/Zhang AO reviews and Helmchen/Denk only when Chapter
  2 or 4 needs correction-modality context.
- Cite multiview microscopy papers only as adjacent alignment/fusion precedent,
  not as FLFM model sources.

## Chapter-Level Use

| Chapter | New support |
| --- | --- |
| Chapter 2 | LFM/FLFM lineage, scanless capture motivation, reconstruction families, and similar works. |
| Chapter 3 | FLFM Fourier-plane model and practical setup constraints. |
| Chapter 4 | Tissue optical-property vocabulary, sample-induced aberrations, scattering-aware LFM comparison. |
| Chapter 5 | Adjacent view-registration/fusion precedent, with clear algorithmic boundaries. |
| Chapter 8 | Conservative framing: the thesis is rectification, not learned reconstruction, AO, deconvolution, or full scattering inversion. |

## Safe Thesis Boundary

The expanded literature supports the central framing that FLFM and LFM offer
single-shot spatial-angular capture and that tissue-like media can degrade
microscopy through scattering, blur, contrast loss, and aberration. It does not
turn the thesis results into a general proof of tissue imaging, volumetric
reconstruction, adaptive optics, learned reconstruction, or full scattering
inversion.

## Immediate Writing Guidance

- Replace legacy local-FLFM-note references in planning documents with Guo 2019
  and the Applied Optics design/setup guides where a citable source is needed.
- Use Zhang 2021 computational optical sectioning and the AO/deep-tissue
  microscopy sources in the same paragraph only if the prose makes clear that
  they are comparison methods, not implemented components.
- Keep result claims tied to selected eyedrop/chicken runs and provenance
  records; literature cannot supply result evidence for the thesis' own method.
