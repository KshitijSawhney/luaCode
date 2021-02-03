--[[this file is responsible for getting the corresponding files through pastebin using pastebin get <code> <name>.
This makes updating mulitple files considerably easier]]
shell.run("delete programs/") --remove old files
shell.run("mkdir programs")
shell.run("pastebin get <code> programs/globals")
shell.run("pastebin get <code> programs/checkFuel")
shell.run("pastebin get <code> programs/getOrientation")
shell.run("pastebin get <code> programs/moveTo")

require("globals")

rednet.open("right") -- open the wireless modem for communication
 while true do -- puts turtle into a waitloop for a message
    HEADING = shell.run("getOrientation")
    local id,message = rednet.receive()
    command = {}
    for word in message:gmatch("%w+") do table.insert(command, word) end
    if command[1]=="exit" then
        break
    elseif command[1] =="dump" then
        shell.run("invDump "+ tostring(FIRST_FREE_SLOT))
    elseif command[1]=="checkFuel" then
        shell.run("checkFuel")
    elseif command[1]=="moveTo" then
        shell.run(message)
    end
end

