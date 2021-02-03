require("globals")

function forward()
    CURRX,CURRY,CURRZ =  gps.locate()
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

function turnAround()
    turnRight()
    turnRight()
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

function move(value)
    checkFuel()
    for i=value,0,-1 do
        turtle.dig()
        forward()
    end
end

X,Y,Z=tonumber(arg[2]),tonumber(arg[3]),tonumber(arg[4])

if(CURRX == X and CURRY == Y and CURRZ == Z) then
    print("Already here!")

else
    --translate in the X direction
    if currX~=X then
        if X>currX and HEADING ~= 2 then
            makeHeading(2)
        elseif X<currX and HEADING ~=0 then
            makeHeading(0)
        end
        move(math.abs(X-currX))
    end

    --translate in the Z direction
    if CURRZ~=Z then
        if Z>CURRZ and HEADING ~= 3 then
            makeHeading(3)
        elseif Z<CURRZ and HEADING ~=1 then
            makeHeading(1)
        end
        move(math.abs(Z-currZ))
    end
    --translate in the Y direction
    if CURRY~=Y then
        moveVertical(Y-CURRY)
    end
    print("done")
end