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
ANTS_OUT=$(pwd -P)"/lct_out.nc"
CCI_FILE="ants_out.nc"
LSM_OUT="cci_maskout"
CONFIG_FILE="ants.config"
LSM_FILE="qrparm.mask_igbp"

#singularity exec --home $ANTS_HOME $ANTS_CONTAINER bin/ancil_lct.py $CCI_FILE --output $ANTS_OUT --target-grid grid.nl --transform-path bin/cci2jules.json --landseamask-output $LSM_OUT --ants-config $CONFIG_FILE

singularity exec --home $ANTS_HOME $ANTS_CONTAINER bin/ancil_lct.py $CCI_FILE --output $ANTS_OUT --transform-path bin/cci2jules.json --ants-config $CONFIG_FILE --target-lsm $LSM_FILE
