#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export PATH="$HOME/.cargo/bin:$PATH"
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:/home/priyeshmishra/CodeBase/Includes

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
