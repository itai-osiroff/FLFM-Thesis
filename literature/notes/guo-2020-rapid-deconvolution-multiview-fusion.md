# Guo 2020 - Rapid image deconvolution and multiview fusion

> **Status:** reference
>
> **Reviewed:** 2026-11-11

## Citation

M. Guo, Y. Li, Y. Su, T. Lambert, D. Dalle Nogare, M. W. Moyle, L. H. Duncan, R. Ikegami, A. Santella, I. Rey-Suarez, D. Green, A. Beiriger, J. Chen, H. Vishwasrao, S. Ganesan, V. Prince, J. C. Waters, C. M. Annunziata, M. Hafner, W. A. Mohler, A. B. Chitnis, A. Upadhyaya, T. B. Usdin, Z. Bao, D. Colon-Ramos, P. La Riviere, H. Liu, Y. Wu, H. Shroff, "Rapid image deconvolution and multiview fusion for optical microscopy", Nature Biotechnology 38, 1337-1346 (November 2020). DOI 10.1038/s41587-020-0560-x (printed on the paper). Published online 29 June 2020. No discrepancy with the assignment metadata (issue number not printed).

## What was read

File C4b_20.txt: the full main text (printed pp. 1337-1346) and the Methods passages on reflective-imaging deconvolution, the network and training (PDF pp. 13 and 15). The remainder of the Methods (sample preparation, imaging systems, registration details, processing of cleared tissue), the Reporting Summary (PDF pp. 18-20), the figure panels and all Supplementary Notes and Figures were not read. Printed page 1344 was checked against the PDF image.

## Why This Matters

Guo et al. state plainly that conventional Richardson-Lucy deconvolution needs many iterations and that multiview and spatially varying cases are very slow, and they propose a faster back projector and a learned network. It is a primary source for the "deconvolution is slow" part of G25 and for what the fix looks like, but it is silent on aberrations and PSF mismatch.

## Key Claims (paraphrased)

- **PSF is required (p. 1337).** Deconvolution can partly reverse blur and noise only provided the imaging process can be characterized, i.e. the PSF is known; RLD assumes Poisson noise. [anchor: "Provided the imaging process can be characterized"]
- **Forward model uses the PSF (p. 1338).** The forward projector must account accurately for the band-limited blurring of the microscope, so the PSF is used for it. [anchor: "The PSF is typically used for f"]
- **Cost of conventional RLD (p. 1337).** A resolution-limited result usually needs ten or more iterations; this is manageable for single-view data, but deconvolving large multiview datasets can take days, often far longer than the acquisition. [anchor: "usually requires ten"] [anchor: "manageable for single-view microscopes"] [anchor: "view datasets can take days"]
- **Spatially varying PSF is especially costly (p. 1342).** Spatially varying deconvolution needs forward and back projectors at every axial slice; the worked example is 27,200 3D convolutions (14 min per volume on one GPU) versus 80 (2.5 s) for an invariant PSF. In this paper the variation comes from reflective-coverslip imaging geometry, not from sample or optics aberration. [anchor: "Unfortunately, spatially varying deconvolution carries a consid"] [anchor: "27,200 3D convolutions"]
- **Proposed fix 1: unmatched back projector (pp. 1337-1338).** Replacing the transposed PSF by a Wiener-Butterworth (WB) back projector cuts the iterations, often to one (bead example: 1 iteration versus 15, tenfold or more speed-up). [anchor: "the number of iterations can be reduced to one"] [anchor: "recovered the object's resolution-limited size with only 1 iteration"]
- **Side effects of the fix (pp. 1338, 1344).** WB introduces small unphysical negative values (set to zero); the authors report it did not amplify noise more than other methods; too many WB iterations can still introduce artifacts, so a single iteration is recommended. [anchor: "unphysical negative values"] [anchor: "nor did it amplify noise more than other methods"] [anchor: "exists, particularly if too many iterations are applied"]
- **Proposed fix 2: learned network (pp. 1344, 1346).** A 3D convolutional network (DenseDeconNet) gives 50 to 160 times speed-up over WB deconvolution for the spatially varying case, and the authors say a simple 2D spatially invariant blur cannot model reflective imaging. Caveats: about 50 to 100 training pairs are needed, training takes days on one GPU, the network is brittle and was retrained for each new sample, and it augments but does not replace classic deconvolution. [anchor: "cannot properly model the physics of the microscope"] [anchor: "must be accumulated before application"] [anchor: "training the network still takes days"] [anchor: "retraining the network on each new sample"] [anchor: "ments, but does not replace"]
- **Not blind (Methods, PDF p. 13, reflective-imaging deconvolution).** The deconvolution is non-blind; the PSFs are simulated widefield detection PSFs based on experimentally measured PSFs. [anchor: "This deconvolution process is not blind"]
- **Aberrations and PSF mismatch.** The word aberration does not occur in the text read, and the effect of an incorrect or mismatched PSF is not discussed (not stated).

## Relevance to the thesis

- Supports: G25 for "deconvolution needs a known PSF" (p. 1337, 1338, Methods) and "iterative deconvolution is slow, particularly multiview and spatially varying" (pp. 1337, 1342), and for the existence of a learned accelerator that needs training data (p. 1346).
- Does not support: noise amplification or ringing artifacts of conventional Richardson-Lucy (the only artifact and noise remarks concern the proposed WB variant); anything about aberrations or PSF mismatch; a claim that the cost is unavoidable (the paper's point is that it can be reduced ten- to several-thousand-fold).

## Differences to state if cited

- The speed problem is presented as relative to acquisition time for very large light-sheet datasets (gigavoxel to teravoxel); single-view deconvolution is called manageable.
- The paper's own method shows the cost is largely algorithmic, so "costly and slow" should be worded as "conventional" or "classical" RLD.
- The spatially varying PSF in Section 4 is a known, simulated PSF in a reflective geometry; it is not an unknown aberrated PSF.
- Microscopes are light-sheet, iSIM, confocal and widefield; no light-field system, no aberrated scenes.

## Still unread

- Supplementary Notes 1-4 (WB derivation, network details) and supplementary figures (noise tests, Supp. Figs. 2-3); Methods text on sample preparation and imaging; Reporting Summary.

## Safe Wording

Classical Richardson-Lucy deconvolution with a known PSF typically needs ten or more iterations, which makes deconvolution of large multiview or spatially varying data slow; Guo et al. reduce this with an unmatched back projector and a trained network (Guo et al., 2020, pp. 1337, 1342, 1346).
