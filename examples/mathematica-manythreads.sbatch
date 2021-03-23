#!/bin/bash
#SBATCH --job-name=mathematica-manythreads
#SBATCH --nodes=1
#SBATCH --output=/home/eschnetter/src/c/mathematica-manythreads.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load mathematica

math -noprompt -script mathematica-manythreads.m

date
