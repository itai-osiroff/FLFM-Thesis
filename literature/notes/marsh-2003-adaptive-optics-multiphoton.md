# Marsh 2003 - Practical implementation of adaptive optics in multiphoton microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

P. N. Marsh, D. Burns, and J. M. Girkin, "Practical implementation of adaptive optics in multiphoton microscopy", Optics Express 11(10), 1123-1130 (19 May 2003; received 28 March 2003, revised 25 April 2003). No DOI is printed on the paper (only the manuscript number #2278). No discrepancy with the assignment metadata.

## What was read

C4a_10.txt (8 pages, printed pages 1123-1130), read completely: abstract, reference list, Introduction, Experiment, Experimental results, Conclusions. Figures 1-6 were read through their captions and the surrounding text only; image content was not inspected. The text file contains some garbled characters (micro sign), which the anchors avoid. A keyword search found no mention of Shack-Hartmann, wavefront sensor, wavefront sensing, cost or price anywhere in the paper.

## Why This Matters

An early, practical two-photon scanning microscope with a 37-actuator micromachined deformable mirror, optimized by image-intensity feedback instead of a wavefront sensor. It is a usable primary example of specimen-induced aberration sources (G24) and of a deformable-mirror correction with stated practical limits (G27: dynamic range, concave-only surface, slow optimization). It does not discuss why wavefront sensing is avoided, so it cannot carry G26's sensing caveat on its own.

## Key Claims (paraphrased)

- **Aberration from index mismatch and non-uniform samples (p. 1123).** Refractive-index mismatch between the immersion medium of a high-NA objective and the sample, plus non-uniform samples, impart aberrations that deteriorate the PSF. [anchor: "refractive-index mismatches between"]
- **Optical-system sources (p. 1124).** Other aberration sources are off-axis transmission through optical components (objective, scan lenses during scanning) and imperfections in the optical elements along the optical train. [anchor: "Other sources of aberrations include off-axis transmission through"]
- **Consequences (p. 1124).** Specimen-induced aberrations reduce resolution, and the laser power needed increases with depth, which can cause irreversible effects in biological samples. [anchor: "the necessary laser power to"]
- **Uniform mismatch gives spherical aberration (p. 1124).** For a uniform sample with an index mismatch the primary aberration is spherical and grows with depth. [anchor: "the primary aberration is spherical which naturally increases"]
- **Static alternatives (p. 1124).** Tube-length change, immersion index change, pupil-area change and objective correction collars compensate spherical aberration but are essentially static and not easily changed during imaging. [anchor: "static corrections and not easily changed during imaging"]
- **Corrector type and prior hardware limits (pp. 1124-1125).** An earlier liquid-crystal SLM system is reported to have only 1-2% optical throughput at 780 nm; an earlier DM system needed beam up- and down-collimation and lost 50% of the beam when a defocus bias was used. The authors place a 15 mm OKO DM (37 electrostatic actuators, silicon nitride membrane) after the scan head for a compact module with short DM-to-objective path. [anchor: "generator had an optical throughput of only"]
- **DM limitations (pp. 1125, 1127).** The DM produces only concave surfaces, so a defocus bias is applied via the scan lens. Residual axial PSF broadening at depth is attributed to the mirror running out of dynamic range, said to be fixable by better amplifiers. [anchor: "the mirror running out of dynamic range"]
- **Image-based optimization, no wavefront sensor (pp. 1125-1126).** The DM shape is optimized from the two-photon fluorescence signal in a region of interest (hill climbing, 30 s to 15 min). Each trial shape needs a scan, which limits speed; for biological samples the number of scans is kept small, trading resolution against scan count. [anchor: "However, this does limit the optimization"]
- **Pre-computed correction sets (p. 1126).** Because spherical aberration dominates in many biological samples, sets of actuator voltages calibrated on artificial samples for various depths can be stepped through quickly. [anchor: "Sets of actuator voltages which provided aberration correction for various"]
- **Spatial variation (p. 1126).** The authors note that lateral scan aberrations grow with scan angle and that point-by-point correction is possible with AO, probably at slower scan rates; this was not implemented. The reported correction is one mirror shape optimized for a region (a 32 um by 32 um image). [anchor: "it is possible to perform correction on a point"]
- **Result (abstract, p. 1123).** With a 1.3 NA 40x oil objective, imaging depth in water was extended from about 3.4 to 46.2 um at an axial PSF FWHM of 1.25 um; in guinea-pig bladder muscle a 40% gain in peak signal at 30.8 um depth (p. 1128). [anchor: "extended from approximately 3.4 to 46.2"]

## Relevance to the thesis

- Supports: G24 (index mismatch, non-uniform samples, and optical-train sources, pp. 1123-1124; this is a good source for the "optics" branch of the sample/environment/optics triad). G27 only in a limited way: a concrete DM implementation with stated limits (dynamic range, concave-only shape, 37 actuators, slow image-based optimization) and a statement that earlier SLM and DM layouts had throughput or alignment penalties.
- Does not support: G26 as stated (no wavefront sensor, no Shack-Hartmann, no explanation of why sensing is avoided or hard; the only sensing reference is a passing mention of "measured specimen induced aberrations" in an earlier SLM work, p. 1124). G27's cost claim (no cost or price statement anywhere) and the claim that corrections are usually spatially invariant (not stated as a general claim; the paper only notes point-by-point correction as a possible future scheme). G25 and G30.

## Differences to state if cited

- Point-scanning two-photon microscope with a non-descanned detector; correction applies to the excitation wavefront, unlike widefield or light-field detection.
- 2003 hardware (37-actuator DM); no statement of current DM cost or complexity.
- Optimization is sensorless, but the paper never calls it "sensorless" or contrasts it with wavefront sensing.

## Still unread

- Figure image content (Figs. 1-6) was read by caption only.
- Cited references (Booth, Neil, Sherman et al.) are not read here.

## Safe Wording

Refractive-index mismatch between the immersion medium and the sample, non-uniform specimens, and imperfections or off-axis transmission in the optical train all aberrate the focus of a high-NA objective (Marsh et al. 2003, pp. 1123-1124); in their two-photon microscope a 37-actuator deformable mirror was optimized from the fluorescence signal, with the available mirror stroke limiting the correction at depth (pp. 1125-1127).
