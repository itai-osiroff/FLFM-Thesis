"""Desktop workflow for preparing and selecting a single-view figure."""
import json
import os
from pathlib import Path
from queue import Empty, Queue
import re
import shutil
from tempfile import TemporaryDirectory
from threading import Thread
import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog, ttk
from uuid import uuid4

from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
from matplotlib.figure import Figure
from matplotlib.patches import Rectangle
from matplotlib.widgets import RectangleSelector
import numpy as np
from single_view_import import MissingOriginal, UnverifiedCapture, acquisition_root, candidates

from single_view_figure import (
    bounds, digest, display_limits, draw, five_images, load_bundle, prepare,
    render_pdf, save_json,
)


TOOL_DIR = Path(__file__).resolve().parent
FIGURE_ROOT = TOOL_DIR.parents[1] / "candidate-outputs" / "figures-source"


def select_export(preview, folder):
    """Stage a complete selection before replacing the previous one."""
    selected = folder / "selected"
    snapshot = json.loads(preview.with_suffix(".recipe.json").read_text(encoding="utf-8"))
    if snapshot.get('figure_kind') == 'alignment_evolution':
        from alignment_evolution import select_export as select_combined
        return select_combined(preview,folder)
    bundle = (preview.parent / snapshot["run_bundle"]).resolve()
    snapshot["run_bundle"] = Path(os.path.relpath(bundle, selected)).as_posix()
    with TemporaryDirectory(dir=folder) as temporary:
        temp = Path(temporary)
        staged = temp / "new"
        staged.mkdir()
        pdf = staged / "figure.pdf"
        shutil.copyfile(preview, pdf)
        save_json(staged / "figure.recipe.json", snapshot)
        save_json(staged / "provenance.json", {
            "run": snapshot["run_provenance"],
            "bundle_sha256": snapshot["bundle_sha256"],
            "pdf_sha256": digest(pdf),
            "view": snapshot["view"],
            "crop": snapshot["crop"],
            "display_limits": snapshot["display_limits"],
        })
        # Keep the backup outside the temporary tree so it survives a failed rollback.
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


class Wizard:
    def __init__(self, root, data_root):
        self.root = root
        self.default_data_root = data_root
        self.path = None
        self.recipe = None
        self.bundle = None
        self.preview = None
        self.busy = False
        self.events = Queue()
        self.status = tk.StringVar()
        self.frame = None
        root.title("Single-view figure setup")
        root.geometry("1190x810")
        root.minsize(840, 620)
        root.protocol("WM_DELETE_WINDOW", self.close)
        self.home()

    def close(self):
        if self.busy:
            messagebox.showinfo("Reconstruction in progress", "Wait for the current run to finish.")
        else:
            self.root.destroy()

    def page(self, title):
        if self.frame is not None:
            self.frame.destroy()
        self.frame = ttk.Frame(self.root, padding=12)
        self.frame.pack(fill="both", expand=True)
        ttk.Label(self.frame, text=title, font=("Segoe UI", 16, "bold")).pack(anchor="w")
        ttk.Label(self.frame, textvariable=self.status, wraplength=780).pack(side="bottom", anchor="w")
        self.status.set("")
        return self.frame

    def home(self):
        frame = self.page("Single-view figure")
        ttk.Button(frame, text="Choose a capture…", command=self.new).pack(anchor="w", pady=10)
        ttk.Button(frame, text="Open existing figure…", command=self.open).pack(anchor="w")
        ttk.Button(frame, text='Create combined figure…', command=self.migrate_combined).pack(anchor='w',pady=10)

    def migrate_combined(self):
        source=filedialog.askopenfilename(title='Choose an existing single-view recipe',filetypes=[('Recipe','*.json')],initialdir=FIGURE_ROOT)
        if not source: return
        name=simpledialog.askstring('Combined figure','New figure folder name',initialvalue='alignment_evolution')
        if not name: return
        try:
            from alignment_evolution import migrate
            self.resume(migrate(Path(source),name))
        except (OSError,ValueError,KeyError) as exc: messagebox.showerror('Migration failed',str(exc))

    def choose_capture(self):
        filename = filedialog.askopenfilename(
            title="Choose the main FLFM capture", initialdir=str(self.default_data_root or Path.cwd()), filetypes=[("Images", "*.tif *.tiff *.png"), ("All files", "*")]
        )
        return Path(filename).resolve() if filename else None

    def new(self):
        capture = self.choose_capture()
        if capture is None:
            return
        suggestion = re.sub(r"[^A-Za-z0-9_-]+", "-", capture.stem).strip("-_") or "single-view"
        name = simpledialog.askstring("Figure name", "Name for the figure folder", initialvalue=suggestion)
        if name is None:
            return
        if not re.fullmatch(r"[A-Za-z0-9_-]+", name):
            messagebox.showerror("Figure name", "Use letters, numbers, hyphens or underscores.")
            return
        folder = FIGURE_ROOT / name
        if folder.exists():
            messagebox.showerror("Figure name", "That figure folder already exists.")
            return
        self.choose_run(capture, folder / "recipe.json", {})

    def open(self):
        folder = filedialog.askdirectory(title="Open existing figure folder", initialdir=FIGURE_ROOT)
        if folder:
            self.resume(Path(folder) / "recipe.json")

    def resume(self, path):
        try:
            recipe = json.loads(path.read_text(encoding="utf-8"))
        except (OSError, ValueError) as exc:
            messagebox.showerror("Open figure", f"Could not open the figure's saved settings.\n{exc}")
            return
        self.path, self.recipe = path.resolve(), recipe
        if recipe.get('figure_kind') == 'alignment_evolution' and (path.parent.name == 'selected' or path.parent.parent.name == 'previews'):
            origin=path.resolve()
            root=origin.parent.parent if origin.parent.name=='selected' else origin.parent.parent.parent
            recipe['run_bundle']=str((origin.parent/recipe['run_bundle']).resolve())
            if recipe.get('renderer_snapshot'): recipe['renderer_snapshot']=str((origin.parent/recipe['renderer_snapshot']).resolve())
            recipe.pop('resolved_display',None)
            self.path=root/'recipe.json'
            save_json(self.path,recipe)
        self.bundle = self.preview = None
        if recipe.get("run_bundle"):
            try:
                self.bundle, self.metadata = load_bundle(self.path, recipe)
                self.review()
                return
            except (OSError, ValueError, KeyError, TypeError):
                self.bundle = None
                messagebox.showwarning("Saved reconstruction unavailable",
                                       "The saved reconstruction could not be verified. "
                                       "Attach the existing algorithm run to recover the figure.")
                self.recipe.update(run_bundle=None, run_id=None, bundle_sha256=None)
        self.home()
        frame = self.frame
        ttk.Button(frame, text="Attach saved run…", command=self.change_run).pack(anchor="w", pady=10)

    def checkpoint(self):
        save_json(self.path, self.recipe)

    def change_run(self):
        capture = self.choose_capture()
        if capture:
            self.choose_run(capture, self.path, self.recipe)

    def choose_run(self, capture, path, recipe):
        frame = self.page("Choose a saved run")
        ttk.Label(frame, text=str(capture), wraplength=1100).pack(anchor="w")
        runs = candidates(capture)
        choices = tk.Listbox(frame, height=10, width=135)
        choices.pack(fill="both", expand=True, pady=10)
        for run in runs:
            choices.insert("end", f"{run.parent.name} / {run.name}    {run}")
        self.status.set("Select a matching run or browse to its workspace folder.")

        def start(run):
            draft = {**recipe, "scene": capture.stem, "capture": str(capture),
                     "run": str(run), "original_views": None}
            if not recipe or recipe.get('figure_kind') == 'alignment_evolution':
                draft['figure_kind']='alignment_evolution'
                for key in ('resolved_display','renderer_snapshot','renderer_sha256','parent_recipe','preview_id','parent_preview_id'):
                    draft.pop(key,None)
            self.start_import(path, draft)

        def selected():
            if choices.curselection():
                start(runs[choices.curselection()[0]])

        def browse():
            folder = filedialog.askdirectory(title="Choose the folder containing workspace.npz or workspace.mat",
                                             initialdir=acquisition_root(capture))
            if folder:
                start(Path(folder))

        ttk.Button(frame, text="Review selected run", command=selected).pack(anchor="w")
        ttk.Button(frame, text="Browse for run…", command=browse).pack(anchor="w")
        ttk.Button(frame, text="Back", command=self.review if self.bundle is not None else self.home).pack(anchor="w")

    def canvas(self, figure, frame, toolbar=False):
        canvas = FigureCanvasTkAgg(figure, master=frame)
        if toolbar:
            NavigationToolbar2Tk(canvas, frame)
        canvas.get_tk_widget().pack(fill="both", expand=True)
        return canvas

    def start_import(self, path, draft, confirmed=False):
        self.page("Importing saved run")
        self.status.set("Reading saved run products…")
        self.busy = True

        def worker():
            try:
                arrays, metadata = prepare(path, draft, confirmed=confirmed,
                                           allow_extract=True,
                                           progress=lambda msg: self.events.put(("progress", msg)))
                self.events.put(("success", (arrays, metadata)))
            except Exception as exc:
                self.events.put(("error", exc))

        def poll():
            try:
                kind, value = self.events.get_nowait()
            except Empty:
                self.root.after(80, poll)
                return
            if kind == "progress":
                self.status.set(value)
                self.root.after(0, poll)
                return
            self.busy = False
            if kind == "success":
                self.path, self.recipe = path, draft
                self.bundle, self.metadata = value
                self.run_review(self.review)
                return
            if isinstance(value, UnverifiedCapture) and messagebox.askyesno(
                    "Confirm capture", f"{value}\n\nIs this the capture used by the selected run?"):
                self.start_import(path, draft, confirmed=True)
                return
            if isinstance(value, MissingOriginal):
                self.status.set(str(value))
                messagebox.showinfo("Original views needed", str(value))
                stack = filedialog.askopenfilename(title="Locate saved original views",
                                                   filetypes=[("NumPy stack", "*.npy")])
                if stack:
                    self.start_import(path, dict(draft, original_views=stack), confirmed=confirmed)
                    return
            else:
                messagebox.showerror("Could not import run", str(value))
            self.choose_run(Path(draft["capture"]), path, draft)

        Thread(target=worker, daemon=True).start()
        self.root.after(80, poll)

    def run_review(self, back):
        frame = self.page("Review saved run")
        ttk.Button(frame, text="Continue to figure", command=back).pack(anchor="w")
        figure = Figure(figsize=(8, 3), layout="constrained")
        axes = figure.subplots(1, 2)
        global_avg = self.bundle["global_average"]
        final = self.bundle.get("final_average")
        averages = (global_avg,) if final is None else (global_avg, final)
        lo = min(float(a.min()) for a in averages)
        hi = max(float(a.max()) for a in averages)
        for ax, title, image in zip(axes, ("Global-stage average", "Final rectified average"),
                                    (global_avg, final)):
            ax.set_title(title)
            ax.set_axis_off()
            if image is None:
                ax.text(.5, .5, "Unavailable in this saved figure", ha="center", va="center")
            else:
                ax.imshow(image, cmap="gray", vmin=lo, vmax=hi)
        self.canvas(figure, frame)
        details = ttk.Frame(frame)
        details.pack(fill="both", expand=True)
        box = tk.Text(details, height=14, wrap="word")
        scrollbar = ttk.Scrollbar(details, command=box.yview)
        scrollbar.pack(side="right", fill="y")
        box.configure(yscrollcommand=scrollbar.set)
        box.pack(fill="both", expand=True)
        keys = ("archive_run", "run_name", "generation_id", "algo_commit", "geometry",
                "geometry_sources", "effective_config", "config_sources", "dataset_entries",
                "original_source", "original_mode", "capture_verified")
        info = {key: self.metadata.get(key) for key in keys}
        box.insert("1.0", json.dumps(info, indent=2).replace(": null", ': "Unknown"'))
        box.configure(state="disabled")

    def review(self):
        if self.recipe.get('figure_kind') == 'alignment_evolution':
            from alignment_evolution_setup import compose
            compose(self); return
        frame = self.page("3   Review and export")
        ttk.Label(frame, text="Choose a noncentral view from the mosaic. Drag on the aligned view to crop all six panels.").pack(anchor="w")
        controls = ttk.Frame(frame)
        controls.pack(fill="x", pady=6)
        review = ttk.Frame(frame)
        review.pack(fill="both", expand=True)
        guide_frame = ttk.Frame(review)
        guide_frame.pack(side="left", fill="both", expand=True)
        figure_frame = ttk.Frame(review)
        figure_frame.pack(side="left", fill="both", expand=True)
        guide = Figure(figsize=(4, 6), layout="constrained")
        mosaic, crop_ax = guide.subplots(2, 1)
        guide_canvas = self.canvas(guide, guide_frame)
        figure = Figure(figsize=(6, 5))
        preview_canvas = self.canvas(figure, figure_frame)
        original = self.bundle["original"]
        size, _, h, w = original.shape
        reference = tuple(self.bundle["reference_index"].tolist())
        stride = max(1, max(h, w) // 30)
        small = original[:, :, ::stride, ::stride]
        atlas = small.transpose(1, 2, 0, 3).reshape(size*small.shape[2], size*small.shape[3])
        mosaic.imshow(atlas, cmap="gray", interpolation="nearest",
                      extent=(-.5, size-.5, size-.5, -.5))
        mosaic.set_title("Original views (click to select)")
        mosaic.set_axis_off()
        mosaic.add_patch(Rectangle((reference[0]-.5, reference[1]-.5), 1, 1,
                                   fill=False, edgecolor="deepskyblue", linewidth=2))
        highlight = Rectangle((0, 0), 1, 1, fill=False, edgecolor="orange", linewidth=2)
        mosaic.add_patch(highlight)
        images, _, _ = five_images(self.bundle, self.recipe["view"])
        limits = display_limits(self.recipe, images)
        aligned = crop_ax.imshow(images[2], cmap="gray", extent=(0,w,h,0),
                                 vmin=limits[0], vmax=limits[1], interpolation="nearest")
        crop_ax.set_title("Aligned view (drag to crop)")
        crop_ax.set_axis_off()
        self.preview = None

        def redraw():
            nonlocal images, limits
            images, _, _ = five_images(self.bundle, self.recipe["view"])
            limits = display_limits(self.recipe, images)
            highlight.set_xy((self.recipe["view"][0]-.5, self.recipe["view"][1]-.5))
            aligned.set_data(images[2])
            aligned.set_clim(*limits)
            draw(figure, images, self.recipe["crop"], limits, size, reference, self.recipe["view"])
            guide_canvas.draw_idle()
            preview_canvas.draw_idle()

        def edit(**updates):
            self.recipe.update(updates)
            self.checkpoint()
            self.preview = None
            select.configure(state="disabled")
            self.status.set("Edits saved. Generate a PDF when the figure is ready.")
            redraw()

        def change_view(event):
            if event.inaxes is mosaic and event.button == 1:
                index = (round(event.xdata), round(event.ydata))
                if index != reference and all(0 <= v < size for v in index):
                    edit(view=list(index))

        def crop_selected(start, end):
            xs = sorted((start.xdata, end.xdata))
            ys = sorted((start.ydata, end.ydata))
            selection = [max(0, int(np.floor(xs[0]))), max(0, int(np.floor(ys[0]))),
                         min(w, int(np.ceil(xs[1]))), min(h, int(np.ceil(ys[1])))]
            bounds(selection, (h,w))
            edit(crop=selection, display_limits=limits)

        selector = RectangleSelector(crop_ax, crop_selected, button=[1], minspanx=1, minspany=1)
        if self.recipe["crop"] is not None:
            x0,y0,x1,y1 = bounds(self.recipe["crop"], (h,w))
            selector.extents = (x0,x1,y0,y1)
            selector.set_visible(True)

        def reset_crop():
            selector.clear()
            edit(crop=None)

        def generate():
            self.preview = None
            select.configure(state="disabled")
            output = self.path.parent / "previews" / uuid4().hex / "figure.pdf"
            try:
                self.recipe["display_limits"] = limits
                self.checkpoint()
                render_pdf(self.path, self.recipe, output, images, size, reference, self.metadata)
                self.preview = output
                select.configure(state="normal")
                self.status.set("Preview generated. Open it to review the PDF, then use this figure.")
            except Exception as exc:
                messagebox.showerror("Could not generate preview", str(exc))

        def use():
            try:
                pdf = select_export(self.preview, self.path.parent)
                self.status.set(f"Selected figure saved to {pdf}")
                open_pdf.configure(state="normal")
            except (ValueError, OSError, KeyError) as exc:
                messagebox.showerror("Could not select figure", str(exc))

        def open_file(path):
            try:
                os.startfile(path)
            except OSError as exc:
                messagebox.showerror("Could not open", str(exc))

        def button(label, callback):
            widget = ttk.Button(controls, text=label, command=callback)
            widget.pack(side="left", padx=(0, 5))
            return widget

        button("Run details…", lambda: self.run_review(self.review))
        button("Change source run…", self.change_run)
        button("Reset crop", reset_crop)
        button("Auto display range", lambda: edit(display_limits=None))
        button("Generate preview", generate)
        button("Open preview", lambda: open_file(self.preview) if self.preview else
               messagebox.showinfo("Preview", "Generate a preview first."))
        select = button("Use this figure", use)
        select.configure(state="disabled")
        selected_pdf = self.path.parent / "selected" / "figure.pdf"
        open_pdf = button("Open PDF", lambda: open_file(selected_pdf))
        open_pdf.configure(state="normal" if selected_pdf.is_file() else "disabled")
        button("Show folder", lambda: open_file(self.path.parent))
        guide_canvas.mpl_connect("button_press_event", change_view)
        # Matplotlib stores weak references to widget callbacks.
        guide_canvas.crop_selector = selector
        redraw()


def launch(data_root=None, recipe_path=None):
    root = tk.Tk()
    wizard = Wizard(root, data_root)
    if recipe_path is not None:
        root.after_idle(lambda: wizard.resume(recipe_path))
    root.mainloop()
