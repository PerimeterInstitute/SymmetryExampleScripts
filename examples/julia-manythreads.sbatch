#!/bin/bash
#SBATCH --job-name=julia-manythreads
#SBATCH --nodes=1
#SBATCH --output=/home/eschnetter/src/c/julia-manythreads.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

env OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE julia julia-manythreads.jl

date
