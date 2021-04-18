--[[Program for the turtle to execute on startup]]
FIRST_FREE_SLOT = 4 --marks the first slot in the inventory
-- here is the breakdown of slots : {1:lava,2:empty buckets,3:items chest,4 to 16 : everything else}
TOTAL_SLOTS = 16
TUNNEL_START = {143,70,555}
TUNNEL_END = {143,70,537}
CURRX,CURRY,CURRZ=_,_,_
HEADING = 0           
STEPS = 0  --count for total steps since last refuel

VISITED={}

function forward()
    checkFuel()
    checkFullInv()
    turtle.forward()
    CURRX,CURRY,CURRZ =  gps.locate()
    STEPS=STEPS+1
end

function back()
    checkFuel()
    checkFullInv()
    turtle.back()
    CURRX,CURRY,CURRZ =  gps.locate()
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

function turnAround()
    turnRight()
    turnRight()
end

function refuel()
    checkFullInv() --make sure invetory is empty to accept potential items
    while (turtle.detectUp()) do --makes space for chests even if it has to dig mulitiple blocks
        turtle.digUp() 
    end
    turtle.select(1) -- select lava enderchest
    turtle.placeUp()
    turtle.select(16) -- last slot specially for fuel
    turtle.suckUp() --get lava bucket
    turtle.refuel()
    turtle.select(1) -- lavachest slot
    turtle.digUp()
    turtle.select(2) -- bucket chest slot
    turtle.placeUp()
    turtle.select(16) --empty bucket
    turtle.dropUp() --puts bucket in enderchest
    turtle.select(2)
    turtle.digUp()
end

function checkFuel()
    if turtle.getFuelLevel()==0 then
        refuel()
    end
end

function checkFullInv()
    if turtle.getItemDetail(16) ~= nil then
        invDump()
    end    
end

function move(value)
    checkFullInv()
    checkFuel()
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
            else
                break
            end
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



function invDump()
    while (turtle.detectUp()) do --makes space for chests even if it has to dig mulitiple blocks
        turtle.digUp() 
    end
    turtle.select(3)
    turtle.placeUp()
    for i=TOTAL_SLOTS,FIRST_FREE_SLOT,-1 do
        turtle.select(i)
        turtle.dropUp()
    end
    turtle.select(3)
    turtle.digUp()
end

function moveTo(X,Y,Z)
    CURRX,CURRY,CURRZ=gps.locate()
    if(CURRX==X and CURRY==Y and CURRZ==Z) then
        print("Already here!")
        return

    else
        --translate in the X direction
        if CURRX~=X then
            if X>CURRX and HEADING ~= 2 then
                makeHeading(2)
            elseif X<CURRX and HEADING ~=0 then
                makeHeading(0)
            end
            move(math.abs(X-CURRX))
        end

        --translate in the Z direction
        if CURRZ~=Z then
            if Z>CURRZ and HEADING ~= 3 then
                makeHeading(3)
            elseif Z<CURRZ and HEADING ~=1 then
                makeHeading(1)
            end
            move(math.abs(Z-CURRZ))
        end
        --translate in the Y direction
        if CURRY~=Y then
            moveVertical(Y-CURRY)
        end
        print("done")
    end
end

function inspect(direction)
    local s,data
    if direction=="F" then
        s,data = turtle.inspect()
    elseif direction=="U" then
        s,data = turtle.inspectUp()
    elseif direction=="D" then
        s,data = turtle.inspectDown()
    elseif direction=="L" then
        turnLeft()
        s,data = turtle.inspect()
    elseif direction=="R" then
        turnRight()
        s,data = turtle.inspect()
    elseif direction=="B" then
        turnAround()
        s,data = turtle.inspect()
    end
    if s then
        os.sleep(0.1)
        return isOre(data)
    end
end

function dfsMiner(vein_start)
    table.insert( VISITED,{CURRX,CURRY,CURRZ})
    if inspect("F") ~=true then
        if inspect("B") ~=true then
            turnAround()
            if inspect("U") ~= true  then
                if inspect("D") ~= true then
                    if inspect("L") ~= true then
                        turnRight()
                        if inspect("R") ~= true then
                            turnLeft()
                            moveTo(vein_start[1],vein_start[2],vein_start[3])
                            return
                        else
                            local start = {CURRX,CURRY,CURRZ}       
                            move(1)
                            dfsMiner(start)
                        end
                    else
                        local start = {CURRX,CURRY,CURRZ}       
                        move(1)
                        dfsMiner(start)        
                    end
                else
                    local start = {CURRX,CURRY,CURRZ}
                    moveVertical(-1)
                    dfsMiner(start)          
                end
            else
                local start = {CURRX,CURRY,CURRZ}
                moveVertical(1)
                dfsMiner(start)
            end
        else
            local start = {CURRX,CURRY,CURRZ}
            move(1)
            dfsMiner(start)
        end
    else
        local start = {CURRX,CURRY,CURRZ}
        move(1)
        dfsMiner(start)
    end
end

function isOre(data)
    local name=data.name
    name=string.lower( name )
    if string.match( name,"ore",-3 ) then
        return true
    else
        return false
    end
end

function smartTunnel(heading,dist)
    for i=1,dist do
        makeHeading(heading)
        table.insert( VISITED,{CURRX,CURRY,CURRZ})
        if inspect("U") ~= true  then
            if inspect("D") ~= true then
                if inspect("L") ~= true then
                    turnRight()
                    if inspect("R") ~= true then
                        turnLeft()
                        move(1)
                    else
                        local initial_pos={CURRX,CURRY,CURRZ}
                        move(1)
                        dfsMiner({CURRX,CURRY,CURRZ})
                        moveTo(initial_pos[1],initial_pos[2],initial_pos[3])
                    end
                else
                    local initial_pos={CURRX,CURRY,CURRZ}
                    move(1)
                    dfsMiner({CURRX,CURRY,CURRZ})
                    moveTo(initial_pos[1],initial_pos[2],initial_pos[3])           
                end
            else
                local initial_pos={CURRX,CURRY,CURRZ}
                moveVertical(-1)
                dfsMiner({CURRX,CURRY,CURRZ})
                moveTo(initial_pos[1],initial_pos[2],initial_pos[3])
            end
        else
            local initial_pos={CURRX,CURRY,CURRZ}
            moveVertical(1)
            dfsMiner({CURRX,CURRY,CURRZ})
            moveTo(initial_pos[1],initial_pos[2],initial_pos[3])   
        end
    end
end


function selfRemove()
    moveTo(TUNNEL_START[1],TUNNEL_START[2],TUNNEL_START[3])
    moveTo(TUNNEL_END[1],TUNNEL_END[2],TUNNEL_END[3])
    rednet.broadcast("master remove")
end

function mine( x1,y1,z1,x2,y2,z2 )
    --cannot dig below y=1 as y=0 is bedrock
    if y1<1 then y1=1
    elseif y2<1 then y2=1
    end
    --move to top-northwest corner and dig to bottom-southwest corner
    moveTo(math.min(x1,x2),math.max(y1,y2),math.min(z1,z2))

    local targetX,targetY,targetZ=math.max(x1,x2),math.min(y1,y2),math.max(z1,z2)

    --facing SOUTH
    makeHeading(3)

    --how much to dig in each direction
    local xdist,ydist,zdist=math.abs(x1-x2),math.abs(y1-y2),math.abs(z1-z2)
    for i = 0 , ydist do
        for j=i , xdist + i do
            move(zdist)
            if j~= xdist + i then 
                if (j+(2*i))%2==1 then
                    turnRight()
                    turtle.dig()
                    forward()
                    turnRight()
                else
                    turnLeft()
                    turtle.dig()
                    forward()
                    turnLeft()
                end
            end
        end
        if i ~= ydist then
            turnAround()
            moveVertical(-1)
        end
    end
    moveTo(math.min(x1,x2),math.max(y1,y2)+1,math.min(z1,z2)) --go back to top+1-northwest corner
    invDump()
    selfRemove()
end

--[[
    The main loop of the turtle's functionality. It will start and then wait for a command via
    rednet broadcast
]]

turtle.suckDown(1)
turtle.turnRight()
turtle.suck(1)
turtle.turnLeft()
turtle.turnLeft()
turtle.suck(1)
turtle.turnRight()
checkFuel()

rednet.open("right") -- open the wireless modem for communication

HEADING = getOrientation()
back()

rednet.broadcast("added")


while true do -- puts turtle into a waitloop for a message
    local _,message = rednet.receive()
    command = {}
    for word in message:gmatch("%w+") do table.insert(command, word) end
    if tonumber(command[1])==os.getComputerID() then
        table.remove(command,1)
        if command[1]=="exit" then
            break
        elseif command[1] =="dump" then
            invDump() 
        elseif command[1]=="checkFuel" then
            checkFuel()
        elseif command[1]=="moveTo" then
            moveTo(tonumber(command[2]),tonumber(command[3]),tonumber(command[4]))
        elseif command[1]=="mine" then
            mine(tonumber(command[2]),tonumber(command[3]),tonumber(command[4]),tonumber(command[5]),tonumber(command[6]),tonumber(command[7]))
        elseif command[1]=="branch" then
            moveTo(tonumber(command[2]),tonumber(command[3]),tonumber(command[4]))
            smartTunnel(tonumber(command[5]),tonumber(command[6]))
        elseif command[1]=="remove" then
            selfRemove()
        end
    end
end
