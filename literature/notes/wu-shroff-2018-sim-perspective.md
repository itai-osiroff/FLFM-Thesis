# Wu 2018 - Faster, sharper, and deeper: SIM for biological imaging

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

Yicong Wu and Hari Shroff, "Faster, sharper, and deeper: structured illumination microscopy for biological imaging", Nature Methods 15(12), 1011-1019, December 2018 (Perspective; published online 26 November 2018). DOI 10.1038/s41592-018-0211-z (printed on the first page). The first page carries the flag "Corrected: Author Correction". No discrepancy with the metadata given in the assignment (volume 15, pages 1011-1019, 2018); the issue number (12) is inferred from the printed "DECEMBER 2018" footer, not printed as "(12)".

## What was read

File C4d_25.txt (9 PDF pages, printed pp. 1011-1019): the whole main text, Figs. 1-5 captions and the reference list (the list was only skimmed; refs 30, 46-48 checked). The extracted text starts at the title page and is complete. The file is not valid UTF-8 (Windows-1252 style bytes), which only garbles punctuation. Figure panels were not interpreted, only the captions. Supplementary Figs 1-2 and Supplementary Table 1 are cited in the text and were not read (not part of the file).

## Why This Matters

A recent review of SIM variants. It states the SIM principle and image counts, the speed limits, the artifact sources, how SIM suffers from aberration and scattering in thicker samples, and that adaptive optics (AO) is used to restore it. It is a good single source for the claim that SIM needs several raw images plus a computational reconstruction and is sensitive to aberrations.

## Key Claims (paraphrased)

- **SIM principle (p. 1011).** Sharp structured illumination multiplies the labeled sample, which moves high-frequency sample information into the detection passband; the raw data stay diffraction limited and extra images with phase-shifted illumination are needed to unmix the components computationally, followed by deconvolution. [anchor: "illumination moves SR information into the detection passband"]
- **Image counts, 2D (p. 1011).** Isotropic 2D resolution gain needs three orientations times three phases, nine images in total. [anchor: "a total of nine images"]
- **Image counts, 3D (p. 1013).** 3D SIM needs 15 raw images per reconstruction; a 10 um thick sample sampled axially at 150 nm entails about 1,000 raw images, with phototoxicity and loss of temporal resolution. [anchor: "images (15) are required for 3D reconstruction"] [anchor: "acquisition of ~1,000 raw images"]
- **Nonlinear SIM image counts (p. 1017).** Higher resolution needs more images at finer steps, for example 25 images with one higher harmonic in 2D and 63 with two. [anchor: "63 images (seven phases, nine orientations) with two HOH"]
- **Speed limits (pp. 1012-1014).** Traditional TIRF-SIM temporal resolution is ninefold worse than diffraction-limited TIRFM because nine raw images are required; single-focus spot-scanning SIM gives about 0.1-1 Hz; CSD-ISM needs about 250 raw images per SR image (about 1 Hz); instant SIM, which does the reassignment optically, reaches video rate or better and instant TIRF-SIM about 100 Hz. [anchor: "Temporal resolution in traditional TIRF-SIM is ninefold worse"] [anchor: "CSD-ISM requires ~250 raw images for reconstruction"]
- **Artifact sources (p. 1012).** All SR-SIM methods are prone to reconstruction artifacts, especially when assumptions about the PSF/OTF and illumination do not match reality; named examples are lensing from refractive-index mismatch, hatching from wrong illumination angles, honeycombs from out-of-focus blur, and artifacts from strong photobleaching during a volume. SIMcheck is named as a check tool. [anchor: "all SR-SIM methods are prone to reconstruction"] [anchor: "photobleaching during acquisition of a single volume also induces"] [anchor: "an ImageJ plugin, enables users to iden"]
- **Spot-scanning artifacts (p. 1012).** Artifacts in spot-scanning SIM are not yet systematically investigated, but arise if the assumed system PSF differs from the experiment. [anchor: "can result if the assumed system PSF"]
- **Aberration sensitivity (p. 1012).** Even analog (optical reassignment) spot-scanning SIM, which relies less on computation, has resolution and SNR degraded by aberrations, most commonly spherical aberration (cites a 2P-ISIM AO paper). [anchor: "degraded in the presence of aberrations (most commonly spherical"]
- **3D SIM needs minimal aberration (p. 1014).** 3D SIM gives a large gain provided reconstructions are done correctly and aberrations are minimal. [anchor: "are carried out correctly and aberrations are minimal"]
- **Thick, dense samples (p. 1012).** Traditional 3D SIM does not remove the Poisson noise of the background and performs poorly in thicker, densely labeled samples; spot-scanning SIM filters background with pinholes. [anchor: "performance in thicker, densely labeled samples"]
- **Scattering (p. 1015).** In samples more than about 50 um from the coverslip, scattering degrades the illumination structure and raises background, which lowers resolution and SNR; two-photon excitation is proposed to reduce this. [anchor: "samples that generate greater scattering degrade the illu"]
- **Adaptive optics (pp. 1015-1016).** Imaging at depth can be improved by AO, with either direct or indirect wavefront sensing. Indirect AO was applied to 1P SIM to reach SR through 35 um of C. elegans tissue. Direct AO was combined with 2P-ISIM by descanning the emission onto a wavefront sensor, measuring aberrations and correcting them with a deformable mirror during acquisition; resolution was recovered to 176 nm lateral and 729 nm axial at about 250 um depth. The AO was applied "at each plane" in fixed brain sections (p. 1016). [anchor: "optics (AO), through either direct"] [anchor: "to correct for depth-dependent aberrations"] [anchor: "descanning the fluorescence emission onto a wavefront sensor"] [anchor: "was recovered to 176 nm laterally and 729 nm axially"]
- **AO cost (p. 1016).** The high cost of 2P laser sources and AO elements may be a practical concern. [anchor: "The high costs of 2P laser"]
- **Light-sheet variants (p. 1016-1017).** Bessel-beam SIM in a light sheet needs five diffraction-limited frames per plane and has volumetric resolution 3.5-fold worse than traditional 3D SIM with one high-NA lens but better contrast in thick dense samples; lattice light sheet SIM needs three to five phase-shifted images; coherent structured-illumination LSFM and LLS SIM are limited to thin transparent samples because without dedicated AO it is hard to keep sharp structure in dense aberrating specimens. [anchor: "requirement of five diffraction-limited frames"] [anchor: "cated AO correction, it is difficult to maintain any sharp structure"]
- **Illumination source (p. 1012).** Traditional SIM uses gratings or SLMs to produce coherent interference; DMDs are cheap and flexible but have low efficiency and possibly lower contrast. [anchor: "to generate coherent interference"]
- **Summary (p. 1018).** For thicker specimens spot-scanning variants are generally more robust to aberrations and reconstruction artifacts than traditional SIM; for very thick or scattering samples (above 100 um) multiphoton illumination and AO may be necessary; ISIM is the fastest. [anchor: "generally more robust to aberrations or reconstruction"] [anchor: "multiphoton illumination and AO"] [anchor: "the fastest SR-SIM method available owing to its"]

## Relevance to the thesis

- Supports: G29 in full (several images per reconstruction with the counts above, optical sectioning and resolution gain, sensitivity to aberrations and to reconstruction artifacts, AO used in practice). G26 in part: names direct (wavefront sensor plus deformable mirror) and indirect AO and applies both to SIM. G24 in part: spherical aberration and scattering degrade SIM resolution and SNR. G27 in part: only a cost remark (AO elements are costly); nothing on spatial invariance.
- Does not support: G25 (no statement on PSF estimation, noise amplification or deconvolution cost, except that deconvolution is part of SIM reconstruction). Does not support any claim about Shack-Hartmann specifically (the term is not used), nor about spatially varying versus invariant correction. Does not support a claim that SIM is single-shot or model-free. Contains nothing on light-field or multi-view imaging, on defocus diversity (G30), or on ptychography.

## Differences to state if cited

- SIM (a perspective review) is fluorescence imaging with structured excitation; the thesis method uses unstructured wide-field emission captured in one exposure. The two differ in what is varied (illumination versus detection aperture).
- The review treats aberration as degradation of SIM resolution and SNR; it does not model aberrations as local shifts between views.
- Direct versus indirect AO: the review says "direct" means wavefront sensing (the example descans emission onto a wavefront sensor) and "indirect" is not defined in the text; the sensor type is not named. This is a secondary classification from refs 46-47 (titles: "Direct wavefront sensing..." and "Wavefront sensorless adaptive optics...") not read here.
- The 2P-ISIM AO result is a two-photon point-scanning system, not wide-field.

## Still unread

- Supplementary Figs 1-2 and Supplementary Table 1.
- Cited primary sources (refs 30, 46-48 for the AO results, and Demmerle 2017 as ref 11).
- Figure panels (only captions read).

## Safe Wording

Structured illumination microscopy needs nine raw images per 2D reconstruction and 15 per 3D reconstruction, followed by computational unmixing and deconvolution, and its resolution and signal-to-noise ratio degrade in the presence of aberrations such as spherical aberration; adaptive optics with direct or indirect wavefront sensing has been combined with SIM to image deeper (Wu and Shroff 2018, pp. 1011-1013, 1015-1016).

## Triage from the first C4c-C4e pass (2026-11-11)

**Add.** Use as the overview in Chapter 2. Keep quantitative resolution and aberration claims tied to the primary demonstrations.
