--[[this file is responsible for getting the corresponding files through pastebin using pastebin get <code> <name>.
This makes updating mulitple files considerably easier]]
shell.run("delete programs/") --remove old files
shell.run("mkdir programs")
shell.run("pastebin get JjRjXtFx programs/globalVars")
shell.run("pastebin get Kr8ZnHsP programs/checkFuel")
shell.run("pastebin get JHfcc6z0 programs/getOrientation")
shell.run("pastebin get kyPga1Ft programs/moveTo")
shell.run("pastebin get UmEW50gL programs/invDump")

require("globals")

rednet.open("right") -- open the wireless modem for communication
 while true do -- puts turtle into a waitloop for a message
    HEADING = shell.run("programs/getOrientation")
    local id,message = rednet.receive()
    command = {}
    for word in message:gmatch("%w+") do table.insert(command, word) end
    if command[1]=="exit" then
        break
    elseif command[1] =="dump" then
        shell.run("programs/invDump ".. tostring(FIRST_FREE_SLOT))
    elseif command[1]=="checkFuel" then
        shell.run("programs/checkFuel")
    elseif command[1]=="moveTo" then
        shell.run("programs/"..message)
    end
end

