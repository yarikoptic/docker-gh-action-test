#!/usr/bin/env bash

set -ex

# refs:
# https://github.com/MicrosoftDocs/vsts-docs/issues/3784
# https://forums.docker.com/t/docker-for-mac-unattended-installation/27112

# why cask -> https://stackoverflow.com/questions/40523307/brew-install-docker-does-not-include-docker-engine/43365425#43365425
brew install --cask docker
echo "allow the app to run without confirmation"
xattr -d -r com.apple.quarantine /Applications/Docker.app

echo "preemptively do docker.app's setup to avoid any gui prompts"
sudo "$(which cp)" /Applications/Docker.app/Contents/Library/LaunchServices/com.docker.vmnetd /Library/PrivilegedHelperTools
sudo "$(which cp)" /Applications/Docker.app/Contents/Resources/com.docker.vmnetd.plist /Library/LaunchDaemons/
sudo "$(which chmod)" 544 /Library/PrivilegedHelperTools/com.docker.vmnetd
sudo "$(which chmod)" 644 /Library/LaunchDaemons/com.docker.vmnetd.plist
sudo "$(which launchctl)" load /Library/LaunchDaemons/com.docker.vmnetd.plist
