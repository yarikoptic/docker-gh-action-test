#!/usr/bin/env bash

set -ex

# from:
# https://github.com/docker/roadmap/issues/80#issuecomment-633613240
# and update
# https://github.com/docker/for-mac/issues/2359#issuecomment-853420567

# refs:
# https://github.com/MicrosoftDocs/vsts-docs/issues/3784
# https://forums.docker.com/t/docker-for-mac-unattended-installation/27112

# why cask -> https://stackoverflow.com/questions/40523307/brew-install-docker-does-not-include-docker-engine/43365425#43365425
brew install --cask docker
echo "allow the app to run without confirmation"
xattr -d -r com.apple.quarantine /Applications/Docker.app

echo "preemptively do docker.app's setup to avoid any gui prompts"
sudo cp /Applications/Docker.app/Contents/Library/LaunchServices/com.docker.vmnetd /Library/PrivilegedHelperTools

# get vmnetd version number
defaults read /Applications/Docker.app/Contents/Info.plist VmnetdVersion

# the plist we need used to be in /Applications/Docker.app/Contents/Resources, but
# is now dynamically generated. So we dynamically generate our own
sudo tee "/Library/LaunchDaemons/com.docker.vmnetd.plist" > /dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.docker.vmnetd</string>
	<key>Program</key>
	<string>/Library/PrivilegedHelperTools/com.docker.vmnetd</string>
	<key>ProgramArguments</key>
	<array>
		<string>/Library/PrivilegedHelperTools/com.docker.vmnetd</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>Sockets</key>
	<dict>
		<key>Listener</key>
		<dict>
			<key>SockPathMode</key>
			<integer>438</integer>
			<key>SockPathName</key>
			<string>/var/run/com.docker.vmnetd.sock</string>
		</dict>
	</dict>
	<key>Version</key>
	<string>59</string>
</dict>
</plist>

EOF

sudo chmod 544 /Library/PrivilegedHelperTools/com.docker.vmnetd
sudo chmod 644 /Library/LaunchDaemons/com.docker.vmnetd.plist
sudo launchctl load /Library/LaunchDaemons/com.docker.vmnetd.plist

sleep 5
