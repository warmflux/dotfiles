if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting ""
starship init fish | source

fish_add_path ~/.local/bin

set -gx EDITOR nvim

alias la="ls -al"
