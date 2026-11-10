function [panels, zooms, extras] = presentZooms(prepared, presentation, schemaVersion, upsampled)
%PRESENTZOOMS Render exported panels, zoom insets and any stacked extra insets.
% Shared by replay and the setup dialogs so previews match exports. extras is
% empty unless window mapping has zoom cells with view 'both'.

panels = triofig.renderPanels(prepared, presentation.upsampleFactor);
extras = struct();
if schemaVersion >= 6 && strcmp(presentation.display.method, 'window') && ...
        triofig.hasSeparateZoom(presentation.display)
    if nargin < 4
        upsampled = triofig.upsampleSources(prepared, presentation.upsampleFactor);
    end
    [zooms, extras] = triofig.extractZoomSet(prepared, panels, presentation, upsampled);
else
    zooms = triofig.extractZooms(panels, presentation.zoomRois);
end
end
