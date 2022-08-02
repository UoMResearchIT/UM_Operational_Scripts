#!/usr/bin/env python

# nb need to install rioxarray to load the tif file
import xarray as xr

c4 = xr.open_dataset("C4_ratio_ndvi.tif")

c4 = c4 * 100
c4 = c4.rename({'x':'longitude'})
c4 = c4.rename({'y':'latitude'})
c4 = c4.fillna(0)

c4.rio.write_grid_mapping(inplace=True)
c4.rio.write_crs("epsg:4326", inplace=True)
c4.rio.write_coordinate_system(inplace=True)

c4.to_netcdf('c4.nc',mode='w')
