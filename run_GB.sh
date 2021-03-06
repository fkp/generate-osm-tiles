projection27700m="+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +datum=OSGB36 +units=m +no_defs"
mapnikconfig="/etc/mapnik-osm-carto-data/osm_OSGB.xml"

# These coordinates can clip out areas we are not interested in
extentWKT27700m="POLYGON ((61624 -83, 52313 22770, 91250 47318, 136959 62977, 164046 104031, 179282 155242, 230493 163283, 216526 181059, 172510 172171, 143308 200104, 138229 247929, 172510 271630, 216103 288983, 193249 303796, 177589 347388, 203830 364318, 198328 398176, 234725 415952, 233879 444731, 196211 450657, 189440 482822, 215680 508216, 191979 526838, 172934 568315, 126378 618679, 99715 632223, 84478 657617, 103524 688512, 101408 713906, 84055 726180, 66280 756229, 43848 757922, 20147 787125, 36653 864576, 28189 882352, -6515 882775, -6938 923405, 48927 925945, 56968 960226, 84478 963189, 126378 973347, 178859 983927, 189863 963612, 221182 988160, 251231 989429, 294824 985620, 296517 1027943, 320218 1058416, 366350 1078308, 401901 1121054, 372699 1137560, 387512 1157452, 419254 1217127, 465386 1238289, 492050 1232364, 503054 1195966, 498821 1153643, 476390 1128672, 454805 1086772, 389205 997894, 322334 891240, 365080 890817, 425179 888277, 438723 862460, 440839 827332, 385819 694014, 444648 649152, 473427 548000, 533526 510332, 572463 421454, 589393 379554, 658803 363048, 683773 325380, 682503 251315, 654993 204760, 641027 188677, 674885 179366, 683350 143391, 635525 95989, 550455 65517, 373545 40969, 336301 56629, 319372 51127, 313870 13883, 270700 7111, 231340 25733, 210178 27849, 197481 -2199, 61624 -83))"
basedir=OS

mincoordx=0
mincoordy=0
maxcoordx=700000
maxcoordy=1300000

# Something which looks like mini scale
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 700000 --coordsincrementy 1300000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 1000

# Something which looks like OS250K tiles
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 100000 --coordsincrementy 100000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 250

# Something which looks like OS50K tiles
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 20000 --coordsincrementy 20000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 50

# Something which looks like OS10K tiles
./GenerateTiles.py --basedir ${basedir} --imgsize 4000 --flatdirectorystructure --scale 2 --mincoordx ${mincoordx} --mincoordy ${mincoordy} --maxcoordx ${maxcoordx} --maxcoordy ${maxcoordy} --coordsincrementx 5000 --coordsincrementy 5000 "${projection27700m}" ${mapnikconfig} "${extentWKT27700m}" 10
