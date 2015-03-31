#!/usr/bin/python
from mapnik import *
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
    def __init__(self, inQueue, inThreadnum, inBasedir, inProjection, inMapnikconfig, inExtractAreaGeom, inFullClipBelowZoom, inFlatDirectoryStructure, inScale):
        threading.Thread.__init__(self)
        self.queue = inQueue
        self.threadnum = inThreadnum
        self.basedir = inBasedir
        self.projection = inProjection
        self.mapnikconfig = inMapnikconfig
        self.extractAreaGeom = inExtractAreaGeom
        self.fullClipBelowZoom = inFullClipBelowZoom
        self.flatDirectoryStructure = inFlatDirectoryStructure
        self.scale = inScale

    def run(self):
        while True:

            # Blocks, waiting for something to become avialable on the queue. This at the moment can give a NoneType error while the script is in the process of shutting down. Can't figure out how to stop this but it doesn't do any harm as all the queued items are done and the script is terminating.
            item = self.queue.get()

            self.DrawMap(item)

            # Mark the item we have taken off the queue as done - not sure how python marries this up with the item taken above, but seems to work just fine and this is how all the documentation suggests this should be done
            self.queue.task_done()

    def DrawMap(self, params):

        if self.flatDirectoryStructure:
            xySeparator = "_"
        else:
            xySeparator = "/"

        filename = self.basedir + "/" + str(params.GetZoom()) + "/" + str(params.GetMinX()).zfill(params.GetPad()) + xySeparator + str(params.GetMinY()).zfill(params.GetPad()) + ".png"

        # Create a bounding box for this tile so we can figure out if we should render it
        if params.GetZoom() > self.fullClipBelowZoom and not(params.IntersectsArea(extractAreaGeom)):
            self.Log("Skipping tile " + filename + " as outside extract area")
        elif os.path.isfile(filename):
            self.Log("Skipping file " + filename + " as it already exists")
        else:
            self.Log(filename)

            m = Map(params.GetTileSize(),params.GetTileSize(),self.projection)
            load_map(m,self.mapnikconfig)
            bbox = Box2d(params.GetMinX(),params.GetMinY(),params.GetMaxX(),params.GetMaxY())
            m.zoom_to_box(bbox)

            # This prevents labels being drawn on the boundary of the tiles
            m.buffer_size = params.GetTileSize() / 2

            im = Image(params.GetTileSize(),params.GetTileSize())
            render(m, im, self.scale)
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
parser.add_argument("zoomlevels", type=int, nargs='+', help="The zoom levels to render")
parser.add_argument("--threads", type=int, default=2, help="The number of threads to start rendering with")
parser.add_argument("--fullClipBelowZoom", type=int, default=-1, help="If specified, the script will only perform a full clip based on the extract polygon below this zoom level, so zoom levels above this will receive the whole extent of the extract region")
parser.add_argument("--paddigits", type=int, default=8, help="The number of digits to pad coordinates written to file and directory names")
parser.add_argument("--imgsize", type=int, default=500, help="The resulting image size in pixels")
parser.add_argument("--basedir", help="The base directory to generate the tiles into")
parser.add_argument("--mincoordx", type=int, help="The x coordinate to start generating tiles from in the destination coordinate system. If not specified, will be inferred from the extent of the polygon extract region")
parser.add_argument("--mincoordy", type=int, help="The y coordinate to start generating tiles from in the destination coordinate system. If not specified, will be inferred from the extent of the polygon extract region")
parser.add_argument("--maxcoordx", type=int, help="The x coordinate to end generating tiles from in the destination coordinate system. If not specified, will be inferred from the extent of the polygon extract region")
parser.add_argument("--maxcoordy", type=int, help="The y coordinate to end generating tiles from in the destination coordinate system. If not specified, will be inferred from the extent of the polygon extract region")
parser.add_argument("--coordsincrementx", type=int, default=-1, help="The x coordinate increment to use. If not specified, will be inferred from the extent of the polygon extract region divided by the square of the zoom level (so zoom 0 is the full extent, 1 is divided into half in both direction etc")
parser.add_argument("--coordsincrementy", type=int, default=-1, help="The y coordinate increment to use. If not specified, will be inferred from the extent of the polygon extract region divided by the square of the zoom level (so zoom 0 is the full extent, 1 is divided into half in both direction etc")
parser.add_argument("--flatdirectorystructure", action='store_true', help="Whether to generate the tiles in a flat directory or use the x coordinate to split them into seperate directories")
parser.add_argument("--scale", type=int, default=1, help="How much to scale the rendering of the data. The OSM style sheet works for Global Mercator but for other projections you may have to scale this up a little to avoid having too much detail in the tiles generated")

args = parser.parse_args()

projection = args.projection
mapnikconfig = args.mapnikconfig
imgsize = args.imgsize
paddigits = args.paddigits
numthreads = args.threads
maxQueueSize = 500000
fullClipBelowZoom = args.fullClipBelowZoom
extractAreaGeom = ogr.CreateGeometryFromWkt(args.extractarea)
coordsincrementx = args.coordsincrementx
coordsincrementy = args.coordsincrementy
flatDirectoryStructure = args.flatdirectorystructure
scale = args.scale

if args.mincoordx is not None and args.mincoordy is not None and args.maxcoordx is not None and args.maxcoordy is not None:
    print "Using min and max coordinates from arguments"
    mincoords = args.mincoordx, args.mincoordy
    maxcoords = args.maxcoordx, args.maxcoordy
else:
    print "Deriving min and max coordinates from extract area extent"
    extractAreaEnvelope = extractAreaGeom.GetEnvelope()
    mincoords = (int(extractAreaEnvelope[0]), int(extractAreaEnvelope[2]))
    maxcoords = (int(extractAreaEnvelope[1])+1, int(extractAreaEnvelope[3])+1)

if args.basedir is not None:
    basedir = args.basedir
else:
    basedir = ""

# A queue to put tiles in for rendering on threads
queue = Queue()

for zoom in args.zoomlevels:

    print "About to render zoom level: " + str(zoom)

    maxtilesize = max(maxcoords[0] - mincoords[0], maxcoords[1] - mincoords[1])

    print "Max tile size: " + str(maxtilesize)

    if coordsincrementx != -1 and coordsincrementy != -1:
        xcoordsincrement = coordsincrementx
        ycoordsincrement = coordsincrementy
    else:
        xcoordsincrement = maxtilesize / math.pow(2, zoom)
        ycoordsincrement = xcoordsincrement

    print "Coordinate increment for zoom level " + str(zoom) + " is " + str(xcoordsincrement)

    x = mincoords[0]
    y = mincoords[1]


    for i in range(numthreads):
        t = ThreadedTileGenerator(queue, i, basedir, projection, mapnikconfig, extractAreaGeom, fullClipBelowZoom, flatDirectoryStructure, scale)
        t.daemon = True
        t.start()

    while (y < maxcoords[1]):
        while (x < maxcoords[0]):

            # If the queue gets too big then hang on until the rendering threads have a chance to pick some of these off
            while (queue.qsize() > maxQueueSize):
                time.sleep(10)
            # Truncate all coordinates to an integer when they are passed to the render method
            queue.put(TileParams(int(x),int(y),int(x+xcoordsincrement),int(y+ycoordsincrement),imgsize,zoom,paddigits))
            x = x+xcoordsincrement
        y = y+ycoordsincrement
        x = mincoords[0]

    # Blocks until all items in the queue are processed
    queue.join()



