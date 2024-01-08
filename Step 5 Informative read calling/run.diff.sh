#!/bin/sh

#SBATCH --account=${ACCOUNT}
#SBATCH --job-name=Diff
#SBATCH --time=04:00:00  
#SBATCH --mem-per-cpu=4G  
#SBATCH --cpus-per-task=4  

set -o errexit # exit on errors

module --force purge
module load StdEnv 
module load GCC/8.2.0-2.31.1 
module load Python/3.7.2-GCCcore-8.2.0
module load SAMtools/1.9-GCC-8.2.0-2.31.1
module load Bowtie2/2.3.5.1-GCC-8.2.0-2.31.1
module list

export SRC= # Location to scripts in MOLBAR_HOME

echo $1

date
echo differential_mapping.py
python3 ${SRC}/differential_mapping.py  map_${1}/Primary.bam --debug 1> ${1}.out 2> ${1}.err

date
echo count_diffmap_per_gene.py
python3 ${SRC}/count_diffmap_per_gene.py  ${1}.out > ${1}.tsv


echo "DONE"
date
