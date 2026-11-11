# Nayar 1994 - Shape from focus

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Shree K. Nayar and Yasuo Nakagawa, "Shape from Focus", IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 16, no. 8, pp. 824-831, August 1994 (IEEE Log Number 9400036; manuscript received July 2, 1992, revised June 24, 1993). No DOI is printed on the pages. No discrepancy with the metadata given in the assignment.

## What was read

C4e_30.txt, the whole file. Completeness check: the file starts mid-page. Its first lines are the tail of the reference list of the previous article (Huang, Blostein ... Zhuang) at the top of the first page of this paper's PDF; the paper's own title, abstract and introduction follow on that same page (PDF p. 1 = printed p. 824; the printed page number is not visible there). All eight pages are present: PDF pp. 1-8 = printed pp. 824-831. The last page also carries the start of an unrelated article (Onural et al.), which was ignored. The error table of Fig. 8(e), garbled in the text, was read from the PDF page image (PDF p. 6, printed p. 829). Figures 5-7 and 9 were not interpreted beyond captions. The text file is not valid UTF-8 and equations are OCR-garbled.

## Why This Matters

Primary source for shape from focus (depth from focus) applied to microscopic objects: a through-focus stack of images, a focus measure per pixel, and the focus peak position gives local depth. It is the closest of the three computer-vision papers to microscopy, and it is a fallback source for G30 (through-focus images used to recover 3D). It uses reflected bright-field light on opaque industrial samples, not fluorescence.

## Key Claims (paraphrased)

- **What it does (p. 824, abstract).** Different focus levels give a sequence of images; a sum-modified-Laplacian focus measure is computed at each pixel, and an interpolation over a small number of focus values gives depth. [anchor: "The shape from focus method presented here uses different"]
- **Target surfaces (p. 824, Section I).** Rough, textured surfaces (texture from roughness or reflectance variation), where shape from shading, photometric stereo, stereo and structured light work poorly; focus analysis alone is not reliable on general scenes, so the method restricts itself to this class. [anchor: "restricting ourselves to a particular class of surfaces"]
- **Defocus as low-pass filtering (p. 825).** Defocus is modelled as convolution of the focused image with a blurring function (Gaussian approximation of physical optics; spread parameter proportional to the blur radius, with a constant that does not matter for the approach), so it is a low-pass filter whose bandwidth shrinks with more defocus. [anchor: "Hence defocusing is a low-pass"]
- **Acquisition by moving the object (p. 825).** Focus is varied by moving the object with respect to a fixed lens and sensor, to keep magnification constant for in-focus points; for small displacements magnification is assumed constant for the depth algorithm. Camera settings are not changed. [anchor: "we propose varying the degree of focus by moving"]
- **Procedure (p. 825).** For each surface element the stage position of maximum focus is found; height equals the focused-plane distance minus that displacement. Only a small number of images (stage increments of Ad) is used, not a continuous sweep. [anchor: "moves the unknown object with respect to"]
- **Local depth (p. 826).** The depth at a pixel uses only focus measures recorded at that pixel, so the method adapts to varying texture. [anchor: "feature of the proposed method is its local nature"]
- **Focus measure (pp. 826-827).** Modified Laplacian (absolute values of the second derivatives in x and y, so that opposite signs do not cancel) summed over a small window (3 x 3 or 5 x 5) for values above a threshold. The measure is nonlinear. The Laplacian output is argued to behave as a Gaussian function of the defocus parameter (central limit argument over random texture), and the authors state this general behaviour holds for any focus operator. [anchor: "Using central limit theorem, the result of applying"]
- **Gaussian interpolation (p. 828).** Three focus values around the maximum (with their displacements) uniquely determine a Gaussian and hence the peak position, width and height; look-up tables make this fast. The Gaussian model holds only in the peak region, and Ad had to be chosen empirically because the width is unknown before estimation. [anchor: "uniquely determine the parameters"]
- **Texture and depth of field affect sharpness (p. 827).** Peaks are sharp for strong texture and weak for weak texture; a smaller depth of field gives a sharper peak (depth of field depends on magnification, aperture and sensor resolution). [anchor: "A smaller depth of field causes the"]
- **System (p. 829).** Nikon Alphaphot-2 microscope with objectives of x10, x40 or x100, a 512 x 480 CCD (about 1 micron per pixel in the evaluation setup), bright-field illumination, motorised z-stage with 0.02 micron resolution, Sun SPARC 2; about 40 seconds for a sequence of 10 images (acquisition, focus measure and depth), estimated under 1 second with custom hardware. [anchor: "about 40 seconds for a sequence of 10"]
- **Accuracy on a steel ball (p. 829, Fig. 8).** A rough steel ball 1590 micron in diameter was imaged with 100 micron stage steps. The depth map from simple maximum picking (coarse) had mean absolute error 30.32 micron, maximum 187.80 micron; with Gaussian interpolation mean absolute error 13.815 micron, maximum 175.82 micron (read from the Fig. 8(e) table in the PDF image). The text states that errors had no obvious correlation with surface orientation and depend on texture, depth of field and Ad. The number of images is OCR-garbled in the text ("1.3"), so not given here. [anchor: "conducted on a steel ball sample"]
- **Second sample (pp. 830-831, Fig. 9).** Tungsten paste via-hole filling on a ceramic substrate (hole about 70 micron), 18 images at 8 micron increments; depth maps median-filtered (5 x 5) to remove scattered wrong values from untextured areas; a reconstructed all-in-focus image is formed by patching best-focused regions. Result shown qualitatively, no error figures. [anchor: "a total of 18 images were taken using stage position"]
- **Stated limits (p. 831).** Small errors come from image noise, the Gaussian approximation and weak texture; some surface roughness detail is lost because of the finite window. Applicable to objects up to a few hundred microns in size in the described system. [anchor: "lost due to the use of a finite size window"]
- **No texture assumption (p. 831).** The authors state no assumption is made about the type of texture; other texture-based shape methods assume regularity and so do not apply. [anchor: "made regarding the type of the textures"]

## Relevance to the thesis

- Supports: G30, that a through-focus stack taken on a microscope can be used to recover 3D shape (depth) of a textured sample, with local per-pixel depth from the focus peak (pp. 824-825, 829).
- Does not support: aberration measurement or correction (aberrations are not discussed); fluorescence (illumination is bright field, reflective opaque industrial samples); light-field imaging; single-shot acquisition (it needs a mechanical z-scan and about 10-18 images); transparent or scattering samples. Not evidence about adaptive optics or alignment of views.

## Differences to state if cited

- Sequential axial scan, many exposures and a moving stage, versus a single-shot light-field capture.
- Recovers surface height of a rough opaque object, not an aberration-corrected image of a planar fluorescent scene.
- Relies on surface texture with enough high-frequency content and on image magnification staying constant; accuracy depends on depth of field and step size.
- Uses a focus operator and a Gaussian peak fit, not a PSF or wavefront model.

## Still unread

- Figures 5, 6(b), 7 and 9 as images (only captions and the Fig. 8 table read from the PDF). Ref. [1] (Born and Wolf) and the authors' technical report [12] were not read. Equations (13), (15)-(22) are OCR-garbled and were not verified.

## Safe Wording

Shape from focus recovers the height of rough, textured surfaces from a through-focus image stack by finding, at each pixel, the stage position of maximum focus measure, and was demonstrated on a microscope with accuracy of about 14 micron mean absolute error on a 1590 micron steel ball (Nayar and Nakagawa 1994, pp. 825, 829); it requires a mechanical axial scan and bright-field illumination of a textured opaque surface.

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Reserve for distinguishing shape from focus from depth estimated from measured blur. It addresses surface shape, a different task from volumetric fluorescence restoration.
