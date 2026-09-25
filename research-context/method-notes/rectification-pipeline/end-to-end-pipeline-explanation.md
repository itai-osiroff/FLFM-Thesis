# From FLFM elemental views to a rectified image: implementation and thesis explanation

> **Status:** draft
>
> **Reviewed:** 2026-09-25
>
> **Source observation:** 2026-09-25; `algo`, branch `main`, commit
> `d0e08634e71ca0ecc4766e46de9e33d2d351d06a`.

## 1. Purpose, evidence boundary, and reading guide

How does the implemented pipeline turn a captured Fourier light-field microscopy
(FLFM) image into a single two-dimensional reconstruction, and which choices
determine that reconstruction? This document answers that question from the
local source code. It provides a prose base for the reconstruction-method
chapter, the computational part of the evaluation chapter, and a more detailed
supplement. It follows the thesis [writing standard](../../../planning/writing-standard.md):
define the method, identify the evidence for its behavior, and place limitations
beside the claims they qualify.

The inspected checkout is `C:/Users/admin2/Documents/git_clones/algo`, with the
main workflow in `moment_images/`. Its tracked source was clean at inspection.
This account describes the named revision; historical products require their
own code and parameter provenance. In particular, the June 3 eyedrop
provenance identifies a saved configuration and algorithm generation but does
not identify its source commit. The older notes beside this file describe
commit `e5213c91cb24c001f1185a3a9ba8a4fecb3c3f43`, observed on July 16; they
remain a separate implementation observation.

Sections 2–6 supply the principal methods narrative. Sections 7–11 explain the
optional processing branches and experiment harness. Sections 12–15 provide
writing guidance, limitations, reproducibility requirements, and an evidence
map. For chapter drafting, begin with the adaptation paragraphs in Section
12.2 and use the detailed sections to specify the verified experimental
settings. Direct section links:

- [Data and entry points](#2-data-representation-and-the-two-entry-points),
  [interactive preparation](#3-interactive-preparation-from-the-sensor-image-to-elemental-views),
  [global stage](#4-global-rectification-one-translation-per-elemental-view),
  [local stage](#5-pixelwise-rectification-local-displacement-selection-and-resampling),
  and [combined mode](#6-combined-rectification-and-its-reference-choices).
- [HDR](#7-exposure-stacks-and-hdr-assembly),
  [reference rebuilding](#8-optional-subtractive-max-reference-reconstruction),
  [sweeps](#9-parameter-sweeps-from-datasets-to-candidate-reconstructions),
  [scoring](#10-three-distinct-meanings-of-scoring), and
  [saved products and evaluation](#11-saved-products-inspection-and-external-camera-comparison).
- [Thesis-ready prose and defaults](#12-parameter-interpretation-and-thesis-ready-prose),
  [limitations](#13-assumptions-failure-modes-and-interpretation-limits),
  [reproducibility](#14-reproducibility-record-and-verification-of-this-explanation),
  and [source map](#15-source-map-and-observation-record).

Equations below translate the implementation; they are not a new physical
forward model or a derivation of an optimal estimator. Source identifiers such
as **[S3]** refer to the verified file/function map in Section 15.

### 1.1 The scientific scope

The computational task is registration and aggregation of elemental views of a
nominally two-dimensional fluorescent scene. An **elemental view**, also called
a **sub-view**, is one image extracted from the captured view grid. Global
rectification estimates a translation for each view. Pixelwise rectification
estimates a spatially varying displacement for each view. Combined
rectification applies those stages in sequence. Each stage forms an image by
averaging its warped views. **[S1–S5]**

This formulation exploits redundant scene structure across views. A useful
interpretation is that a locally displaced scene feature can be brought into
better correspondence before averaging. That interpretation does not establish
that arbitrary scattering can be inverted, that an optical wavefront has been
measured, or that three-dimensional structure has been reconstructed. The
implemented core contains neither a learned reconstruction model nor a
point-spread-function deconvolution step. Its ability to improve bead recovery
under particular media is an experimental question, to be answered with the
thesis datasets and a defined comparison protocol.

### 1.2 Where the relevant code begins and ends

The application programming interface (API) exposes the reconstruction without
interactive prompts. Optional high dynamic range (HDR) assembly combines
multiple exposures; its specific weighting rule is described in Section 7.

| Layer | Principal files | Role in the account |
| --- | --- | --- |
| Operator workflow and common API | `im_process.py` | Image loading, view extraction, interactive choices, scripted configuration, HDR, diagnostics, and saving. |
| Registration and aggregation | `rectification_strategy.py` | Translation estimation, local displacement search, remapping, and arithmetic averaging. |
| Optional local-stage reference | `iterative_subtractive_max_rebuild.py` | Construct a reference from globally aligned views before local matching. |
| Optional displacement-field blend | `power_blend.py`, `rectification_strategy.py` | Reuse two matching fields and bound the change from an ordinary-intensity field. |
| Experiment execution | `parameter_sweep.py`, `sweep_scheduler.py`, `memory_enforcement.py`, `reliable_io.py` | Load datasets, generate and execute candidates, preserve results, and manage resources. |
| Post-run scoring and inspection | `sweep_analysis.py`, `metric_profiles.py`, `sweep_visualization.py`, `sweep_metric_explorer.py`, `report_generation.py` | Describe and rank completed images; generate visual/report products. |
| External-reference evaluation | `validate_rectification.py`, `trio_benchmark.py`, `trio_oracle_metrics.py`, `human_bead_oracle.py`, `bead_quality_diagnostics.py` | Register external-camera comparisons or score annotated bead structure. |

The root camera-acquisition utilities and gain-calibration modules support the
laboratory workflow. The separate MATLAB material and `python_lf_correction/`
are not the implementation dispatched by these two entry points. The presence
of such files does not make their methods part of a `moment_images` run.
Similarly, a helper defined in a file is not necessarily called: the local
rectifier uses its supplied backward coordinates directly, rather than the
older `_build_backward_map` helper. **[S1, S5, S15]**

## 2. Data representation and the two entry points

Let

$$
V_{ij}(y,x),\qquad i,j\in\{0,\ldots,N-1\},
$$

denote a square grid of grayscale elemental views. In memory this is an array
of shape `(N, N, H, W)`. The first two axes index views; the final two index
pixels inside a view. In `extract_views`, the first view index advances the
sensor's horizontal coordinate and the second advances its vertical coordinate;
do not infer physical row/column orientation from array position alone.
An exposure stack adds an axis, producing
`(E, N, N, H, W)`. The ordinary reconstructed image has shape `(H, W)`.
Displacements are ordered `(dy, dx)`: positive values mean a feature is moved
toward increasing row or column coordinates. The default reference index is
`(N // 2, N // 2)`. For an even grid this is a discrete index selected by floor
division, not a geometrical view lying between the central four images.
**[S1, S3]**

The interactive entry point is:

```text
python -m moment_images.im_process
```

It asks the operator to select images and extraction geometry, choose a
strategy, inspect intermediate figures, and optionally save outputs. Its
`main()` orchestrates strategy objects directly. The scripted entry point,
used by the sweep, is
`rectify_views_from_config(views, RectificationRunConfig(...))`. It accepts an
already extracted array and deterministic parameters, returning a
`RectificationResult`. Both paths share the registration classes, but their
defaults, available controls, and HDR sequencing are not identical. An
interactive run should not be described as a call to the configuration API.
**[S1, S2]**

The result retains the final average, the rectified view stack, reference
index, configuration, input grid used for alignment, and available global and
pixelwise diagnostics. In combined mode the global average and globally
rectified stack are retained separately from the final local result. These
intermediate products provide the natural global-only baseline for that run;
they should not be confused with an independently optimized global candidate.
**[S1]**

```text
Captured image(s)                         Saved numerical view grid
        |                                         |
Image selection and view extraction               |
        +-------------------+---------------------+
                            |
                   V: (N, N, H, W)
                            |
             +--------------+---------------+
             |              |               |
          global          pixel          combined
             |              |               |
      one shift/view   local search   one shift/view
             |              |               |
        translation     backward       global average
             |            remap       and warped views
             |              |               |
             |              |         select reference
             |              |               |
             |              |          local search
             |              |               |
             |              |         backward remap
             +--------------+---------------+
                            |
                  arithmetic view average
                            |
                  metrics and saved artifacts
```

HDR adds exposure assembly at path-dependent points; Section 7 spells these
out instead of implying that the diagram represents every exposure workflow.

## 3. Interactive preparation: from the sensor image to elemental views

### 3.1 Intensity values and geometry-detection images

`get_image_paths` loads readable files from the selected directory in sorted
filename order; automatic HDR exposure times are assigned in that order.
For non-HDR data, the operator can select by image number or filename substring.
`load_image` opens images with Pillow. The processing path expects a
grayscale-compatible image; opening a color file is not itself a documented
color-to-grayscale calibration. By default, the interactive prompt leaves
processing intensities in their native representation. A separate temporary
8-bit image supports geometry detection and display. That proxy maps finite
intensities to `[0, 255]`, replaces non-finite values for the display conversion,
and becomes zero when its range is effectively constant. The proxy does not
replace the processing image unless the operator explicitly elects 8-bit
normalization. **[S2]**

The manual geometry display also offers an equalized contrast proxy, clipped
to its upper intensity range. This makes faint view boundaries easier to
inspect; it is not an enhancement applied to the reconstructed quantitative
image. Likewise, an `unsharp_mask` function exists, but its possible use on the
reference in `main()` is commented out. The program does separately create
sharpened final-image display variants. These must be identified as optional
postprocessing rather than part of registration or the raw reconstructed
average. **[S2]**

If normalization is enabled, min–max scaling changes the numerical intensity
scale before registration. This decision must accompany any comparison of
intensity-dependent metrics or exposure fusion. Preserving native values does
not, by itself, perform dark subtraction, flat-field correction, gain
calibration, or exposure correction. Those operations should only be claimed
when the input provenance records them.

### 3.2 Selecting the grid geometry

Manual selection specifies a view center `(x, y)` and radius `r`, followed by
operator confirmation. Circle detection instead selects a region of interest
(full image, center, brightest-pixel vicinity, or a specified location) and
applies Hough-circle detection to that region. Only the brightest-pixel ROI
selection first uses a `51 × 51`, sigma-five blur to locate a suitable maximum;
this blur is not a separate preprocessing step in the Hough call. The detected centers
are converted back to full-image coordinates and shown for confirmation.
This is assistance for selecting extraction geometry, not a fit of the entire
microlens lattice. **[S2]**

Hough parameters are `dp=1`, minimum center separation 20, and threshold
parameters 50 and 30. Center/brightest-pixel ROI slices can span
`4 × search_radius` (520 pixels at the normal call site), despite the helper's
smaller-size docstring. The `specific` ROI branch swaps the prompted row and
column roles in its bounds check and slicing; manual geometry or inspection
of the actual selected ROI is necessary to interpret that path correctly.
These coordinate details are implementation limitations, not optical effects.

The interactive defaults include a `3 × 3` grid, a detection radius range of
100–130 pixels, and a view-distance scale factor of one. Grid pitch is computed
as the floor of twice the largest radius among the first at most two retained
circles, multiplied by that scale factor. The first retained circle supplies
the extraction center, while the derived pitch also determines patch size.
Therefore center and patch size/pitch do not necessarily derive from exactly
the same circle when several
detections are present. These numbers are software defaults, not measured
optical constants. **[S2]**

### 3.3 Extraction and its consequences

`extract_views` places centers on a regular axis-aligned square grid about the
selected center. It extracts square patches of side `view_dist`, equal to the
grid pitch (and normally `2r` for a single circle); it does not apply a
circular aperture mask. A patch that would extend beyond the source image is
left entirely zero rather than partially cropped or padded with its surviving
pixels. The output array is floating point. The resulting grid is displayed
before registration. **[S2]**

An erroneous center, radius, or pitch changes the data given to every candidate.
Because blank views remain in the grid, they also remain in the arithmetic
average unless later preprocessing explicitly removes them. Neither their
presence nor a poor circle fit is automatically repaired by registration.
Extraction geometry belongs in the reproducibility record alongside algorithm
parameters.

Multiple accepted images are stacked, but `circles_chosen` stores the last
accepted geometry and the subsequent extraction uses that geometry for the
accepted stack. After extraction, an unrestricted `np.squeeze` removes singleton
axes. This is an implementation detail worth retaining in the supplement:
one-view grids and unusual singleton shapes need care, and accepting several
ordinary images does not establish independent per-image registration. The
scripted API is the clearer contract for explicit four- or five-dimensional
arrays. **[S2]**

## 4. Global rectification: one translation per elemental view

### 4.1 Translation estimation

The global stage works on a floating-point copy of the input. For a threshold
fraction $\tau_g$, each view is independently thresholded:

$$
\widetilde V_{ij}(y,x)=
\begin{cases}
V_{ij}(y,x), & V_{ij}(y,x)\geq\tau_g\max V_{ij},\\
0, & \text{otherwise}.
\end{cases}
$$

The reference is zero-padded by $p$ pixels on each side. The implementation
correlates that padded reference with the moving view using
`scipy.signal.correlate2d(..., mode="valid")`. Equal-sized views give a
correlation array of shape `(2p + 1, 2p + 1)`. Its maximum determines an
integer displacement after subtracting the central correlation index:

$$
(d^g_y,d^g_x)=\operatorname*{arg\,max} C-(p,p).
$$

Thus the padding is also the global search bound, from `-p` to `+p` along each
axis. There is no continuous refinement of this maximum, no local mean
subtraction, and no normalized cross-correlation denominator. It is a raw
cross-correlation translation estimate. **[S3]**

The stored array, named a similarity matrix, has shape `(N, N, N, N, 2)` and
holds displacements rather than a retained correlation surface. The scripted
path computes only pairs having the chosen reference as the first view. The
interactive path can ask for all pairwise comparisons. Even when all pairs are
computed, the warp uses only translations relative to the selected reference;
there is no joint consistency optimization across view pairs. Uncomputed
matrix entries contain initialization values and must not be interpreted as
measured translations. **[S3]**

### 4.2 Warping and aggregation

Each non-reference view is translated with the affine matrix

$$
A_{ij}=\begin{bmatrix}1&0&d^g_x\\0&1&d^g_y\end{bmatrix}.
$$

`cv.warpAffine` retains the original `(H, W)` grid and uses constant borders.
The reference view is copied unchanged. The global image is

$$
G(y,x)=\frac{1}{N^2}\sum_{i,j}V^g_{ij}(y,x).
$$

Thresholding affects the shift estimate, not the intensities passed into this
warp. The final mean is not weighted by correlation magnitude, view quality,
exposure, or valid overlap. Zero-filled boundaries participate in the mean;
consequently the edges may become dimmer as overlap decreases. **[S3]**

A translation model cannot account for view-dependent rotation, scale, shear,
or within-view distortion. Ambiguous repeated features can generate a wrong
maximum. On an entirely blank pair, the maximum is tied everywhere and NumPy
selects its first occurrence; this yields `(-p, -p)` rather than an inferred
zero shift. That blank-input behavior was also checked directly in the small
probe recorded in Section 14. It is not a measure of meaningful correspondence.

## 5. Pixelwise rectification: local displacement selection and resampling

### 5.1 What is being estimated

The local stage estimates $d_{ij}(y,x)=(d_y,d_x)$ for each view relative to a
reference image $R$. In pixel-only mode the reference is ordinarily the
central view. In combined mode it is selected after global alignment. At each
pixel the algorithm tests a bounded grid of candidate shifts and selects the
largest local score. There is no continuous optimizer, deformation-energy
minimizer, or learned predictor inside this search. **[S4]**

The class name refers to patch matching, but the implementation evaluates
Gaussian-smoothed products of whole shifted arrays. Its `window_size` is not
a literal square-patch loop controlling all spatial support. It validates the
window against the view dimensions, sets the default displacement radius,
influences the default search stride at factor one, and supplies a default
displacement-smoothing extent. The correlation support is governed by the
Gaussian parameters. This distinction matters when describing what a larger
"window" actually changes. **[S4]**

### 5.2 Thresholding, upsampling, and the candidate grid

Moving-view scoring copies are thresholded relative to each view's maximum.
The selected reference is also thresholded relative to its own maximum.
An external reference is resized if needed, then thresholded; an internal
reference comes from the already prepared view grid. None of these scoring
copies replaces the raw array eventually warped. **[S4]**

With upsampling factor $q$, views are linearly resized to `(qH, qW)`, and an
integer candidate shift on this grid represents $1/q$ original pixels.
The displacement bound becomes $q m$, where $m$ is `max_displacement`.
If the bound is omitted, $m=\lfloor\text{window_size}/2\rfloor$ after
the class increments an even window size to the next odd integer. With
$q>1$, every integer shift in `[-qm, qm]²` is evaluated. **[S4]**

At $q=1$, the default stride is
`max(1, window_size // 10)`, unless a caller supplies `step_size` to the class.
The score tensor still allocates all candidate positions; unevaluated entries
remain zero and participate in subsequent normalization and selection. A
factor-one run with a large window is therefore not equivalent to a dense
integer search. With the usual factor two, this stride issue is avoided because
the effective stride is forced to one. **[S4]**

The implementation shifts arrays with `np.roll`. The normal interactive and
configuration paths enable `zero_fill_roll`, removing wrapped values at image
borders. Direct construction of the strategy class defaults this flag to
false, which permits circular wraparound during matching. Final remapping
still uses constant borders. Record the actual flag rather than assuming the
class and entry-point defaults are the same. **[S4, S5]**

### 5.3 The intensity score, including its actual normalization

Write $J_s(y,x)=J(y-s_y,x-s_x)$ for a candidate-shifted view and let
$\mathcal G$ denote the implemented Gaussian filter with constant-zero
extension. With the ordinary intensity setting, the numerator is

$$
P_I(y,x;s)=\mathcal G[R J_s](y,x).
$$

The default `normalized_conv=True` divides this by

$$
D(y,x;s)=\sqrt{\mathcal G[J_s^2](y,x)\,\mathcal G[R](y,x)},
\qquad
C_I(y,x;s)=\frac{P_I(y,x;s)}{D(y,x;s)+0.1\max_{y,x,s}D}.
$$

The maximum in the stabilizing term is taken over the current moving view's
full spatial/displacement tensor. The reference term is **the smoothed
reference, not its smoothed square**. There is also no local mean subtraction.
These operations do not constitute standard local normalized
cross-correlation (NCC), zero-mean NCC, or a correlation coefficient bounded
by minus one and one. In thesis prose, call this a *Gaussian-smoothed
intensity-product score with the implemented intensity normalization* or a
*local correlation-like score*. **[S4]**

For `normalized_conv=False`, the numerator itself is used. This lower-level
switch exists on the strategy method; it is not a field of
`RectificationRunConfig` or a normal interactive prompt.

The smoothing call uses `truncate=gauss_size / gauss_sigma`. In SciPy's
parameterization, this is a Gaussian radius expressed in standard deviations;
thus `gauss_size` here determines approximately the support radius, not a
literal kernel diameter. Its default is `int(5 * sigma)`. When $q>1$, the
code multiplies sigma by $q$ and recomputes this size, even if an explicit
size was supplied. This should not be written as a conventional
`gauss_size × gauss_size` kernel. **[S4]**

The denominator has a proportional stabilizer, not an unconditional positive
epsilon. If it is identically zero, division can produce NaNs. The subsequent
intended "no signal means zero displacement" check does not reliably recover
that case, because its comparison is made after the division. Signed inputs
can also invalidate the square root through the reference term. Input validity
and confidence are therefore not guaranteed merely by the presence of
normalization. Section 14 records a verified blank-input example.

### 5.4 Optional gradient and Laplacian components

Three optional families add derivative information:

$$
C_\nabla(y,x;s)=\mathcal G[\nabla R\cdot\nabla J_s](y,x),
\qquad
C_\Delta(y,x;s)=\mathcal G[(\Delta R)(\Delta J_s)](y,x).
$$

The gradient uses `np.gradient`, and the Laplacian uses `cv.Laplacian` on the
scoring arrays. Derivatives of each shifted moving array are computed inside
the search. The gradient score preserves derivative direction through the dot
product; it is not simply a product of gradient magnitudes. The Laplacian score
uses signed Laplacians, not their absolute magnitudes. Zero-filled edges can
contribute derivative structure. **[S4]**

Every component, including intensity, is min–max normalized independently
over candidate displacements at each pixel:

$$
\widehat C_k(s)=\frac{C_k(s)-\min_t C_k(t)}{\max_t C_k(t)-\min_t C_k(t)}.
$$

For a finite range no larger than `1e-12`, the component is set to `0.5` at all
shifts. The combined local score is

$$
S(s)=\alpha\widehat C_I(s)
+(1-\alpha)\sum_{k\in\{\nabla,\Delta\}}w_k\widehat C_k(s),
\qquad \sum_k w_k=1.
$$

`intensity` requires `alpha=1` and no component weights.
`blurred_gradient_corr` and `blurred_laplacian_corr` assign all auxiliary
weight to their named component. `blurred_composite_corr` accepts nonnegative
gradient/Laplacian weights and normalizes their positive mass; auxiliary
weight must exist if `alpha < 1`. Legacy names containing `ncc` are accepted
aliases, not evidence of an NCC implementation. At `alpha=1`, auxiliary
components are inactive. **[S4]**

This min–max transformation compares the *relative preference among shifts*
within one pixel. It does not calibrate score confidence across pixels or
views. In a nondegenerate intensity-only search, the winning normalized score
is normally one regardless of how weak the absolute correlation is. Saved
score maps must not be presented as probabilities of correct correspondence.

### 5.5 Selecting and smoothing the field

The algorithm selects `argmax` over the flattened displacement grid at each
pixel. Exact ties choose the first position in row-major order, which can bias
ambiguous matches toward negative shifts. If the absolute raw intensity score
is finite and no larger than `1e-12` at every candidate, the code overrides the
selected indices to zero displacement. That intensity-based override also
applies to auxiliary families; it is not a general confidence test for their
combined score. Component-score diagnostics are gathered before that override.
**[S4]**

If requested, the selected `dy` and `dx` fields are separately Gaussian
smoothed with constant-zero boundaries. This is a post-selection smoothing
operation, not a spatial regularizer jointly optimized with the matching
criterion. The displacement sigma is used on the current working grid without
automatic multiplication by $q$; its physical extent therefore differs
between upsampling settings. Scores are not recomputed for smoothed
displacements. **[S4]**

For $q>1$, score maps and fields are resized back to the original view
dimensions by linear interpolation; displacement values are then divided by
$q$. The resulting field can contain values between the nominal search
increments because interpolation and optional smoothing average neighboring
estimates. Increasing $q$ improves numerical sampling of shifts; it does
not by itself establish increased optical resolution.

### 5.6 Backward remapping and the final image

For each output pixel, the stored coordinates are

$$
\operatorname{map}_y(y,x)=y-d_y(y,x),\qquad
\operatorname{map}_x(y,x)=x-d_x(y,x).
$$

`cv.remap` samples the original moving view at these coordinates using linear
interpolation and constant borders. This is a **backward map**: the output
pixel specifies where to read in the source. It avoids describing the algorithm
incorrectly as independent forward placement of pixels. **[S5]**

When the reference is a member of the view grid, that reference view is copied
unchanged and its matching step is skipped. When an external reference image
is supplied, every elemental view, including the center, is matched and warped.
The external reference itself is not inserted as an extra view in the average.
The reconstructed image is

$$
I_{\mathrm{rect}}(y,x)=\frac{1}{N^2}
\sum_{i,j}\operatorname{Remap}(V_{ij},\operatorname{map}_{ij})(y,x).
$$

There is no score weighting, outlier-view rejection, valid-support
renormalization, or Jacobian intensity correction in this mean. Consequently,
the transformation is not guaranteed to conserve integrated fluorescence, be
invertible, or preserve local geometry. Apparent sharper peaks can reflect
useful alignment, but can also reflect compression or merging of features;
bead fidelity requires separate evidence.

## 6. Combined rectification and its reference choices

Combined mode first estimates global translations and forms globally aligned
views $V^g_{ij}$ and their mean $G$. Local matching is then performed on
those globally aligned views. Its estimated field describes the additional
local correction in the global frame, not the total displacement from the
original sensor patch. The implementation resamples the global output again;
it does not compose both transformations and sample the original patch once.
The intermediate interpolation and zero borders are therefore part of the
implemented result. **[S1, S3–S5]**

Three scripted reference modes are supported:

| Mode | Reference for local matching | Consequence |
| --- | --- | --- |
| `global_average` | Mean of globally aligned views used for scoring | Default combined choice; all views, including the center, are locally matched. |
| `center_view` | Central globally aligned elemental view | Center is preserved in the local stage; no external reference is passed. |
| `iterative_subtractive_max_rebuild` | Reference constructed from the globally aligned scoring stack | Optional feature-selected reference described in Section 8. |

The global-average reference includes the moving view's own contribution;
there is no leave-one-view-out construction. Averages can provide stable
shared structure but can also retain global-stage blur or misplaced features.
The implementation exposes alternatives; it does not establish a universally
best reference. The interactive path asks whether to use the global average
(default yes) or the center. The rebuild option is exposed through the
scripted/sweep path rather than this prompt. **[S1, S2]**

### 6.1 Optional sigma refinement

`pixel_sigma_pyramid=True` repeats local matching at successively smaller
Gaussian sigmas. With the default starting sigma seven, the sequence is
`7 → 3 → 1`, using integer halving after the initial pass. Images are not
downsampled between passes: this is a sequence of matching-support scales,
not a multiresolution image pyramid. Each pass uses the preceding displacement
field, not always the original coarse field. **[S4]**

Candidates differing from the preceding field by more than two original pixels
in either axis have their component scores set to zero. The neighborhood is
axis-aligned; it is not a Euclidean-radius constraint. These candidates remain
in the tensors and the normalization/argmax operation, so zeroing is weaker
than removing them or assigning negative infinity. Ties and signed auxiliary
scores prevent interpreting this as an unconditional bound on the final
update. The full search tensor is still allocated. This path supplies a
coarse-to-fine preference but no convergence or correctness certificate.

### 6.2 Optional intensity power and bounded field blending

`pixel_shift_power=p` changes only the intensity representation used for local
matching:

$$
P_p(z)=\operatorname{sign}(z)|z|^p,\qquad p>0.
$$

The default $p=1$ leaves it unchanged. Current configuration defaults apply
the power to both the reference and shifted moving intensity; setting
`pixel_shift_power_apply_to_reference=False` retains moving-only power.
Thresholding and upsampling precede the power. Gradient/Laplacian components
continue to use unpowered scoring data. Global estimation, raw warping, final
view averaging, and HDR fusion are not performed on powered intensities.
This is a change in displacement selection, not gamma correction of the
returned reconstruction. **[S1, S4]**

For powered scoring, non-finite intensity-copy values are replaced with zero,
signed powers preserve the sign of finite negative inputs, and non-finite
powered values are set to zero. Diagnostic counts are retained. This treatment
is not comprehensive sanitation of auxiliary derivative channels or the raw
output, and negative reference values can still be problematic for the
normalization described above. **[S4]**

The optional power blend computes an anchor field $d_1$ with power one and
a challenger $d_p$ with power greater than one, then forms

$$
\delta=d_p-d_1,\qquad
d_{\mathrm{blend}}=d_1+\beta\delta
\min\!\left(1,\frac{c}{\|\delta\|_2+10^{-12}}\right),
\quad 0\leq\beta\leq1.
$$

For cap $c=0$, the implementation explicitly sets the residual to zero.
Non-finite residual vectors are also replaced with zero. Thus the applied
change from the anchor is bounded in magnitude by approximately $\beta c$,
in original-view pixels. This is a vector-magnitude cap on the residual, not
independent clipping of horizontal and vertical components. The new field is
used to remap raw globally aligned views. **[S1, S5, S7]**

This mode is restricted to combined rectification, is incompatible with the
sigma pyramid, and requires the ordinary `pixel_shift_power` field to remain
one. The paired fields can be cached and reused when only blend weight or cap
changes. Its diagnostic score maps are inherited from the anchor and are
explicitly marked `anchor_inherited`; they are not a new matching-score
evaluation at the blended coordinates. Field gradients, cap-hit fractions,
non-finite residuals, and out-of-bounds coordinates describe the change but do
not prove reconstruction fidelity. This newer option should enter a thesis
result explanation only if its saved run configuration establishes its use.

## 7. Exposure stacks and HDR assembly

### 7.1 The exposure-combination rule

`assemble_HDR` accepts either full images or an exposure stack of views. It is
a weighted exposure composite, called HDR in the code; its returned values
should not be described as calibrated radiance. For exposure index $e$,
time $t_e$, intensity $X_e$ entering weighted fusion, and total exposure
count $E$, its
unnormalized weight is

$$
w_e=\left[\max\left(\frac{X_e}{\sqrt{t_e}},0\right)\right]^E
\mathbf1\{X_e<c_e\max X_e\},
\qquad c_e\in\operatorname{linspace}(0.5,1,E).
$$

It divides these weights by `max(sum(weights), 1e-8)` and returns
$\sum_e\widehat w_eX_e$. Exposure time affects the weights, while the
averaged values are the input intensities rather than $X_e/t_e$. The
cutoff is relative to the observed maximum, not a measured camera saturation
level, and the strict inequality excludes values equal to the cutoff. Pixels
with zero weight in every exposure return zero. Exposure order therefore
matters through both the times and the cutoff sequence. **[S6]**

In view-stack mode, every exposure's view is first multiplied by an
outward-increasing spatial factor

$$
g(y,x)=\exp\left[
\frac{(x-\lceil W/2\rceil)^2+(y-\lceil H/2\rceil)^2}
{2(0.6\lceil W/2\rceil)^2}\right].
$$

The exponent is positive: this is the “center-inverse Gaussian” named by the
interface. It boosts values away from the center and is not a fitted
flat-field correction. If normalization is requested, each weighted
exposure/view is separately min–max scaled before fusion. The maximum used in
the exposure cutoff spans the supplied exposure slice (all views together in
view-stack mode). In image mode, there is no spatial factor; optional
normalization occurs per input image, and the final image is also normalized
when that flag is enabled. Thus $X_e$ in the equation denotes values after
these applicable preprocessing operations, rather than necessarily raw sensor
values. **[S6]**

### 7.2 The path determines when fusion occurs

| Entry and choice | Implemented order |
| --- | --- |
| Interactive HDR without center-inverse Gaussian | Combine complete sensor images first, then detect/extract and rectify the one composite image. |
| Interactive delayed HDR, global-only | Estimate shifts from the first exposure, apply them to every exposure's views, assemble HDR views, and average. |
| Interactive delayed HDR, combined | Globally align exposures using the first exposure's shifts, assemble HDR views, then estimate and apply local correction to that HDR grid. |
| Scripted HDR, global-only or pixel-only | Estimate the selected field on the first exposure, apply it to every exposure, assemble HDR views, and average. |
| Scripted HDR, combined | Estimate global shifts on exposure one; estimate local fields on its globally aligned views; apply both stages to every exposure; assemble HDR from the final per-exposure stacks. |

The scripted combined path also computes an intermediate globally aligned HDR
grid for its global output, but that HDR grid is not its local matching input.
Its local reference average or rebuilt reference derives from the first
globally aligned exposure. In contrast, the interactive combined path locally
refines already fused HDR views. These operations need not commute because
fusion weights depend on intensity and position. **[S1, S2, S6]**

The helper can synthesize times `1, 1/2, 1/4, …` when passed actual `None`, as
in interactive automatic-time mode. Those are assumed times, not measured
metadata. The configuration API wraps its exposure-time value in
`np.array(...)`, so its default `None` becomes a zero-dimensional array and
fails the helper's one-dimensional length check. Explicit positive exposure
times are therefore required for that API's HDR path at this revision. In
addition, the API's `normalize_to_8bit` flag acts through HDR assembly; it
does not automatically rescale an ordinary supplied four-dimensional view
grid before matching. The interactive preparation and sweep image-extraction
paths can perform that earlier normalization. **[S1, S2, S6, S8]**

### 7.3 Interactive completion limits

Static tracing identifies several path-specific limitations at this revision.
In ordinary interactive pixel-only mode, the later overlay section asserts
that `rect_views_after_global` is present even though this branch leaves it
`None`. It therefore does not reach the final export prompts in a normal
Python invocation. Delayed-HDR pixel-only additionally attempts a later
rectification of a five-dimensional array and fails the four-dimensional
shape requirement. The scripted pixel-only API does not share those
interactive orchestration errors. **[S2, S5]**

Accepting multiple non-HDR images also leaves a five-dimensional extracted
array after `squeeze`, which the ordinary similarity calls do not accept.
Rejecting exposures in delayed HDR can leave the exposure-time list
inconsistent with the accepted stack. The geometry-selection routine does
not verify a shared center across accepted exposures. These are source-path
findings, not observations from rerunning the GUI or historical evidence that
a particular thesis run failed.

## 8. Optional subtractive-max reference reconstruction

The combined scripted mode can replace the global-average reference with an
image assembled from selected patches of globally aligned views. Although its
function is named `iterative_subtractive_max_rebuild`, this revision performs
a greedy saliency-peak selection followed by weighted patch accumulation.
It does not repeatedly subtract an image residual, rerun rectification, or
perform iterative deconvolution. **[S9]**

First, the view grid is flattened to `(V, H, W)`, converted to float32, and
non-finite values are replaced with zero. The helper computes a mean image
$M$, a cross-view standard-deviation image $\sigma_V$, and a robust
base $B$. The default base is the per-pixel median. A trimmed-mean option
sorts intensities across views and discards `floor(V × trim_fraction)` samples
at each end, default fraction 0.1; when that count is zero it is an ordinary
mean. A directly supplied base/reference must match the view dimensions.

A feature map is constructed from the optionally blurred mean. Its components
are nonnegative intensity, gradient magnitude, and absolute Laplacian. Each
component is divided by its 99th percentile with numerical safeguards and
clipped to `[0,1]`. The selected family uses the same intensity/auxiliary
weight convention as local matching, followed by another normalization.
However, these are image features, not the signed derivative-product scores
from Section 5. The shared family name does not make the two calculations
identical. **[S9]**

Saliency is formed as

$$
A=\operatorname{Normalize}_{99}\left(
\operatorname{Smooth}\left[
\frac{F}{\epsilon+\operatorname{Normalize}_{99}(\sigma_V)}
\right]\right).
$$

The intended preference is for strong features with lower cross-view
variability. Defaults are feature sigma one, saliency-smoothing sigma one,
and consistency epsilon 0.05. This variability term does not distinguish
registration error, brightness variation, blur, and noise; saliency is a
heuristic selection criterion rather than confidence in physical truth.

Greedy nonmaximum suppression selects the current greatest saliency, records
its location, and zeros a square neighborhood. Selection stops at a peak cap
or when the next peak falls below 0.1 times the initial maximum. Patch radius
defaults to five pixels; suppression radius defaults to that radius. The
automatic cap is at most 128 peaks and approximately one peak per
`(2 × peak_radius + 1)²` pixels, with a minimum configured allowance of one.
**[S9]**

For each peak, the default `best_view` donor is the globally aligned view with
the greatest taper-weighted local feature sum. Its **raw-intensity patch** is
accumulated with a weight equal to peak saliency times the taper. The default
taper is the outer product of one-dimensional Hann windows; flat and Gaussian
alternatives exist. Boundary patches and windows are cropped consistently,
overlaps are divided by accumulated weights, and uncovered pixels retain the
robust base. With sparse reconstruction $Q$, the final reference is

$$
R_{\mathrm{rebuild}}=0.2B+0.8Q
$$

under the default `background_blend=0.2`. This reference is used for local
matching; it is not substituted directly for the final averaged
reconstruction. **[S1, S9]**

The helper returns the reference plus mean, variability, feature/saliency,
peak, donor, and coverage diagnostics. The ordinary `im_process` dispatcher
keeps only `.reference_image`; it does not attach the complete rebuild result
to `RectificationResult`. The helper's adjustable parameters are more numerous
than those exposed by that dispatcher, which passes the metric settings and
otherwise uses defaults. A flat feature map yields no peaks and returns the
base. Selecting base-image donors or setting background blend to one also
leaves the base unchanged. Such no-change behavior is expected and does not
demonstrate a successful correction.

## 9. Parameter sweeps: from datasets to candidate reconstructions

### 9.1 Specification-driven and legacy execution

The main reproducible sweep path is:

```text
python -m moment_images.parameter_sweep --spec path/to/spec.json
```

The JSON specification describes datasets, strategies, parameter axes, stage
budgets, scoring, execution, and optional experiments. A GUI can help construct
and launch such specifications. Without `--spec`, a legacy command-line path
runs a sequential Cartesian sweep over one dataset and writes a summary. It
does not provide the staged composite leaderboard or run-state resume
described below. **[S8, S10]**

Each specified dataset selects exactly one source: a saved `.npy` view array,
one sensor image with extraction geometry, or a directory of exposure images.
Image inputs are extracted once, outside individual candidate runs. Directory
inputs use sorted supported filenames and require HDR. Generated grids can be
cached as `generated_views.npy` or `generated_exposure_views.npy`. The normal
image-input default preserves native intensities; optional 8-bit normalization
is performed before extraction. A saved grid is loaded directly and checked
for square grid shape and HDR consistency. **[S8]**

Dataset identities include shape, dtype, item size, file size, modification
time, and a SHA-256 content hash. Compatibility signatures use content and
processing/HDR semantics rather than just the path. Path relocation is
therefore distinguishable from changed data. A cached generated grid can stand
in for an unavailable original source only when the recorded identity permits
that reuse. This bookkeeping makes reuse explicit; it does not recover
unrecorded acquisition or manual-extraction decisions. **[S8, S13]**

### 9.2 What a candidate changes

A candidate is a canonical rectification configuration, evaluated separately
for each dataset. Global candidates vary global thresholds and padding.
Pixel candidates additionally vary local window, displacement range,
correlation smoothing, field smoothing, threshold, subpixel factor,
sigma-pyramid setting, shift boundary handling, and intensity power where
specified. Combined candidates include global settings, refinement window,
reference choice, and optional coupled power-blend settings. Dataset-specific
HDR/exposure/normalization values are overlaid when the actual task is built.
Each task ultimately calls the same `rectify_views_from_config` API. **[S10]**

The built-in search-space defaults include local windows 15, 25, 35, and 45;
bounds 5, 15, and 25; score sigmas 3, 5, and 7; field-smoothing sigmas 0 and 1;
subpixel factors 1 and 2; and pyramid off/on. They retain local threshold
0.05, ordinary intensity power one, and zero-filled shifts. Default strategies
are pixel and combined. These broad software defaults should never be
substituted for a historical experiment's saved ranges.

### 9.3 Two stages and their budgets

The default specification uses two stages with a nominal budget of 320
candidate configurations per dataset, a stage-one fraction of 0.6 (normally
192 candidates), and up to eight leading seeds for refinement. Stage one
enumerates strategy-specific Cartesian products, deduplicates canonical
configuration signatures, and, when necessary, selects evenly spaced indices
from the deterministic enumeration. The cap is shared across the configured
strategies; it is not 192 candidates for each strategy. The code parses a
`random_seed`, but that field is not used to randomize this enumeration.
**[S10]**

Stage two generates parameter variations around the leading stage-one
configurations. Default `auto_fine` refinement considers original axis values,
midpoints, and bounded half-step extrapolation, favors nearby variants, and
round-robins among seed groups under the remaining budget. A `neighbor`
alternative explores neighboring specified values. Duplicate configurations
are controlled by signatures. The budget helper enforces at least one
stage-two allowance even for a nominal zero remainder; actual completed
counts also depend on available unique candidates, failures, and reusable
runs. Report generated/completed counts rather than assuming the nominal
budget was exactly consumed. **[S10]**

Candidate generation is separate from scheduling. The normal scheduler uses
adaptive memory admission, estimates each task's peak demand, reserves memory,
and updates estimates from successful execution. Its default memory safety
fraction is 0.70, telemetry is enabled, and enforcement is `auto`; fixed-batch
execution is an alternative. Worker failures can lead to reduced parallelism,
isolated execution, or recorded failures. These decisions affect resources and
which outputs complete, but do not intentionally alter the registration
criterion. Runtime comparisons require the execution policy and environment.
**[S12]**

### 9.4 Optional searches that must be named separately

A **metric experiment** changes the in-loop displacement-score family,
intensity blend alpha, and auxiliary weights. It is disabled by default.
The usual `baseline_shortlist` mode expands up to eight leading pixel/combined
baseline configurations into alternative formulations. `independent_search`
instead searches each formulation/alpha variant with its own candidate budget
and optionally its own coarse/fine stages. These produce a separate
`metric_experiments` leaderboard. An alpha report may sort by one primary
metric, default Laplacian variance; its order need not match the composite
leaderboard. This is distinct from simply reweighting already computed output
metrics in the explorer. **[S10, S11]**

A **validation-oracle sweep** is another optional, default-disabled path. It
scores initial candidates using external-camera trio comparisons or human bead
annotations, selects seeds using that evidence, refines them in a validation
phase, and scores the new candidates. In `skip_image_metric_stage` mode it
skips ordinary stage two and can replace root rankings with the successful
validation rankings. The pixelwise rectifier still sees LF data, but candidate
selection is now validation-guided. It is inaccurate to call this entire
workflow an independent blind test merely because camera images never enter
the warp function. **[S10, S14]**

## 10. Three distinct meanings of scoring

### 10.1 Local selection, output quality, and validation

| Score type | Input and decision | What it does not establish |
| --- | --- | --- |
| Local displacement score | Reference/moving-view representations; chooses a shift at each pixel | Absolute image quality or calibrated match confidence. |
| Post-run image metric/composite score | Completed mean image; ranks parameter candidates | Agreement with the physical scene without independent evidence. |
| Validation or bead-oracle score | Completed candidate plus registered external reference or annotations | Independence when the same oracle also selected/refined candidates. |

These three quantities should not all be called “the similarity metric.”
In particular, post-run Laplacian or guide-channel scores do not imply that
the default rectifier optimized a guide image inside its displacement search.
**[S4, S11, S14]**

### 10.2 Metrics recorded from the completed image

The basic image metrics are computed on the numerical average in its raw
intensity scale:

| Metric | Implemented calculation |
| --- | --- |
| Mean and maximum intensity | Arithmetic mean and maximum of the image. |
| Total variation | Sum of absolute first differences along both image axes. |
| Sum of squared gradient | Sum of squared components from `np.gradient`. |
| Laplacian variance | Variance of `cv.Laplacian` in float64. |
| Level-two Haar horizontal/vertical energy | Sum of squared horizontal and vertical detail coefficients after two Haar decompositions; the diagonal detail is excluded. |

The extended registry adds discrete-cosine-transform (DCT) entropy, Gini and
Hoyer sparsity indices, Vollath F4, and a Tamura-type coefficient of variation.
These use a separately min–max-normalized 8-bit average-image channel and/or
a guide channel formed as the absolute Laplacian of a Gaussian-blurred version
of that normalized average. Thus base metrics and guide/extended metrics are
not all calculated on an identical intensity representation. **[S11]**

For supplemental precision: normalized DCT Shannon entropy uses absolute DCT
coefficients, sets the DC coefficient to zero, normalizes their sum, and divides
Shannon entropy by the log of the coefficient count. The blockwise
`ndct_bayes` measure uses edge-padded `8 × 8` blocks, coefficients with
index sum at most six, and averages `1 - sum(a²) / sum(a)²`. Gini describes
inequality of nonnegative values; Hoyer compares L1 and L2 norms. Vollath F4
subtracts vertical two-pixel-lag products from vertical one-pixel-lag products.
The implemented Tamura statistic is standard deviation divided by mean of
absolute finite values. Metric names should be accompanied by these actual
definitions when used quantitatively. **[S11]**

Each run also records field-magnitude mean, standard deviation, 95th percentile,
maximum, and fraction exceeding two pixels, plus statistics of cross-view
standard deviation after rectification. Available selected component-score
summaries and runtime warnings are retained. These are useful diagnostic
measurements, but they are not terms in the default composite score.
The field statistic called `outlier_rate_gt2px` is merely a magnitude threshold;
it does not classify a displacement as scientifically incorrect. **[S11]**

### 10.3 The default composite ranking

For each stage and dataset separately, successful candidates define the minimum
and maximum of each selected image metric. A metric value $m$ becomes
$z=(m-m_{\min})/(m_{\max}-m_{\min})$. A constant finite metric maps to
0.5; invalid values or bounds map to zero. The per-dataset score is

$$
s_{cd}=\frac{\sum_k w_kz_{cdk}}{\sum_k|w_k|}
-\lambda_t z^{\mathrm{runtime}}_{cd},
$$

where the runtime term applies only when its penalty weight is positive.
The default weights are 0.25 each for total variation, squared-gradient sum,
Laplacian variance, and level-two Haar horizontal/vertical energy. Runtime
penalty defaults to zero. Across available datasets for candidate $c$,
the leaderboard uses

$$
S_c=\operatorname{mean}_d(s_{cd})
-\lambda_r\operatorname{std}_d(s_{cd})
-\lambda_m n_{\mathrm{missing}},
$$

with population standard deviation, default $\lambda_r=0.5$, and default
$\lambda_m=1$ per missing dataset. The normal scope is
`global_and_local_metrics`, meaning the final average even for a global-only
candidate; available global intermediate metrics are recorded separately.
**[S10, S11]**

Scores are relative to the successful candidate population in that dataset
and stage. Stage-one and stage-two numerical scores are not directly
comparable. If stage two has a nonempty leaderboard, root ranked products use
that leaderboard; otherwise they fall back to stage one. Changing the set of
completed candidates can change normalization and hence ranks. A claim of
“best” must name the stage, candidate set, metric weights, and dataset scope.

Explicit metric weights or a named ranking profile may replace the defaults;
specifying both in the JSON is rejected. Signed weights are handled by the
weighted formula. Named-profile validation controls whether a profile may use
negative weights; explicit metric-weight dictionaries use the signed formula
directly. The scorer does not automatically invert a metric merely
because the registry calls it lower-is-better. The actual resolved profile is
part of the method. Sharpness, contrast, and sparsity scores may favor noise,
isolated bright artifacts, or feature suppression; their increase is evidence
about that statistic, not automatically about bead accuracy. **[S10, S11]**

## 11. Saved products, inspection, and external-camera comparison

### 11.1 Interactive products and numerical workspaces

Interactive figures show extracted/rectified views, translations or local
displacements, corner/reference overlays, averages, and a global-minus-final
difference where available. Equalized display proxies and four unsharp-mask
variants, with `(sigma, strength)` values `(2,2)`, `(3,2)`, `(2,3)`, and `(3,3)`,
are separate visual products. The unsharp helper normalizes its result to
0–255. Those images must not silently replace the raw final average in metric
or camera comparisons. **[S2]**

The interactive script offers figure saving as 1000-dpi JPGs and, inside that
save branch, an optional workspace export. A nonempty save directory and
acceptance of figure saving are prerequisites for that workspace prompt.
Its workspace can preserve source/processing/detection arrays, views,
global/local results, displacements, sharpened variants, extraction settings,
reference index, strategy, image paths, and HDR metadata. The helper attempts
compressed `.npz` and a MATLAB `.mat` companion and reports failures separately.
The interactive save layout is not the standardized per-candidate sweep
layout. Its export omits several requested settings, including matching-window
sizes, maximum displacement, and the combined-reference yes/no choice. It is
therefore not a complete configuration record: preserve the operator choices
separately. **[S2, S13]**

### 11.2 Sweep artifacts and continuation

For an ordinary successful spec task, the directory is
`runs/<stage>/<candidate-id>/<dataset-id>/`, containing:

| Artifact | Use |
| --- | --- |
| `config.json` | Actual configuration associated with the candidate/dataset. |
| `metric_record.json` | Raw image metrics, formulation identity, warnings, and available field/score diagnostics. |
| `rectified_views.npy` | Numerical final stack, suitable for checking aggregation. |
| `workspace.npz` | Numerical averages, rectified stage arrays, and available displacement/score/blend data; the ordinary sweep writer does not include the original input grid. |
| `avg_rectified.png` | Display preview; numerical analysis should return to the workspace. |
| Optional figure files | Intermediate diagnostic visualizations. |

The root/stage products include summaries, JSON/CSV leaderboards,
`best_configs.json`, optional analysis, an experiment manifest, and durable
`run_state.json`. The GUI can save a `sweep_spec.json`, but the runner does not
guarantee copying its input specification into that filename; retain the actual
input spec separately. Metric and validation experiments
have additional separate products. Generation directories snapshot major
summary products so that one later extension need not be confused with the
original experiment's reported state. These snapshots include selected
per-run previews/workspaces/metrics but are not complete independent copies
of every run file. The parsed `keep_all_run_artifacts`
flag has no subsequent control use in this module; do not infer automatic
artifact pruning from its name. **[S10, S13]**

Resume checks fingerprints/signatures and saved artifacts, rather than merely
skipping an existing directory. Missing required outputs and unreadable
JSON/NPY/NPZ data can trigger recomputation; PNGs are checked for existence,
not successful image decoding. Absent selected metrics can be backfilled from
a valid workspace.
Primary files can fall back to `.bak` copies. Atomic helpers write temporary
files and replace destinations with backup rotation for the supported
JSON/NPY/NPZ/CSV paths; this guarantee does not cover preview PNGs or MATLAB
files. A `workspace.mat` companion is also attempted, but is not required for
resume; its export failure does not invalidate an otherwise valid spec task.
Changed experiments use
the explicit extend/merge mechanisms and compatible dataset identities;
adopting relocated output roots also has explicit handling. These controls
reduce accidental mixing of runs, but an output manifest still needs a source
revision to establish historical code provenance. **[S13]**

`--dry-run` skips rectification and writes a plan, but the experiment runner
prepares datasets before this branch and can create generated-view caches.
It should not be described as guaranteed to perform no writes or input
preparation. Raw-workspace inspection and metric re-ranking use
`sweep_metric_explorer`; visual reports use `sweep_visualization` and reporting
helpers. Re-ranking existing arrays changes the analysis, not the reconstructed
pixel values. **[S8, S10, S15]**

### 11.3 External-camera and annotation evaluation boundary

The validation GUI prepares Validation Camera and ThorCam images for comparison
with an LF result and saves geometry, intensity, crop/scale, transform, and
registration information in a validation workspace. The trio benchmark can
read those references or a saved workspace, register completed LF candidates,
and report validation similarity and a ThorCam baseline. The current benchmark
has several registration profiles; its default is `bead_geometric_v2`, a
bead-based similarity-registration route. These evaluation transformations
can include scale and rotation, unlike the core global translation model.
**[S14]**

Evaluation also tracks comparison support, registration diagnostics, and row
rankability. A small or uncertain common field of view can invalidate an
otherwise attractive score. Human-bead annotations provide an additional
oracle for bead-local structure; they are not measurements automatically
present in ordinary LF input. The exact validation metric and registration
protocol should be described from the actual selected run, not inferred from
the benchmark's current defaults. This document does not treat the external
registration code as an additional stage of the LF reconstruction.

For an ordinary sweep, external comparisons can remain downstream evidence.
If the validation-oracle branch or later manual selection uses the same
reference to pick a winner, that comparison also served parameter selection.
The thesis must state that role and reserve claims of independent validation
for an appropriately separated evaluation. **[S10, S14]**

## 12. Parameter interpretation and thesis-ready prose

### 12.1 Defaults are entry-point dependent

The following are defaults in the inspected code, not a proposed experimental
protocol. Use a saved per-run configuration to identify the requested values,
then apply the effective-value rules described below.

| Parameter | Configuration API default | Interpretation or distinction |
| --- | --- | --- |
| Strategy | `pixel` | Combined is a choice, not the default API strategy. |
| Pixel-only window | `41` | Interactive prompt defaults to `15`. |
| Combined refinement window | `14`, incremented by strategy to `15` | Interactive prompt defaults to `15`; saved requested and effective values may differ. |
| Global pad | `54` | `im_process` passes `int(120 × 0.45)`; direct global-class construction defaults to `56`. |
| Global / local threshold | `0.15` / `0.05` | Per-view fractions of maximum, affecting scoring copies. |
| Maximum local displacement | `None` | Resolves to effective window radius; an explicit value overrides that relation. |
| Score sigma | `None` → `7` | In original-grid units before automatic upsampling scale adjustment. |
| Score size | `None` → `int(5 × sigma)` | Used through SciPy `truncate`; recomputed after upsampling. |
| Field-smoothing sigma | `None` → `0` | No optional displacement Gaussian smoothing by default. |
| Field-smoothing size | `None` → `2 × effective_window_radius + 1` | Relevant when field smoothing is enabled. |
| Upsampling factor | `2` | Half-pixel candidate sampling before downsampling the field. |
| Zero-filled trial shifts | `True` | Direct pixel-strategy construction defaults to `False`. |
| Sigma pyramid | `False` | Optional repeat search at decreasing score sigma. |
| Local score family / intensity blend | `intensity` / `1` | Auxiliary matching components inactive. |
| Intensity power / apply to reference | `1` / `True` | No power effect at one; both-side semantics matter when changed. |
| Combined reference | `global_average` | Center and rebuilt reference are alternatives. |
| Power field blend | Disabled | Raised power, blend weight, and cap must be recorded when enabled. |
| HDR / HDR-assembly normalization | Disabled / disabled | HDR requires an explicit exposure stack; ordinary API input normalization belongs to its caller. |

**Sources:** configuration in **[S1]**, interactive prompts in **[S2]**, effective
parameter handling in **[S3, S4]**. Sweep defaults belong to the sweep
specification and are not safely inferred from this table.

### 12.2 Suggested core methods text

The following is an adaptation base, not a statement that every listed option
was used in the thesis experiments:

> Each FLFM acquisition was represented as a square grid of elemental views of
> the same nominally two-dimensional scene. The reconstruction method aligns
> these views before averaging them. In the global stage, each view is matched
> to the central view by a bounded integer translation search using
> cross-correlation. Thresholding suppresses low-intensity values in the
> matching copies, while the estimated translations are applied to the original
> view intensities. The mean of the translated views provides the global
> reconstruction.
>
> In combined rectification, local matching is subsequently performed on the
> globally aligned views. At each pixel, a bounded set of trial displacements
> is evaluated using Gaussian-smoothed products with a reference image. The
> intensity score uses the implementation-specific normalization described in
> the supplement. The winning displacement defines a backward sampling map;
> optional smoothing and subpixel sampling control the numerical representation
> of that field. Each globally aligned view is resampled by linear interpolation,
> and the arithmetic mean of the resulting views is the final reconstruction.
>
> The reference, displacement bound, matching support, and other numerical
> settings are specified for each experiment. This method estimates image
> displacements rather than an optical wavefront or a volumetric scattering
> model. Its usefulness is therefore evaluated through comparisons with the
> global-stage output and the recorded external-camera references under the
> stated acquisition and registration protocol.

For a run verified to use `global_average`, replace “a reference image” with
“the global-stage average.” Add auxiliary score families, power, HDR, or
reference rebuilding only when they were used. Describe global matching as
cross-correlation and local matching using its explicit normalized
intensity-product formulation. Calling both stages normalized
cross-correlation would misstate the implementation.

### 12.3 What belongs in the main text and supplement

| Destination | Material to retain |
| --- | --- |
| Reconstruction-method chapter | The view-grid model, assumptions, global translation, local score and displacement selection, reference choice, backward warp, arithmetic mean, and principal limitations. |
| Setup/data/evaluation chapter | Actual extraction geometry, input normalization, chosen parameter ranges, candidate selection protocol, metrics, camera registration, and treatment of failed/missing runs. |
| Supplement | Exact score equations, support/stride semantics, HDR branches, optional rebuild/power modes, tensor axes, storage contract, full grids and rankings, numerical edge cases, and source revision. |
| Results | Dataset-specific comparisons and measurements from traceable artifacts; no performance claim follows from the implementation alone. |
| Discussion | Interpretation of established results, including dim-bead loss, false sharpening, registration uncertainty, and no-change cases. |

For the June 3 dense4 eyedrop candidate, the existing provenance records a
`7 × 7 × 400 × 400` grid, combined/global-average mode, global pad 88, local
bound 8, refinement window 19, score sigma 11.5, score-size setting 58, no
field smoothing, intensity matching, and no HDR or 8-bit processing
normalization. These are recorded candidate settings, not defaults or a
complete historical software specification. Its source commit and parts of
the comparison-figure postprocessing remain unresolved. See the
[candidate provenance](../../result-provenance/fig_eyedrop_3_6.yaml) rather
than attributing that image to the current checkout.

## 13. Assumptions, failure modes, and interpretation limits

The method assumes that sufficiently corresponding scene structure is present
across views, that useful displacement estimates lie inside the search bounds,
and that the chosen reference provides an adequate target. A two-dimensional
warp cannot represent arbitrary changes in visibility, depth-dependent blur,
multiple scattering, or lost signal. Thresholds and powered matching can
emphasize bright structures at the expense of dim beads; derivative components
can respond to noise and artificial edges. None of these options supplies an
automatic test of whether a selected feature is a real bead.

Several numerical details impose additional boundaries:

| Issue | Implemented behavior | Consequence for interpretation |
| --- | --- | --- |
| Blank or clipped views | Remain in extraction and aggregation; ambiguous global correlation and potentially invalid local normalization | Inspect input grids and finite score/field diagnostics. |
| Repeated or weak texture | Per-pixel argmax with deterministic tie selection | A field can exist without reliable correspondence. |
| Local deformation | Optional field smoothing, without invertibility constraints | Sharper peaks may accompany geometric distortion or feature merging. |
| Borders | Constant-zero shifts/warps in ordinary paths; no overlap-normalized mean | Edge brightness and scores can depend on padding and displacement. |
| Repeated resampling | Global warp followed by local remap | Interpolation is part of combined output, even when a composed warp would differ. |
| Score confidence | Per-pixel normalization across shifts; inherited scores in power blends | Similarity-map values are not calibrated uncertainty or comparable absolute confidence. |
| Selection bias | Candidate image metrics determine ranking; optional oracle paths can guide further search | An oracle used for selection is not independent evidence on those same data. |
| Historical attribution | Current source differs from previous notes; some run commits absent | Describe verified saved settings and label unresolved implementation details. |

The search also has a substantial memory cost. For one moving view it allocates
component tensors of shape `(qH, qW, D, D)`, where `D = 2qm + 1`, plus an
intensity-normalization tensor when enabled and normalized component copies.
One float32 tensor alone occupies `4 q² H W D²` bytes. At large displacement
ranges this grows roughly as the fourth power of the upsampling factor.
Views are processed sequentially inside this search, but field outputs cover
the full grid and parallel sweep workers multiply resource demand. Scheduler
limits manage execution; they do not change the mathematical method. **[S4, S12]**

For illustration, a `400 × 400` view, factor two, and bound eight give
`D=33`: one float32 search tensor is approximately 2.79 GB in decimal units.
Several such arrays may coexist. This is a tensor-size calculation, not a
measurement of peak process memory or runtime on a thesis experiment.

## 14. Reproducibility record and verification of this explanation

A reconstruction used in the thesis should be traceable through the following
record. Saving a display PNG alone is insufficient.

1. Acquisition identity, sample/medium, camera, exposure sequence, calibration
   and preprocessing, raw input path, and source-array dtype/range.
2. Extracted grid, center/radius/pitch, shape and orientation, and any excluded
   or blank views.
3. Source revision and dependency versions; requested configuration and
   effective values after default resolution, resizing, or odd-window coercion.
4. Reference construction, strategy, global and local parameters, intensity
   power/reference-power semantics, and optional HDR/rebuild/blend settings.
5. Sweep specification, generation, candidate identity, dataset identity,
   selection metric/profile, failed/missing candidates, and any validation or
   annotation input used for selection.
6. Raw average and stacks, global baseline, coordinate/displacement arrays,
   warnings and diagnostics, and the workspace/storage links needed to recover
   those arrays.
7. External-camera registration, valid comparison region, intensity scaling,
   crops, quantitative metric protocol, and the separate figure-render steps.

This document was checked against source, rather than treating the older guide
text or docstrings as definitive. Tiny synthetic probes exercised global shift
sign and the completely blank local case using system Python 3.13, NumPy 2.2.6,
SciPy 1.16.0, and OpenCV 4.13.0. A `2 × 2` grid of `9 × 9` zeros, reference
`(1,1)`, and global pad two returned `(-2,-2)` for a non-reference pair.
With local window three, factor one, radius one, sigma one, Gaussian size
three, and threshold 0.05, the blank moving views produced non-finite scores
and a selected horizontal displacement of minus one. A reference impulse at
`(4,4)` and moving impulse at `(4,2)` gave a global correction `(0,+2)`.
These checks substantiate specific implementation details; they do not assess
scientific reconstruction quality.

The checkout's own `.venv` instead supplied NumPy 1.26.4 and failed at
`np.asarray(..., copy=True)` before that probe could run. The source uses an
API accepted by the inspected NumPy 2 environment, while `requirements.txt`
does not pin a compatible version. No environment or algorithm changes were
made. The full GUI workflow, large sweeps, external-camera registration, and
historical thesis datasets were not rerun for this documentation task.

## 15. Source map and observation record

All line ranges below were checked against the observed revision. They are
lookup aids, not stable identifiers across future edits; retain the commit
alongside the function names. Links open the local source checkout.

| ID | Source and verified line ranges | Claims supported |
| --- | --- | --- |
| **S1** | [im_process.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/im_process.py:79), `normalize_combined_reference_mode`, `RectificationRunConfig`, `RectificationResult`, `rectify_views_from_config`, lines 79–238 and 317–596 | API configuration, dispatch, first-exposure HDR matching, references, power blend, result fields. |
| **S2** | [im_process.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/im_process.py:246), image/proxy helpers 246–315; normalization/sharpening 748–820; directory/ROI/Hough/extraction 933–1123; figures/workspace 1126–1311; `main` 1313–2014 | Interactive preparation, defaults, geometry, execution, displays, saving, and path-specific limitations. |
| **S3** | [rectification_strategy.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/rectification_strategy.py:374), reference resolution 374–397 and 451–478; `GlobalTranslationRectificationStrategy` 505–631 | Center selection, global thresholding/correlation, translation sign, pairwise storage, warp and mean. |
| **S4** | [rectification_strategy.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/rectification_strategy.py:97), metric validation/normalization 97–227; power treatment 245–371; local constructor 646–662; matching and pyramid 815–1419 | Local component equations, normalization, candidate grid, subpixel handling, sigma passes, smoothing, diagnostics. |
| **S5** | [rectification_strategy.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/rectification_strategy.py:669), field blending 669–812; local `rectify`, remap and rolling 1421–1558 | Capped vector residual, inherited scores, backward-map convention, raw resampling, border behavior. |
| **S6** | [im_process.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/im_process.py:822), `assemble_HDR` 822–931 | Weight equation, exposure checks, inverse Gaussian, normalization and image/view return forms. |
| **S7** | [power_blend.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/power_blend.py:21), `PowerBlendConfig`/search adapter 21–145 and field cache 175–318; [parameter_sweep.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/parameter_sweep.py:4447), task cache construction within 4447–4497 | Coupled blend constraints and cached field reuse across blend alpha/cap. |
| **S8** | [parameter_sweep.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/parameter_sweep.py:2267), input specification 257–303; path resolution 1205–1249; `_load_views`, extraction and dataset preparation 2267–2671; identity/signatures 2690–2737 | Dataset input alternatives, cache generation, geometry, shape checks, content identity. |
| **S9** | [iterative_subtractive_max_rebuild.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/iterative_subtractive_max_rebuild.py:194), family rules 67–191; main routine 194–394; array/base/features 406–518; peaks/tapers/donors 521–671 | Rebuild settings, saliency, greedy selection, donor accumulation, diagnostics and no-change cases. |
| **S10** | [parameter_sweep.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/parameter_sweep.py:304), specs 304–1035; candidates/refinement 1336–2157; task evaluation 4008–4104; scoring 5119–5268; metric expansion 5338–5556; oracle ranking/search 6832–7454; `run_sweep_experiment` 7567–8067; legacy/CLI 8068–8692 | Sweep defaults, search stages, scoring formula, optional branches, and current entry-point distinctions. |
| **S11** | [sweep_analysis.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/sweep_analysis.py:76), metrics/records 76–199 and alpha reporting 460–609; [metric_profiles.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/metric_profiles.py:88), image/guide metrics 88–310, registry/profile validation 312–578 and 711–739 | Raw metrics, guide transformations, selected-score diagnostics, profiles, and report ranking. |
| **S12** | [sweep_scheduler.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/sweep_scheduler.py:45), settings 45–128, learning/admission 154–400, workers 538–581; [memory_enforcement.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/memory_enforcement.py:336), backend selection 336–404; `parameter_sweep.py` execution 4447–5118 | Resource admission, telemetry, scheduling defaults and worker-failure handling. |
| **S13** | [parameter_sweep.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/parameter_sweep.py:2175), `_save_run_artifacts` 2175–2258, state/fingerprints 2738–3288, reuse/backfill 3289–3560, adoption/merge 4190–4446, generation products 7475–7525; [reliable_io.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/reliable_io.py:20), 20–210; `im_process.py` workspace helper 1262–1311 | Artifact contents, backup/atomic persistence, compatible reuse, generations, and save limitations. |
| **S14** | [validate_rectification.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/validate_rectification.py:59), options/results 59–173, point/ECC alignment 774–914, workspace 2567–2687; [trio_benchmark.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/trio_benchmark.py:45), settings 45–129, rankability 1244–1250, metric support/scoring 2045–2342, `run_benchmark` 2437–2737; [human_bead_oracle.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/human_bead_oracle.py:312), per-bead/aggregate scoring 312–517 | Downstream comparison scope, registration differences, support/rankability, annotation oracle. |
| **S15** | [repository README](C:/Users/admin2/Documents/git_clones/algo/README.md:1), workflow map; [sweep_visualization.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/sweep_visualization.py:1), viewer/export; [sweep_metric_explorer.py](C:/Users/admin2/Documents/git_clones/algo/moment_images/sweep_metric_explorer.py:1), workspace re-ranking | Repository context and inspection-tool boundaries. |

SHA-256 hashes below identify the actual local bytes read, including their
line-ending representation; they need not equal Git blob identifiers.

| File under `moment_images/` | Observed SHA-256 |
| --- | --- |
| `im_process.py` | `49a68b131fb09274727723abe0d9b8864cd79581e50b1070209596c4b4003602` |
| `rectification_strategy.py` | `3f099de2cf773770ac4a3ad76171ffc701eb6dc86faae317edf800756dd0b87e` |
| `parameter_sweep.py` | `a355b447c1f482d42945869145dac153aea37c08a7b54d902b2b66273a301619` |
| `iterative_subtractive_max_rebuild.py` | `e9aceaa5a2ad4e876cb59888760e53f55c7b0fad75bfb85c424cf711760863cc` |
| `power_blend.py` | `d3defe27f964f5bdb09e3832f2fdefd9ab723b679efedbef1badfc0bc4b59653` |

The source establishes how this revision constructs and ranks candidate
images. It does not establish which optional branches produced every earlier
figure, whether a given candidate is physically faithful, or whether local
rectification improves all tested scenes. Those remain questions for the
saved run provenance and the experimental comparisons.
