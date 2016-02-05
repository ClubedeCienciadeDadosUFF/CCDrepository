from sys import argv
import json
from pprint import pprint

filename = argv[1]

print(filename)

with open(filename) as data_file:
    data = json.load(data_file)

geojson = {}

geojson['type'] = "Feature"
geojson['properties'] = {"name": filename}
geojson['geometry'] = {"type": "Polygon"}
geojson['geometry']['coordinates'] = []

firstGeographicPoint = data['points'][0]

for point in data['points']:
    geographicPoint = [point['lat'], point['lng']]
    geojson['geometry']['coordinates'].append(geographicPoint)

pprint(geojson)
