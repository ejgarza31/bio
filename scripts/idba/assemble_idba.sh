#!/bin/bash
# Recreating metagenome analysis used in 
# https://mbio.asm.org/content/7/1/e01669-15.short
#
# The use ggKbase onlinen binning tool which seems unlikely to be reproduced

module load anaconda3/4.3.1
BASE_DIR=/nobackup/eegarza/metagenome-paper

mkdir -p $BASE_DIR/trimmed $BASE_DIR/filtered $BASE_DIR/assembly $BASE_DIR/logs
echo
echo running $1

mkdir -p $BASE_DIR/trimmed/${1}
source activate cutadapt-env
cutadapt -j 16 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o $BASE_DIR/trimmed/${1}/${1}.1.trimmed.fastq \
-p $BASE_DIR/trimmed/${1}/${1}.2.trimmed.fastq \
$BASE_DIR/seqs/${1}/${1}_1.fastq.gz \
$BASE_DIR/seqs/${1}/${1}_2.fastq.gz \
> $BASE_DIR/logs/${1}.cutadapt.log
source deactivate cutadapt-env

mkdir -p $BASE_DIR/filtered/${1}
module load jdk/8.0_144
java -jar /home/workgroups/bio/apps/trimmomatic/0.36/trimmomatic-0.36.jar PE \
-threads 16 \
-phred33 \
-trimlog $BASE_DIR/logs/${1}.trimmomaticLog \
$BASE_DIR/trimmed/${1}/${1}.1.trimmed.fastq \
$BASE_DIR/trimmed/${1}/${1}.2.trimmed.fastq \
$BASE_DIR/filtered/${1}/${1}.forward.paired.fastq \
$BASE_DIR/filtered/${1}/${1}.forward.unpaired.fastq \
$BASE_DIR/filtered/${1}/${1}.reverse.paired.fastq \
$BASE_DIR/filtered/${1}/${1}.reverse.unpaired.fastq \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:15 \
MINLEN:6
module unload jdk/8.0_144

source activate idba-env
fq2fa --merge --filter \
$BASE_DIR/filtered/${1}/${1}.forward.paired.fastq \
$BASE_DIR/filtered/${1}/${1}.reverse.paired.fastq \
$BASE_DIR/filtered/${1}/${1}.merged.fa

mkdir -p $BASE_DIR/assembly/${1}
idba_ud \
--num_threads 16 \
-r $BASE_DIR/filtered/${1}/${1}.merged.fa \
-o $BASE_DIR/assembly/idba_ud/${1}
source deactivate idba-env

echo $1 complete
echo
