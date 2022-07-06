#!/usr/bin/env python

# nb need to install rioxarray to load the tif file
import xarray as xr
import dask
import numpy as np

landuse = xr.open_dataset('ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7cds.nc')
landuse = landuse.lccs_class
landuse = landuse.sel(time='2010-01-01') # change if different year used
#landuse = landuse[32500:35000,77500:80000] # for testing

ocean = xr.open_dataset("ESACCI-LC-L4-WB-Ocean-Map-150m-P13Y-2000-v4.0.tif",chunks={"x": 16200,"y": 16200})
ocean = ocean.rename({'x':'lon'})
ocean = ocean.rename({'y':'lat'})
#ocean = ocean.isel(lon=slice(155000,160000), lat=slice(65000,70000)) # for testing

# 150m to 300m
ocean_out = ocean.coarsen(lon=2).max().coarsen(lat=2).max()

#if mask = 0 use new ocean value else use CCI value
ocean_out = ocean_out.where(ocean_out>0, 119) # set ocean as new category 119
ocean_out = xr.where(ocean_out != 119, landuse.data, ocean_out.band_data)

# make attributes match the land use input
ocean_out = ocean_out.to_array(dim="lccs_class")
ocean_out = ocean_out.drop_vars({'band', 'spatial_ref','lccs_class'})
ocean_out = ocean_out[0,0,:,:]
ocean_out = ocean_out.astype('uint8')
ocean_out.attrs['standard_name'] = landuse.standard_name
ocean_out.attrs['flag_colors'] = landuse.flag_colors
ocean_out.attrs['long_name'] = landuse.long_name
ocean_out.attrs['valid_min'] = landuse.valid_min
ocean_out.attrs['valid_max'] = landuse.valid_max
ocean_out.attrs['ancillary_variables'] = landuse.ancillary_variables
ocean_out.attrs['flag_meanings'] = landuse.flag_meanings + ' ocean'
ocean_out.attrs['flag_values'] = np.append(landuse.flag_values, 119)
ocean_out = ocean_out.rename("lccs_class")
ocean_out.coords['time'] = landuse.coords['time']
ocean_out['lon'] = landuse['lon']
ocean_out['lat'] = landuse['lat']

ocean_out.to_netcdf('ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7cds_oceanmask.nc', mode='w', format="NETCDF4", engine="netcdf4", encoding={"lccs_class":{"zlib": True, "complevel": 5}})
print("Finished")
