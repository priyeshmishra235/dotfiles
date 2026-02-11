# Enable Powerlevel10k instant prompt. Should stay at the top of ~/.config/zsh/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# ╭──────────────────────────────────────────────────────────╮
# │                           Path                           │
# ╰──────────────────────────────────────────────────────────╯
export STEAM_ENABLE_WAYLAND=1

plugins=(
     "sudo"
     "zsh-autosuggestions"
     "zsh-syntax-highlighting"
     "zsh-completions"
)

ZSH_THEME="robbyrussell"

# ╭──────────────────────────────────────────────────────────╮
# │                         Aliases                          │
# ╰──────────────────────────────────────────────────────────╯
 alias mkdir='mkdir -p'

# ╭──────────────────────────────────────────────────────────╮
# │              Directory navigation shortcuts              │
# ╰──────────────────────────────────────────────────────────╯
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias c='clear'

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
