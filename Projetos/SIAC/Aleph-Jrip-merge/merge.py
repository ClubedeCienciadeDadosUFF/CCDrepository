import json

#occurrence_type
#geo_position
#!nearby_locations
#stolen_objects
#time
#date

ST_RIGHT = 1
ST_WRONG = 0

def tuple_compare(a, j): #aleph, jrip    
    right = wrong = 0
    if a['occurrence_type'] != j['occurrence_type']: return False       
    if a['geo_position'] == j['geo_position']: right += 1
    else: wrong += 1
    if a['date'] == j['date']: right += 1
    else: wrong += 1
    if a['time'] == j['time']: right += 1
    else: wrong += 1
    for a_o in a['stolen_objects']:
        for j_o in j['stolen_objects']:
            if a_o == j_o: right += 1
            else: wrong += 1
    for a_o in a['nearby_locations']:
        for j_o in j['nearby_locations']:
            if a_o == j_o: right += 1
            else: wrong += 1
    if right >= ST_RIGHT and wrong >= ST_WRONG: return True
    return False

def format_tuple(t):
    #arg1 AND arg2 AND ... argn :- occurrence_type   
    s_and = ""
    string = ""
    if t['geo_position'] != "":
        string += s_and + t['geo_position']
        s_and = " AND "
    if t['date'] != "":
        string += s_and + t['date']
        s_and = " AND "
    if t['time'] != "":
        string += s_and + t['time']
        s_and = " AND "
    for t_o in t['stolen_objects']:
        string += s_and + t_o
        s_and = " AND "
    for t_o in t['nearby_locations']:
        string += s_and + t_o
        s_and = " AND "
    string += " :- " + t['occurrence_type'] + '\n'
    return string

with open('aleph.json') as aleph:
    aleph = json.load(aleph)

with open('jrip.json') as jrip:
    jrip = json.load(jrip)

output = open('output.potato', "w")

for aleph_rule in aleph['rules']:
    for jrip_rule in jrip['rules']:
        if tuple_compare(aleph_rule, jrip_rule):
            output.write(format_tuple(aleph_rule))
            output.write(format_tuple(jrip_rule))
            output.write("-----\n")
output.close()
