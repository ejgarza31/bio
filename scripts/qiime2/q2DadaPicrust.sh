#!/bin/bash
#SBATCH --job-name=q2DADA
#SBATCH --output=q2DADA.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=3750
#SBATCH --partition=batch

##****************************************************************************
## qiime2 commands to import paired-end reads, join, filter, and 
## denoise using dada2. No sample metadata is required. A manifest file 
## must first be created. 
##
## The next three lines are the input variables you should modify:
##  * ROOT - is the directory where all output artifacts are saved. To start, 
##           ROOT dir should include the manifest file as well as this script.
##  * PREFIX - is the name for the analysis/samples that gets prepended to 
##             each output artifact
##  * MANIFEST - the filename of the manifest text file in the ROOT dir. The 
##               manifest can point to reads saved in a directory outside ROOT.
##*****************************************************************************

ROOT=/nobackup/eegarza/Qiime
PREFIX=corpusChristi
MANIFEST=corpusChristiManifest.txt

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

echo "Denoising using DADA2"
INPUT=$OUTPUT
OUTPUT=$(echo $OUTPUT | sed 's/.qza$/Dada.qza/g')
OUTPUTTABLE=$(echo $OUTPUT | sed 's/.qza$/OTUTable.qza/g')
OUTPUTREPSQ=$(echo $OUTPUT | sed 's/.qza$/Repseqs.qza/g')
OUTPUTSTATS=$(echo $OUTPUT | sed 's/.qza$/DADADenoiseStats.qza/g')
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $INPUT \
  --p-trim-left-f 16 \
  --p-trim-left-r 16 \
  --p-trunc-len-f 210 \
  --p-trunc-len-r 210 \
  --o-table $OUTPUTTABLE \
  --o-representative-sequences $OUTPUTREPSQ \
  --o-denoising-stats $OUTPUTSTATS
  --p-n-threads $SLURM_CPUS_PER_TASK

echo "Exporting aplicon sequences from DADA2 output for use in PICRUSt2"
qiime tools export --input-path $OUTPUTREPSQ --output-path $ROOT/DADA2seqs/

echo "Exporting OTU table from DADA2 output for use in PICRUSt2"
qiime tools export --input-path $OUTPUTTABLE  --output-path $ROOT/DADA2table/

echo "Running PICRUSt2"
source activate /apps/bio-conda
picrust2_pipeline.py \
-s $ROOT/DADA2seqs/dna-sequences.fasta \
-i $ROOT/DADA2table/feature-table.biom \
-o $ROOT/${prefix}Picrust2

date | awk '{print $2" "$3" "$4}'

