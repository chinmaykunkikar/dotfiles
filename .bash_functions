# mkdir and cd into the directory
function mkcd() {
  mkdir -p "$@" && cd "$@"
  echo "Changed to new directory from $(tput bold)'$(echo $OLDPWD)' -> '$(pwd)'$(tput sgr0)"
}

# cd working
function wk() {
  working=/home/$(whoami)/working
  if [ -d $working ]; then
    if [[ "$1" == '-l' || "$1" == '--list' ]]; then
      ls -l $working
    elif [ "$1" ]; then
      for subdir in "$1"; do
        echo $subdir
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
    if [[ "$1" == '-l' || "$1" == '--list' ]]; then
      ls -l $downloads
    else
      cd ${downloads}
    fi
  else
    echo -e "Could not find ~/Downloads directory."
  fi
}
