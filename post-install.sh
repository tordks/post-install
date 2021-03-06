#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-

# Description:
#   A post-installation bash script for Ubuntu (14.04)

#TODO: Read gnome stuff
#TODO: Add customizations
#TODO: Add if(there) == 0 => run on zapp, vim
#TODO: Add ParaView, Openfoam, pov-ray to seperate file
#TODO: Consider adding these to vim:
#      https://github.com/johndgiese/dotvim
#      https://github.com/carlhuda/janus
#      https://github.com/altercation/Vim-colors-solarized
#      https://github.com/tomasr/molokai
#      https://github.com/sjl/badwolf/
#TODO: Reconsider using terminator
#TODO: Consider using tmux. If so add tmux settings to vimrc.
#TODO: Add compilation of Youcompleteme for vim and powerline fonts.
#TODO: Add BOOST c++ library
#TODO: Anaconda instead of several python installs.

echo ''
echo '#------------------------------#'
echo '#------------------------------#'
echo '#     Post-Install Script      #'
echo '#------------------------------#'
echo '#------------------------------#'
echo ''

echo ''
echo 'settings before system'
echo ''

echo ''
echo ' THIS SCRIPT IS NOT RECENTLY TESTED '
echo ' test mkdir with zapp and dotfiles '
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

#echo 'Cleanup?'
#echo 'Y/n'
#read clean
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
vlc                  - video player
skype                - chat
indicator sticknotes - notes on desktop
google Chrome        - browser'

sudo add-apt-repository -y ppa:umang/indicator-stickynotes
#sudo add-apt-repository -y ppa:cooperjona/nitrotasks
#sudo add-apt-repository -y ppa:upubuntu-com/tor64
sudo apt-get update

sudo apt-get install -y \
vlc \
skype \
indicator-stickynotes

#tor-browser \

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
aptitude     - package handler
ssh          - for logging in remotely
synaptic     - grahpical package manager
htop         - process viewer
parallel     - shell tool for executing jobs in parallel
GNU stow     - software installation manager
tig          - git repository browser
ncdu         - disk usage viewer
pip          - python package installer
when-changed - runs a program when a file is changed
xsel         - command-line tool to access x clipboard and selection buffers
terminator   - alternative terminal
zapp         - fast folder browsing
timeshift    - system restore tool
curl         - client to get/send documents from/to a server
vim          - epic editor
gnome-do     - quickly perform actions on your desktop'
echo ''

sudo apt-add-repository -y ppa:teejee2008/ppa
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
curl \
cifs-utils \
openconnect \
'gnome-do'

#when-changed
sudo pip install https://github.com/joh/when-changed/archive/master.zip 

#vpn to NTNU
cd ~/Desktop/
wget -q  kjdf.no/downloads/ntnu_shares.sh.gz -O ntnu_shares.sh.gz
gunzip -f ntnu_shares.sh.gz
chmod +x ntnu_shares.sh
cd
# The script is used like this:

# ntnu_shares.sh start  - (Kobler til VPN og) monterer ressurser
# ntnu_shares.sh stop   - Avmonterer ressurser (og kobler fra VPN)
# ntnu_shares.sh kill   - Kobler fra VPN og forsøker å avmontere ressurser.
#                         - Denne kan brukes dersom det oppstår problemer med de monterte ressursene.
# ./ntnu_shares.sh status - Viser status

#-------#
#  VIM  #
#-------#

#Installing plugin manager
cd
mkdir .vim/autoload/
mkdir .vim/undo/
mkdir .vim/backups/
cd .vim/autoload/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c PlugClean -c PlugInstall -c :bd -c :q

#---------#
#  .Zapp  #
#---------#

echo 'Installing .zapp'
cd
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
build-essential     - allows building of deb packages
git                 - version control
gitk                - revision tree visualizer
g++                 - c++ compiler
gfortran            - fortran compiler
libcr-dev           - allows programs to be "checkpointed"
python-numpy        - array facility to the python language
python-scipy        - scientific tools for python
python-matplotlib   - python based plotting system
ipython             - Enhanced interactive python shell
ipython-notebook    - interactive python html notebook
scons               - alternative to make
lapack              - linear algebra package
cmake               - open- source make system
texlive             - tex system
texlive-latex-extra - additional packages for tex
latex-xcolor        - xcolor package for latex
latexmk             - resolves cross-references in LaTeX'
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
python-dev \
ipython \
ipython-notebook \
vim \
scons \
liblapack-dev \
cmake \
texlive \
texlive-latex-extra \
latex-xcolor \
latexmk

echo'Compiling python3.4.3.tqz'

echo'Installing required packages'
sudo apt-get install build-essential checkinstall
sudo apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev \
                     libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

cd /usr/src
sudo wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
sudo tar xzf Python-3.4.3.tgz
sudo rm Python-3.4.3.tgz
cd Python-3.4.3
sudo ./configure
sudo make altinstall
cd



}


##########################
#  INSTALL DESIGN TOOLS  #
##########################
function design {
echo ''
echo 'Installing design tools...'
echo ''
echo 'Current package list:
gimp                       - image manipulation program
gimp-plugin-linux registry - Repository of optional extensions for gimp
inkscape                   - vector-based drawing program
imagemagick                - image manipulation programs
blender                    - 3d modeller/renderer'
echo ''

sudo add-apt-repository -y ppa:thomas-schiex/blender
sudo apt-get update

sudo apt-get install -y  \
gimp \
gimp-plugin-registry \
icontool \
inkscape \
imagemagick \
blender
}


##############
#  Settings  #
##############
function settings {
echo 'Adding predefined settings'
cd
git clone https://github.com/tordks/dotfiles.git
cd .dotfiles/
stow bash
stow vim
cd


cd .vim/plugged/YouCompleteMe/
python install.py
cd

# Make vim standard editor for misc. programmes.
export VISUAL=vim
export EDITOR="$VISUAL"

#Remove native terminal and replace it with terminator
# Terminator must already be installed.
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

#if [[ $clean == *"Y"* || $clean == *"y"* ]]
#then
#    cleanup        # Remove unused packages etc.
#fi

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
