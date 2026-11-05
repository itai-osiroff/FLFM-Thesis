"""Draw the two coordinate grids and the local sampling example."""
import numpy as np
from matplotlib.patches import Rectangle

from displacement_figure import view_label

ACCENTS = ("#ad4825", "#176d89")


def arrows(ax, x, y, vectors, **kwargs):
    return ax.quiver(x, y, vectors[...,1], vectors[...,0], angles="xy",
                     scale_units="xy", pivot="middle", **kwargs)


def draw(figure, data, recipe, resolved):
    figure.clear()
    grid = figure.add_gridspec(2, 3, width_ratios=(1.18,1,1), height_ratios=(1, .69))
    lattice = figure.add_subplot(grid[:,0])
    maps = [figure.add_subplot(grid[0,k]) for k in (1,2)]
    inset = figure.add_subplot(grid[1,1:])
    n = data["shifts"].shape[0]
    i, j = np.indices((n,n))
    lattice.scatter(i, j, s=3, c=".75")
    scale = max(resolved["global_maximum"] / .77, 1)
    q = arrows(lattice, i, j, data["shifts"], scale=scale, color=".25", width=.009)
    reference = data["reference"]
    lattice.scatter(*reference, s=15, c=".15", zorder=3)
    for ij, color in zip(recipe["views_ij_zero_based"], ACCENTS):
        lattice.add_patch(Rectangle((ij[0]-.43,ij[1]-.43), .86, .86, fill=False,
                                    edgecolor=color, linewidth=1.25))
    lattice.set(xlim=(-.55,n-.45), ylim=(n-.45,-.55), aspect="equal", title="A   Global translations",
                xlabel="View index $i$", ylabel="View index $j$")
    ticks = np.unique(np.linspace(0,n-1,min(n,7),dtype=int))
    lattice.set_xticks(ticks, ticks+1)
    lattice.set_yticks(ticks, ticks+1)
    key = max(1, round(scale*.25))
    lattice.quiverkey(q, .24, -.22, key, f"{key} px", coordinates="axes", labelpos="E")

    x0,y0,x1,y1 = recipe["crop_xyxy_zero_based_half_open"]
    y,x = recipe["sample_yx_zero_based"]
    spacing = recipe["arrow_spacing_px"]
    yy,xx = np.mgrid[y0:y1:spacing,x0:x1:spacing]
    stride_fields = [data["fields"][tuple(ij)][yy,xx] for ij in recipe["views_ij_zero_based"]]
    arrow_max = max(float(np.linalg.norm(field, axis=-1).max()) for field in stride_fields)
    local_scale = max(arrow_max / (.74 * spacing), .001)
    for k, (ax, ij, color, vectors) in enumerate(zip(maps, recipe["views_ij_zero_based"], ACCENTS, stride_fields)):
        patch = data["fields"][tuple(ij)][y0:y1,x0:x1]
        img = ax.imshow(np.linalg.norm(patch,axis=-1), cmap="cividis", vmin=0,
                        vmax=resolved["local_limit"], interpolation="nearest",
                        extent=(x0-.5,x1-.5,y1-.5,y0-.5))
        moving = np.any(vectors != 0, axis=-1)
        if moving.any():
            local_q = arrows(ax, xx[moving], yy[moving], vectors[moving], color="white",
                             scale=local_scale, width=.009, edgecolor=".22", linewidth=.2)
            if k == 1 or not np.any(stride_fields[1] != 0):
                key = max(.1, round(local_scale * spacing * .48, 1))
                ax.quiverkey(local_q, .24, -.13, key, f"{key:g} px", coordinates="axes", labelpos="E",
                             color=".25")
        ax.set_title(("B   " if k == 0 else "") + f"View {view_label(ij)}", color=color)
        ax.set_xticks([])
        ax.set_yticks([])
        for spine in ax.spines.values():
            spine.set_color(color)
        if k == 0:
            ax.scatter(x,y,marker="+",s=55,c="black",linewidths=2.2)
            ax.scatter(x,y,marker="+",s=45,c="white",linewidths=1.2)
    clipped = resolved["clipped_pixels"]
    bar = figure.colorbar(img, ax=maps, fraction=.07, pad=.06, extend="max" if clipped else "neither")
    bar.set_label("Local magnitude (px)" + ("\nColors clipped" if clipped else ""), fontsize=7)
    bar.ax.tick_params(labelsize=7)

    sy,sx = resolved["source_yx"]
    inset.set_title("C   Backward sampling")
    inset.scatter(x,y,c=ACCENTS[0],s=30,zorder=3)
    if (sx,sy) != (x,y):
        inset.scatter(sx,sy,c=".16",marker="s",s=20,zorder=3)
        inset.annotate("", xy=(sx,sy), xytext=(x,y),
                       arrowprops=dict(arrowstyle="->", linestyle="--", shrinkA=3, shrinkB=3))
    inset.annotate("Output  $p$", (x,y), xytext=(7,-7), textcoords="offset points", fontsize=8)
    inset.annotate("Read  $p-d(p)$", (sx,sy), xytext=(7,7), textcoords="offset points", fontsize=8)
    xmin,xmax = min(x,sx), max(x,sx)
    ymin,ymax = min(y,sy), max(y,sy)
    inset.set(xlim=(xmin-1,xmax+3.8), ylim=(ymax+1.4,ymin-1.4), aspect="equal")
    step = max(1, int(max(xmax-xmin,ymax-ymin)//10))
    inset.set_xticks(np.arange(np.floor(xmin),np.ceil(xmax)+1,step))
    inset.set_yticks(np.arange(np.floor(ymin),np.ceil(ymax)+1,step))
    inset.tick_params(left=False,bottom=False,labelleft=False,labelbottom=False)
    inset.grid(alpha=.23)
    for spine in inset.spines.values():
        spine.set_visible(False)
    for ax in (lattice, *maps, inset):
        ax.title.set_fontsize(9)
        ax.tick_params(labelsize=7)
    lattice.xaxis.label.set_size(8)
    lattice.yaxis.label.set_size(8)
    return lattice

