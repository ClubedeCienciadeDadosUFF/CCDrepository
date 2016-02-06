from sys import argv
import json
import re
from pprint import pprint

fileNames = argv[1:]

print(fileNames)

finalGeoJSON = {'type': 'FeatureCollection'}
finalGeoJSON['features'] = []


def getGeoJSON(data, fileName):
    matchObj = re.search(r'.*/(.*)', fileName)
    name = matchObj.group(1)
    geojson = {}
    geojson['type'] = "Feature"
    geojson['properties'] = {"name": name}
    geojson['geometry'] = {"type": "Polygon"}
    geojson['geometry']['coordinates'] = []

    firstGeographicPoint = data['points'][0]

    geoPoints = []

    for point in data['points']:
        geographicPoint = [point['lng'], point['lat']]
        geoPoints.append(geographicPoint)

   
    geoPoints.append([firstGeographicPoint['lng'], firstGeographicPoint['lat']])

    geojson['geometry']['coordinates'].append(geoPoints)
    # pprint(geojson)

    return geojson


for fileName in fileNames:
    with open(fileName) as data_file:
        finalGeoJSON['features'].append(
            getGeoJSON(json.load(data_file), fileName))
        data_file.close()

with open('niteroi-neighbourhoods.geojson', 'w') as outfile:
    json.dump(finalGeoJSON, outfile)
