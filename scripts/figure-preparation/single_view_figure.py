"""Prepare, crop and render the Chapter 5 single-view comparison."""
import argparse
from dataclasses import asdict
import hashlib
import json
import os
from pathlib import Path
from uuid import uuid4

import numpy as np


def digest(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def save_json(path, data):
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")
    temporary.replace(path)


def source_spec(recipe):
    keys = ("scene", "capture", "run", "original_views") if recipe.get("source_version") == 2 else (
        "scene", "capture", "geometry", "settings")
    return {key: recipe.get(key) for key in keys}

def five_images(bundle, view):
    original, aligned, refined = (bundle[k] for k in ("original", "aligned", "refined"))
    reference = tuple(bundle["reference_index"].tolist())
    average = bundle["global_average"]
    if (original.ndim != 4 or original.shape[0] != original.shape[1]
            or aligned.shape != original.shape or refined.shape != original.shape
            or average.shape != original.shape[2:]):
        raise ValueError("Expected matching (N,N,H,W) stacks and an (H,W) average.")
    for index in (view, reference):
        if len(index) != 2 or any(type(i) is not int or not 0 <= i < original.shape[0] for i in index):
            raise ValueError("View indices must be zero-based [row, column] within the grid.")
    if tuple(view) == reference:
        raise ValueError("Select a noncentral view.")
    index = tuple(view)
    images = (original[reference], original[index], aligned[index], average, refined[index])
    if not all(np.isfinite(a).all() for a in images):
        raise ValueError("The selected images contain non-finite intensities.")
    return images, original.shape[0], reference


def bounds(crop, shape):
    h, w = shape
    if crop is None:
        return 0, 0, w, h
    if len(crop) == 4 and all(type(i) is int for i in crop):
        x0, y0, x1, y1 = crop
        if 0 <= x0 < x1 <= w and 0 <= y0 < y1 <= h:
            return x0, y0, x1, y1
    raise ValueError(f"Invalid crop {crop!r} for image width {w}, height {h}.")


def display_limits(recipe, images):
    limits = recipe["display_limits"]
    if limits is None:
        positive = np.concatenate([a[a > 0] for a in images])
        if not positive.size:
            raise ValueError("No positive intensities for automatic display scaling.")
        limits = [0.0, float(np.percentile(positive, 99.9))]
    if len(limits) != 2 or not np.isfinite(limits).all() or limits[0] >= limits[1]:
        raise ValueError("display_limits must contain two increasing finite values.")
    return limits


def prepare(path, recipe, data_root=None, *, confirmed=False, allow_extract=False, progress=print):
    from single_view_import import import_products

    def resolve(key):
        value = Path(recipe[key])
        return ((data_root or path.parent) / value).resolve()

    capture = resolve("capture")
    run = resolve("run")
    if not capture.is_file():
        raise ValueError(f"Capture is unavailable: {capture}")
    original = resolve("original_views") if recipe.get("original_views") else None
    progress("Reading saved run products…")
    arrays, metadata, artifacts = import_products(capture, run, original, confirmed, allow_extract)
    ref = tuple(arrays["reference_index"].tolist())
    view = [ref[0], ref[1] - 1 if ref[1] else 1]
    draft = dict(recipe, source_version=2, view=view, crop=None, display_limits=None)
    images, _, _ = five_images(arrays, view)
    draft["display_limits"] = display_limits(draft, images)
    run_id = uuid4().hex
    metadata.update(run_id=run_id, source=source_spec(draft), archive_run=str(run),
                    capture_path=str(capture), capture_sha256=digest(capture),
                    artifacts={str(item): digest(item) for item in artifacts})
    if recipe.get('figure_kind') == 'alignment_evolution':
        from alignment_evolution import initialize_new
        initialize_new(draft, arrays, metadata)
    folder = path.parent / "generations" / run_id
    progress("Saving figure bundle…")
    folder.mkdir(parents=True)
    bundle = folder / "run.npz"
    np.savez_compressed(bundle, **arrays, metadata=json.dumps(metadata))
    draft.update(run_bundle=bundle.relative_to(path.parent).as_posix(),
                 run_id=run_id, bundle_sha256=digest(bundle))
    save_json(path, draft)
    recipe.update(draft)
    return arrays, metadata

def load_bundle(path, recipe):
    if recipe.get('figure_kind') == 'alignment_evolution':
        from alignment_evolution import load_bundle as load_combined
        return load_combined(path, recipe)
    bundle = path.parent / recipe["run_bundle"]
    if digest(bundle) != recipe["bundle_sha256"]:
        raise ValueError("Bundle hash differs from the recipe. Check the selected run.")
    with np.load(bundle, allow_pickle=False) as arrays:
        metadata = json.loads(arrays["metadata"].item())
        if metadata["run_id"] != recipe["run_id"] or metadata["source"] != source_spec(recipe):
            raise ValueError("Bundle identity or reconstruction settings differ from the recipe.")
        bundle = {key: arrays[key] for key in (
            "original", "aligned", "refined", "global_average", "reference_index"
        )} | ({"final_average": arrays["final_average"]} if "final_average" in arrays else {})
    return bundle, metadata


def load_run(path, recipe):
    bundle, metadata = load_bundle(path, recipe)
    images, size, reference = five_images(bundle, recipe["view"])
    return images, size, reference, metadata


def panels(images, crop, limits):
    x0, y0, x1, y1 = bounds(crop, images[0].shape)
    lo, hi = limits
    center, raw, aligned, average, refined = (
        np.clip((a[y0:y1, x0:x1] - lo) / (hi - lo), 0, 1) for a in images
    )
    blue = np.array([0., .4, 1.])
    orange = 1 - blue

    def overlay(target, moving):
        return target[..., None] * blue + moving[..., None] * orange

    return (center, overlay(center, raw), overlay(center, aligned),
            average, overlay(average, aligned), overlay(average, refined))


def draw(figure, images, crop, limits, size, reference, view):
    from matplotlib.patches import Patch

    figure.clear()
    grid = figure.add_gridspec(2, 3, left=.15, right=.98, top=.90, bottom=.19,
                              wspace=.055, hspace=.08)
    titles = ("Reference", "Before", "After")
    for i, panel in enumerate(panels(images, crop, limits)):
        ax = figure.add_subplot(grid[i // 3, i % 3])
        ax.imshow(panel, cmap="gray", vmin=0, vmax=1, interpolation="nearest")
        ax.set_axis_off()
        if i < 3:
            ax.set_title(titles[i], fontsize=9, pad=4)
        if i in (0, 3):
            ax.text(-.06, .5, "Global\nalignment" if i == 0 else "Local\nrefinement",
                    transform=ax.transAxes, ha="right", va="center", fontsize=8)
    locator = figure.add_axes([.16, .022, .09, .13])
    rows, cols = np.indices((size, size))
    locator.scatter(cols, rows, s=2, c=".65")
    locator.scatter(reference[1], reference[0], s=14, c=[(0., .4, 1.)])
    locator.scatter(view[1], view[0], s=14, c=[(1., .6, 0.)])
    locator.set(xlim=(-.6, size-.4), ylim=(size-.4, -.6), aspect="equal")
    locator.set_axis_off()
    figure.text(.25, .08, f"View ({view[0]+1}, {view[1]+1})", fontsize=8, va="center")
    figure.legend(handles=[Patch(color=(0., .4, 1.), label="Reference"),
                           Patch(color=(1., .6, 0.), label="Selected view")],
                  loc="center right", bbox_to_anchor=(.98, .08), ncols=2,
                  fontsize=8, frameon=False)


def crop_editor(path, recipe, images, limits, size, reference):
    import matplotlib
    matplotlib.use("TkAgg")
    import matplotlib.pyplot as plt
    from matplotlib.widgets import RectangleSelector

    view = recipe["view"]
    selection = recipe["crop"]
    h, w = images[0].shape
    guide, ax = plt.subplots(num="Crop guide")
    ax.imshow(images[2], cmap="gray", vmin=limits[0], vmax=limits[1],
              extent=(0, w, h, 0), interpolation="nearest")
    ax.set_title("Drag to crop ֲ· Enter saves ֲ· Close discards")
    preview = plt.figure("Shared crop preview", figsize=(7, 5))
    draw(preview, images, selection, limits, size, reference, view)

    def selected(start, end):
        nonlocal selection
        left, right = sorted((start.xdata, end.xdata))
        top, bottom = sorted((start.ydata, end.ydata))
        selection = [max(0, int(np.floor(left))), max(0, int(np.floor(top))),
                     min(w, int(np.ceil(right))), min(h, int(np.ceil(bottom)))]
        draw(preview, images, selection, limits, size, reference, view)
        preview.canvas.draw_idle()

    selector = RectangleSelector(ax, selected, button=[1], minspanx=1, minspany=1)
    if selection is not None:
        x0, y0, x1, y1 = bounds(selection, (h, w))
        selector.extents = (x0, x1, y0, y1)
        selector.set_visible(True)

    def key(event):
        if event.key == "enter":
            recipe.update(crop=selection, display_limits=limits)
            save_json(path, recipe)
            plt.close(preview)
            plt.close(guide)

    guide.canvas.mpl_connect("key_press_event", key)
    guide.canvas.mpl_connect("close_event", lambda event: plt.close(preview))
    plt.show()


def render_pdf(path, recipe, out, images, size, reference, metadata):
    from matplotlib.figure import Figure

    crop = bounds(recipe["crop"], images[0].shape)
    limits = display_limits(recipe, images)
    w, h = crop[2]-crop[0], crop[3]-crop[1]
    figure = Figure(figsize=(6, 1.05 + 3.25 * h/w))
    draw(figure, images, recipe["crop"], limits, size, reference, recipe["view"])
    out.parent.mkdir(parents=True, exist_ok=True)
    figure.savefig(out, metadata={"CreationDate": None, "ModDate": None})
    snapshot = dict(recipe, display_limits=limits, run_provenance=metadata,
                    run_bundle=Path(os.path.relpath(path.parent / recipe["run_bundle"], out.parent)).as_posix())
    save_json(out.with_suffix(".recipe.json"), snapshot)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=("setup", "prepare", "crop", "render", "migrate", "select", "upgrade"))
    parser.add_argument("recipe", type=Path, nargs="?")
    parser.add_argument("--data-root", type=Path)
    parser.add_argument("--confirm-capture", action="store_true")
    parser.add_argument("--extract-original", action="store_true")
    parser.add_argument("--output", type=Path)
    parser.add_argument('--figure-name')
    parser.add_argument('--workspace', type=Path)
    parser.add_argument('--figure-dir', type=Path)
    parser.add_argument('--use-current-renderer', action='store_true')
    args = parser.parse_args()
    if args.command == "setup":
        from single_view_setup import launch

        launch(args.data_root, args.recipe)
        return
    if args.recipe is None:
        parser.error(f"{args.command} requires a recipe path")
    path = args.recipe.resolve()
    try:
        if args.command == 'migrate':
            from alignment_evolution import migrate
            if not args.figure_name: parser.error('migrate requires --figure-name')
            print(migrate(path, args.figure_name, args.workspace)); return
        if args.command == 'upgrade':
            from alignment_evolution import upgrade_layout
            print(upgrade_layout(path)); return
        if args.command == 'select':
            from alignment_evolution import select_export
            if not args.figure_dir: parser.error('select requires --figure-dir')
            print(select_export(path,args.figure_dir)); return
        recipe = json.loads(path.read_text(encoding="utf-8"))
        if args.command == "prepare":
            prepare(path, recipe, args.data_root, confirmed=args.confirm_capture,
                    allow_extract=args.extract_original)
            return
        if recipe.get('figure_kind') == 'alignment_evolution':
            if args.command == 'crop':
                from single_view_setup import launch
                launch(args.data_root,path); return
            from alignment_evolution import render
            print(render(path,recipe,args.output,args.use_current_renderer)); return
        images, size, reference, metadata = load_run(path, recipe)
        limits = display_limits(recipe, images)
        if args.command == "crop":
            crop_editor(path, recipe, images, limits, size, reference)
            return

        out = (args.output or path.parent / "generations" / recipe["run_id"] / "preview.pdf").resolve()
        render_pdf(path, recipe, out, images, size, reference, metadata)
        print(out)
    except (ValueError, OSError, KeyError, TypeError) as exc:
        parser.exit(1, f"{exc}\n")


if __name__ == "__main__":
    main()
