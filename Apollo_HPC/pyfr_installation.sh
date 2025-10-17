#PyFR installation script for Apollo HPC

module load Python/3.11.3-GCCcore-12.3.0
module load OpenMPI/4.1.5-GCC-12.3.0
module load CMake/3.26.3-GCCcore-12.3.0
module load CUDA/12.3.0

#Export appropriate directory for installation
export TTWORKPLACE=/data/home/tt/ttuw

if test -d $TTWORKPLACE/source; then
    echo "Using source directory for installation"
    else
    echo "Assign an installation directory."
    exit 1
fi
echo "Installing PyFR and Dependencies"

cd $TTWORKPLACE/source
mkdir pyFRv2.1 && cd pyFRv2.1

#Building Python virtual environment
python -m venv --system-site-packages $TTWORKPLACE/source/pyFRv2.1/py_venv
source $TTWORKPLACE/source/pyFRv2.1/py_venv/bin/activate
export PATH=$TTWORKPLACE/source/pyFRv2.1/py_venv/bin:$PATH

#Building XSMM
cd $TTWORKPLACE/source/pyFRv2.1
git clone https://github.com/libxsmm/libxsmm.git && cd libxsmm
git checkout bf5313db8bf2edfc127bb715c36353e610ce7c04
make -j4 STATIC=0 BLAS=0
export PYFR_XSMM_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.1/libxsmm/lib/libxsmm.so

#Building Scotch
cd $TTWORKPLACE/source/pyFRv2.1
wget https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.9/scotch-v7.0.9.tar.gz
tar -xf scotch-v7.0.9.tar.gz && rm scotch-v7.0.9.tar.gz
cd scotch-v7.0.9/
mkdir build && cd build && cmake -DBUILD_SHARED_LIBS=ON -DLIBSCOTCHERR=scotcherr .. && make -j5
export PYFR_SCOTCH_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.1/scotch-v7.0.9/build/lib/libscotch.so

cd $TTWORKPLACE/source/pyFRv2.1

#Installing PyFR
pip install pyfr==v2.1

#Add the following lines to bash_script. Remove '#' before.
#export TTWORKPLACE=/data/home/tt/ttuw
#export PATH=$TTWORKPLACE/source/py_venv/bin:$PATH
#export PYFR_XSMM_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.1/libxsmm/lib/libxsmm.so
#export PYFR_SCOTCH_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.1/scotch-v7.0.9/build/lib/libscotch.so

#alias py_venv="module load Python/3.11.3-GCCcore-12.3.0 OpenMPI/4.1.5-GCC-12.3.0 CMake/3.26.3-GCCcore-12.3.0 CUDA/12.3.0; \
#    source $TTWORKPLACE/source/pyFRv2.1/py_venv/bin/activate;"
