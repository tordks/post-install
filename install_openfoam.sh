#!/bin/bash

# NOT TESTED

#TODO: check all dependencies automaticly beforehand.
#TODO: add options for testing
#TODO: add comments

echo'#####################################'
echo'#  Install OPENFOAM on ubuntu 14.4  #'
echo'#####################################'

# This script follows the steps found on this page:
# http://www.openfoam.org/download/source.php



#---------------------------------------#
#  Downloading and unpacking sources    #
#---------------------------------------#

mkdir $HOME/OpenFOAM/
cd $HOME/OpenFOAM/

wget "http://sourceforge.net/projects/foam/files/foam/2.4.0/OpenFOAM-2.4.0.tgz/download?use_mirror=skylink&use_mirror=mesh" -O OpenFOAM-2.4.0.tgz

wget "http://sourceforge.net/projects/foam/files/foam/2.4.0/ThirdParty-2.4.0.tgz/download?use_mirror=kent&use_mirror=mesh" -O ThirdParty-2.4.0.tgz

tar xzf OpenFOAM-2.4.0.tgz
tar xzf ThirdParty-2.4.0.tgz 

rm OpenFOAM-2.4.0.tgz
rm ThirdParty-2.4.0.tgz 


#-----------------------------------#
#  Install the necessary packages:  #
#-----------------------------------#

# For openFoam
sudo apt-get install -y \
    build-essential \
    flex \
    bison \
    cmake \
    zlib1g-dev \
    libopenmpi-dev \
    openmpi-bin \
    gnuplot \
    libreadline-dev \
    libncurses-dev \
    libxt-dev 

# For paraView
sudo apt-get install -y \
    qt4-dev-tools \
    libqt4-dev \
    libqt4-opengl-dev \
    freeglut3-dev \
    libqtwebkit-dev 

sudo apt-get install -y \
    libscotch-dev \
    libcgal-dev


#-----------------------------------#
#   Setting environment veriables:  #
#-----------------------------------#

echo "" >> $HOME/.bashrc
echo "source $HOME/OpenFOAM/OpenFOAM-2.4.0/etc/bashrc" >> $HOME/.bashrc
source $HOME/.bashrc


#-------------------------#
#   Checking the system:  #
#-------------------------#

cd $HOME/OpenFOAM/OpenFOAM-2.4.0/bin/
bash foamSystemCheck
echo "foamSystemCeck is complete"
read -n1 -r -p "Is everything ok? If no press ctrl-C and abort installation" key

echo "checking gcc version"
gcc --version
echo "if the gcc version i below 4.5 abort installation by pressing ctrl-C"

#------------------------#
#  Building the sources  #
#------------------------#
echo "Starting to build sources. This will take a long time..."
echo "Output will be saved to temp.log. Check there if you encounter errors"

cd $WM_PROJECT_DIR
./Allwmake > temp.log


#-----------------------------------------------------#
#  Compiling Paraview and the Paraview Reader Module  #
#-----------------------------------------------------#


echo "checking cmake version:"

cmake --version
echo "is the version above 2.8.8?"

read -n1 -r -p "Is the version above 2.8.8? If no, cmake has to be installed" key

#cd $WM_THIRD_PARTY_DIR
#./makeCmake
#wmSET

cd $WM_THIRD_PARTY_DIR
./makeParaView4

#------------------------#
#  Testing installation  #
#------------------------#

cd $HOME/OpenFOAM/OpenFOAM-2.4.0/bin/
bash foamInstallationTest


#####################
#  Getting started  #
#####################

cd $HOME/OpenFOAM/
mkdir -p $FOAM_RUN

cp -r $FOAM_TUTORIALS $FOAM_RUN


