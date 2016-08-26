#! /gpfs/barnes_home/shettyan/tools/R-3.3.1/bin/Rscript --vanilla --default-packages=utils
args <- commandArgs()
tgp_dat=args[9]                     #### Command line input TGP file 
bigH_dat=args[7]                    ####Command line input for Bigham file
file_name=args[11]                  ### Command line input as chromosome name
bim2 = read.table(bigH_dat, header=F,sep="\t", quote="",stringsAsFactors=FALSE) 
bim1 = read.table(tgp_dat, header=F, sep="\t",quote="",stringsAsFactors=FALSE)
common.snps=merge(bim1,bim2,by=c("V1","V3","V4"))
colnames(common.snps)=c('chr','genetic_dist','pos','TGP_snp','TGP_A1','TGP_A2','BigHam_snp','BigHam_A1','BigHam_A2')
common.snps=common.snps[nchar(common.snps$TGP_A1)==1&nchar(common.snps$TGP_A2)==1&nchar(common.snps$BigHam_A1)==1&nchar(common.snps$BigHam_A2)==1,]
non_amb_bh=common.snps[common.snps$BigHam_A1=="G"&common.snps$BigHam_A2!="C"|common.snps$BigHam_A1=="C"&common.snps$BigHam_A2!="G"|common.snps$BigHam_A1=="T"&common.snps$BigHam_A2!="A"|common.snps$BigHam_A1=="A"&common.snps$BigHam_A2!="T",]
non_amb_bh_1=non_amb_bh[non_amb_bh$TGP_A1=="G"&non_amb_bh$TGP_A2!="C"|non_amb_bh$TGP_A1=="C"&non_amb_bh$TGP_A2!="G"|non_amb_bh$TGP_A1=="T"&non_amb_bh$TGP_A2!="A"|non_amb_bh$TGP_A1=="A"&non_amb_bh$TGP_A2!="T",]
#write.table(bim2$V2[common.snps], file=paste(file_name, "_merged_TGP_BigHAM.txt", sep=""), sep="\t", col.names=F, row.names=F, quote=F )
tt=subset(non_amb_bh_1,select=c("chr","TGP_snp","genetic_dist","pos","TGP_A1","TGP_A2"))
tt1=subset(non_amb_bh_1,select=c("chr","BigHam_snp","genetic_dist","pos","BigHam_A1","BigHam_A2"))
#tt2=tt[(tt$TGP_A1=="A"|tt$TGP_A1=="T")&(tt$TGP_A2=="G"|tt$TGP_A2=="C")|(tt$TGP_A1=="G"|tt$TGP_A1=="C")&(tt$TGP_A2=="A"|tt$TGP_A2=="T"),]
#tt3=tt1[(tt1$BigHam_A1=="A"|tt1$BigHam_A1=="T")&(tt1$BigHam_A2=="G"|tt1$BigHam_A2=="C")|(tt1$BigHam_A1=="G"|tt1$BigHam_A1=="C")&(tt1$BigHam_A2=="A"|tt1$BigHam_A2=="T"),]
write.table(tt,file=paste(file_name, "_merged_filtered_TGP.txt", sep=""), sep="\t", row.names=F, quote=F )
write.table(tt1,file=paste(file_name, "_merged_filtered_BigHAM.txt", sep=""), sep="\t", row.names=F, quote=F )
