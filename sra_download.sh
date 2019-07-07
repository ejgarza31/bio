#!/bin/bash
# 
# DESCRIPTION:
#   Downloads sequences listed in accession file from NCBI SRA using
#   sra-toolkit binary. 
# 
# INPUT PARAMETER(s) (In Order): 
#   * Local path to save downloaded sequences
#
# OUTPUT:
#   * Compressed, Split (paired-end) sequences for each accession number
#     listed in accession file if the accession number is valid
#
# ASSUMPTIONS:
#   * Accession numbers listed in a file named SRR_Acc_List.txt (which 
#     is the default file name if downloaded from NCBI) with 1 accession
#     number per line located in the current working directory.
#   * Path to fastq-dump (which is part of the sra-toolkit) is assumed
#   * No log file is generated
#   * No error checking is performed 
#   * prefetch (also part of the sra-toolkit is not run)

filename='SRR_Acc_List.txt'
while read p; do
  echo downloading $p
  ./sratoolkit.2.9.6-1-centos_linux64/bin/fastq-dump --split-files --gzip --outdir $1 $p
  echo $p complete
  echo
done < $filename
