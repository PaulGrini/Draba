#!/bin/sh

#SBATCH --account=$ACCOUNT
#SBATCH --job-name=pilon
#SBATCH --time=24:00:00 # pilon takes about 5 hours
#SBATCH --mem-per-cpu=18G  # pilon can require 18 GB RAM
#SBATCH --cpus-per-task=1  # pilone multi-threading is inefficient
# Jobs submit with 'arrayrun 1-10' receive a $TASK_ID.
# Jobs submit with 'sbatch --array=1-10' recieve a $SLURM_ARRAY_TASK_ID.

set -o errexit # exit on errors
# Pilon expected outputs
#savefile pilon.changes
#savefile pilon.fasta 

if [ $# -ne 2 ]; then
    echo "Please specify <Alaska|Norway> and number of this round."
    exit 1
fi
GENOME=$1
echo GENOME $GENOME
ROUND=$2
echo ROUND $ROUND
let PREV=${ROUND}-1
PREV_REF=consensus_${PREV}
PREV_MAP=map_to_consensus_${PREV}
echo PREV_REF $PREV_REF
echo PREV_MAP $PREV_MAP
INITIALDIR=`pwd`
echo INITIALDIR ${INITIALDIR}
echo

echo MODULES
module purge
module load SAMtools/1.9-GCC-8.2.0-2.31.1   
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1
module load Pilon/1.23-Java-11  ## saga
# To execute Pilon run: java -Xmx8G -jar $EBROOTPILON/pilon.jar
# Pilon Requirement: fasta file, bam file, bai index
# Pilon Requirement: about 18 GB RAM
JARFILE=$EBROOTPILON/pilon.jar
echo PILON JAR; ls -l $JARFILE
echo HEADER; ls -l $HEADERFILE
echo "Java version is:"
JAVA=`which java`
${JAVA} -showversion |& head -n 4
PILON="${JAVA} -Xmx16G -jar ${JARFILE}"
echo "Pilon command is: ${PILON}"
echo

# Here are some interesting pilon options
OPTIONS="--diploid "  # assume diploid
OPTIONS="--vcf"       # output a VCF
OPTIONS="--variant"   # heuristic for variants not assembly
OPTIONS="--fix all"   # correct bases, indels, and local misassembly and write a FASTA file
OPTIONS="--changes"   # show changes to the FASTA
# Use this set of options to generate the homozygous genome informed by reads.
OPTIONS="--fix all --changes --output ${GENOME}"
echo "Pilon options set to: ${OPTIONS}"
echo

echo "SAMTOOLS MERGE"
if [ "${GENOME}" == "Alaska" ] ; then
    echo "Alaska"
    ln -s ../${PREV_REF}/Alaska.fasta prev.Alaska.fasta
    samtools view -b -H ../${PREV_MAP}/Sample_25_A1/Sorted.bam > Alaska.header.bam
    samtools merge -h Alaska.header.bam -@ 4 -O BAM Alaska.bam \
        ../${PREV_MAP}/Sample_25_A1/Sorted.bam \
        ../${PREV_MAP}/Sample_26_A3/Sorted.bam \
        ../${PREV_MAP}/Sample_27_A4/Sorted.bam \
        ../${PREV_MAP}/Sample_28_A5/Sorted.bam 
fi
if [ "${GENOME}" == "Norway" ] ; then
    echo "Norway"
    ln -s ../${PREV_REF}/Norway.fasta prev.Norway.fasta
    samtools view -b -H ../${PREV_MAP}/Sample_29_N1/Sorted.bam > Norway.header.bam
    samtools merge -h Norway.header.bam -@ 4 -O BAM Norway.bam \
        ../${PREV_MAP}/Sample_29_N1/Sorted.bam \
        ../${PREV_MAP}/Sample_30_N2/Sorted.bam \
        ../${PREV_MAP}/Sample_31_N3/Sorted.bam \
        ../${PREV_MAP}/Sample_32_N6/Sorted.bam 
fi
echo

date
echo SAMTOOLS INDEX
samtools index -@ 4 ${GENOME}.bam
echo

date
echo START PILON
${PILON} --genome prev.${GENOME}.fasta --frags ${GENOME}.bam ${OPTIONS}
echo -n $?; echo " exit status"
echo DONE PILON
date
echo

echo START BOWTIE BUILD
bowtie2-build ${GENOME}.fasta ${GENOME}
date
echo DONE
