#PyFR 2.1 installation script for local machines with sudo rights

#Run this script from within the installation source directory

export TTWORKPLACE=/mnt/f
export PYFR_INSTALL_DIRECTORY=$TTWORKPLACE/source/pyFRv2.1

#Install Python and MPI:
sudo apt install python3 python3-pip libopenmpi-dev openmpi-bin python3.10-venv
pip3 install virtualenv

#Building Python virtual environment
python3 -m venv --system-site-packages $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv
source $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin/activate

#Building XSMM
cd $PYFR_INSTALL_DIRECTORY
git clone https://github.com/libxsmm/libxsmm.git && cd libxsmm
git checkout bf5313db8bf2edfc127bb715c36353e610ce7c04
make -j4 STATIC=0 BLAS=0
export PYFR_XSMM_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/libxsmm/lib/libxsmm.so

#Building Scotch
cd $PYFR_INSTALL_DIRECTORY
wget https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.9/scotch-v7.0.9.tar.gz
tar -xf scotch-v7.0.9.tar.gz && rm scotch-v7.0.9.tar.gz
cd scotch-v7.0.9/
mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON -DLIBSCOTCHERR=scotcherr .. && make -j5
export PYFR_SCOTCH_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/scotch-v7.0.9/build/lib/libscotch.so

cd $PYFR_INSTALL_DIRECTORY

#Installing PyFR
pip install pyfr==2.1

# Ask user about bash_aliases
read -r -p "Add PyFR2.1 alias script to ~/.bash_aliases? [y/n] " ans

#Setting up bash alias for easy environment setup
BASH_ALIASES="$HOME/.bash_aliases"

if [[ "$ans" =~ ^[Yy]$ ]]; then
    cat <<'EOF' >> "$HOME/.bash_aliases"
# ---- PyFR 2.1 environment setup (Local_Machine) ----
pyfr2.1() {
    export TTWORKPLACE=/mnt/f
    export PYFR_INSTALL_DIRECTORY=$TTWORKPLACE/source/pyFRv2.1
    export PATH=$PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin:$PATH
    export PYFR_XSMM_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/libxsmm/lib/libxsmm.so
    export PYFR_SCOTCH_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/scotch-v7.0.9/build/lib/libscotch.so

    source $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin/activate
}
# ---- End PyFR 2.1 setup ----

EOF

    echo "Added pyfr2.1 function to ~/.bash_aliases"
else
    echo "Skipping ~/.bash_aliases update"
fi

echo "Installation complete."
