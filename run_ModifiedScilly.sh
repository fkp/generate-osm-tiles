projection27700m="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
mapnikconfig="/etc/mapnik-osm-carto-data/osm_OSGB.xml"

# These coordinates can clip out areas we are not interested in
extentWKT27700m="POLYGON ((141000 981000, 159000 981000, 159000 999000, 141000 999000, 141000 981000))"
basedir=OSScilly

mincoordx=0
mincoordy=0
maxcoordx=700000
maxcoordy=1300000

# Something which looks like mini scale
#./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 700000 --coordsincrementy 1300000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 1000

# Something which looks like OS250K tiles
#./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 100000 --coordsincrementy 100000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 250

# Something which looks like OS50K tiles
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 50

# Something which looks like OS10K tiles
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 5000 --coordsincrementy 5000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 10
