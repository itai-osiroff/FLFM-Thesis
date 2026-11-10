function [panels, zooms] = presentZooms(prepared, presentation, schemaVersion)
%PRESENTZOOMS Render exported panels and zoom insets for a prepared presentation.
% Shared by replay and the setup dialogs so previews match exports.

panels = triofig.renderPanels(prepared, presentation.upsampleFactor);
perRegion = schemaVersion >= 6 && strcmp(presentation.display.method, 'window') && ...
    strcmp(presentation.display.zoom.mode, 'perRegion');
if perRegion
    zooms = triofig.extractDisplayZooms(prepared, presentation);
else
    zooms = triofig.extractZooms(panels, presentation.zoomRois);
end
end
