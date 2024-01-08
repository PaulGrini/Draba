#!/bin/sh

echo modules
module --force purge
module load StdEnv
module load GCCcore/11.3.0
module load Python/3.10.4-GCCcore-11.3.0
module load R-bundle-Bioconductor/3.15-foss-2022a-R-4.2.1
module list

p=python3
s=# Location to scripts (src) on MOLBAR_HOME

# This script will generate csv files.
# There shouldn't be any csv files in this directory.
# If there are, they are assumed to be input and lead to redundant outputs.
# In case we rerun this script, we need to get rid of the previously generated csv files.

echo
echo clean up
rm -v *.log
rm -v *.csv

echo
echo prepare
# Collate four replicates into one row per gene like MAT,MAT,MAT,PAT,PAT,PAT.
# Generate several files like this one called AlaNor.counts.csv

$p ${s}/prepare_heterozygous_counts.py AlaNor.model.tsv
echo -n $?
echo " exit status"
echo
echo "Prepared these csv files:"
ls *.csv

echo done
