#!/bin/bash
#SBATCH --partition=debugq
#SBATCH --job-name=julia-manythreads
#SBATCH --nodes=1
#SBATCH --output=julia-manythreads.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load julia

env OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE julia julia-manythreads.jl

date
