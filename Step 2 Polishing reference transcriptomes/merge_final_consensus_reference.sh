#!/bin/sh

echo SETUP
module --force purge
module load StdEnv 
module load GCC/8.2.0-2.31.1 
module load Python/3.7.2-GCCcore-8.2.0
module load SAMtools/1.9-GCC-8.2.0-2.31.1
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1

echo DIRECTORY
mkdir final_reference
cd final_reference

CONSENSUS_DIR= # Location to the final consensus_ directory
PILON_SUFFIX="_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon"

echo EXTRACT Alaska
cat ${CONSENSUS_DIR}/Alaska.fasta | \
sed 's/_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon//' \
> AlaNor.fasta

echo EXTRACT Norway
cat ${CONSENSUS_DIR}/Norway.fasta | \
sed 's/_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon_pilon//' \
>> AlaNor.fasta

echo INDEX

bowtie2-build AlaNor.fasta AlaNor

cd ..
echo DONE
