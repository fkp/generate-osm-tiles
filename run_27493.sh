projection27493m="+proj=tmerc +lat_0=39.66666666666666 +lon_0=-8.131906111111112 +k=1 +x_0=180.598 +y_0=-86.99 +ellps=intl +towgs84=-223.237,110.193,36.649,0,0,0,0 +units=m +no_defs"
mapnikconfig="/etc/mapnik-osm-carto-data/osm_27493.xml"

# These coordinates can clip out areas we are not interested in
extentWKT27493m="POLYGON((205000 212117, 87745 -373897, -12539 -381000, -129117 -322094, -188000 -24231, -112989 263920, 48893 329000, 205000 212117))"
basedir=Port

./GenerateTiles.py --flatdirectorystructure --basedir ${basedir} --imgsize 4000 --scale 4 "${projection27493m}" ${mapnikconfig} "${extentWKT27493m}" 0 1 2 3 4 5 6 7 8 9

