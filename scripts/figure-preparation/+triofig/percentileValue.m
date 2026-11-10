function value = percentileValue(values, percentile)
%PERCENTILEVALUE Linear-interpolated percentile without a toolbox dependency.
% NaN values are ignored. Percentile is in [0, 100].

values = double(values(:));
values = sort(values(~isnan(values)));
count = numel(values);
if count == 0
    error('triofig:FlatImage', 'Cannot compute a percentile of an empty image region.');
end
position = 1 + (count - 1) * percentile / 100;
lower = floor(position);
upper = ceil(position);
value = values(lower) + (position - lower) * (values(upper) - values(lower));
end
