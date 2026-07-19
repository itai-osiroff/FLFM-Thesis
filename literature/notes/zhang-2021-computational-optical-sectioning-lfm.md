# Zhang 2021 - Computational Optical Sectioning For LFM

## Citation

Yi Zhang, Zhi Lu, Jiamin Wu, Xing Lin, Dong Jiang, Yeyi Cai, Jiachen Xie,
Yuling Wang, Tianyi Zhu, Xiangyang Ji, and Qionghai Dai, "Computational optical
sectioning with an incoherent multiscale scattering model for light-field
microscopy," *Nature Communications*, 12, article 6391, 2021.
DOI: `10.1038/s41467-021-26730-w`.

Primary source: <https://doi.org/10.1038/s41467-021-26730-w>

## Why This Matters

This paper directly strengthens the scattering-aware LFM context. It states the
problem clearly: LFM is compact and tomographic, but scattering tissue and dense
labeling can severely degrade quantitative volumetric fluorescence imaging.

For this thesis, it is a comparison and caveat source. It should be cited to
show that scattering-aware LFM reconstruction exists, while making clear that
the current thesis does not implement this model.

## Key Claims

- LFM provides a compact computational approach to high-speed volumetric
  fluorescence imaging.
- Scattering tissue and dense labels can cause severe degradation in LFM.
- The paper proposes an incoherent multiscale scattering model for
  computational optical sectioning and validates it on biological dynamics.

## Useful Equations, Figures, Or Methods

- Use when discussing what a scattering-aware LFM reconstruction method looks
  like.
- Use as a comparison point for the thesis' narrower rectification strategy.

## Thesis Placement

| Chapter | Use |
| --- | --- |
| Chapter 2: Background and Literature | Modern scattering-aware LFM context. |
| Chapter 4: Aberration and Scattering | Evidence that tissue/dense labeling degradation is a known LFM issue. |
| Chapter 8: Discussion | Contrast with full scattering-aware reconstruction. |

## Possible Thesis Use

- Citation for severe degradation in scattering tissue or densely labeled
  samples.
- Comparison citation for a more complete computational optical sectioning
  approach than this thesis implements.

## Safe Wording

Zhang et al. address LFM degradation in scattering or densely labeled biological
samples using an incoherent multiscale scattering model. This thesis cites the
work to position its simpler rectification method against scattering-aware LFM
reconstruction, not to claim equivalent physical modeling.

## Caveats

- Do not describe the current method as computational optical sectioning.
- Do not claim that the thesis estimates or inverts the full scattering model.
