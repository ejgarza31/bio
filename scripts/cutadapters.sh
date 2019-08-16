#!/bin/bash

module load anaconda3/4.3.1
source activate cutadapt-env
BASE_DIR=/home/eegarza/nyu-project

cutadapt -j 16 \
-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
-o $BASE_DIR/trimmed/${1}.1.trimmed.fastq \
-p $BASE_DIR/trimmed/${1}.2.trimmed.fastq \
$BASE_DIR/seqs-paired/${1}_1.fastq.gz \
$BASE_DIR/seqs-paired/${1}_2.fastq.gz \
> $BASE_DIR/logs/${1}.cutadapt.log

