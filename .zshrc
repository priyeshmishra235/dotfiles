# Only start tmux if not already inside tmux
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

export PATH="$HOME/.cargo/bin:$PATH"

#  Aliases 
# System Maintenance scripts
alias cpum="sudo ~/dotfiles/CodeBase/bash++/sysMng/cpuManager.sh"
alias sysm="sudo ~/dotfiles/CodeBase/bash++/sysMng/sysMaintenance.sh"
alias borgBackup="sudo ~/dotfiles/CodeBase/bash++/sysMng/borgBackup.sh"
alias predatorSense='sudo ~/dotfiles/CodeBase/bash++/sysMng/predatorSense.sh interactive'

# Zen mode bonsai script
alias bonsai="~/CodeBase/bash++/sysMng/bonsai.sh"

#  This is your file 
# Add your configurations here

# [ -f "$HOME/.config/nnn/nnnrc" ] && source "$HOME/.config/nnn/nnnrc"
