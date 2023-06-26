# mkdir and cd into the directory
function mkcd() {
  if [ -d "$1" ]; then
    cd "$1" && echo "Changed to existing directory: $(tput bold)'$PWD'$(tput sgr0)"
  else
    mkdir -p "$@" && cd "$@" && echo "Changed to new directory: $(tput bold)'$PWD'$(tput sgr0)"
  fi
}

# cd working
function wk() {
  working="/home/$(whoami)/working"
  if [ -d "$working" ]; then
    if [[ "$1" == 'l' || "$1" == '--list' ]]; then
      ls "$working"
    elif [ "$1" ]; then
      cd "$working/$1"
    else
      cd "$working"
    fi
  else
    echo "Could not find ~/working directory."
  fi
}

# cd downloads
function dl() {
  downloads="/home/$(whoami)/Downloads"
  if [ -d "$downloads" ]; then
    if [[ "$1" == 'l' || "$1" == '--list' ]]; then
      ls "$downloads"
    else
      cd "$downloads"
    fi
  else
    echo "Could not find ~/Downloads directory."
  fi
}

