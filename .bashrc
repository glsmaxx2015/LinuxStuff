
### ~/bashrc ###

## BY: Greg Shubert   ON: 4-28-2016 



if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)




shopt -s expand_aliases
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete 


##########################################################################

###  ALIAS  ####


alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias h='htop'                             ## Opens HTOP
alias c='clear'                            ## Clears Terminal            
alias pup='sudo pacman -Syyu'              ## Syncs Pacman Db
alias yup='yaourt -Syyuua'                 ## UpDates Yaourt 
alias thrt='gksu thunar'                   ## Opens Thunar As Root
alias df='df -h'                           ## Human Readable 
alias rb='sudo reboot'                     ## Reboot System
alias diff='colordiff'                     ## ColorDiff  http://www.cyberciti.biz/faq/how-do-i-compare-two-files-under-linux-or-unix/
alias h='history'                          ## Short Bash History Listing
alias nowdate='date +"%d-%m-%Y"'           ## Date Now
alias ports='netstat -tulanp'              ## Open Ports
alias reboot='sudo /sbin/reboot'           ## Reboot  http://www.cyberciti.biz/faq/howto-shutdown-linux/
alias poweroff='sudo /sbin/poweroff'       ## Poweroff  
alias halt='sudo /sbin/halt'               ## Halt 
alias shutdown='sudo /sbin/shutdown'       ## ShutDown
alias path='echo $PATH'                    ## Show $PATH



# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
		;;
esac

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

# better yaourt colors
##export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

##[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion
##BROWSER=/usr/bin/xdg-open

##BASHISHDIR="/usr/share/bashish"                 ## line added by bashish
##TTY=`tty 2>/dev/null` && if test "x$BASHISHDIR" != x;then       ## line added by bashish
##test "$BASHISH_OLDPATH"||BASHISH_OLDPATH="$PATH"                ## line added by bashish
##PATH="$HOME/.bashish/launcher:$BASHISHDIR/lib:$BASHISH_OLDPATH" ## line added by bashish
##BASHSISH_CP=437                                                 ## line added by bashish
##TEST_TERM="$TERM" _bashish_utfcheck && BASHISH_CP=utf8          ## line added by bashish
##ENV="$HOME/.profile"                                            ## line added by bashish
##export BASHISH_CP BASHISH_OLDPATH TTY ENV                       ## line added by bashish
##. "$BASHISHDIR/main/prompt/sh/init"                             ## line added by bashish
##fi                                                              ## line added by bashish

screenfetch -D 'Manjaro Cup of Linux Edition 1.16-5'

## Adds Scripts and Bin to /home/glsmaxx
PATH=$PATH:/home/glsmaxx/Scripts:/home/glsmaxx/Bin

## Makes Terminator default Terminal
export TERMINAL="Terminator"

## Makes nano default EDITOR
export EDITOR="nano"





















