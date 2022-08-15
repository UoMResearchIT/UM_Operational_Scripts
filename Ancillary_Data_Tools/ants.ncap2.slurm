#!/bin/bash

#SBATCH --job-name=ants_cci
#SBATCH --time=1:0:0
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1

#SBATCH --account=n02-NEV012681
#SBATCH --partition=serial
#SBATCH --qos=serial
#SBATCH --mem=124G

module load nco/5.0.5

ncap2 -s 'where(lccs_class == 130) lccs_class=101' ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7cds_oceanmask.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 140) lccs_class=102' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 150) lccs_class=103' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 151) lccs_class=104' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 152) lccs_class=105' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 153) lccs_class=106' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 160) lccs_class=107' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 170) lccs_class=108' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 180) lccs_class=109' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 190) lccs_class=111' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 200) lccs_class=112' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 201) lccs_class=113' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 202) lccs_class=114' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 210) lccs_class=115' ESACCI2.nc ESACCI2.nc
ncap2 -O -s 'where(lccs_class == 220) lccs_class=117' ESACCI2.nc ESACCI2.nc
