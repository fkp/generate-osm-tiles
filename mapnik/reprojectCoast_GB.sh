#!/bin/bash

# Reproject the various shapefiles into a target srs
./reprojectCoast.sh "-1037459 6280130 392508 8644951" 27700m "+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"

