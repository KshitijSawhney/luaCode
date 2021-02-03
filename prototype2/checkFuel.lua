require("globals")
function checkFuel()
    if FUEL<=STEPS then
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