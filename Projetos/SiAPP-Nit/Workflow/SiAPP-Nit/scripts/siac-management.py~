import xml.etree.ElementTree as ET
import os
import re
import sys

#"/home/bbspock/CCDrepository/Projetos/SIAC/Oficial/Workflow/SIAC/SIAC.xml"
tree = ET.parse(sys.argv[1])
root = tree.getroot()

#environment
env = root.find('environment')
VERBOSE = env.get('verbose')

#workspace
ws = root.find('workspace')
WORKFLOW_DIRECTORY = ws.get('workflow_dir')
EXP_DIRECTORY = WORKFLOW_DIRECTORY+"exp/"

#databse
#TODO

#conceptualWorkflow
cwf = root.find('conceptualWorkflow')
activities = cwf.findall('activity')
for activity in activities:
    print(activity.get('tag'))
    print(activity.get('description'))
    script = WORKFLOW_DIRECTORY + activity.get('script')
    commd = "Rscript " + script
    for relation in activity.findall('relation'):
        name = relation.get('name')
        if relation.get('reltype') == "Input":
            args = re.split(',', name)
            for arg in args:
                commd += " " + EXP_DIRECTORY + arg
        if relation.get('reltype') == "Output":
            commd += " " + EXP_DIRECTORY + name 
    os.system(commd)
print("End execution")
