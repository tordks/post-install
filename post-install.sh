#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

# Description:
#   A post-installation bash script for Ubuntu (14.04)

#TODO: Document packages
#TODO: Read gnome stuff
#TODO: Add customizations
#TODO: Koble opp mot stud-serveren
#TODO: Add ParaView, Openfoam, pov-ray. 

echo ''
echo '#------------------------------#'
echo '#------------------------------#'
echo '#     Post-Install Script      #'
echo '#------------------------------#'
echo '#------------------------------#'
echo ''

####################
#  Choose bundles  #
####################

function choose {
echo 'Which bundles do you wish to install?'
echo 'u   - system upgrade'
echo 't   - system tools'
echo 'D   - development tools'
echo 'a   - applications'
echo 'd   - design tools'
echo 'f   - settings'
echo 'all - all of the above'
read ans

echo 'Cleanup?'
echo 'Y/n'
read clean
}

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
#TODO: Nitrotasks not working
function applications {
echo ''
echo 'Installing selected favourite applications'
echo ''
echo 'Current package list:
Vlc
Skype
Wine
Indicator sticknotes
Tor browser
Google Chrome 
Steam
Vim'

sudo add-apt-repository -y ppa:umang/indicator-stickynotes
#sudo add-apt-repository -y ppa:cooperjona/nitrotasks
sudo add-apt-repository -y ppa:upubuntu-com/tor64
sudo apt-get update

sudo apt-get install -y \
vlc \
skype \
wine \
indicator-stickynotes \
tor-browser \
|| echo "Installation failed" && exit

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

#-------#
#  VIM  #
#-------#

#Installing plugin manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugInstall -c :bd -c :q


#----------#
#  RSSowl  #
#----------#

wget http://archive.getdeb.net/ubuntu/rpool/apps/r/rssowl/rssowl_2.2.1-1~getdeb1_amd64.deb
sudo dpkg -i rssowl_2.2.1-1~getdeb1_amd64.deb
sudo apt-get install -f
sudo rm -rf rssowl_2.2.1-1~getdeb1_amd64.deb
}

##########################
#  INSTALL SYSTEM TOOLS  #
##########################

function system {
echo ''
echo 'Installing system tools'
echo ''
echo 'Current package list:
aptitude
ssh
synaptic
htop
parallel
GNU stow
tig
ncdu
pip -   installation software
when-changed    -   runs a program when a file is changed
xsel
terminator  -   new terminal
zapp    -   fast folder browsing
timeshift   -   system restore tool'
echo ''

sudo apt-add-repository ppa:teejee2008/ppa
sudo apt-get update

sudo apt-get install -y \
aptitude \
ssh \
synaptic \
htop \
parallel \
stow \
tig \
ncdu \
python-pip \
xsel \
terminator \
timeshift \
|| echo "Installation failed" && exit

#when-changed
pip install https://github.com/joh/when-changed/archive/master.zip 


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
sudo apt-get install -y \
build-essential \
git \
gitk \
g++ \
gfortran \
libcr-dev \
python-numpy \
python-scipy \
python-matplotlib \
ipython \
ipython-notebook \
vim \
scons \
liblapack-dev \
cmake \
texlive \
|| echo "Installation failed" && exit


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
gnome-do
blender'
echo ''

sudo add-apt-repository -y ppa:thomas-schiex/blender
sudo apt-get update

sudo apt-get install -y  \
gimp \
gimp-plugin-registry \
icontool \
inkscape \
imagemagick \
blender \
'gnome-do' || echo "Installation failed" && exit
}


##############
#  Dotfiles  #
##############
function settings {
echo 'Adding predefined settings'
git clone https://github.com/tordks/dotfiles.git
cd .dotfiles/
stow bash
stow vim
cd

# Make vim standard editor for misc. programmes
export VISUAL=vim
export EDITOR="$VISUAL"

#Remove native terminal and replace it with terminator
sudo apt-get remove gnome-terminal
sudo ln -s /usr/bin/terminator /usr/bin/gnome-terminal

}

####################
#  CLEANUP SYSTEM  #
####################

function cleanup {
echo ''
echo 'Remove unused pre-installed packages'
echo 'Remove old kernel(s)'
echo 'Remove orphaned packages'
echo 'Remove leftover configuration files'
echo 'Clean package cache'

echo 'Removing selected pre-installed applications...'
sudo apt-get purge landscape-client-ui-install ubuntuone-control-panel* overlay*

# Remove Old Kernel
echo 'Removing old Kernel(s)...'
sudo dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | grep -v linux-libc-dev | xargs sudo apt-get -y purge

# Remove Orphaned Packages
echo 'Removing orphaned packages...'
sudo apt-get autoremove -y

# Remove residual config files?
echo 'Removing leftover configuration files...'
sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep '^rc' | tr -s ' ' | cut -d ' ' -f 2)

# Clean Package Cache
echo 'Cleaning package cache...'
sudo apt-get clean

# Remove packages that were automatically installed to satisfy dependencies for other packages and are now no longer needed
echo 'Remove automaticly added packages which are no longer needed'
sudo apt-get autoremove
}



#----- MY MAIN FUNCTION ----#
function my_main {
echo ''
echo 'Running post-install package'
cd
choose      # Choose which bundles to run

if [[ $ans == *"u"* || $ans == *"all"* ]]
then
    sysupgrade     # System upgrade/Update
fi

if [[ $ans == *"t"* || $ans == *"all"* ]]
then
    system         # System tools
fi

if [[ $ans == *"D"* || $ans == *"all"* ]]
then
    development    # Install Dev Tools
fi


if [[ $ans == *"a"* || $ans == *"all"* ]]
then
    applications   # Applications
fi

if [[ $ans == *"d"* || $ans == *"all"* ]]
then
    design         # Install Design Tools
fi

if [[ $ans == *"f"* || $ans == *"all"* ]]
then
    settings        # Add predefined settings
fi

if [[ $clean == *"Y"* || $clean == *"y"* ]]
then
    cleanup        # Remove unused packages etc.
fi

echo ''
echo 'Post-install completed'
echo 'Restart system?'
read ans

if [[ $ans == *"Y"* || $ans == *"y"* ]]
then
    sudo reboot
fi
}


#----- RUN MY MAIN FUNCTION -----#
my_main

#END OF SCRIPT
