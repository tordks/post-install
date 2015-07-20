#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <hewittsamuel@gmail.com>
#   Ravikishore Kommajosyula <ravikishorek@gmail.com>
#
# Description:
#   A post-installation bash script for Ubuntu (14.04)
#
# Legal Stuff:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

echo ''
echo '#-------------------------------------------#'
echo '#     Ubuntu 14.04 Post-Install Script      #'
echo '#-------------------------------------------#'
sleep 2
#----- FUNCTIONS -----#

# SYSTEM UPGRADE
function sysupgrade {
# Perform system upgrade

echo ''
echo 'SYSTEM UPGRADE'
sleep 1
# Update repository information
echo 'Updating repository information...'
echo 'Requires root privileges:'
sudo apt-get update
# Dist-Upgrade
echo 'Performing system upgrade...'
sudo apt-get dist-upgrade -y
echo 'Done.'
}

# INSTALL APPLICATIONS
function favourites {
# Install Favourite Applications
echo ''
echo 'Installing selected favourite applications...'
echo ''
echo 'Current package list:
vlc
'
sleep 1
# Feel free to change to whatever suits your preferences.
sudo apt-get install -y --no-install-recommends vlc
echo 'Done.'
}

# INSTALL SYSTEM TOOLS
function system {
echo ''
echo 'Installing favourite system utilities...'
echo ''
echo 'Current package list:
aptitude
dconf-tools
ssh
synaptic'
echo ''
sleep 1
# Positive action
echo 'Requires root privileges:'
# Feel free to change to whatever suits your preferences.
sudo apt-get install -y --no-install-recommends aptitude dconf-tools ssh  synaptic
echo 'Done.'
}

# INSTALL DEVELOPMENT TOOLS
function development {
echo ''
echo 'Installing development tools...'
echo ''
echo 'Current package list:
build-essential
git
gitk
g++
libcr-dev
python-numpy
python-scipy
python-matplotlib
ipython
ipython-notebook
vim
scons
lapack
cmake'
echo ''
sleep 1
sudo apt-get install -y build-essential git gitk  g++ libcr-dev python-numpy python-scipy python-matplotlib ipython ipython-notebook vim scons liblapack-dev cmake
}


# INSTALL GNOME COMPONENTS
function gnome {
echo ''
echo '1. Add GNOME3 PPA'
echo '4. Install GNOME Shell'
echo '5. Install extra GNOME components'
echo '6. Configure GNOME Shell Specific Settings'
# Add repository
echo 'Adding GNOME3 PPA to software sources...'
echo 'Requires root privileges:'
sudo add-apt-repository -y ppa:gnome3-team/gnome3
# Update repository information
echo 'Updating repository information...'
sudo apt-get update
# Upgrade system
echo 'Performing system upgrade...'
sudo apt-get dist-upgrade -y
echo 'Done.'
echo ''
# Install GNOME Shell
echo 'Installing GNOME Shell...'
echo 'Requires root privileges:'
sudo apt-get install -y gnome-shell gnome-shell-extensions gnome-session
echo 'Done.'
echo ''
# Font Settings
echo 'Setting font preferences...'
echo 'Requires the "Cantarell" font.'
# Check if "fonts-cantarell" package is installed
PACKAGE=$(dpkg-query -W --showformat='${Status}\n' fonts-cantarell | grep "install ok installed")
echo "Checking if installed..."
if [ "" == "$PACKAGE" ]; then
    echo 'Cantarell is not installed.'
    echo 'Installing... '
    echo 'Requires root privileges:'
    sudo apt-get install -y fonts-cantarell
    echo 'Done. '
else
    echo 'Cantarell is installed, proceeding... '
fi
# Settings font settings
gsettings set org.gnome.desktop.interface text-scaling-factor '1.0'
gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 10'
gsettings set org.gnome.desktop.interface font-name 'Cantarell 10'
gsettings set org.gnome.nautilus.desktop font 'Cantarell 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 10'
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'slight'
echo 'Done. '
# GNOME Shell Settings
echo 'Setting GNOME Shell window button preferences...'
gsettings set org.gnome.shell.overrides button-layout ':close'
echo 'Done. '
echo ''
}


# INSTALL DESIGN TOOLS
function design {
echo ''
echo 'Installing design tools...'
echo ''
echo 'Current package list:
gimp
gimp-plugin-registry
inkscape'
echo ''
# Feel free to change to whatever suits your preferences.
sudo apt-get install -y  gimp gimp-plugin-registry icontool inkscape
}


# THIRD PARTY APPLICATIONS
function thirdparty {
echo 'Installing third party applications...? '
echo ''
echo 'Current package list:
Google Chrome 
Steam'
echo ''
#
# Google Chrome 
#
echo 'Downloading Google Chrome...'
# Download Debian file that matches system architecture
if [ $(uname -i) = 'i386' ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
elif [ $(uname -i) = 'x86_64' ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi
# Install package(s)
echo 'Installing Google Chrome...'
echo 'Requires root privileges:'
sudo dpkg -i google-chrome*.deb
sudo apt-get install -fy
# Cleanup and finish
rm google-chrome*.deb
cd
echo 'Done.'
#
# Google Talk Plugin
echo 'Downloading Google Talk Plugin...'
# Download Debian file that matches system architecture
if [ $(uname -i) = 'i386' ]; then
    wget https://dl.google.com/linux/direct/google-talkplugin_current_i386.deb
elif [ $(uname -i) = 'x86_64' ]; then
    wget https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb
fi
#
# Steam
#
echo 'Downloading Steam...'
cd $HOME/Downloads
# Download Debian file that matches system architecture
if [ $(uname -i) = 'i386' ]; then
    wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
elif [ $(uname -i) = 'x86_64' ]; then
    wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
fi
# Install package(s)
echo 'Installing Steam...'
echo 'Requires root privileges:'
sudo dpkg -i steam*.deb
sudo apt-get install -fy
# Cleanup and finish
rm steam*.deb
cd
echo 'Done.'

# CLEANUP SYSTEM
function cleanup {
echo ''
echo '1. Remove unused pre-installed packages'
echo '2. Remove old kernel(s)'
echo '3. Remove orphaned packages'
echo '4. Remove leftover configuration files'
echo '5. Clean package cache'
echo 'Removing selected pre-installed applications...'
echo 'Requires root privileges:'
sudo apt-get purge landscape-client-ui-install ubuntuone-control-panel* overlay*
echo 'Done.'
# Remove Old Kernel
echo 'Removing old Kernel(s)...'
echo 'Requires root privileges:'
sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | grep -v linux-libc-dev | xargs sudo apt-get -y purge
echo 'Done.'
# Remove Orphaned Packages
echo 'Removing orphaned packages...'
echo 'Requires root privileges:'
sudo apt-get autoremove -y
echo 'Done.'
# Remove residual config files?
echo 'Removing leftover configuration files...'
echo 'Requires root privileges:'
sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep '^rc' | tr -s ' ' | cut -d ' ' -f 2)
echo 'Done.'
# Clean Package Cache
echo 'Cleaning package cache...'
echo 'Requires root privileges:'
sudo apt-get clean
echo 'Done.'
}

#----- MY MAIN FUNCTION ----#
function my_main {
echo ''
echo 'Running post-install package'
sysupgrade
favourites
system
development # Install Dev Tools
design # Install Design Tools
gnome # Install GNOME components
codecinstall # Install Ubuntu Restricted Extras
thirdparty # Install Third-Party Applications
customize # Customize system
cleanup
echo ''
echo 'Post-install package completed'
echo 'Please restart your system'
}

#----- RUN MY MAIN FUNCTION -----#
my_main

#END OF SCRIPT
