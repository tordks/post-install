#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

# Description:
#   A post-installation bash script for Ubuntu (14.04)

#TODO: Finish functions
#TODO: Document packages
#TODO: Fix Headings/reformat
#TODO: Read gnome stuff
#TODO: Add options/bundles.
#TODO: Add customizations
#TODO: Koble opp mot stud-serveren
#TODO: RSS-feed application

echo ''
echo '#------------------------------#'
echo '#     Post-Install Script      #'
echo '#------------------------------#'
echo ''
sleep 2

#####################
#  SYSTEM UPGRADE   #
#####################

function sysupgrade {
echo 'SYSTEM UPGRADE'
sudo apt-get update
sudo apt-get dist-upgrade -y
}

##########################
#  INSTALL APPLICATIONS  #
##########################
#TODO: Minetest, 
function applications {
echo ''
echo 'Installing selected favourite applications'
echo ''
echo 'Current package list:
Vlc
Skype
Wine
Indicator sticknotes
Nitro Task Manager
Tor browser
Google Chrome 
Steam
.Zapp
Vim'
sudo apt-get install -y --no-install-recommends vlc skype wine

# Sticknotes, Nitro, Tor
sudo add-apt-repository ppa:umang/indicator-stickynotes
sudo add-apt-repository ppa:cooperjona/nitrotasks
sudo add-apt-repository ppa:upubuntu-com/tor64
sudo apt-get update
sudo apt-get install indicator-stickynotes
sudo apt-get install nitrotasks
sudo apt-get install tor-browser

#To remove tor:
#sudo add-apt-repository --remove ppa:upubuntu-com/tor-bundle
#sudo apt-get remove tor-browser
#sudo apt-get update 


#------------------#
#  Google Chrome   #
#------------------#

echo 'Downloading Google Chrome'

# Download Debian file that matches system architecture
if [ $(uname -i) = 'i386' ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
elif [ $(uname -i) = 'x86_64' ]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi


# Install package(s)
echo 'Installing Google Chrome'
sudo dpkg -i google-chrome*.deb
sudo apt-get install -fy

# Cleanup and finish
rm google-chrome*.deb
cd

#---------#
#  Steam  #
#---------#

echo 'Downloading Steam'
cd $HOME/Downloads
# Download Debian file that matches system architecture
if [ $(uname -i) = 'i386' ]; then
    wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
elif [ $(uname -i) = 'x86_64' ]; then
    wget http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
fi

# Install package(s)
echo 'Installing Steam...'
sudo dpkg -i steam*.deb
sudo apt-get install -fy

# Cleanup and finish
rm steam*.deb
cd



#---------#
#  .Zapp  #
#---------#

echo 'Installing .zapp'
mkdir .zapp
cd .zapp
git clone https://github.com/rupa/z.git
mv z/z.sh .
rm -rf z
cd

#-------#
#  VIM  #
#-------#

#Installing plugin manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c :bd -c :q

}

##########################
#  INSTALL SYSTEM TOOLS  #
##########################

function system {
echo ''
echo 'Installing system utilities'
echo ''
echo 'Current package list:
aptitude
dconf-tools
ssh
synaptic
htop
parallel
GNU stow
tig
ncdu
pip
when-changed'
echo ''
sudo apt-get install -y --no-install-recommends aptitude dconf-tools ssh  synaptic htop parallel stow tig ncdu python-pip 

pip install https://github.com/joh/when-changed/archive/master.zip
}

###############################
#  INSTALL DEVELOPMENT TOOLS  #
###############################
#TODO: Anaconda, SmartGit, fortran,
function development {
echo ''
echo 'Installing development tools...'
echo ''
echo 'Current package list:
build-essential
git
gitk
g++
gfortran
libcr-dev
python-numpy
python-scipy
python-matplotlib
ipython
ipython-notebook
vim
scons
lapack
cmake
Latex'
echo ''
sudo apt-get install -y build-essential git gitk  g++ gfortran libcr-dev python-numpy python-scipy python-matplotlib ipython ipython-notebook vim scons liblapack-dev cmake texlive
}


##########################
#  INSTALL DESIGN TOOLS  #
##########################
function design {
echo ''
echo 'Installing design tools...'
echo ''
echo 'Current package list:
gimp
gimp-plugin-registry
inkscape
imagemagick
gnome-do'
echo ''
sudo apt-get install -y  gimp gimp-plugin-registry icontool inkscape imagemagick 'gnome-do'
}


##############
#  Dotfiles  #
##############
function dotfiles {
git clone https://github.com/tordks/dotfiles.git
cd .dotfiles/
stow bash
stow vim
cd
}

####################
#  CLEANUP SYSTEM  #
####################

function cleanup {
#TODO: Look at original file
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
cd
sysupgrade  # System upgrade/Update
favourites  # Favourite applications
system      # System tools
development # Install Dev Tools
design      # Install Design Tools
thirdparty  # Install Third-Party Applications
dotfiles    # Get dotfiles and move to correct location
cleanup     # Remove unused packages etc.
echo ''
echo 'Post-install completed'
echo 'Please restart your system'
}


#----- RUN MY MAIN FUNCTION -----#
my_main

#END OF SCRIPT
