function upsampled = upsampleSources(prepared, factor)
%UPSAMPLESOURCES Nearest-neighbour upsample the processed float panels like renderPanels.
upsampled = struct();
for name = {'thorcam', 'global', 'local'}
    upsampled.(name{1}) = imresize(prepared.source.(name{1}), factor, 'nearest');
end
end
