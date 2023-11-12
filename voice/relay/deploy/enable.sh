#!/bin/sh
sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/node
sudo cp voice-ai-relay.service /etc/systemd/system/voice-ai-relay.service
sudo systemctl start voice-ai-relay
sudo systemctl enable voice-ai-relay
systemctl status voice-ai-relay
