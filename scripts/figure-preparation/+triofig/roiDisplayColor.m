function color = roiDisplayColor(name)
%ROIDISPLAYCOLOR Map a recipe color name to the RGB value MATLAB accepts.

switch lower(char(string(name)))
    case 'orange'
        color = [1, 0.5, 0];
    case 'cyan'
        color = [0, 1, 1];
    case 'yellow'
        color = [1, 1, 0];
    otherwise
        error('triofig:InvalidRoiColor', 'Unsupported ROI display color: %s', name);
end
end
