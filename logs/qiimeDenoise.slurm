#!/bin/bash
#SBATCH --job-name=qiimeDenoise_%j
#SBATCH --output=qiimeDenoise_%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=3750
#SBATCH --partition=batch

ROOT=/home/eegarza/Qiime

module load bio/qiime2/2019.4

qiime dada2 denoise-paired --i-demultiplexed-seqs /home/eegarza/Qiime/bigHornData.qza \
--p-trim-left-f 16 \
--p-trim-left-r 16 \
--p-trunc-len-f 230 \
--p-trunc-len-r 220 \
--p-trunc-q 2 \
--p-max-ee 2 \
--o-table $ROOT/bigHornTable.qza \
--o-representative-sequences $ROOT/bigHornRepreSeqs.qza \
--o-denoising-stats $ROOT/bigHornDenoiseStats.qza \
--p-n-threads $SLURM_CPUS_PER_TASK

