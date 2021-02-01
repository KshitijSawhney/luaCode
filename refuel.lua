if turtle.getFuelLevel()==0 then
    turtle.digUp() --make space for enderchests
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
    print(turtle.getFuelLevel())
end