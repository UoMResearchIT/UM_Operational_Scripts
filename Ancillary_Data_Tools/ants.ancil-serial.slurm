#!/bin/bash

#SBATCH --job-name=ants_cci
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=<youraccount>
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

module load nco
module load cray-hdf5
module load cray-netcdf

ANTS_HOME=$(pwd -P)
ANTS_CONTAINER=/work/y07/shared/umshared/ANTS/latest/ants_latest.sif
#export SINGULARITYENV_APPEND_PATH=$(pwd -P)"/bin"
ANTS_OUT=$(pwd -P)"/qrparm.veg.frac"
CCI_FILE="regrid_out.nc"
CONFIG_FILE="ants.highmem.config"

ncatted -a source,global,c,c,'Met Office Unified Model v11.7' $CCI_FILE

singularity exec --home $ANTS_HOME $ANTS_CONTAINER \
            bin/ancil_2anc.py $CCI_FILE \
            --output $ANTS_OUT \
            --grid-staggering=6
