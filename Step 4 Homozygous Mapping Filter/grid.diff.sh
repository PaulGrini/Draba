#!/bin/sh

echo "Submit Alaska"
sbatch --account=${ACCOUNT} run_diff.sh Sample_25_A1
sbatch --account=${ACCOUNT} run_diff.sh Sample_26_A3
sbatch --account=${ACCOUNT} run_diff.sh Sample_27_A4
sbatch --account=${ACCOUNT} run_diff.sh Sample_28_A5

echo "Submit Norway"
sbatch --account=${ACCOUNT} run_diff.sh Sample_29_N1
sbatch --account=${ACCOUNT} run_diff.sh Sample_30_N2
sbatch --account=${ACCOUNT} run_diff.sh Sample_31_N3
sbatch --account=${ACCOUNT} run_diff.sh Sample_32_N6

echo "Done"
