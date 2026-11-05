"""Read archived rectification products without importing the rectifier."""
import json
from pathlib import Path, PureWindowsPath

import numpy as np
from PIL import Image


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.is_file() else {}


def acquisition_root(capture):
    main = next((p for p in capture.parents if p.name.casefold() == "main"), None)
    return main.parent if main else capture.parent.parent


def candidates(capture):
    root = acquisition_root(capture) / "algo_run"
    return sorted({p.parent for pattern in ("workspace.npz", "workspace.mat")
                   for p in root.rglob(pattern)
                   if p.parent.name.casefold() == capture.stem.casefold()})


def read_workspace(path, extra_keys=()):
    keys = ("global_rectified_views", "rectified_views", "average_rectified_global_image",
            "average_rectified_image", "reference_view_index", "original_views",
            "config_json", "run_name", "global_rectification_matrix") + tuple(extra_keys)
    if path.suffix == ".npz":
        with np.load(path, allow_pickle=False) as data:
            return {k: data[k] for k in keys if k in data}
    try:
        from scipy.io import loadmat
    except ImportError as exc:
        raise ValueError("Install SciPy to import MATLAB workspaces.") from exc
    try:
        return loadmat(path, variable_names=keys)
    except NotImplementedError as exc:
        raise ValueError(f"{path} is a MATLAB v7.3 workspace. Select a run workspace "
                         "with the saved aligned and refined view stacks in NPZ or classic MAT format.") from exc


def scalar(data, key):
    return str(np.asarray(data[key]).item()) if key in data else None


def extract_original(capture, geometry, shape):
    cx, cy = geometry["center_x"], geometry["center_y"]
    count, width = geometry["view_grid_size"], geometry["view_distance"]
    if not all(type(v) is int for v in (cx, cy, count, width)) or (
            count, count, width, width) != shape:
        raise ValueError("Recorded extraction geometry does not match the saved view stacks.")
    with Image.open(capture) as image:
        sensor = np.asarray(image)
    if sensor.ndim != 2:
        raise ValueError("Extraction requires a single grayscale capture.")
    views = np.empty(shape, dtype=np.float64)
    half = width // 2
    for i in range(count):
        for j in range(count):
            x = cx + (i - count // 2) * width
            y = cy + (j - count // 2) * width
            if min(x - half, y - half) < 0 or x + half >= sensor.shape[1] or y + half >= sensor.shape[0]:
                raise ValueError("Recorded extraction geometry extends outside the capture.")
            views[i, j] = sensor[y-half:y-half+width, x-half:x-half+width]
    return views


def recover_original(capture, arrays, matrix, geometry):
    """Locate the unchanged reference patch and verify the grid against saved shifts."""
    aligned = arrays["aligned"]
    count, _, height, width = aligned.shape
    ref = tuple(arrays["reference_index"])
    if (height != width or matrix is None or matrix.shape != (count, count, count, count, 2)
            or matrix.dtype.kind not in "iuf"):
        raise ValueError("The workspace lacks a compatible saved global shift matrix.")
    shifts = matrix[ref]
    if (not np.isfinite(shifts).all() or np.any(shifts != np.trunc(shifts))
            or np.any(np.abs(shifts) >= width)):
        raise ValueError("The saved shifts cannot verify an integer patch grid.")
    with Image.open(capture) as image:
        sensor = np.asarray(image)
    template = aligned[ref]
    if (sensor.ndim != 2 or min(sensor.shape) < width or not np.isfinite(template).all()
            or template.min() == template.max()):
        raise ValueError("The saved reference patch cannot identify a location in the capture.")

    y, x = np.unravel_index(np.argmax(template), template.shape)
    ys, xs = np.nonzero(sensor[y:sensor.shape[0]-height+y+1,
                               x:sensor.shape[1]-width+x+1] == template[y, x])
    # Filter the candidates with the lowest-valued pixel before comparing full patches.
    y, x = np.unravel_index(np.argmin(template), template.shape)
    valid = sensor[ys + y, xs + x] == template[y, x]
    match = None
    for top, left in zip(ys[valid], xs[valid]):
        if not np.array_equal(sensor[top:top+height, left:left+width], template):
            continue
        origin_x = int(left + width // 2 + (count // 2 - ref[0]) * width)
        origin_y = int(top + height // 2 + (count // 2 - ref[1]) * height)
        if any(geometry.get(k) not in (None, v) for k, v in
               (("center_x", origin_x), ("center_y", origin_y))):
            continue
        recovered = dict(center_x=origin_x, center_y=origin_y,
                         view_grid_size=count, view_distance=width)
        try:
            original = extract_original(capture, recovered, aligned.shape)
        except ValueError:
            continue
        for i, j in np.ndindex(count, count):
            dy, dx = (0, 0) if (i, j) == ref else map(int, shifts[i, j])
            y0, y1 = max(0, dy), min(height, height + dy)
            x0, x1 = max(0, dx), min(width, width + dx)
            expected = np.zeros_like(template)
            expected[y0:y1, x0:x1] = original[i, j, y0-dy:y1-dy, x0-dx:x1-dx]
            if not np.array_equal(expected, aligned[i, j]):
                break
        else:
            if match is not None:
                raise ValueError("More than one capture location matches the saved view grid.")
            match = original, recovered
    if match is None:
        raise ValueError("No capture location reproduces every saved globally aligned view.")
    return match


def import_products(capture, run, original_path=None, confirmed=False, allow_extract=False):
    workspace = run / "workspace.npz"
    if not workspace.is_file():
        workspace = run / "workspace.mat"
    if not workspace.is_file():
        raise ValueError(f"No workspace.npz or workspace.mat in {run}")
    data = read_workspace(workspace)
    fields = dict(aligned="global_rectified_views", refined="rectified_views",
                  global_average="average_rectified_global_image",
                  final_average="average_rectified_image", reference_index="reference_view_index")
    for key in fields.values():
        if key not in data:
            raise ValueError(f"{workspace} is missing {key}.")
    arrays = {k: data[v] for k, v in fields.items()}
    shape = arrays["aligned"].shape
    if (len(shape) != 4 or min(shape) < 1 or shape[0] != shape[1] or shape[0] < 2
            or arrays["refined"].shape != shape
            or any(arrays[k].shape != shape[2:] for k in ("global_average", "final_average"))):
        raise ValueError("Saved view stacks and averages have incompatible shapes.")
    ref = arrays["reference_index"].ravel()
    if ref.shape != (2,) or ref.dtype.kind not in "iu" or np.any(ref < 0) or np.any(ref >= shape[0]):
        raise ValueError("Invalid saved reference view index.")
    arrays["reference_index"] = ref
    config_path = run / "config.json"
    metric_path = run / "metric_record.json"
    metrics = read_json(metric_path)
    embedded = scalar(data, "config_json")
    configs = [(str(workspace), json.loads(embedded))] if embedded is not None else []
    if config_path.is_file():
        configs.append((str(config_path), read_json(config_path)))
    if isinstance(metrics.get("config"), dict):
        configs.append((str(metric_path), metrics["config"]))
    config = {}
    sources = {}
    for source, values in configs:
        if not isinstance(values, dict):
            raise ValueError(f"Invalid effective configuration in {source}")
        for k, v in values.items():
            if k in config and config[k] != v:
                raise ValueError(f"Conflicting setting {k} in {sources[k]} and {source}")
            config[k], sources[k] = v, source
    if config.get("strategy", "combined") != "combined":
        raise ValueError("Select a combined global and local run.")
    if config.get("combined_reference_mode") not in (None, "global_average"):
        raise ValueError("The six-panel figure requires a run using the global average as its local reference.")
    dataset = run.name
    if dataset.casefold() != capture.stem.casefold():
        raise ValueError(f"Run dataset {dataset} does not match capture {capture.stem}.")
    archive = next((p for p in (run, *run.parents)
                    if (p / "experiment_manifest.json").is_file() or
                    (p / "sweep_spec.json").is_file() or (p / "datasets").is_dir()), run)
    metadata_paths = [archive / n for n in ("sweep_spec.json", "experiment_manifest.json")]
    spec, manifest = (read_json(p) for p in metadata_paths)
    entries = {}
    geometry = {}
    entry_sources = {}
    for path, metadata in zip(metadata_paths, (spec, manifest)):
        matches = [item for item in metadata.get("datasets", [])
                   if item.get("id", item.get("dataset_id")) == dataset]
        if len(matches) > 1:
            raise ValueError(f"Duplicate dataset {dataset} in {path}")
        if matches:
            entries[str(path)] = matches[0]
            for k, v in matches[0].items():
                if k in geometry and geometry[k] != v and k in {
                        "source_image", "center_x", "center_y", "view_radius", "view_grid_size",
                        "view_distance", "hdr_enabled", "normalize_to_8bit", "hdr_exposure_times"}:
                    raise ValueError(f"Conflicting dataset field {k} in {entry_sources[k]} and {path}")
                geometry[k], entry_sources[k] = v, str(path)
    for k in ("hdr_enabled", "normalize_to_8bit", "hdr_exposure_times"):
        if k in config and k in geometry and config[k] != geometry[k]:
            raise ValueError(f"Conflicting {k} in {sources[k]} and {entry_sources[k]}")
    verified = False
    if geometry.get("source_image"):
        recorded = PureWindowsPath(geometry["source_image"])
        if recorded.name.casefold() != capture.name.casefold():
            raise ValueError(f"Recorded capture {recorded} disagrees with {capture}.")
        recorded_path = Path(geometry["source_image"])
        if not recorded_path.is_absolute():
            recorded_path = acquisition_root(capture) / recorded_path
        if recorded_path.is_file() and recorded_path.resolve() != capture.resolve():
            raise ValueError(f"The run points to a different capture: {recorded_path}")
        verified = recorded_path.resolve() == capture.resolve()
    if not verified and not confirmed:
        raise UnverifiedCapture("The dataset name matches, but its recorded capture path could not be verified.")
    if manifest.get("generation_id") and metrics.get("generation_id") and (
            manifest["generation_id"] != metrics["generation_id"]):
        raise ValueError(f"Conflicting generation IDs in {metric_path} and {metadata_paths[1]}")
    for key, expected in (("view_grid_size", shape[0]), ("view_distance", shape[-1])):
        if geometry.get(key) is not None and geometry[key] != expected:
            raise ValueError(f"Recorded {key} in {entry_sources[key]} disagrees with {workspace}.")
    artifacts = [workspace, config_path, metric_path, *metadata_paths]
    if original_path is None and "original_views" not in data:
        saved = archive / "datasets" / dataset / "generated_views.npy"
        if saved.is_file():
            original_path = saved
        elif geometry.get("resolved_views_path"):
            recorded = Path(geometry["resolved_views_path"])
            if (recorded.is_file() and recorded.parent.name == dataset
                    and recorded.name == "generated_views.npy"):
                original_path = recorded
    original_mode = "loaded"
    if original_path is not None:
        arrays["original"] = np.load(original_path, allow_pickle=False)
        artifacts.append(original_path)
        original_source = str(original_path)
    elif "original_views" in data:
        arrays["original"] = data["original_views"]
        original_source = str(workspace)
    else:
        # The saved tile dimensions record the effective spacing for this sweep
        # extractor, whose tile width equals its center-to-center spacing.
        extraction = dict(geometry)
        if extraction.get("view_distance") is None:
            extraction["view_distance"] = shape[-1]
        supported = (geometry.get("hdr_enabled", config.get("hdr_enabled")) is False
                     and geometry.get("normalize_to_8bit", config.get("normalize_to_8bit")) is False
                     and not geometry.get("source_image_dir"))
        recorded = supported and verified and all(type(geometry.get(k)) is int for k in
                                                  ("center_x", "center_y", "view_radius", "view_grid_size"))
        matrix = data.get("global_rectification_matrix")
        recoverable = supported and matrix is not None
        if not (recorded or recoverable) or not allow_extract:
            raise MissingOriginal(recorded or recoverable)
        try:
            if recorded:
                arrays["original"] = extract_original(capture, extraction, shape)
                original_mode = "extracted"
            else:
                arrays["original"], recovered = recover_original(capture, arrays, matrix, geometry)
                for key in ("center_x", "center_y"):
                    if geometry.get(key) is None:
                        geometry[key] = recovered[key]
                        entry_sources[key] = f"Verified against {workspace} and {capture}"
                original_mode = "recovered"
        except (OSError, ValueError) as exc:
            raise MissingOriginal(False, str(exc)) from exc
        original_source = str(capture)
    if arrays["original"].shape != shape:
        raise ValueError("The original view stack does not match the saved view dimensions.")
    for k, array in arrays.items():
        if array.dtype.kind not in "buif" or not np.isfinite(array).all():
            raise ValueError(f"Invalid numeric data in {k}.")
    return arrays, dict(effective_config=config, config_sources=sources, dataset_entries=entries,
                        run_name=scalar(data, "run_name") or metrics.get("run"),
                        generation_id=metrics.get("generation_id") or manifest.get("generation_id"),
                        run_signature=metrics.get("run_signature"),
                        algo_commit=config.get("algo_commit") or metrics.get("algo_commit")
                        or manifest.get("algo_commit"), capture_verified=verified,
                        original_source=original_source,
                        original_mode=original_mode,
                        geometry=dict(center_x=geometry.get("center_x"), center_y=geometry.get("center_y"),
                                      view_radius=geometry.get("view_radius"), view_grid_size=shape[0],
                                      view_distance=shape[-1]),
                        geometry_sources=entry_sources), [p for p in artifacts if p.is_file()]


class UnverifiedCapture(ValueError):
    pass


class MissingOriginal(ValueError):
    def __init__(self, can_extract, reason=None):
        self.can_extract = can_extract
        if can_extract:
            message = "The saved original view stack is missing. Enable extraction with --extract-original."
        else:
            detail = reason or "The capture and saved metadata cannot establish the original patches."
            message = f"The saved original view stack is missing. {detail} Locate the matching NumPy stack."
        super().__init__(message)
