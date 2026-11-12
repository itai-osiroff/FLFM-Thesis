# Open Questions

> **Status:** active
>
> **Reviewed:** 2026-11-12

| Question | Area | Owner | Status | Notes |
| --- | --- | --- | --- | --- |
| What exact thesis chapter order best serves the argument? | Structure | Author | Decided — 2026-11-08 | Author approved the seven-chapter [structure and budget](revised-thesis-structure.md); content migration remains pending. |
| How is the 488 nm excitation beam coupled into the shared objective, and what filters and contrast path does the Validation Camera use? | Chapter 4 system | Author | Open | The [physical system account](../research-context/physical-system-composition.md) establishes the major paths but not these elements. |
| Are both installed 40× objectives the deck's N40X-PF model, and what are the measured lens spacings and sensor positions? | Chapter 4 system | Author | Open | The hardware deck names one objective model; the ray-optics scripts give design focal lengths. |
| Which sample preparation, acquisition settings, view-extraction geometry, calibration, and code revision apply to each selected Chapter 6 result? | Chapter 4 data/provenance | Author | Open | Fill from raw captures, saved run records, and a [result-provenance](../research-context/result-provenance/) record; do not infer settings from filenames or a later code checkout. |
| What are the pixel pitch and sensor size of the main Blackfly S BFS-PGE-244S8M camera, and which emission band and detection filters set the wavelength used in the design relations? | Chapter 4 design-values table | Author | Open (added 2026-11-12) | Needed for the sampling rate, Nyquist verdict, object-space pixel, and the check that the pupil span fits the sensor. Take pixel pitch and sensor size from the manufacturer data sheet and cite it. The filter question extends the existing excitation/filter item above. |
| Is there a field stop or iris at an intermediate image plane (between the two relay lenses before the array), and which lenslets are retained for the views? | Chapter 4 system | Author | Open (added 2026-11-12) | A field stop enforces the no-overlap condition that Chapter 3 B4 states; without one, the field is set by the specimen and illumination footprint. The retained-view set fixes the largest view angle used for axial resolution. The ray-optics scripts do not model a stop. |
| What is the objective's field number or usable field of view? | Chapter 4 system | Author | Open (added 2026-11-12) | Upper bound on the field against the maximum no-overlap field of about 0.82 mm from the design values. |
| Which candidate-selection rule, numerical metrics, common support, and external-camera registration apply to each reported comparison? | Chapter 4 evaluation | Author | Open | The [method source account](../research-context/method-notes/rectification-pipeline/end-to-end-pipeline-explanation.md) documents available paths, but a final result needs its own protocol and selection disclosure. |
