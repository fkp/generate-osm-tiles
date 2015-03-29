#!/bin/bash

# Reproject the various shapefiles into a target srs

# location of shape files
source=/etc/mapnik-osm-carto-data/data/

# THESE COORDINATES NEED TO BE IN GLOBAL MERCATOR
extent="-1037459 6280130 392508 8644951"
srs=27700m
proj4="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"

echo "Extract for ${srs}"

find ${source} -name '*.shp' | while read fullPath
do
  echo Converting: $fullPath
  file=$(basename $fullPath)
  dir=$(dirname $fullPath)

  destinationFullPath=$dir/${file/.shp/_$srs.shp}

  ogr2ogr -f "ESRI Shapefile" -s_srs EPSG:3857 -t_srs "${proj4}" \
     -spat ${extent} ${destinationFullPath} ${fullPath}
  
done


