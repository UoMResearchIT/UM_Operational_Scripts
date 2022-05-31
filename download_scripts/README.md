# Meteorological Download Scripts

These scripts use ERA5 meteorological inputs, downloaded via the CDS API.

## Setup

Instructions for setting up are given at [How to use the CDS API](https://cds.climate.copernicus.eu/api-how-to), and summarised below.

### Software

A python based API client is available, installable via either `pip` or `conda`. To install via `pip` follow the instructions on the website above. To install via `conda` use the install script in setup -- this will create a conda environment containing the client library.

### Licensing

To get access to the ERA5 data you should create a user account, and accept the licence agreement at the [Copernicus Climate Data Store](https://cds.climate.copernicus.eu/cdsapp/#!/terms/licence-to-use-copernicus-products). Once you have accepted the license, then you will need to save the url and key within your home directory in the file: `.cdsapirc`

## Downloading Data

Included here is the download script, `download.py`, and an example job submission script, `era5_download.slurm`, which is configured for ARCHER2. The download script will return volumetric and surface data in a single date file, following the naming convention `ec_grib_YYYYMMDDHH00.t+000`. This is designed to be directly compatible with the UM input data naming convention.

### Configuration Options

1) Start and end dates are set in the `idate` and `edate` variables defined on lines 15 and 16. 

2) The hours of the day to extract data for are set in the `hours` array defined on line 19. ERA5 data is available on a 1 hour interval - this script extracts data every 3 hours, modify as you need.

3) The region limits are defined in the `area_limits` array on line 20. The example region is set for a domain over South America, modify this as you need. 
   
   1) The array is organised as: `['North Lat', 'West Long', 'South Lat', 'East Long']`
   
   2) Make sure to allow enough space around your domain to fit the boundary ancillary data. As a rule of thumb, add an extra 5 degrees to your domain to account for these.
