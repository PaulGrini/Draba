#!/bin/sh

date

module purge
module load GCC/8.2.0-2.31.1 
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1

mkdir consensus_0
cd consensus_0

echo Alaska
cat ../reference/ref.fasta |\
 awk '{if (substr($1,1,1)==">") print $1 "_Alaska"; else print $1;}' \
 > Alaska.fasta

bowtie2-build Alaska.fasta Alaska

echo Norway
cat ../reference/ref.fasta |\
   awk '{if (substr($1,1,1)==">") print $1 "_Norway"; else print $1;}' \
   > Norway.fasta

bowtie2-build Norway.fasta Norway

cd ..
date
