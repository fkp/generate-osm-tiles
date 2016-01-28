#rm north-america-latest.osm.pbf
#wget http://download.geofabrik.de/north-america-latest.osm.pbf
#rm us-northeast-latest-osm.pbf
#wget http://download.geofabrik.de/north-america/us-northeast-latest.osm.pbf
#osm2pgsql --slim -C 3000 -E EPSG:4326 north-america-latest.osm.pbf
osm2pgsql --slim -C 2000 -E EPSG:4326 us-northeast-latest.osm.pbf
