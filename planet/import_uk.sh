rm british-isles-latest.osm.pbf
wget http://download.geofabrik.de/europe/british-isles-latest.osm.pbf
osm2pgsql --slim -C 1000 -E EPSG:4326 british-isles-latest.osm.pbf
#osm2pgsql --slim -C 1500 --number-processes 4 -E EPSG:4326 british0isles-latest.osm.pbf
