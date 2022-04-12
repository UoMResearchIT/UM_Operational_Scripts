
from datetime import datetime, timedelta
import os


def readdate(datestring):
    return(datetime(int(datestring[0:4]),int(datestring[4:6]), int(datestring[-2::])))

def createdatestring(dateobject):
    return("%d%02d%02d" % (dateobject.year, dateobject.month, dateobject.day))

def createincstring(increment):
    return("%03d" % increment)

def createhourstring(increment):
    return("%02d" % (increment % 24))



if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser()
    hstring = "Start date string, format YYYYMMDD"
    istring = "Increment (in hours)"
    estring = "End date string, format YYYYMMDD"
    parser.add_argument("--startdate", help=hstring, type=str)
    parser.add_argument("--increment", help=istring, type=str)
    parser.add_argument("--enddate", help=estring, type=str)
    parser.add_argument("--sourcedir", help="path to source directory", type=str)
    parser.add_argument("--destdir", help="path to destination directory", type=str)
    
    
    # initial settings
    
    args = parser.parse_args()
    
    startdate = readdate(args.startdate)
    enddate   = readdate(args.enddate)
    idate     = readdate(args.startdate)

    hour_inc = int(args.increment)

    source_dir = args.sourcedir
    dest_dir = args.destdir

    # ops code
    
    startdatestring = createdatestring(startdate)

    increment_sum = 0

    while (idate<=enddate):
    
        datestring = createdatestring(idate)
        print(datestring)
        inc_string = createincstring(increment_sum)
        hourstring = createhourstring(increment_sum)


        # link data
        os.system(f'ln -s {source_dir}/era5_data_{datestring}_{hourstring} {dest_dir}/era5_data_{startdatestring}.t{inc_string}')
        
        # increment the system
        increment_sum += hour_inc
        
        idate = startdate + timedelta(days=int(increment_sum/24)) 


















        