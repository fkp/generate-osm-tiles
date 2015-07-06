projection2260ft="+proj=tmerc +lat_0=38.83333333333334 +lon_0=-74.5 +k=0.9999 +x_0=150000 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs "
mapnikconfig="/etc/mapnik-osm-carto-data/osm_2260.xml"

# These coordinates can clip out areas we are not interested in
extentWKT2260ft="POLYGON ((389169 888586, 370071 921572, 379620 934593, 369203 960635, 377016 983204, 392641 998829, 409134 1025739, 442988 1020530, 458613 1010982, 490731 1062197, 574933 1001433, 571460 965843, 608787 967579, 617467 946746, 650453 947614, 659134 929385, 712085 923308, 712085 898135, 734655 875565, 755488 866017, 753752 833898, 729446 822614, 748544 795704, 743335 774871, 706877 739280, 709481 722787, 737259 701086, 728578 677648, 737259 662892, 705141 636850, 656530 620357, 637433 616017, 615731 592579, 620939 570010, 591426 560461, 561912 591711, 535870 613412, 547155 646398, 574064 678517, 604446 683725, 622676 720183, 486391 801780, 478578 858204, 434308 888586, 389169 888586))"
basedir=US
threads=4

./GenerateTiles.py --threads ${threads} --basedir ${basedir} --imgsize 4000 --scale 1 "${projection2260ft}" ${mapnikconfig} "${extentWKT2260ft}" 0 1 2 3 4 5 6 7 8 9 10

