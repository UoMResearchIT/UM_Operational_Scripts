#!/bin/bash

#SBATCH --job-name=ants_lct
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=<youraccount>
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

ANTS_HOME=$(pwd -P)
ANTS_CONTAINER=/work/y07/shared/umshared/ANTS/latest/ants_latest.sif
#export SINGULARITYENV_APPEND_PATH=$(pwd -P)"/bin"
ANTS_OUT=$(pwd -P)"/lct_out.nc"
CCI_FILE="ants_out.nc"
CONFIG_FILE="ants.highmem.config"
LSM_MASK="qrparm.mask"
TRANSFORM="bin/cci2jules_ra1_reslakes.json"


singularity exec --home $ANTS_HOME $ANTS_CONTAINER \
            bin/ancil_lct.py $CCI_FILE \
            --output $ANTS_OUT \
            --target-lsm $LSM_MASK \
            --transform-path $TRANSFORM
