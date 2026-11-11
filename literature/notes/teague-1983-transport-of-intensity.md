# Teague 1983 - Deterministic phase retrieval by a Green's function solution

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. R. Teague, "Deterministic phase retrieval: a Green's function solution," Journal of the Optical Society of America 73(11), 1434-1441, November 1983. Received 29 November 1982, revised manuscript received 31 May 1983. No DOI printed on the paper. Metadata in the assignment (JOSA 73(11), 1434-1441, 1983) matches. Note that Waller 2010 cites this paper as "J. Opt. Soc. Am. A", but the printed header here is "J. Opt. Soc. Am." (JOSA A did not yet exist).

## What was read

File C4e_37.txt, all 8 printed pages (1434-1441): abstract, Sections 1-7 and Appendix A (diffraction theory) and the reference list. Equations garbled by pdftotext were not re-read from the PDF; figures 2 and 3 (simulation error plots) were not interpreted beyond their captions. The file is not valid UTF-8 (legacy encoding), but the text is complete.

## Why This Matters

This is the original source of the transport-of-intensity (TIE) phase-retrieval idea: phase follows from the longitudinal intensity derivative through a linear Poisson-type equation. It is a classical example of using defocused (through-focus) intensity images to recover phase, the family of methods behind gap G30. It is a coherent-wave, scalar, paraxial method, quite different from the thesis single-shot incoherent shift-alignment method.

## Key Claims (paraphrased)

- **Problem and scheme (p. 1434, abstract and Sec. 1).** The paper derives propagation equations for phase and irradiance and a Green's function solution for the phase from irradiance and perimeter phase values; a measurement scheme and a numerical simulation are given, for circular and slit pupils. [anchor: "Both circular and slit pupils are considered."]
- **Deterministic, non-iterative (p. 1434, Sec. 1).** Phase is given directly from measured irradiance data, so no phase uniqueness question arises as in iterative algorithms. Earlier two-defocus work and analyticity arguments had said extra irradiance measurements are needed for uniqueness. [anchor: "Both methods are deterministic phase-"]
- **Wave model (p. 1434, Sec. 2).** Light propagates nominally along +z, the scalar amplitude (single wavelength, time factor exp(-i2*pi*c*t/lambda)) obeys the parabolic equation. Coherence is not discussed in words; a monochromatic scalar field is assumed. [anchor: "Suppose that light propagates nominally in the +z direction,"]
- **Core relation (p. 1435, Eqs. 4-7).** If irradiance is known (e.g. measured), the continuity-type Eq. (4) is linear in phase; with an auxiliary function it becomes a 2D Poisson equation whose right-hand side is the longitudinal irradiance derivative, and phase follows (up to a constant) by integration. [anchor: "measurement), then Eq. (4) becomes a linear equation, which"]
- **Boundary information needed (pp. 1434-1435, Secs. 1 and 3).** For a finite pupil, two-plane irradiance alone is insufficient: phase on the perimeter is also needed. For a uniformly illuminated pupil, perimeter phase plus irradiance in one plane a small distance dz from the pupil suffice (Eq. 14). For an untruncated Gaussian beam the perimeter can go to infinity and irradiance alone suffices. [anchor: "two-plane irradiance measurements alone are insufficient to"]
- **Perimeter phase by Hartmann sensors (p. 1436, Sec. 4).** The paper simply assumes no basic problem in measuring perimeter phase, for example with a set of Hartmann sensors, and assumes nominally collimated light at the pupil. [anchor: "by using a set of Hartmann13 sensors)."]
- **Local validity (p. 1434, Sec. 1).** The Green's function method applies locally anywhere, not only at the pupil; in the image plane the perimeter may be taken to infinity so image-plane phase follows from the longitudinal irradiance gradient alone. [anchor: "The Green's function method of phase retrieval applies"]
- **Measurement difficulty and beam compressor (pp. 1436-1437, Secs. 4-5).** Irradiance change near the pupil plane is tiny (about 1e-6 per metre for visible light and 1 m pupils), so a beam compressor magnifies the longitudinal variation; photon-noise-limited detection gives an optimal defocus step, which must be small enough for the linear term to dominate and large enough that noise is small. [anchor: "longitudinal irradiance variation can be greatly increased by"]
- **Simulation (p. 1437, Sec. 6).** One wave of coma and one wave of spherical aberration were recovered with 31x31 detector elements, with 1/20-wave noise added; the author says this verifies Eqs. 11, 12, 14 and their noise immunity, not a system design. [anchor: "Gaussian random noise of zero mean and 1/20-wave standard"]
- **Noise remark (p. 1437, Sec. 7).** The author states the algorithm is not particularly sensitive to noise (simulation-based only). [anchor: "Moreover, the algorithm is not particularly sensitive to noise."]
- **Appendix A (pp. 1438-1441).** The parabolic-wave equation stays locally valid away from sharp pupil edges even where Fresnel diffraction gives absurd near-field results; this needs aperture >> wavelength and, for focused systems, f-number >> 1. The appendix works with collimated monochromatic illumination of a round pupil. [anchor: "collimated, monochromatic light"]

## Relevance to the thesis

- Supports: G30 only in a narrow sense: defocused/through-focus intensity measurements can give phase (hence aberration) in a coherent, paraxial, scalar model; here aberrations are measured in the pupil plane of a (nominally collimated) beam.
- Does not support: any statement about fluorescence, incoherent emission, microscopy, light-field or multi-view imaging (none appear in the paper). Does not support the Shack-Hartmann/AO claims (G26) beyond the passing assumption that Hartmann sensors measure perimeter phase (ref. 13 is Hardy, active optics). Not evidence about cost or speed of any method. Must not be cited for "TIE works with incoherent fluorescence"; extension to partial coherence is in later work (Waller 2010 cites Paganin and Nugent 1998 for that), not here.

## Differences to state if cited

- Teague needs a (near-)coherent, scalar, paraxial field and uses at least two closely spaced planes (one plane plus a known pupil-plane irradiance), plus perimeter phase for finite pupils; the thesis method uses one exposure of incoherent fluorescence.
- Teague recovers a phase map by solving a Poisson equation (a model-based inversion); the thesis method does not recover phase and does not use a wave-propagation model.
- Results are a numerical simulation only (31x31 detectors, one wave of coma or spherical aberration); no experiment.

## Still unread

- Figures 2 and 3 were seen only as captions; garbled equation lines (e.g. Eqs. 11, 12, 20-23, A-series details) were not verified against the PDF.
- Cited works (refs. 1-27) not read.

## Safe Wording

Teague showed that, for a scalar paraxial field, phase can be obtained from the longitudinal derivative of intensity measured in closely spaced planes, by solving a Poisson equation with boundary information (Teague 1983, pp. 1434-1435, Eqs. 4-7 and 14).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use only for transport-of-intensity history. Its observable is optical-field phase under a propagation model.
