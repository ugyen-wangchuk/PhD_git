#Installation script for PyFR using mamba on linux

#!/bin/bash

echo Name of installation directory?:
read folder_name

export directory_name=$folder_name 
export current_directory=$(pwd)
export install_directory=$current_directory/$directory_name

if [ -d "$directory_name" ]; then
  echo "'$directory_name' does exist."
  echo "Remove '$directory_name' or use OTHER DIRECTORY NAME before continuing installation"
  echo "Exiting installation"
  exit 1
fi
echo -e '\n'"Initiating installation of PyFR in $install_directory"
mkdir $directory_name
cd $directory_name
wget https://github.com/conda-forge/miniforge/releases/download/24.3.0-0/Mambaforge-24.3.0-0-Linux-x86_64.sh
{   echo -ne '\n' 
    echo yes
    echo $install_directory/mambaforge
    echo no
} | bash ./Mambaforge-24.3.0-0-Linux-x86_64.sh

source $install_directory/mambaforge/etc/profile.d/conda.sh; 
source $install_directory/mambaforge/etc/profile.d/mamba.sh;
mamba activate
export PYTHONPATH=$install_directory/mambaforge:$PYTHONPATH
export PATH=$install_directory/mambaforge/bin:$PATH

echo Name of mamba_environment?:
read mamba_env_name
mamba create -n $mamba_env_name
mamba activate $mamba_env_name

mamba install python==3.10.14 gxx==12.3.0 fortran-compiler==1.6.0 mpich==4.2.1 metis==5.2.1 -y
git clone https://github.com/libxsmm/libxsmm.git && cd libxsmm
git checkout bf5313db8bf2edfc127bb715c36353e610ce7c04
make -j4 STATIC=0 BLAS=0
cd ../

echo PyFR version number?:
read pyfr_ver
pip install pyfr==v$pyfr_ver
echo 'Installation complete'

export file_output='scripts_for_bash'
touch $file_output
echo -e '\n'Copy lines from $directory_name/scripts_for_bash.txt to bashrc or bash_aliases file'\n'
echo export install_directory=$install_directory >> $file_output
echo export PYTHONPATH='$install_directory'/mambaforge:'$PYTHONPATH' >> $file_output
echo export PATH='$install_directory'/mambaforge/bin:'$PATH' >> $file_output
echo export PYFR_XSMM_LIBRARY_PATH='$install_directory'/libxsmm/lib/libxsmm.so >> $file_output
echo export PYFR_METIS_LIBRARY_PATH='$install_directory'/mambaforge/envs/$mamba_env_name/lib/libmetis.so >> $file_output
echo 'alias mamba_'$mamba_env_name'="source '$install_directory'/mambaforge/etc/profile.d/conda.sh; source '$install_directory'/mambaforge/etc/profile.d/mamba.sh; mamba activate; mamba activate '$mamba_env_name'" ' >> $file_output

echo Use mamba_$mamba_env_name to activate the mamba environment.
