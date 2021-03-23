#!/bin/bash
#SBATCH --partition=debugq
#SBATCH --job-name=mathematica-manythreads
#SBATCH --nodes=1
#SBATCH --output=mathematica-manythreads.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load mathematica

# If you want to set the number of threads used by mathematica explicitly, you can set
# export OMP_NUM_THREADS=20

math -noprompt -script mathematica-manythreads.m

date
