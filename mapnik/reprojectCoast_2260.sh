#!/bin/bash

# Reproject the various shapefiles into a target srs

# location of shape files
source=/etc/mapnik-osm-carto-data/data/

# THESE COORDINATES NEED TO BE IN GLOBAL MERCATOR
extent="-8844696.57158 4594657.77135 -8154152.70061 6026245.6093"
srs=2260ft
proj4="+proj=tmerc +lat_0=38.83333333333334 +lon_0=-74.5 +k=0.9999 +x_0=150000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs "

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

  ogr2ogr -f "ESRI Shapefile" -s_srs EPSG:2260 -t_srs "${proj4}" \
     -spat ${extent} ${destinationFullPath} ${fullPath}
  
done

