#!/bin/sh 
#SBATCH --account=${ACCOUNT}
#SBATCH --job-name=Bowtie
#SBATCH --time=04:00:00   # Bowtie takes about 35 minutes
#SBATCH --mem-per-cpu=4G  # 16 GB total
#SBATCH --cpus-per-task=4  # 4 cpu is optimal for 4 threads

set -o errexit # exit on errors
# Our python will generate smaller Aligned.bam which we keep.

#savefile *.bam
#savefile *.db
#savefile *.log
#savefile *.SN

module --force purge
module load StdEnv 
module load GCC/8.2.0-2.31.1 
module load Python/3.7.2-GCCcore-8.2.0
module load SAMtools/1.9-GCC-8.2.0-2.31.1
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1
module list

echo LD_LIBRARY_PATH $LD_LIBRARY_PATH
echo WHICH PYTHON3
which python3
python3 --version
#expect MOLBAR_HOME= #Location of scripts
echo MOLBAR_HOME ${MOLBAR_HOME}

date
INITIALDIR=`pwd`
echo INITIALDIR ${INITIALDIR}
ls -l

echo
date
THREADS=4
TARGET=AlaNor    # name of the (link to the) fasta
echo THREADS $THREADS
R1=*_R1_*.fq.gz
R2=*_R2_*.fq.gz
echo R1 $R1
echo R2 $R2
echo TARGET ${TARGET}

echo
date
echo run Bowtie
# assumes *.fasta and *.bt2 have same first name
# for homozygous, remove option: --heterozygous
python3 ${MOLBAR_HOME}/src/mapping.py --debug ${TARGET} ${R1} ${R2} Aligned.out.sam
echo -n $?
echo " exit status"
date

echo run python filter
echo "Filter for primary alignments only"
echo "Filter for unspliced alignments only"
python3 ${MOLBAR_HOME}/src/samfilter.py Aligned.out.sam Primary.bam
echo -n $?
echo " exit status"
date

echo sort bam file
# the -T option is critical: uses local directory rather than /tmp
samtools sort --threads $THREADS -T tmp --output-fmt BAM -o Sorted.bam Primary.bam

echo stats
samtools flagstat Sorted.bam > samtools.flagstat
samtools stats Sorted.bam | grep '^SN' | cut -f 2- > samtools.stats.SN 

date
ls -l
echo DONE
