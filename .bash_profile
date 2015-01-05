
[[ -s "$HOME/.exports" ]]   && source "$HOME/.exports" # Load the default .exports
[[ -s "$HOME/.functions" ]] && source "$HOME/.functions" # Load the default .functions
[[ -s "$HOME/.profile" ]]   && source "$HOME/.profile" # Load the default .profile
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# include all homebrew bash completions
for f in /usr/local/etc/bash_completion.d/*; do source $f; done

# Autocomplete SSH hosts
SSH_KNOWN_HOSTS=( $(cat ~/.ssh/known_hosts | \
  cut -f 1 -d ' ' | \
  sed -e s/,.*//g | \
  uniq | \
  egrep -v [0123456789]) )
SSH_CONFIG_HOSTS=( $(cat ~/.ssh/config | grep "Host " | grep -v "*" | cut -f 2 -d ' ') )

complete -o default -W "${SSH_KNOWN_HOSTS[*]} ${SSH_CONFIG_HOSTS[*]}" ssh

# Default prompt: pwd {git branch} $
GIT_PS1_SHOWDIRTYSTATE=true
PS1='\[\033[01;33m\]\w\[\033[00m\]\[\033[01;31m\]$(__git_ps1 " {%s}")\[\033[00m\]\$ '
