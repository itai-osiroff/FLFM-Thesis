# Mudry 2012 - SIM using unknown speckle patterns (blind-SIM)

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

E. Mudry, K. Belkebir, J. Girard, J. Savatier, E. Le Moal, C. Nicoletti, M. Allain, A. Sentenac, "Structured illumination microscopy using unknown speckle patterns", Nature Photonics 6, 312-315, 2012 (published online 22 April 2012; VOL 6, MAY 2012 on the page footers). DOI 10.1038/NPHOTON.2012.83 (printed on the paper). No discrepancy with the assignment metadata.

## What was read

C4d_21.txt, all four PDF pages (printed pp. 312-315): abstract, main text, figure captions, Methods, references. Complete for the main paper. Supplementary Information (algorithm details, simulation parameters, noise study, Supplementary Fig. S3 on distorted periodic patterns) is NOT included in the file and was unread. Figure images were not inspected, only captions. The file is non-UTF-8 and two-column text interleaves in places.

## Why This Matters

Original blind-SIM paper: it shows that super-resolution from structured illumination can be had without knowing the illumination, and claims insensitivity to aberration-induced illumination deformation. For the thesis it is context for how structured-illumination methods depend on illumination knowledge, and a sequential multi-image alternative to a single-shot approach.

## Key Claims (paraphrased)

- **Claim of the paper (abstract, p. 312).** Image reconstruction can proceed without knowing the illumination patterns provided their average is roughly homogeneous; about two-fold better resolution than wide-field from uncontrolled speckles; insensitive to illumination deformations from the specimen or aberrations. [anchor: "insensitive to specimen or aberration-induced illumination"]
- **Problem with standard SIM (p. 312).** Existing structured-illumination reconstructions need precise knowledge of the patterns, and small errors there produce artefacts in the final image. [anchor: "yielding artefacts in the final high-resolution image"]
- **Conditions for standard SIM (p. 312).** The need for known patterns can be met only if illumination distortion by the sample or objective aberrations is negligible and the set-up is carefully calibrated and stabilized; this limits use to weakly scattering samples. [anchor: "limits the application domain to weakly"]
- **Method (p. 313).** L images, each with a different unknown pattern, give L+1 unknowns (density plus patterns); the underdetermination is handled by requiring the patterns to sum to a constant (homogeneous on average), plus positivity, with conjugate-gradient minimization. [anchor: "roughly homogeneous over the sample plane"]
- **Simulation (p. 313).** Flat 2D sample in the focal plane, NA 1.49, 160 fully developed speckles, Poisson and electronic noise; resolution improves as the speckle effective NA grows and is always better than deconvolution of the wide-field image at the same photon budget. [anchor: "A total of 160 different speckle patterns with NAeff"]
- **Fair-comparison setup (pp. 313-314).** Wide-field images were deconvolved with the same regularization (including positivity) and the same photon budget; in experiments the wide-field image is the sum of the structured images. [anchor: "To ensure the same photon budget, the wide-field image was obtained"]
- **Experiment, periodic grid (p. 314).** 24 images (three orientations, eight shifts) of 90 nm beads, NA 1.45; blind-SIM resolution 160 nm vs 250 nm for deconvolved wide-field, matching an up-to-date SIM that assumes periodicity. [anchor: "periodicity of the light pattern and reaches 160 nm"]
- **Distortion (p. 314).** The text states that blind-SIM can handle strongly distorted periodic patterns beyond classical SIM, but points to Supplementary Fig. S3 for the evidence (unread). [anchor: "which are beyond the reach of classical SIM algorithms"]
- **Experiment, speckle (p. 314).** 150 speckles made by translating a diffuser, on an 80 nm tissue section; clear resolution gain over wide-field and its deconvolution. [anchor: "illuminated by 150 different speckles."]
- **Sectioning remark (p. 314).** Taking the standard deviation of the speckle images (dynamic speckle illumination) can remove out-of-focus fluorescence but gave no resolution gain. [anchor: "did not yield any improvement in resolution"]
- **Resolution claim (p. 314).** About two times better than wide-field microscopy. [anchor: "images with a resolution about two times"]

## Relevance to the thesis

- Supports: G29 (SIM needs several images and known patterns; small pattern errors give artefacts; a blind reconstruction is used to cope; quantities: 160 simulated, 24 and 150 experimental images). Weakly G24 (illumination aberration or sample-induced deformation is named as an obstacle).
- Does not support: G25, G26, G27, G28. Nothing here on detection-path aberrations, wavefront sensing, AO or deformable mirrors. Not evidence for the abstract claim of insensitivity to aberration unless the Supplementary is checked; in the main text the only aberration-related evidence is by reference to Supplementary Fig. S3. Acquisition time, computation time and cost are not stated.

## Differences to state if cited

- Resolution gain via many sequential images with uncontrolled illumination; thesis method is a single exposure.
- Illumination is the unknown; emission aberrations are not modelled (PSF h is assumed known, estimated by averaging isolated fluorophores).
- Simulations use a flat 2D sample at focus; experiments use thin samples.
- Iterative inverse problem; thesis method is shift-based alignment, not an inverse problem.

## Still unread

- Supplementary Sections I and II and Fig. S3 (algorithm, noise study, distorted-pattern test). Figure images. Acquisition and runtime: not stated in main text.

## Safe Wording

Blind structured illumination microscopy reconstructs a sample from many images taken under unknown illumination patterns and was reported to be insensitive to illumination deformation from the specimen or aberrations, whereas standard SIM requires precisely known patterns (Mudry et al., 2012, pp. 312-313).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Use for unknown-pattern reconstruction if needed. Controlled illumination diversity is still needed; the paper does not establish recovery through arbitrary tissue scattering.
