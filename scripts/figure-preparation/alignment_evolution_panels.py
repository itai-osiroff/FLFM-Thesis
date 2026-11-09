"""Self-contained renderer; snapshots depend only on NumPy and Matplotlib."""
import numpy as np
from matplotlib.patches import Patch, ConnectionPatch


def draw(fig,data,r,resolved):
    fig.clear(); x0,y0,x1,y1=resolved['crop']; lo,hi=resolved['display_limits']; v=tuple(r['view'])
    ref=tuple(data['reference_index']); y,x=r['sample_yx']; sy,sx=resolved['source_yx']
    blue=np.array([0,.4,1]); orange=1-blue
    norm=lambda a: np.clip((a-lo)/(hi-lo),0,1)
    refs=[data['original'][ref],data['global_average']]
    before=[data['original'][v],data['aligned'][v]]; after=[data['aligned'][v],data['refined'][v]]
    grid=fig.add_gridspec(2,3,left=.14,right=.99,bottom=.46,top=.91,wspace=.07,hspace=.20)
    axes=[]
    for row in range(2):
        for col in range(3):
            ax=fig.add_subplot(grid[row,col]); axes.append(ax)
            a=norm(refs[row]); panel=a if col==1 else a[...,None]*blue+norm((before if col==0 else after)[row])[...,None]*orange
            ax.imshow(panel[y0:y1,x0:x1],cmap='gray',vmin=0,vmax=1,interpolation='nearest',extent=(x0-.5,x1-.5,y1-.5,y0-.5))
            ax.set_axis_off()
            ax.text(.01,1.03,'ABCDEF'[row*3+col],transform=ax.transAxes,fontsize=8,fontweight='bold')
            if row==0: ax.set_title(['Before','Displacement field','After'][col],fontsize=9,pad=18)
            if col==0:
                ax.text(-.05,.5,('Global\nalignment\n\nCentral\nreference' if row==0 else 'Local\nrefinement\n\nReference: G'),transform=ax.transAxes,ha='right',va='center',fontsize=8)
            if col==1:
                step=r['global_arrow_spacing'] if row==0 else r['local_arrow_spacing']
                yy,xx=np.mgrid[y0+step//2:y1:step,x0+step//2:x1:step]
                field=np.broadcast_to(data['shifts'][v],(*yy.shape,2)) if row==0 else data['fields'][v][yy,xx]
                mag=r['arrow_magnification']; ey=yy-field[...,0]*mag; ex=xx-field[...,1]*mag
                valid=(ey>=y0)&(ey<y1)&(ex>=x0)&(ex<x1)&np.any(field!=0,axis=-1)
                ax.quiver(xx[valid],yy[valid],-field[...,1][valid]*mag,-field[...,0][valid]*mag,angles='xy',scale_units='xy',scale=1,pivot='tail',color='white',edgecolor='black',linewidth=.35,width=.012)
                ax.text(.5,-.12,('Source: original view' if row==0 else 'Source: globally aligned view'),transform=ax.transAxes,ha='center',fontsize=8)
                if row==1: ax.scatter(x,y,s=32,facecolors='none',edgecolors='#ff5ec4',linewidths=1.2)
                if row==0:
                    ax.plot([x1-22,x1-14],[y1-5,y1-5],color='white',linewidth=1)
                    ax.text(x1-18,y1-8,'8 px',color='white',ha='center',fontsize=8)
    fig.text(.55,.375,f'Arrows: output position to source location; lengths {r["arrow_magnification"]:g}x image pixels',ha='center',fontsize=8)
    fig.legend(handles=[Patch(color=blue,label='Reference'),Patch(color=orange,label='Selected view')],loc='center',bbox_to_anchor=(.58,.408),ncol=2,fontsize=8,frameon=False)
    # Matched full-image coordinates expose the source/output distinction.
    radius=r['enlargement_radius']; h,w=refs[0].shape
    bx0=int(np.floor(min(x,sx)))-radius; bx1=int(np.ceil(max(x,sx)))+radius+1
    by0=int(np.floor(min(y,sy)))-radius; by1=int(np.ceil(max(y,sy)))+radius+1
    patches=[]
    for k,(image,title) in enumerate([(data['aligned'][v],'Source: globally aligned'),(data['refined'][v],'Output: locally refined')]):
        ax=fig.add_axes([.34+k*.34,.075,.27,.225]); patches.append(ax)
        patch=np.zeros((by1-by0,bx1-bx0)); ya,yb=max(0,by0),min(h,by1); xa,xb=max(0,bx0),min(w,bx1)
        if ya<yb and xa<xb: patch[ya-by0:yb-by0,xa-bx0:xb-bx0]=norm(image[ya:yb,xa:xb])
        ax.imshow(patch,cmap='gray',vmin=0,vmax=1,interpolation='nearest',extent=(bx0-.5,bx1-.5,by1-.5,by0-.5))
        ax.set_axis_off(); ax.set_title(title,fontsize=8,pad=5)
        py,px=(sy,sx) if k==0 else (y,x)
        ax.scatter(px,py,s=45,facecolors='none',edgecolors='#ff5ec4',linewidths=1.2)
        ax.text(.5,-.13,r'$p_{\mathrm{src}} = p - d(p)$' if k==0 else 'Output p',transform=ax.transAxes,ha='center',fontsize=8)
    fig.add_artist(ConnectionPatch((x,y),(sx,sy),coordsA='data',coordsB='data',axesA=patches[1],axesB=patches[0],arrowstyle='->',linestyle='--',color='#b72b8b',linewidth=1.1,shrinkA=6,shrinkB=6))
    fig.text(.65,.005,r'The warp takes the intensity at $p_{\mathrm{src}}$ for output $p$.',ha='center',fontsize=8)
    ax=fig.add_axes([.035,.17,.15,.13]); n=data['original'].shape[0]; ii,jj=np.indices((n,n))
    ax.scatter(jj,ii,s=3,c='.65'); ax.scatter(ref[1],ref[0],s=15,c=[blue]); ax.scatter(v[1],v[0],s=15,c=[orange]); ax.set(xlim=(-.5,n-.5),ylim=(n-.5,-.5),aspect='equal'); ax.set_axis_off()
    fig.text(.11,.12,f'View ({v[0]+1},{v[1]+1})',ha='center',fontsize=8)
    fig.text(.03,.335,'G  Warping at one pixel',fontsize=9)
    if not resolved['source_in_bounds']: fig.text(.34,.06,'Outside source: reads zero',fontsize=8)
    return axes
