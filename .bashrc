# Add this to your ~/.bashrc

# Soucre dotfiles
# ~/.dotfiles have modular files for aliases, git aliases,
# custom functions, archival functions, environment variables

if [ -f ~/.dotfiles/.bash_aliases ]; then
    source ~/.dotfiles/.bash_aliases
fi

if [ -f ~/.dotfiles/.archive ]; then
    source ~/.dotfiles/.archive
fi

if [ -f ~/.dotfiles/.envars ]; then
    source ~/.dotfiles/.envars
fi

if [ -f ~/.dotfiles/.git_aliases ]; then
    source ~/.dotfiles/.git_aliases
fi

if [ -f ~/.dotfiles/.functions ]; then
    source ~/.dotfiles/.functions
fi
