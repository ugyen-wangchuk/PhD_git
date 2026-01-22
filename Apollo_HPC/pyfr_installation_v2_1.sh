#PyFR 2.1 installation script for Apollo HPC

module load Python/3.11.3-GCCcore-12.3.0
module load OpenMPI/4.1.5-GCC-12.3.0
module load CMake/3.26.3-GCCcore-12.3.0
module load CUDA/12.3.0

#Export appropriate directory for installation
export TTWORKPLACE=/data/home/tt/ttuw

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
export PYFR_XSMM_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.1/libxsmm/lib/libxsmm.so

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

#Setting up bash alias for easy environment setup
BASH_ALIASES="$HOME/.bash_aliases"

if ! grep -q "^pyfr2.1()" "$BASH_ALIASES" 2>/dev/null; then
    cat <<'EOF' >> "$BASH_ALIASES"
# ---- PyFR 2.1 environment setup (Apollo HPC) ----
pyfr2.1() {
    export TTWORKPLACE=/data/home/tt/ttuw
    export PYFR_INSTALL_DIRECTORY=$TTWORKPLACE/source/pyFRv2.1
    export PATH=$PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin:$PATH
    export PYFR_XSMM_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/libxsmm/lib/libxsmm.so
    export PYFR_SCOTCH_LIBRARY_PATH=$PYFR_INSTALL_DIRECTORY/scotch-v7.0.9/build/lib/libscotch.so

    module load Python/3.11.3-GCCcore-12.3.0 \
                OpenMPI/4.1.5-GCC-12.3.0 \
                CMake/3.26.3-GCCcore-12.3.0 \
                CUDA/12.3.0

    source $PYFR_INSTALL_DIRECTORY/pyfr2.1_venv/bin/activate
}
# ---- End PyFR 2.1 setup ----

EOF

    echo "Added pyfr21 function to ~/.bash_aliases"
else
    echo "pyfr21 function already exists in ~/.bash_aliases — skipping"
fi
