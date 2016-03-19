# Remove the annoying mail checker thingy
unset MAILCHECK

# Useful aliases (updated Nov 2014)
alias cddev='cd ~/Developer'

alias pgstatus='pg_ctl -D /usr/local/var/postgres status'
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias gulpc='gulp --require coffee-script/register'
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


# SOFTRADE TEAM COMMANDS

# Update dotfiles
s_update() {
  # store work directory
  dir=$(pwd)
  # Move to dotfiles repo
  cd ~/.dotfiles/
  # Check branch
  if [ -d .git ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ $branch == "master" ]
    then
      echo "Initiating git update of dotfiles"
      git pull origin master
    else
      echo "Danger, something's wrong with your dotfiles setup"
    fi
  else
    echo "Danger, something's wrong with your dotfiles setup"
  fi
  # Move back to work directory
  cd $dir
}

# Sync develop with git
s_gitsync() {
  if [ -z "$1" ]
  then
    echo "No parameter provided. Options: pull_depricated | push_depricated | fetch | pr_update | latest_in_develop | pull_safe"
  elif [ ! -d .git ]
  then
    echo "Illegal operation: You're not in a git repo"
  elif [ $1 == "pull_depricated" ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ $branch == "develop" ]
    then
      echo "Branch is indeed develop"
      echo "Initiating pull"
      git pull --rebase origin develop
    else
      echo "Danger, you're in the wrong branch: $branch"
    fi
  elif [ $1 == "push_depricated" ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ $branch == "develop" ]
    then
      echo "Branch is indeed develop"
      echo "Initiating push"
      git push origin develop
    else
      echo "Danger, you're in the wrong branch: $branch"
    fi
  elif [ $1 == "fetch" ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ $branch == "develop" ]
    then
      echo "Danger, you're in the wrong branch: $branch"
    else
      echo "Fetching latest changes from develop"
      git fetch origin develop:develop
      echo "Updating $branch with latest changes"
      git rebase develop
    fi
  elif [ $1 == "pull_safe" ]
  then
    echo "Updating current branch safely with latest changes"
    git pull --ff-only origin $branch:$branch
  elif [ $1 == "latest_in_develop" ]
  then
    echo "Updating branch develop with latest changes"
    git fetch origin develop:develop
  elif [ $1 == "pr_update" ]
  then
    branch=$(git symbolic-ref --short -q HEAD)
    if [ ($branch == "develop") -o ($branch == "master") ]
    then
      echo "Danger, you're in the wrong branch: $branch"
    else
      echo "Please enter the name of the pull request branch:"
      read pr_branch
      if [ $pr_branch == $branch ]
      then
        echo "Updating pull request in $branch"
        git push origin $branch --force-with-lease
      else
        echo "Danger, your PR is in the wrong branch"
      fi
    fi
  else
    echo "Incorrect parameter provided. Options: pull_depricated | push_depricated | fetch | pr_update | latest_in_develop | pull_safe"
  fi
}
