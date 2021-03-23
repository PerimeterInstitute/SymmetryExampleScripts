#!/bin/bash
#SBATCH --partition=debugq
#SBATCH --job-name=hello-mpi
#SBATCH --nodes=4
#SBATCH --output=hello-mpi.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load mpi
which mpirun

mpirun ./hello-mpi

date
