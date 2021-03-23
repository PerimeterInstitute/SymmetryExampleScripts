#!/bin/bash
#SBATCH --partition debugq
#SBATCH --job-name=hello-openmp
#SBATCH --nodes=1
#SBATCH --output=hello-openmp.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

env OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE ./hello-openmp

date
