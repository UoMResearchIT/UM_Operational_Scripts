
BASE_PATH='/work/n02/n02/lowe/'


PATH_ARGS="--sourcedir ${BASE_PATH}CIDAR_Data/ERA5_Gribfiles/ --destdir ${BASE_PATH}CIDAR_Data/Example_Links/"

DATE_ARGS="--startdate 20100601 --enddate 20100610 --increment 6"

python link.py ${PATH_ARGS} ${DATE_ARGS}
