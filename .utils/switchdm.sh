#!/bin/bash

# Function to switch to TTY
switch_to_tty() {
  local tty_number
  tty_number=$(basename "$(tty)" | sed 's/tty//')
  echo "Switching to TTY${tty_number}..."
  sudo systemctl stop display-manager.service
  sudo systemctl start getty@tty${tty_number}.service
  sudo chvt "${tty_number}"
  echo "Switched to TTY${tty_number}"
}

# Function to switch to the display manager
switch_to_display_manager() {
  echo "Switching to display manager..."
  sudo systemctl stop getty@tty1.service
  sudo systemctl start display-manager.service
  sudo chvt 1
  echo "Switched to display manager"
}

# Check if systemctl command is available
if ! command -v systemctl >/dev/null 2>&1; then
  echo "Error: The script requires systemctl to work."
  echo "Please ensure that systemctl is available on your system."
  exit 1
fi

# Check if current session is a TTY
if [[ $(tty) =~ /dev/tty([0-9]+) ]]; then
  current_tty=${BASH_REMATCH[1]}
  echo "Already in a TTY session (TTY${current_tty}). Switching to the display manager..."
  #switch_to_display_manager
  exit 0
fi

# Check current display manager and toggle accordingly
current_manager=$(systemctl show display-manager.service --property=ActiveState --value)
if [[ "$current_manager" == "active" ]]; then
  switch_to_tty
else
  switch_to_display_manager
fi
