projection29901m="+proj=tmerc +lat_0=53.5 +lon_0=-8 +k=1 +x_0=200000 +y_0=250000 +ellps=airy +towgs84=482.5,-130.6,564.6,-1.042,-0.214,-0.631,8.15 +units=m +no_defs "
mapnikconfig="/etc/mapnik-osm-carto-data/osm_OSI.xml"

# These coordinates can clip out areas we are not interested in
extentWKT29901m="POLYGON ((0 0, 700000 0, 700000 1300000, 0 1300000, 0 0))"
basedir=OSI
threads=3
mincoordx=0
mincoordy=0
maxcoordx=400000
maxcoordy=500000

# Something which looks like a map of Ireland
./GenerateTiles.py --threads ${threads} --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx ${maxcoordx} --coordsincrementy ${maxcoordy} "${projection29901m}" ${mapnikconfig} "${extentWKT29901m}" 1000

# Something which looks like OS250K tiles
./GenerateTiles.py --threads ${threads} --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 100000 --coordsincrementy 100000 "${projection29901m}" ${mapnikconfig} "${extentWKT29901m}" 250

# Something which looks like OS50K tiles
#./GenerateTiles.py --threads ${threads} --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection29901m}" ${mapnikconfig} "${extentWKT29901m}" 50

# Something which looks like OS10K tiles
#./GenerateTiles.py --threads ${threads} --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 5000 --coordsincrementy 5000 "${projection29901m}" ${mapnikconfig} "${extentWKT29901m}" 10

