# Chung 2019 - CACAO-FB computational aberration compensation

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

J. Chung, G. W. Martinez, K. C. Lencioni, S. R. Sadda, C. Yang, "Computational aberration compensation by coded-aperture-based correction of aberration obtained from optical Fourier coding and blur estimation," Optica 6(5), 647-661 (2019), DOI 10.1364/OPTICA.6.000647 (printed on the paper). Received 29 Jan 2019, published 10 May 2019. No discrepancy with the assignment metadata (p. 661 holds only references).

## What was read

Whole of C4c_02.txt (15 pp, printed pp. 647-661): abstract, Sections 1-5, all captions, reference list. Not read: Supplement 1 (Eqs. S2-S9, Fig. S1 overlap study, Figs. S2-S3 motion registration, Visualization 1) and the figures as images (captions only). The text file is not valid UTF-8 and equations are partly garbled, so equations were read from the prose. Page numbers come from the running headers.

## Why This Matters

CACAO-FB (coded-aperture-based correction of aberration obtained from overlapped Fourier coding and blur estimation) is the incoherent counterpart of Horstmeyer 2014: it adapts overlapped Fourier coding to spatially incoherent light, estimates a pupil function per image tile, then deconvolves. It is the closest published precedent for tile-wise (field-dependent) aberration correction of incoherent images, and the authors name fluorescence as a prospective target.

## Key Claims (paraphrased)

- **Aim and novelty (Abstract, p. 647; Sec. 1, p. 648).** Overlapped Fourier coding is adapted to an incoherent modality so spatial coherence is not needed, and the latent image is recovered by deconvolution made noise-robust with coded apertures. [anchor: "adapting overlapped Fourier coding to an incoherent imaging modality"]
- **Why coherence mattered (Sec. 1, p. 648).** Fourier-ptychography aberration recovery was limited to setups with a well-defined, spatially coherent field on the sample. [anchor: "spatially coherent field on the sample plane"]
- **Target scenarios include fluorescence (Sec. 1, p. 648).** One of three listed scenarios is a sample field that is incoherent by nature, with fluorescence emission as the example. [anchor: "spatially incoherent by nature (e.g., fluorescence emission)"]
- **Fluorescence is a stated prospect, not a demonstration (Sec. 5, p. 660).** The authors say the method should be a viable solution for static fluorescent wide-field samples because fluorescent signals are incoherent. No fluorescent sample is imaged in the main text; demonstrations use LED-illuminated transmission targets, a laser-illuminated eye model and an in vivo macaque retina. [anchor: "since the fluorescent signals are inherently"]
- **Acquisition (Sec. 2.A p. 651; Sec. 3.A p. 655; Sec. 4 p. 659).** A relay images the lens pupil onto an SLM; intensity-only images are taken with (i) small circular masks (64 of 1 mm in the simulation, about 40% overlap, spiral scan) to measure local PSFs and (ii) a full aperture plus four rotated coded apertures for deconvolution. In vivo, 213 frames were summed for each big mask and 4 for each small mask, a 45 s sequence with motion registration. The experimental small-mask count is not stated in the main text. [anchor: "there is one full aperture and four"]
- **Not single-shot (Sec. 5, p. 659).** Stronger aberration is handled by smaller scanned apertures, at the cost of acquisition speed (more images). [anchor: "comes at the expense of the acquisition speed as more images need"]
- **Per-region estimation (Sec. 2, pp. 649-651).** The image is divided into small tiles treated as isoplanatic (aberration constant within a tile) and the pupil function is recovered separately per tile. Within a tile, PSFs for different point positions differ only by a lateral shift, so the tile image is the object convolved with one PSF. [anchor: "small tiles of isoplanatic patches"] [anchor: "PSFs for different point source locations are"]
- **Tile size is chosen visually (Sec. 3.B, p. 658).** In the eye-model test the tile is the biggest one that still gave an aberration-free image, judged by eye. [anchor: "biggest tile that could produce an aberration-free image"]
- **Local PSF estimation (Sec. 2.B-C, pp. 651-652).** Each small-mask image is compared with the near-aberration-free centre-mask image and the local blur kernel is found by iterative Tikhonov deconvolution (image-pair blur estimation); the kernels are stitched into the complex pupil by Fourier-ptychography alternating projections, which needs at least 30% aperture overlap. The pupil is recovered as a general complex function, not as Zernike coefficients. [anchor: "adopt an image-pair-based blur estimation algorithm"]
- **Centre of the pupil is nearly aberration-free (Sec. 2.B, p. 651).** For locally near-linear phase a small-mask kernel is a shifted diffraction-limited spot; masks over stronger aberration give kernels that deviate from a spot. [anchor: "near the center of an imaging lens is minimal"]
- **Shape matters beyond shift (Sec. 3.B, p. 657; Fig. 15, p. 658).** With severe aberration the local kernels had distinct shapes as well as lateral shifts, and using centroids alone (as Shack-Hartmann does) distorted the result. [anchor: "aperture images had distinct shapes in addition to lateral shifts"]
- **Final step is deconvolution (Sec. 2.D, pp. 653-655).** An aberrated OTF can have near-zero values, where plain division would amplify noise; coded-aperture images fill the nulls and a combined iterative Tikhonov deconvolution recovers the object intensity. The authors report minimal artifacts at an input SNR of at least 40 in simulation. [anchor: "during deconvolution will amplify noise at these spatial"] [anchor: "signal-to-noise ratio (SNR) of at least 40"]
- **Comparison with blind recovery (Sec. 1, p. 648; Sec. 2.C, p. 652).** The authors say blind (Zernike or sharpness-based) recovery is prone to local minima and heuristic methods depend on the sample; in a simulation, two blind deconvolution algorithms reconstruct the PSF poorly while their pipeline succeeds. [anchor: "blind recovery is prone to converging"]
- **Spatially varying correction is demonstrated (Sec. 3.A p. 656; Sec. 3.B p. 658).** Three regions of a USAF-target grid imaged through an inexpensive single-element trial lens gave drastically different PSFs and were compensated separately (features resolved up to Group 5 Element 5); the eye model showed severe spatially varying aberration with good deconvolution across the field. [anchor: "the recovered PSFs in the three different regions"]
- **Compute time and photon cost (Sec. 2.C p. 652; Sec. 2.D p. 655; Sec. 5 p. 660).** On a laptop, Algorithm 1 took 2 min and Algorithm 2 20 s for 64 images of 1000 by 1000 pixels, and Algorithm 3 took 2 s for 5 images. The Fourier-plane amplitude mask discards much of the light. [anchor: "it takes 2 min for"] [anchor: "Using an aperture mask in the Fourier plane discards a"]
- **Stated limitations (Secs. 4-5, pp. 659-660).** Suited to static targets; in vivo SNR was very low (the full-aperture frame about 7.5 before averaging), eye drift limits averaging, specular reflections corrupt data, and the retinal result is not on par with a typical AO retinal imager. [anchor: "captured images of the retina have low SNR"]
- **Adaptive optics and Shack-Hartmann (Sec. 1, pp. 647-648; Sec. 5, p. 660).** The authors describe AO as a wavefront detector (for example Shack-Hartmann) plus a compensating device (for example a deformable mirror), with a feedback loop and a guide star, correcting one isoplanatic patch at a time so the field must be raster-scanned. They state that non-overlapping tiny masks reduce their scheme to Shack-Hartmann sensing. [anchor: "needs a separate guide star for the correction process"] [anchor: "If the masks on the pupil are shrunk smaller with no overlap"]

## Relevance to the thesis

- Supports: G28 (Fourier-ptychography aberration recovery needed spatially coherent illumination and sequential captures; this paper adapts it to incoherent light, Sec. 1, p. 648). G25 only narrowly: aberrated-OTF deconvolution amplifies noise where the OTF is near zero (p. 653). G26/G27 only as the authors' description of AO (pp. 647-648). G30 not supported (aperture-scanned, not through-focus, acquisition).
- Does not support: any claim that fluorescence was imaged (stated prospect only); single-shot operation (many aperture-coded frames, 45 s in vivo); a claim that deconvolution-based correction is generally noisy or artifact-prone (the paper argues its coded-aperture deconvolution is robust, Fig. 7); anything about light-field or multi-view imaging, or depth/3D (not discussed).

## Differences to state if cited

- CACAO-FB is sequential and SLM-based (dozens to hundreds of frames); the thesis acquires one Fourier light-field frame.
- It recovers an explicit pupil function per tile and deconvolves; the thesis method estimates no pupil or PSF and does not deconvolve (global integer shift per view, then per-pixel bounded displacement search, warp, average).
- Its tiles are discrete isoplanatic patches with one pupil each; the thesis refines shifts per pixel.
- It requires a static scene and a relay of the lens pupil onto an SLM; the thesis sub-aperture views come from a lenslet array in the Fourier plane.
- The picture of a local PSF as a shifted spot under low-order aberration resembles the thesis assumption of aberration as shifts between views, but the paper itself reports that severe aberration also changes kernel shape.

## Still unread

- Supplement 1 (S2-S9 derivations, overlap study Fig. S1, motion registration Figs. S2-S3, Visualization 1).
- Figures as images (captions only).
- Number of small-mask images used in the experiments.

## Safe Wording

Chung et al. adapted overlapped Fourier coding to spatially incoherent light: they recover a pupil function per isoplanatic tile from aperture-scanned intensity images and then deconvolve with coded apertures (Optica 6, 647-661, 2019, Secs. 2-3, pp. 649-656); they state it should apply to fluorescent samples because fluorescence is incoherent, but demonstrate it only on non-fluorescent targets and an in vivo retina (p. 660).

## Triage from the first C4c-C4e pass (2026-11-11)

**Reserve.** Consider for a dedicated pupil-coded comparison. Its actively varied apertures and blur-kernel inversion differ from registration of simultaneously sampled views.
