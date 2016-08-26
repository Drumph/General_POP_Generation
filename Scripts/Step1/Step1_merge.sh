#!/bin/bash
#SBATCH -p defq # Partition
#SBATCH -n 15              # 15 CPU
#SBATCH -N 1              # on one node
#SBATCH -t 0-4:00         # Running time of 12 hours
#SBATCH --error=merge_filter.err
#SBATCH --share 
#SBATCH --mail-user=aniket.shetty@ucdenver.edu
#SBATCH --mail-type=END
cd /gpfs/barnes_home/shettyan/scripts
i=0
while read line; do
((i++))
varname="var$i"
printf -v $varname "$line"
done < /gpfs/barnes_home/shettyan/scripts/final_file.txt

for j in `seq 2 $i`; do

curr_var=var$j
eval curr_var=\$$curr_var
##echo item: $curr_var

if [ "$curr_var" != "" ]; then

id_name=`echo $curr_var | awk 'END {print $1}'`     ### get each of the chromosome number
f1=`echo $curr_var | awk 'END {print $2}'`
f2=`echo $curr_var | awk 'END {print $3}'`

name="chr"$id_name                                  ##### chromosome number saved to the variable
filename=$(basename "$1")                            ### extracting filename from the path
extension="${filename##*.}"                          ### extensions of the file
filename="${filename%.*}"                            #### LP6008052-DNA_D01.SNPs.vcf
filename=$(echo $filename | cut -f 1,2 -d '.')       ### extracting filename without extensions
name_file=$filename"."$name                          #### pasting the chromosome number to the filename
bgzip_file=$name_file".recode.vcf"  
tab_file=$bgzip_file".gz"
/gpfs/barnes_home/shettyan/tools/R-3.3.1/bin/Rscript merge.r --args $id_name --args $f1 --args $f2
fi
done
