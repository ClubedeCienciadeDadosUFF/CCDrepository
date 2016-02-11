import json
from collections import defaultdict

suburb_count = defaultdict(lambda: 0, {})
time_count = defaultdict(lambda: 0, {})
date_count = defaultdict(lambda: 0, {})
occurrence_count = defaultdict(lambda: 0, {})
objects_count = defaultdict(lambda: 0, {})

suburb_weight = defaultdict(lambda: 0, {})
time_weight = defaultdict(lambda: 0, {})
date_weight = defaultdict(lambda: 0, {})
occurrence_weight = defaultdict(lambda: 0, {})
objects_weight = defaultdict(lambda: 0, {})

with open('aleph.json') as aleph_file:
    aleph_json = json.load(aleph_file)

with open('jrip.json') as jrip_file:
    jrip_json = json.load(jrip_file)

n_inductions = len(jrip_json['rules']) + len(aleph_json['rules'])


def get_aleph_inductions():
    for aleph_rule in aleph_json['rules']:
        if aleph_rule['occurrence_type']:
            occurrence_count[aleph_rule['occurrence_type']] += 1
        if aleph_rule['time']:
            time_count[aleph_rule['time']] += 1
        if aleph_rule['date']:
            date_count[aleph_rule['date']] += 1
        if aleph_rule['geo_position']:
            suburb_count[aleph_rule['geo_position']] += 1
        for obj in aleph_rule['stolen_objects']:
            objects_count[obj] += 1


def get_jrip_inductions():
    for jrip_rule in jrip_json['rules']:
        if jrip_rule['occurrence_type']:
            occurrence_count[jrip_rule['occurrence_type']] += 1
        if jrip_rule['time']:
            time_count[jrip_rule['time']] += 1
        if jrip_rule['date']:
            date_count[jrip_rule['date']] += 1
        if jrip_rule['geo_position']:
            suburb_count[jrip_rule['geo_position']] += 1
        for obj in jrip_rule['stolen_objects']:
            objects_count[obj] += 1


def calculate_weights():
    for suburb in suburb_count:
        suburb_weight[suburb] = suburb_count[suburb] / n_inductions
    for time in time_count:
        time_weight[time] = time_count[time] / n_inductions
    for date in date_count:
        date_weight[date] = date_count[date] / n_inductions
    for occurrence in occurrence_count:
        occurrence_weight[occurrence] = occurrence_count[
            occurrence] / n_inductions
    for obj in objects_count:
        objects_weight[obj] = objects_count[obj] / n_inductions

get_aleph_inductions()
get_jrip_inductions()
calculate_weights()

data = {}
data['weights'] = {}
data['weights']['suburbs'] = suburb_weight
data['weights']['time'] = time_weight
data['weights']['date'] = date_weight
data['weights']['occurrence'] = occurrence_weight
data['weights']['objects'] = objects_weight

with open('weights.json', 'w') as outfile:
    json.dump(data, outfile)
