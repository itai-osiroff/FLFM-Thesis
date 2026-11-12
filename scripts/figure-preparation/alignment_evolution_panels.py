"""Self-contained renderer (layout 2); snapshots depend only on NumPy and Matplotlib.

Conventions. A displacement d maps an output pixel p to the source location
q = p - d(p); the warp reads the source at q. Arrows show the forward picture of
that same pair: they start at q in the image being warped and end at the output
position p, so they point in the direction the content moves.
"""
import numpy as np
from matplotlib.patches import Patch, Rectangle

FIGSIZE_IN = (145/25.4, 172/25.4)
FIG_MM = (145, 172)
REGION_COLORS = ('#2ca02c', '#e03c31')
G_CENTER_X = .54   # horizontal centre of panel G, as a fraction of the figure width
KEY_PX = (8, 4)   # displacement (px) shown by the key bar in the global and local rows


def arrow_segments(field, crop, step, magnification, shape):
    """Return (tails, heads, extent) as (K,2) [y,x] arrays and (x0,y0,x1,y1).

    `field` is a (2,) constant displacement or an (H,W,2) field. Heads are the
    output grid points inside `crop`; tails are head - magnification*d. Arrows
    with no displacement or a tail outside the image are dropped. The extent is
    the smallest image-clipped box containing the crop and every kept tail.
    """
    x0, y0, x1, y1 = crop; h, w = shape
    yy, xx = np.mgrid[y0+step//2:y1:step, x0+step//2:x1:step]
    d = np.broadcast_to(field, (*yy.shape, 2)) if np.ndim(field) == 1 else field[yy, xx]
    ty = yy - d[..., 0]*magnification; tx = xx - d[..., 1]*magnification
    keep = np.any(d != 0, axis=-1) & (ty >= 0) & (ty <= h-1) & (tx >= 0) & (tx <= w-1)
    heads = np.stack((yy[keep], xx[keep]), -1).astype(float)
    tails = np.stack((ty[keep], tx[keep]), -1)
    ex0, ey0, ex1, ey1 = x0, y0, x1, y1
    if len(tails):
        ex0 = min(ex0, int(np.floor(tails[:, 1].min()))-2); ex1 = max(ex1, int(np.ceil(tails[:, 1].max()))+3)
        ey0 = min(ey0, int(np.floor(tails[:, 0].min()))-2); ey1 = max(ey1, int(np.ceil(tails[:, 0].max()))+3)
    return tails, heads, (max(0, ex0), max(0, ey0), min(w, ex1), min(h, ey1))


def equal_extents(extents, shape):
    """Grow every extent to the largest width and height (shifted back into the image)."""
    h, w = shape; tw = max(e[2]-e[0] for e in extents); th = max(e[3]-e[1] for e in extents); out = []
    for ex0, ey0, ex1, ey1 in extents:
        nx0 = min(max(0, ex0-(tw-(ex1-ex0))//2), w-tw); ny0 = min(max(0, ey0-(th-(ey1-ey0))//2), h-th)
        out.append((nx0, ny0, nx0+tw, ny0+th))
    return out


def draw(fig, data, r, resolved):
    if r.get('layout_version') != 2:
        raise ValueError('This renderer draws layout 2. Run "single_view_figure.py upgrade" on the recipe.')
    fig.clear(); fig.set_size_inches(*FIGSIZE_IN)
    lo, hi = resolved['display_limits']; v = tuple(r['view'])
    ref = tuple(data['reference_index'])
    regions = [tuple(g['crop']) for g in resolved['regions']]
    blue = np.array([0, .4, 1]); orange = 1-blue
    norm = lambda a: np.clip((a-lo)/(hi-lo), 0, 1)
    rlo, rhi = resolved.get('local_reference_display_limits', (lo, hi))
    norm_ref = lambda a: np.clip((a-rlo)/(rhi-rlo), 0, 1)   # G is an average, so it may use lower limits
    h, w = data['global_average'].shape
    refs = [data['original'][ref], data['global_average']]
    before = [data['original'][v], data['aligned'][v]]; after = [data['aligned'][v], data['refined'][v]]
    warped = [data['original'][v], data['aligned'][v]]   # the image each stage warps
    # Arrow length magnification per stage row: the global shift is already long, the local field is small.
    mags = [r['arrow_magnification'], r.get('local_arrow_magnification', r['arrow_magnification'])]
    # Stage rows keep their absolute size and distance from the top edge (mm).
    mm_y = lambda mm: 1-mm/FIG_MM[1]
    stage_box = [(mm_y(10.4), mm_y(56.8)), (mm_y(64.0), mm_y(110.4))]
    fields = [data['shifts'][v], data['fields'][v]]; steps = [r['global_arrow_spacing'], r['local_arrow_spacing']]
    segs = [[arrow_segments(fields[row], crop, steps[row], mags[row], (h, w)) for crop in regions] for row in range(2)]
    extents = [equal_extents([sg[2] for sg in segs[row]], (h, w)) for row in range(2)]
    axes = []
    for row in range(2):
        outer = fig.add_gridspec(2, 3, left=.17, right=.98, top=stage_box[row][0], bottom=stage_box[row][1], wspace=.10, hspace=.05)
        for k, crop in enumerate(regions):
            x0, y0, x1, y1 = crop
            for col in range(3):
                ax = fig.add_subplot(outer[k, col]); axes.append(ax)
                if col == 1:
                    tails, heads, _ = segs[row][k]; ex0, ey0, ex1, ey1 = extents[row][k]
                    ax.imshow((norm(warped[row])[..., None]*orange)[ey0:ey1, ex0:ex1], interpolation='nearest', extent=(ex0-.5, ex1-.5, ey1-.5, ey0-.5))
                    if len(tails):
                        ax.quiver(tails[:, 1], tails[:, 0], heads[:, 1]-tails[:, 1], heads[:, 0]-tails[:, 0], angles='xy', scale_units='xy', scale=1,
                                  pivot='tail', color='white', edgecolor='black', linewidth=.35, width=.012 if row == 0 else .02)
                    ax.set_xlim(ex0-.5, ex1-.5); ax.set_ylim(ey1-.5, ey0-.5)
                    if k == 0:   # key: a displacement of KEY_PX[row] pixels, drawn at this row's arrow magnification
                        n = KEY_PX[row]; bar = n*mags[row]
                        ax.plot([ex1-14-bar, ex1-14], [ey1-5, ey1-5], color='white', linewidth=1)
                        ax.text(ex1-14-bar/2, ey1-8, f'{n:g} px', color='white', ha='center', fontsize=8)
                else:
                    a = (norm if row == 0 else norm_ref)(refs[row])
                    panel = a[..., None]*blue + norm((before if col == 0 else after)[row])[..., None]*orange
                    ax.imshow(panel[y0:y1, x0:x1], interpolation='nearest', extent=(x0-.5, x1-.5, y1-.5, y0-.5))
                ax.set_xticks([]); ax.set_yticks([])
                for s in ax.spines.values(): s.set_edgecolor(REGION_COLORS[k]); s.set_linewidth(1.4)
                if k == 0: ax.text(.01, 1.03, 'ABCDEF'[row*3+col], transform=ax.transAxes, fontsize=8, fontweight='bold')
                if col == 0:
                    ax.text(.03, .94, f'R{k+1}', transform=ax.transAxes, color=REGION_COLORS[k], fontsize=8, fontweight='bold', va='top',
                            bbox=dict(facecolor='black', edgecolor='none', pad=1.2, alpha=.55))
                    if k == 0:
                        ax.text(-.05, 0, ('Global\nalignment\n\nCentral\nreference' if row == 0 else 'Local\nrefinement\n\nReference: G'),
                                transform=ax.transAxes, ha='right', va='center', fontsize=8)
                if row == 0 and k == 0: ax.set_title(['Before', 'Displacement field', 'After'][col], fontsize=9, pad=18)
                if col == 1 and k == 1:
                    ax.text(.5, -.09, 'Warped view: ' + ('original' if row == 0 else 'globally aligned'), transform=ax.transAxes, ha='center', va='top', fontsize=8)
    # Bottom band: both regions in the full selected view (output coordinates of the globally aligned view).
    cx0, cy0, cx1, cy1 = resolved.get('context_crop', (0, 0, w, h))
    mm_x = lambda mm: mm/FIG_MM[0]
    side_w = 50.0/FIG_MM[0]; side_h = 50.0/FIG_MM[1]       # largest box (square in mm), image aspect kept
    scale = min(side_w*FIG_MM[0]/(cx1-cx0), side_h*FIG_MM[1]/(cy1-cy0))   # mm per pixel
    box_w, box_h = (cx1-cx0)*scale/FIG_MM[0], (cy1-cy0)*scale/FIG_MM[1]
    gx = G_CENTER_X   # panel G is centred here: between the figure centre (.5) and the middle column of panels (.575)
    ax = fig.add_axes([gx-box_w/2, mm_y(170.5), box_w, box_h])
    ax.imshow(norm(data['aligned'][v]), cmap='gray', vmin=0, vmax=1, interpolation='nearest', extent=(-.5, w-.5, h-.5, -.5))
    for k, (x0, y0, x1, y1) in enumerate(regions):
        ax.add_patch(Rectangle((x0-.5, y0-.5), x1-x0, y1-y0, fill=False, edgecolor=REGION_COLORS[k], linewidth=1.4))
        ax.text(x0+3, y0+3, f'R{k+1}', color=REGION_COLORS[k], fontsize=8, fontweight='bold', va='top', ha='left',
                bbox=dict(facecolor='black', edgecolor='none', pad=1.0, alpha=.55))
    ax.set_xticks([]); ax.set_yticks([]); ax.set_xlim(cx0-.5, cx1-.5); ax.set_ylim(cy1-.5, cy0-.5)
    fig.text(gx, mm_y(118.5), f'G  Regions in the selected view ({v[0]+1},{v[1]+1}), globally aligned', fontsize=9, ha='center')
    # Colour legend to the left of G. The arrow convention (including the scales m) is explained in the thesis caption.
    fig.legend(handles=[Patch(color=blue, label='Reference'), Patch(color=orange, label='Selected view')],
               loc='center right', bbox_to_anchor=(gx-box_w/2-mm_x(3), mm_y(145)), ncol=1, fontsize=8, frameon=False)
    return axes
