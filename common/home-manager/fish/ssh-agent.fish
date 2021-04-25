#!/usr/bin/fish
#
# Fish script to run ssh-agent correctly, i.e. only start a new one when
# necessary. Drop it into ~/.config/fish/conf.d and forget about it.
#
# Uses ps and kill, everything else is done inside fish.
#
# Requires fish 2.3 for the string manipulation.
#
# Works with Fedora 26 and CentOS 7, for CentOS 6 you'll need a third party
# repo for fish anyway so make sure it's recent enough.
#
if status --is-interactive

  # Load the SSH environment variables
  if test -f ~/.ssh/environment
    source ~/.ssh/environment
  end

  # Check the environment variables are present
  if test \( "$SSH_AGENT_PID" != "" \) -a \( "$SSH_AUTH_SOCK" != "" \) -a \( -S "$SSH_AUTH_SOCK" \)
    # Check it's not pointing at GNOME askpass
    if string match -rv "/run/user/.*" "$SSH_AUTH_SOCK" >/dev/null
      # Check the agent's actually running
      if ps -p "$SSH_AGENT_PID" >/dev/null
        set -e SSH_ASKPASS
        exit
      end
    end
  end

  # If we get this far, something is wrong
  # Kill the existing agent process if possible
  if test "$SSH_AGENT_PID" != ""
    kill -s TERM "$SSH_AGENT_PID" 2>/dev/null
  end
  
  # Start up a new agent, set the environment variables, and store them
  # in the file for other shell instances
  set a (ssh-agent) >/dev/null
  set s (string match -r '.*=[^;]*' $a)
  rm ~/.ssh/environment 2> /dev/null
  for l in $s
    set v (string replace -r '=' ' ' $l)
    eval "set -x" $v 
    echo "set -x " $v >> ~/.ssh/environment
    ssh-add 2> /dev/null
  end
end
