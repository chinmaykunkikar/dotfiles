# mkdir and cd into the directory
function mkcd() {
  mkdir -p "$@" && cd "$@"
}

# install
function innstall() {
  sudo apt install "$@"
}

# cd working
function wk() {
if [ -d "/home/chinmay/working" ]; then
  cd ~/working/"$1"
else
  echo -e "Cannot find ~/working directory."
fi
}

# reposync
#function repo() {
#if [ $1 == "sync" ]; then
#  ~/bin/repo sync -c -j8 --force-sync --no-clone-bundle --no-tags
#else
#  ~/bin/repo
#fi
#}

# cd downloads
function dl() {
  cd ~/Downloads
}
