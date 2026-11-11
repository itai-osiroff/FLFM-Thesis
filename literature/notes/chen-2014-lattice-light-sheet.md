# Chen 2014 - Lattice light-sheet microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

B.-C. Chen, W. R. Legant, K. Wang, L. Shao, D. E. Milkie, M. W. Davidson, C. Janetopoulos, X. S. Wu, J. A. Hammer III, Z. Liu, B. P. English, Y. Mimori-Kiyosue, D. P. Romero, A. T. Ritter, J. Lippincott-Schwartz, L. Fritz-Laylin, R. D. Mullins, D. M. Mitchell, J. N. Bembenek, A.-C. Reymann, R. Bohme, S. W. Grill, J. T. Wang, G. Seydoux, U. S. Tulu, D. P. Kiehart, E. Betzig. "Lattice light-sheet microscopy: Imaging molecules to embryos at high spatiotemporal resolution." Science 346(6208), 1257998, 24 October 2014 (Corrected 30 January 2015). DOI 10.1126/science.1257998. No discrepancy with the assignment metadata.

## What was read

File C4d_13.txt (14 PDF pages): the Research Article Summary page (printed p. 439), the full main text (printed pp. 1257998-1 to 1257998-12, including Methods, references and acknowledgments), and the Science "Editor's summary" last page. The supplement is NOT in the file: supplementary notes 1-5, figs. S1-S26, table S1 and movies are only cited (list on p. 1257998-12). Figure panels were not inspected; only captions and text were read.

## Why This Matters

This is the original lattice light-sheet (LLS) paper from Betzig's group. It is a light-sheet (orthogonal illumination) technique, so it is a different imaging architecture from Fourier light-field microscopy. Its only link to the thesis topic is a short statement that depth-dependent sample-induced aberrations require adaptive optics, and a mention of SIM as a multi-image mode.

## Key Claims (paraphrased)

- **What the instrument is (p. 1257998-1, Summary).** Ultrathin light sheets built from 2D optical lattices are scanned plane by plane through a specimen to form 3D images; the lattice is used either for structured-illumination super-resolution or dithered into a uniform sheet. [anchor: "ultrathin light sheets derived from two-"]
- **SIM mode, number of images (p. 1257998-2).** In SIM mode, F images are recorded at each z plane while the lattice is stepped in x by equal fractions of its period; a 3D image is then reconstructed with resolution beyond the diffraction limit in x and z. The figure caption gives a five-phase hexagonal lattice (7.5 s per volume) and finer three-phase patterns allowing about 4 s per volume. Total images per volume is not stated (F per plane times number of planes). [anchor: "we recorded F images at every z plane as we"]; [anchor: "five-phase hexagonal lattice"]; [anchor: "three-phase patterns to be used for SIM"]
- **SIM resolution (p. 1257998-3).** SIM mode gives about 150 nm by 280 nm in xz; the dithered (non-SIM) mode gives 230 nm in x and 370 nm in z (OTF-defined, GFP). Detection NA is 1.1, excitation NA 0.65. [anchor: "xz resolution we obtain"]; [anchor: "CFI Apo LWD 25XW, 1.1 NA"]
- **Dithered mode is single image per plane (p. 1257998-2).** Dithering the lattice gives time-averaged uniform illumination, so only one 2D image per z plane is needed, at diffraction-limited resolution. [anchor: "only one 2D image at each z plane"]
- **SIM is motion sensitive (p. 1257998-10, Discussion).** To reconstruct artifact-free images, SIM needs the specimen to move less than the voxel size during the raw-image acquisition. [anchor: "artifact-free images, requires that the specimen"]
- **Sample aberrations and adaptive optics (p. 1257998-8, Discussion).** Like all optical microscopy, performance degrades with depth owing to sample-induced aberrations; imaging beyond roughly 20 to 100 um will likely need adaptive optics in both excitation and detection paths (cites Wang et al. 2014, ref. 48, a sensorless-AO paper; the paper does not describe the AO method itself). [anchor: "performance degrades increasingly with depth"]; [anchor: "combining the technique with adap-"]
- **Aberrations minimal in superficial layers (p. 1257998-7).** Embryo imaging is claimed to work in superficial layers where sample-induced aberrations are minimal. [anchor: "aberrations are minimal"]
- **Instrument-induced thermal aberrations (p. 1257998-11, Methods).** Asymmetric heating or cooling of the objective ends and convection in the bath create substantial optical aberrations; the authors add heating/cooling blocks to keep the temperature symmetric. [anchor: "Asymmetric heating or cooling of"]
- **Software processing (p. 1257998-11, Methods).** Dithered-mode data are deconvolved with a GPU Richardson-Lucy algorithm using an experimentally measured PSF per emission wavelength; SIM data use a 3D-SIM reconstruction with an OTF from a measured PSF. [anchor: "Richardson-Lucy algorithm adapted to run on"]

## Relevance to the thesis

- Supports: only a weak, incidental use for G24 (sample-induced aberrations degrade imaging with depth; p. 1257998-8) and a pointer that adaptive optics is the proposed remedy (G26 flavour, but the AO method is only cited, not described). For G29, it is a source that SIM needs several raw images per plane and a reconstruction, and is motion sensitive. Nothing on G25 (no cost, slowness or noise-amplification statement; deconvolution is used routinely, not criticised), G27, G28, or G30 beyond a passing mention of astigmatism-based 3D localization in PALM.
- Does not support: any claim about SIM sensitivity to aberrations (not stated), spatially varying versus invariant correction (not stated), Shack-Hartmann or wavefront sensing (not stated), light-field or multi-view imaging (not stated), fluorescence-coherence arguments about ptychography (not stated). Must not be cited for general SIM theory; use Gustafsson 2008 (its ref. 9) for that, if read.

## Differences to state if cited

- It is orthogonal-objective light-sheet microscopy with scanned volumes and 4D time series, not a single-shot 2D snapshot method. SIM here is lattice SIM with a coherent lattice and F phase steps, not widefield sinusoidal SIM with rotations (rotations are not mentioned).
- The aberration remark concerns depth in thick specimens, not the thesis's 2D aberrated scene.

## Still unread

- Supplement (supplementary notes 1-5, figs. S1-S26, table S1, movies S1-S18): not in the file, so exact SIM pattern periods, phase counts per lattice and any AO detail are unread.
- Figure panels (only captions read).

## Safe Wording

Lattice light-sheet microscopy, like other optical microscopy, loses performance with depth because of sample-induced aberrations, and the authors expect imaging beyond roughly 20 to 100 um to need adaptive optics (Chen et al. 2014, p. 1257998-8).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Keep for a distinct illumination-geometry comparison. Use wide-field SIM papers to support wide-field resolution and sectioning claims.
