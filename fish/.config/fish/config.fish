set theme_color_scheme nord
set PATH ~/.local/bin/ ~/node_modules/.bin/ /usr/local/bin $PATH

set fish_bind_mode insert
function fish_user_key_bindings
    fish_vi_key_bindings
    bind -M insert -m default jk backward-char force-repaint
end

set -g fish_key_bidings fish_user_key_bindings

alias kssh "kitty +kitten ssh "

function ats
   ssh access "ts $argv"
end

alias dr "docker run -v (pwd):/workspace -w /workspace"

alias ls "exa"
alias cat "bat"
