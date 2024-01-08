#!/bin/sh

#Expect a folder 'reference' that contains the polished Alaska and Norway reference transcriptomes from step 1

DATA1[0]="Sample_25_A1"
DATA1[1]="Sample_26_A3"
DATA1[2]="Sample_27_A4"
DATA1[3]="Sample_28_A5"
DATA1[4]="Sample_29_N1"
DATA1[5]="Sample_30_N2"
DATA1[6]="Sample_31_N3"
DATA1[7]="Sample_32_N6"

for DD in `seq 0 7` ; do
    SAMPLE=${DATA1[${DD}]}
    DIR1="${SAMPLE}
    rm -rf $DIR1
    mkdir $DIR1
    cd $DIR1
    ln -s ../reference/* . 
    ln -s /Trimmed/Reference_1/*${SAMPLE}*.fq.gz . #Location to trimmed reads
    cd ..
  
done

echo DONE
