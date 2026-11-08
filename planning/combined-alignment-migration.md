# Combined alignment figure migration — 2026-11-07

> **Status:** historical implementation record. Current placement and figure
> allowance follow the [authoritative structure and budget](revised-thesis-structure.md);
> retaining both method figures during structural migration does not approve
> a permanent departure.

Implemented the approved two-row before / sampling map / after design and linked source/output enlargement through the existing single-view entry point. Separate model, renderer and composition page preserve legacy rendering. Combined recipes have explicit kind/schema/layout versions; migrations create new candidates and retain parents. New imports verify both remapping stages; previews retain hashed executable renderer snapshots. Selection verifies artifacts and rolls back on staging failure.

Decisions: image coordinates are [y,x], view indices are [i=row,j=column]; the inset uses p_src to avoid the existing upsampling q. Magnification is explicit. Saved designs remain frozen until Adopt current renderer is chosen. Opening selected/previews creates a root draft. Chapter-local ragged-bottom spacing avoids a stretched equation page while preserving the template. Caption shortened to leave adequate page-number clearance.

Dense10 is selected and included as Figure 5.2; original selections remain intact. See ../candidate-outputs/figures-source/alignment_evolution_dense10_17_6/qa/verification.md for acceptance evidence and known provenance limits.
