# ANTS_final
# <u>Ancillary Data Tools</u>

These are scripts for running the ANTS preprocessors for the Unified Model. Documentation for these preprocessors can be found in the [Met Office ANTS pages](https://code.metoffice.gov.uk/doc/ancil/ants/latest/introduction.html), and an introduction to the ANTS singularity container is available on the [NCAS ANTS pages](https://cms.ncas.ac.uk/miscellaneous/ants-container/).
These scripts are written for the ANTS v0.18 singularity container. The most recent release of the toolset container at the time of writing (May 2022). However, where necessary, v0.19 scripts have been used, and links to download these are provided below. These scripts are designed for use on the ARCHER2 HPC facility.
The scripts in this repository are intended for creating ancillary data for a limited area model domain over South America. Some of the configuration and input files included here may be domain specific - replace these with files for your domain if using these scripts for other studies.

Replace `<username>` with your Met Office user account name, and enter your password when it is requested. Scripts can take an hour to run.

## Overview of run order

1. Set up
  
2. **ants.ocean.slurm** to add ocean to cci data
  
3. **ants.ncap2.slurm** to change the CCI class numbers because anything >127 will not work with ants...
  
4. **ants.preproc-serial.archer2.slurm** for the ants preprocessing set
  
5. **ants.ncap2.ants_out.slurm**, similar to step 3, this may not be needed
  
6. **ants.lct-serial.archer2.slurm** to put it into UM format
  
7. **ants.postC4-serial.archer2.slurm**

8. **ants.regrid.slurm**
  
9. **ants.2anc.slurm**
  
10. **surface_type_merging_with_masks_v3.ipynb**

11. Copy to UM

  

## 1. Set up

###### Download v0.19 Ancil Tools

These should be taken directly from the Met Office code repository:

```bash
svn checkout https://code.metoffice.gov.uk/svn/ancil/ants/tags/0.19.0/bin/
svn checkout https://code.metoffice.gov.uk/svn/ancil/ants/trunk/rose-test/resources/
cp resources/transforms/cci2jules.json bin/
```

###### Download ESACCI Land Use Data

ESA CCI data should be downloaded from Copernicus:

[Copernicus Climate Data Store |](https://cds.climate.copernicus.eu/cdsapp#!/dataset/satellite-land-cover?tab=overview)

If data is taken from Copernicus then need to remove a dimension otherwise 3d when expecting 2d and ants throws an error. This is accounted for in the ants.ocean.slurm scripts.

###### Water bodies

This is added to the CCI, as CCI does not differentiate between ocean and water

[Index of /neodc/esacci/land_cover/data/water_bodies/v4.0/](https://dap.ceda.ac.uk/neodc/esacci/land_cover/data/water_bodies/v4.0/)

###### MODIS land cover

MODIS data, use modis_landcover_qdeg (quarter degree)

[ISLSCP II MODIS (Collection 4) IGBP Land Cover, 2000-2001 , https://doi.org/10.3334/ORNLDAAC/968](https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=968)

###### Upload to archer2

If above files downloaded locally, transfer to archer2

```bash
scp <filename> <username>@login.archer2.ac.uk:/work/n02/n02/<username>/<antsfolder>
```

###### Copy some existing UM ancils

This is how to create the ancillary data, using the ESA CCI land use data, for your nested domain (using suite `u-<id>`).

1. Run suite to create new ancillaries only:
  
  In `rg01_rs01_ancil_mode` set `MAKE_ANCILS_ONLY` to <u>True</u>
  
2. Copy the `qrparm.mask_igbp` and `grid.nl` file:
  
  `cp /work/n02/n02/<username>/cylc-run/u-<id>/share/data/ancils/Regn1/resn_1/qrparm.mask_igbp .`
  
###### Patch the UM Ancil Tools

Some changes have been made to these tools for this workflow. You can apply these changes using the included patch files.
```bash
patch -u -b bin/ancil_lct_preproc_cci.py -i patch.ancil_lct_preproc_cci.txt
```


## 2. ants.ocean.slurm

ESACCI does not differentiate between ocean and water (i.e. lakes and rivers). Therefore we add a new 'ocean' category to the data. This runs the python script **ESA_WB_regrid.py**. The script also corrects the antds 3d/2d error.

## 3. ants.ncap2.slurm

ncap2 is used to change the values in the CCI file as ants requires int8 (-127 to 127) and the ants containter looks hard coded so we cannot edit anything in this, hence the needed to modify the input file. Note the next step ants.preproc-serial.archer2.slurm only changes the metadata, hence the need for this.

## 4. ants.preproc-serial.archer2.slurm

This is the ants preprocessing stage. We have made edits to **ancil_lct_preproc_cci.py** in order to correct the metadata (shown below, and applied by the patch file in the Setup process). This overwrites what is called from import ants in the container.

```
def set_flag_metadata2(cube):

    flag_values = [0,10,11,12,20,30,40,50,60,61,62,70,71,72,80,81,82,90,100,110,120,121,122,101,102,103,105,105,106,107,108,109,111,112,113,114,115,116,117,118,119,]
    flag_meanings = ("no_data","cropland_rainfed","herbaceous_cover","tree_or_shrub_cover","cropland_irrigated","mosaic_cropland","mosaic_natural_vegetation","tree_broadleaved_evergreen_closed_to_open","tree_broadleaved_deciduous_closed_to_open","tree_broadleaved_deciduous_closed","tree_broadleaved_deciduous_open","tree_needleleaved_evergreen_closed_to_open","tree_needleleaved_evergreen_closed","tree_needleleaved_evergreen_open","tree_needleleaved_deciduous_closed_to_open","tree_needleleaved_deciduous_closed","tree_needleleaved_deciduous_open","tree_mixed","mosaic_tree_and_shrub","mosaic_herbaceous","shrubland","shrubland_evergreen","shrubland_dedicious","grassland","lichens_and_mosses","sparse_vegetation","sparse_tree","sparse_shrub","sparse_herbaceous","tree_cover_flooded_fresh_or_brakish_water","tree_cover_flooded_saline_water","shrub_or_herbaceous_cover_flooded","urban","bare_areas","consolidated_bare_areas","unconsolidated_bare_areas","water_bodies","sea_ocean_water","snow_and_ice","resolved_lake""ocean",)

    cover_mapping.set_flag_arrays(cube, flag_values, flag_meanings)

lct_preproc_cci.set_flag_metadata = set_flag_metadata2
```

You will also need to comment # out any lakes in your domain. In our case this was lakes nicaragua and titcaca (included in the patch file). Not sure what the ants code is doing but it creates a strange block with incorrect values around these lakes in the output.

## 5. ants.ncap2.ants_out.slurm

Similar to step3 as the ants preprocessing creates new categories and they use negative values so simply changing these to positive values.

## 6. ants.lct-serial.archer2.slurm

Transforms CCI land use values to the values used in the UM. Note edits need to made to **cci2jules.json** to match the above CCI value and metadata changes. This is adding no_data and ocean classes. The data is then put onto the grid taken from qrparm.mask_igbp.

## 7. ants.postC4-serial.archer2.slurm

CCI data does contain C4 grass, therefore the category in the UM is currently empty. You can ownload the `c4_percent_1d.asc` datafile from [ISLSCP II C4 Vegetation Percentage](https://daac.ornl.gov/ISLSCP_II/guides/c4_percent_1deg.html) (this will require you to create an EarthData login account), and copy across to ARCHER2 or `cp resources/c4_percent_1d.nc .` as the asc file has no lat/lon info.

However, this file is at ~1 degree resolution and when modelling at higher resolutions this will produce a blocky effect.

Instead use the grassmapr R package to create higher resolution data. https://rdrr.io/github/rebeccalpowell/grassmapr/man/grassmapr.html or https://github.com/rebeccalpowell/grassmapr. This package is created by the Powell et al. (2012) [Vegetation and soil carbon‐13 isoscapes for South America: integrating remote sensing and ecosystem isotope measurements - Powell - 2012 - Ecosphere - Wiley Online Library](https://esajournals.onlinelibrary.wiley.com/doi/pdf/10.1890/ES12-00162.1)

Run `python c4pc.py` (n.b. on archer2 using python version cray-python/3.8.5.0) then ants.postC4-serial.archer2.slurm

## 8. ants.regrid.slurm

Step 6 makes a slight mess of the lat/lon so need to regrid back to what it was originally (can quickly view the lat/lon using xconv).

## 9. ants.2anc.slurm

Put the files in the ancillary file format.

## 10. surface_type_merging_with_masks_v3.ipynb

IGBP data will have some cells that are not present in CCI and vice versa. We are using the igbp mask as otherwise every ancil would need chaning to a new mask. Without this step the model will fail stating nans ingested. Currently using Jasmin to run this part as python cf library wouldn't install on archer2. Copy qrparm.veg.frac_igbp and the newly created qrparm.veg.frac.cci to Jasmin. Open and run each cell in notebook.

## 11. Copy to UM

Copy cci_with_igbp_fill_surface_fractions2.nc back to archer2. Use xancil to convert to ancillary format (Atmosphere Ancillary Files > Vegetation Fractions). N.b. use field_1391. Note under configuration change UM version number as 4.5 that is set as default will cause an error.

## Misc

Check  vegetation fractions add up to 1 by summing over a dimension (n.b. dim0 could also be pseudo or coordinate):

```bash
ncwa -a dim0 -y sum in.nc out.nc
```


