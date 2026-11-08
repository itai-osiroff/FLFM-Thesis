"""Tk desktop wizard for selecting and replaying a displacement figure."""
import json
import os
from pathlib import Path
from queue import Empty, Queue
import re
from threading import Thread
import tkinter as tk
from tkinter import filedialog, messagebox, simpledialog, ttk
from uuid import uuid4

import numpy as np
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
from matplotlib.patches import Rectangle
from matplotlib.widgets import RectangleSelector

import displacement_figure as model
from displacement_panels import draw


class Wizard:
    def __init__(self, root):
        self.root = root
        self.path = self.recipe = self.data = self.metadata = self.preview = None
        self.busy = False
        self.frame = None
        root.title("Figure 5.3 · Displacement figure")
        root.geometry("1280x850")
        root.minsize(1000, 680)
        root.protocol("WM_DELETE_WINDOW", self.close)
        self.home()

    def close(self):
        if not self.busy:
            self.root.destroy()

    def page(self, title):
        if self.frame:
            self.frame.destroy()
        self.frame = ttk.Frame(self.root, padding=14)
        self.frame.pack(fill="both", expand=True)
        ttk.Label(self.frame, text=title, font=("Segoe UI", 17, "bold")).pack(anchor="w", pady=(0, 8))
        self.status = tk.StringVar()
        ttk.Label(self.frame, textvariable=self.status, wraplength=950).pack(side="bottom", anchor="w")
        return self.frame

    def buttons(self, parent, *actions):
        row = ttk.Frame(parent)
        row.pack(fill="x", pady=5)
        result = []
        for text, action in actions:
            button = ttk.Button(row, text=text, command=action)
            button.pack(side="left", padx=(0, 5))
            result.append(button)
        return result

    def home(self):
        page = self.page("Displacement figure")
        ttk.Label(page, text="Choose a saved reconstruction, or resume a figure from its local bundle.").pack(anchor="w")
        self.buttons(page, ("Legacy dense7 preset", lambda: self.choose_source(seed=True)),
                     ("Choose saved run…", self.choose_source), ("Open existing figure…", self.open))

    def choose_source(self, seed=False, replace=False):
        try:
            source = None
            if seed:
                source = json.loads(model.FIGURE_52.read_text(encoding="utf-8"))
                workspace = Path(source["run"]) / "workspace.npz"
                if not workspace.is_file():
                    workspace = workspace.with_suffix(".mat")
            else:
                chosen = filedialog.askopenfilename(
                    title="Choose a saved reconstruction workspace",
                    filetypes=[("Run workspaces", "*.npz *.mat")],
                )
                if not chosen:
                    return
                workspace = Path(chosen).resolve()
            path = self.path
            if not replace:
                suggestion = re.sub(r"[^A-Za-z0-9_-]+", "-", workspace.parent.name).strip("-_")
                name = simpledialog.askstring("New figure folder", "Figure folder name",
                                              initialvalue=f"displacements_{suggestion}")
                if name is None:
                    return
                if not re.fullmatch(r"[A-Za-z0-9_-]+", name):
                    raise ValueError("Use letters, numbers, hyphens or underscores for the folder name.")
                folder = model.FIGURE_ROOT / name
                if folder.exists():
                    raise ValueError("That figure folder already exists. Open it or choose a new name.")
                path = folder / "recipe.json"
        except (OSError, ValueError, KeyError) as exc:
            messagebox.showerror("Could not choose source", str(exc))
            return
        self.import_source(path, workspace, source)

    def import_source(self, path, workspace, seed):
        self.page("Reading saved run")
        self.status.set("Checking the stored fields against the refined views and saving a local bundle…")
        self.busy = True
        result = Queue()

        def worker():
            try:
                result.put((True, model.import_run(path, workspace, seed)))
            except Exception as exc:
                result.put((False, exc))

        def poll():
            try:
                ok, value = result.get_nowait()
            except Empty:
                self.root.after(80, poll)
                return
            self.busy = False
            if ok:
                self.path = path
                self.recipe, self.data, self.metadata = value
                self.preview = None
                self.review()
            else:
                messagebox.showerror("Could not import saved run", str(value))
                (self.compose if self.recipe is not None else self.home)()

        Thread(target=worker, daemon=True).start()
        self.root.after(80, poll)

    def open(self):
        folder = filedialog.askdirectory(title="Open figure folder", initialdir=model.FIGURE_ROOT)
        if folder:
            self.open_choices(Path(folder))

    def open_choices(self, folder):
        page = self.page("Open figure")
        ttk.Label(page, text=str(folder)).pack(anchor="w")
        for title, path in (("Open current draft", folder/"recipe.json"),
                            ("Restore selected settings…", folder/"selected"/"figure.recipe.json")):
            button, = self.buttons(page, (title, lambda p=path: self.resume(p)))
            if not path.is_file():
                button.configure(state="disabled")
        self.buttons(page, ("Back", self.home))
        ttk.Label(page, text="Restoring selected settings replaces the current draft.").pack(anchor="w")

    def resume(self, source):
        try:
            path = source.resolve()
            recipe = json.loads(path.read_text(encoding="utf-8"))
            data, metadata = model.load_bundle(path, recipe)
            model.display(data, recipe)
            if path.parent.name == "selected":
                draft = path.parent.parent/"recipe.json"
                recipe = model.snapshot_for(path, recipe, draft)
                for key in ("resolved_display", "run_provenance", "caption_draft", "renderer_version",
                            "matplotlib_version", "numpy_version", "pdf_sha256"):
                    recipe.pop(key, None)
                if draft.is_file() and not messagebox.askyesno(
                        "Restore selected settings", "Replace the current draft with the selected settings?"):
                    return
                model.save_json(draft, recipe)
                path = draft
        except (OSError, ValueError, KeyError, TypeError) as exc:
            messagebox.showerror("Could not reopen figure", str(exc))
            return
        self.path, self.recipe, self.data, self.metadata = path, recipe, data, metadata
        self.preview = None
        self.compose()

    def review(self):
        page = self.page("Review run and scene")
        n, _, h, w = self.metadata["grid_shape_ijyx"]
        ref = model.view_label(self.data["reference"])
        header = (f"{self.metadata['dataset']}   ·   {n} × {n} views, {w} × {h} px\n"
                  f"Global reference {ref}   ·   Local reference: global-stage average")
        ttk.Label(page, text=header).pack(anchor="w")
        fields = ttk.Frame(page)
        fields.pack(fill="x", pady=8)
        values = {}
        for row, (key, label) in enumerate(zip(model.SCENE_FIELDS,
                                               ("Specimen", "Medium", "Acquisition date", "Reason for this example"))):
            ttk.Label(fields, text=label).grid(row=row, column=0, sticky="w", padx=(0, 10))
            value = tk.StringVar(value=self.recipe["scene"].get(key) or "")
            ttk.Entry(fields, textvariable=value).grid(row=row, column=1, sticky="ew", pady=2)
            values[key] = value
        fields.columnconfigure(1, weight=1)

        def proceed():
            updated = dict(self.recipe, scene={k: v.get().strip() or None for k,v in values.items()})
            if self.save(updated):
                self.compose()

        self.buttons(page, ("Save and compose", proceed),
                     ("Change source run…", lambda: self.choose_source(replace=True)))
        details = ttk.Frame(page)
        details.pack(fill="both", expand=True)
        box = tk.Text(details, height=15, wrap="word")
        scroll = ttk.Scrollbar(details, command=box.yview)
        scroll.pack(side="right", fill="y")
        box.configure(yscrollcommand=scroll.set)
        box.pack(fill="both", expand=True)
        record = {k: self.metadata[k] for k in ("run_name", "generation_id", "algorithm_commit",
                                               "workspace", "effective_config")}
        box.insert("1.0", json.dumps(record, indent=2).replace(": null", ': "unknown"'))
        box.configure(state="disabled")
        self.status.set("Blank scene fields are recorded as unknown.")

    def save(self, updated):
        try:
            model.save_json(self.path, updated)
        except OSError as exc:
            self.status.set(str(exc))
            return False
        if updated != self.recipe:
            self.preview = None
        self.recipe = updated
        return True

    def compose(self):
        page = self.page("Compose and preview")
        self.buttons(page, ("Run details and scene…", self.review),
                     ("Change source run…", lambda: self.choose_source(replace=True)),
                     ("Open selected PDF", lambda: self.open_file(self.path.parent/"selected"/"figure.pdf")))
        ttk.Label(page, text="Click a lattice cell for the active view. Drag on the aligned image to crop. Click to place the sample.").pack(anchor="w")
        controls = ttk.Frame(page)
        controls.pack(fill="x", pady=6)
        target = tk.StringVar(value="First view")
        ttk.Combobox(controls, textvariable=target, values=("First view", "Second view"),
                     state="readonly", width=12).pack(side="left", padx=(0, 8))
        crop_key, sample_key = "crop_xyxy_zero_based_half_open", "sample_yx_zero_based"
        spacing_key, limit_key = "arrow_spacing_px", "manual_local_limit_px"
        values = {}
        for key, title, width in ((crop_key, "Crop xyxy (0-based)", 19), (sample_key, "Sample yx (0-based)", 10),
                                  (spacing_key, "Arrow spacing (px)", 5), (limit_key, "Color max (auto/px)", 7)):
            ttk.Label(controls, text=title).pack(side="left", padx=(0, 3))
            value = tk.StringVar()
            ttk.Entry(controls, textvariable=value, width=width).pack(side="left", padx=(0, 8))
            values[key] = value

        panels = ttk.Panedwindow(page, orient="horizontal")
        panels.pack(fill="both", expand=True)
        guide_frame, preview_frame = ttk.Frame(panels), ttk.Frame(panels)
        panels.add(guide_frame, weight=2)
        panels.add(preview_frame, weight=3)
        guide = Figure(figsize=(4,4), layout="constrained")
        preview_figure = Figure(figsize=(6.4,4), layout="constrained")
        ax = guide.add_subplot()
        first = tuple(self.recipe["views_ij_zero_based"][0])
        image_artist = ax.imshow(self.data["aligned"][first], cmap="gray", interpolation="nearest")
        outline = Rectangle((0, 0), 1, 1, fill=False, edgecolor="orange")
        ax.add_patch(outline)
        sample_marker = ax.scatter([], [], marker="+", c="orange")
        guide_canvas = FigureCanvasTkAgg(guide, master=guide_frame)
        preview_canvas = FigureCanvasTkAgg(preview_figure, master=preview_frame)
        for canvas in (guide_canvas, preview_canvas):
            canvas.get_tk_widget().pack(fill="both", expand=True)
        lattice = None
        syncing = False
        start_at = None

        def sync():
            nonlocal syncing
            syncing = True
            for key,value in values.items():
                raw = self.recipe[key]
                value.set(", ".join(map(str, raw)) if isinstance(raw, list) else
                          "auto" if raw is None else str(raw))
            syncing = False
            selected.configure(state="normal" if self.preview else "disabled")
            open_preview.configure(state="normal" if self.preview else "disabled")

        def redraw():
            nonlocal lattice
            resolved = model.display(self.data, self.recipe)
            lattice = draw(preview_figure, self.data, self.recipe, resolved)
            first = tuple(self.recipe["views_ij_zero_based"][0])
            image = self.data["aligned"][first]
            image_artist.set_data(image)
            image_artist.set_clim(float(image.min()), float(image.max()))
            x0,y0,x1,y1 = self.recipe[crop_key]
            outline.set_bounds(x0-.5, y0-.5, x1-x0, y1-y0)
            y,x = self.recipe[sample_key]
            sample_marker.set_offsets([[x,y]])
            ax.set_title(f"Aligned view {model.view_label(first)}")
            guide_canvas.draw_idle()
            preview_canvas.draw_idle()
            sync()
            self.status.set("Colors clip " + str(resolved["clipped_pixels"]) + " pixels." if
                            resolved["clipped_pixels"] else "The local maps share one color scale.")

        def edit(updates, adjust_sample=False):
            recipe = dict(self.recipe, **updates)
            try:
                if adjust_sample:
                    try:
                        model.display(self.data, recipe)
                    except ValueError:
                        first = tuple(recipe["views_ij_zero_based"][0])
                        recipe[sample_key] = model.default_sample(self.data["fields"][first], recipe[crop_key])
                model.display(self.data, recipe)
            except (ValueError, TypeError) as exc:
                self.status.set(str(exc))
                return False
            if not self.save(recipe):
                return False
            redraw()
            return True

        def apply():
            try:
                updates = {
                    key: [int(v) for v in values[key].get().replace(",", " ").split()]
                    for key in (crop_key, sample_key)
                }
                updates[spacing_key] = int(values[spacing_key].get())
                limit = values[limit_key].get().strip()
                updates[limit_key] = None if limit.lower() in ("", "auto") else float(limit)
            except ValueError:
                self.status.set("Enter integer crop, sample, and arrow spacing values. Use auto or a number for the color limit.")
                return False
            return edit(updates, adjust_sample=updates[sample_key] == self.recipe[sample_key])

        def choose_view(event):
            if event.inaxes is not lattice or event.button != 1 or event.xdata is None:
                return
            n = self.data["shifts"].shape[0]
            ij = [round(event.xdata), round(event.ydata)]
            if any(not 0 <= index < n for index in ij):
                return
            idx = 0 if target.get() == "First view" else 1
            views = list(self.recipe["views_ij_zero_based"])
            views[idx] = ij
            edit({"views_ij_zero_based": views}, adjust_sample=idx == 0)

        def crop(start, end):
            if any(event.xdata is None or event.ydata is None for event in (start,end)):
                return
            h,w = self.data["aligned"].shape[-2:]
            xs = sorted((start.xdata,end.xdata))
            ys = sorted((start.ydata,end.ydata))
            edit({crop_key: [max(0,round(xs[0])), max(0,round(ys[0])),
                             min(w,round(xs[1])+1), min(h,round(ys[1])+1)]}, adjust_sample=True)

        def press(event):
            nonlocal start_at
            start_at = (event.x,event.y) if event.inaxes is ax and event.button == 1 else None

        def release(event):
            nonlocal start_at
            clicked = start_at is not None and abs(event.x-start_at[0])+abs(event.y-start_at[1]) < 5
            start_at = None
            if clicked and event.inaxes is ax and event.xdata is not None:
                edit({sample_key: [round(event.ydata), round(event.xdata)]})

        def generate():
            if not apply():
                return
            output = self.path.parent/"previews"/uuid4().hex/"figure.pdf"
            try:
                model.render(self.path, self.recipe, output, self.data, self.metadata)
            except (OSError, ValueError, KeyError) as exc:
                messagebox.showerror("Could not generate preview", str(exc))
                return
            self.preview = output
            sync()
            self.status.set("Preview ready. Open the PDF to review it, then use this figure.")

        def use():
            try:
                output = model.select_export(self.preview, self.path.parent)
            except (OSError, ValueError, KeyError) as exc:
                messagebox.showerror("Could not select preview", str(exc))
                return
            self.status.set(f"Selected figure saved to {output}")

        def dirty(*_):
            if not syncing:
                self.preview = None
                selected.configure(state="disabled")
                open_preview.configure(state="disabled")

        _, _, open_preview, selected = self.buttons(
            page, ("Apply values", apply), ("Generate PDF preview", generate),
            ("Open preview", lambda: self.open_file(self.preview)), ("Use this figure", use))
        for value in values.values():
            value.trace_add("write", dirty)
        preview_canvas.mpl_connect("button_press_event", choose_view)
        guide_canvas.mpl_connect("button_press_event", press)
        guide_canvas.mpl_connect("button_release_event", release)
        guide_canvas.selector = RectangleSelector(ax, crop, button=[1], minspanx=6, minspany=6,
                                                 spancoords="pixels")
        redraw()

    def open_file(self, path):
        if not path or not path.is_file():
            self.status.set("This PDF has not been generated yet.")
            return
        try:
            os.startfile(path)
        except OSError as exc:
            messagebox.showerror("Could not open PDF", str(exc))


def launch(recipe=None):
    root = tk.Tk()
    wizard = Wizard(root)
    if recipe is not None:
        root.after_idle(lambda: wizard.resume(recipe))
    root.mainloop()

