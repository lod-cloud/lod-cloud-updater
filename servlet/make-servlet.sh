#!/bin/bash

if [[ ! -f "oauth2" ]]
then
    echo "oauth2 secret is missing!"
    exit -1
fi
docker cp lod-cloud-updater:/lod-cloud-site/target/lod-cloud-crud-java-0.1-SNAPSHOT.war .
docker build -t nuig_uld/lod-cloud-servlet .
rm lod-cloud-crud-java-0.1-SNAPSHOT.war 
