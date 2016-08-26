###Overview####
step2_extract.sh this script output's plink binary files
making_bed.txt this script consists of file path of the raw TGP and bigham files


###Description#####
The making_bed.txt contains three columns the first column is the chromosome number, the the second column is the full path of raw Bigham binary data(bed,bim,fam) ,and the third column is  the full path of the raw TGP data.
*** The "step2_extract.sh" has the path mentioned, so the output is created in the path. This script also uses the output of the first script, So please check the path and make sure it's right before executing the script.

###Functions###
The Step2_extract.sh does two things first it takes the output files of the first script and makes a snp list which are stored with extension "*_snpName_Bigham.txt" and "*_snpName_TGP.txt". Then, it makes use of this list to subset the raw files which are in "making_bed.txt" column one and column two and creates a binary files for each of the datasets.

###Running the script###
sbatch step2_extract.sh

###Output file###
/gpfs/barnes_share/testing/TGP_BARNES/part2/

