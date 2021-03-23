#!/bin/bash
#SBATCH --job-name=mathematica-manytasks
#SBATCH --nodes=1
#SBATCH --output=/home/eschnetter/src/c/mathematica-manytasks.out
#SBATCH --time=0:10:00

set -euxo pipefail

pwd
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
date

module load mathematica

# Run 200 tasks, each labelled from 1 to 200.
# But run only 40 ($SLURM_CPUS_ON_NODE) at a time.
seq 200 |
    xargs -P $SLURM_CPUS_ON_NODE -n 1 -I '{}' \
	  math -noprompt -script mathematica-onetask.m '{}'

date
