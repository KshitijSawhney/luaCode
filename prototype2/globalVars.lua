FIRST_FREE_SLOT = 4 --marks the first slot in the inventory
-- here is the breakdown of slots : {1:lava,2:empty buckets,3:items chest,4 to 16 : everything else}
TOTAL_SLOTS = 16
CURRX,CURRY,CURRZ=gps.locate()
HEADING = 0
FUEL=turtle.getFuelLevel()           
STEPS = 0
