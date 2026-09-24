function downsampleFactor = downsample_point_match(referencePoints, movingPoints)
%DOWNSAMPLE_POINT_MATCH Estimate a scale factor from recorded point pairs.
%   This is the noninteractive working copy of the original calibration script.
%   Supply matching Nx2 [x y] coordinates in reference and moving images.

if size(referencePoints, 2) ~= 2 || size(movingPoints, 2) ~= 2
    error('eyedrop_replay:InvalidPoints', ...
        'Point arrays must each have two columns: [x y].');
end
if size(referencePoints, 1) ~= size(movingPoints, 1) || size(referencePoints, 1) < 2
    error('eyedrop_replay:InvalidPoints', ...
        'At least two corresponding reference and moving points are required.');
end

referenceDistances = pdist(double(referencePoints));
movingDistances = pdist(double(movingPoints));
if any(movingDistances == 0)
    error('eyedrop_replay:InvalidPoints', ...
        'Moving-image point pairs must not have zero separation.');
end

downsampleFactor = median(referenceDistances ./ movingDistances);
end
