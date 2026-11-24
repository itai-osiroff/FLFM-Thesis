# Chapter 5: retired Shack–Hartmann analogy (legacy)

> **Status:** historical
>
> **Reviewed:** 2026-11-24

## Why it was retired

At the supervisor meeting of 2026-11-24 the author offered to simplify the
"aberrations as shifts" section by comparing the FLFM to a Shack–Hartmann
sensor. Anat replaced that with her own account: the aberration happens in the
tissue; the lenslets split the Fourier plane into segments, each segment
approximates the wavefront by its mean tilt (a piecewise-linear approximation),
and each tilt becomes a shift of that view. Waves from two different emitters
reach the Fourier plane differently, so each has its own piecewise-linear
approximation, which is why the correction varies across the field (the local
stage). The author decided the same day to delete the Shack–Hartmann analogy
from Chapter 5 for now and keep it here as legacy.

Scope: only the Chapter 5 analogy was removed. The Shack–Hartmann sensor as an
adaptive-optics method (Chapters 1 and 2, the literature notes) is prior work
and stays. Chapter 1, paragraph 3, also uses the Shack–Hartmann geometry as
motivation ("This placement is also the geometry of the Shack–Hartmann
sensor..."). It stays (author, 2026-11-24): it is referenced, and that is
enough.

## Removed text (verbatim, `overleaf/main/05_image_reconstruction.tex`, third paragraph of `sec:aberrations-as-shifts`, as of commit b0e156b)

```latex
Refocusing corrects one kind of shift: defocus, where the shift grows linearly across the pupil. An aberration also shifts the views, but in a less regular pattern. Each shift measures the average tilt of the light over that view's part of the pupil. This is how a Shack--Hartmann wavefront sensor works \cite{platt2001shackHartmannHistory}, and the FLFM lenslet array acts as one, with the scene in place of a guide star. The shifts therefore sample the slope of the wavefront error $W(u,v)$, and defocus is its quadratic case \cite{wu2021digitalAdaptiveOpticsDaoslimit}. More views sample $W$ more finely and give more angular data for correction.
```

The paragraph is kept in the chapter without its two Shack–Hartmann
sentences until the piecewise-linear rewrite (P2–P4) replaces it.

## Related sources

- `literature/notes/platt-shack-2001-shack-hartmann-history.md` (lenslet spot
  displacement as wavefront tilt; principle only).
- Earlier plan row: `planning/03-light-field-model-plan.md`, B6 (historical).
