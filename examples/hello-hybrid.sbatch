#!/bin/bash
#SBATCH --partition debugq
#SBATCH --job-name=hello-hybrid
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --output=hello-hybrid.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load mpi
which mpirun

env OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE mpirun ./hello-hybrid

date
