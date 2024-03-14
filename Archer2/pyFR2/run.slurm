#!/bin/bash --login

#SBATCH --job-name=euler
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=16
#SBATCH --time=00:10:00
#SBATCH --account=ta094-ttuwarcher
#SBATCH --partition=standard
#SBATCH --qos=short

# Set a nifty environment
export TTWORKPLACE=/work/ta094/ta094/ttuw_archer
export PYFR_XSMM_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.0/libxsmm/lib/libxsmm.so
export PYFR_SCOTCH_LIBRARY_PATH=$TTWORKPLACE/source/pyFRv2.0/scotch-v7.0.4/build/lib/libscotch.so

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$TTWORKPLACE/source/pyFRv2.0/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$TTWORKPLACE/source/pyFRv2.0/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$TTWORKPLACE/source/pyFRv2.0/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$TTWORKPLACE/source/pyFRv2.0/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Pass cpus-per-task setting to SRUN
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# Add in some clever stuff for OpenMP
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PLACES=cores

conda activate pyfr2

# Run your Python progamme
srun --distribution=block:block --hint=nomultithread pyfr -p run -b openmp euler-vortex.pyfrm euler-vortex.ini

conda deactivate
