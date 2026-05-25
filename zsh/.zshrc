# @vinialx zsh profile configuration

alias nix-config='sudo nvim /etc/nixos/configuration.nix'
alias nix-update='sudo nixos-rebuild switch'
alias nix-clear='sudo nix-collect-garbage'

# omz configuration.
export ZSH="$ZSH"
ZSH_THEME=""

# direnv configuration.
eval "$(direnv hook zsh)"

# zoxide configuration.
eval "$(zoxide init zsh)"

# fzf configuration.
eval "$(fzf --zsh)"

# integration zoxide & fzf.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bun completions.
[ -s "/home/vinicius/.bun/_bun" ] && source "/home/vinicius/.bun/_bun"

# bun exports.
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# starship configuration.
eval "$(starship init zsh)"
