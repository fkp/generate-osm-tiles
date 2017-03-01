wget http://download.geofabrik.de/north-america/canada-latest.osm.pbf
osm2pgsql --slim -C 2000 -E EPSG:4326 canada-latest.osm.pbf
