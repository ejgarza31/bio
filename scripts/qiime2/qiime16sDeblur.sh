#!/bin/bash
#*****************************************************************************
# Script that will execute common qiime2 commands to import paired-end reads,
# join, filter, and denoise using deblur. No metadata is required for this
# script. A manifest file must first be created. 
#
# The next three lines are the input variables you should modify:
#  * ROOT - is the directory where all output artifacts are saved. To start, 
#           ROOT dir should include the manifest file as well as this script.
#  * PREFIX - is the name for the analysis/samples that gets prepended to 
#             each output artifact
#  * MANIFEST - the filename of the manifest text file in the ROOT dir
#*****************************************************************************
ROOT=/home/eegarza/Qiime
PREFIX=bigHorn
MANIFEST=bigHornManifest.txt

date | awk '{print $2" "$3" "$4}'
module load bio/qiime2/2019.4

echo "Importing using QIIME2"
INPUT="$ROOT/$MANIFEST"
OUTPUT="$ROOT/${PREFIX}Demux.qza"
INPUTFORMAT="PairedEndFastqManifestPhred33V2"
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $INPUT \
  --output-path $OUTPUT \
  --input-format $INPUTFORMAT

echo "Joining using Vsearch"
INPUT=$OUTPUT
OUTPUT=$(echo $OUTPUT | sed 's/.qza$/Joined.qza/g')
qiime vsearch join-pairs \
  --i-demultiplexed-seqs $INPUT \
  --o-joined-sequences $OUTPUT

echo "Filtering"
INPUT=$OUTPUT
OUTPUT=$(echo $OUTPUT | sed 's/.qza$/Filtered.qza/g')
OUTPUTSTATS=$(echo $OUTPUT | sed 's/.qza$/Stats.qza/g')
qiime quality-filter q-score-joined \
  --i-demux $INPUT \
  --p-min-quality 4 \
  --p-quality-window 3 \
  --p-min-length-fraction 0.75 \
  --p-max-ambiguous 0 \
  --o-filtered-sequences $OUTPUT \
  --o-filter-stats $OUTPUTSTATS \
  --verbose

echo "Denoising using Deblur"
INPUT=$OUTPUT
OUTPUT=$(echo $OUTPUT | sed 's/.qza$/Deblur.qza/g')
OUTPUTTABLE=$(echo $OUTPUT | sed 's/.qza$/Table.qza/g')
OUTPUTSTATS=$(echo $OUTPUT | sed 's/.qza$/Stats.qza/g')
qiime deblur denoise-16S \
  --i-demultiplexed-seqs $INPUT \
  --p-trim-length 250 \
  --p-jobs-to-start 12 \
  --o-representative-sequences $OUTPUT \
  --o-table $OUTPUTTABLE \
  --p-sample-stats \
  --o-stats $OUTPUTSTATS \
  --output-dir $ROOT/denoise \
  --verbose

date | awk '{print $2" "$3" "$4}'
