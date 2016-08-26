#!/bin/bash
#SBATCH -p defq # Partition
#SBATCH -n 1              # one CPU
#SBATCH -N 1              # on one node
#SBATCH -t 0-1:00         # Running time of 1 hours
#SBATCH --error=job.%J.err # creating error file for each job id's
#SBATCH --share 
#SBATCH --mail-user=          ###your email id (isn't necessary)
#SBATCH --mail-type=END
##Read the filenames for each set
export PERL5LIB=~/tools/vcftools_0.1.13/perl            ### PAth to the perl library of vcftools
export PATH=~/tools/tabix/:$PATH                        ###PATH to the tabix library
cd /gpfs/barnes_home/shettyan/scripts/
i=0
while read line; do
((i++))
varname="var$i"
printf -v $varname "$line"
done < /gpfs/barnes_home/shettyan/scripts/BigHAM_TGP_flip.txt          

for j in `seq 2 $i`; do
curr_var=var$j
eval curr_var=\$$curr_var
##echo item: $curr_var

if [ "$curr_var" != "" ]; then

id_name=`echo $curr_var | awk 'END {print $1}'`     ### get each of the chromosome number
f1=`echo $curr_var | awk 'END {print $2}'`

filename=$(basename "$id_name")                            ### extracting filename from the path
extension="${filename##*.}"                          ### extensions of the file
filename="${filename%.*}"                            #### LP6008052-DNA_D01.SNPs.vcf
filename=$(echo $filename | cut -f 1,2,4 -d '_')       ### extracting filename without extensions
out_file="Bigham_TGP_"$filename
out_file2="Bigham_TGP_2"$filename
missing_file1=$out_file"-merge.missnp"
missing_flipped=$out_file"_flipped"
missing_file2=$out_file2"-merge.missnp"
final_file_BH=$id_name"_final"
final_file_TGP=$f1"_final"
#Flip file 1 markers to file 2 markers
#-First get a list of SNPs to flip
/gpfs/barnes_share/Software/plink2 --bfile  $id_name --bmerge ${f1}.bed ${f1}.bim ${f1}.fam --make-bed --out $out_file
#-Then flip the markers
if [ -e "${missing_file1}" ]
then
/gpfs/barnes_share/Software/plink2 --bfile  $id_name --flip $missing_file1 --make-bed --out  $missing_flipped
else
/gpfs/barnes_share/Software/plink2 --bfile  $id_name --make-bed --out $missing_flipped
fi
#-Are there any markers that cannot be merged after flip? If so, delete them from both data sets
#remove the previous ".missnp" file
#rm $missing_file1
/gpfs/barnes_share/Software/plink2 --bfile  $missing_flipped --bmerge ${f1}.bed ${f1}.bim ${f1}.fam --make-bed --out $out_file2
if [ -e "${missing_file2}" ]
then
/gpfs/barnes_share/Software/plink2 --bfile  $missing_flipped --exclude $missing_file2 --make-bed --out  $final_file_BH
/gpfs/barnes_share/Software/plink2 --bfile  $f1 --exclude $missing_file2 --make-bed --out  $final_file_TGP
else
/gpfs/barnes_share/Software/plink2 --bfile  $missing_flipped --make-bed --out  $final_file_BH
/gpfs/barnes_share/Software/plink2 --bfile  $f1 --make-bed --out  $final_file_TGP
fi
fi
