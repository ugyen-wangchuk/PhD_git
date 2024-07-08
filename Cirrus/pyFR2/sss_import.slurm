#!/bin/bash --login

#SBATCH --job-name=sbli_d_1
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=18
#SBATCH --time=00:30:00
#SBATCH --exclusive
#SBATCH --account=ec265
#SBATCH --partition=standard
#SBATCH --qos=standard

module list

export SSS=/scratch/space1/ec265/ttuw_cirrus1
export PYFR_SOURCE=/scratch/space1/ec265/ttuw_cirrus1/source
export PYFR_XSMM_LIBRARY_PATH=$SSS/source/pyFRv2.0/libxsmm/lib/libxsmm.so
export XDG_CACHE_HOME=${HOME/home/work}

#For srun
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores

#pyFR2.0
export PYTHONPATH=$PYFR_SOURCE/pyFRv2.0/mambaforge:$PYTHONPATH
export PATH=$PYFR_SOURCE/pyFRv2.0/mambaforge/bin:$PATH
export PYFR_XSMM_LIBRARY_PATH=$PYFR_SOURCE/pyFRv2.0/libxsmm/lib/libxsmm.so
export PYFR_METIS_LIBRARY_PATH=$PYFR_SOURCE/pyFRv2.0/mambaforge/envs/pyFRv2.0/lib/libmetis.so
source $PYFR_SOURCE/pyFRv2.0/mambaforge/etc/profile.d/conda.sh 
source $PYFR_SOURCE/pyFRv2.0/mambaforge/etc/profile.d/mamba.sh 
mamba activate pyFRv2.0

pyfr --version

pyfr import 3d_sbli_h_d.msh 3d_sbli_h_d.pyfrm 

pyfr partition 176 3d_sbli_h_d.pyfrm  .

echo 'Import Complete'
