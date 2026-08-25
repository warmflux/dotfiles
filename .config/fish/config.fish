if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""
starship init fish | source
mise activate fish | source
# set -U fish_user_paths (go env GOPATH)/bin $fish_user_paths

set -gx EDITOR nvim

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end

# ---- wails 自定义命令 ----
function wdev
    wails dev -tags webkit2_41
end

function wbuild
    wails build -tags webkit2_41
end
