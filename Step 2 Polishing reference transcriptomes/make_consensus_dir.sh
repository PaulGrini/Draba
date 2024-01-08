#!/bin/sh

# Command line parameter 1 gives the number for this round.
# Give a one for the initial round where we mapped to ref (original Alaska transcriptome) i.e consensus_0.
# This will build a pilon consensus for Alaska and another for Norway.

if [ $# -eq 0 ]; then
    echo "Please provide the number of this round."
    exit 1
fi
ROUND=$1
let PREV=${ROUND}-1
WORK_DIR=consensus_${ROUND}
PREV_REF=consensus_${PREV}
PREV_MAP=map_to_consensus_${PREV}
echo WORK_DIR $WORK_DIR
echo PREV_REF $PREV_REF
echo PREV_MAP $PREV_MAP
echo

date

echo MODULE
module purge
module load GCC/8.2.0-2.31.1 
module load SAMtools/1.9-GCC-8.2.0-2.31.1   ## saga
module load Pilon/1.23-Java-11  ## saga
module list
echo

mkdir ${WORK_DIR}
cd ${WORK_DIR}
pwd
echo

echo "Alaska"
ln -s ../${PREV_REF}/Alaska.fasta prev.Alaska.fasta
samtools view -b -H ../${PREV_MAP}/Sample_25_A1/Sorted.bam > Alaska.header.bam  
echo MERGE
samtools merge -h Alaska.header.bam -@ 4 -O BAM Alaska.bam \
../${PREV_MAP}/Sample_25_A1/Sorted.bam \
../${PREV_MAP}/Sample_26_A3/Sorted.bam \
../${PREV_MAP}/Sample_27_A4/Sorted.bam \
../${PREV_MAP}/Sample_28_A5/Sorted.bam 

date
echo "Norway"
ln -s ../${PREV_REF}/Norway.fasta prev.Norway.fasta
samtools view -b -H ../${PREV_MAP}/Sample_29_N1/Sorted.bam > Norway.header.bam
echo MERGE
samtools merge -h Norway.header.bam -@ 4 -O BAM Norway.bam \
../${PREV_MAP}/Sample_29_N1/Sorted.bam \
../${PREV_MAP}/Sample_30_N2/Sorted.bam \
../${PREV_MAP}/Sample_31_N3/Sorted.bam \
../${PREV_MAP}/Sample_32_N6/Sorted.bam 

cd ..
date
