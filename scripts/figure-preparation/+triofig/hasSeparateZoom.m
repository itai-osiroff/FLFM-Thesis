function result = hasSeparateZoom(display)
%HASSEPARATEZOOM True when any zoom cell is not inherit (separate or both).
result = false;
if ~isfield(display, 'zoom') || ~isfield(display.zoom, 'regions'), return; end
for index = 1:numel(display.zoom.regions)
    region = display.zoom.regions(index);
    result = result || ~strcmp(region.thorcam.view, 'inherit') || ~strcmp(region.flfm.view, 'inherit');
end
end
