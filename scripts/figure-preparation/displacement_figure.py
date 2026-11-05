"""Prepare and reproduce the Chapter 5 displacement figure from saved runs."""
import argparse
import json
import os
from pathlib import Path
import re
import shutil
from tempfile import TemporaryDirectory
from uuid import uuid4

import numpy as np

from single_view_figure import bounds, digest, save_json
from single_view_import import read_workspace, scalar

REQUIRED_PRODUCTS = (
    "global_rectified_views", "average_rectified_global_image", "average_rectified_image",
    "reference_view_index", "global_rectification_matrix",
    "pixel_displacements_x", "pixel_displacements_y",
)
ROOT = Path(__file__).resolve().parents[2]
FIGURE_ROOT = ROOT / "candidate-outputs" / "figures-source"
FIGURE_52 = FIGURE_ROOT / "single_view_dense7_17_6" / "selected" / "figure.recipe.json"
RENDERER_VERSION = 1
SCENE_FIELDS = ("specimen", "medium", "acquisition_date", "selection_reason")


def read_run(path, expected_hash=None):
    import cv2

    workspace_hash = digest(path)
    if expected_hash and workspace_hash != expected_hash:
        raise ValueError("The workspace hash differs from the Figure 5.2 selection.")
    raw = read_workspace(path, (*REQUIRED_PRODUCTS, "pixel_rectified_views", "rectification_strategy"))
    missing = [key for key in REQUIRED_PRODUCTS if key not in raw]
    refined = raw.get("pixel_rectified_views", raw.get("rectified_views"))
    if refined is None:
        missing.append("pixel_rectified_views or rectified_views")
    if missing:
        raise ValueError("Missing saved products: " + ", ".join(missing))
    aligned = raw["global_rectified_views"]
    if aligned.ndim != 4 or aligned.shape[0] != aligned.shape[1] or min(aligned.shape) < 1:
        raise ValueError("Invalid aligned stack shape. Expected (N,N,H,W).")
    n, _, h, w = aligned.shape
    matrix = raw["global_rectification_matrix"]
    ref = raw["reference_view_index"].ravel()
    if n < 2 or ref.shape != (2,) or ref.dtype.kind not in "iu" or tuple(ref) != (n//2, n//2):
        raise ValueError("Invalid reference shape or index. Expected the central view.")
    if matrix.shape != (n,n,n,n,2) or refined.shape != aligned.shape:
        raise ValueError("Global translation matrix or refined stack has an incompatible shape.")
    dx, dy = (raw[f"pixel_displacements_{axis}"] for axis in ("x", "y"))
    if dx.shape != (h,w,n,n) or dy.shape != dx.shape:
        raise ValueError("Local displacement shape must be (H,W,N,N).")
    fields = np.stack((dy, dx), axis=-1).transpose(2,3,0,1,4).copy()
    data = {
        "shifts": matrix[tuple(ref)], "fields": fields, "reference": ref,
        "aligned": aligned, "global_average": raw["average_rectified_global_image"],
        "final_average": raw["average_rectified_image"],
    }
    if any(data[key].shape != (h,w) for key in ("global_average", "final_average")):
        raise ValueError("Saved average has an incompatible shape.")
    for key, value in {**data, "refined": refined}.items():
        if value.dtype.kind not in "iuf" or not np.isfinite(value).all():
            raise ValueError(f"Invalid numeric values in {key}.")
    if not np.all(data["shifts"][tuple(ref)] == 0):
        raise ValueError("The central view must have a zero global translation.")

    config, config_sources = {}, {}
    artifact_hashes = {str(path): workspace_hash}
    embedded = scalar(raw, "config_json")
    settings = [(path, json.loads(embedded) if embedded else {})]
    metrics = {}
    for name in ("config.json", "metric_record.json"):
        file = path.with_name(name)
        if file.is_file():
            record = json.loads(file.read_text(encoding="utf-8-sig"))
            if not isinstance(record, dict):
                raise ValueError(f"Invalid metadata in {name}.")
            artifact_hashes[str(file)] = digest(file)
            if name == "metric_record.json":
                metrics = record
                record = record.get("config", {})
            settings.append((file, record))
    for file, record in settings:
        if not isinstance(record, dict):
            raise ValueError(f"Invalid reconstruction settings in {file.name}.")
        for key, value in record.items():
            if key in config and config[key] != value:
                raise ValueError(f"Conflicting reconstruction setting: {key}.")
            config[key], config_sources[key] = value, str(file)
    strategy = scalar(raw, "rectification_strategy")
    strategy = {"1": "global", "2": "pixel", "3": "combined"}.get(strategy, strategy)
    mode = config.get("combined_reference_mode")
    legacy = config.get("combined_use_global_avg_reference")
    if (config.get("strategy", strategy) != "combined" or strategy not in (None, "combined")
            or not (mode == "global_average" or (mode is None and legacy is True)) or legacy is False):
        raise ValueError("Choose a saved combined run using the global average as its local reference.")
    yy, xx = np.indices((h,w), dtype=np.float32)
    for ij in np.ndindex(n,n):
        field = fields[ij]
        remapped = cv2.remap(aligned[ij].astype(np.float64),
                             (xx-field[...,1]).astype(np.float32),
                             (yy-field[...,0]).astype(np.float32),
                             cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
        if not np.allclose(remapped, refined[ij], rtol=1e-6, atol=1e-6):
            raise ValueError(f"Saved local fields do not reproduce view {view_label(ij)}.")
    if digest(path) != workspace_hash:
        raise ValueError("The workspace changed during import. Try again after the run finishes.")
    run_name = scalar(raw, "run_name") or metrics.get("run") or path.parent.name
    metadata = {
        "dataset": path.parent.name, "run_name": run_name,
        "generation_id": metrics.get("generation_id"), "run_signature": metrics.get("run_signature"),
        "algorithm_commit": config.get("algo_commit") or metrics.get("algo_commit"),
        "workspace": str(path), "source_hashes": artifact_hashes,
        "effective_config": config, "config_sources": config_sources,
        "local_reference": "global_average", "grid_shape_ijyx": list(aligned.shape),
    }
    return data, metadata


def view_label(ij):
    return f"({ij[0]+1},{ij[1]+1})"


def index_pair(value, shape, label):
    if (not isinstance(value, (list, tuple)) or len(value) != 2
            or any(type(v) is not int or not 0 <= v < size for v, size in zip(value, shape))):
        raise ValueError(f"Invalid {label} coordinates.")
    return tuple(value)


def default_sample(field, crop):
    h, w = field.shape[:2]
    x0,y0,x1,y1 = bounds(crop, (h,w))
    yy, xx = np.mgrid[y0:y1,x0:x1]
    patch = field[y0:y1,x0:x1]
    sy, sx = yy-patch[...,0], xx-patch[...,1]
    valid = (sy >= 0) & (sy <= h-1) & (sx >= 0) & (sx <= w-1)
    preferred = valid & np.any(patch != 0, axis=-1)
    if not valid.any():
        raise ValueError("The crop has no pixel with an in-frame source location.")
    distance = (yy-(y0+y1-1)/2)**2 + (xx-(x0+x1-1)/2)**2
    closest = np.argmin(np.where(preferred if preferred.any() else valid, distance, np.inf))
    return [int(yy.flat[closest]), int(xx.flat[closest])]


def defaults(data, featured=None, dense7=False):
    n, _, h, w, _ = data["fields"].shape
    reference = tuple(data["reference"])
    ordered = [(i,j) for j in range(n) for i in range(n) if (i,j) != reference]
    first = index_pair(featured, (n,n), "view") if featured is not None else ordered[0]
    second = next(ij for ij in ordered if ij != first)
    crop = [0,0,w,h]
    if dense7:
        first, second = (2,5), (4,1)
        crop = [113,157,176,222]
    sample = [186,142] if dense7 else default_sample(data["fields"][first], crop)
    return dict(schema_version=1, views_ij_zero_based=[list(first), list(second)],
                crop_xyxy_zero_based_half_open=crop, sample_yx_zero_based=sample,
                arrow_spacing_px=8 if dense7 else max(1, round(max(h,w)/12)),
                manual_local_limit_px=None, scene=dict.fromkeys(SCENE_FIELDS))


def display(data, recipe):
    n, _, h, w, _ = data["fields"].shape
    views = recipe["views_ij_zero_based"]
    if not isinstance(views, list) or len(views) != 2:
        raise ValueError("Choose two distinct views.")
    first, second = (index_pair(ij, (n,n), "view") for ij in views)
    if first == second:
        raise ValueError("Choose two distinct views.")
    crop = recipe["crop_xyxy_zero_based_half_open"]
    if not isinstance(crop, list):
        raise ValueError("Enter four crop bounds.")
    x0,y0,x1,y1 = bounds(crop, (h,w))
    y,x = index_pair(recipe["sample_yx_zero_based"], (h,w), "sample")
    if not (x0 <= x < x1 and y0 <= y < y1):
        raise ValueError("Choose a sample pixel inside the crop.")
    source = np.array([y,x]) - data["fields"][first][y,x]
    if not (0 <= source[0] <= h-1 and 0 <= source[1] <= w-1):
        raise ValueError("The sample's read location falls outside the aligned view.")
    spacing = recipe["arrow_spacing_px"]
    if type(spacing) is not int or spacing < 1:
        raise ValueError("Arrow spacing must be a positive integer.")
    magnitudes = [np.linalg.norm(data["fields"][ij][y0:y1,x0:x1], axis=-1) for ij in (first,second)]
    maximum = max(float(m.max()) for m in magnitudes)
    limit = recipe["manual_local_limit_px"]
    if limit is None:
        limit = maximum or 1.0
    if not isinstance(limit, (int, float)) or isinstance(limit, bool) or not np.isfinite(limit) or limit <= 0:
        raise ValueError("The local color limit must be positive and finite.")
    return dict(source_yx=source.tolist(), local_limit=limit, local_maximum=maximum,
                clipped_pixels=sum(int(np.count_nonzero(m > limit)) for m in magnitudes),
                global_maximum=float(np.linalg.norm(data["shifts"],axis=-1).max()))


def import_run(path, workspace, seed=None):
    metadata52 = seed["run_provenance"] if seed is not None else {}
    expected = metadata52.get("artifacts", {}).get(str(workspace))
    if seed is not None and not expected:
        raise ValueError("The Figure 5.2 recipe has no recorded hash for this workspace.")
    data, metadata = read_run(workspace, expected)
    featured = seed["view"] if seed is not None else None
    dense7 = metadata["dataset"] == "beads_2um_dense7_eyedrop_680us" and featured == [2,5]
    recipe = defaults(data, featured, dense7)
    if dense7:
        recipe["scene"].update(specimen="Fluorescent beads", medium="Gel eyedrops", acquisition_date="2026-06-17")
    if seed is not None:
        metadata["figure_52_source"] = {key: metadata52.get(key) for key in
                                       ("capture_path", "capture_sha256", "capture_verified", "run_id")}
    display(data, recipe)
    bundle = path.parent / "generations" / uuid4().hex / "run.npz"
    bundle.parent.mkdir(parents=True)
    np.savez_compressed(bundle, **data, metadata=json.dumps(metadata))
    recipe.update(run_bundle=bundle.relative_to(path.parent).as_posix(), bundle_sha256=digest(bundle))
    save_json(path, recipe)
    return recipe, data, metadata


def load_bundle(path, recipe):
    if recipe.get("schema_version") != 1:
        raise ValueError("Unsupported displacement recipe version.")
    bundle = path.parent / recipe["run_bundle"]
    if digest(bundle) != recipe["bundle_sha256"]:
        raise ValueError("Bundle hash differs from the recipe.")
    with np.load(bundle, allow_pickle=False) as items:
        return {k: items[k] for k in items.files if k != "metadata"}, json.loads(items["metadata"].item())


def caption(recipe, metadata, resolved):
    scene = recipe["scene"]
    first, second = map(view_label, recipe["views_ij_zero_based"])
    specimen, medium, date = (scene.get(key) or "unknown" for key in SCENE_FIELDS[:3])
    limit = f"Local colors span 0–{resolved['local_limit']:.3g} image pixels."
    if resolved["clipped_pixels"]:
        limit += f" Colors saturate above this limit ({resolved['clipped_pixels']} pixels across the two crops)."
    return (
        f"Global translations and local displacements for {metadata['dataset']} "
        f"(specimen: {specimen}, medium: {medium}, acquisition date: {date}). "
        "(A) Each retained sub-aperture view corresponds to a region of the conjugate pupil. "
        "Arrows give global translations relative to the original central view, marked with a dot. "
        f"(B) Views {first} and {second} are shown over a shared crop. Colors give the magnitude "
        "of the additional displacement estimated against the global-stage average. "
        f"Sparse arrows show the stored correction. {limit} "
        f"(C) The marked output pixel in view {first} reads intensity at p − d(p) in the globally aligned view. "
        "Arrow keys are in image pixels."
    )


def snapshot_for(path, recipe, output):
    snapshot = dict(recipe)
    snapshot["run_bundle"] = Path(os.path.relpath(path.parent / recipe["run_bundle"], output.parent)).as_posix()
    return snapshot


def render(path, recipe, output, data=None, metadata=None):
    import matplotlib
    from matplotlib.figure import Figure
    from displacement_panels import draw

    if data is None:
        data, metadata = load_bundle(path, recipe)
    resolved = display(data, recipe)
    if "resolved_display" in recipe and resolved != recipe["resolved_display"]:
        raise ValueError("Saved display settings disagree with the bundle and recipe.")
    if recipe.get("renderer_version", RENDERER_VERSION) != RENDERER_VERSION:
        raise ValueError("This recipe requires a different displacement renderer version.")
    figure = Figure(figsize=(6.4,4.0), layout="constrained")
    draw(figure, data, recipe, resolved)
    output.parent.mkdir(parents=True, exist_ok=True)
    figure.savefig(output, metadata={"CreationDate": None, "ModDate": None})
    snapshot = snapshot_for(path, recipe, output)
    snapshot.update(resolved_display=resolved, run_provenance=metadata,
                    caption_draft=caption(recipe, metadata, resolved), renderer_version=RENDERER_VERSION,
                    matplotlib_version=matplotlib.__version__, numpy_version=np.__version__,
                    pdf_sha256=digest(output))
    save_json(output.with_suffix(".recipe.json"), snapshot)
    return snapshot


def select_export(preview, folder):
    selected = folder / "selected"
    recipe = json.loads(preview.with_suffix(".recipe.json").read_text(encoding="utf-8"))
    if recipe["pdf_sha256"] != digest(preview):
        raise ValueError("Preview PDF hash differs from its recipe.")
    load_bundle(preview, recipe)
    snapshot = snapshot_for(preview, recipe, selected / "figure.pdf")
    with TemporaryDirectory(dir=folder) as staging:
        staged = Path(staging) / "new"
        staged.mkdir()
        shutil.copyfile(preview, staged / "figure.pdf")
        save_json(staged / "figure.recipe.json", snapshot)
        save_json(staged / "provenance.json", snapshot)
        backup = folder / f".selected-backup-{uuid4().hex}"
        if selected.exists():
            selected.rename(backup)
        try:
            staged.rename(selected)
        except OSError:
            if backup.exists():
                backup.rename(selected)
            raise
        if backup.exists():
            shutil.rmtree(backup, ignore_errors=True)
    return selected / "figure.pdf"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("setup", "render"))
    parser.add_argument("recipe", type=Path, nargs="?")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.command == "setup":
        from displacement_setup import launch
        launch(args.recipe)
        return
    if not args.recipe or not args.output or args.output.suffix.lower() != ".pdf":
        parser.error("render requires RECIPE --output PDF")
    output = args.output.resolve()
    if output.exists() or output.with_suffix(".recipe.json").exists():
        parser.error("Choose a new output path to preserve existing exports.")
    try:
        recipe = json.loads(args.recipe.read_text(encoding="utf-8"))
        render(args.recipe.resolve(), recipe, output)
    except (OSError, ValueError, KeyError, TypeError, ImportError) as exc:
        parser.exit(1, f"{exc}\n")
    print(output)


if __name__ == "__main__":
    main()

