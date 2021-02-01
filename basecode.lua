--[[Program for the turtle to execute on startup]]
FIRST_FREE_SLOT = 4 --marks the first slot in the inventory
-- here is the breakdown of slots : {1:lava,2:empty buckets,3:items chest,4 to 16 : everything else}
TOTAL_SLOTS = 16

HOME_X,HOME_Y,HOME_Z = gps.locate()     --uses the pre-existing gps hosts to get position through trilateration
HEADING = 0           
STEPS = 0  --count for total steeps since last refuel

function forward()
    turtle.forward()
    STEPS=STEPS+1
end

function turnLeft()
    HEADING = (HEADING-1)%4
    turtle.turnLeft()
  end
  
function turnRight()
    HEADING = (HEADING+1)%4
    turtle.turnRight()
end

function move(value)
    for i=value,1,-1 do
        turtle.dig()
        forward()
    end
end

function moveVertical(value)
    if value < 0 then
        for i=math.abs(value),1,-1 do
            turtle.digDown()
            turtle.down()
            STEPS=STEPS+1
        end
    else
        for i=value,1,-1 do
            turtle.digUp()
            turtle.up()
            STEPS=STEPS+1
        end
    end
end

function turnAround()
    turnRight()
    turnRight()
end

function makeHeading(target)
    while target ~= HEADING do
        if target>HEADING then
            turnRight()
        elseif target < HEADING then
            turnLeft()
        end
    end
end

function getOrientation()
    loc1 = vector.new(gps.locate(2, false))
    if not turtle.forward() then
        for j=1,6 do
                if not turtle.forward() then
                        turtle.dig()
             else break end
        end
    end
    loc2 = vector.new(gps.locate(2, false))
    local heading = loc2 - loc1
    return ((heading.x + math.abs(heading.x) * 2) + (heading.z + math.abs(heading.z) * 3))-1
    end
    
    --[[orientation will be:
    -x = 0  (WEST)
    -z = 1  (NORTH)
    +x = 2  (EAST)
    +z = 3  (SOUTH)
    --]]

function refuel()
    if turtle.getFuelLevel()<=STEPS then
        invDump(FIRST_FREE_SLOT) --make sure invetory is empty to accept potential items
        turnAround() 
        while (turtle.detect()) do --makes space for chests even if it has to dig mulitiple blocks
            turtle.dig() 
        end
        turtle.select(1) -- select lava enderchest
        turtle.place()
        turtle.select(16) -- last slot specially for fuel
        turtle.suck() --get lava bucket
        turtle.refuel()
        turtle.select(1) -- lavachest slot
        turtle.dig()
        turtle.select(2) -- bucket chest slot
        turtle.place()
        turtle.select(16) --empty bucket
        turtle.drop() --puts bucket in enderchest
        turtle.select(2)
        turtle.dig()
        turnAround()
        print(turtle.getFuelLevel())
    end
end

function invDump(first_slot)
    turnAround()
    while (turtle.detect()) do --makes space for chests even if it has to dig mulitiple blocks
        turtle.dig() 
    end
    turtle.select(3)
    turtle.place()
    for i=TOTAL_SLOTS,first_slot,-1 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.select(3)
    turtle.dig()
    turnAround()
end

function moveTo(X,Y,Z)
    local currX,currY,currZ=gps.locate()

    --translate in the X direction
    if X>currX and HEADING ~= 2 then
        makeHeading(2)
    elseif X<currX and HEADING ~=0 then
        makeHeading(0)
    end
    move(math.abs(X-currX))

    --translate in the Z direction
    if Z>currZ and HEADING ~= 3 then
        makeHeading(3)
    elseif Z<currZ and HEADING ~=1 then
        makeHeading(1)
    end
    move(math.abs(Z-currZ))

    --translate in the Y direction
    moveVertical(Y-currY)
end

--[[
    The main loop of the turtle's functionality. It will start and then wait for a command via
    rednet broadcast
]]

rednet.open("right") -- open the wireless modem for communication
 while true do -- puts turtle into a waitloop for a message
    HEADING = getOrientation()
    local id,message = rednet.receive()
    command = {}
    for word in message:gmatch("%w+") do table.insert(command, word) end
    if command[1]=="exit" then
        break
    elseif command[1] =="dump" then
        invDump(FIRST_FREE_SLOT) 
    elseif command[1]=="checkFuel" then
        refuel()
    elseif command[1]=="moveTo" then
        moveTo(command[2],command[3],command[4])
    end
end