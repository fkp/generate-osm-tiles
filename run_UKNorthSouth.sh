projection27700m="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
mapnikconfig="/etc/mapnik-osm-carto-data/osm_OSGB.xml"

# These coordinates can clip out areas we are not interested in
extentWKT27700mNorth="POLYGON((279079 530299,305081 551348,359561 552587,353370 594685,417755 662784,396706 685072,380610 703644,386801 740790,422708 812604,438804 860893,414041 883180,342226 886895,271650 886895,240696 868322,240696 836129,272888 820033,345941 817557,348417 796508,342226 774221,316225 770506,286508 784126,238219 713550,212218 707359,191169 672690,215932 620686,189930 558778,212218 540205,232029 552587,279079 530299),(194883 745742,168881 744504,173834 712312,202622 715717,194883 745742,194883 745742),(306010 985639,291771 957780,347489 931779,358013 960876,306010 985639,306010 985639),(140094 951590,122759 925588,148142 913206,161143 939208,140094 951590,140094 951590),(182811 629663,157428 635854,158047 609852,184668 602423, 182811 629663))"
extentWKT27700mSouth="POLYGON((317162 108641,412846 175505,404777 242370,443973 275802,497003 264273,522365 236605,514296 193951,566173 203173,663011 181270,658399 121322,590382 82126,456654 59069,333301 59069,305633 82126,317162 108641))"
basedirNorth=North
basedirSouth=South
basedirCommon=Common

mincoordx=0
mincoordy=0
maxcoordx=700000
maxcoordy=1300000

# Something which looks like mini scale (common to North and South)
./GenerateTiles.py --basedir ${basedirCommon} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 700000 --coordsincrementy 1300000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mNorth}" 1000

# Something which looks like OS250K tiles
./GenerateTiles.py --basedir ${basedirNorth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 100000 --coordsincrementy 100000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mNorth}" 250
./GenerateTiles.py --basedir ${basedirSouth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 100000 --coordsincrementy 100000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mSouth}" 250


# Something which looks like OS50K tiles
./GenerateTiles.py --basedir ${basedirNorth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mNorth}" 50
./GenerateTiles.py --basedir ${basedirSouth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mSouth}" 50

# Generate 50K tiles which are zoomed in a bit too just to compare
basedirNorthScaled=NorthScaled
basedirSouthScaled=SouthScaled
./GenerateTiles.py --scale 3 --basedir ${basedirNorthScaled} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mNorth}" 50
./GenerateTiles.py --scale 3 --basedir ${basedirSouthScaled} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mSouth}" 50

# Something which looks like OS10K tiles
./GenerateTiles.py --basedir ${basedirNorth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 5000 --coordsincrementy 5000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mNorth}" 10
./GenerateTiles.py --basedir ${basedirSouth} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 5000 --coordsincrementy 5000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700mSouth}" 10

