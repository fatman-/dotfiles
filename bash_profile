# Remove the annoying mail checker thingy
unset MAILCHECK

# Useful aliases (updated Nov 2014)
alias cddev='cd ~/Developer'

alias pgstatus='pg_ctl -D /usr/local/var/postgres status'
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias gulp='gulp --require coffee-script/register'
alias mocha='mocha --compilers coffee:coffee-script/register --reporter list'

# Bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Brew bash completion
source `brew --repository`/Library/Contributions/brew_bash_completion.sh

# Z - for rapid folder switching
. `brew --prefix`/etc/profile.d/z.sh

# Cycle through options on tab rather than displaying on double tab
bind '"\t":menu-complete'

# Weird locale problem fix
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# BASH PROMPT
source `brew --prefix`/etc/bash_completion.d/git-completion.bash
source `brew --prefix`/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
  grey=$(tput setaf 8);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 40);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 226);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
  grey="\e[1;37m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${bold}${red}";
else
	userStyle="${green}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${green}";
fi;

# Set the terminal title to the current working directory.
PS1="\[\033]0;\w\007\]";
PS1+="\n"; # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${grey}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${grey}\] in ";
PS1+="\[${yellow}\]\w"; # working directory
PS1+="\$(__git_ps1 \"${grey} on ${blue}%s\")"; # Git repository details
PS1+="\n";
PS1+="\[${grey}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

# export PS1='\n\[\033[0;37m\]Tesla@\u\[\033[0m\] \[\033[0;33m\]\w\[\033[0m\] \[\033[1;35m\]$(__git_ps1 "(%s)")\[\033[0m\] \n\$ '

# Softrade team functions
s_developsync() {
  if [ -d .git ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ "develop" == $branch ]
    then
      echo "Branch is indeed develop"
      echo "Initializing data update"
      git pull --rebase origin develop
    else
      echo "Danger, you're in the wrong branch: $branch"
    fi
  else
    echo "Illegal operation: You're not in a git repo";
  fi
}
