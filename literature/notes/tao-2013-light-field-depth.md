# Tao 2013 - Depth from combining defocus and correspondence, light-field cameras

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. W. Tao, S. Hadap, J. Malik, R. Ramamoorthi, "Depth from Combining Defocus and Correspondence Using Light-Field Cameras," 2013 IEEE International Conference on Computer Vision (ICCV), pp. 673-680. DOI 10.1109/ICCV.2013.89 (printed on the first page). Affiliations: UC Berkeley and Adobe. Metadata in the assignment matches; all printed pages 673-680 are present.

## What was read

File C4e_36.txt, complete (printed pp. 673-680): abstract, Secs. 1-8 and references. Figures were read only through captions. The supplementary material (cited several times) is unread.

## Why This Matters

The paper shows, for a consumer plenoptic camera, how one exposure supplies a defocus cue and a correspondence cue (agreement between sub-aperture views), and how they are fused into depth. The correspondence cue is conceptually close to the thesis idea of comparing sub-aperture views, but the paper is about depth of macroscopic scenes, not aberrations or microscopy (gap G30, depth recovery).

## Key Claims (paraphrased)

- **Both cues from one capture (p. 673, abstract).** A micro-lens array captures enough information to refocus and to shift viewpoint within the sub-apertures, so defocus and correspondence cues are both available from one exposure. Before, defocus needed several focus exposures and correspondence needed several viewpoints or cameras. [anchor: "dence are available simultaneously in a single capture."]
- **Sensor type (p. 673).** The paper describes a micro-lens array camera (Lytro, RayTrix). A regular-grid or hexagonal lenslet layout is not stated; the data are treated as an already parameterized light field. [anchor: "An array of micro-lenses captures"]
- **EPI and shear (pp. 673, 675, Sec. 3).** The light field is an epipolar image (EPI) with spatial x and angular u; shearing by a value alpha performs refocusing (after Ng et al.). The final algorithm uses the full 4D data, Eq. 8. [anchor: "Our final algorithm uses the"]
- **Defocus cue (p. 676, Sec. 3.1).** For each shear, average over angle u to get the refocused image, then take the absolute spatial Laplacian averaged over a window (9x9); a high response means in focus. [anchor: "We will use a contrast-based measure"]
- **Correspondence cue (p. 676, Sec. 3.2).** For each shear, take the variance over angle u per spatial pixel, averaged over a window; low variance means best correspondence. The sub-apertures have a small baseline. [anchor: "Because of the small-baseline, we"]
- **Depth and confidence (p. 676, Sec. 3.3).** Per pixel, depth is the shear that maximizes the defocus response and minimizes the correspondence response; confidence is a Peak Ratio of the best to the second-best extremum; the cues can disagree. [anchor: "we use Peak Ratio as introduced by"]
- **Combination (pp. 675-677, Sec. 4).** The two depth maps with confidences are fused by an MRF with source, flatness and smoothness terms to give dense depth. [anchor: "combine both cues in a MRF global optimization process"]
- **Complementary strengths (p. 673, Introduction).** Defocus is better at repeating textures and noise; correspondence is robust at bright points and features and gives sharper results. [anchor: "cues perform better in repeating textures and noise;"]
- **Data and evaluation (pp. 674, 677-678).** All images come from single shots of a "$400 consumer Lytro camera"; the authors wrote their own processing from the RAW sensor data. Evaluation is qualitative plus occlusion-boundary precision and recall against user-marked boundaries, compared with Sun et al. and Wanner et al.; no metric ground-truth depth is reported. [anchor: "We wrote our own light-field processing"]
- **Occlusions (p. 677).** Occlusions are not handled explicitly; defocus copes better with them than correspondence. [anchor: "Although we do not handle occlusions explicitly"]
- **Limitations (p. 679, Sec. 7, Fig. 10).** Objects far from the main-lens focus plane get wrong depth because defocus blur becomes ambiguous and correspondence shows large displacement; a fixed window size creates ambiguities; macro images with large displacements fail. [anchor: "Because our pipeline relies on shearing, objects that are"]

## Relevance to the thesis

- Supports: G30 (a light-field camera gives defocus and correspondence depth cues from sub-aperture views in one exposure; precedent for using disparity between sub-aperture views of a single capture).
- Does not support: anything about aberrations, microscopy, fluorescence, Fourier light-field microscopes or aberration estimation (none of these terms appear in the paper; searched). Does not support claims on lenslet-grid layout, or on quantitative depth accuracy.

## Differences to state if cited

- Tao et al. estimate depth of macroscopic photographic scenes with a Lytro; the thesis treats a flat 2D fluorescent scene whose view-to-view shifts are attributed to aberrations, not depth.
- Tao et al. use shear-based refocusing and MRF smoothing (a depth model); the thesis uses global cross-correlation shifts and a bounded per-pixel displacement search with no depth model.
- Baseline here is the Lytro main-lens aperture, not a microscope pupil.

## Still unread

- Supplementary material (not in the file); figures read via captions only; references not read.

## Safe Wording

A single light-field exposure provides both a defocus cue (refocused-image contrast) and a correspondence cue (agreement between sub-aperture views), which Tao et al. combine to estimate depth for photographic scenes (Tao et al. 2013, pp. 673-676).

## Triage from the first C4c-C4e pass (2026-11-11)

**Author decision.** Add only if comparing light-field depth cues in Chapter 2. This is the same optional candidate listed in C3. Its output is scene depth, distinct from rectified fluorescence intensity.
