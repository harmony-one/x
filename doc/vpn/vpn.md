## VPN with Traffic Congestion Simulation

Accessing or configuring the VPN requires special credentials. Request for credentials using [this document](https://docs.google.com/document/d/1d9RV-u4aDJSXVJ42ea4ptMmzFehtXvS27pgjkHb491Q/edit?usp=sharing)

### Usage

You can manually set up the VPN with as a Cisco IPSec VPN. Both macOS and iOS have native support for the protocol. 

Alternatively, you may add the VPN configuration as a "profile" in iOS or macOS. Download and double click the .mobileconfig profile after you are granted with access to the credentials.

- On macOS, you can find the profile under `Settings` -> `Privacy and Security` -> `Profiles`. Double click the profile and approve the installation. You can then find the VPN under `Settings` -> `VPN`
- On iOS, the easiest way to install is by airdropping the profile to the mobile device, then click install after you receive the profile. Next, go to `Settings`, you can then find the pending profile on the top of the screen. Tap the profile and approve it for installation. You can then find the VPN under `Settings` -> `VPN`

### Congestion Settings

The current settings are:

- **Delay**: 500ms with 400ms jittering per packet, following normal distribution. The packet delay is 50% correlated to previous packet, which means a slower packet is more likely to lead to another slow packet
- **Loss**: 30%, with 25% correlation to previous packet, which means it is more likely to consecutively lose packets instead of randomly and independently
- **Bandwidth**: Each connection is capped at 8mbps

These settings can be changed for all users using the network emulator at the VPN server. See instructions below

### Server Configuration

#### VPN Instance

You can login at the server using the GCP credentials described in the credential document.

The docker instance for the IPSec / IKEv2 VPN is named `ipsec-vpn-server`. It is based on the image `hwdsl2/ipsec-vpn-server`, with environment variable files and various scripts at `/opt/vpn`, and auto-generated configuration files at `/opt/vpn/data`

- Environment variables: `/opt/vpn/env`
- Start VPN instance: `run.sh` at current directory `/opt/vpn/`
- Stop VPN instance: `/opt/vpn/stop.sh`
- View logs: `/opt/vpn/log.sh`

#### Traffic congestion simulation

We use `netem` for [traffic emulation](https://man7.org/linux/man-pages/man8/tc-netem.8.html)  after considering multiple alternatives (see below). The tool is part of [traffic control](https://man7.org/linux/man-pages/man8/tc.8.html) `tc` , each effect needs to be added as a "queuing discipline" (qdisc)

The current three rules are added under handle `1:` and `2:` and `3:`, where `1:` is the child of `root` and higher numbers are children of the preceding number. The exact commands used are

- `sudo tc qdisc add dev docker0 root handle 1: netem delay 500ms 400ms 50 distribution normal`
- `sudo tc qdisc add dev docker0 parent 1: handle 2: netem loss 30% 25%`
- `sudo tc qdisc add dev docker0 parent 2: handle 3: netem rate 8mbit`

Variations of these commands can be found in the link above. To change any rule, use `sudo tc qdisc change docker0 handle <handle_id> ....`. To delete, use `sudo tc qdisc rm docker0 handle <handle_id>`

Here `docker0` represents the network created by Docker engine.

#### Alternatives considered

- [GCP Cloud Armor](https://cloud.google.com/armor/docs/rate-limiting-overview): A sophisticated system for network throttling and traffic control, with nice UI and documentations. It is more powerful than other alternative because we can control the traffic at both Layer 3 and Layer 7 levels, and we can make specific rules based on user agents, types of clients, or IP addresses. It is also easy to configure - we may put a standard VPN instance behind a Cloud Armor configuration and simulate congestion outside the instance. However, setting it up requires too much training and overhead. We can move to this solution if the simpler ones could not meet our needs.
- [pumba](https://github.com/alexei-led/pumba): A Docker-based network emulator that can be attached and configured for specific containers. But fundamentally, pumba relies on `netem` to emulate traffic congestion. This tool may be useful when we have multiple VPN servers running at the same server instance, emulating different traffic pattern. 