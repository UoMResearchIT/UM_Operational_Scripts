#!/usr/bin/env python

import time
from datetime import date
from datetime import timedelta

import cdsapi

c = cdsapi.Client()
 

# Set dates for data extraction
idate = date(2018,8,1)
edate = date(2018,8,31)

# Set hours for each date to extract


while (idate <= edate):

    iyear = idate.year
    imonth = idate.month
    iday = idate.day

    stryear  = "%04d" % (iyear)
    strmonth = "%02d" % (imonth)
    strday   = "%02d" % (iday)
    strdate = "%d%02d%02d" % (iyear, imonth, iday)
    print(strdate)   

    # extract 3D data
    c.retrieve(
        "reanalysis-era5-pressure-levels",
        {
            'product_type': 'reanalysis',
            'format': 'grib',
            'year': stryear,
            'month': strmonth,
            'day': strday,
            'variable': [
                'specific_humidity', 'temperature', 'u_component_of_wind',
                'v_component_of_wind'
            ],
            'pressure_level': [
                '1', '2', '3',
                '5', '7', '10',
                '20', '30', '50',
                '70', '100', '125',
                '150', '175', '200',
                '225', '250', '300',
                '350', '400', '450',
                '500', '550', '600',
                '650', '700', '750',
                '775', '800', '825',
                '850', '875', '900',
                '925', '950', '975',
                '1000',
            ],
            'time': [
                '00:00', '06:00', '12:00',
                '18:00',
            ],
            'area': [25, -95, -50, -20],
        },
        "preslev_"+strdate+".grib")
    
    # extract surface data
    c.retrieve(
        'reanalysis-era5-single-levels',
        {
            'product_type': 'reanalysis',
            'format': 'grib',
            'year': stryear,
            'month': strmonth,
            'day': strday,
            'variable': [
                'geopotential', 'land_sea_mask', 'skin_temperature',
                'surface_pressure', 'soil_temperature_level_1', 'soil_temperature_level_2', 'soil_temperature_level_3',
                'soil_temperature_level_4', 'soil_type', 'volumetric_soil_water_layer_1',
                'volumetric_soil_water_layer_2', 'volumetric_soil_water_layer_3', 'volumetric_soil_water_layer_4',
                'snow_density', 'snow_depth'
            ],
            'time': [
                '00:00', '06:00', '12:00',
                '18:00',
            ],
            'area': [25, -95, -50, -20],
        },
        "surface_"+strdate+".grib")
    
        
    # move to next day
    
    idate = idate + timedelta(days=1) 

print("End.")

