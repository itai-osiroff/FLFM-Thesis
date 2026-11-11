# Neil 2000 - Adaptive aberration correction in a two-photon microscope

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. A. A. Neil, R. Juskaitis, M. J. Booth, T. Wilson, T. Tanaka and S. Kawata, "Adaptive aberration correction in a two-photon microscope," Journal of Microscopy 200(2), 105-108, November 2000 (short communication; received 6 July 2000, accepted 23 August 2000). No DOI is printed in the paper body; the Wiley download stamp in the page header shows 10.1046/j.1365-2818.2000.00770.x (taken from that stamp, not from the paper). Authors, journal, volume, issue, pages and year match the assignment metadata.

## What was read

C4a_07.txt, the whole communication (printed pp. 105-108, 4 PDF pages), including the reference list. Fig. 3 (the x-z bead scans) and Table 1 were not viewed as images; Table 1 amplitudes are garbled in the text and are not reported here. The companion papers on the modal wavefront sensor (Neil et al. 2000b, 2000c) are unread.

## Why This Matters

This is an early demonstration of adaptive aberration correction in a two-photon fluorescence scanning microscope with a spatial light modulator as the corrector. It gives a clear statement of the sources and effects of aberrations in high-NA fluorescence microscopy (refractive index mismatch), and shows an indirect measurement scheme that the authors themselves call a "wavefront sensor" although it uses fluorescent bead image brightness. It is two-photon scanning microscopy, not widefield or light-field imaging.

## Key Claims (paraphrased)

- **Setting (pp. 105-106).** Two-photon (2-p) scanning microscope with a Ti:sapphire beam at 780 nm, a commercial microscope, 63x 1.25 NA oil-immersion objective with coverglass correction, detector pinholes fully open. The sample is 100 nm fluorescent polystyrene beads on a slide, with a 28 micrometre water layer under a coverglass. It is a bead phantom, not biological tissue. [anchor: "titanium sapphire laser beam (Coherent Mira) was"]
- **Aberration sources and effects (p. 105).** Aberrations reduce image quality and signal. They can come from misaligned optics or non-optimal operating conditions. In particular, using a high-NA objective to image through a refractive index mismatch (immersion medium, coverglass, specimen) introduces spherical aberration that lowers the focal spot intensity and enlarges it. In a confocal microscope this gives dimmer images with worse lateral and especially axial resolution. The paper also cites studies showing that such aberrations reduce 2-p fluorescence intensity even a few micrometres deep. [anchor: "It is well known that the presence of aberrations in a"] [anchor: "misalignment of optics or"] [anchor: "lower the intensity of the focal spot and increase its size"]
- **Classification of wavefront sensing (pp. 105-106, 107).** The introduction states that adaptive optics generally measures induced wavefront aberrations with a wavefront sensor and then pre-shapes the beam with an adaptive element. The authors then present "a new method of wavefront sensing" implemented with the same SLM, and say this is the first use of this form of wavefront sensing in microscopy. So the paper files its sensorless-like scheme under wavefront sensing (a "modal wavefront sensor"), not under a separate indirect category. It does not discuss why a Shack-Hartmann or other direct sensor is unsuitable in microscopy; this is not stated. [anchor: "Adaptive optics generally involves measurement of the"] [anchor: "This is the first time that this form of"]
- **What is measured and how (p. 106-107).** The SLM produces a pair of adjacent focal spots, each carrying an equal and opposite bias aberration of one Zernike mode on top of the current correction. Scanning the pair across a single fluorescent bead gives two bead images; a brightness difference means that mode is present in the induced aberration. The correction for that mode is adjusted until the two images are equally bright. Modes are done sequentially, then the SLM is reconfigured to one spot carrying the total correction. The quality measure is therefore the relative fluorescence brightness of two bead images. The number of scans or iterations per mode is not stated. [anchor: "difference in brightness between the two bead images"]
- **Modes and corrector (pp. 106-107).** Low-order Zernike modes; seven were used in the corrected result (first-order astigmatism, first-order coma (two), first-order spherical, second-order coma, second-order spherical, third-order spherical, by Table 1 descriptions). The paper notes typically only a small number of modes is needed. The corrector is a ferroelectric liquid-crystal SLM (Displaytech) used for both measurement and correction. [anchor: "only a small number of these modes are required to describe"] [anchor: "arbitrary and accurate phase and amplitude wavefronts at"]
- **Excitation-path-only correction (p. 106).** In a two-photon microscope the authors say aberrations in the emission path need not be corrected, because large-area detectors act as collectors for the fluorescence light. This is specific to non-descanned 2-p detection and should not be transferred to a widefield or imaging-detector system. [anchor: "large area detectors can be employed which act"]
- **Corrector cost and complexity (pp. 106-108).** The SLM wavefront generator gives arbitrary phase and amplitude at the expense of reduced optical throughput; throughput was about 1 to 2 percent at 780 nm, and the authors believe up to 10 percent is feasible. They call this adequate for single-point scanning 2-p microscopy where surplus laser power exists, and say a more efficient implementation might use deformable mirrors or nematic liquid crystals. Financial cost is not stated, and spatial variation of the correction across the field is not discussed (the correction is for a single spot position on a single bead). [anchor: "had an optical throughput of around"] [anchor: "components such as deform-"]
- **Demonstrated benefit (p. 107, Fig. 3).** Axial (x-z) scans of single 100 nm beads: uncorrected beads under 28 micrometres of water show an elongated axial point spread function and blurring; with the seven-mode correction the focus is described as near diffraction limited and sectioning ability is restored at 28 micrometres depth. The evidence is qualitative images of one bead; no numbers for signal or resolution gain are given, though the uncorrected image was dimmer. [anchor: "diffraction limited focusing is restored"]

## Relevance to the thesis

- Supports: G24 (aberrations from misaligned optics, non-optimal conditions and refractive-index mismatch with high-NA objectives; spherical aberration lowers intensity and degrades axial resolution; p. 105). G26 (partially): shows adaptive optics normally being described as wavefront measurement plus an adaptive corrector; this paper's own sensor is an image-brightness based modal scheme implemented on the corrector, so it is an example of sensing without a dedicated sensor, but the paper calls it a wavefront sensor. G27 (partially): the SLM corrector has very low light throughput (1 to 2 percent) and the paper suggests DMs or nematic LCs as more efficient options.
- Does not support: any claim that wavefront sensing (Shack-Hartmann) is difficult in microscopy (not stated); any claim about cost in money; any claim that corrections are spatially invariant or vary across the field (not discussed); any claim about computational methods (G25) or defocus images (G30). It is not a widefield or light-field result.

## Differences to state if cited

- Two-photon scanning microscope with a bead phantom, not a widefield or light-field fluorescence system or biological tissue.
- The authors call their image-brightness scheme a modal wavefront sensor, which differs from the usual direct/indirect split used in later papers (Booth 2006, Debarre 2009 call such schemes sensorless).
- Excitation-path correction only; the thesis works on the emission path of a Fourier light-field microscope.

## Still unread

- Neil et al. 2000b (J. Opt. Soc. Am. A 17, 1098) and Neil et al. 2000c (Opt. Lett. 25, 1083) on the modal wavefront sensor; Neil et al. 1998 and 2000a on the wavefront generator; Albert et al. 2000 (deformable-mirror smart microscope); the figure images and Table 1 amplitudes.

## Safe Wording

In a two-photon scanning microscope, specimen-induced aberrations from refractive index mismatch were measured with a modal scheme implemented on a ferroelectric liquid-crystal spatial light modulator and corrected with the same device, restoring near diffraction-limited axial images of beads at 28 micrometres depth, at a light throughput of only 1 to 2 percent (Neil et al. 2000, pp. 105-108).
