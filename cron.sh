#!/bin/bash

# These two commands must be run once
# docker build -t nuig_uld/lod-docker-update
# docker create --name lod-cloud-updater nuig_uld/lod-docker-update
docker start -a lod-cloud-updater
cd servlet
bash make-servlet.sh
cd -
docker cp lod-cloud-updater:/lod-cloud-site/lod-data-mongo.json .
docker cp lod-cloud-updater:/lod-cloud-site/src/main/webapp/versions/versions.zip servlet/
mongoimport --collection datasets --db mern-dataset-app --drop lod-data-mongo.json
rm lod-data-mongo.json
docker stop lod-cloud
docker rm lod-cloud
docker run -d -p 9001:8080 --name lod-cloud --restart always nuig_uld/lod-cloud-servlet
