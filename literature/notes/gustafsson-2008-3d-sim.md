# Gustafsson 2008 - 3D resolution doubling by structured illumination

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. G. L. Gustafsson, L. Shao, P. M. Carlton, C. J. R. Wang, I. N. Golubovskaya, W. Z. Cande, D. A. Agard, J. W. Sedat. "Three-Dimensional Resolution Doubling in Wide-Field Fluorescence Microscopy by Structured Illumination." Biophysical Journal 94(12), 4957-4970, June 2008. DOI printed on the paper: 10.1529/biophysj.107.120345. No discrepancy with the assignment metadata (the assignment gave volume 94 and pages 4957-4970; the issue number 12 is printed in the page footers).

## What was read

File C4d_16.txt, the whole 14-page paper (printed pp. 4957-4970), including Theory, Methods, Results, Discussion and reference list. The text is complete (title page to references). Not read: the Supplementary Material (Data S1, Movies S1-S3, Fig. S1), which is only on the journal website. Figures were read only through their captions (not interpreted visually). The file has equation glyphs garbled, so equation details were taken from the prose.

## Why This Matters

This is the primary source for 3D structured illumination microscopy (SIM) with a grating. It shows concretely what SIM costs (many sequential exposures, a calibration of the OTF and of the pattern parameters, a linear reconstruction) and which things go wrong (motion, drift, edge effects). It says very little about aberrations, so it supports the "SIM needs multiple captures" half of G29 and only weakly the aberration-sensitivity half.

## Key Claims (paraphrased)

- **Raw images per volume (p. 4969).** The implemented 3D SIM uses 15 raw images per axial section (5 phases times 3 orientations); sections are spaced about 125 nm, which gives roughly 120 exposures per micrometre of volume thickness, so a thick sample needs more than 1000 raw images. [anchor: "three-dimensional SIM uses 15 raw images"]
- **Acquisition recipe (p. 4963).** Five pattern phases spaced 2 pi/5, three pattern orientations 60 degrees apart, focus step 122 or 125 nm; phase varies fastest, then focus, then orientation. [anchor: "Three-dimensional data were acquired with five pattern phases"]
- **Acquisition time (p. 4963).** One prototype acquired 80 sections of 512 x 512 pixels, five phases, three orientations, 100 ms exposures, in 140 s; the time is limited by exposure time and could be shortened with more light. [anchor: "with 100-ms exposure times, in 140 s"]
- **Why several images (p. 4959).** Each phase-shifted image gives one linear equation in the unknown information components; at least as many phases as components are needed to separate them. [anchor: "at least equal to the number of unknowns"]
- **Missing cone and how 3D information is obtained (pp. 4957, 4958, 4960).** The conventional wide-field data lack axial information because of the missing cone of the OTF, so each section holds out-of-focus blur from all other sections. [anchor: "the missing-cone problem (1)"] The paper uses three mutually coherent excitation beams (two side beams near the pupil edge, one central) whose interference gives a 3D intensity pattern with seven Fourier components; the shifted OTF copies fill the missing cone while keeping the factor-of-two lateral gain, and the axial resolution is also doubled. [anchor: "three mutually coherent beams of excitation light"] [anchor: "This region fills in the missing cone"] The 3D data are a focus stack acquired with the pattern held fixed relative to the focal plane (p. 4958).
- **Light source and coherence (p. 4961).** The beams come from a laser scrambled into a multimode fibre to simulate a spatially incoherent source; this suppresses stray fringes from dust and confines the interference to a finite axial range, and it broadens the side-band transfer functions axially. [anchor: "simulated spatially incoherent (and unpolarized) light"]
- **Refractive-index mismatch and spherical aberration (p. 4962).** The only statement on this in the paper: the position of the grating stage (making the plane of maximum pattern modulation coincide with the focal plane) is aligned once per objective and wavelength, but this setting can be affected by spherical aberration when imaging deep into samples with ill-matched refractive index. [anchor: "it can be affected by spherical aberration"] Effect on the OTF or on the pattern shape beyond that sentence: not stated.
- **Aberrations in live samples (p. 4969).** Live imaging is said to be compatible in principle if a water-immersion objective is used to avoid unnecessary aberrations. [anchor: "water-immersion objective lens is used to avoid"] No aberration measurement, correction or adaptive optics appears in the paper.
- **OTF calibration (p. 4963).** The 3D transfer functions are measured from a single fluorescent bead (five phases, one orientation), rotationally averaged around the kz axis and zeroed outside the known support; they need to be determined once per objective and wavelength. [anchor: "each Om was rotationally averaged around the kz axis"] [anchor: "Transfer functions need only be determined once for each combination of"]
- **Parameter fitting and drift (p. 4963).** The pattern wave vector, starting phase and modulation depths are estimated from the data by cross-correlating overlapping information components; thermal drift is measured with the redundant central component and removed. [anchor: "were determined from the data by comparing"] [anchor: "this redundancy was exploited to detect thermal drift"] Drift within one orientation was not compensated.
- **Reconstruction (p. 4964).** A generalised Wiener filter combines the components, with a constant Wiener parameter adjusted empirically and an apodization; reconstruction of a 400 x 400 x 72 voxel volume took 138 s on a dual dual-core workstation. [anchor: "to be a constant and adjusted empirically"] [anchor: "required 138 s on a computer"]
- **Reconstruction artifacts (pp. 4964, 4969).** The order of operations (filter before shifting) was chosen because the other order amplifies frequency-shift "smearing" into artifacts. [anchor: "lead to artifacts in the reconstruction"] Data that contain strong emission from outside the imaged volume can also produce artifacts. [anchor: "the imaged volume, artifacts could be expected to arise"] Sample motion during acquisition can likewise produce artifacts. [anchor: "produce artifacts if substantial motion"]
- **Noise (p. 4966).** SIM removes out-of-focus light computationally and leaves behind the associated shot noise, so confocal microscopy may be preferable on very thick, dense samples. [anchor: "behind the associated shot noise"] No quantitative noise-amplification figure is given; the Wiener parameter is the only regularisation named.
- **Linear, no prior (p. 4966).** The reconstruction is completely linear once the parameters are known and uses no a priori sample constraints; deconvolution-style constraints are deliberately avoided. [anchor: "linear (once the parameters are determined)"]
- **Resolution achieved (p. 4965).** Mean FWHM of 100 beads was 103.9 nm laterally and 279.5 nm axially (about twice the conventional resolution in each dimension). [anchor: "yielded a mean FWHM of 103.9 nm laterally"]
- **Live-sample limits (p. 4969).** Motion and total exposure (photobleaching, phototoxicity) are the limits; thin samples ease both. [anchor: "usual limits to total exposure"]

## Relevance to the thesis

- Supports: G29 (SIM needs several sequential images per volume, a pattern and OTF calibration, and a linear reconstruction that can give artifacts under motion, drift or edge effects; the one aberration statement is that the grating-focus alignment can be affected by spherical aberration in index-mismatched samples, p. 4962). G30 only in the sense that 3D data are a through-focus stack with a separately measured PSF/OTF (pp. 4962-4963).
- Does not support: any claim that SIM is "sensitive to aberrations in the PSF" or that aberrations corrupt the pattern and OTF in general (not stated here; the 2005 paper has a related sentence). Not a source for adaptive optics or blind methods. Not a source for optical sectioning limited to thin samples being "worse" than confocal in general (the paper says it depends on the specimen).

## Differences to state if cited

- It is an incoherent fluorescence method with coherent, structured excitation, needing about 15 images per section and many sections; the thesis method is single-shot and has no illumination structuring.
- The reconstruction in this paper is a linear Wiener-type combination that relies on a measured OTF (a PSF model); the thesis method is neither a PSF-based reconstruction nor deconvolution.
- The paper's own aberration remark is limited to grating alignment and spherical aberration; it does not model aberrations as view shifts.

## Still unread

- Supplementary Data S1, Movies S1-S3, Fig. S1.
- Figures 1-7 were not inspected visually, only their captions.

## Safe Wording

Three-dimensional structured illumination microscopy as implemented by Gustafsson et al. records 15 raw images per axial section (five pattern phases at each of three orientations), so a thick specimen needs more than a thousand exposures (p. 4969), and the authors note that the pattern-focus alignment can be affected by spherical aberration in samples with mismatched refractive index (p. 4962).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Add if Chapter 2 claims volumetric resolution doubling. Gustafsson 2000 supports the lateral claim and Neil 1997 supports grid-based sectioning.
