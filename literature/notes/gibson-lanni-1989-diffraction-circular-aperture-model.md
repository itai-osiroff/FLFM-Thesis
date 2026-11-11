# Gibson 1989 - Diffraction by a circular aperture as a model for 3-D optical microscopy

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Sarah Frisken Gibson and Frederick Lanni, "Diffraction by a circular aperture as a model for three-dimensional optical microscopy", Journal of the Optical Society of America A 6(9), 1357-1367, September 1989 (received 15 December 1988, accepted 24 April 1989). Center for Fluorescence Research in Biomedical Sciences, Carnegie-Mellon University. No DOI is printed on the paper. The assignment metadata (JOSA A 6(9), 1357-1367, 1989; 11 pages) matches the paper; no discrepancy.

## What was read

File C4b_18.txt, the whole article (printed pp. 1357-1367): abstract, Sections 1-8, acknowledgments, references and notes. The equations are garbled by text extraction and were not re-derived or checked against the PDF page images. Figure 7 (computed log-intensity cross sections) was taken from its caption and the text only, not interpreted from the image. Nothing else was read.

## Why This Matters

This is the scalar-diffraction PSF model that 3-D serial-sectioning (through-focus) microscopy and its deconvolution were built on. It shows what the standard analytic 3-D PSF assumes (an aberration-free circular aperture, scalar theory, small field angles) and where those models were already thought to be inaccurate. For the thesis it is background for the claim that deconvolution needs a PSF model, not evidence about aberrations.

## Key Claims (paraphrased)

- **Scope (p. 1357, abstract).** The paper reviews existing formulations of the 3-D diffraction pattern of spherical waves from a circular aperture, in the context of 3-D serial-sectioning microscopy, and adds a new formulation for off-axis focal points. [anchor: "serial-sectioning microscopy. A new formulation for off-axis"]
- **Why a PSF model is needed (p. 1357, Sections 1-2).** To estimate the true object from a stack of 2-D images one needs a good model of the imaging process; if the process is linear, the model is the 3-D image field of a point source, which determines the 3-D PSF. [anchor: "must have a good model of the imaging process"]
- **Through-focus stack as data (p. 1357, Section 1).** In 3-D serial-sectioning microscopy the object is stepped through focus and the recorded 2-D images contain in-focus and out-of-focus information; the stack is then processed by one of several algorithms to estimate the 3-D object. [anchor: "stepped through focus, and a series of 2-D images"]
- **Reconstruction algorithms rely on PSF properties (p. 1357, Section 2).** Many reconstruction algorithms assume a shift-invariant PSF, so the authors want the on-axis and off-axis diffraction pattern in a form that shows its symmetry and degree of shift variance. [anchor: "point-spread function is shift invariant, or, in other words,"]
- **Only diffraction is kept (p. 1357, Section 1).** Of the distortions of the image field (diffraction, aberrations, stray reflections, lens inaccuracies, noise, nonlinearity, discretization), all except diffraction by the circular aperture are said to be reducible to a negligible amount in an ideal system, so the model is an aberration-free, diffraction-limited one. [anchor: "can be reduced to a negligible"]
- **Scalar basis and approximations (p. 1358, Section 3).** All reviewed formulations start from Kirchhoff's scalar diffraction expression; the obliquity factor and the aperture amplitude are treated as slowly varying (constant) over the integral, and the formulations differ only in how they expand the exponent. This is stated for image-space field angles of a few degrees. [anchor: "expression for scalar diffraction"] [anchor: "image field angles are of the order of a few degrees"]
- **How the exponent is simplified (pp. 1358-1364, Sections 4-6).** The path difference r - s is expanded with the binomial series and higher-order terms are dropped, giving Bessel-function integrals over a normalized aperture radius. The paper does not call this "the Fresnel approximation"; the word Fresnel appears only as "Fresnel number". [anchor: "binomial expansion"]
- **How defocus enters (p. 1358, Section 4; p. 1364, Section 6).** In the Born-Wolf form the PSF is a function of defocus, the axial distance of the detector plane from the plane of the focal point, as a quadratic phase term in the aperture integral. The paper's own spherical-coordinate form uses the difference of the distances to the detection point and to the focal point. [anchor: "the distance of the detector plane from"]
- **Large defocus (pp. 1360-1361, Section 5).** With lasers and precise detection it was found that the classical forms fail for low Fresnel number: the 3-D intensity is not symmetric about the in-focus plane and the intensity maximum shifts toward the aperture. [anchor: "is not symmetric about the in-focus plane"]
- **New off-axis formulation (pp. 1364-1365, Section 6).** The spherical-coordinate expansion is more accurate for larger field angles and its intensity is a shift-invariant function in three transformed coordinates, which the authors say could allow a 3-D Fourier transform for use in image-restoration algorithms (left for future study). [anchor: "This function is shift invariant in three dimensions in"]
- **What is shown (pp. 1365-1366, Section 7, Fig. 7).** Computed (not measured) log-intensity cross sections for on-axis and 2.5 mm off-axis focal points with parameters zf = 160 mm, aperture radius 1 mm, wavelength 520 nm, comparing an extended Born-Wolf form (off-axis field is a pure shift of the on-axis field, symmetric about the in-focus plane) with the new form (asymmetric about the in-focus plane; for small field angles the off-axis field resembles a rotation of the on-axis field). [anchor: "is not symmetric about the in-focus plane"]
- **Known discrepancy with measurements (p. 1366, Section 8).** Others had observed significant discrepancies between the classical analytic PSF or transfer function and measured fields; the authors suggest this may be partly due to inaccuracies in the model. They present no measurements themselves. [anchor: "be due partly to inaccuracies in the model"]
- **Refractive index (whole paper).** Refractive-index effects (coverslip, immersion oil, specimen layers) are not stated or modelled; the word "refractive" does not occur in the text.

## Relevance to the thesis

- Supports: G30 in a minimal way (through-focus stacks of 2-D images are the data for 3-D serial-sectioning microscopy, p. 1357). G25 in a minimal way (3-D reconstruction algorithms rely on an analytic PSF model whose accuracy matters, pp. 1357 and 1366).
- Does not support: G24 (aberrations are explicitly set aside as negligible in an ideal system, p. 1357); G25 claims about cost, slowness, artifacts or noise amplification (not discussed); anything about high-NA vector effects (the model is scalar and small-angle); G26 and G27 (no adaptive optics or wavefront sensing); any statement about Fourier light-field microscopy.

## Differences to state if cited

- Scalar, small-angle, aberration-free diffraction model of a wide-field system with a 160 mm image distance and a circular aperture; not a high-NA vector model and not a model of a Fourier lenslet-array system.
- Single homogeneous medium; no index mismatch, so it cannot be cited for depth-dependent or sample-induced aberration (that is the 1991 paper).
- Purely computational comparison between formulations; no experiment in this paper.

## Still unread

- Equation-level correctness of Eqs. (1)-(21) (garbled in extraction; PDF page images not inspected).
- Figure 7 as an image.
- Cited works (Stamnes 1986, Born and Wolf, Hopkins 1955, Li and Wolf 1984, Sheppard 1986, and others) were not read.

## Safe Wording

Standard analytic models of the 3-D point-spread function used in serial-sectioning microscopy treat an aberration-free circular aperture in scalar diffraction theory, and reconstruction algorithms rely on such a model (Gibson and Lanni 1989, p. 1357).
