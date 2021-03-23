#!/bin/bash
#SBATCH --job-name=hello-mpi
#SBATCH --nodes=4
#SBATCH --output=/home/eschnetter/src/c/hello-mpi.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load intel/mpi
which mpirun

mpirun ./hello-mpi

date
