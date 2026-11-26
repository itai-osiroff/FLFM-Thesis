function segment = proposeSegment(image, roi, extensionPixels)
%PROPOSESEGMENT Propose a profile segment through bright spots in a region.
%   ROI is [columnStart, rowStart, width, height] in one-based pixels of IMAGE.
%   The two brightest local maxima at least 3 px apart define the segment,
%   which is then extended by EXTENSIONPIXELS beyond each. With a single
%   maximum, the segment is horizontal through it. This is only a proposal:
%   the author approves or edits the coordinates in the recipe.
if nargin < 3
    extensionPixels = 4;
end
columns = max(1, round(roi(1))):min(size(image, 2), round(roi(1) + roi(3) - 1));
rows = max(1, round(roi(2))):min(size(image, 1), round(roi(2) + roi(4) - 1));
patch = imgaussfilt(double(image(rows, columns)), 0.7);
peaks = imregionalmax(patch);
peaks([1, end], :) = false;
peaks(:, [1, end]) = false;
[r, c] = find(peaks);
if isempty(r)
    [~, index] = max(patch(:));
    [r, c] = ind2sub(size(patch), index);
end
[~, order] = sort(patch(sub2ind(size(patch), r, c)), 'descend');
r = r(order);
c = c(order);
first = [c(1), r(1)];
second = [];
for k = 2:numel(r)
    if hypot(c(k) - first(1), r(k) - first(2)) >= 3
        second = [c(k), r(k)];
        break
    end
end
first = first + [columns(1), rows(1)] - 1;
if isempty(second)
    direction = [1, 0];
    startXY = first - extensionPixels * 2 * direction;
    endXY = first + extensionPixels * 2 * direction;
    kind = 'single';
else
    second = second + [columns(1), rows(1)] - 1;
    direction = (second - first) / norm(second - first);
    startXY = first - extensionPixels * direction;
    endXY = second + extensionPixels * direction;
    kind = 'pair';
end
segment = struct('startXY', startXY, 'endXY', endXY, 'kind', kind);
end
