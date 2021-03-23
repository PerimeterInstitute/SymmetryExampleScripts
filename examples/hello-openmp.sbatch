#!/bin/bash
#SBATCH --job-name=hello-openmp
#SBATCH --nodes=1
#SBATCH --output=/home/eschnetter/src/c/hello-openmp.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

env OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE ./hello-openmp

date
