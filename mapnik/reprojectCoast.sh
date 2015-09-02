#!/bin/bash

# Reproject the various shapefiles into a target srs

# location of shape files
source=/etc/mapnik-osm-carto-data/data/

# THESE COORDINATES NEED TO BE IN GLOBAL MERCATOR
if [ "$#" -ne 3 ]
then
  echo "Expected: <extent> <srs> <proj4>"
  exit 1
fi

extent=$1
srs=$2
proj4=$3

echo "Using:"
echo " extent: " $1
echo " srs: " $2
echo " proj4: " $3

function DeleteShapefile
{
  for extension in .sbf .prj .shp .shx
  do
    fileToDelete=${1/.shp/$extension}
    if [ -f $fileToDelete ]
    then
      rm $fileToDelete
    fi
  done
}

echo "Extract for ${srs}"

for fullPath in \
  "${source}ne_10m_populated_places/ne_10m_populated_places.shp" \
  "${source}ne_10m_populated_places/ne_10m_populated_places_fixed.shp" \
  "${source}land-polygons-split-3857/land_polygons.shp" \
  "${source}simplified-land-polygons-complete-3857/simplified_land_polygons.shp" \
  "${source}ne_110m_admin_0_boundary_lines_land/ne_110m_admin_0_boundary_lines_land.shp" \
  "${source}world_boundaries/builtup_area.shp" \
  "${source}world_boundaries/world_boundaries_m.shp" \
  "${source}world_boundaries/places.shp"
do
  file=$(basename $fullPath)
  dir=$(dirname $fullPath)

  destinationFullPath=$dir/${file/.shp/_$srs.shp}
  
  DeleteShapefile ${destinationFullPath}

  echo Converting: $file

  ogr2ogr -f "ESRI Shapefile" -s_srs EPSG:3857 -t_srs "${proj4}" \
     -clipsrc ${extent} ${destinationFullPath} ${fullPath}
  
done

