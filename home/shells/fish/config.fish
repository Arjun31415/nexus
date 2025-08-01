export EDITOR=nvim
set fish_greeting # Disable greeting
set VIRTUAL_ENV_DISABLE_PROMPT 1
# set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x MANPAGER "nvim +Man!"
set MANWIDTH 999
set SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
set sponge_purge_only_on_exit true

fish_vi_key_bindings

if test -f ~/.venv/bin/activate.fish
    source ~/.venv/bin/activate.fish
end

## Export variable need for qt-theme
if type qtile >>/dev/null 2>&1
    set -x QT_QPA_PLATFORMTHEME qt5ct
end

if test -z (pgrep ssh-agent)
    eval (ssh-agent -c | head -n2)
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

if test -d ~/.npm-global
    set NPM_PACKAGES "$HOME/.npm-global"
    set -p PATH "$HOME/.npm-global/bin"
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

if type -q fastfetch
    if test -d ~/.config/fastfetch/presets
        fastfetch --load-config ~/.config/fastfetch/presets/neofetch.jsonc
    else
        fastfetch
    end
else if type -q neofetch
    neofetch
end

# direnv hook fish | source
# Nixos home manager does this anyways
#source ("starship" init fish --print-full-init | psub)
