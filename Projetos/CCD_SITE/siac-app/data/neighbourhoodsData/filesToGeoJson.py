from sys import argv
import json
import re
from pprint import pprint
import unicodedata
import string

# Args : 1 - algorithm , 2 - folder/* (todos os json dos bairros)
# 2 - niteroi-occurrences.json(Todas as ocorrências com o bairro incluso
# para poder calcular a densidade)
fileNames = argv[2:]
args = argv[:2]

print(fileNames)
print(args)

finalGeoJSON = {'type': 'FeatureCollection'}
finalGeoJSON['features'] = []

occurrences = {}

with open(args[1]) as occurrencesFile:
    occurrences = json.load(occurrencesFile)


def remove_accents(data):
    return ''.join(x for x in unicodedata.normalize('NFKD', data) if x in string.ascii_letters).lower()


def calculateDensity(neighbourhood):
    density = 0
    for occ in occurrences:
        suburb = occ['suburb']
        suburb = suburb.split(" ")
        catSuburb = ""
        if not (len(suburb) == 1):
            catSuburb = catSuburb + remove_accents(suburb[0])
            for sub in suburb[1:]:
                catSuburb = catSuburb + "_" + remove_accents(sub)
        else:
            catSuburb = remove_accents(suburb[0])
        print(catSuburb)
        if neighbourhood == catSuburb:
            density = density + 1
    return density


def getGeoJSON(data, fileName):
    matchObj = re.search(r'.*/(.*)', fileName)
    name = matchObj.group(1)
    geojson = {}
    geojson['type'] = "Feature"
    density = calculateDensity(name)
    geojson['properties'] = {"name": name, "density":density}
    geojson['geometry'] = {"type": "Polygon"}
    geojson['geometry']['coordinates'] = []

    firstGeographicPoint = data['points'][0]

    geoPoints = []

    for point in data['points']:
        geographicPoint = [point['lng'], point['lat']]
        geoPoints.append(geographicPoint)

    geoPoints.append(
        [firstGeographicPoint['lng'], firstGeographicPoint['lat']])

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

occurrencesFile.close()
