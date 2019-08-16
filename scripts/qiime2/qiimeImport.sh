#!/bin/bash


TYPE="SampleData[PairedEndSequenceWithQuality]"
ROOT=/home/eegarza/Qiime
INPUTPATH="$ROOT/manifestOnlyFour.txt"
OUTPUTPATH="$ROOT/deepFour.qza"
INPUTFORMAT="PairedEndFastqManifestPhred33V2"

date | awk '{print $2" "$3" "$4": "}';
hostname;
pwd;

module load bio/qiime2/2019.4
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path $INPUTPATH --output-path $OUTPUTPATH --input-format $INPUTFORMAT

