#!/bin/bash
#SBATCH --job-name=megahit
#SBATCH --partition=batch
#SBATCH --nodes=1
#SBATCH --mem=58G
#SBATCH --ntasks=12
#SBATCH --array=1-6

SAMPLE_NAME=$(cat /home/eegarza/metagenome-paper/SrrAccList.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n 1)
BASE_DIR=/nobackup/eegarza/metagenome-paper
FILTERED_SEQ_DIR=${BASE_DIR}/filtered/${SAMPLE_NAME}
OUTPUT_DIR=${BASE_DIR}/assembly/megahit/${SAMPLE_NAME}/

assemble_megahit.sh ${FILTERED_SEQ_DIR}/${SAMPLE_NAME}.forward.paired.fastq ${FILTERED_SEQ_DIR}/${SAMPLE_NAME}.reverse.paired.fastq ${OUTPUT_DIR}
