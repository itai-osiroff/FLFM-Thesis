# Technical-stage writing worksheet

> **Status:** template
>
> **Reviewed:** 2026-11-08

Use with the [technical writing guide](../technical-writing-guide.md). Copy only
the applicable parts into a draft worksheet; write the thesis as connected prose.
Replace brackets with inspected evidence or `unknown`; use `not applicable`
with a reason. These fields contain no experimental facts or preset claims.

## Placement and space

- Authoritative chapter/ownership: [link to the applicable entry in the
  [structure and budget](../revised-thesis-structure.md)]
- Current/projected prose-equation page equivalents: [estimate and build/revision]
- Figure/caption/table footprint: [separate estimate; existing and proposed visuals]
- Main-text essentials: [what the reader needs in the chapter]
- Supporting detail: [appendix/provenance destinations and links]
- Budget state: [within target / inherited migration debt / proposed departure /
  approved departure with author-decision link; TBD is not a new allocation]

Complete the relevant evidence fields below across the main and supporting
account. Filling a field does not require another paragraph, heading, or figure
in the thesis.

## Scope and evidence

- Stage and chapter/section: [name and target]
- Question answered: [one sentence]
- Account type: [physical model / implemented procedure / specific experiment]
- Source observation: [repository, full commit, date, file/function/section]
- Experiment: [dataset/run/configuration identifiers, or not applicable]
- Claim/provenance links: [existing records]
- Missing evidence: [what is unknown and which record can resolve it]

## Stage description

**Purpose and assumptions.** [Problem addressed, reason for the operation,
conditions required, and known violations. Distinguish motivation from tested
justification.]

**Input.** [Meaning, axes/shape, datatype, units, spatial sampling, origin,
calibration and preprocessing state.]

**Operation.** [Ordered transformation; reference choice; optional path;
distinction between matching copies and reconstructed data.]

**Mathematics/algorithm.** [Defining equation or pseudocode, symbol definitions,
coordinate/sign conventions, finite search support/ties or solver/stopping
behavior, implementation locator. Use an optimization objective only if it
describes the actual estimator.]

**Parameters.** [Names and reference to the authoritative table/configuration;
how values were obtained and whether selection used the evaluated data.]

**Implementation.** [Entry point/version, numerical precision, interpolation,
padding/cropping, boundary behavior, normalization and zero handling.]

**Output and transition.** [Meaning, shape, units, changed sampling, saved
artifact, and how the next stage consumes it.]

**Checks and limitations.** [Diagnostic/metric with definition, data and scope,
actual failure/exclusion rule, result evidence. Label proposed checks as proposed.]

## Parameter ledger

Link the authoritative run record: [path]. If the table below summarizes that
record, maintain it when the record changes; do not make it a second source of
truth. Class values: acquisition/calibration, algorithmic, numerical,
evaluation, display; learned weights and training settings only if applicable.

| Stage | Parameter / symbol / config key | Requested -> effective value | Units / grid | Class | Fixed or per-image | Evidence locator |
| --- | --- | --- | --- | --- | --- | --- |
| [stage] | [name] | [value or unknown] | [unit] | [class] | [scope] | [config + revision] |

| Parameter | Selection rule and dataset | Tested range | When fixed | Sensitivity evidence / missing record |
| --- | --- | --- | --- | --- |
| [same name] | [actual selection process] | [range or unknown] | [record] | [link or not performed] |

## Notation and physical assumptions

| Symbol | Meaning | Domain / axes / shape | Units | Measured / fixed / estimated | First equation / implementation |
| --- | --- | --- | --- | --- | --- |
| [symbol] | [meaning] | [domain] | [units] | [status] | [locator] |

- Coordinates: [continuous/discrete, origin, axis order, displacement direction]
- Physics: [image quantity, optical assumptions, retained/neglected effects]
- Discretization: [sampling and units conversion]
- Noise/statistics: [justified assumptions or no statistical model asserted]
- Validity: [regime and failure conditions]
- Derivation checks: [dimensions, limiting cases, agreement with implementation]

## Evaluation and selection boundary

- In-loop score and role: [what it selects]
- Candidate-ranking metric and role: [what it ranks]
- External reference and registration: [source and procedure]
- Data used to select settings/candidates: [identifiers]
- Data used for reported evaluation: [identifiers and overlap with selection]
- Selection/exclusion rule, including manual choices: [record]
- Unit of replication and number of independent samples: [evidence]
- Uncertainty/aggregation and failed or missing runs: [actual treatment]
- Permitted conclusion: [bounded statement supported by this protocol]

## Figure-caption worksheet

[Declarative observation supported by the panels.] (a) [data and processing
state]. (b) [stage output and comparison]. (c) [diagnostic/reference, if present].
[Sample/condition and field-of-view relationship.] Scale bars: [value and unit
with calibration provenance]. [Symbols/colors.] [Display ranges, projection,
interpolation, and any nonlinear display processing.] Quantification used
[actual data state]. Settings: [table]. Provenance: [record]. Limit: [if needed
to interpret the comparison].

## Reproducibility pointers

- Inputs, calibration, and manual ROIs: [identifiers and access locations]
- Code revision and entry point/command: [exact record]
- Configuration and effective-value transformations: [record]
- Environment and consequential hardware/randomness: [record]
- Outputs, evaluation, figure export and checksums: [record]
- Replay status: [not attempted / attempted with outcome and date]

For an actual learned stage, additionally record sample-level splits,
normalization, architecture and weights identifier/hash, loss, optimizer,
schedule, augmentation, stopping/checkpoint selection, seeds, and inference
tiling/postprocessing. Omit this extension from the current non-learned
rectification account.

## Review outcome

Use `supported`, `needs evidence`, or `not applicable (reason)` per substantive
issue. List the issue, its exact source/section, and next action. Do not mark a
source as read by the author or a result as reproduced on their behalf.
