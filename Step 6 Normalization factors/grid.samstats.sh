#!/bin/sh

export ACCOUNT= # Account
export PYTHON_VENV= # Location to virtual environment
export MOLBAR_HOME= # Location to scripts
# Visit every subdirectory
for D in Sample_*/;
do
    cd $D
    sbatch --account=${ACCOUNT} ../samstats.sh
    cd ..
done
echo DONE
