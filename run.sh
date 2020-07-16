#!/bin/bash

cd /lod-cloud-draw
git pull
#python3 scripts/get-data.py
bash generate-clouds.sh
# Inspect cloud
#eog clouds/lod-cloud-sm.jpg
# Number of links
LINKS=`grep "<line" clouds/lod-cloud.svg | wc -l`
# Number of datasets
DATASETS=`grep "<circle" clouds/lod-cloud.svg | wc -l`
echo "$LINKS links between $DATASETS datasets"

cd /lod-cloud-site
DATE=`date +%Y-%m-%d`
git pull
mkdir src/main/webapp/versions/$DATE
cp /lod-cloud-draw/clouds/* src/main/webapp/versions/$DATE
cp /lod-cloud-draw/lod-data.json src/main/webapp/
rm src/main/webapp/versions/latest
ln -s $DATE src/main/webapp/versions/latest
cp /lod-cloud-draw/lod-data.json src/main/webapp/versions/latest/
# Update counts, link totals and history
#vi src/main/webapp/index.html
sed "s/==LINKS==/$LINKS/" src/main/webapp/index-template | sed "s/==DATASETS==/$DATASETS/" | sed "/TABLE/a <tr typeof=\"dctype:Image\" about=\"#cloud\" property=\"dc:title\" content=\"LOD cloud diagram\"> <th property=\"dc:modified\" datatype=\"xsd:date\" content=\"$DATE\">$DATE</th><td></td><td></td><td></td><td><a href=\"versions/$DATE/lod-cloud.png\">png</a></td><td></td><td><a href=\"versions/$DATE/lod-cloud.svg\">svg</a></td><td><a href=\"versions/$DATE/lod-data.json\">json</a></td><td></td><td class=\"dataset-count\">$DATASETS</td></tr>" > src/main/webapp/index.html
sed -i "/TABLE/a <tr typeof=\"dctype:Image\" about=\"#cloud\" property=\"dc:title\" content=\"LOD cloud diagram\"> <th property=\"dc:modified\" datatype=\"xsd:date\" content=\"$DATE\">$DATE</th><td></td><td></td><td></td><td><a href=\"versions/$DATE/lod-cloud.png\">png</a></td><td></td><td><a href=\"versions/$DATE/lod-cloud.svg\">svg</a></td><td><a href=\"versions/$DATE/lod-data.json\">json</a></td><td></td><td class=\"dataset-count\">$DATASETS</td></tr>" src/main/webapp/index-template 
mvn install
python3 for-mongo.py src/main/webapp/lod-data.json > lod-data-mongo.json
cd src/main/webapp/versions
zip -r versions.zip *
zip versions.zip ../index-template
