#!/bin/bash
module load jdk/8.0_144
BASE_DIR=/home/eegarza/nyu-project

java -jar /apps/trimmomatic/0.36/trimmomatic-0.36.jar PE \
-threads 16 \
-phred33 \
-trimlog $BASE_DIR/logs/SRR1976948.trimmomaticLog \
$BASE_DIR/trimmed/SRR1976948.1.trimmed.fastq \
$BASE_DIR/trimmed/SRR1976948.2.trimmed.fastq \
$BASE_DIR/filtered/SRR1976948.forward.paired.fastq \
$BASE_DIR/filtered/SRR1976948.forward.unpaired.fastq \
$BASE_DIR/filtered/SRR1976948.reverse.paired.fastq \
$BASE_DIR/filtered/SRR1976948.reverse.unpaired.fastq \
LEADING:3 \
TRAILING:3 \
SLIDINGWINDOW:4:15 \
MINLEN:6

