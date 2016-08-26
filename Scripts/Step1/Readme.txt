###OVERVIEW#####
Step1_merge.sh is the main scripts which calls the "merge.r script"
merge.r script contains the R code to perform mergering of the two data datasets which are listed in the list file "final_file.txt"
final_file.txt contains the list of files from chr1 to chr22 of each of the TGP and Bigham data

###Run script#####
sh Step1_merge.sh

###Description###
Step1_merge.sh calls the merge.r script, which performs the merging of the files which are listed in file called "fina_file.txt" . The final_file.txt contains three columns the first column is the full path of Bigham data , the second column is the full path of the TGP data and the third column is the chromosome number.
*** The "Step_merge.sh" has the path mentioned where the merge.r and final_file.txt are present... Due to the path mentioned the output is also created in the path. So please check the path and make sure it's right before executing the script.

###Function of the script####
This script output the snp's list in the plink bim format.
The resulting scripts are cleaned(only biallelic snps are picked other are filtered out) snp list which are present in both TGP and Bigham data. The merging inside the R script is done based on position.
The output file of this script is used by the "step2_extract.sh" script to subset files only to these snps.
####OUTPUT file path####
The output of this script is stored in this path:
/gpfs/barnes_share/testing/TGP_BARNES/part1/
