# Wang Et Al. 2021 - Real-Time Volumetric Reconstruction With LFM And Deep Learning

> **Status:** reference
>
> **Reviewed:** 2026-11-10

## Citation

Zhaoqiang Wang, Lanxin Zhu, Hao Zhang, Guo Li, Chengqiang Yi, Yi Li, Yicong
Yang, Yichen Ding, Mei Zhen, Shangbang Gao, Tzung K. Hsiai, and Peng Fei,
"Real-time volumetric reconstruction of biological dynamics with light-field
microscopy and deep learning," *Nature Methods* 18(5), 551-556, 2021. DOI
`10.1038/s41592-021-01058-x`. The bioRxiv preprint has a different title; this is
the published paper.

## What was read

Author-supplied PDF `literature/Wang et al., Nature Methods 18(5), 551–556, 2021.pdf`
(git-ignored), the published article, 6 pages (PDF page n = journal page 550 + n).
Methods and supplementary material are online only and not in the file.
**Reading status:** a delegated reader covered all six pages; the author of this
note re-read journal pp. 551-552 (abstract, introduction, Fig. 1, start of the
method), which match. Other locators come from the delegated reading.

## What the paper says

- **Problem (abstract and introduction, p. 551).** LFM is limited by artifacts,
  non-uniform resolution and slow reconstruction. Classic reconstruction is
  iterative and computationally heavy; hardware modifications mitigate artifacts at
  the cost of added system complexity.
- **Method (pp. 551-552, Fig. 1).** A view-channel-depth (VCD) convolutional
  network (U-Net-type). The light-field image is rearranged into views, whose
  features are fed into the channels of each convolutional layer; output channels
  are assigned to depth planes, so the network outputs a 3D stack directly.
- **Training (p. 552, Fig. 1a-b).** High-resolution 3D images of stationary samples
  (synthetic or experimental, for example from point-scanning confocal) are
  forward-projected into synthetic light fields with a wave-optics LFM model
  (Broxton et al.) and paired as input and ground truth; loss is pixel-wise
  mean-squared error. Quantities of training data are in supplementary tables
  (not in the file).
- **Setup (Fig. 1a).** A standard microscope with a microlens array and camera
  (not Fourier LFM). Objectives 40x/0.8 W and 20x/0.5 W (delegated reading).
- **Headline results (pp. 552-555, delegated).** About 13.5 volumes/s of
  reconstruction versus about 900 times slower for iterative deconvolution on the
  same worm data; bead resolution of about 1.1 um lateral and 3.0 um axial, uniform
  over 60 um, against 2.6/5.0 um near focus rising to 4.0/7.0 um at the edge for
  deconvolution (Fig. 1g; PDF p. 2 shows 2.38/5.1 um and 1.26/3.23 um for the
  selected bead). Applications: calcium activity in moving *C. elegans*; blood flow
  and ejection fraction in a beating zebrafish heart at up to 200 Hz.
- **Limitations (Discussion, p. 556, delegated).** Performance depends on training
  data; considerable numbers of training images are needed; generalization is
  discussed in supplementary notes (not read). Compatibility with a Fourier LFM is
  mentioned but not demonstrated. There is no dedicated limitations section.

## Relevance to the thesis (gap ID G14)

- The learned-reconstruction family: a supervised network trained on synthetic
  light fields from a wave-optics model, mapping a light-field image to a 3D volume.
- Useful as a contrast: the thesis reconstructs a single 2D image by alignment and
  averaging, with no training data and no learned model.
- Note the sentence in its introduction that classic reconstruction is iterative and
  slow, and artifacts and non-uniform resolution limit LFM (p. 551). That is a
  primary-source statement for the Chapter 1 and 2 limitations (G19).

## Safe Wording

Wang et al. train a convolutional network on synthetic light fields, generated with
a wave-optics model from high-resolution volumes, to map a light-field image to a
3D stack directly, reporting video-rate reconstruction [Wang 2021, p. 551-552].
Do not describe it as FLFM or as aberration correction.
