
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=$PATH:$(brew --prefix)/bin

# fnm — just add binary to PATH; shell integration is in .zshrc
FNM_PATH="/Users/chinmay/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/chinmay/Library/Application Support/fnm:$PATH"
fi

# Created by `pipx` on 2024-10-04 14:39:00
export PATH="$PATH:/Users/chinmay/.local/bin"

# For pyenv 12-09-2025
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# For Java 25-09-2025
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home

# For Android sdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

