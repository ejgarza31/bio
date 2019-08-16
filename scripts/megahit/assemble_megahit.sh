module load anaconda3/4.3.1
source activate py35_bio
megahit -1 $1 -2 $2 -o $3 
