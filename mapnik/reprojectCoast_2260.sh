#!/bin/bash

# Reproject the various shapefiles into a target srs

# location of shape files
source=/etc/mapnik-osm-carto-data/data/

# THESE COORDINATES NEED TO BE IN GLOBAL MERCATOR
extent="-8444696.57158 4994657.77135 -8154152.70061 5626245.6093"
srs=2260ft
proj4="+proj=tmerc +lat_0=38.83333333333334 +lon_0=-74.5 +k=0.9999 +x_0=150000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs "

echo "Extract for ${srs}"

find ${source} -name '*.shp' | while read fullPath
do
  echo Converting: $fullPath
  file=$(basename $fullPath)
  dir=$(dirname $fullPath)

  destinationFullPath=$dir/${file/.shp/_$srs.shp}

  ogr2ogr -f "ESRI Shapefile" -s_srs EPSG:2260 -t_srs "${proj4}" \
     -spat ${extent} ${destinationFullPath} ${fullPath}
  
done


