# XILINX SOFTWARE CATALOG IN A CONTAINER
## 📝｜ABSTRACT
This is a tool for installing [Xilinx](https://www.xilinx.com/) software products in a containerised *and potentially emulated* environment on everything; among other things, Apple Macs *(Arm®-based Apple® silicon & Intel®)*. The tool and the project as a whole are not associated with Xilinx®.
### FEATURES
- universal containerised installation 
- processor architecture agnostic
- operating system agnostic
- rosetta acceleration where applicable
- gui compatibility
- networking
- usb passthrough
- shared directory with host machine
- declarativity
- reproducibility
## 🌱｜INSTALLATION
### 🚨｜GENERAL PREREQUISITES
Posses an AMD Xilinx account; accounts can be created [on the official AMD website](https://www.amd.com/en/registration/create-account.html).

<!--INSTALLATION METHODS-->
<details><summary><b>⚡｜AUTOMATIC; RECOMMENDED ROUTE</b></summary>

**N.B.**: The automatic installation script uses an automated adaption of the nix [nix](https://nixos.org/guides/how-nix-works) installation method outlined below to achieve maximum reproducibility in a declarative fashion.

- Dowload the [script `run.sh`](https://github.com/pelasgus/xilinx/releases/latest)
- Navigate to `Downloads` directory; if the file was stored in a different path, update accordingly.
```
cd Downloads
```
- Make the script executable:
```
sudo chmod +x script.sh
```
- Run the script
```
./script.sh
```
</details>
<details><summary><b>🔩｜MANUAL</b></summary>
<details><summary><b>🔩｜MANUAL | NIX</b></summary>

- Install Nix via the [recommended multi-user installation](https://nixos.org/manual/nix/stable/installation/installing-binary#multi-user-installation); read more on [how it is done](https://nixos.org/manual/nix/stable/installation/installing-binary#macos-installation)
```bash
curl -L https://nixos.org/nix/install | sh
```
**N.B.**: For future reference; To upgrade the local nix installation run the [following](https://nixos.org/manual/nix/stable/installation/upgrading#macos-multi-user) if need be:
```bash
sudo nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable ;
sudo launchctl remove org.nixos.nix-daemon ;
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```
**N.B.**: To uninstall Nix follow the [instructions](https://nixos.org/manual/nix/stable/installation/uninstall#macos) provided with the manual.
- Enable Nix's Experimental Features; specifically, `nix command` and **flake** support.

**N.B.**: This step is optional but does provide some quality of life improvements.
```bash
cat <<EOF > ~/.config/nix/nix.conf
experimental-features = nix-command flakes
EOF
```
<details><summary><b>🔩｜MANUAL | NIX | SHELL</b></summary>

</details>
<details><summary><b>🔩｜MANUAL | NIX | FLAKE</b></summary>

</details>

</details>
<details><summary><b>🔩｜MANUAL | HOMEBREW</b></summary></details>
<details><summary><b>🔩｜MANUAL | SOURCE</b></summary></details>
<details><summary><b>🔩｜MANUAL | GUI | DOCKER DESKTOP</b></summary>
- Install XQuartz
- Install [Docker®](https://www.docker.com/products/docker-desktop/s)
You first need to install [XQuartz](https://www.xquartz.org/) and [Docker®](https://www.docker.com/products/docker-desktop/) (make sure to choose "Apple Chip" instead of "Intel Chip"). Then you need to
* open Docker, 
* go to settings,
* check "Use Virtualization Framework",
* uncheck "Open Docker Dashboard at startup",
* go to "Resources"
* increase Swap to 2GB (if synthesis fails, you may need to increase Memory or Swap)
* go to "Features in Development" and
* check "Use Rosetta for x86/amd64 emulation on Apple Silicon".

**N.B.**: These steps are mandatory and thus, cannot be skipped!

## How it works
### Docker & XQuartz
This script creates an x64 Docker container running Linux® that is accelerated by [Rosetta 2](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment) via the Apple Virtualization framework. The container has all the necessary libraries preinstalled for running Vivado. It is installed automatically given an installer file that the user must provide. GUI functionality is provided by XQuartz.

### USB connection
A drawback of the Apple Virtualization framework is that there is no implementation for USB forwarding as of when I'm writing this. Therefore, these scripts set up the [Xilinx Virtual Cable protocol](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/644579329/Xilinx+Virtual+Cable). Intended to let a computer connect to an FPGA plugged into a remote computer, it allows for the host system to run an XVC server (in this case a software called [xvcd](https://github.com/tmbinc/xvcd) by Felix Domke), to which the docker container can connect.

`xvcd` is contained in this repository, but with slight changes to make it compile on modern day macOS (compilation requires libusb and libftdi installed via homebrew, though there is a compiled version included). It runs continuously while the docker container is running.

This version of `xvcd` only supports the `FT2232C` chip. There are forks of this software supporting other boards such as [xvcserver by Xilinx](https://github.com/Xilinx/XilinxVirtualCable).

### Environment variables
A few environment variables are set such that

1. the GUI is displayed correctly.
2. Vivado doesn't crash (maybe due to emulation?)
</details>
<details><summary><b>🔩｜MANUAL | GUI | UTM</b></summary>
UTM is essentially a mac wrapper around QEMU that provides a more easy to follow installation procedure.
Download file or
OPTIONs
- emulate
- x86_64
- Match specs requirements for your app of choice
- Use minimum amount of disk space as it wont really be utilised.
</details>
</details>


## 🧰｜USAGE

## ⚖️｜LICENSE
The repository's contents are licensed under the latest version of the [GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.html).

## 📖｜ACKNOWLEDGEMENTS
### ACKNOWLEDGEMENTS | LEGAL
- Vivado and Xilinx are trademarks of Xilinx, Inc.
- Arm is a registered trademark of Arm Limited (or its subsidiaries) in the US and/or elsewhere.
- Apple, Mac, MacBook, MacBook Air, macOS and Rosetta are trademarks of Apple Inc., registered in the U.S. and other countries and regions.
- Docker and the Docker logo are trademarks or registered trademarks of Docker, Inc. in the United States and/or other countries. Docker, Inc. and other parties may also have trademark rights in other terms used herein.
- Intel and the Intel logo are trademarks of Intel Corporation or its subsidiaries.
- Linux® is the registered trademark of Linus Torvalds in the U.S. and other countries.
- Oracle, Java, MySQL, and NetSuite are registered trademarks of Oracle and/or its affiliates. Other names may be trademarks of their respective owners.
- X Window System is a trademark of the Massachusetts Institute of Technology.
### ACKNOWLEDGEMENTS | TECHNICAL
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050; nix-darwin
- https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8; script automation
- https://github.com/NelsonDane/vivado-on-silicon-mac/tree/main