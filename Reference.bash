#!/bin/bash


#The paired read should be downloaded from ENA. Also the reference genome is provided as well. Find link in the folders provided
#Move downloaded files to the directory path of your computer
#Ensure that burrow wheeler aligner is installed on your computer

#create a directory for files
mkdir Chl
#check if downloaded file are present in the working directory
ls -l Chl/

#create an index for the genome
bwa index ChlRef.fasta 

#run the alignment process for seperate forward and reverse reads
bwa aln ChlRef.fasta ERR3402420_1.fastq.gz > Chl_1.aln.sai
bwa aln ChlRef.fasta ERR3402420_2.fastq.gz > Chl_2.aln.sai

#collate the complete alignment in SAM format and use the five files generated as input
bwa sampe ChlRef.fasta Chl_1.aln.sai Chl_2.aln.sai ERR3402420_1.fastq.gz ERR3402420_2.fastq.gz > Chl.aln.sam

#convert from SAM to BAM format, sort the BAM alignments, and generate index files
samtools faidx ChlRef.fasta
samtools import ChlRef.fasta.fai Chl.aln.sam Chl.aln.bam
samtools sort Chl.aln.bam Chl.aln.sorted
samtools index Chl.aln.sorted.bam

#generate a consensus sequence from the alignment and summarize the positions in the sorted alignment
samtools mpileup -u –f ChlRef.fasta Chl.aln.sorted.bam > pilefile.bcf

#extract a consensus sequence from the bcf file
bcftools view –c pilefile.bcf > consensus.vcf
