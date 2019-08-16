#!/bin/bash
#
#SBATCH --partition=batch
#SBATCH --mem-per-cpu=3750
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 16
#SBATCH --array=1-6

SAMPLE_NAME=$(cat /home/eegarza/metagenome-paper/SrrAccList.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)
assemble_idba.sh /nobackup/eegarza/metagenome-paper $SAMPLE_NAME

