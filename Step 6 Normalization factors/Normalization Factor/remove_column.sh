#!/bin/sh

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
    sed -i -r 's/(\s+)?\S+//5' ${DATUM}.tsv
    sed -i -r 's/(\s+)?\S+//4' ${DATUM}.tsv
    sed -i -e '1s/pairs/count/' ${DATUM}.tsv
done
