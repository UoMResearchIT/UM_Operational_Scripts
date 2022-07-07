#!/usr/bin/env python

# nb need to install rioxarray to load the tif file
import xarray as xr
#import cf_xarray as cfxr

c3 = xr.open_dataset("c3_crop_cov_2000_10min_adj.tif")
c4 = xr.open_dataset("c4_crop_cov_2000_10min_adj.tif")

c4pc = c4 / (c3 + c4) * 100
c4pc = c4pc.rename({'x':'longitude'})
c4pc = c4pc.rename({'y':'latitude'})
c4pc = c4pc.fillna(0)

c4pc.rio.write_grid_mapping(inplace=True)
c4pc.rio.write_crs("epsg:4326", inplace=True)
c4pc.rio.write_coordinate_system(inplace=True)

#c4pc.to_netcdf('c4pc.nc', mode='w', format="NETCDF4", engine="netcdf4", encoding={"c4pc":{"zlib": True, "complevel": 5}})
c4pc.to_netcdf('c4pc.nc',mode='w')
