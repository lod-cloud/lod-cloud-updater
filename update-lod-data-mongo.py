import json
from urllib.request import urlopen
import codecs

lod_data_mongo = {}
for line in open("lod-data-mongo.json").readlines():
    d = json.loads(line)
    lod_data_mongo[d["_id"]] = d
    
reader = codecs.getreader("utf-8")
new_data = json.load(reader(urlopen("https://lod-cloud.net/extract/datasets")))

for k,v in new_data.items():
    if k not in lod_data_mongo:
        v["_id"] = v["identifier"]
        lod_data_mongo[k] = v

with open("lod-data-mongo.json", "w") as output:
    for _, v in lod_data_mongo.items():
        output.write(json.dumps(v))
        output.write("\n")
