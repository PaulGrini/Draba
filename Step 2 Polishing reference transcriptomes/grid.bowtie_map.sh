#!/bin/sh

# Command line parameter gives the number for this round.
# Give a zero for the initial round where we map to Araport11.
# Give a 1 to map to consensus_1, etc.

if [ $# -eq 0 ]; then
    echo "Please provide the number of this round."
    exit 1
fi
ROUND=$1
echo ROUND $ROUND
TRIM_BASE='/Trimmed' #Location of trimmed reads
CONS_DIR="consensus_${ROUND}"
MAP_DIR="map_to_consensus_${ROUND}"

echo "DIRECTORY SETUP"
mkdir ${MAP_DIR}
cd ${MAP_DIR}
pwd

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
    DIR1="${SAMPLE}.Reference_1"
    rm -rf $DIR1
    mkdir $DIR1
    cd $DIR1
    if [ $DD -lt 6 ]; then
         ln -s ../../${CONS_DIR}/Alaska.* .
    else
         ln -s ../../${CONS_DIR}/Norway.* .
    fi
    ln -s ${TRIM_BASE}/Reference_1/*${SAMPLE}*.fq.gz .
    cd ..
    # 
    DIR2="${SAMPLE}.Reference_2"
    rm -rf $DIR2
    mkdir $DIR2
    cd $DIR2
    if [ $DD -lt 6 ]; then
         ln -s ../../${CONS_DIR}/Alaska* .
    else
         ln -s ../../${CONS_DIR}/Norway* .
    fi
    ln -s ${TRIM_BASE}/Reference_2/*${SAMPLE}*.fq.gz .
    cd ..
done

echo
echo "GRID SUBMIT"

export ACCOUNT= #Account name/number to submit to the server
export MOLBAR_HOME= #Location of scripts

# Visit every subdirectory
for D in Sample_*/;
do
    cd $D
    sbatch --account=${ACCOUNT} ../../bowtie_map.sh
    cd ..
done
echo DONE
cd ..
