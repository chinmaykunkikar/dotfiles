#!/bin/bash

# Function to switch to TTY
switch_to_tty() {
  echo "Switching to TTY..."
  sudo systemctl stop display-manager.service
  sudo systemctl start getty@tty1.service
  echo "Switched to TTY"
}

# Function to switch to the display manager
switch_to_display_manager() {
  local display_manager=$(systemctl show display-manager.service --property=Description --value)

  if [[ -z "$display_manager" ]]; then
    echo "Failed to retrieve the display manager name. Aborting..."
    exit 1
  fi

  echo "Switching to $display_manager..."
  sudo systemctl stop getty@tty1.service
  sudo systemctl start display-manager.service
  echo "Switched to $display_manager"
}

# Check if systemctl command is available
if ! command -v systemctl >/dev/null 2>&1; then
  echo "Error: The script requires systemctl to work."
  echo "Please ensure that systemctl is available on your system."
  exit 1
fi

# Check current display manager and toggle accordingly
current_manager=$(systemctl show display-manager.service --property=ActiveState --value)
if [[ "$current_manager" == "active" ]]; then
  echo "Current display manager: $current_manager"
  switch_to_tty
else
  echo "Current display manager: $current_manager"
  switch_to_display_manager
fi
