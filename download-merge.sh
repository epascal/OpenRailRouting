wget https://download.geofabrik.de/europe/france-latest.osm.pbf
wget https://download.geofabrik.de/europe/switzerland-latest.osm.pbf
osmium merge france-latest.osm.pbf switzerland-latest.osm.pbf -o france-switzerland.osm.pbf

