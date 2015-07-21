#!/usr/bin/python
import xml.etree.ElementTree as ET
import argparse

parser = argparse.ArgumentParser(description='A script to replace min and max scales in meters to equivalent ft values')
parser.add_argument("xmlFile", help="The XML file to open")

args = parser.parse_args()

tree = ET.parse(args.xmlFile)
root = tree.getroot()
replacements = {}

def ReplaceElementMtoFt(inRoot, inElementName):
  for elem in root.iter(inElementName):
    meters = int(elem.text)
    if not(meters in replacements):
      feet = int(meters * 3.2808399)
      print ":%s/ScaleDenominator>" + str(meters) + "/" + "ScaleDenominator>" + str(feet) + "/g"
      replacements[meters] = 1
      #elem.text = str(feet)

ReplaceElementMtoFt(root, "MinScaleDenominator")
ReplaceElementMtoFt(root, "MaxScaleDenominator")

# Note we will overwrite the same file
#with open(args.xmlFile, "w") as file:
#  tree.write(file)
