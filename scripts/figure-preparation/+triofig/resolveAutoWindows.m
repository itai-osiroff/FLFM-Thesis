function display = resolveAutoWindows(display, source, mode)
%RESOLVEAUTOWINDOWS Recompute every main-panel window flagged auto from percentiles.
% source: processed (unwindowed) float images with fields global, local, thorcam,
% as returned in applyDisplay's info.source. mode is 'linked' or 'separate'.
% Windows that are not flagged auto keep their absolute values.

roles = display.roles;
if strcmp(mode, 'separate')
    pools = struct('global', {{source.global}}, 'local', {{source.local}}, ...
        'thorcam', {{source.thorcam}});
else
    pools = struct('flfm', {{source.global, source.local}}, 'thorcam', {{source.thorcam}});
end
for name = fieldnames(pools).'
    key = name{1};
    if roles.(key).auto
        roles.(key) = triofig.resolveWindow(pools.(key), roles.(key));
    end
end
display.roles = roles;
end
