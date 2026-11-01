# Capture Editor Trio Workspace Export Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a trio-compatible `workspace.mat` to capture-editor exports when edited global and local averages originate from one MAT workspace.

**Architecture:** Preserve the current individual role exports. In the export helper, detect a shared source MAT workspace, collect its `config_json` if present, and stage one combined workspace with the edited global/local arrays under trio's required variable names. Verify it by loading the staged MAT and comparing the values before publishing; add the result to the existing capture manifest.

**Tech Stack:** MATLAB R2025b, MAT-file `save`/`load`, existing `captureedit.exportImages` pipeline, JSON manifest.

**Spec:** [2026-11-01-capture-editor-trio-workspace-design.md](../specs/2026-11-01-capture-editor-trio-workspace-design.md)

## Global Constraints

- Emit a combined workspace only when both MAT roles are selected and share the same source workspace path.
- The combined workspace must contain `average_rectified_global_image`, `average_rectified_image`, and `config_json`.
- Use source `config_json` if present; if absent, store `{}` and record that absence in the capture manifest.
- Verify exact array and configuration round-trip before publishing the export directory.
- Keep individual exports, display TIFF behavior, and native-resolution export unchanged.
- Do not create or imply an experiment manifest or bake comparison geometry into exported pixels.

## Review Focus

- Only one reconstruction role is selected: no combined workspace is emitted.
- Global and local roles came from separate workspaces: do not merge their run identity.
- A shared MAT lacks `config_json`: the combined file remains readable and export provenance states it was missing.
- Both roles have different filters or numeric classes: each edited array is stored without conversion.
- Existing individual native exports and optional TIFF derivatives retain their current contents.

## Files and responsibilities

- Modify `scripts/capture-editor/+captureedit/exportImages.m` to construct, verify, and manifest the combined workspace.
- Modify `scripts/capture-editor/README.md` to describe the additional trio-ready output and its shared-source condition.

## Task 1: Add and document a trio-ready shared workspace

**Files:**
- Modify: `scripts/capture-editor/+captureedit/exportImages.m`
- Modify: `scripts/capture-editor/README.md`

**Interfaces:**
- Consumes: existing `sources`, `stacks`, `roles`, and staged per-role exports in `captureedit.exportImages`.
- Produces: an optional `workspace.mat` at the export root plus a manifest record identifying its path and source metadata.

- [x] Detect whether `global` and `local` are both selected, both MAT sources, and have the same canonical `source.path`.
- [x] For that case, build `workspace.mat` in the existing staging directory from the already-evaluated edited arrays, with exact variable names `average_rectified_global_image` and `average_rectified_image`.
- [x] Load `config_json` from the shared source workspace when present; otherwise store `'{}'`. Include a manifest record that identifies the combined workspace, source path/hash, and whether source configuration was available.
- [x] Read the staged workspace back and verify both arrays with `isequaln` and the same `class`, and verify `config_json` exactly, before publishing. Raise `captureedit:ExportVerification` on any mismatch.
- [x] Update the capture-editor README to explain that exports from one shared MAT workspace include a combined trio-compatible `workspace.mat`; separate-source and single-role exports remain individual MAT files.
- [x] Review the resulting diff and confirm individual files, optional display TIFFs, geometry handling, and publication staging are unchanged.

## Verification constraint

Do not add or run tests for this task. The exporter performs a read-back check on
the combined MAT file before publishing it; report that implementation check
separately from automated test coverage.
