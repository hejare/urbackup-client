#!/bin/sh

# Make sure that the environment variables are set correctly 
VERBOSITY="${VERBOSITY:-info}"
INTERNET_MODE_ENABLED="${INTERNET_MODE_ENABLED:-false}"

if [ "$INTERNET_MODE_ENABLED" = "true" ]; then
    if [ -z "$INTERNET_SERVER" ]; then
        echo "The environment variable INTERNET_SERVER must be set when INTERNET_MODE_ENABLED is set to true."
        exit 1
    fi
    if [ -z "$INTERNET_AUTHKEY" ]; then
        echo "The environment variable INTERNET_AUTHKEY must be set when INTERNET_MODE_ENABLED is set to true."
        exit 1
    fi
    INTERNET_SERVER_PORT="${INTERNET_SERVER_PORT:-55415}"
fi

# Start the backup service so that we may use the control application to set the configuration
urbackupclientbackend -v $VERBOSITY &
PID=$!

# Wait for the service to start by watching the log file
( tail -f -n0 --retry /var/log/urbackupclient.log & ) | grep -q "Started UrBackupClient Backend"

# Set the configurations
if ! [ -z "$COMPUTERNAME" ]; then
    urbackupclientctl set-settings -k computername -v $COMPUTERNAME
fi

if [ "$INTERNET_MODE_ENABLED" = "true" ]; then
    urbackupclientctl set-settings -k internet_mode_enabled -v true -k internet_server -v $INTERNET_SERVER -k internet_server_port -v $INTERNET_SERVER_PORT -k internet_authkey -v $INTERNET_AUTHKEY
fi
# [ ! -e /etc/default/urbackupclient ] || sed -i 's/INTERNET_ONLY=false/INTERNET_ONLY=true/' /etc/default/urbackupclient

# Add the default directory to backup unless it's already there
mkdir -p /backup
if ! ( urbackupclientctl list | grep -q /backup ) then 
    urbackupclientctl add-backupdir --path /backup
fi

# Wait for Ctrl-C
while true; do sleep 1d; done