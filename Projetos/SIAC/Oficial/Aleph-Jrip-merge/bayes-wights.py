import json
from collections import defaultdict

counter = defaultdict(lambda: 0, {})
counter['a'] = 1

with open('aleph.json') as aleph_file:
    aleph = json.load(aleph_file)

with open('jrip.json') as jrip_file:
    jrip = json.load(jrip_file)


def count_json(json, counter): #json must be aleph or jrip
    for j in json['rules']:
        if j['occurrence_type']:
            counter['occurrence_type'] += 1
            #counter['occurrence_type'][j['occurrence_type']] += 1
        if j['time']:
            counter['time'] += 1
            #counter['time'][j['time']] += 1
        if j['date']:
            counter['date'] += 1
            #counter['date'][j['date']] += 1
        if j['geo_position']:
            counter['geo_position'] += 1
        for obj in j['stolen_objects']:
            #counter['geo_position'][j['date']] += 1
            counter['stolen_objects'] += 1
            #counter['stolen_objects'][obj] += 1
    
    #return counter

#count_json(aleph, counter)
#counter = count_json(jrip)

print(counter[counter['b']])
