#!/usr/bin/python
from osgeo import ogr
import sys, os, threading, time, math, argparse, multiprocessing

parser = argparse.ArgumentParser(description='A script to get the bounding box of a WKT string')
parser.add_argument("wkt", help="The WKT geometry")

args = parser.parse_args()

geometry = ogr.CreateGeometryFromWkt(args.wkt)
print "Envelope" + str(geometry.GetEnvelope())
