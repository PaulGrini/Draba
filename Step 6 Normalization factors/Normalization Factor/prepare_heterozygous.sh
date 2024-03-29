#!/bin/sh

echo modules
module purge
module load Python/3.6.6-foss-2018b
module load R-bundle-Bioconductor/3.8-foss-2018b-R-3.5.1

p=python3
s= # Location to scripts (src) at MOLBAR_HOME

# This script will generate normalization factors.
# There should be a script that generates counts.csv for each sample.
# This should create counts.csv files of all replicates after mapping with bowtie before any filtering

echo
echo clean up
rm -v *.log
rm -v *.csv

echo
echo
echo prepare

$p ${s}/prepare_heterozygous_counts.py AlaNor.model.tsv 
echo -n $?
echo " exit status"

echo done
