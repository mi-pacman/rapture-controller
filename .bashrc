# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
# [ -z "$PS1" ] && return
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=100000000

# avoid losing history
PROMPT_COMMAND="history -a"
export HISTSIZE PROMPT_COMMAND

TERM=xterm-256color

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    # Do it ONLY when connecting via pts BUT NOT tty
    # pts - ssh or terminal emulators like konsole or gnome-terminal
    # otherwise it'll mess up the Bash prompt PS1
    mytty=$(tty)
    if [[ ${mytty:5:3} = "pts" ]]; then
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        # PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    fi
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# color for man pages
man() {
    env LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

# some more ls aliases
alias ll='exa -la'
alias lt='exa -T'
# alias ll='ls -alF'
alias la='ls -A'
alias lah='ls -lah'
alias l='ls -CF'

# Add an "alert" alias for long running commands.
# Use like so: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#     . /etc/bash_completion
# fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

if [ -d "$HOME/.linuxbrew" ]; then
    export PATH=$HOME/.linuxbrew/bin:$PATH
    export LD_LIBRARY_PATH=$HOME/.linuxbrew/lib
fi


# Rapture's configuration

##########################
###Terraform Controller###
##########################
alias poweron-tc='sudo docker run -v /home/vagrant/.aws/credentials:/root/.aws/credentials -v /home/vagrant/rapture-proxy/provisioner/instances:/root/instances --name terraform_controller -h terraformController -d -p 2222:22 midockerdb/terraform-controller:0.1.2'
alias connect-tc='ssh -p 2222 root@localhost'
alias poweroff-tc='sudo docker stop terraform_controller && sudo docker rm terraform_controller'

#######################
###Packer Controller###
#######################
alias poweron-pc='sudo docker run -v /home/vagrant/.aws/credentials:/root/.aws/credentials:ro -v /home/vagrant/rapture-proxy/provisioner/images:/root/images:ro --name packer_controller -h packerController -d -p 2223:22 midockerdb/packer-controller:0.1.2'
alias connect-pc='ssh -p 2223 root@localhost'
alias poweroff-pc='sudo docker stop packer_controller && sudo docker rm packer_controller'

#Generate SSH Key
alias generate-key='ssh-keygen -t ed25519 -f /home/vagrant/rapture-proxy/provisioner/images/tf-packer'

#Fetch terraform public_ip output from container
alias terraformipraw='sudo docker exec -it terraform_controller terraform output --state /root/instances/terraform.tfstate public_ip'
alias terraformip="terraformipraw | sed 's/\"//g'"  # Removes "" from output
