require("globals")
turnAround()
while (turtle.detect()) do --makes space for chests even if it has to dig mulitiple blocks
    turtle.dig() 
end
turtle.select(3)
turtle.place()
for i=TOTAL_SLOTS,arg[2],-1 do
    turtle.select(i)
    turtle.drop()
end
turtle.select(3)
turtle.dig()
turnAround()