# mkdir and cd into the directory
mkcd() {
  if [ -d "$1" ]; then
    cd "$1" && echo "Changed to existing directory: $(tput bold)'$PWD'$(tput sgr0)"
  else
    mkdir -p "$@" && cd "$@" && echo "Changed to new directory: $(tput bold)'$PWD'$(tput sgr0)"
  fi
}

# cd working
function wk() {
  working=/home/$(whoami)/working
  if [ -d $working ]; then
    if [[ "$1" == 'l' || "$1" == '--list' ]]; then
      ls $working
    elif [ "$1" ]; then
      for subdir in "$1"; do
        cd ${working}/${subdir}
      done
    else
      cd ${working}
    fi
  else
    echo -e "Could not find ~/working directory."
  fi
}

# cd downloads
function dl() {
  downloads=/home/$(whoami)/Downloads
  if [ -d $downloads ]; then
    if [[ "$1" == 'l' || "$1" == '--list' ]]; then
      ls -l $downloads
    else
      cd ${downloads}
    fi
  else
    echo -e "Could not find ~/Downloads directory."
  fi
}
