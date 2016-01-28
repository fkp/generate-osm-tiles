# generate-osm-tiles
This is a python script which will allow you to generate raster tiles from a PostGIS database of OpenStreetMap data. The script is multi-threaded and supports using any projection system a required. You can also define a geographical extent to clip the area you are interested in, avoiding generating irrelevant tiles.

There are some shell scripts which show you how to load the OpenStreetMap data which will run on a Linux server which has been setup with the standard map tile server pre-built packages.
