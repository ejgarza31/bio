#!/bin/bash

date;hostname; pwd
ROOT=/home/eegarza/Qiime

qiime dada2 denoise-paired --i-demultiplexed-seqs $ROOT/deepFour.qza --p-trim-left-f 16 --p-trim-left-r 16 --p-trunc-len-f 230 --p-trunc-len-r 220 --p-trunc-q 2 --p-max-ee 2 --o-table $ROOT/deepFourTable.qza --o-representative-sequences $ROOT/deepFourRepreSeqs.qza --o-denoising-stats $ROOT/deepFourDenoiseStats.qza --p-n-threads 16

date;hostname;pwd
