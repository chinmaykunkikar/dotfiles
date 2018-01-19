# Custom aliases
alias la='ls -A'                     # ls without . and ..
alias ls='ls --block-size=M --color' # Normal ls
alias lx='ls -lXB'                   # Sort by extension.
alias lk='ls -lSr'                   # Sort by size, biggest last.
alias cs='reset && ls'               # Reset terminal before ls
alias rm='rm -rf'                    # #YOLO
alias mkdir='mkdir -p'               # Of course make subdirectories. Duh.
alias apt-get='apt'                  # Get past apt-get now
eval "$(hub alias -s)"               # https://github.com/github/hub/blob/master/README.md
