# Capture-editor filters, endpoint warnings, and clipping

> **Status:** research brief with source inspection and synthetic MATLAB checks
>
> **Observed:** 2026-11-02
>
> **Scope:** why filtering can produce black/white endpoint warnings; approaches
> to preserving scientific intensities and producing readable display exports.

This AI-assisted note follows the requested `research` skill and the ARS-Codex
3.22.0 `deep-research` quick route. It is a targeted primary-source investigation,
not a systematic review, benchmark, independent review panel, or claim that one
algorithm is the current best method. The application-specific section must name
the inspected revision and distinguish synthetic checks from the user's session.

## Question and main finding

Are warnings introduced by filters expected, and can they be handled reliably?
Sometimes: sharpening deliberately raises local contrast, while thresholding and
background subtraction can deliberately produce zero. But an endpoint indicator
cannot establish how that endpoint arose. Reliable handling requires separate
accounting for the original data, intermediate arithmetic, display mapping, and
export conversion. A hard clamp is a choice that loses distinctions among
out-of-range values; using floating point does not prevent an explicit clamp.
The algebra below makes this distinction explicit. MATLAB's display example
also demonstrates a floating-point filtered image whose values exceed the
default display interval without requiring that the array be overwritten.
([MathWorks, `imshow`, “Scale Display Range of Image”](https://www.mathworks.com/help/images/ref/imshow.html))

## Distinguish the meanings of saturation

1. **Acquisition saturation:** the detector/digitizer did not record the true
   bright intensity. A presentation transform cannot recover those missing
   measurements. Avoiding overexposure is an acquisition issue.
   ([North, 2006, “Establishing your acquisition settings”](https://pmc.ncbi.nlm.nih.gov/articles/PMC2063524/))
2. **Processing clipping:** distinct intermediate values are collapsed to a
   boundary, for example `min(max(x,0),1)`. Once `1.02` and `1.20` become `1`, a
   later reduction of brightness cannot recover their difference. This is a
   direct consequence of that many-to-one mapping, independent of datatype.
3. **Display clipping:** the stored values remain distinct but the current
   screen mapping renders several values black or white. Changing the display
   range can reveal them if the values were retained. `imshow(I,[])` maps the
   stored minimum and maximum to the display endpoints.
   ([MathWorks, `imshow`, Description](https://www.mathworks.com/help/images/ref/imshow.html))
4. **Color saturation:** chromatic vividness is a different concept. It is not
   the appropriate explanation for an editor operating on grayscale arrays.
   In color pipelines, lightness and chroma/gamut handling are separate stages.
   ([ACES, Output Transforms](https://docs.acescentral.com/system-components/output-transforms/))

A value exactly equal to a display boundary is not itself evidence of destroyed
information: an original black pixel, a thresholded pixel, and a clipped pixel
can all have value zero. Counts of `x<=0` or `x>=1` after clamping cannot
distinguish them. Strict pre-clamp tests `x<0` and `x>1` answer a different,
more specific question.

## Why different filters behave differently

| Operation | Expected range behavior and qualification | Evidence |
| --- | --- | --- |
| Gain/offset or contrast window | For `y=g*x+b`, pixels can leave `[0,1]`. A narrow window intentionally maps its tails to endpoints. MATLAB's default `imadjust(I)` explicitly saturates 1% at each tail; this is behavior of that syntax, not proof this editor calls it. | [MathWorks, `imadjust`, Description](https://www.mathworks.com/help/images/ref/imadjust.html) |
| Gamma | For positive `gamma`, `x^gamma` maps strictly interior `0<x<1` to strictly interior output in exact arithmetic. A gamma change alone need not clip valid normalized input; surrounding clamps, finite precision, or other stages must be considered. | Algebra of the power mapping; [MathWorks, `imadjust`, gamma parameter](https://www.mathworks.com/help/images/ref/imadjust.html) |
| Gaussian/mean and bilateral smoothing | A normalized nonnegative weighted average stays between the participating minimum and maximum. Thus smoothing itself does not mathematically require overshoot. This statement assumes valid normalized weights and includes the chosen padding samples; it does not cover a later normalization/clamp. MATLAB describes bilateral filtering as edge-preserving Gaussian smoothing. | Convex-combination bound; [MathWorks, `imbilatfilt`, Description](https://www.mathworks.com/help/images/ref/imbilatfilt.html) |
| Median | The median remains within the sampled neighborhood range. Boundary padding can change that neighborhood; downstream display mapping can still highlight endpoints. | Order-statistic definition; no claim about an uninspected implementation. |
| Unsharp/Laplacian sharpening | For unsharp masking, `y=x+a*(x-G_sigma*x)`, `a>0`, bright edge samples increase and dark samples decrease. A bright value `0.98` with blurred value `0.90` and `a=1` becomes `1.06`. Overshoot is permitted by this arithmetic; hard clipping is an additional operation. Increasing sharpening strength increases local contrast and can create undesirable effects. | Derivation of the unsharp operation; [MathWorks, `imsharpen`, Amount and Unsharp masking](https://www.mathworks.com/help/images/ref/imsharpen.html) |
| Threshold/background subtraction | A hard threshold deliberately maps part of the image to zero. Subtracting an estimated morphological background can also make exact zeros where image and estimate agree. These need not be accidental underflow. Integer subtraction may additionally truncate negative results. | [MathWorks, `imsubtract`, background example and Output Arguments](https://www.mathworks.com/help/images/ref/imsubtract.html) |
| CLAHE | CLAHE redistributes local intensities. Its `ClipLimit` controls local contrast amplification; it is not a guarantee that an endpoint overlay stays empty. `Range='full'` uses the output class's full range; `'original'` limits the output to the input extrema. Local remapping also changes intensity relationships. | [MathWorks, `adapthisteq`, ClipLimit and Range](https://www.mathworks.com/help/images/ref/adapthisteq.html) |

For a broader restoration example, `deconvlucy` explicitly permits output beyond
the input range. Its damping parameter addresses noise amplification and
`edgetaper` addresses boundary ringing. Those address different mechanisms from
an export clamp; they are not a reason to clamp every restoration stage or a
claim that this editor contains deconvolution.
([MathWorks, `deconvlucy`, Description and Tips](https://www.mathworks.com/help/images/ref/deconvlucy.html))

## Established handling and implications for this editor

**Scientific presentation.** QUAREP-LiMi recommends monitoring intensity
adjustments with histograms/range indicators, avoiding signal clipping,
reporting cutoff values, and using the same adjustments for images being
compared. It also asks that nonlinear adjustments be reported and recommends a
linear-adjusted counterpart for gamma-adjusted displays. These practices support
transparent comparisons; they do not identify a universally correct filter or
acceptable clipped percentage.
([QUAREP-LiMi, Image colors and channels, brightness/contrast, comparison, and gamma items](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/image_publishing/2_image_colors_channels.html))

Keep unprocessed data and document the processing applied to copies. Quantitative
analysis and a visually enhanced figure require distinct provenance and an
appropriate interpretation of the processed intensities.
([QUAREP-LiMi, Ethical image processing, original-data and intensity-measurement items](https://quarep-limi.github.io/WG12_checklists_for_image_publishing/fiji_course/image_ethics.html))

**Natural-image display.** A concrete modern example is ACES 2: a scene-referred
image is rendered through a device-specific output transform. Its tone scale has
a continuous monotonic toe and shoulder, followed by separate chroma/gamut
handling. This illustrates controlled range compression at presentation, rather
than treating every intermediate value beyond a nominal display white as an
error. It is a cinema/photographic rendering design, not a quantitative
microscopy intensity transform.
([ACES, Output Transforms](https://docs.acescentral.com/system-components/output-transforms/);
[Tone Mapping, Requirements](https://docs.acescentral.com/system-components/output-transforms/technical-details/tone-mapping/);
[Gamut Compression, Compression](https://docs.acescentral.com/system-components/output-transforms/technical-details/gamut-compression/))

**Artifact-aware enhancement.** Local Laplacian filtering is an established
primary-paper example of separating large edges from small details for tone
mapping and detail enhancement, with demonstrated reduction of halos. The 2011
paper does not establish that any implementation always stays inside `[0,1]`,
recovers saturated measurements, or is the current best method.
([Paris, Hasinoff, and Kautz, 2011, abstract and Fig. 1](https://people.csail.mit.edu/hasinoff/pubs/ParisEtAl11-lapfilters-lowres.pdf))

The following are **engineering recommendations inferred from these sources and
the mathematics**, pending application-specific design and validation:

- Preserve floating intermediate results through operations that support them;
  make required algorithm-domain conversions explicit. Do not simply delete all
  bounds: gamma and CLAHE, for example, have domain/range assumptions.
- Track per-stage strict underflow/overflow before clamping, separately from
  exact endpoints, inherited source endpoints, nonfinite values, and export
  quantization. Distinguish low from high warnings.
- Provide a documented common linear display range for comparative figures;
  optionally offer a disclosed monotonic shoulder/toe for visual exploration.
  Independent auto-rescaling of each panel can conceal intensity differences.
- Reduce sharpening strength or use an edge/detail-aware method when visible
  halos or overshoot are objectionable. Compressing the display range cannot
  undo a ringing artifact already created by the filter.
- Keep scientific/native exports distinct from display-rendered exports and
  retain the recipe and unclamped data if later adjustment is intended.

## Search and verification limits

Sources were inspected on 2026-11-02 through their owning documentation or author
paper pages. Targeted searches covered MathWorks filter/range documentation,
QUAREP-LiMi image-publishing guidance, ACES 2 output transforms, and the original
local-Laplacian paper. Selection favored directly relevant primary specifications,
official implementation documentation, community-authored guidelines, and an
original algorithm paper. Secondary explainers and unverified “SOTA” rankings
were excluded.

MathWorks pages currently identify R2026b; the installed editor's MATLAB release
must be recorded in its own evidence section. The Nature Methods publisher page
was inaccessible in the browsing tool, so checklist claims above rely on the
official, dynamically updated QUAREP-LiMi companion rather than assuming that
its current wording equals the 2024 printed version. No user capture, filter
recipe, or acquisition metadata was supplied to this literature investigation.
There is no universal headroom value or reliable post hoc reconstruction of
values erased by a many-to-one clamp.

## Current editor evidence

Observed 2026-11-02 in `FLFM-Thesis` at commit
`d07c9c80629dff84d9bd7656f5bdcc85bd53d84e`. The working tree contained unrelated
figure-output changes; `git diff -- scripts/capture-editor` was empty. These
observations concern this revision, not the September rectification implementation
or a historical experiment. Application code was not changed for this investigation.

| Observation | Inspected code locator |
| --- | --- |
| Working normalization is `(double(image)-low)/(high-low)`; every enabled operation is followed by `min(max(x,0),1)`, even for floating-point MAT inputs. Output is mapped back to native coordinates and cast to the input class; integers are rounded. An empty/disabled stack returns the original array. | [evaluate.m](../../scripts/capture-editor/+captureedit/evaluate.m), lines 6–9 and 77–81 |
| Integer working limits are datatype limits. Float working limits are observed input extrema, with a safe interval for constants; global/local float inputs share joint extrema. This interval is not an inferred detector saturation threshold or physical bound. | [loadSources.m](../../scripts/capture-editor/+captureedit/loadSources.m), lines 36–47 |
| Viewing limits initially use observed extrema separately from integer datatype limits; global/local share viewing limits. Thus an integer image can acquire more display warnings while its values remain inside the datatype range. | [loadSources.m](../../scripts/capture-editor/+captureedit/loadSources.m), lines 40–47 |
| The overlay first normalizes/clamps the rendered image to the current viewing interval, then marks `normalized<=0 | normalized>=1` magenta. This includes legitimate exact endpoints and cannot distinguish high from low, source endpoints from introduced endpoints, or strict excursions from equality. | [Editor.m](../../scripts/capture-editor/+captureedit/Editor.m), lines 265–270 and 680–681 |
| Viewing limits are editable and shared between global/local. Changing them does not change the filter working range or restore values already clamped by evaluation. | [Editor.m](../../scripts/capture-editor/+captureedit/Editor.m), lines 598–610; [evaluate.m](../../scripts/capture-editor/+captureedit/evaluate.m), lines 6 and 77 |
| Native export calls the same clamping evaluator. Saving an edited MAT file therefore retains the already-clamped output, despite its floating datatype. Optional display TIFFs additionally apply the viewing interval and quantize to uint16. | [exportImages.m](../../scripts/capture-editor/+captureedit/exportImages.m), lines 24–40 |
| Comparison views may contain geometric resampling/fill effects. The native single-image view is a useful control when separating filtering from alignment effects. | [comparisonPanels.m](../../scripts/capture-editor/+captureedit/comparisonPanels.m), camera rotation, resizing, and warping; [Editor.m](../../scripts/capture-editor/+captureedit/Editor.m), render |

The native source arrays remain unchanged; Undo/stack reevaluation can regenerate
an earlier state. This does not make the arithmetic within a clamped edited
result invertible. In particular, a later gain reduction cannot recover values
flattened by an earlier filter, although reducing that earlier filter's gain
and reevaluating from the source can avoid the loss.

### Synthetic probe: actual evaluator, not the active capture

Executed with MATLAB `25.2.0.3123386 (R2025b) Update 3` using a temporary script:

```powershell
& 'C:\Program Files\MATLAB\R2025b\bin\matlab.exe' -batch "run(fullfile(tempdir,'capture_clipping_probe_20261102.m'))"
```

The probe used the catalog's default parameters and the actual
`captureedit.evaluate` function, at native resolution, without an application
change. Its 64×64 double fixture has intensity 0.05 in the left half and 0.95
in the right half; working and viewing limits for endpoint counts are `[0,1]`.
These are constructed test intensities, with no physical units or acquisition.

| Enabled operation | Result min / max | Low endpoints / high endpoints (4096 pixels) |
| --- | --- | --- |
| None (fixture) | 0.05 / 0.95 | 0 / 0 |
| Brightness, gamma, or full window (each separately, default identity settings) | 0.05 / 0.95 | 0 / 0 |
| Gaussian, mean, median, or bilateral (each separately) | 0.05 / 0.95 | 0 / 0 |
| Unsharp | 0 / 1 | 64 / 64 |
| Laplacian | 0 / 1 | 64 / 64 |
| Threshold | 0 / 0.95 | 2048 / 0 |
| Background subtraction | 0 / 0 | 4096 / 0 |
| CLAHE | 0.082031 / 0.984375 | 0 / 0 |

The Laplacian arithmetic before the editor clamp reached **−0.4 and 1.4**,
with 64 strictly low and 64 strictly high values. The actual evaluator output
equaled that raw result clamped to `[0,1]`. This directly establishes introduced
processing clipping for this synthetic fixture. The background fixture, in
contrast, is removed entirely by its morphological background estimate; its
zeros are a consequence of the subtraction rather than evidence of overflow.

A second check applied gain 2 then gain 0.5 to `[0.1 0.4 0.6 0.9]`:

```text
result = [0.1 0.4 0.5 0.5]
maximum absolute error relative to original = 0.4
```

The gain pair would be an identity without the intervening clamp. A third check
used stored values `[0.2 0.4 0.6 0.8]` and viewing limits `[0.2,0.8]`: the overlay
predicate marked two pixels although zero values were strictly outside the
interval. All probe assertions passed; the process exited with code 0. These
checks demonstrate mechanisms, not the clipped fraction in the user's capture.
The exact active capture, stack parameters/order, viewing interval, and sensor
metadata were not inspected.

Minimal self-contained MATLAB reproduction of the two main arithmetic checks:

```matlab
addpath('scripts/capture-editor'); % Run from the repository root.
c = captureedit.catalog();
x = repmat([ones(1,32)*.05 ones(1,32)*.95],64,1);
d = c(strcmp({c.type},'laplacian'));
n = struct('id','lap','type',d.type,'enabled',true,'params',d.params);
raw = x-n.params.amount*imfilter(x,fspecial('laplacian',n.params.alpha),'replicate');
y = captureedit.evaluate(x,n,[0 1]);
assert(nnz(raw<0)==64 && nnz(raw>1)==64);
assert(isequal(y,min(max(raw,0),1)));
d = c(strcmp({c.type},'brightness'));
a = struct('id','gain','type',d.type,'enabled',true,'params',d.params);
a.params.gain = 2;
b = a; b.id = 'restore'; b.params.gain = .5;
assert(isequal(captureedit.evaluate([.1 .4 .6 .9],[a b],[0 1]),[.1 .4 .5 .5]));
```

### Consequence and recommended direction

Sharpening overshoot is expected for these algorithms. Clamping after every
stage is an explicit current design choice, also documented in the capture
editor README, rather than a requirement of floating-point processing. For
scientific use, the recommended direction is to retain signed/headroom-capable
floating intermediates wherever supported, record any required domain conversion,
and separate per-stage strict excursion diagnostics from display-endpoint
warnings. Float export should preserve that processed array; display output
should apply a documented range/tone mapping. This is a recommendation, not an
implemented or validated replacement pipeline. In particular, changing the clamp
policy changes saved-session behavior and requires explicit treatment of gamma,
CLAHE, source normalization, and integer export. A bounded-output or edge-aware
sharpening option addresses overshoot/halos more directly than hiding their
warnings with a wider display range.

Source-file SHA-256 digests at inspection:

```text
evaluate.m     890F7DA7458B3628E40AF5D088A01838D98914E905913EAC2B4C556D57C8C8E8
Editor.m       AFE283A9652487FE16187A03C1181ED5A3750855BF3D6403CE451EB64E025E98
loadSources.m  334D8139653473E7FEC8B7564343C70B1B78747F453D6108A75DD2B06967CF42
exportImages.m 553B84783F855C4BE012B1D1A9D13883573839FCAFC606C621D6BDB3B0CDFDB8
```
