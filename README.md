# 📁 `/home/chinmay/.dotfiles`

> 💻 _"After countless rounds of distro hopping, I finally found the one—the KDE spin of Fedora!"_ - me 😄

I have carefully curated a collection of personalized configurations to suit my needs. I use GNU Stow to manage these files by creating symbolic links, or "packages," that connect them to their respective paths in the target directory (`/home/chinmay`).

The use of `stow` for file management is guided by the principle of maintaining a structured organization. Each package represents a specific configuration, and its files are organized within dedicated directories that mirror the structure of the target directory.

## 📦 My Packages

| Package  | Description                                                                            |
| -------- | -------------------------------------------------------------------------------------- |
| bash     | Bash-related configs, including aliases, shell options, exports, and custom functions. |
| gh       | GH config                                                                              |
| git      | Git-related configs, such as the global `gitconfig` and `gitignore` files.             |
| htop     | Configuration file for `htop` system monitor (`htoprc`).                               |
| btop     | Configuration file for `btop` system monitor (`btop.conf`).                            |
| kde      | Custom KDE app configs and preferences.                                                |
| sudoers  | Excluded from stowing; contains the config for passwordless sudo.                      |
| switchdm | Custom script to switch between desktop manager and tty mode.                          |

## 🚀 Stow 'em!

1. Clone this repository to `~/.dotfiles`:

   ```console
   git clone https://github.com/chinmaykunkikar/dotfiles ~/.dotfiles
   ```

2. Install `stow` using a package manager. `dnf` in case of Fedora:

   ```console
   sudo dnf install stow
   ```

3. Stow the files to create the symlinks:

   ```console
   stow --verbose=1 --dir=/home/$(whoami)/.dotfiles --stow --target=/home/$(whoami) */
   ```

✨ Voilà! Happy configuring! 🎉
