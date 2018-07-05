projection26910m="+proj=utm +zone=10 +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
mapnikconfig="/etc/mapnik-osm-carto-data/osm_26910.xml"

# These coordinates can clip out areas we are not interested in
extentWKT26910m="POLYGON ((494000 5994000, 538000 5994000, 538000 5954000, 494000 5954000, 494000 5994000))"
basedir=CA26910

./GenerateTiles.py --flatdirectorystructure --basedir ${basedir} --imgsize 4000 --scale 4 "${projection26910m}" ${mapnikconfig} "${extentWKT26910m}" 0 1 2 3 4 5 6

