# Common
alias rm='rm --force --recursive'
alias ls='exa --long --all --no-user --group-directories-first --git --sort=ext --sort=size --header'
alias l='exa --long --all --no-user --group-directories-first --git --sort=ext --sort=size --header'
alias g='git'
alias open='xdg-open'
alias code='code .'
alias xx='exit'
alias sudo='sudo '

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

# Network
alias sshs='ssh chinmay@192.168.0.123'
alias sshw='ssh chinmay@192.168.0.122'
alias eip='dig +short myip.opendns.com @resolver1.opendns.com'

# Connect to protonvpn (protonvpn.com/support/linux-vpn-tool)
alias vpnct='protonvpn-cli connect'
alias vpndt='protonvpn-cli disconnect'
alias vpnst='protonvpn-cli status'
