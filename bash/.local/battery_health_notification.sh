#!/bin/bash

# Run this script as a cronjob every 5 minutes or so, to get notifications from
# the server machine to desktop when battery percentage goes below 20%.
# Cronjob line example:
# */5 * * * * /bin/bash $HOME/.local/battery_health_notification.sh

# Retrieve the current battery percentage
CABLE_PLUGGED=$(upower -i $(upower -e | grep line_power) | grep -A2 'line-power' | grep online | awk '{ print $2 }')
BATTERY_PERCENTAGE=$(upower -i $(upower -e | grep battery) | awk '/percentage:/ {print int($2)}')

# Set the threshold values for notification
LOW_THRESHOLD=20

# Define some values about host and remote machines
HOSTNAME=$(hostname)
NEPTUNE_IP='192.168.0.122'
REMOTE_USERNAME='chinmay'

# Define the summary and body messages
BATT_LOW_SUMMARY="Battery Low ($BATTERY_PERCENTAGE% remaining)"
BATT_LOW_BODY="Battery is running low on your <i>$HOSTNAME</i> server. Plug it in to avoid disruption of services."

# Check if the battery is unplugged and charge is lower than threshold
if [[ $CABLE_PLUGGED == 'no' && $BATTERY_PERCENTAGE -le $LOW_THRESHOLD ]]; then
    # Send low battery notification to remote machine
    ssh "$REMOTE_USERNAME@$NEPTUNE_IP" "DISPLAY=:0 notify-send --urgency=critical --expire-time=0 --icon=battery-caution --app-name=Supernova \"$BATT_LOW_SUMMARY\" \"$BATT_LOW_BODY\""
fi
