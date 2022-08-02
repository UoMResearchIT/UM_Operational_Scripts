#!/bin/bash

#SBATCH --job-name=ants_cci
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=n02-NEV012681
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

ANTS_HOME=$(pwd -P)
ANTS_CONTAINER=/work/y07/shared/umshared/ANTS/latest/ants_latest.sif
#export SINGULARITYENV_APPEND_PATH=$(pwd -P)"/bin"
ANTS_OUT=$(pwd -P)"/qrparm.veg.frac.cci"
CCI_FILE="postC4_regrid.nc"
CONFIG_FILE="ants.highmem.config"


singularity exec --home $ANTS_HOME $ANTS_CONTAINER bin/ancil_2anc.py $CCI_FILE --output $ANTS_OUT
