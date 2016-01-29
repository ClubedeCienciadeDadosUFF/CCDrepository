from sys import argv
import re
import json

script, filename = argv

inductions = open(filename, 'r')
data = {}
data['rules'] = []

for line in inductions:

    matchObj = None
    json_line = {}

    occurence_type = ""
    matchObj = re.search(r'occurrence\(A,(.*)\)\s', line)
    if matchObj:
        occurrence_type = matchObj.group(1)
    json_line['occurrence_type'] = occurrence_type

    geo_position = ""
    matchObj = re.search(r'geo_position\(A,(.*?)\)', line)
    if matchObj:
        geo_position = matchObj.group(1)
    json_line['geo_position'] = geo_position

    # time
    time = ""
    matchObj = re.search(r'morning\(A\)?', line)
    if matchObj:
        time = "morning"
    matchObj = re.search(r'evening\(A\)?', line)
    if matchObj:
        time = "evening"
    matchObj = re.search(r'night\(A\)?', line)
    if matchObj:
        time = "night"
    matchObj = re.search(r'dawn\(A\)?', line)
    if matchObj:
        time = "dawn"

    json_line['time'] = time

    # date
    date = ""
    matchObj = re.search(r'business_day\(A\)?', line)
    if matchObj:
        date = "business_day"
    matchObj = re.search(r'weekend\(A\)?', line)
    if matchObj:
        date = "weekend"

    json_line['date'] = date

    objects = re.findall(r'object\(A,(.*?)\)', line)
    json_line['stolen_objects'] = objects

    nearby_locations = re.findall(r'nearby_location\(A,(.*?)\)', line)
    json_line['nearby_locations'] = nearby_locations

    data['rules'].append(json_line)


with open('aleph.json', 'w') as outfile:
    json.dump(data, outfile)
