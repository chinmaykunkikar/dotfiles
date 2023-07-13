# Common
alias rm='rm --force --recursive'
alias ls='exa --long --all --no-user --group-directories-first --git --sort=ext --sort=size --header'
alias l='exa --long --all --no-user --group-directories-first --git --sort=ext --sort=size --header'
alias g='git'
alias open='xdg-open'
alias code='code .'
alias xx='exit'

# DNF package manager
alias dnfu='sudo dnf upgrade'
alias dnfi='sudo dnf install'
alias dnfr='sudo dnf remove'

# Flatpak package manager
alias flup='flatpak update --assumeyes'
alias flin='flatpak install --assumeyes'
alias flun='flatpak uninstall --assumeyes'

# Node package manager (NPM)
alias npmi='npm install'
alias npmr='npm uninstall'
alias npmup='npx npm-check-updates'

# Server related
alias srvc='ssh -i ~/.ssh/supernova chinmay@192.168.0.123'
