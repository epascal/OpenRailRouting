wget https://download.geofabrik.de/europe/france-latest.osm.pbf
wget https://download.geofabrik.de/europe/switzerland-latest.osm.pbf
osmium merge --overwrite france-latest.osm.pbf switzerland-latest.osm.pbf -o ../osm/france-switzerland.osm.pbf

