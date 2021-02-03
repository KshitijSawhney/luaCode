require("globals")

loc1 = vector.new(gps.locate(2, false))
if not turtle.forward() then
    for j=1,6 do
        if not turtle.forward() then
            turtle.dig()
        else
            break
        end
    end
end
loc2 = vector.new(gps.locate(2, false))
local heading = loc2 - loc1
return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))-1

--[[orientation will be:
-x = 0  (WEST)
-z = 1  (NORTH)
+x = 2  (EAST)
+z = 3  (SOUTH)
--]]
