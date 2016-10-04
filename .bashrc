# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here. #moved to .bash_prompt
#PS1='\[\e[0;37m\][\[\e[0;36m\]\u@\h: \[\e[0;37m\]\W]\[\e[0m\]\$ '

# Case-insensitive globbing (used in pathname expansion)
#shopt -s nocaseglob #moved to .bash_profile

# Append to the Bash history file, rather than overwriting it
#shopt -s histappend #moved to .bash_profile

# Ignore duplicate lines and lines starting with space; history size changes #Moved to .exports
#HISTCONTROL=ignoreboth
#HISTSIZE=100000
#HISTFILESIZE=200000

# Autocorrect typos in path names when using `cd`
#shopt -s cdspell #moved to .bash_profile

# Check window size after each command and if necessary update values of lines/columns.
#shopt -s checkwinsize #moved to .bash_profile

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias dir='dir --color=auto'
        alias vdir='vdir --color=auto'

        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so: #Moved to .aliases
#       sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards #moved to .bash_profile
#[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
#        -o "nospace" \
#        -W "$(grep "^Host" ~/.ssh/config | \
#        grep -v "[?*]" | cut -d " " -f2 | \
#        tr ' ' '\n')" scp sftp ssh

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt` #moved to .bash_profile
#for option in autocd globstar; do
#        shopt -s "$option" 2> /dev/null
#done


# Standard User Aliases

#alias vi='vim'
#alias wpawifi='sudo /etc/init.d/wpa_supplicant start'
#alias cp='rsync -avz --progress'
#alias chromed='docker run -d --memory 3gb -v /etc/localtime:/etc/localtime:ro -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v $HOME/Downloads:/root/Downloads -v $HOME/Pictures:/root/Pictures -v $HOME/Torrents:/root/Torrents -v $HOME/.chrome:/data -v /dev/shm:/dev/shm -v /etc/hosts:/etc/hosts --security-opt seccomp:~/etc/chrome.json --device /dev/snd --device /dev/dri --device /dev/video0 --device /dev/usb --device /dev/bus/usb --group-add audio --group-add video --name chrome jess/chrome --user-data-dir=/data'
#alias stopchromed='for i in stop rm; do docker $i chrome && docker ps -a; done'

if [[ -f $HOME/.bash_profile ]]; then
        source $HOME/.bash_profile
fi

