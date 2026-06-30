# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# @vinialx zsh profile configuration

alias nxcfg='sudo nvim /etc/nixos/configuration.nix'
alias nxupd='sudo nixos-rebuild switch'
alias nxclr='sudo nix-collect-garbage'
alias nxclrd='sudo nix-collect-garbage -d'
alias nv='nvim'
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'
alias brd='bun run dev'
alias brb='bun run build'
alias taskmgrbk-ssh='fly ssh console -a wires-task-manager-server'
alias taskmgrcl-ssh='fly ssh console -a wires-task-manager-client'

# omz configuration.
export ZSH="$ZSH"
ZSH_THEME=""

# rtk configuration.
export PATH="$HOME/.local/bin:$PATH"

# direnv configuration.
eval "$(direnv hook zsh)"

# zoxide configuration.
export _ZO_FZF_OPTS="--height 40% --reverse --border"
eval "$(zoxide init zsh --cmd cd)"

# fzf configuration.
eval "$(fzf --zsh)"

# zoxide + fzf functions.
cpz() {
  local dest_search="${@[-1]}"
  local files=("${@[1,-2]}")
  local target
  
  target=$(zoxide query -i "$dest_search")
  
  if [ -n "$target" ]; then
    cp -r "${files[@]}" "$target"
    echo "✨ Copiado para: $target"
  fi
}

mvz() {
  local dest_search="${@[-1]}"
  local files=("${@[1,-2]}")
  local target
  
  target=$(zoxide query -i "$dest_search")
  
  if [ -n "$target" ]; then
    mv "${files[@]}" "$target"
    echo "🚚 Movido para: $target"
  fi
}

# integration zoxide & fzf.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bun completions.
[ -s "/home/vinicius/.bun/_bun" ] && source "/home/vinicius/.bun/_bun"

# bun exports.
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
