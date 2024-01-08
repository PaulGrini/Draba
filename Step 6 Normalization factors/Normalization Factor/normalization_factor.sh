#!/bin/sh

echo modules
module purge
module load Python/3.6.6-foss-2018b
module load R-bundle-Bioconductor/3.8-foss-2018b-R-3.5.1

p=python3
s= # Location to scripts (src) at MOLBAR_HOME

# This script will generate csv files.
# There shouldn't be any csv files in this directory.
# If there are, they are assumed to be input and lead to redundant outputs.
# In case we rerun this script, we need to get rid of the previously generated csv files.
echo
echo clean up

${p} ${s}/normalize_counts.py --debug AlaNor.counts.csv AlaNor.out.csv > AlaNor.normfactors.csv
${p} ${s}/normalize_counts.py --debug NorAla.counts.csv NorAla.out.csv > NorAla.normfactors.csv

echo
echo done
