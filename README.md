# dotfiles

> macOS configurations, managed with [GNU Stow](https://www.gnu.org/software/stow/).

The `darwin` branch has macOS configs. The `fedora` branch has the old Linux/KDE setup.

Each directory is a stow package. Stow creates symlinks from the package contents to `$HOME`, mirroring the directory structure.

## Packages

| Package | What's in it |
| ------- | ------------ |
| btop | System monitor preferences |
| gh | GitHub CLI config |
| ghostty | Ghostty terminal (colors, keybindings, shell integration) |
| git | Git config with [delta](https://github.com/dandavison/delta) pager, aliases, expanded global gitignore, and [git-delete-branches](git/.config/git/git-delete-branches) (fzf-powered branch cleanup) |
| nano | Syntax highlighting |
| tmux | Catppuccin theme, TPM plugins, `C-Space` prefix |
| wezterm | Custom tab bar, SSH exec domains, command palette, git/package-script runners |
| zed | Editor settings and keymap |
| zsh | oh-my-zsh, fzf (custom theme), bat, zoxide, fnm with auto-switch |

## Key tools

The [Brewfile](Brewfile) has the full list. Some highlights:

**Shell**: zsh, fzf, bat, eza, zoxide, ripgrep, git-delta, fd (via fzf)

**Dev**: fnm, bun, node, pyenv, uv, pipx, supabase, docker, biome

**Terminals**: Ghostty, WezTerm

**Editors**: Zed, Cursor (VS Code)

**Apps**: Raycast, Maccy, LocalSend, OBS, CoconutBattery, noTunes

## Setup

Clone and stow:

```console
git clone https://github.com/chinmaykunkikar/dotfiles ~/.dotfiles
cd ~/.dotfiles

brew install stow
stow --verbose=1 --target="$HOME" */
```

Or pick specific packages:

```console
stow --verbose=1 --target="$HOME" git zsh wezterm ghostty
```

## Brewfile

The `Brewfile` tracks Homebrew taps, formulae, casks, and VS Code extensions. It lives at the repo root and is excluded from stowing.

```console
# Restore packages on a fresh machine
brew bundle --file=~/.dotfiles/Brewfile

# Update after installing or removing packages
brew bundle dump --file=~/.dotfiles/Brewfile --force
```
