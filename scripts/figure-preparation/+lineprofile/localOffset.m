function [offsetXY, peak] = localOffset(moving, reference, columns, rows, maxShift)
%LOCALOFFSET Local translation of MOVING relative to REFERENCE in a window.
%   The global registration places the regular camera and G on the grid of
%   the final image, but the aberration displaces each bead by a different
%   amount, so a bead can sit a few pixels away from where it appears in the
%   final image. OFFSETXY = [dx, dy] is how far the content of the window
%   (COLUMNS x ROWS of REFERENCE) is displaced in MOVING: after subtracting
%   a Gaussian-blurred copy (sigma 4 px) from both images, the peak of the
%   normalized cross-correlation within +-MAXSHIFT pixels, refined to
%   sub-pixel precision by a parabola through the peak and its neighbours.
%   A profile segment drawn on REFERENCE is moved by OFFSETXY to cross the
%   same beads in MOVING.
columns = round(columns(:).');
rows = round(rows(:).');
% Remove the slowly varying halo first, so the beads, not the haze around
% them, decide the match.
moving = highPass(moving);
reference = highPass(reference);
template = double(reference(rows, columns));
searchRows = rows(1) - maxShift:rows(end) + maxShift;
searchColumns = columns(1) - maxShift:columns(end) + maxShift;
if searchRows(1) < 1 || searchColumns(1) < 1 || searchRows(end) > size(moving, 1) ...
        || searchColumns(end) > size(moving, 2)
    error('lineprofile:OutsideImage', 'The offset search window leaves the image.');
end
area = double(moving(searchRows, searchColumns));
correlation = normxcorr2(template, area);
% Keep only placements where the template lies fully inside the search area.
valid = correlation(size(template, 1):end - size(template, 1) + 1, ...
    size(template, 2):end - size(template, 2) + 1);
[peak, index] = max(valid(:));
[r, c] = ind2sub(size(valid), index);
dy = r - 1 - maxShift + subpixel(valid, r, c, 1);
dx = c - 1 - maxShift + subpixel(valid, r, c, 2);
offsetXY = [dx, dy];
end

function image = highPass(image)
image = double(image);
image = image - imgaussfilt(image, 4);
end

function delta = subpixel(values, r, c, dimension)
delta = 0;
if dimension == 1
    if r == 1 || r == size(values, 1)
        return
    end
    a = values(r - 1, c); b = values(r, c); d = values(r + 1, c);
else
    if c == 1 || c == size(values, 2)
        return
    end
    a = values(r, c - 1); b = values(r, c); d = values(r, c + 1);
end
denominator = a - 2 * b + d;
if denominator < 0
    delta = 0.5 * (a - d) / denominator;
end
end
