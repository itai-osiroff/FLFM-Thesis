# Versioned trio figures implementation plan

Goal: retain every generation, automatically compile a self-contained figure-only
preview, and explicitly select thesis-facing exports independently of latest.

Approved design: figure roots contain a tracked index and working recipe, local
generation history (assets, metadata, snapshot LaTeX, PDF and build diagnostics),
and an explicitly selected portable export. Legacy generations retain original
files and provenance; no historical generation date or scientific approval is
inferred. MATLAB setup/replay remain entry points and accept v2/v3 recipes.

## Tasks

- [x] Add generation lifecycle, locking, index, provenance and compiler helpers,
  with tests for retained history, failure isolation and paths containing spaces.
- [x] Integrate setup/replay; add preview-only derivation and explicit selection.
  Test raw-data-free preview, deterministic assets, comparison gates and selection.
- [x] Add repeatable, hash-verified legacy import, run migration and update links,
  ignore rules, compatibility runner and user documentation.
- [x] Run MATLAB integration suite, dense4 replay and visual PDF checks; review
  implementation and resolve important findings.

## Execution decisions

- Work in the existing checkout on a feature branch: the approved migration
  includes untracked local bundles and the uncommitted overlap change.
- Keep a root working recipe for convenient editing and existing command usage;
  each generation contains an immutable exact snapshot.
- Legacy imports are explicitly exempted from the history ignore rule so moving
  existing tracked evidence cannot silently remove it from version control.
- Incomplete attempts return a status and diagnostics; input preflight errors
  retain their existing error identifiers and create no generation.
- No commit, push, or thesis-template changes are part of implementation.
- Review fixes: verify parent inventories before preview derivation, treat README
  as a disposable view after committing the authoritative index, register attempts
  before processing, and link historical comparison approval to recipe/image hashes.
- Legacy JSON recipe hashes may match only after CRLF-to-LF normalization from
  historical Git checkouts. Accept that exact transformation only and record the
  match mode; do not accept arbitrary recipe differences.

## Verification

- Final MATLAB suite: 35 passed, 0 failed, 0 incomplete, including exact dense4
  replay, deterministic images, comparison rejection, compiler failures, locked
  writers, retained interrupted attempts, selection interruption, README failure,
  saved-template/current-template behavior, tamper rejection and repeatable import.
- Four bundles migrated with no automatic selection; 164 artifact hashes verified.
- Four tightly cropped previews rendered and visually inspected; 3% overlap retained.
- All legacy artifacts remain trackable, including preserved original compiler
  metadata. New histories and verification artifacts are ignored by default.
- Independent review findings resolved and re-reviewed; no important residual findings.
- `git diff --check` passed. Work remains uncommitted on `codex/versioned-trio-figures`.
