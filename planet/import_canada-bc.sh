rm british-columbia-latest.osm.pbf
wget http://download.geofabrik.de/north-america/canada/british-columbia-latest.osm.pbf
#osm2pgsql --slim -C 3000 -E EPSG:4326 british-columbia-latest.osm.pbf
osm2pgsql --slim -C 2000 -E EPSG:4326 british-columbia-latest.osm.pbf
