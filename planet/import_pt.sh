wget http://download.geofabrik.de/europe/portugal-latest.osm.pbf
osm2pgsql --slim -C 2000 -E EPSG:4326 portugal-latest.osm.pbf
