# Add user configurations here
# For HyDE to not touch your beloved configurations,
# we added 2 files to the project structure:
# 1. ~/.hyde.zshrc - for customizing the shell related hyde configurations
# 2. ~/.zshenv - for updating the zsh environment variables handled by HyDE // this will be modified across updates

#  Plugins 
# oh-my-zsh plugins are loaded  in ~/.hyde.zshrc file, see the file for more information

#  Aliases 
#
# CMake auto running and building for c++
alias brr="~/CodeBase/bash++/buildRelease.sh"
alias bd="~/CodeBase/bash++/buildDebug.sh"
alias rd="~/CodeBase/bash++/runDebug.sh"
alias br="~/CodeBase/bash++/buildRun.sh"
alias bc="~/CodeBase/bash++/buildClean.sh"
alias gcd="~/CodeBase/bash++/cmakeGenerate.sh"
alias rr="~/CodeBase/bash++/run.sh"
# System Maintenance scripts
alias cpum="sudo ~/CodeBase/bash++/sysMng/cpuManager.sh"
alias sysm="sudo ~/CodeBase/bash++/sysMng/sysMaintenance.sh"
# Zen mode bonsai script
alias bonsai="~/CodeBase/bash++/sysMng/bonsai.sh"

#  This is your file 
# Add your configurations here

# [ -f "$HOME/.config/nnn/nnnrc" ] && source "$HOME/.config/nnn/nnnrc"
