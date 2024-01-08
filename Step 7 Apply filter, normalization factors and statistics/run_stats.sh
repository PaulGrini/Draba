#!/bin/sh

echo modules
module --force purge
module load StdEnv
module load GCCcore/11.3.0
module load Python/3.10.4-GCCcore-11.3.0
module load R-bundle-Bioconductor/3.15-foss-2022a-R-4.2.1
module list

p=python3
s= # Location to scripts (src) on MOLBAR_HOME

echo
echo filter
function filter() {
    echo "Filter $1 excluding $2"
    ${p} ${s}/apply_filter_to_counts.py ${2} ${1}.counts.csv > ${1}.filtered
    echo "Statistics $1"
    ${p} ${s}/statistics_from_counts.py --debug ${s}/limma.foldchange.r ${1}.filtered
}
filter AlaNor Combined.genes_pass_filter
filter NorAla Combined.genes_pass_filter

echo
echo clean up
rm -v *.json
rm -v *.counts.csv
rm -v *.filtered
# statistics_from_counts.py leaves behind timestamps in *json files
#echo JUST FOR DEBUGGING NO clean up

echo
echo "Look here for P-value statistics."
ls -l *.final.csv

echo
echo done
