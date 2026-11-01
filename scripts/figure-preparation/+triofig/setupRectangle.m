function result = setupRectangle(kind, position, imageSize, id)
%SETUPRECTANGLE Convert image rectangles without hiding out-of-bounds edits.
if nargin < 4
    id = 1;
end
if numel(position) ~= 4 || any(~isfinite(position))
    error('triofig:InvalidRoi', 'Enter finite X, Y, width and height values.');
end
width = round(position(3));
height = round(position(4));
if strcmp(kind, 'crop')
    x = round(position(1) + .5);
    y = round(position(2) + .5);
else
    x = round(position(1));
    y = round(position(2));
end
if width < 1 || height < 1 || x < 1 || y < 1 || ...
        x + width - 1 > imageSize(2) || y + height - 1 > imageSize(1)
    error('triofig:InvalidRoi', 'The rectangle must have positive size and stay inside the image.');
end
if strcmp(kind, 'crop')
    result = struct('rowStartOneBased', y, 'columnStartOneBased', x, ...
        'height', height, 'width', width);
else
    colors = {'orange', 'cyan'};
    result = struct('id', id, 'xZeroBased', x - 1, 'yZeroBased', y - 1, ...
        'width', width, 'height', height, 'color', colors{id});
end
end
