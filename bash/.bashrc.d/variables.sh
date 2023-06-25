# XDG defaults
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Config directories according to XDG defaults
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export KDEHOME="$XDG_CONFIG_HOME"/kde
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv
