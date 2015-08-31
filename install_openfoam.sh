echo'#####################################'
echo'#  Install OPENFOAM on ubuntu 14.4  #'
echo'#####################################'


echo 'How many processors does this computer have?'
read > procs

echo ''

echo 'Which system architecture are you on? (You can check by running:
uname -m'
echo''
echo'(1) x86_64'
echo'(2) i686'
read > arch


#-----------------------------------#
#  Install the necessary packages:  #
#-----------------------------------#

sudo apt-get install 
build-essential \
cmake \
flex \
bison \
zlib1g-dev \
qt4-dev-tools \
libqt4-dev \
libqtwebkit-dev \
gnuplot \
libreadline-dev \
libncurses-dev \
libxt-dev \
libopenmpi-dev \
openmpi-bin \
libboost-system-dev \
libboost-thread-dev \
libgmp-dev \
libmpfr-dev \
python \
python-dev \
bglu1-mesa-dev \
libqt4-opengl-dev


#-----------------------------------------#
#  OpenFOAM downloading and installation  #
#-----------------------------------------#

mkdir OpenFOAM
cd OpenFOAM
wget "http://downloads.sourceforge.net/foam/OpenFOAM-2.4.0.tgz?use_mirror=mesh" -O OpenFOAM-2.4.0.tgz
wget "http://downloads.sourceforge.net/foam/ThirdParty-2.4.0.tgz?use_mirror=mesh" -O ThirdParty-2.4.0.tgz
 
tar -xzf OpenFOAM-2.4.0.tgz 
tar -xzf ThirdParty-2.4.0.tgz

# ---------------------------------------------------------------#
#  Optional: A few symbolic links that ensure that the correct   #
#  MPI installation  is used:                                    #
# ---------------------------------------------------------------#

ln -s /usr/bin/mpicc.openmpi OpenFOAM-2.4.0/bin/mpicc
ln -s /usr/bin/mpirun.openmpi OpenFOAM-2.4.0/bin/mpirun

#-----------------------------------------------------------------#
#  For building OpenFOAM itself, it depends on whether you have   #
#  installed the i686 or x86_64 architecture of Ubuntu.           #
#-----------------------------------------------------------------#


if [ $arch == 1] 
then
    source $HOME/OpenFOAM/OpenFOAM-2.4.0/etc/bashrc WM_NCOMPPROCS=$procs
else
    source $HOME/OpenFOAM/OpenFOAM-2.4.0/etc/bashrc WM_NCOMPPROCS=$procs WM_ARCH_OPTION=32
fi

#------------------------------------------------------------------#
#  Save an alias in the personal .bashrc file, simply by running   # 
#  the following command:                                          #
#------------------------------------------------------------------#

echo "alias of240='source \$HOME/OpenFOAM/OpenFOAM-2.4.0/etc/bashrc $FOAM_SETTINGS'" >> $HOME/.bashrc


#  Note: This last line means that whenever you start a new terminal 
#  window or tab, you should run the alias command associated to the 
#  OpenFOAM 2.4.0 shell environment. In other words, whenever you 
#  start a new terminal, you should run:  of240



#-------------------------------------------------------------------#
#  Now let's build the ThirdParty folder, because we need the shell #
#  environment to be updated afterwards, for CGAL to be properly    #
#  picked up for building OpenFOAM:                                 #
#-------------------------------------------------------------------#

cd $WM_THIRD_PARTY_DIR
 
#make very certain that the correct Qt version is being used, by running this command:
export QT_SELECT=qt4
 
# This next command will take a while... somewhere between 5 minutes to 30 minutes.
./Allwmake > make.log 2>&1
 
#update the shell environment
wmSET $FOAM_SETTINGS


#----------------#-------------------------------------------------#
#  Now, in order to build ParaView 4.1.0 that comes with OpenFOAM, # 
#  including with the ability to use Python and MPI, several       #
#  steps are needed:                                               #
#------------------------------------------------------------------#

# First make very certain that the correct Qt version is being used, 
# by running this command: 

export QT_SELECT=qt4

# Need to do several fixes: 

sed -i -e 's=//#define GLX_GLXEXT_LEGACY=#define GLX_GLXEXT_LEGACY=' \
      ParaView-4.1.0/VTK/Rendering/OpenGL/vtkXOpenGLRenderWindow.cxx
 
cd $WM_THIRD_PARTY_DIR/ParaView-4.1.0
 
wget http://www.paraview.org/pipermail/paraview/attachments/20140210/464496cc/attachment.bin -O Fix.patch
patch -p1 < Fix.patch
 
cd VTK
wget https://github.com/gladk/VTK/commit/ef22d3d69421581b33bc0cd94b647da73b61ba96.patch -O Fix2.patch
patch -p1 < Fix2.patch
 
cd ../..


# For building ParaView with Python and MPI, it depends on whether 
# you have installed the i686 or x86_64 architecture of Ubuntu.


echo'This will take a while... somewhere between 30 minutes to 2 hours 
     or more'

if [ $arch == 1] 
then
    ./makeParaView4 -python -mpi -python-lib /usr/lib/x86_64-linux-gnu/libpython2.7.so.1.0 > log.makePV 2>&1
else
    ./makeParaView4 -python -mpi -python-lib /usr/lib/i386-linux-gnu/libpython2.7.so.1.0 > log.makePV 2>&1
fi

echo 'Make sure to check the contents of the file log.makePV and 
      check if there are any errors. Press enter to continue'
read

#Finally, update the shell environment: 
wmSET $FOAM_SETTINGS


#-----------------------------#
#  Now let's build OpenFOAM:  #
#-----------------------------#

echo'Now let us build OpenFoam'
echo '(Warning: this may take somewhere from 30 minutes to 6 hours, 
      depending on your machine.)'

#Go into OpenFOAM's main source folder
cd $WM_PROJECT_DIR
 
#Still better be certain that the correct Qt version is being used
export QT_SELECT=qt4
 
# This next command will take a while... somewhere between 30 minutes to 3-6 hours.
./Allwmake > make.log 2>&1
 
#Run it a second time for getting a summary of the installation
./Allwmake > make.log 2>&1


#--------------------------------------#
#  To check if everything went well:   #
#--------------------------------------#

echo 'Check if icoFoam is working (If it tells you how to use it, 
      then the installation should be working as intended. )'

icoFoam -help

echo 'If the previous command failed to work properly, then edit 
      the file make.log and check if there are any error messages.'

echo 'END OF SCRIPT'


