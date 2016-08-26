#!/bin/bash
#SBATCH -p defq # Partition
#SBATCH -n 15              # 15 CPU
#SBATCH -N 1              # on one node
#SBATCH -t 0-48:00         # Running time of 12 hours
#SBATCH --error=TGP_conv.err
#SBATCH --share 
#SBATCH --mail-user=aniket.shetty@ucdenver.edu
#SBATCH --mail-type=END
export PERL5LIB=~/tools/vcftools_0.1.13/perl
export PATH=~/tools/tabix-0.2.6:$PATH
cd /gpfs/barnes_home/shettyan/scripts
i=0
while read line; do
((i++))
varname="var$i"
printf -v $varname "$line"
done < /gpfs/barnes_home/shettyan/scripts/making_bed.txt          #### List of chromosome 1-22

for j in `seq 2 $i`; do

curr_var=var$j
eval curr_var=\$$curr_var
##echo item: $curr_var

if [ "$curr_var" != "" ]; then

id_name=`echo $curr_var | awk 'END {print $1}'`     ### get each of the chromosome number
f1=`echo $curr_var | awk 'END {print $2}'`
f2=`echo $curr_var | awk 'END {print $3}'`
name="chr"$id_name                                  ##### chromosome number saved to the variable
filename=$(basename "$id_name")                            ### extracting filename from the path
extension="${filename##*.}"                          ### extensions of the file
filename="${filename%.*}"                            #### LP6008052-DNA_D01.SNPs.vcf
filename=$(echo $filename | cut -f 1,2,3,4,5 -d '.')       ### extracting filename without extensions
bigham_snp=$id_name"_merged_filtered_BigHAM.txt"
TGP_snp=$id_name"_merged_filtered_TGP.txt"
out_bigHAM=$id_name"_snpName_Bigham.txt"
out_TGP=$id_name"_snpName_TGP.txt"
final_bigHAM=$id_name"_subset_BigHAM_snp"
final_TGP=$id_name"_subset_TGP_snp"
cut -f2 /gpfs/barnes_share/testing/TGP_BARNES/part1/$bigham_snp > $out_bigHAM  ##### gets the SNP's id's from the output of the first script
cut -f2 /gpfs/barnes_share/testing/TGP_BARNES/part1/$TGP_snp  > $out_TGP ######### gets the SNP's id's from the output of the first script
/gpfs/barnes_share/Software/plink2 --bfile $f1 --extract $out_bigHAM --make-bed --out $final_bigHAM
/gpfs/barnes_share/Software/plink2 --bfile $f2 --extract $out_TGP --make-bed --out $final_TGP
fi
done
