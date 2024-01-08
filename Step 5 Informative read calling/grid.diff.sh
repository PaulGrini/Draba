#!/bin/sh

# Process every heterozygous bam file.
# Create text files of maps per read.

echo "Submit AxN"
sbatch --account=${ACCOUNT} run_diff.sh Sample_33
sbatch --account=${ACCOUNT} run_diff.sh Sample_34
sbatch --account=${ACCOUNT} run_diff.sh Sample_35
sbatch --account=${ACCOUNT} run_diff.sh Sample_36

echo "Submit NxA"
sbatch --account=${ACCOUNT} run_diff.sh Sample_37
sbatch --account=${ACCOUNT} run_diff.sh Sample_38
sbatch --account=${ACCOUNT} run_diff.sh Sample_39
sbatch --account=${ACCOUNT} run_diff.sh Sample_40

echo "Done"
