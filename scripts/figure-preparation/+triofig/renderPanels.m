function panels = renderPanels(prepared, upsampleFactor)
%RENDERPANELS Convert cropped panels to deterministic uint8 exported panels.

panelNames = {'thorcam', 'global', 'local', 'validation'};
panels = struct();
for index = 1:numel(panelNames)
    name = panelNames{index};
    image = imresize(prepared.(name), upsampleFactor, 'nearest');
    panels.(name) = uint8(round(min(max(image, 0), 1) * 255));
end
end
