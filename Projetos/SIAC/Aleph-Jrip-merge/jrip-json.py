from sys import argv
import re
import json

script, filename = argv

inductions = open(filename, 'r')
data = {}
data['rules'] = []

for line in inductions:
    json_line = {}
    clauses = re.findall(r'\((.*?)\)', line)
    objects = []
    nb_loc = []
    json_line["date"] = json_line["time"] = json_line["geo_position"] = ""
    for clause in clauses:
        matchObj = re.search(r'(.*)=(.*)', clause)
        key = matchObj.group(1)        
        value = matchObj.group(2)        
        if value == "TRUE" or value == "FALSE":
            objects.append(key)
        elif key == "suburb":
            json_line['geo_position'] = value
        elif key == "date" or key == "time":
            json_line[key] = value
        elif key == "nearby_location":
            nb_loc.append(value)
    json_line['stolen_objects'] = objects
    json_line['occurrence_type'] = re.search(r'occurrence_type=(.*)\n', line).group(1)
    json_line['nearby_locations'] = nb_loc
    data['rules'].append(json_line)

with open('jrip.json', 'w') as outfile:
    json.dump(data, outfile)
