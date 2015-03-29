#!/usr/bin/python
from mapnik2 import *
from osgeo import ogr
import sys, os, threading, time, math, argparse
from Queue import *

class TileParams:
    def __init__(self, inMinX, inMinY, inMaxX, inMaxY, inTileSize, inZoom, inPad):
        ring = ogr.Geometry(ogr.wkbLinearRing)
        ring.AddPoint(inMinX, inMinY)
        ring.AddPoint(inMaxX, inMinY)
        ring.AddPoint(inMaxX, inMaxY)
        ring.AddPoint(inMinX, inMaxY)
        ring.AddPoint(inMinX, inMinY)

        self.TileGeometry = ogr.Geometry(ogr.wkbPolygon)
        self.TileGeometry.AddGeometry(ring)

        self.TileSize = inTileSize
        self.Zoom = inZoom
        self.Pad = inPad

        self.MinX = inMinX
        self.MinY = inMinY
        self.MaxX = inMaxX
        self.MaxY = inMaxY

    def GetMinX(self): return self.MinX
    def GetMinY(self): return self.MinY
    def GetMaxX(self): return self.MaxX
    def GetMaxY(self): return self.MaxY
    def GetTileSize(self): return self.TileSize
    def GetZoom(self): return self.Zoom
    def GetPad(self): return self.Pad

    def IntersectsArea(self, inExtractArea):
        return inExtractArea.Intersect(self.TileGeometry)

class ThreadedTileGenerator(threading.Thread):
    def __init__(self, inQueue, inThreadnum, inBasedir, inProjection, inMapnikconfig, inExtractAreaGeom, inFullClipBelowZoom):
        threading.Thread.__init__(self)
        self.queue = inQueue
        self.threadnum = inThreadnum
        self.basedir = inBasedir
        self.projection = inProjection
        self.mapnikconfig = inMapnikconfig
        self.extractAreaGeom = inExtractAreaGeom
        self.fullClipBelowZoom = inFullClipBelowZoom

    def run(self):
        while True:

            # Blocks, waiting for something to become avialable on the queue. This at the moment can give a NoneType error while the script is in the process of shutting down. Can't figure out how to stop this but it doesn't do any harm as all the queued items are done and the script is terminating.
            item = self.queue.get()

            self.DrawMap(item)

            # Mark the item we have taken off the queue as done - not sure how python marries this up with the item taken above, but seems to work just fine and this is how all the documentation suggests this should be done
            self.queue.task_done()

    def DrawMap(self, params):

        filename = self.basedir + "/" + str(params.GetZoom()) + "/" + str(params.GetMinX()).zfill(params.GetPad()) + "_" + str(params.GetMinY()).zfill(params.GetPad()) + ".png"

        # Create a bounding box for this tile so we can figure out if we should render it
        if params.GetZoom() > self.fullClipBelowZoom and not(params.IntersectsArea(extractAreaGeom)):
            self.Log("Skipping tile " + filename + " as outside extract area")
        elif os.path.isfile(filename):
            self.Log("Skipping file " + filename + " as it already exists")
        else:
            self.Log(filename)

            m = Map(params.GetTileSize(),params.GetTileSize(),self.projection)
            load_map(m,self.mapnikconfig)
            bbox = Envelope(params.GetMinX(),params.GetMinY(),params.GetMaxX(),params.GetMaxY())
            m.zoom_to_box(bbox)

            # This prevents labels being drawn on the boundary of the tiles
            m.buffer_size = params.GetTileSize() / 2

            im = Image(params.GetTileSize(),params.GetTileSize())
            render(m, im)
            # x,y,width,height
            view = im.view(0,0,params.GetTileSize(),params.GetTileSize()) 

            dirname = os.path.dirname(filename)
            if not os.path.exists(dirname):
                os.makedirs(dirname)

            view.save(filename,'png')

    def Log(self, message):
        # Prefix all log messages with the thread number and current queue size
        print "[t" + str(self.threadnum) + ", q" + str(self.queue.qsize()) + "] " + message


parser = argparse.ArgumentParser(description='A script to generate OSM tiles in a specific coordinate system')

parser.add_argument("projection", help="The Proj4 projection to use")
parser.add_argument("mapnikconfig", help="The mapnik config file to be used for the rendering")
parser.add_argument("extractarea", help="The extract area as a WKT polygon (coordinates in the destination coordinate system)")
parser.add_argument("--threads", type=int, default=2, help="The number of threads to start rendering with")
parser.add_argument("--fullClipBelowZoom", type=int, default=-1, help="If specified, the script will only perform a full clip based on the extract polygon below this zoom level, so zoom levels above this will receive the whole extent of the extract region")
parser.add_argument("--paddigits", type=int, default=8, help="The number of digits to pad coordinates written to file and directory names")
parser.add_argument("--imgsize", type=int, default=500, help="The resulting image size in pixels")
parser.add_argument("--basedir", help="The base directory to generate the tiles into")

args = parser.parse_args()

extractAreaGeom = ogr.CreateGeometryFromWkt(args.extractarea)
extractAreaEnvelope = extractAreaGeom.GetEnvelope()

mincoords = (0, 0)
maxcoords = (800000, 1300000)
projection = args.projection
mapnikconfig = args.mapnikconfig
imgsize = args.imgsize
paddigits = args.paddigits
numthreads = args.threads
maxQueueSize = 500000
fullClipBelowZoom = args.fullClipBelowZoom

if args.basedir is not None:
    basedir = args.basedir
else:
    basedir = ""

# Hardcoded to match the OS 50K coordinate space
xcoordsincrement = 20000
ycoordsincrement = 20000

x = 0
y = 0

queue = Queue()

for i in range(numthreads):
    t = ThreadedTileGenerator(queue, i, basedir, projection, mapnikconfig, extractAreaGeom, fullClipBelowZoom)
    t.daemon = True
    t.start()

while (y < maxcoords[1]):
    while (x < maxcoords[0]):

        # If the queue gets too big then hang on until the rendering threads have a chance to pick some of these off
        while (queue.qsize() > maxQueueSize):
            time.sleep(10)
        # Truncate all coordinates to an integer when they are passed to the render method
        queue.put(TileParams(int(x),int(y),int(x+xcoordsincrement),int(y+ycoordsincrement),imgsize,50,paddigits))
        x = x+xcoordsincrement
    y = y+ycoordsincrement
    x = mincoords[0]

# Blocks until all items in the queue are processed
queue.join()



