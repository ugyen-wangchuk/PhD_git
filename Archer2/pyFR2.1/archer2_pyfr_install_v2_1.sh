#PyFR2.1 installation on Archer2

module load PrgEnv-gnu cray-python/3.10.10 extra-compilers scotch/7.0.3

#Export appropriate directory for installation
export TTWORKPLACE=/work/e01/e01/ttuw_archer2

if test -d $TTWORKPLACE/source; then
    echo "Using source directory for installation."
    else
    echo "Assign correct source directory for installation."
    exit 1
fi

echo "Installing PyFR and Dependencies"

cd $TTWORKPLACE/source
mkdir -p pyFRv2.1
cd pyFRv2.1

export PYFR_INSTALL_DIRECTORY=$TTWORKPLACE/source/pyFRv2.1

#Building Python virtual environment
python -m venv --system-site-packages $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv
source $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin/activate
export PATH=$PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin:$PATH

#Building XSMM
cd $PYFR_INSTALL_DIRECTORY
git clone https://github.com/libxsmm/libxsmm.git && cd libxsmm
git checkout bf5313db8bf2edfc127bb715c36353e610ce7c04
make -j4 STATIC=0 BLAS=0
export PYFR_XSMM_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/libxsmm/lib/libxsmm.so

#Building Scotch
cd $PYFR_INSTALL_DIRECTORY
wget https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.8/scotch-v7.0.8.tar.gz
tar -xf scotch-v7.0.8.tar.gz && rm scotch-v7.0.8.tar.gz
cd scotch-v7.0.8/
mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON .. && make -j5
export PYFR_SCOTCH_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/scotch-v7.0.8/build/lib/libscotch.so

#Installing PyFR
cd $PYFR_INSTALL_DIRECTORY
python -m pip install numpy==1.26.4
pip install pyfr==2.1

# Ask user about bash_aliases
read -r -p "Add PyFR2.1 alias script to ~/.bash_aliases? [y/n] " ans

#Setting up bash alias for easy environment setup
BASH_ALIASES="$HOME/.bash_aliases"

if [[ "$ans" =~ ^[Yy]$ ]]; then
    cat <<'EOF' >> "$HOME/.bash_aliases"
# ---- PyFR 2.1 environment setup (Archer2 HPC) ----
pyfr2.1() {
    export TTWORKPLACE=/work/e01/e01/ttuw_archer2
    export PYFR_INSTALL_DIRECTORY=$TTWORKPLACE/source/pyFRv2.1
    export PATH=$PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin:$PATH
    export PYFR_XSMM_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/libxsmm/lib/libxsmm.so
    export PYFR_SCOTCH_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/scotch-v7.0.8/build/lib/libscotch.so

	module load PrgEnv-gnu cray-python/3.10.10 extra-compilers scotch/7.0.3

    source $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin/activate
}
# ---- End PyFR 2.1 setup ----

EOF

    echo "Added pyfr2.1 function to ~/.bash_aliases"
else
    echo "pyfr2.1 function already exists in ~/.bash_aliases — skipping"
fi
