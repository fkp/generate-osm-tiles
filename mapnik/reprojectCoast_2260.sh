#!/bin/bash

# Reproject the various shapefiles into a target srs
./reprojectCoast.sh "-9544696.57158 4094657.77135 -7054152.70061 6526245.6093" 2260ft "+proj=tmerc +lat_0=38.83333333333334 +lon_0=-74.5 +k=0.9999 +x_0=150000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs "


