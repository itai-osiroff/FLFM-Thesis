# Pentland 1987 - A new sense for depth of field

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Alex Paul Pentland, "A New Sense for Depth of Field", IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. PAMI-9, no. 4, pp. 523-531, July 1987. No DOI is printed on the pages (IEEE Log Number 8613854 only). No discrepancy with the metadata given in the assignment.

## What was read

C4e_34.txt, the whole file: PDF pp. 1-9 = printed pp. 523-531 (title page with abstract, Sections I-IV, Appendix, references). Complete. The figures (Figs. 1-6) are scanned images and were not interpreted; only their captions were read. The text file is not valid UTF-8 (legacy encoding) but readable; equations are garbled by OCR, so formulas were read from the surrounding prose only.

## Why This Matters

Early computer-vision paper that proposes recovering a depth map from the amount of defocus in one or two ordinary images, with no search over lens settings. It is a fallback primary source for the statement that defocus carries depth information (G30). It is not about microscopy, fluorescence, aberrations or light fields.

## Key Claims (paraphrased)

- **Core idea (p. 523, abstract).** Depth can be estimated at all image points simultaneously from the amount of defocus, using only one or two images, instead of the autofocus approach of searching the lens setting for best focus point by point. [anchor: "estimate depth simultaneously at all points"]
- **Depth equation (p. 524, Section II).** Distance D follows from the lens parameters (image-plane distance, f-number, focal length) and the spatial constant of the point spread function, which is modelled as a 2D Gaussian. The only unknown in most situations is the blur width. Two solutions exist (in front of or behind the plane of exact focus); this is avoided by keeping the focused surface nearer than all objects. [anchor: "as a Gaussian with spatial constant"]
- **Method A, sharp edges (p. 524-525).** Blur is measured from the slope of the Laplacian zero-crossing at step edges, because at edges the image variation is due mainly to the PSF; it needs one image and the scene contribution known (edges recognised as such). [anchor: "image data surrounding them can be used to de-"]
- **Method B, two apertures (pp. 525-526).** Two images of the same view are taken with different aperture sizes (beam split by a half-silvered mirror, or alternate video frames), so they differ only in depth of field. Corresponding patches are compared in the Fourier domain; the ratio of transforms gives the difference of squared blur widths and hence depth. With a pinhole image as one of the two the equation gives depth directly. [anchor: "half-silvered mirror"]
- **No matching problem (p. 525).** Because the two images are identical except for aperture, they are compared point by point; there is no stereo-style correspondence step. [anchor: "there is no matching problem as there is with stereo"]
- **Overconstraint check (p. 526).** With three or more views each blur width gives its own depth estimate; disagreement tells the algorithm not to trust the answer, for example when the patch has too little high-frequency content. [anchor: "this overconstraint allows us to"]
- **Accuracy (p. 526-527).** Accuracy is argued theoretically for human-eye parameters (assuming about 2 percent error in blur estimation) and found comparable to human stereopsis over a few metres. Not measured on a camera test target. [anchor: "approximately 2 percent error"]
- **Experiments (pp. 528-529).** Edge method demonstrated on an indoor image (sand castle, refrigerator, door) with 3 of 8 bits of noise; depth values varied along edges and had to be averaged over zero-crossing segments. Two-aperture method demonstrated on a pair of images of a mirrored bottle on a checkered plane that were re-digitised from a computer-graphics paper (ref. [14], Potmesil and Chakravarty), i.e. synthetic, not captured by the author's camera as far as the text states. Results are qualitative depth maps; no error table. [anchor: "substantial noise (3 of 8"]
- **Accuracy statement in Discussion (p. 529).** The sharp-edge version is probably not accurate enough for a depth map but is useful for depth-plane segmentation. The two-aperture version is described as having somewhat less accuracy than stereo or motion. An outside report of about 1.25 cm accuracy with a simple version is mentioned as a note. [anchor: "not accurate enough to produce a depth map"]
- **Stated limit (p. 529).** The main limitation is ensuring enough high-frequency information (image resolution and scene content) to measure the change between images. [anchor: "major limitation in measuring focal gradient depth"]
- **Real-time claim (p. 528-529).** Author estimates a depth map over a 256 x 256 image in under half a second with standard hardware; this is an estimate, not a reported measurement. [anchor: "in less than a half-second"]
- **Blur model and calibration (p. 530-531, Appendix).** A Gaussian is justified by diffraction rings summed over wavelengths and the central limit theorem; the constant relating blur-circle radius to Gaussian width depends on the optics and must be determined for the system to get absolute distance. [anchor: "constant of proportionality k must be determined"]
- **Assumed blur model validity (p. 526).** The convolution model of a patch can be substantially wrong for large defocus, because neighbouring points spread into the patch by different amounts; patches with smoothly decaying edges are suggested. [anchor: "may be substantially in"]
- **Human perception (pp. 527-528).** Part of the paper reports psychophysical experiments (subjective depth rises with focal gradient, pinhole demonstration). Not relevant to the thesis.

## Relevance to the thesis

- Supports: G30, only the general statement that the degree of defocus (blur width) is a depth cue that can be used to estimate depth from one or two images of a scene taken with known, different optical settings (aperture), page 523 (abstract) and Section II.B.
- Does not support: anything about measuring aberrations, wavefront sensing, fluorescence, microscopy, light-field or multi-view imaging. Do not cite it for through-focus aberration measurement. Do not cite it for quantitative depth accuracy of a real camera (accuracy is theoretical for the human eye; experiments are qualitative; one imagery source is synthetic). The paper mentions chromatic aberration only as a source of a second, differently defocused view in the human eye (p. 528) and as a PSF broadening term (Appendix).

## Differences to state if cited

- Needs two images with different aperture (or one edge-containing image), whereas the thesis method uses a single exposure.
- Assumes a known, space-invariant Gaussian PSF per patch and a locally constant depth over the patch; the thesis method models aberration as shifts between views and does not use a PSF model.
- Aim is depth of an opaque scene by blur magnitude; the thesis aim is aberration-corrected in-focus 2D recovery.
- The sharp-edge version requires identifiable step edges; the two-aperture version requires scene texture with high-frequency content.

## Still unread

- Figures 1-6 as images (captions read only). The cited ref. [10] (human experiments) and [13], [14] were not read. Equation typesetting is garbled in the text; equations were not independently verified.

## Safe Wording

Early work showed that the amount of defocus in one or two images of a scene, taken with different apertures, can be converted into a depth map without searching over focus settings (Pentland 1987, p. 523 and Sec. II.B); the method relies on a Gaussian blur model and on scene texture with sufficient high-frequency content (p. 529).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use for depth-from-defocus history if needed. The estimates concern scene surfaces in camera images.
