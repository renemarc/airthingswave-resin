#!/bin/bash
#
# Startup script
#

# Optimize shell for safety.
set -o errexit -o noclobber -o nounset -o pipefail

# Replace placeholders found in configuration file with environment variables
envsubst < config.yaml > airthingswave-mqtt.yaml

# Prevent container from exiting
journalctl --follow
