# Szeliski - Computer Vision: Algorithms And Applications (2009 Draft, Chapter 3)

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation (decided 2026-11-10: 2nd edition)

Richard Szeliski, *Computer Vision: Algorithms and Applications*, 2nd edition,
Springer, 2022, DOI `10.1007/978-3-030-34372-9` (bib key
`szeliski2022computerVision`). The local file is a pre-publication draft of the
**first** edition dated September 7, 2009, not the cited edition. **The section
numbers and page numbers in this note are the 2009 draft's and are not valid for
the 2nd edition; the 2nd edition was not opened.** Before citing a section, find
the inverse-warping and interpolation sections in the 2nd edition (the author's
free copy or the Springer table of contents) and record the numbers here.

## What was read

`literature/Szeliski Book.pdf` (git-ignored): 110 pages containing the title page
and Chapter 3 "Image processing" only (draft pp. 101-209; draft page = PDF page +
99). **Reading status:** a delegated reader covered the warping, interpolation and
padding passages; the author of this note re-read draft p. 170 (forward versus
inverse warping), which matches. Other locators are from the delegated reading.

## What the draft says

- **Forward versus inverse warping (Section 3.5.1, pp. 169-171, Algorithms
  3.1-3.2).** Forward warping copies each source pixel to its destination and
  leaves cracks and holes, especially when magnifying. Inverse warping samples
  each destination pixel from the source at the mapped location, so it has no
  holes and uses well-studied interpolation at non-integer locations.
- **Resampling from a destination-to-source mapping (p. 172).** When the mapping is
  not a simple inverse, it is better to formulate warping as resampling from a
  destination-to-source mapping; optical flow is given as an example.
- **Mesh-based warping (Section 3.5.2, pp. 175-178).** Local deformations through a
  dense displacement field interpolated from control points.
- **Interpolation (Section 3.4.1, pp. 148-152, Eqs. 3.77-3.78).** Linear (tent),
  cubic and windowed-sinc kernels; bilinear is often used for speed.
- **Borders (Section 3.2.1, p. 117, delegated).** Padding modes for filtering
  include zero padding, which sets pixels outside the image to zero. The draft
  states this for filtering, not for warping.

## What it does not cover

- No dense per-pixel displacement estimation or window-based matching in this
  excerpt (those chapters are not in the file).
- The thesis's exact resampling formula, output(y,x) = input at (y,x) minus
  displacement with linear interpolation and zeros outside, is not stated in the
  draft; it follows from the inverse-warping procedure with the displacement as
  the mapping (inference).

## Relevance to the thesis (gap ID G5)

Textbook support for "warp by backward (inverse) sampling with linear
interpolation". Use the published edition's section on inverse warping and the
section on interpolation, not the draft's page numbers.
