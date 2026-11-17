# Supervisor Meetings

> **Status:** active
>
> **Reviewed:** 2026-11-17

| Date | Topics | Decisions | Follow-Up |
| --- | --- | --- | --- |
| 2026-11-17 | Chapter 3 abbreviated calculations (via the talk cheat sheet): lateral and axial resolution, depth of field, sensor and pixel size, sampling ratio vs camera magnification. | Restructure around the design: design parameters first (number of lenslets $N$, field of view, sensor pixel count; relay matches pixel size), then results. All final formulas in NA and $N$, as multiples of the conventional microscope: $\Delta x_{LF}=N\Delta x_o$, $\Delta z_{LF}\approx N\Delta z_o$, $\mathrm{Range}_{z,LF}=N^2\mathrm{Range}_{z,o}$, so about $N$ depth planes per capture. Start with conventional reminders; exact derivations after, partly in the appendix. Drop the focal-length chains from the main text, the lenses from the parallax figure, and the circle-of-confusion term (assuming proper sampling). Replace $R_{NIP}$ notation with $\Delta x_o$, $\Delta x_{LF}$. Full list with timestamps: [workplan](03-04-design-chapter-workplan.md) section 1. | Approve the [workplan](03-04-design-chapter-workplan.md); settle constants and the $N$ symbol clash with Chapter 5; find out how the lenslets and the 0.375 relay were chosen. |

