#!/bin/sh

# Rename counts.tsv to ${DATUM}.tsv

DATA[1]="Sample_33"
DATA[2]="Sample_34"
DATA[3]="Sample_35"
DATA[4]="Sample_36"
DATA[5]="Sample_37"
DATA[6]="Sample_38"
DATA[7]="Sample_39"
DATA[8]="Sample_40"


for DD in `seq 1 8`; do
    DATUM=${DATA[${DD}]}
    DIR="${DATUM}"
    echo $DIR
    cd $DIR
    mv counts.tsv ${DATUM}.tsv
    cd ..
done
