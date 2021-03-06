# Ancillary Data Tools

These are scripts for running the ANTS preprocessors for the Unified Model. Documentation for these preprocessors can be found in the [Met Office ANTS pages](https://code.metoffice.gov.uk/doc/ancil/ants/latest/introduction.html), and an introduction to the ANTS singularity container is available on the [NCAS ANTS pages](https://cms.ncas.ac.uk/miscellaneous/ants-container/).

These scripts are written for the ANTS v0.18 singularity container. The most recent release of the toolset container at the time of writing (May 2022). However, where necessary, v0.19 scripts have been used, and links to download these are provided below. These scripts are designed for use on the ARCHER2 HPC facility.

The scripts in this repository are intended for creating ancillary data for a limited area model domain over South America. Some of the configuration and input files included here may be domain specific - replace these with files for your domain if using these scripts for other studies.

## Set up

###### Download v0.19 Ancil Tools

These should be taken directly from the Met Office code repository:

```bash
svn checkout --username <username> https://code.metoffice.gov.uk/svn/ancil/ants/tags/0.19.0/bin/
```

Replace `<username>` with your Met Office user account name, and enter your password when it is requested.

###### Download Transform Tables

These should also be taken directly from the Met Office code repository:

```bash
svn checkout --username <username> https://code.metoffice.gov.uk/svn/ancil/data/trunk/transforms/
```

Replace `<username>` with your Met Office user account name, and enter your password when it is requested.

###### Download Land Use Data

ESA CCI data should be downloaded from CEDA:

```bash
wget https://dap.ceda.ac.uk/neodc/esacci/land_cover/data/land_cover_maps/v1.6.1/ESACCI-LC-L4-LCCS-Map-300m-P5Y-2010-v1.6.1.nc .
```

SLSCP II MODIS  (Collection 4) IGBP Land Cover, 2000-2001 should be downloaded from [https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=968](https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=968) to your own computer. Select the `modis_landcover_qdeg` (quarter degree) dataset.

Then transfer to ARCHER2:

```bash
scp modis_landcover_class_qd.asc <username>@login.archer2.ac.uk:/work/n02/n02/<username>/ants3
```

## Running the Software

This is how to create the ancillary data, using the ESA CCI land use data, for your nested domain (using suite `u-cn801`).

1. Run suite to create new ancillaries only:
   
   1. In `rg01_rs01_ancil_mode` set `MAKE_ANCILS_ONLY` to <u>True</u>

2. Copy the `grid.nl` and `qrparm.mask` files:
   
   1. ```bash
      cp /work/n02/n02/<username>/cylc-run/u-cn801/share/data/ancils/Regn1/resn_1/grid.nl .
      ```
   
   2. ```bash
      cp /work/n02/n02/<username>/cylc-run/u-cn801/share/data/ancils/Regn1/resn_1/qrparm.mask .
      ```

3. **Run the Preprocessing Steps (1 to 5) listed below.**

4. Replace `qrparm.veg.frac` in the run ancil directory:
   
   1. ```bash
      cp /work/n02/n02/<username>/ants3/qrparm.veg.frac work/n02/n02/<username>/cylc-run/u-cn801/share/data/ancils/Regn1/resn_1/
      ```

5. Run the suite without creating the ancillaries again:
   
   1. In `rg01_rs01_ancil_mode` set `MAKE_ANCILS_ONLY` to <u>False</u>
   
   2. In `rg01_rs01_ancil_mode` set `Create New Ancillaries` to <u>False</u>

###### STEP 1:`ancil_lct_preproc_cci.py`

Edit the `ants.preproc-serial.archer2.slurm` file to change the user account, and submit using:

```bash
sbatch ants.preproc-serial.archer2.slurm
```

This is run as a serial job, so that geographic data can be downloaded as needed. It will create the `ants_out.nc` file.

###### STEP 2: `ancil_lct.py`

The crosswalk table will need editing to add the resolved lake data (created in the previous step). First copy the table:

```bash
cp transforms/cci2jules_ra1.json bin/cci2jules_ra1_reslakes.json
```

Then edit the `cci2jules_ra1_reslakes.json` file to add the following lines to these two lists (as the final item in each):

1. the `cover_map`:

```json
           [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0],
```

2. the `source`:

```json
           "resolved_lake",
```

**Or** copy this file:

```html
https://code.metoffice.gov.uk/trac/ancil/browser/ants/trunk/rose-test/resources/transforms/cci2jules.json
```

Edit the `ants.lct-serial.archer2.slurm` file to change the user account, and submit using:

```bash
sbatch ants.lct-serial.archer2.slurm
```

This will create the `lct_out.nc` file.

###### STEP 3: `ancil_lct_postproc_c4.py`

Download the `c4_percent_1d.asc` datafile from [https://daac.ornl.gov/ISLSCP_II/guides/c4_percent_1deg.html](https://daac.ornl.gov/ISLSCP_II/guides/c4_percent_1deg.html) (this will require you to create an EarthData login account), and copy across to ARCHER2:

```bash
scp c4_percent_1d.asc <username>@login.archer2.ac.uk:/work/n02/n02/<username>/ants3
```

This file does not contain latitude or longitude data, so these must be loaded from the ants resources:

```bash
svn checkout https://code.metoffice.gov.uk/svn/ancil/ants/trunk/rose-test/resources/
cp resources/c4_percent_1d.nc .
```

**NOTE**: Although we have downloaded high resolution C4 data, the C3:C4 ratios are still at a low resolution, and so the coverage of C3 and C4 are very blocky. It would be better to either parameterise this ratio, or update to higher resolution data when it comes available.

Edit the `ants.postC4-serial.archer2.slurm` file to change the user account, and submit using:

```bash
sbatch ants.postC4-serial.archer2.slurm
```

###### STEP 4: `ancil_general_regrid.py`

Edit the `ants.regrid-serial.archer2.slurm` file to change the user account, and submit using:

```bash
sbatch ants.regrid-serial.archer2.slurm
```

###### STEP 5: `ancil_2anc.py` / `ancil_ancil.py`

Edit the `ants.ancil-serial.slurm` file to change the user account, and submit using:

```bash
sbatch ants.ancil-serial.slurm
```

This creates the `qrparm.veg.frac` file (as well as a netcdf file, which is not needed).

###### 


